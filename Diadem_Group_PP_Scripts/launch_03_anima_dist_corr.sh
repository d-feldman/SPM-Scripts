
#!/bin/bash

#
# Robert C Welsh
#
# 2021-11-05
#
# Modified by Daniel Feldman 09/12/2022


EXPDIR=/thalia/data/MickeyLab/DDEP22

START=1
LENGTH=1

SUBJECTLISTFILE=${EXPDIR}/Scripts/PreProcessing/Participants_List.txt

SUBJECTLIST=`cat ${SUBJECTLISTFILE} | head -${START} | tail -${LENGTH}`

cd ${EXPDIR}

DATE=`date`

echo
echo "${DATE} : ${USER} : Starting"
echo
echo "${DATE} : ${USER} : Processing : ${SUBJECTLIST}"
echo


for RUN in 1 
do
    echo "distortionCorrect -M ImagingData/SubjectsDerived/group_model/ -MO ImagingData/SubjectsDerived/group_model/ -f func/SCC/ -fm fieldMap -fi FM_PA.nii -bi FM_AP.nii -fg -v ds_run_0${RUN} ${SUBJECTLIST}"
    distortionCorrect -M ImagingData/SubjectsDerived/group_model/ -MO ImagingData/SubjectsDerived/group_model/ -f func/SCC/ -fm fieldMap -fi FM_PA.nii -bi FM_AP.nii -fg -v ds_run_0${RUN} ${SUBJECTLIST}
done
    

echo "${DATE} : ${USER} : All done"
echo

#
# all done
#
