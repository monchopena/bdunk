FROM ruby:2.6.8-slim as builder

# For building native extensions
RUN apt-get update
RUN apt-get install build-essential -y

# Required bundler version for gems
ENV BUNDLER_VERSION='2.2.17'
RUN gem install bundler:${BUNDLER_VERSION}

# Prevent Gemfile to be modified since Gemfile.lock
RUN bundle config --global frozen 1

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

RUN bundle exec jekyll build

FROM nginx
COPY --from=builder /usr/src/app/_site /usr/share/nginx/html