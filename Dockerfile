# Dockerfile.dev
ARG RUBY_VERSION=3.2.2
FROM docker.io/library/ruby:$RUBY_VERSION-slim

WORKDIR /rails

# Cài đặt các package cần thiết - THÊM build-essential và các development tools
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    curl \
    build-essential \
    libjemalloc2 \
    libvips \
    libpq-dev \
    postgresql-client \
    nodejs \
    npm \
    pkg-config \
    && rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Set environment variables
ENV BUNDLE_PATH="/gems" \
    BUNDLE_JOBS=4

# Copy Gemfile và cài đặt gems
COPY Gemfile Gemfile.lock ./

# Cài đặt bigdecimal trước
RUN gem install bigdecimal

# Sau đó cài đặt bundle
RUN bundle install

# Copy application code
COPY . .

# Expose port
EXPOSE 3000

# Start server
CMD ["bash", "-c", "rm -f tmp/pids/server.pid && bundle exec rails s -p 3000 -b '0.0.0.0'"]