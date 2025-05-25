FROM node:22-slim AS builder

RUN apt-get update -y && apt-get install -y openssl
WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

RUN npm run build

FROM node:22-slim

WORKDIR /app

COPY package*.json ./
RUN npm install --omit=dev

COPY --from=builder /app .
ENV PORT=8080
EXPOSE 8080

CMD ["npm", "start"]
