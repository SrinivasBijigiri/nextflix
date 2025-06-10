# Stage 1: Build phase
FROM node:18 as builder
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# Stage 2: Run phase
FROM node:18-alpine
WORKDIR /usr/src/app

# Copy only necessary files from builder
COPY --from=builder /usr/src/app/node_modules ./node_modules
COPY --from=builder /usr/src/app/public ./public
COPY --from=builder /usr/src/app/.next ./.next
COPY --from=builder /usr/src/app/next.config.js ./
COPY --from=builder /usr/src/app/package*.json ./

# Set runtime environment variables
ENV NODE_ENV=production
ENV NODE_OPTIONS=--openssl-legacy-provider
ARG API_KEY
ENV TMDB_KEY=${API_KEY}

EXPOSE 3000

CMD ["npm", "start"]
