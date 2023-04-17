library(tidyverse)
#this is magma, so not what we need
# read_tsv('/sdata/gwas_summary_stats/magma/processed_magma_out/2017_pgc_autism_15kb.genes.out.tsv')
# how to bypass case sensitivity--- 'tolower()' function.
# you don't need this anymore but keeping as a reference
## UKB_ex = read_csv('/sdata/UK_Biobank/data_queries/taylor_keys/updated_master.csv')
#this is literally just a bunch of helpful hints and my learning curve here

###############  autism summary stats
read_tsv('/sdata/gwas_summary_stats/PGC/2017/2017_pgc_autism.tsv')


cls <- read_tsv('/wdata/trthomas/array/merged_2022_ABCD_iWES1_WGS_2-4/master.tsv') %>%
  filter(cluster_allPCs == 1)

pgs <- read_tsv("/wdata/trthomas/array/merged_2022_ABCD_iWES1_WGS_2-4/PGS/all_PGS.tsv") 
pgs2 <- pgs %>% 
  select(IID, PGS_name, PGS = PGS_std_PCresid)
pgs_names <- read_tsv("/wdata/trthomas/array/merged_2022_ABCD_iWES1_WGS_2-4/PGS/clean_PGS_names.tsv")

pgs_keep <- pgs_names %>% 
  filter(str_detect(tolower(PGS_name), tolower('NEB|NEARSIGHTED|MIGRAINE|HAYFEVER|HEIGHT|MENARCHE|EVERSMOKE|DPW|CPD|COPD|CANNABIS|BMI|ASTHMA|ASTEC|AFB|ACTIVITY|cannabis|alcohol|morning'), negate = T))
  # distinct(PGS_name)

pgs <- pgs %>% 
  filter(PGS_name %in% pgs_keep$PGS_name) %>%
  filter(IID %in% cls$IID)

#combine demos
demo1 = read_csv('/wdata/cries/Fall_2022/courtney_demo.csv')
demo2 = read_csv('/wdata/cries/Fall_2022/lucasdemo.csv')

####################### demographics and job data, complete
demographics =  inner_join(demo1, demo2, by = 'eid')
i1 = read_csv('/wdata/cries/Fall_2022/job_1.csv')
i2 = read_csv('/wdata/cries/Fall_2022/job_2.csv')
i3 = read_csv('/wdata/cries/Fall_2022/job_3.csv')
i4 = read_csv('/wdata/cries/Fall_2022/job_4.csv')
i5 = read_csv('/wdata/cries/Fall_2022/job_5.csv')
job_data = full_join(i1, i2, by = 'eid', all = T) %>%
  full_join(i3, by = 'eid') %>%
  full_join(i4, by = 'eid') %>%
  full_join(i5, by = 'eid') 
# more cleaning - ditch all jobs after 2010, then grab the last one
# job_data %>% pivot_longer(cols = starts_with())
### analysis ??
# pattern = _[:alpha:][:digit:]

## ok we're just going a different harder way here
job <- job_data %>%
  select(eid, starts_with('p22601')) %>%
  pivot_longer(cols = starts_with('p22601'), names_to = 'array', names_prefix = 'p22601_a', values_to = 'job', values_drop_na = T)
hist_job <- job_data %>%
  select(eid, starts_with('p22617')) %>%
  pivot_longer(cols = starts_with('p22617'), names_to = 'array', names_prefix = 'p22617_a', values_to = 'hist', values_drop_na = T)
int <- inner_join(job, hist_job, by = c('eid', 'array'))
start_year <- job_data %>%
  select(eid, starts_with('p22602')) %>%
  pivot_longer(cols = starts_with('p22602'), names_to = 'array', names_prefix = 'p22602_a', values_to = 'start', values_drop_na = T)
int2 <- inner_join(int, start_year, by = c('eid', 'array')) %>%
  filter(start < 2010) %>%
  group_by(eid) %>% 
  slice_max(order_by = array, n = 1, with_ties = F)
full_dat <- inner_join(int2, demographics, by = 'eid')

# analysis now! pgs!

full_dat %>% write_tsv('/wdata/cries/Fall_2022/ukb_job_data.tsv')

##UKBiobank genetics people
fam_file = '/sdata/UK_Biobank/genotypes/imputed_v3/plink/ukb_imp_chr1_v3.fam'
bim_file = '/sdata/UK_Biobank/genotypes/imputed_v3/plink/ukb_imp_chr1_v3.bim'
fam = read_tsv(fam_file, col_names = F)
fam %>%
  filter(X2 %in% full_dat$eid) %>%
  write_tsv('/wdata/cries/Fall_2022/job_subset.fam')

#### plink plink ###
system("cat /wdata/lcasten/ukbb/imaging/code/pull_merge_most_recent_array_data_for_prs.sh")
# pgs #
"/wdata/lcasten/ukbb/example_ukbb_polygenic_score_calculation.R"
