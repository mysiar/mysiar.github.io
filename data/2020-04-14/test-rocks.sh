#!/usr/bin/env bash

curl --request POST \
   --url http://127.0.0.1:3333/.well-known/mercure \
   --header 'authorization: Bearer JWT_TOKEN' \
   --header 'content-type: application/x-www-form-urlencoded' \
   --data topic=test \
   --data 'data={
 	"headline": "Hello there this is Mercure.Rocks"
 }'
