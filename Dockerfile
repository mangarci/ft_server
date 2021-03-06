FROM debian:buster


#Environment variable to turn autoindex on/off
ENV AUTOINDEX on

RUN apt-get update
RUN apt-get install -y nginx mariadb-server php-fpm php-mysql wget

#Copy the nginx's configuration
COPY /srcs/nginx.conf /tmp/ 
COPY /srcs/nginx_autoindexoff.conf /tmp/
COPY /srcs/index.html /var/www/html

#SSL certificates
RUN mkdir ~/mkcert && \
  cd ~/mkcert && \
  wget https://github.com/FiloSottile/mkcert/releases/download/v1.1.2/mkcert-v1.1.2-linux-amd64 && \
  mv mkcert-v1.1.2-linux-amd64 mkcert && \
  chmod +x mkcert && \
./mkcert -install && \
./mkcert localhost
RUN rm var/www/html/index.nginx-debian.html

#Wordpress installation and copy to html
RUN wget https://wordpress.org/latest.tar.gz
RUN tar -xvzf latest.tar.gz && rm -rf latest.tar.gz
RUN mv wordpress /var/www/html
RUN chown -R www-data:www-data /var/www/html/ && chmod -R 755 /var/www/html/
COPY srcs/wp-config.php /var/www/html/wordpress

#phpmyadmin installation and copy to html
RUN wget https://files.phpmyadmin.net/phpMyAdmin/5.0.2/phpMyAdmin-5.0.2-english.tar.gz
RUN tar -xzvf phpMyAdmin-5.0.2-english.tar.gz && rm -rf phpMyAdmin-5.0.2-english.tar.gz
RUN mv phpMyAdmin-5.0.2-english/ /var/www/html/phpmyadmin
COPY srcs/config.inc.php /var/www/html/phpmyadmin

#copy the script and execute
COPY /srcs/*.sh ./

EXPOSE 80 443

CMD bash init.sh