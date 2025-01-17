# ruby 3.3.5
FROM ruby:3.3.5

# set workdir    
WORKDIR /app

# Update and install prerequesites, create app folder for workdir
RUN apt-get update -qq && apt-get install -y \
    build-essential \
    libpq-dev \
    nodejs \
    yarn \
    wget \
    unzip \
    libnss3 \
    libxss1 \
    libgconf-2-4 \
    libappindicator3-1 \
    fonts-liberation \
    libasound2 \
    libgbm-dev \
    libatk-bridge2.0-0 \
    xdg-utils \
    libgtk-3-0 \
    chromium \
    chromium-driver

#updates rubygems
RUN gem update --system

#copy local gemfiles into container workdir
COPY Gemfile* /app/

#installs gems from gemfiles
RUN bundle update --bundler && bundle install

#bash for installing rails
CMD bash