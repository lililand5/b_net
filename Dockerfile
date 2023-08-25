FROM ruby:3.1.2
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client libpq-dev
WORKDIR /b_net
RUN gem install bundler

COPY Gemfile Gemfile.lock ./

RUN bundle install

COPY . .

CMD ["rails", "server", "-b", "0.0.0.0"]
