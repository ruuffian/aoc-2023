#!/usr/bin/env bash

function printError() {
  echo "ERROR: ${1}"
  exit 1
}

declare    year="${1}" day="${2}"

[ -z "${year}" ] && printError "Missing year argumenet."
[ -z "${day}" ] && printError "Missing day argument."
declare    url="https://adventofcode.com/${year}/day/${day}/input"

declare    token=""
while read -r token; do
  [ -z "${token}" ] && printError "Missing session token."
  curl -X GET "${url}" --header "Cookie: session=${token}" > "./inputs/${day}.txt"
done < .token
