#TO create auto-signed certificated
#openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/server.key -out /etc/ssl/certs/server.crt

FROM httpd:2.4

EXPOSE 80

EXPOSE 443

COPY server.crt /usr/local/apache2/conf/server.crt

COPY server.key /usr/local/apache2/conf/server.key

COPY httpd.conf /etc/apache2/conf/httpd.conf

COPY ./www /usr/local/apache2/htdocs/

RUN sed -i \
       -e 's/^#\(Include .*httpd-ssl.conf\)/\1/' \
       -e 's/^#\(LoadModule .*mod_ssl.so\)/\1/' \
       -e 's/^#\(LoadModule .*mod_socache_shmcb.so\)/\1/' \
       conf/httpd.conf

CMD apachectl -DFOREGROUND


#TO RUN
# docker build -t server:https .
# docker run -dit --name mywebsite -p 443:443 -p 80:80 server:https
# Visit http://localhost:443
# or http://localhost and you will see It works!