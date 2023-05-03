library(tidyverse)

############### part 1: label creative jobs in a new 'creative' column as 1, and other jobs as 0
p = read_tsv('/wdata/cries/career_proj/biol-4386-course-project-clries_backup/data/input_data/ukb_job_data.tsv')
jobs <- p %>% 
  select(c(eid, array, job, start)) %>%
  mutate(creative = case_when(str_detect(string = job, pattern = "artist|music|graphic|actor,|entertain|architect|dancer|dancing|arts officer|design|
                                         public relations|journal|editor|statistician|social science|geographer|writer|it strategy|it manager|
                                         it user|it oper|callig|glass|cerami|archiv|marketing|second|draughts|physic|town planner|
                                         civil engineer|vocational or|vocational t|photog|software|librarian|higher ed|quality control eng|
                                         design and development eng|electrical eng|quantity surveyor|teacher|further ed|chem|conservation|
                                         environment|bio") == TRUE ~ 1,
                          #    str_detect(string = job, pattern = ) == TRUE ~ -1,
                              TRUE ~ 0)) %>%
  rename(IID = eid)
# save the list of creative jobs to a file for access on github
p %>% 
  select(job) %>%
  filter(str_detect(string = job, pattern = "artist|music|graphic|actor,|entertain|architect|dancer|dancing|arts officer|design|
                                         public relations|journal|editor|statistician|social science|geographer|writer|it strategy|it manager|
                                         it user|it oper|callig|glass|cerami|archiv|marketing|second|draughts|physic|town planner|
                                         civil engineer|vocational or|vocational t|photog|software|librarian|higher ed|quality control eng|
                                         design and development eng|electrical eng|quantity surveyor|teacher|further ed|chem|conservation|
                                         environment|bio")) %>% unique() %>%
  write_csv('/wdata/cries/career_proj/tmp/biol-4386-course-project-clries/creative_jobs.csv')
  
############# part 2: add BPD polygenic scores to the tibble
  file = '/wdata/lcasten/ukbb/imaging/LDPred2/LDPred2_gathered_resid_scores_w_covar.csv'
bipolar_pgs <- read_csv(file)  %>%
  filter(pgs_name == '2021_PGC_bipolar_I_II') %>%
  select(c(IID, adj_pgs, sexMale))
bipolar_pgs

############# part 3: add job satisfaction data, since the first file we downloaded from UKB only had job data
####### filter to only include participants with complete job, satisfaction, and PGS data
jobsat = read_csv('/wdata/cries/career_proj/biol-4386-course-project-clries/master_job_data_participant.csv') 
only_sat <- jobsat %>%
  select(c(eid, p4537_i0)) %>%
  rename(IID = eid)
all_dat <- inner_join(jobs, bipolar_pgs, by = 'IID') %>%
  inner_join(only_sat, by = 'IID') %>%
  rename(job_sat = p4537_i0)
## change satisfaction data from a string to a value
final <- all_dat %>%
  mutate(job_sat = case_when(job_sat == 'Extremely happy' ~ 5,
                             job_sat == 'Very happy' ~ 4,
                             job_sat == 'Moderately happy' ~ 3,
                             job_sat == 'Moderately unhappy' ~ 2,
                             job_sat == 'Very unhappy' ~ 1,
                             job_sat == 'Extremely unhappy' ~ 0)
  )

################ part 5: saving tibble to a file
##### save a little chunk for the github
final %>%
  select(-c(IID)) %>%
  filter(creative != 0) %>%
  write_csv('/wdata/cries/career_proj/tmp/biol-4386-course-project-clries/dat_subset.csv')

#### save all for project analysis
final %>%
  write_csv('/wdata/cries/career_proj/tmp/biol-4386-course-project-clries/pgs_sat_data.csv')
