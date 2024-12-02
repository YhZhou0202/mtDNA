#!/bin/bash

###裁剪序列，生成clean reads
java -jar path/to/trimmomatic-0.39.jar PE -phred33 -threads 10 -trimlog logfilead raw.read1.gz raw.read2.gz clean.read1.gz out.trim1.gz clean.read2.gz out.trim2.gz ILLUMINACLIP:./MGI-adPE.fa:2:15:7:1:true SLIDINGWINDOW:4:15 LEADING:3 TRAILING:3

###质控
fastqc clean.read1.gz clean.read2.gz -o fq_quality

###筛选同源序列，生成比对文件unclassified.sam
bwa aln -l 25 -k 2 -t 2 "$ref" ./clean.read1.gz -f ./B.sa1.sai
bwa aln -l 25 -k 2 -t 2 "$ref" ./clean.read2.gz -f ./B.sa2.sai

bwa sampe -o 10000 -r '@RG\tID:B\tSM:B_SP\tPL:UNKNOWN\tLB:adapt' "$ref" ./B.sa1.sai ./B.sa2.sai ./clean.read1.gz ./clean.read2.gz -f ./unclassified.sam

###建立损伤模型
damageprofiler -i unclassified.sam -o dam -r "$ref" -only_merged





