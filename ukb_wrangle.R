library(tidyverse)
p = read_tsv('/wdata/cries/career_proj/biol-4386-course-project-clries_backup/data/input_data/ukb_job_data.tsv')
p %>% select(c(eid, array, job, start)) %>%
  mutate(creative = case_when(job == contains('archit|draught|auth|reporter,|music|dancer|entertain|singer|artist|arts|cartoon|painter,') ~ 1,
                              TRUE ~ 0)) %>%
  head()
