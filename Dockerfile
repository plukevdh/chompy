FROM ruby:2.2.3

ENV APP_DIR=/chompy

RUN mkdir $APP_DIR
WORKDIR $APP_DIR

COPY Gemfile* $APP_DIR/
RUN bundle install --without development test

ADD . $APP_DIR/

CMD bundle exec puma -C config/puma.rb
