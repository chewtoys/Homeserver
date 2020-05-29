#!/usr/bin/env bash

notify() {
  local title="$1"
  local body="$2"

  curl "https://${GOTIFY_URL}/message?token=${GOTIFY_API_KEY}" -F "title=${title}" -F "message=${body}"
}

array_contains () {
  local e match="$1"
  shift
  for e; do [[ "$e" == "$match" ]] && return 0; done
  return 1
}