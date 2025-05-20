# syntax=docker/dockerfile:1
# Use slim Ruby image
ARG RUBY_VERSION=3.3.8
FROM ruby:$RUBY_VERSION-slim AS base

# Set working directory
WORKDIR /rails

# Install base OS packages
RUN apt-get update -qq && \
    DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
    curl \
    libjemalloc2 \
    libvips \
    postgresql-client \
    openssl && \
    rm -rf /var/lib/apt/lists/*

# Set environment variables
ENV RAILS_ENV=development \
    BUNDLE_DEPLOYMENT=1 \
    BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_WITHOUT=""

# ---- Build stage ----
FROM base AS build

# Install build tools and dependencies
RUN apt-get update -qq && \
    DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
    build-essential \
    git \
    libpq-dev \
    libyaml-dev \
    pkg-config \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy Gemfiles and install dependencies
COPY Gemfile Gemfile.lock ./
RUN bundle install --jobs 4 --retry 3 && \
    rm -rf ~/.bundle /usr/local/bundle/ruby/*/cache /usr/local/bundle/ruby/*/bundler/gems/*/.git

# Copy application code
COPY . .

# Precompile Bootsnap cache
RUN bundle exec bootsnap precompile --gemfile && \
    bundle exec bootsnap precompile app/ lib/

# Normalize bin files
RUN chmod +x bin/* && \
    sed -i "s/\r$//g" bin/* && \
    sed -i 's/ruby\.exe$/ruby/' bin/*

# ---- Final runtime stage ----
FROM base

# Copy compiled bundle and app code
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails

# Create non-root user
RUN groupadd --system --gid 1000 rails && \
    useradd --system --uid 1000 --gid 1000 --create-home --shell /bin/bash rails && \
    chown -R rails:rails /rails/db /rails/log /rails/tmp /rails/storage

USER rails:rails

# Entrypoint script for DB setup (optional)
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Port and default command
EXPOSE 80
CMD ["./bin/thrust", "./bin/rails", "server", "-b", "0.0.0.0"]
