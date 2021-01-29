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

COPY . .

EXPOSE 3000

CMD ["node","index.js"]
