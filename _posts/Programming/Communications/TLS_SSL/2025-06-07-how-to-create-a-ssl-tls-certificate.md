---
title: How to create a SSL/TLS certificate (with OpenSSL)
description: Step by step guide explaining how to generate SSL/TLS certificate with OpenSSL.
# author:
# authors:
date: 2025-06-07 16:34:26 +0100
# last_modified_at: 2025-06-07 16:34:26 +0100
categories: [Programming, Communication]
tags: [how to, ssl, tls, cryptography, cybersecurity, web]  # TAG names should always be lowercase
toc: true  # (Table of Contents) The default value is on _config.yml
pin: false
math: false
mermaid: false
comments: false
image:
  path: /assets/img/cybersecurity/ssl_tls/tls_fake_certificate_key.svg
  # lqip:
  # alt:
---

On this article you will learn a basic management to know **how to create a self-signed certificates and keys**.

> To learn more about SSL/TLS go to this post [How it works - SSL/TLS protocol and certificate](/_posts/Programming/Communications/TLS_SSL/2025-03-08-what-is-ssl-tls-protocol-certificate.md){:target="_blank"}

## Table of contents

- [Table of contents](#table-of-contents)
- [Dependencies](#dependencies)
- [Some file format overview](#some-file-format-overview)
- [Certificates and keys management](#certificates-and-keys-management)
  - [Private key creation](#private-key-creation)
  - [Public key creation](#public-key-creation)
  - [View key content](#view-key-content)
  - [Certificate creation](#certificate-creation)
  - [View certificate content](#view-certificate-content)
- [Certificate Signing Requests (CSRs)](#certificate-signing-requests-csrs)
- [OpenSSL configuration file](#openssl-configuration-file)
- [Tips](#tips)
- [References](#references)
  - [Certificate Authorities](#certificate-authorities)
  - [Useful tools](#useful-tools)

## Dependencies

- A GNU/Linux environment
- openssl toolkit

```shell
sudo apt install openssl
```

## Some file format overview

| Format                | Description                   |
|-----------------------|-------------------------------|
| .csr                  | A Certificate Signing Request |
| .pem                  | A container format that may include the public certificate,<br>or an entire certificate chain including public key, private key and root certificates |
| .der                  | A way to encode ASN.1 syntax in binary, a .pem file is just a Base64 encoded .der file |
| .cert<br>.cer<br>.crt | PEM (or rarely DER) formatted file with a different extension |
| .key                  | PEM formatted file containing just the private-key of a specific<br>certificate and is merely a conventional name and not a standardized one |

## Certificates and keys management

### Private key creation

```shell
openssl genrsa -des3 -out <KEY_FILENAME.key> 4096
```

Where:

- `genrsa` to generate a standard RSA key (other options; ecparam, dsaparam...).
- `-des3` option create a key with DES-3 encrypted password protection (other options; -aes256, -aria128...).
- `-out` to save.
- `4096` to be a 4096-bit key.

### Public key creation

```shell
openssl rsa -in <PRIVATE_KEY_FILENAME.key> -pubout -out <PUBLIC_KEY_FILENAME.key>
```

Where:

- `rsa` it is necessary to know the format of the key, in this case is a RSA key.
- `-in` option to pass in the private key file.
- `-pubout` option specifies that we want to output the public key.
- `-out` option to say where save the public key file.

### View key content

```shell
openssl rsa -noout -text -in <KEY_FILENAME.key>
```

Where:

- `rsa` it is necessary to know the format of the key, in this case is a RSA key.
- `-noout` option to tell it to not output the original base64-encoded value.
- `-text` option to display it in a readable text format.
- `-in` option to pass in the key file.
- Add `-pubin` to view contents of a public key stored in a key file.

### Certificate creation

> You need a private key.
{: .prompt-info }

```shell
openssl req -new -x509 -days 365 -key <KEY_FILENAME.key> -out <CERTIFICATE_FILEMANE.crt>
```

Where:

- `req` creates and processes certificate requests.
- `-new` option to generate a new certificare request.
- `-x509` option to outputs a self signed certificate instead of a certificate request.
- `-days <n>` when the -x509 option is being used, specifies the number of days of validity of the certificate.
- `-key <KEY_FILENAME.key>` specifies the file to read the private key from.

### View certificate content

```shell
openssl x509 -noout -text -in <CERTIFICATE_FILENAME.crt>
```

Where:

- `x509` it is necessary to know the format of the certificate, in this case is a RSA key.
- `-noout` option to tell it to not output the original base64-encoded value.
- `-text` option to display it in a readable text format.
- `-in` option to pass in the key file.

## Certificate Signing Requests (CSRs)

A CSR is what you submit to a Certificate Authority (CA) to apply for a digital identity certificate. It includes your public key and other identity information.

## OpenSSL configuration file

```shell
openssl req -x509 -nodes -sha256 -days 365 -newkey rsa:2048 -keyout key.pem -out cert.pem -config ./certs/openssl.cnf
openssl x509 -outform der -in cert.pem -out certificate.cer
```

An example of a simple openssl.cnf:

```ini
[ req ]
default_bits        = 2048
default_keyfile     = server-key.pem

req_extensions      = req_ext
x509_extensions     = x509_ext # The extensions to add to the self signed cert
string_mask         = utf8only

[ subject ]
countryName                 = Country Name (2 letter code)
countryName_default         = US
stateOrProvinceName         = State or Province Name (full name)
stateOrProvinceName_default = NY
localityName                = Locality Name (eg, city)
localityName_default        = New York
organizationName            = Organization Name (eg, company)
organizationName_default    = Example, LLC
commonName                  = Common Name (e.g. server FQDN or YOUR name)
commonName_default          = Example LLC
emailAddress                = Email Address
emailAddress_default        = test@example.com

[ x509_ext ]
subjectAltName = @alt_names

[ req_ext ]
subjectAltName = @alt_names

[ alt_names ]
DNS.1 = jt_xps
URI.1 = urn:freeopcua:client
```

## Tips

- **This is important**. Back up your certificate and key to external storage.
- Restrict the key’s permissions so that only `root` can access it -> `chmod 400 /root/certs/MyKey.key`.

## References

- <https://www.linode.com/docs/guides/create-a-self-signed-tls-certificate/>{:target="_blank"}
- <https://www.golinuxcloud.com/openssl-view-certificate/>{:target="_blank"}
- [What is a Pem file and how does it differ from other OpenSSL Generated Key File Formats?](https://serverfault.com/a/9717){:target="_blank"}
- [OpenSSL cheatsheet](https://www.golinuxcloud.com/openssl-cheatsheet/){:target="_blank"}
- [OpenSSL Cookbook](https://www.feistyduck.com/library/openssl-cookbook/online/){:target="_blank"}
- <https://jamielinux.com/docs/openssl-certificate-authority/create-the-root-pair.html>{:target="_blank"}

### Certificate Authorities

- [Let's encrypt](https://letsencrypt.org/){:target="_blank"} (it is a free option)

### Useful tools

- [OpenSSL](https://www.openssl.org/){:target="_blank"}
- [LibreSSL](https://www.libressl.org/){:target="_blank"}
- [X509 Certificate Generator](https://certificatetools.com/){:target="_blank"}
- [Mozilla SSL Configuration Generator](https://ssl-config.mozilla.org/#server=nginx&version=1.17.7&config=modern&openssl=1.1.1k&guideline=5.7){:target="_blank"}
- [Country Codes](https://www.ssl.com/country-codes/){:target="_blank"}
