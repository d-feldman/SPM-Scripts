#! /bin/bash

# by Daniel Feldman 06/2/2023


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

function function1() {
    ${EXPDIR}/Scripts/PreProcessing/Group_PP_Scripts/launch_02_despike.sh 
    	if [ $? -eq 0 ]; then 
		echo "despiking completed"
	else 
		echo "despiking failed"
		exit 1
	fi
    }

function function2() {
    ${EXPDIR}/Scripts/PreProcessing/Group_PP_Scripts/launch_03_anima_dist_corr.sh 
    	if [ $? -eq 0 ]; then 
		echo "distortion correction completed"
	else 
		echo "distortion correction failed"
		exit 1
	fi
    }

function function3() {
     ${EXPDIR}/Scripts/PreProcessing/Group_PP_Scripts/run_realign_sliceTime_job.m
    	if [ $? -eq 0 ]; then 
		echo "spatial, sliceTiming, and Smoothing Completed"
	else 
		echo "failure to launch"
		exit 1
	fi
    }


for SUBJ in ${SUBJECTLIST} 
do
    function1
    function2
    echo "Distortion Correction Ongoing!"
    while [ ! -f ${EXPDIR}/ImagingData/SubjectsDerived/group_model/${SUBJ}/func/SCC/run_01/dc_ds_run_01.nii ]; do
	sleep 1
    done 
    function3
    echo "Be patient"
done
  
echo "${DATE} : ${USER} : All done"
echo

#
# all done
#
