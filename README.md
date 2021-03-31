ft_server 

🔎 Objective
Installing a complete web server using docker
The server run multiple services(Wordpress, phpMyAdmin, SQL database)
SSL protocol is used
autoindex must be added in nginx config file


🔎 Commands


First, build an image : docker build -t ft_server .
And then run : docker run -it --rm -p 80:80 -p 443:443 ft_server
