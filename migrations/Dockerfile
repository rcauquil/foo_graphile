FROM node:alpine

RUN mkdir /migrate
WORKDIR /migrate

RUN npm install -g graphile-migrate
COPY ./.gmrc ./.gmrc
COPY ./migrations ./migrations

CMD ["graphile-migrate", "migrate"]
