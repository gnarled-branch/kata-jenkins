#define build-test stage - docker multistage pipeline

FROM node:12 as build-test          

#create app directory
WORKDIR /app

#install dependencies
COPY package*.json ./

RUN npm install

COPY . .

RUN npm test

FROM build-test as security-scan

RUN apk add curl \
    && curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/master/contrib/install.sh | sh -s -- -b /usr/local/bin \
    && trivy filesystem --exit-code 1 --no-progress /


# run lean image
FROM node:12-alpine as run    

#create app directory
WORKDIR /app

#install dependencies
COPY package*.json ./

RUN npm install

COPY . .

EXPOSE 3000

CMD ["node","index.js"]
