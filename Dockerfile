#  ----- FIRST STAGE -----
FROM node:18 AS builder

ENV NODE_ENV=production
WORKDIR /app

# COPY package*.json /app/
# COPY src /app/src
COPY . /app
# RUN ls /app/client
RUN npm ci --production
# RUN npm install --prefix client
RUN npm ci --production --prefix client
RUN npm run build --prefix client
RUN rm -rf client/node_modules


#  ----- SECOND STAGE -----
FROM node:18-alpine

ENV NODE_ENV=production
WORKDIR /app

EXPOSE 5000
#RUN npm i -g nodemon
COPY --from=builder /app /app/
USER node

CMD ["npm", "start"]
