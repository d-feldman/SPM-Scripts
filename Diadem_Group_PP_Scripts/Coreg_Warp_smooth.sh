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

#go convert and get norm.nii
function function0() {
    for SUBJ in ${SUBJECTLIST} 
    do
    	cd /thalia/data/MickeyLab/DDEP22/ImagingData/SubjectsDerived/group_model/${SUBJ}/anat/${SUBJ}/mri/
    	mri_convert norm.mgz norm.nii
    	cp /thalia/data/MickeyLab/DDEP22/ImagingData/SubjectsDerived/group_model/${SUBJ}/anat/${SUBJ}/mri/norm.nii /thalia/data/MickeyLab/DDEP22/ImagingData/SubjectsDerived/group_model/${SUBJ}/anat/
    done
    	if [ $? -eq 0 ]; then 
		echo "Filetype fixed"
	else 
		echo "fileType failure"
		exit 1
	fi
    }


#Coregister Anatomical to Mean Functional
function function1() {
    ${EXPDIR}/Scripts/PreProcessing/Group_PP_Scripts/run_Coreg_T1func_job.m 
   	if [ $? -eq 0 ]; then 
		echo "coreg completed"
	else 
		echo "coreg failed"
		exit 1
	fi 
    }

##ANTS register Anatomical to MNI
function function2() {
    for SUBJ in ${SUBJECTLIST} 
    do
    cd /thalia/data/MickeyLab/DDEP22/ImagingData/SubjectsDerived/group_model/${SUBJ}/anat/
    antsRegistrationSyNQuick.sh -d 3 -f /thalia/data/MickeyLab/DDEP22/ImagingData/SubjectsDerived/MNI152_T1_2mm_brain.nii -m rnorm.nii -o MNIxT1 -t s
    done
        if [ $? -eq 0 ]; then 
		echo "T1 Reg to MNI correction completed"
	else 
		echo "T1 to MNI failed"
		exit 1
	fi
    }
#fix s and q forms
function function3() {
    for SUBJ in ${SUBJECTLIST} 
    do
    cd /thalia/data/MickeyLab/DDEP22/ImagingData/SubjectsDerived/group_model/${SUBJ}/anat/
    fslorient -copyqform2sform MNIxT11Warp.nii.gz
    done
    	if [ $? -eq 0 ]; then 
		echo "Coppied Q form to S form Completed"
	else 
		echo "Failed q and s form standardization"
		exit 1
	fi
    }

#Apply the transforms to Bold Data
function function4() {
    for SUBJ in ${SUBJECTLIST} 
    do
    cd /thalia/data/MickeyLab/DDEP22/ImagingData/SubjectsDerived/group_model/${SUBJ}/anat/
    antsApplyTransforms -e 3 -i /thalia/data/MickeyLab/DDEP22/ImagingData/SubjectsDerived/group_model/${SUBJ}/func/SCC/run_01/ardc_ds_run_01.nii -r /thalia/data/MickeyLab/DDEP22/ImagingData/SubjectsDerived/MNI152_T1_2mm_brain.nii -t MNIxT11Warp.nii.gz -t MNIxT10GenericAffine.mat -o /thalia/data/MickeyLab/DDEP22/ImagingData/SubjectsDerived/group_model/${SUBJ}/func/SCC/run_01/wardc_ds_run_01.nii
    done
    if [ $? -eq 0 ]; then 
		echo "BOLD successfully in MNI Space"
	else 
		echo "Failed BOLD Standardization"
		exit 1
	fi
    }

#Apply the transforms to Bold Data
function function5() {
   ${EXPDIR}/Scripts/PreProcessing/Group_PP_Scripts/run_smoothing_8mm_job.m 
   	if [ $? -eq 0 ]; then 
		echo "smoothing completed"
	else 
		echo "smoothing failed"
		exit 1
	fi 
    }

for SUBJ in ${SUBJECTLIST} 
do
    function0    
    function1
    function2
    function3
    function4
    function5
    echo "Be patient"
done
  
echo "${DATE} : ${USER} : All done"
echo

#
# all done
#
