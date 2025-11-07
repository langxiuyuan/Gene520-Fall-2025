#!/bin/bash


name=$1

echo cis is `cat anchor_loop.$name |awk '{s+=$3}END{print s/2}'` >> stat
echo trans is `cat anchor_loop.trans |awk '{s+=$3}END{print s/2}'` >> stat
echo 2M is `cat end_loop.2M.rmbl |awk '{s+=$3}END{print s/2}'` >> stat


wait
