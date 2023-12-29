ARG RUBY_VERSION=3.2.2
FROM public.ecr.aws/docker/library/ruby:$RUBY_VERSION-alpine

# Install system dependencies
RUN apk add --no-cache --update \
    build-base \
    docker-cli \
    docker-cli-buildx \
    docker-cli-compose \
    docker-credential-ecr-login \
    aws-cli

RUN gem update --system --no-document \
    && gem install bundler \
    && bundle config set --local without development

WORKDIR /orchestra

# Copy the Gemfile, Gemfile.lock into the container
COPY Gemfile Gemfile.lock orchestra.gemspec ./

# Required in orchestra.gemspec
COPY lib/orchestra/version.rb /orchestra/lib/orchestra/version.rb

# Install gems
RUN bundle install

# Copy the rest of our application code into the container.
# We do this after bundle install, to avoid having to run bundle
# every time we do small fixes in the source code.
COPY . .

# Install the gem locally from the project folder
RUN gem build orchestra.gemspec && \
    gem install ./orchestra-*.gem --no-document

CMD ["orchestra"]
