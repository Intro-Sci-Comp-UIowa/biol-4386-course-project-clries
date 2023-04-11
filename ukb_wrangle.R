library(tidyverse)
p = read_tsv('/wdata/cries/career_proj/biol-4386-course-project-clries_backup/data/input_data/ukb_job_data.tsv')
jobs <- p %>% 
  select(c(eid, array, job, start)) %>%
  mutate(creative = case_when(str_detect(string = job, pattern = "archit|draught|auth|reporter|music|dancer|entertain|singer|artist|arts|cartoon|painter") == TRUE ~ 1,
                              TRUE ~ 0)
         ) %>%
  mutate(not_creative = case_when(str_detect(string = job, pattern = "boring") == TRUE ~ 1,
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
  select(c(IID, adj_pgs, age_at_recruitment, sexMale))
bipolar_pgs

# job satisfaction
jobsat = read_csv('/wdata/cries/career_proj/biol-4386-course-project-clries/master_job_data_participant.csv') 
only_sat <- jobsat %>%
  select(c(eid, p4537_i0)) %>%
  rename(IID = eid)
final <- inner_join(jobs, bipolar_pgs, by = 'IID') %>%
  inner_join(only_sat, by = 'IID') %>%
  rename(job_sat = p4537_i0)

final %>%
  select(-IID) %>%
  head(20) %>%
  write_csv('/wdata/cries/career_proj/tmp/dat_subset.csv')
