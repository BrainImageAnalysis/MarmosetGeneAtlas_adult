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




echo "go"
echo "MOVE: "$BL1
echo "REF1: " $BF
echo "REF0: " $BL0
echo "REF2: " $BL2
echo "POSTTRAFO:" $POSTTRAFO
echo "PRETRAFO:" $PRETRAFO
echo "BF:" $BF

MOVE=$BL1


if false; then
        ITK_GLOBAL_DEFAULT_NUMBER_OF_THREADS=10 \
                /disk/soft//ANTS/bin/antsAI -d 2 -v 1  \
                -o ${POSTTRAFO}.txt \
                --transform Rigid[ 0.1 ] \
                -m Mattes[$BF,$MOVE] \
                -s 1 -c 100
                
     OUT=${output_dir}/${FNAME}.nii.gz
        echo "OUT: " $OUT
        /disk/soft//ANTS/bin/antsApplyTransforms -v 1 -d 2 \
        --float 1 \
                -i $MOVE \
                -o $OUT \
                -r $BF \
                -n Linear \
                -t ${POSTTRAFO}.txt --default-value 1
                

fi

if false; then
        ITK_GLOBAL_DEFAULT_NUMBER_OF_THREADS=10 \
                /disk/soft//ANTS/bin/antsAI -d 2 -v 1  \
                -o $POSTTRAFO \
                --transform Rigid[ 0.1 ] \
                -m Mattes[$BF,$MOVE] \
                -p \
                -s 1 \
                -c 1000 
                
                
                

fi

if true; then
        ITK_GLOBAL_DEFAULT_NUMBER_OF_THREADS=10 \
                /disk/soft//ANTS/bin/antsRegistration -d 2 -v 1  \
                --float 1 \
                --write-composite-transform 1 \
                --initial-moving-transform [$BF,$MOVE,1] \
                -o [$POSTTRAFO] \
                --transform Rigid[0.1 ] \
                -m Mattes[$BF,$MOVE,1] \
                -c [1000x1000x1000, 1.e-50, 1000] \
                -s 4x4x4 \
                -f 16x8x4
                
fi                
if false; then
        ITK_GLOBAL_DEFAULT_NUMBER_OF_THREADS=10 \
                /disk/soft//ANTS/bin/antsRegistration -d 2 -v 1  \
                --float 1 \
                --write-composite-transform 1 \
                --initial-moving-transform [$BF,$MOVE,1] \
                -o [$POSTTRAFO] \
                --transform Rigid[ 0.1 ] \
                -m Mattes[$BF,$MOVE,1] \
                -c [1000x1000x1000, 1.e-8, 20] \
                -s 1x1x1\
                -f 16x8x4

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
                #-t ${POSTTRAFO}Composite.h5 --default-value 0

        
fi
