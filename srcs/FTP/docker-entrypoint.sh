#!/bin/sh
set -e

FTP_USER="ftpuser"
FTP_DIR="/var/www/html"
PASS_FILE="/run/secrets/ftp_password"
CERT_FILE="/run/secrets/certificate"
KEY_FILE="/run/secrets/key"

mkdir -p /etc/vsftpd
cp "$CERT_FILE" /etc/vsftpd/cert.pem
cp "$KEY_FILE"  /etc/vsftpd/key.pem
chmod 600 /etc/vsftpd/cert.pem /etc/vsftpd/key.pem

if ! id "$FTP_USER" > /dev/null 2>&1; then
    adduser -D -h "$FTP_DIR" -s /sbin/nologin "$FTP_USER"
fi
echo "$FTP_USER:$(cat "$PASS_FILE")" | chpasswd

exec vsftpd /etc/vsftpd/vsftpd.conf
