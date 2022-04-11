#!/bin/bash

set -euxo pipefail

curl 'localhost:8888/hue/accounts/login?next=/' -c /tmp/login.cookies
csrf_token=$(sed -n -e '/.*csrftoken.*/s/.*csrftoken\t//p' /tmp/login.cookies)
curl -H 'Content-Type: application/x-www-form-urlencoded' -H 'Referer: http://localhost:8888/accounts/login?next=/' \
  "localhost:8888/hue/accounts/login?username=admin&password=admin&csrfmiddlewaretoken=${csrf_token}&next=/" \
  -b /tmp/login.cookies
curl 'localhost:8888/desktop/api2/get_config/' -b /tmp/auth.cookies
curl -s 'localhost:8888/desktop/api2/get_config/' -b /tmp/auth.cookies | grep -q '"dialect": "hive"'
