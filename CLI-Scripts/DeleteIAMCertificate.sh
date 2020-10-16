#!/bin/bash

#Script is to delete Certificates which are uploaded through IAM (old Model certificate updates)

for line in $(cat /home/duggun/inputfiles/IAMCertificates)
        {
        echo -e "Deleting $line Cert :\n $(aws iam delete-server-certificate --server-certificate-name $line)" >> /home/duggun/outputfiles/IAMCertDeletion.txt
        }

