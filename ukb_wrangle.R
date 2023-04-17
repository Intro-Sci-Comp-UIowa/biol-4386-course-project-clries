library(tidyverse)
p = read_tsv('/wdata/cries/career_proj/biol-4386-course-project-clries_backup/data/input_data/ukb_job_data.tsv')
jobs <- p %>% 
  select(c(eid, array, job, start)) %>%
  mutate(creative = case_when(str_detect(string = job, pattern = "archit|draught|auth|reporter|music|dancer|entertain|singer|artist|arts|cartoon|painter") == TRUE ~ 1,
                              str_detect(string = job, pattern = "farm|factory|horticult|plumb|food worker|road transport/traffic clerk|care assist") == TRUE ~ -1,
                              TRUE ~ 0)
         ) %>%
  rename(IID = eid)
  # select(creative) %>% table()

                              # job == contains('archit|draught|auth|reporter,|music|dancer|entertain|singer|artist|arts|cartoon|painter,')) ~ 1,
                              # TRUE ~ 0) %>%

  
  #### polygenic scores ####
  file = '/wdata/lcasten/ukbb/imaging/LDPred2/LDPred2_gathered_resid_scores_w_covar.csv'
bipolar_pgs <- read_csv(file)  %>%
  filter(pgs_name == '2021_PGC_bipolar_I_II') %>%
  select(c(IID, adj_pgs, sexMale))
bipolar_pgs

# job satisfaction
jobsat = read_csv('/wdata/cries/career_proj/biol-4386-course-project-clries/master_job_data_participant.csv') 
only_sat <- jobsat %>%
  select(c(eid, p4537_i0)) %>%
  rename(IID = eid)
all_dat <- inner_join(jobs, bipolar_pgs, by = 'IID') %>%
  inner_join(only_sat, by = 'IID') %>%
  rename(job_sat = p4537_i0)

final <- all_dat %>%
  mutate(job_sat = case_when(job_sat == 'Extremely happy' ~ 5,
                             job_sat == 'Very happy' ~ 4,
                             job_sat == 'Moderately happy' ~ 3,
                             job_sat == 'Moderately unhappy' ~ 2,
                             job_sat == 'Very unhappy' ~ 1,
                             job_sat == 'Extremely unhappy' ~ 0)
  )
##### save a little chunk for the github
final %>%
  select(-c(IID)) %>%
  filter(creative != 0) %>%
  write_csv('/wdata/cries/career_proj/tmp/biol-4386-course-project-clries/dat_subset.csv')

#### save all for project analysis
final %>%
  write_csv('/wdata/cries/career_proj/tmp/biol-4386-course-project-clries/pgs_sat_data.csv')
