docker run -p 3306:3306 --name $1 -e MYSQL_ROOT_PASSWORD=$2 -d mysql:latest
