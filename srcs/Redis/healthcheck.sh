#!/bin/sh
set -e
redis-cli ping
# PONG
redis-cli info server | grep redis_version
