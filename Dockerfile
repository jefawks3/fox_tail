FROM ruby:3.2 as build

ARG PORT=80
ARG APP_ROOT="/app"
ARG NVM_VERSION="v0.39.3"
ARG NVM_DIR="/usr/local/nvm"
ARG NODE_VERSION="v20.1.0"
ARG YARN_VERSION="v1.22.19"

ENV RAILS_ENV=production
ENV NODE_ENV=development
ENV APP_ROOT $APP_ROOT
ENV BUNDLE_APP_CONFIG=$APP_ROOT/.bundle

# Install Packages
RUN apt-get update -qq && \
  apt-get install -y --no-install-recommends \
  build-essential \
  default-jre \
  curl \
  bash \
  libxml2-dev \
  libxslt-dev && \
  apt-get clean && \
  rm --recursive --force /var/lib/apt/lists/*

# Install NVM
RUN mkdir -p $NVM_DIR
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/$NVM_VERSION/install.sh | bash
RUN /bin/bash -c "source $NVM_DIR/nvm.sh && nvm install $NODE_VERSION && nvm use --delete-prefix $NODE_VERSION"
ENV NODE_PATH $NVM_DIR/versions/node/$NODE_VERSION/bin
ENV PATH $NODE_PATH:$PATH
RUN npm -v
RUN node -v

# Install Yarn
RUN npm install --global yarn@$YARN_VERSION
RUN yarn -v

# Create working directory
RUN mkdir -p $APP_ROOT
WORKDIR $APP_ROOT

# Copy files for installing packages
COPY . .

# Install Ruby Packages
RUN bundle config set --local path $BUNDLE_APP_CONFIG
RUN bundle config --local build.nokogiri --use-system-libraries
RUN gem install bundler
RUN bundle install --jobs 4 --retry 3

# Install Node Packages
Run yarn install

# Build assests
RUN bin/rails assets:precompile

# Clean up
RUN rm -rf node_modules tmp logs test/dummy/tmp test/dummy/logs

FROM ruby:3.2

ARG PORT=80
ARG APP_ROOT="/app"

ENV RAILS_ENV=production
ENV APP_ROOT $APP_ROOT
ENV APP_PORT $PORT
ENV BUNDLE_APP_CONFIG=$APP_ROOT/.bundle

RUN apt-get update -qq && \
  apt-get install -y --no-install-recommends \
  build-essential \
  libxml2-dev \
  libxslt-dev && \
  apt-get clean && \
  rm --recursive --force /var/lib/apt/lists/*

WORKDIR $APP_ROOT

COPY --from=build $APP_ROOT $APP_ROOT

EXPOSE $PORT

CMD bin/rails server -b 0.0.0.0 -p ${APP_PORT}
