# Use an official Nginx image as the base
FROM nginx:latest

# Copy custom Nginx configuration file
COPY nginx/nginx.conf /etc/nginx/nginx.conf

# Expose ports 80 and 443 for HTTP and HTTPS
EXPOSE 80
EXPOSE 443

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
