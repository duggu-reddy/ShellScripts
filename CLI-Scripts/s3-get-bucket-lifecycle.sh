#!/bin/bash

write_file()
{
for data in $(cat tempfile.csv)
do
  echo -e "$line,$data" >> /home/duggun/outputfiles/get-bucket-lifecycle-configuration.csv
done
rm $line.json
}

for line in $(cat /home/duggun/inputfiles/S3bucketsList.txt)
do
  aws s3api get-bucket-lifecycle-configuration --bucket $line > $line.json
  F_count=$(grep Filter $line.json | wc -l)
  T_count=$(grep Transitions $line.json | wc -l)
  E_count=$(grep Expiration $line.json |wc -l)

  if [[ "$F_count" == 0 && "$T_count" != 0 && "$F_count" != "$T_count" && "$T_count" != "$E_count" ]]; then
    jq -r '.Rules[] | [ .Prefix, .Status, .Expiration.Days, .Transitions[].Days, .Transitions[].StorageClass]  | @csv' < $line.json > file1.csv
    jq -r '.Rules[] | [ .Prefix, .Status, .Expiration.Days]  | @csv' < $line.json > file2.csv
    cat file1.csv file2.csv > tempfile.csv
    write_file $line
  elif [[ "$F_count" == 0 && "$T_count" != 0 ]]; then
    jq -r '.Rules[] | [ .Prefix, .Status, .Expiration.Days, .Transitions[].Days, .Transitions[].StorageClass]  | @csv' < $line.json > tempfile.csv
    write_file $line
  elif [[ "$F_count" == 0 ]]; then
    jq -r '.Rules[] | [ .Prefix, .Status, .Expiration.Days]  | @csv' < $line.json > tempfile.csv
    write_file $line
  else
    jq -r '.Rules[] | [ .Filter.Prefix, .Status, .Expiration.Days, .Transitions[].Days, .Transitions[].StorageClass] | @csv' < $line.json > tempfile.csv
    write_file $line
  fi
done
