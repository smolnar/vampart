FROM ruby:2.3.1

RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

COPY Gemfile Gemfile.lock ./

RUN bundle install
COPY . .

CMD rails server -b 0.0
