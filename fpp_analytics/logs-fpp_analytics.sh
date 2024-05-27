#!/bin/bash

docker exec fpp-analytics sh -c 'ls -t logs/*.txt | xargs cat | tail -n 50'
