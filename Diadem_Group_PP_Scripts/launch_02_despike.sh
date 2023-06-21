#!/bin/bash

#
# Robert C Welsh
#
# 2021-11-05
#
# Despiking the data.
#
# Per http://dx.doi.org/10.1155/2013/935154
#
# Paper by Ziad Saad
#
#Adapted to DDEP22 by Daniel Feldman 09-01-2022

EXPDIR=/thalia/data/MickeyLab/DDEP22

START=6
LENGTH=6

SUBJECTLISTFILE=${EXPDIR}/Scripts/PreProcessing/Participants_List.txt

SUBJECTLIST=`cat ${SUBJECTLISTFILE} | head -${START} | tail -${LENGTH}`

cd ${EXPDIR}

DATE=`date`

for SUBJECT in ${SUBJECTLIST}
do
    SESSIONLIST=
    for SESSION in `ls -d ${EXPDIR}/ImagingData/SubjectsDerivedNFS/${SUBJECT}/func/Rest/run_* | awk -F/ '{print $NF}'`
    do
	SESSIONLIST="${SESSIONLIST} ${SESSION}"
    done
    echo "${DATE} : ${USER} : despikeAFNI -B -M ImagingData/SubjectsDerived/ -MO ImagingData/SubjectsDerived/ -f func/Rest -v run_ ${SUBJECT}"
    despikeAFNI -B -M ImagingData/SubjectsDerived/group_model/ -MO ImagingData/SubjectsDerived/group_model/ -f func/SCC -v run_ ${SUBJECT}
done

#
# all done
#
