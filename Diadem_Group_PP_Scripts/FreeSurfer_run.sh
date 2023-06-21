# by Daniel Feldman 06/20/2023


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

#run through FS
function function1() {
    for SUBJ in ${SUBJECTLIST} 
    do
    	cd /thalia/data/MickeyLab/DDEP22/ImagingData/SubjectsDerived/group_model/${SUBJ}/anat/
    	recon-all -s ${SUBJ} -i mprage_wide_1.nii -sd /thalia/data/MickeyLab/DDEP22/ImagingData/SubjectsDerived/group_model/${SUBJ}/anat/ -all 
    done
  	if [ $? -eq 0 ]; then 
		echo "Freesurfer completed"
	else 
		echo "freesurfer failed"
		exit 1
	fi
    }


for SUBJ in ${SUBJECTLIST} 
do
    function1 &
    
done
  
echo "${DATE} : ${USER} : All done"
echo

#
# all done
#
