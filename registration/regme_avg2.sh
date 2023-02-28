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
echo "FIL: " $FIL    # filtered image
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
                --transform Affine[ 0.1 ] \
                -m Mattes[$FIL,$MOVE,1] \
                -m Mattes[$BL0,$MOVE,1] \
                -m Mattes[$BL2,$MOVE,1] \
                -c [500x250x200x100, 1.e-50, 1000] \
                -s 1x1x1x1\
                -f 16x8x4x2

fi

if true; then



     ITK_GLOBAL_DEFAULT_NUMBER_OF_THREADS=10 \
                /disk/soft//ANTS/bin/antsRegistration -d 2 -v 1  \
                --float 1 \
                --write-composite-transform 1 \
                  --initial-moving-transform $PRETRAFO \
                -o [$POSTTRAFO] \
                --transform Affine[ 0.1 ] \
                -m Mattes[$BF,$MOVE,0.5] \
                -m Mattes[$FIL,$MOVE,1] \
                -m Mattes[$BL0,$MOVE,0.5] \
                -m Mattes[$BL2,$MOVE,0.5] \
                -c [1000x1000x1000x100, 1.e-50, 1000] \
                -s 4x4x4x2\
                -f 16x8x4x2

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

           #     /disk/soft//ANTS/bin/antsRegistration -d 2 -v 1  \  # --dimensionality
           #     --float 1 \                                  # use float instead of double for computations
           #     --write-composite-transform 1 \
           #       --initial-moving-transform $PRETRAFO \
           #     -o [$POSTTRAFO] \                            # --output, outputTransformPrefix
           #     --transform Affine[ 0.1 ] \                  # Affine[gradientStep]
           #     -m Mattes[$BF,$MOVE,0.5] \                   # --metric; Mattes[fixedImage,movingImage,metricWeight]
           #     -m Mattes[$FIL,$MOVE,1] \
           #     -m Mattes[$BL0,$MOVE,0.5] \
           #     -m Mattes[$BL2,$MOVE,0.5] \
           #     -c [1000x1000x1000x100, 1.e-50, 1000] \      # --convergence MxNxO [maxIterationsperLevel,stoppingThresholdforMI, convergenceWindowSize]
           #     -s 4x4x4x2\                                  # --smoothing-sigmas, Gaussian kernel SD values
           #     -f 16x8x4x2                                  # --shrink-factors, hierarchical steps will have resolutions divided by these factors

#fi



#if true; then
#        OUT=${output_dir}/${FNAME}.nii.gz
#        echo "OUT: " $OUT
#        /disk/soft//ANTS/bin/antsApplyTransforms -v 1 -d 2 \
###        --float 1 \
  #              -i $MOVE \                                  # input or moving image
  #              -o $OUT \                                   # output name prefix
  #              -r $BF \                                    # ref image
  #              -n Linear \                                 # apply bias field correction
  #              -t ${POSTTRAFO}Composite.h5 --default-value 1  # --transform