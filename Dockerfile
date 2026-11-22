
# ==========================================
# STAGE 1: BUILD THE WEBSITE
# ==========================================

# Use Node.js 22 Alpine as the builder image
FROM node:22-alpine AS builder

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json first
# This helps Docker reuse the dependency installation layer
COPY package*.json ./

# Install the exact dependencies listed in package-lock.json
RUN npm ci

# Copy website HTML files into the container
COPY src/ ./src/

# Copy the shared CSS stylesheet into the container
COPY styles/ ./styles/

# Build all HTML pages using Parcel into the dist folder
RUN npm run build


# ==========================================
# STAGE 2: SERVE THE WEBSITE USING NGINX
# ==========================================

# Use Nginx Alpine as the final runtime image
FROM nginx:1.27-alpine

# Copy only the generated website from the builder stage
COPY --from=builder /app/dist /usr/share/nginx/html

# Expose port 80 for HTTP traffic
EXPOSE 80

# Keep Nginx running in the foreground
CMD ["nginx", "-g", "daemon off;"]
