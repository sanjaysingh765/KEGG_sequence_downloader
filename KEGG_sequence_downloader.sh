#!/bin/bash
 
########################################################################################################################
#
#     Split IDs in given chunk
#     Download fasta sequences as html file 
#     Clean HTML file and save result
#
#
#     Query file format
#     nta:107758906
#     nta:107758907
#     nta:107758908
#     nta:107758909
#     nta:107758910
#     nta:107758911
#     nta:107758912
#
#
#
  
########################################################################################################################
 
query="$1"
size="$2"

 
 
if [[ $# -lt 2 ]] ; then
    printf "\033[1;31mGive me a proper command\033[0m\n"
    printf "\033[1;31mUsage: KEGG_sequence_downloader.sh query_file number_of_sequence_each_file\033[0m\n\n"
     
exit;
 
 
else


i=1
chunk_file=$query
j=$(($i + $size - 1 ))  #change the number here for the every chunk
total_lines=`wc -l $chunk_file | awk '{print $1}'`

while [[ $i -le $total_lines ]]
do

#break IDs in different hunk and save them as URL
sed -n "$i,$j p" ${chunk_file} | sed -z 's/\n/+/g' | sed 's/+$//' | awk '{print "https://www.genome.jp/dbget-bin/www_bget?-f+-n+n+"$0}' >url.txt 
#Download sequences
for i in $(cat url.txt) ; do curl $i >> output.txt ; done 


i=$(( $j + 1))
j=$(($i + 10 - 1 ))

done


#clean HTML file
# input_file | strip HTML | replace &gt; with > | delete all line strat with KEGG | remove blank line | convert to upper case
cat output.txt | awk -v RS='<[^>]+>' -v ORS= '1' | sed 's/&gt;/>/g'  | sed '/\KEGG/d' | awk NF | awk 'BEGIN{FS=" "}{if(!/>/){print toupper($0)}else{print $0}}'  >$query.Genome.fasta


rm url.txt
rm output.txt


fi
