FROM node:14-alpine as build

ARG COMMIT_SHA=<not-specified>
ENV NODE_ENV=production

WORKDIR /build-dir

COPY package.json .
COPY package-lock.json .

RUN npm ci

COPY . .

RUN echo "service-from-template-1633531321399: $COMMIT_SHA" >> ./commit.sha

########################################################################################################################

FROM node:14-alpine

LABEL maintainer="undefined" \
      name="service-from-template-1633531321399" \
      description="This is the best template to start creating a service in node integrated inside the platform" \
      eu.mia-platform.url="https://www.mia-platform.eu" \
      eu.mia-platform.version="0.1.0"

ENV NODE_ENV=production
ENV LOG_LEVEL=info
ENV SERVICE_PREFIX=/
ENV HTTP_PORT=3000

WORKDIR /home/node/app

COPY --from=build /build-dir ./

USER node

CMD ["npm", "-s", "start", "--", "--port", "${HTTP_PORT}", "--log-level", "${LOG_LEVEL}", "--prefix=${SERVICE_PREFIX}"]
