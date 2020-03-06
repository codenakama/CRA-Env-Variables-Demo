FROM node:10-alpine as builder

RUN echo "http://dl-4.alpinelinux.org/alpine/v3.6/main" >> /etc/apk/repositories && \
  apk add --update git && \
  rm -rf /var/cache/apk/*

# ADD virtual build dependencies
RUN apk --no-cache add --virtual native-deps \
  git jq curl

# Add Node app config
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

#Copy in Node app
COPY ./ .


# Install Node app dependancies
RUN yarn

RUN yarn build

# Remove virtual build dependencies
RUN apk del native-deps

# COPY start-up /start-up

# STAGE 2 - Deploy the build artifacts to an nginx prod container
FROM nginx:1.17.5-alpine

COPY --from=builder /usr/src/app/build /usr/share/nginx/html/

# COPY nginx/root/etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf

WORKDIR /usr/share/nginx/html

COPY ./scripts/build-env.sh .

RUN apk add --no-cache bash

RUN chmod +x build-env.sh

EXPOSE 80

ENV REACT_APP_BUILD_NUMBER=1                                                                                                       

CMD ["/bin/bash", "-c", "/usr/share/nginx/html/build-env.sh && nginx -g \"daemon off;\""]
