#!/bin/bash 
#SBATCH --mem 16G 
#SBATCH -c 20
#SBATCH -t 240 
#SBATCH -p bigmem
#SBATCH -o /disk/charissa/ISH_reg_pipeline/log/slurm.out  
#SBATCH -e /disk/charissa/ISH_reg_pipeline/log/slurm.error  
echo $HOSTNAME 


#STATE=0; for SID in {1001..1090};do sbatch --export=ALL,SID=$SID,STATE=$STATE regme_avg.sh;done;
#c
#%%
#MID=$1



current=$STATE
output_dir=${ODIR}/img/
trafo_dir=${ODIR}/trafo/

echo "output_dir" $output_dir
echo "trafo_dir" $trafo_dir



POSTTRAFO=${trafo_dir}/trafo_${FNAME}
PRETRAFO_MERGED=${trafo_dir}/trafo_${FNAME}_merged.nii.gz



echo "go"
echo "MOVE: "$BL1
echo "REF1: " $BF
echo "REF0: " $BL0
echo "REF2: " $BL2
echo "REF_BL: " $REF_BL
echo "FIL: " $FIL
echo "POSTTRAFO:" $POSTTRAFO
echo "PRETRAFO:" $PRETRAFO
MOVE=$BL1




if true; then
        OUT=${output_dir}/${FNAME}.nii.gz
        echo "OUT: " $OUT
        /disk/soft//ANTS/bin/antsApplyTransforms -v 1 -d 2 \
        --float 1 \
                -i $MOVE \
                -o $OUT \
                -r $BF \
                -n Linear \
                -t ${PRETRAFO} --default-value 1

        
fi


#-t ${POSTTRAFO}Composite.h5 --default-value 1

### antsRegistration, from manpages ###
# --float  Use 'float' instead of 'double' for computations.
#  -o, --output outputTransformPrefix
# -m, metric
# -c, --convergence MxNxO
# -s, --smoothing-sigmas MxNxO... Specify  the sigma of gaussian smoothing at each level (vox)
# -f -f, --shrink-factors MxNxO... Specify  the  shrink  factor  for the virtual domain (typically the fixed image) at each level.

### antsApplyTransforms, from manpages ###
# -v, --verbose 0/1, verbose output
# -d, --dimensionality 2/3/4. forces the image to be treated a specified dimensional image
# --float 0/1, use float instead of double for computations
# -i, --input inputFileName 
# -o, --output warpedOutputFileName 
# -r, --reference-image imageFileName. For warping input images, the reference image defines the spacing, origin, size, and direction of the output warped image. 
# -n, --interpolation Linear, NearestNeighbor, Gaussian, etc.
# -t, --transform

