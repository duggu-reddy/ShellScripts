#!/bin/bash
### Author : Narasimha R Duggu (duggu.narasimhareddy@gmail.com)

## Check ACM Certificates and Generate HTML Report.

if [ "$1" == "us-east-1" ]
then
        export REGION="US-EAST"
        export region="us-east-1"
elif [ "$1" == "eu-west-1" ]
then
        export REGION="EU"
        export region="eu-west-1"
else
        echo "Region is not valid exiting now.."
        exit 0
fi

rm /home/duggun/outputfiles/*"$1"-acmarnValidation.csv
export HTML=/tmp/acmarnValidation-$region.html

aws acm list-certificates --region $region --query 'CertificateSummaryList[*].CertificateArn' |awk -F"\"" '{print $2}' | awk 'NF > 0' > /home/duggun/inputfiles/"$1"-acmarnDetails.txt

for acmArn in $(cat /home/duggun/inputfiles/"$1"-acmarnDetails.txt)
      do
      temparn=$(echo $acmArn |  awk -F"/" '{print $2}')
      aws acm describe-certificate --region $region --certificate-arn $acmArn --query 'Certificate.{Dname:DomainName,Anames:SubjectAlternativeNames[*],notbefore:NotBefore,notafter:NotAfter,inuseby:InUseBy}' > $temparn.json

      Dname=$(cat $temparn.json | jq -c '.Dname')
      Anames=$(cat $temparn.json | jq -c '.Anames')
      notbefore=$(cat $temparn.json | jq -c '.notbefore' | awk -FT '{print $1}' | awk -F"\"" '{print $2}')
      notafter=$(cat $temparn.json | jq -c '.notafter' | awk -FT '{print $1}' | awk -F"\"" '{print $2}')
      inuseby=$(cat $temparn.json | jq -c '.inuseby')
      echo -e "$Dname|$Anames|$notbefore|$notafter|$inuseby" >> /home/duggun/outputfiles/`date "+%Y-%m-%d"`-"$1"-acmarnValidation.csv
      rm $temparn.json
      done

rm /tmp/"$1"-acmarnValidation.html
export HTML=/tmp/"$1"-acmarnValidation.html
higher=`date --date="30 days" "+%Y-%m-%d"`

echo "<html>" >> $HTML
echo "<head>" >> $HTML

echo "<STYLE TYPE="text/css">" >> $HTML
echo "<!--" >> $HTML
echo "TD{font-family: Arial; font-size: 10pt;}" >> $HTML
echo "--->" >> $HTML
echo "</STYLE>" >> $HTML

echo "</head>" >> $HTML
echo "<body>" >> $HTML
echo "Generated on `date`" >> $HTML
echo "<table border="1" align="left">" >> $HTML
echo "<colgroup>" >> $HTML
echo "<col span="18" style="background-color:lightyellow">" >> $HTML
echo "<col style="font-color:black">" >> $HTML
echo "</colgroup>" >> $HTML


echo "<tr bgcolor="brown">" >> $HTML
echo "<th colspan="16"><font face="Arial"> Kantar AWS Certificate Manager </th>" >> $HTML
echo "</tr>" >> $HTML
      

echo "<tr align="center">" >> $HTML
echo "<th><font face="Arial" size="2"> DomainName </th>" >> $HTML
echo "<th><font face="Arial" size="2"> SubjectAlternativeNames </th>" >> $HTML
echo "<th><font face="Arial" size="2"> NotBefore </th>" >> $HTML
echo "<th><font face="Arial" size="2"> NotAfter </th>" >> $HTML
echo "<th><font face="Arial" size="2"> InUseBy </th>" >> $HTML
echo "</tr>" >> $HTML

for LINE in $(cat /home/duggun/outputfiles/`date "+%Y-%m-%d"`-"$1"-acmarnValidation.csv)
  do
  echo "<tr align="center">" >> $HTML


  if [ "`echo $LINE|awk  -F"|" '{print $1}'`" == "empty" ]
  then
          echo "<td bgcolor="#FF0000">"`echo $LINE|awk -F"|" '{print $1}'`"</td>" >> $HTML
  elif [ "`echo $LINE|awk  -F"|" '{print $1}'`" == "" ]
  then
          echo "<td bgcolor="#FF0000">"`echo $LINE|awk -F"|" '{print $1}'`"</td>" >> $HTML
  else
          echo "<td>"`echo $LINE|awk -F"|"  '{print $1}'`"</td>" >> $HTML
  fi
    


  if [ "`echo $LINE|awk  -F"|" '{print $2}'`" == "empty" ]
  then
          echo "<td bgcolor="#FF0000">"`echo $LINE|awk -F"|" '{print $2}'`"</td>" >> $HTML
  elif [ "`echo $LINE|awk  -F"|" '{print $2}'`" == "\[\]" ]
  then
          echo "<td bgcolor="#FF0000">"`echo $LINE|awk -F"|" '{print $2}'`"</td>" >> $HTML
  else
          echo "<td>"`echo $LINE|awk -F"|"  '{print $2}'`"</td>" >> $HTML
  fi
  


  if [ "`echo $LINE|awk  -F"|" '{print $3}'`" == "empty" ]
  then
          echo "<td bgcolor="#FF0000">"`echo $LINE|awk -F"|" '{print $3}'`"</td>" >> $HTML
  elif [ "`echo $LINE|awk  -F"|" '{print $3}'`" == "" ]
  then
          echo "<td bgcolor="#FF0000">"`echo $LINE|awk -F"|" '{print $3}'`"</td>" >> $HTML
  else
          echo "<td>"`echo $LINE|awk -F"|"  '{print $3}'`"</td>" >> $HTML
  fi

  lower=`echo $LINE|awk  -F"|" '{print $4}'`
  date_diff=$(( ($(date -d "$higher" +%s) - $(date -d "$lower" +%s) )/(60*60*24) ))

  if [[ "$date_diff" -gt "0" ]]
  then
          echo "<td bgcolor="#FF0000">"`echo $LINE|awk -F"|" '{print $4}'`"</td>" >> $HTML
  elif [[ "$date_diff" -lt "0" && "$date_diff" -gt "-30" ]]
  then
        echo "<td bgcolor="#FFC200">"`echo $LINE|awk -F"|" '{print $4}'`"</td>" >> $HTML
  else
          echo "<td>"`echo $LINE|awk -F"|"  '{print $4}'`"</td>" >> $HTML
  fi
  



  if [ "`echo $LINE|awk  -F"|" '{print $5}'`" == "empty" ]
  then
          echo "<td bgcolor="#FF0000">"`echo $LINE|awk -F"|" '{print $5}'`"</td>" >> $HTML
  elif [ "`echo $LINE|awk  -F"|" '{print $5}'`" == "[]" ]
  then
          echo "<td bgcolor="#FF0000">"`echo $LINE|awk -F"|" '{print $5}'`"</td>" >> $HTML
  else
          echo "<td>"`echo $LINE|awk -F"|"  '{print $5}'`"</td>" >> $HTML
  fi
    
  echo "</tr>" >> $HTML
  done
  
echo "</table>" >> $HTML
echo "</body>" >> $HTML
echo "</html>" >> $HTML
sudo cp -arv /tmp/"$1"-acmarnValidation.html /var/www/html/
