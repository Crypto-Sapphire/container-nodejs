#!/usr/bin/env bash
cd "$(dirname $0)";

yellow='\e[33m'
green='\e[32m'
clear='\e[0m'

for input in index.coffee src{/**,}/*.coffee
do
    output="$(sed 's/\.coffee$/\.js/' <<< "${input}")"

    echo -e "${yellow}>${clear} ${green}${input}${clear} to ${green}${output}${clear}";
    coffee -to "${output}" "${input}"
done
