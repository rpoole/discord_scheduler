FROM ruby:3.0.2

COPY . /bot

WORKDIR /bot

RUN bundle install
RUN apt update && curl -sL https://deb.nodesource.com/setup_14.x | bash - && apt -y install nodejs
RUN npm install -g nodemon
