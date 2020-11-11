service nginx start
service mysql start
service php7.3-fpm start

# Configure a wordpress database
echo "CREATE DATABASE wpdb;"| mysql -u root --skip-password
echo "CREATE USER 'test'@'localhost' identified by 'password';"| mysql -u root --skip-password
echo "GRANT ALL PRIVILEGES ON wpdb.* TO 'test'@'localhost';"| mysql -u root --skip-password
echo "FLUSH PRIVILEGES;"| mysql -u root --skip-password
echo 'creating database is done'

bash