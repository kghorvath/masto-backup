#!/bin/bash

mkdir -p /temp/mastodon
CURDATE="mastodon-`date +'%Y%m%d'`"
DEST="backupserver.tld"
DB_CONTAINER="mastodon-db"
VOLUME="/containers/mastodon"
DEST_VOLUME="/pool/backup/mastodon"

echo "Backing up database..."
podman exec ${_DB_CONTAINER} pg_dumpall -U mastodon | gzip > /temp/mastodon/postgres.sql.gz
echo "Backing up account headers..."
tar -czf /temp/mastodon/accounts.tar.gz ${VOLUME}/pubsys/accounts
echo "Backing up media attachments..."
tar -czf /temp/mastodon/attachments.tar.gz ${VOLUME}/pubsys/media_attachments
echo "Compressing..."
tar -czf /temp/mastodon/${CURDATE}.tar.gz /temp/mastodon/*
echo "Uploading to server..."
scp /temp/mastodon/${CURDATE}.tar.gz root@${DEST}:${DEST_VOLUME}
echo "Cleaning up..."
rm -rf /temp/mastodon/*


