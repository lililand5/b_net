FROM ruby:3.1.2

# Установите зависимости
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client libpq-dev

# Создайте директорию для приложения внутри контейнера
WORKDIR /b_net

# Установите bundler
RUN gem install bundler

# Сначала копируйте Gemfile и Gemfile.lock
COPY Gemfile Gemfile.lock ./

# Теперь установите гемы
RUN bundle install

# Затем копируйте остальные файлы
COPY . .

# Запуск сервера
CMD ["rails", "server", "-b", "0.0.0.0"]
