# syntax = docker/dockerfile:1

ARG RUBY_VERSION=3.2.2
FROM public.ecr.aws/docker/library/ruby:$RUBY_VERSION-alpine as base

# Update gems
RUN gem update --system --no-document


# Throw-away build stage to reduce size of final image
FROM base as build

# Install packages needed to build gems
RUN apk add --no-cache --update build-base

# Install and configure bundler
RUN gem install -N bundler -v 2.4.22 && \
    bundle config set --local without development

WORKDIR /orchestra-build

# Copy the Gemfile, Gemfile.lock into the container
COPY Gemfile Gemfile.lock orchestra.gemspec ./

# Required in orchestra.gemspec
COPY lib/orchestra/version.rb ./lib/orchestra/version.rb

# Install gems
RUN bundle install

# Copy the rest of our application code into the container.
# We do this after bundle install, to avoid having to run bundle
# every time we do small fixes in the source code.
COPY --link . .

# Install the gem locally from the project folder
RUN gem build orchestra.gemspec && \
    gem install ./orchestra-*.gem --no-document


# Final stage for app image
FROM base

# Install Orchestra runtime dependencies
RUN apk add --no-cache --update \
    docker-cli \
    docker-cli-buildx \
    docker-cli-compose \
    docker-credential-ecr-login \
    aws-cli \
    git

RUN git config --global credential.helper '!aws codecommit credential-helper $@' && \
    git config --global credential.UseHttpPath true

# Copy built artifacts
COPY --link --from=build /usr/local/bundle /usr/local/bundle
COPY --link --from=build /orchestra-build/bin/envirobly-git-checkout-commit /usr/bin/envirobly-git-checkout-commit

CMD ["orchestra"]
