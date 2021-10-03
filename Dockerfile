FROM ruby:3.0.2 AS dev

EXPOSE 3000

WORKDIR /app

RUN useradd -m -u 1000 localuser && \
    su localuser -c "bundle config path \"vendor/bundle\""

RUN apt update && \
    apt install -y --no-install-recommends make build-essential libpq-dev iputils-ping curl && \
    apt clean


CMD ["bash", "/app/run/dev.sh"]
