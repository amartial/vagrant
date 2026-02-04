sudo apt update
sudo apt install curl gpg -y

curl -fsS https://www.pgadmin.org/static/packages_pgadmin_org.pub | sudo gpg --dearmor -o /usr/share/keyrings/packages-pgadmin-org.gpg

sudo sh -c 'echo "deb [signed-by=/usr/share/keyrings/packages-pgadmin-org.gpg] https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/$(lsb_release -cs) pgadmin4 main" > /etc/apt/sources.list.d/pgadmin4.list && apt update'
sudo apt install pgadmin4-web pgadmin4-server postgresql-client -y

export PGADMIN_SETUP_EMAIL="test@test.com"
export PGADMIN_SETUP_PASSWORD="Password1234!"

sudo --preserve-env=PGADMIN_SETUP_EMAIL,PGADMIN_SETUP_PASSWORD /usr/pgadmin4/bin/setup-web.sh --yes
