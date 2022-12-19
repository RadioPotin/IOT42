FROM node:lts-alpine

WORKDIR /app

COPY ./app/package.json /app/package.json

RUN npm update && \
    npm install

COPY ./app /app

ENV NODE_ENV=production

EXPOSE 80
CMD ["npm", "start"]