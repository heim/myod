#! /bin/bash

echo "Installing SL"
apt-get update
apt install -y sl

cat << END > /etc/my-app/app.properties
${app_properties}
END

echo "Marking as finished"
touch /tmp/finished
