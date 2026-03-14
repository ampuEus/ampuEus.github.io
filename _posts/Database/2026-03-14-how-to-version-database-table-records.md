---
title: How to Implement Row-Level Versioning and History Tracking in SQL Tables
description: Learn how to implement row-level data versioning and history tracking in any SQL database using triggers, history tables, and snapshot functions.
# author:
# authors:
date: 2026-03-14 13:43:29 +0100
# last_modified_at: 2026-03-14 13:43:29 +0100
categories: [Programming, Databases]
tags: [how to, databases modeling, sql]  # TAG names should always be lowercase
toc: true  # (Table of Contents) The default value is on _config.yml
pin: false
math: false
mermaid: false
comments: false
image:
  path: /assets/img/database/versioning/data_versioning_flow_schema.svg
  # lqip:
  alt: Data versioning schema
---

## Table of contents

- [Table of contents](#table-of-contents)
- [Tutorial development environment](#tutorial-development-environment)
- [Disclaimer: Data versioning and database versioning are not the same](#disclaimer-data-versioning-and-database-versioning-are-not-the-same)
- [One simple table](#one-simple-table)
  - [Step 1: Create main table](#step-1-create-main-table)
  - [Step 2: Create its historic table copy](#step-2-create-its-historic-table-copy)
  - [Step 3: Create log function and add triggers](#step-3-create-log-function-and-add-triggers)
  - [Step 4: Modify table items and check changes on historical table](#step-4-modify-table-items-and-check-changes-on-historical-table)
  - [Step 5: \[Optional\] Implement time snapshot function](#step-5-optional-implement-time-snapshot-function)
- [Two interrelated tables](#two-interrelated-tables)
  - [Step 1: Create new main table, their relationships and populate it](#step-1-create-new-main-table-their-relationships-and-populate-it)
  - [Step 2: Create historic table copies](#step-2-create-historic-table-copies)
  - [Step 3: Add log functions and triggers](#step-3-add-log-functions-and-triggers)
  - [Step 4: Modify tables items and check changes on historical tables](#step-4-modify-tables-items-and-check-changes-on-historical-tables)
  - [Step 5: \[Optional\] Implement new table on snapshot function](#step-5-optional-implement-new-table-on-snapshot-function)

## Tutorial development environment

>The tutorial database is PostgreSQL.
{: .prompt-info }

To make the tutorial easy I am going to execute all queries **online** on [PGTutorial online playground](https://www.pgtutorial.com/playground/).

But you can use on **local** environment using [PostgreSQL directly](https://www.postgresql.org/download/){:target="_blank"} or [PostgreSQL docker image](https://hub.docker.com/_/postgres/){:target="_blank"} with [pgAdmin](https://www.pgadmin.org/){:target="_blank"} or `PSQL` terminal.

This is the docker container that I use for the example:

```shell
docker run --name history-demo-postgres \
    -e POSTGRES_USER=postgres \
    -e POSTGRES_PASSWORD=postgres123 \
    -p 5432:5432 \
    -d postgres:18.0-alpine3.22
```

>I use [pgModeler](https://pgmodeler.io/){:target="_blank"} to model this demo database. Here you have both files: [one table versioning](/assets/file/database/versioning/one-table-versioning-model.dbm){:target="_blank"} and [two table versioning](/assets/file/database/versioning/two-related-table-versioning-model.dbm){:target="_blank"}
{: .prompt-tip }

## Disclaimer: Data versioning and database versioning are not the same

On this tutorial I explain how to implement data versioning in a database, no a database versioning.

**Data versioning tracks changes to the records inside tables** (row-level history, old values, timestamps, etc.). It helps recover or inspect how the data looked at a specific moment in time.
*Example:* Keeping a history of product prices or inventory levels.

**Database versioning tracks changes to the database schema or structure** (tables, columns, relationships, stored procedures, etc.).
*Example:* Applying migrations to add a new column named status to a table.

## One simple table

This is the basic versioning model that you are going to create:

![pgModeler demo schema](/assets/img/database/versioning/one-table-versioning-light.svg){: .light}
![pgModeler demo schema](/assets/img/database/versioning/one-table-versioning-dark.svg){: .dark}

### Step 1: Create main table

```sql
CREATE TABLE product_inventory (
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY ,
    name varchar(100) NOT NULL,
    quantity integer NOT NULL,
    valid_from timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    valid_to timestamp DEFAULT NULL,
    CONSTRAINT product_inventory_pk PRIMARY KEY (id)
);
```

And populate it:

```sql
INSERT INTO product_inventory (name, quantity)
VALUES
    ('Laptop Pro 15"', 111),
    ('Car', 22);
```

this is the actual state of the table:

```sql
SELECT * FROM product_inventory;
```

Output:

```text
+----+----------------+----------+----------------------------+----------+
| id |      name      | quantity |         valid_from         | valid_to |
+----+----------------+----------+----------------------------+----------+
| 1  | Laptop Pro 15" | 111      | 2025-10-10 10:33:10.957000 | NULL     |
+----+----------------+----------+----------------------------+----------+
| 2  | Car            | 22       | 2025-10-10 10:33:10.957000 | NULL     |
+----+----------------+----------+----------------------------+----------+
```

### Step 2: Create its historic table copy

```sql
CREATE TABLE product_inventory_history (
    LIKE product_inventory
);
```

### Step 3: Create log function and add triggers

Now you need to create a function to log old items on history table:

```sql
CREATE FUNCTION log_product_inventory_changes ()
    RETURNS trigger
    LANGUAGE plpgsql
    VOLATILE
    CALLED ON NULL INPUT
    SECURITY INVOKER
    PARALLEL UNSAFE
    COST 1
    AS $$
BEGIN
    INSERT INTO product_inventory_history (
        id,
        name,
        quantity,
        valid_from,
        valid_to
    )
    VALUES (
        OLD.id,
        OLD.name,
        OLD.quantity,
        OLD.valid_from,
        CURRENT_TIMESTAMP
    );

    IF TG_OP = 'UPDATE' THEN
        NEW.valid_from := CURRENT_TIMESTAMP;
        NEW.valid_to := NULL;
        RETURN NEW;
    END IF;

    RETURN OLD;
END;
$$;
```

Now to automatically call `log_product_inventory_changes()` you need to add triggers on main table:

```sql
-- Triggers for UPDATE action. When a tables's item is added or modified.
CREATE TRIGGER product_inventory_update
    BEFORE UPDATE
    ON product_inventory
    FOR EACH ROW
    EXECUTE PROCEDURE log_product_inventory_changes();

-- Triggers for DELETE action. When a table's item is removed.
CREATE TRIGGER product_inventory_delete
    BEFORE DELETE
    ON product_inventory
    FOR EACH ROW
    EXECUTE PROCEDURE log_product_inventory_changes();
```

### Step 4: Modify table items and check changes on historical table

In my case I change `Car` item `quantity` from 22 to 5:

```sql
UPDATE product_inventory
SET
    quantity = 5
WHERE id = 2;
```

Check if it's updated on main table:

```sql
SELECT * FROM product_inventory;
```

Output:

```text
+----+----------------+----------+----------------------------+----------+
| id |      name      | quantity |         valid_from         | valid_to |
+----+----------------+----------+----------------------------+----------+
| 1  | Laptop Pro 15" | 111      | 2025-10-10 10:33:10.957000 | NULL     |
+----+----------------+----------+----------------------------+----------+
| 2  | Car            | 5        | 2025-10-10 10:45:52.118000 | NULL     |
+----+----------------+----------+----------------------------+----------+
```

And if the old item is stored on historic table:

```sql
SELECT * FROM product_inventory_history;
```

Output:

```text
+----+------+----------+----------------------------+----------------------------+
| id | name | quantity |         valid_from         |          valid_to          |
+----+------+----------+----------------------------+----------------------------+
| 2  | Car  | 22       | 2025-10-10 10:33:10.957000 | 2025-10-10 10:45:52.118000 |
+----+------+----------+----------------------------+----------------------------+
```

### Step 5: [Optional] Implement time snapshot function

With this function you'll get a view of the database on a specific time:

```sql
CREATE FUNCTION snapshot_inventory_at (target_ts timestamp)
    RETURNS TABLE (product_id integer, product_name varchar, quantity integer, snapshot_time timestamp)
    LANGUAGE sql
    VOLATILE
    CALLED ON NULL INPUT
    SECURITY INVOKER
    PARALLEL RESTRICTED
    COST 1
    AS $$

-- Product state at the given timestamp
WITH product AS (
    SELECT *
    FROM product_inventory
    WHERE target_ts BETWEEN valid_from AND COALESCE(valid_to, CURRENT_TIMESTAMP)

    UNION ALL

    SELECT *
    FROM product_inventory_history
    WHERE target_ts BETWEEN valid_from AND valid_to
)

-- Output table snapshots
SELECT
    product.id,
    product.name,
    product.quantity,
    target_ts
FROM product
ORDER BY product.id;
$$;
```

To execute it you only need to:

```sql
SELECT * FROM snapshot_inventory_at ('2025-10-10 10:40:00')
```

Output at `2025-10-10 10:40:00` before the update:

```text
+------------+----------------+----------+----------------------------+----------------------------+
| product_id |  product_name  | quantity |        snapshot_time       |          valid_to          |
+------------+----------------+----------+----------------------------+----------------------------+
| 1          | Laptop Pro 15" | 111      | 2025-10-10 10:40:00.000000 | 2025-10-10 10:45:52.118000 |
+------------+----------------+----------+----------------------------+----------------------------+
| 2          | Car            | 22       | 2025-10-10 10:40:00.000000 | NULL                       |
+------------+----------------+----------+----------------------------+----------------------------+
```

Output at `2025-10-10 10:55:00` after the update:

```text
+------------+----------------+----------+----------------------------+----------------------------+
| product_id |  product_name  | quantity |        snapshot_time       |          valid_to          |
+------------+----------------+----------+----------------------------+----------------------------+
| 1          | Laptop Pro 15" | 111      | 2025-10-10 10:55:00.000000 | 2025-10-10 10:45:52.118000 |
+------------+----------------+----------+----------------------------+----------------------------+
| 2          | Car            | 5        | 2025-10-10 10:55:00.000000 | NULL                       |
+------------+----------------+----------+----------------------------+----------------------------+
```

## Two interrelated tables

This is the new model that you are going to create:

![pgModeler demo schema](/assets/img/database/versioning/two-related-table-versioning-light.svg){: .light}
![pgModeler demo schema](/assets/img/database/versioning/two-related-table-versioning-dark.svg){: .dark}

>I'm going to create this new example from zero. If you want you can start from the previous chapter state and implement this new tables and logics.
{: .prompt-warning }

### Step 1: Create new main table, their relationships and populate it

```sql
CREATE TABLE maintenance_tasks (
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY ,
    name varchar(100) NOT NULL,
    description text NOT NULL,
    valid_from timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    valid_to timestamp DEFAULT NULL,
    CONSTRAINT maintenance_tasks_pk PRIMARY KEY (id)
);

CREATE TABLE product_inventory (
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY ,
    name varchar(100) NOT NULL,
    quantity integer NOT NULL,
    valid_from timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    valid_to timestamp DEFAULT NULL,
    id_maintenance_tasks integer,
    CONSTRAINT product_inventory_pk PRIMARY KEY (id)
);

-- Add relationship between them
ALTER TABLE product_inventory ADD CONSTRAINT maintenance_tasks_fk FOREIGN KEY (id_maintenance_tasks)
REFERENCES maintenance_tasks (id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
```

```sql
-- Insert tasks
INSERT INTO maintenance_tasks (name, description)
VALUES
    ('Firmware Update', 'Update device firmware'),
    ('Filter Replacement', 'Replace internal filter'),
    ('Battery Check', 'Inspect and verify battery health');

-- Insert products linked to tasks
INSERT INTO product_inventory (name, quantity, id_maintenance_tasks)
VALUES
    ('Laptop Pro 15"', 111, 1),
    ('Car', 22, 3);
```

Now the tables state is:

```text
+----+--------------------+-----------------------------------+----------------------------+----------+
| id |        name        |            description            |         valid_from         | valid_to |
+----+--------------------+-----------------------------------+----------------------------+----------+
| 1  | Firmware Update    | Update device firmware            | 2025-10-10 14:59:46.744000 | NULL     |
+----+--------------------+-----------------------------------+----------------------------+----------+
| 2  | Filter Replacement | Replace internal filter           | 2025-10-10 14:59:46.744000 | NULL     |
+----+--------------------+-----------------------------------+----------------------------+----------+
| 3  | Battery Check      | Inspect and verify battery health | 2025-10-10 14:59:46.744000 | NULL     |
+----+--------------------+-----------------------------------+----------------------------+----------+
```

```text
+----+----------------+----------+----------------------------+----------+----------------------+
| id |      name      | quantity |         valid_from         | valid_to | id_maintenance_tasks |
+----+----------------+----------+----------------------------+----------+----------------------+
| 1  | Laptop Pro 15" | 111      | 2025-10-10 14:59:46.744000 | NULL     | 1                    |
+----+----------------+----------+----------------------------+----------+----------------------+
| 2  | Car            | 22       | 2025-10-10 14:59:46.744000 | NULL     | 3                    |
+----+----------------+----------+----------------------------+----------+----------------------+
```

### Step 2: Create historic table copies

```sql
CREATE TABLE maintenance_tasks_history (
    LIKE maintenance_tasks
);

CREATE TABLE product_inventory_history (
    LIKE product_inventory
);
```

### Step 3: Add log functions and triggers

```sql
CREATE FUNCTION log_maintenance_task_changes ()
    RETURNS trigger
    LANGUAGE plpgsql
    VOLATILE
    CALLED ON NULL INPUT
    SECURITY INVOKER
    PARALLEL UNSAFE
    COST 1
    AS $$
BEGIN
    INSERT INTO maintenance_tasks_history (
        id,
        name,
        description,
        valid_from,
        valid_to
    )
    VALUES (
        OLD.id,
        OLD.name,
        OLD.description,
        OLD.valid_from,
        CURRENT_TIMESTAMP
    );

    IF TG_OP = 'UPDATE' THEN
        NEW.valid_from := CURRENT_TIMESTAMP;
        NEW.valid_to := NULL;
        RETURN NEW;
    END IF;

    RETURN OLD;
END;
$$;
```

```sql
-- Triggers for UPDATE action for tasks
CREATE TRIGGER maintenance_tasks_update
    BEFORE UPDATE
    ON maintenance_tasks
    FOR EACH ROW
    EXECUTE PROCEDURE log_maintenance_task_changes();

-- Triggers for DELETE action for tasks
CREATE TRIGGER maintenance_tasks_delete
    BEFORE DELETE
    ON maintenance_tasks
    FOR EACH STATEMENT
    EXECUTE PROCEDURE log_maintenance_task_changes();
```

```sql
CREATE FUNCTION log_product_inventory_changes ()
    RETURNS trigger
    LANGUAGE plpgsql
    VOLATILE
    CALLED ON NULL INPUT
    SECURITY INVOKER
    PARALLEL UNSAFE
    COST 1
    AS $$
BEGIN
    INSERT INTO product_inventory_history (
        id,
        name,
        quantity,
        valid_from,
        valid_to
    )
    VALUES (
        OLD.id,
        OLD.name,
        OLD.quantity,
        OLD.valid_from,
        CURRENT_TIMESTAMP
    );

    IF TG_OP = 'UPDATE' THEN
        NEW.valid_from := CURRENT_TIMESTAMP;
        NEW.valid_to := NULL;
        RETURN NEW;
    END IF;

    RETURN OLD;
END;
$$;
```

```sql
-- Triggers for UPDATE action for products
CREATE TRIGGER product_inventory_update
    BEFORE UPDATE
    ON product_inventory
    FOR EACH ROW
    EXECUTE PROCEDURE log_product_inventory_changes();

-- Triggers for DELETE action for products
CREATE TRIGGER product_inventory_delete
    BEFORE DELETE
    ON product_inventory
    FOR EACH ROW
    EXECUTE PROCEDURE log_product_inventory_changes();
```

### Step 4: Modify tables items and check changes on historical tables

```sql
UPDATE product_inventory
SET
    quantity = 5,              -- change quantity
    id_maintenance_tasks = 3   -- change to "Battery Check"
WHERE id = 2;
```

```sql
UPDATE maintenance_tasks
SET
    description = 'Inspect battery health and run capacity test'
WHERE id = 1;
```

`maintenance_tasks` state:

```text
+----+--------------------+----------------------------------------------+----------------------------+----------+----------------------+
| id |        name        |                  description                 |         valid_from         | valid_to | id_maintenance_tasks |
+----+--------------------+----------------------------------------------+----------------------------+----------+----------------------+
| 2  | Filter Replacement | Replace internal filter                      | 2025-10-10 14:59:46.744000 | NULL     | 1                    |
+----+--------------------+----------------------------------------------+----------------------------+----------+----------------------+
| 3  | Battery Check      | Inspect and verify battery health            | 2025-10-10 14:59:46.744000 | NULL     | 3                    |
+----+--------------------+----------------------------------------------+----------------------------+----------+----------------------+
| 1  | Firmware Update    | Inspect battery health and run capacity test | 2025-10-10 15:26:53.952000 | NULL     |                      |
+----+--------------------+----------------------------------------------+----------------------------+----------+----------------------+
```

`maintenance_tasks_history` state:

```text
+----+-----------------+------------------------+----------------------------+----------------------------+
| id |       name      |       description      |         valid_from         |          valid_to          |
+----+-----------------+------------------------+----------------------------+----------------------------+
| 1  | Firmware Update | Update device firmware | 2025-10-10 14:59:46.744000 | 2025-10-10 15:26:53.952000 |
+----+-----------------+------------------------+----------------------------+----------------------------+
```

`product_inventory` state:

```text
+----+----------------+----------+----------------------------+----------+----------------------+
| id |      name      | quantity |         valid_from         | valid_to | id_maintenance_tasks |
+----+----------------+----------+----------------------------+----------+----------------------+
| 1  | Laptop Pro 15" | 111      | 2025-10-10 14:59:46.744000 | NULL     | 1                    |
+----+----------------+----------+----------------------------+----------+----------------------+
| 2  | Car            | 5        | 2025-10-10 15:26:37.865000 | NULL     | 3                    |
+----+----------------+----------+----------------------------+----------+----------------------+
```

`product_inventory_history` state:

```text
+----+------+----------+----------------------------+----------------------------+----------------------+
| id | name | quantity |         valid_from         |          valid_to          | id_maintenance_tasks |
+----+------+----------+----------------------------+----------------------------+----------------------+
| 2  | Car  | 22       | 2025-10-10 14:59:46.744000 | 2025-10-10 15:26:37.865000 | NULL                 |
+----+------+----------+----------------------------+----------------------------+----------------------+
```

### Step 5: [Optional] Implement new table on snapshot function

```sql
CREATE OR REPLACE FUNCTION snapshot_inventory_tasks_at (target_ts timestamp)
    RETURNS TABLE (product_id integer, product_name varchar, quantity integer, task_name varchar, task_description text, snapshot_time timestamp)
    LANGUAGE sql
    VOLATILE
    CALLED ON NULL INPUT
    SECURITY INVOKER
    PARALLEL RESTRICTED
    COST 1
    AS $$
-- Product state at the given timestamp
WITH product AS (
    SELECT *
    FROM public.product_inventory
    WHERE target_ts BETWEEN valid_from AND COALESCE(valid_to, CURRENT_TIMESTAMP)

    UNION ALL

    SELECT *
    FROM public.product_inventory_history
    WHERE target_ts BETWEEN valid_from AND valid_to
),

-- Task state at the given timestamp
task AS (
    SELECT *
    FROM public.maintenance_tasks
    WHERE target_ts BETWEEN valid_from AND COALESCE(valid_to, CURRENT_TIMESTAMP)

    UNION ALL

    SELECT *
    FROM public.maintenance_tasks_history
    WHERE target_ts BETWEEN valid_from AND valid_to
)

-- Join snapshots
SELECT
    p.id,
    p.name,
    p.quantity,
    t.name,
    t.description,
    target_ts
FROM product p
JOIN task t
    ON p.id_maintenance_tasks = t.id
ORDER BY p.id;
$$;
```

```sql
SELECT * FROM snapshot_inventory_tasks_at ('2025-10-10 15:27:00')
```
