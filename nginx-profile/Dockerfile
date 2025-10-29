FROM ubuntu
LABEL version="0.0.1"
RUN apt-get update && apt-get -y install nginx
COPY index.html /var/www/html/
EXPOSE 80
CMD ["nginx","-g", "daemon off;"]
