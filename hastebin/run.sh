#!/bin/sh

set -xe

cd /hastebin/haste-server-master || exit

echo '
{
  "host": "0.0.0.0",
  "port": 7777,
  "keyLength": 6,
  "maxLength": 400000,
  "staticMaxAge": 86400,
  "recompressStaticAssets": true,
  "logging": [
    {
      "level": "verbose",
      "type": "Console",
      "colorize": true
    }
  ],
  "keyGenerator": {
    "type": "random"
  },
  "rateLimits": {
    "categories": {
      "normal": {
        "totalRequests": 500,
        "every": 60000
      }
    }
  },
  "documents": {
    "about": "./about.md"
  },
' > config.js

if [ "$STORAGE_TYPE" = "file" ]
then
    echo '
        "storage": {
          "path": "/hastebin/data",
          "type": "file"
        }
    ' >> config.js
fi

if [ "$STORAGE_TYPE" = "redis" ]
then
    echo '
      "storage": {
        "type": "redis",
        "host": "'"${REDIS_HOST}"'",
        "port": 6379,
        "db": 2,
        "expire": 2592000
      }
    ' >> config.js
fi

echo '}' >> config.js

su-exec $UID:$GID npm start
