FROM node:22-slim AS builder

WORKDIR /app

# Install system dependencies (needed for Prisma + OpenSSL)
RUN apt-get update && apt-get install -y openssl

COPY package*.json ./
RUN npm install

COPY . .

# Generate Prisma client
RUN npx prisma generate

RUN npm run build

FROM node:22-slim

WORKDIR /app

# Install OpenSSL again (for runtime Prisma engine)
RUN apt-get update && apt-get install -y openssl

COPY package*.json ./
RUN npm install --omit=dev

COPY --from=builder /app .
ENV PORT=8080
EXPOSE 8080

CMD ["npm", "start"]
