FROM ruby:3.0.2-slim AS dev

EXPOSE 3000

WORKDIR /app

RUN useradd -m -u 1000 localuser

RUN apt update && \
    apt install -y --no-install-recommends sqlite3 curl make build-essential libsqlite3-dev && \
    apt clean

CMD ["bash", "/app/run/dev.sh"]

COPY ["Gemfile", "Gemfile.lock", "/app/"]

RUN bundle install
