#define build-test stage - docker multistage pipeline

FROM node:12 as build-test          

#create app directory
WORKDIR /app

#install dependencies
COPY package*.json ./

RUN npm install

COPY . .

RUN npm test


# run lean image
FROM node:12-alpine as run    

#create app directory
WORKDIR /app

#install dependencies
COPY package*.json ./

RUN npm install

COPY *.js ./


FROM run as security-scan

RUN apk add curl && curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/master/contrib/install.sh | sh -s -- -b /usr/local/bin \
    && trivy fs --severity HIGH,CRITICAL,MEDIUM --exit-code 1 --no-progress /


FROM run

EXPOSE 3000

CMD ["node","index.js"]
