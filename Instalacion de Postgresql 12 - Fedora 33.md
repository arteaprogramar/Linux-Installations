
sudo dnf install -y https://download.postgresql.org/pub/repos/yum/reporpms/F-33-x86_64/pgdg-fedora-repo-latest.noarch.rpm
sudo dnf install -y postgresql12-server
sudo /usr/pgsql-12/bin/postgresql-12-setup initdb
sudo systemctl enable postgresql-12
sudo systemctl start postgresql-12


