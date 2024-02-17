#!/bin/bash
#$ -M nmcadam2@nd.edu
#$ -m abe
#$ -q debug
#$ -N MultiQC-test

DIRECTORY=$(pwd)
TOOL=multiqc
INPUT=$DIRECTORY/input_data/
VERSION=1.20

#Fastqc check
if [ ! $(command -v fastqc) ]; then
        module load bio/2.0
	echo "loaded bio/2.0 module"
fi

#make output folder
if [ -d "fastqc" ]; then
    echo "./fastqc exists"
else
    mkdir fastqc
fi

#run fastqc
for g in $INPUT/*.gz; do
	fastqc -o ./fastqc $g
done
echo "fastqc complete"

#container install
if [ -d "image" ]; then
    echo "./image exists"
else
    mkdir image
fi

singularity pull docker://multiqc/multiqc:v1.20
mv *.sif $DIRECTORY/image/$TOOL-v$VERSION.sif

#run multiqc
FASTQC=$DIRECTORY/fastqc/
singularity exec -B $DIRECTORY $DIRECTORY/image/$TOOL-v$VERSION.sif $TOOL $FASTQC
