FROM ruby:3.4.7-alpine3.22

RUN apk update && apk upgrade && \
    apk add --no-cache \
        build-base \
        clang \
        gdb \
        bash \
        git \
        libc-dev \
        linux-headers \
        tzdata && \
    rm -rf /var/cache/apk/*

RUN gem update \
    && gem install jekyll bundler \
    && gem cleanup

RUN mkdir /project
WORKDIR /project

EXPOSE 4000

# docker build -t jekyll-dev .
# docker run -it -v %cd%:/project -p 4000:4000 jekyll-dev

# bundle install
# bundle exec jekyll serve --force_polling --port=4000 --host=0.0.0.0
# bundle exec jekyll serve --force_polling --port=4000 --host=0.0.0.0 --draft
