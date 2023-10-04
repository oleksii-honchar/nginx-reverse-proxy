#!/bin/bash

string="apple orange banana"

# Parse the string into an array
read -ra array <<< "$string"

# Loop through the array elements and print them
for item in "${array[@]}"; do
  echo "$item"
done