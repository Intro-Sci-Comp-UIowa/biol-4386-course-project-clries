## how to run: (run lines below in a terminal)
# ssh clries@argon.hpc.uiowa.edu
# qlogin -q CCOM,JM,UI -pe smp 20
# bash /Dedicated/jmichaelson-wdata/cries/PATH/plink.sh

## actual code
PLINK="/Dedicated/jmichaelson-wdata/lcasten/qc_imputation/imputation/bin/plink2"

JOB="/Dedicated/jmichaelson-wdata/cries/Fall_2022/job_subset.fam"
IMP="/Dedicated/jmichaelson-sdata/UK_Biobank/genotypes/imputed_v3/plink/ukb_imp_chr"
FINALSUBSET="/Dedicated/jmichaelson-wdata/cries/Fall_2022/ukbb_genetics/ukbb_imaging_caucasian_imputedV3_chr"

mkdir /Dedicated/jmichaelson-wdata/cries/Fall_2022/ukbb_genetics
ls /Dedicated/jmichaelson-wdata/cries/Fall_2022/

for chr in {1..22}; do \
 $PLINK \
    --threads 20 \
    --memory 510000 \
    --bfile $IMP$chr"_v3" \
    --keep $JOB \
    --make-bed --out $FINALSUBSET$chr
done

## subset to HapMap SNP's
HAPMAP="/Dedicated/jmichaelson-wdata/lcasten/ukbb/imaging/geno/imputed_v3/caucasian/HapMapSnpOverlap/UKBBv3_HapMap3_snp_overlap.txt"
HAPMAPOUT="/Dedicated/jmichaelson-wdata/cries/Fall_2022/ukbb_genetics/hapmap_snps/ukbb_imaging_caucasian_imputedV3_chr"

mkdir /Dedicated/jmichaelson-wdata/cries/Fall_2022/ukbb_genetics/hapmap_snps

for chr in {1..22}; do \
$PLINK \
    --threads 20 \
    --memory 510000 \
    --bfile $FINALSUBSET$chr \
    --extract $HAPMAP \
    --make-bed --out $HAPMAPOUT$chr
done

## merge all chr
mkdir /Dedicated/jmichaelson-wdata/cries/Fall_2022/ukbb_genetics/hapmap_snps/merged
FINALDAT="/Dedicated/jmichaelson-wdata/cries/Fall_2022/ukbb_genetics/hapmap_snps/merged/ukbb_merged_imputedV3_job_caucasian_HapMap3"

for i in {1..22}
do
    echo $HAPMAPOUT$i >> /Dedicated/jmichaelson-wdata/cries/Fall_2022/ukbb_genetics/hapmap_snps/mergelist.txt
done

PLINK1="/Dedicated/jmichaelson-wdata/lcasten/qc_imputation/imputation/bin/plink"
$PLINK1 \
    --memory 510000 \
    --merge-list /Dedicated/jmichaelson-wdata/cries/Fall_2022/ukbb_genetics/hapmap_snps/mergelist.txt \
    --make-bed --out $FINALDAT
