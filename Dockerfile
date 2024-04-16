# Use official node image as base
FROM node:alpine AS builder

# Set working directory
WORKDIR /app

# Copy package.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

RUN npm run build 

# Use another image for serving the application (slimmer)
FROM httpd:latest

RUN sed -i 's/Listen 80/Listen 3000/g' conf/httpd.conf
# Copy only the build folder
COPY --from=builder /app/build/ htdocs/
# Expose port 3000
EXPOSE 3000
