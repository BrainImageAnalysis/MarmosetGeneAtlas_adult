#!/bin/bash 
#SBATCH --mem 16G 
#SBATCH -c 20
#SBATCH -t 240 
#SBATCH -p bigmem
#SBATCH -o /disk/k_raid/usr/skibbe-h/DATA/charissa_ISH/poster/stack_align/log/slurm.out  
#SBATCH -e /disk/k_raid/usr/skibbe-h/DATA/charissa_ISH/poster/stack_align/log/slurm.error  
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


if false; then



     ITK_GLOBAL_DEFAULT_NUMBER_OF_THREADS=10 \
                /disk/soft//ANTS/bin/antsRegistration -d 2 -v 1  \
                --float 1 \
                --write-composite-transform 1 \
                  --initial-moving-transform $PRETRAFO \
                -o [$POSTTRAFO] \
                --transform SyN[ 0.05,3,0 ] \
                -m Mattes[$FIL,$MOVE,1] \
                -m Mattes[$BL0,$MOVE,1] \
                -m Mattes[$BL2,$MOVE,1] \
                -c [500x250x200x100, 1.e-8, 20] \
                -s 1x1x1x1\
                -f 16x8x4x2

 
fi


if true; then

  /disk/soft//ANTS/bin/antsApplyTransforms -v 1 -d 2 \
     --float 1 \
         -i $MOVE \
         -o [$PRETRAFO_MERGED,1] \
         -r $BF \
         -n Linear \
         -t ${PRETRAFO}

     ITK_GLOBAL_DEFAULT_NUMBER_OF_THREADS=10 \
                /disk/soft//ANTS/bin/antsRegistration -d 2 -v 1  \
                --float 1 \
                --write-composite-transform 1 \
                  --initial-moving-transform $PRETRAFO_MERGED \
                -o [$POSTTRAFO] \
                --transform SyN[ 0.05,3,0 ] \
                -m Mattes[$FIL,$MOVE,1] \
                -m Mattes[$BL0,$MOVE,0.5] \
                -m Mattes[$BL2,$MOVE,0.5] \
                 -c [1000x1000x1000, 1.e-50, 500] \
                 -s 4x2x1\
                -f 4x2x1

 
fi



if true; then
        OUT=${output_dir}/${FNAME}.nii.gz
        echo "OUT: " $OUT
        /disk/soft//ANTS/bin/antsApplyTransforms -v 1 -d 2 \
        --float 1 \
                -i $MOVE \
                -o $OUT \
                -r $BF \
                -n Linear \
                -t ${POSTTRAFO}Composite.h5 --default-value 1

        
fi


###
               #--transform SyN[ 0.05,3,0 ] \             # gradientStep, updateGradientFieldVarianceinVoxelSpace, totalGradientFieldVarianceinVoxelSpace
               # -m Mattes[$FIL,$MOVE,1] \
               # -m Mattes[$BL0,$MOVE,0.5] \
               # -m Mattes[$BL2,$MOVE,0.5] \
               # -c [1000x1000x1000, 1.e-50, 500] \       # --convergence
               # -s 4x2x1\                                # --smoothing-sigmas
               # -f 4x2x1                                  # --shrink-factors
               # -r, --initial-moving-transform initialTransform
               # -o, --output outputTransformPrefix