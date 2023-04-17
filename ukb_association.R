library(tidyverse)
risktol = read_tsv('/wdata/cries/career_proj/biol-4386-course-project-clries/input_data/LDPred2/adhd-PGC-2019ancestry_adjusted_pgs.tsv')

jobdat = read_tsv('/wdata/cries/career_proj/biol-4386-course-project-clries/input_data/ukb_job_data.tsv')

map = read_tsv('/wdata/lcasten/ukbb/imaging/field.tsv')

to_match = names(jobdat)[str_detect(names(jobdat), pattern = '[0-9]')]
df_match = data.frame(original_variable = to_match) %>%
  mutate(num = str_sub(original_variable, start = 2, end = -1),
         num = str_split(num, pattern = '_', simplify = T)[,1],
         field_id = as.numeric(num))
map %>%
  inner_join(df_match) %>%
  view()


## sleep duration = p1160_i0
sleep_dat = full_dat %>%
  rename(IID = eid) %>%
  select(IID, p1160_i0) %>%
  mutate(sleep_duration_hours = as.numeric(p1160_i0)) %>%
  drop_na()

##
wd = risktol %>%
  inner_join(sleep_dat)
wd = wd %>%
  select(IID, pgs_name, resid_pgs, sleep_duration_hours) %>%
  filter(sleep_duration_hours >= 4 & sleep_duration_hours <= 10)
hist(wd$sleep_duration_hours)

cor.test(wd$sleep_duration_hours, wd$resid_pgs)
library(ggplot2)
ggplot(wd, aes(x = sleep_duration_hours, y = resid_pgs)) +
         geom_point()
       


#### different pheno #### lucas's example that I am not going to mess with
jobdat
length(unique(jobdat$job))
jobdat %>%
  count(job) %>% 
  arrange(desc(n))
## nursing vs risk
nurse = jobdat %>%
  mutate(nurse_binary = case_when(job == 'public service higher/senior executive officer, hospital administrator' ~ 1,
                                  TRUE ~ 0)
         ) %>%
  rename(IID = eid)
table(nurse$nurse_binary)

wd_nurse = risktol %>%
  inner_join(nurse)

wd_nurse %>%
  ggplot(aes(x = as.factor(nurse_binary), y = resid_pgs)) +
  geom_boxplot() +
  geom_hline(yintercept = 0, color = 'red')
t.test(wd_nurse$resid_pgs ~ wd_nurse$nurse_binary)  

## primary teacher vs risk (hs was not significant at all)
teach = jobdat %>%
  mutate(teach_binary = case_when(job == 'primary /junior school teacher or teaching professional, nursery school teacher (including head teacher)' ~ 1,
                                  TRUE ~ 0)
  ) %>%
  rename(IID = eid)
table(teach$teach_binary)

wd_teach = risktol %>%
  inner_join(teach)

wd_teach %>%
  ggplot(aes(x = as.factor(teach_binary), y = resid_pgs)) +
  geom_boxplot() +
  geom_hline(yintercept = 0, color = 'red')
t.test(wd_teach$resid_pgs ~ wd_teach$teach_binary) 

## cs vs risk
teach = jobdat %>%
  mutate(teach_binary = case_when(job == 'software professional, analyst-programmer, computer programmer, software analyst or engineer, systems designer or programmer' ~ 1,
                                  TRUE ~ 0)
  ) %>%
  rename(IID = eid)
table(teach$teach_binary)

wd_teach = risktol %>%
  inner_join(teach)

wd_teach %>%
  ggplot(aes(x = as.factor(teach_binary), y = resid_pgs)) +
  geom_boxplot() +
  geom_hline(yintercept = 0, color = 'red')
t.test(wd_teach$resid_pgs ~ wd_teach$teach_binary)  


## sales vs risk
teach = jobdat %>%
  mutate(teach_binary = case_when(job == 'sales or marketing manager/director, export/import manager, business development manager, advertising/commercial manager' ~ 1,
                                  TRUE ~ 0)
  ) %>%
  rename(IID = eid)
table(teach$teach_binary)

wd_teach = risktol %>%
  inner_join(teach)

wd_teach %>%
  ggplot(aes(x = as.factor(teach_binary), y = resid_pgs)) +
  geom_boxplot() +
  geom_hline(yintercept = 0, color = 'red')
t.test(wd_teach$resid_pgs ~ wd_teach$teach_binary) 

## clergy vs risk
clergy = jobdat %>%
  mutate(clergy_binary = case_when(job == 'clergyman/woman; any religious officer/leader' ~ 1,
                                  TRUE ~ 0)
  ) %>%
  rename(IID = eid)
table(clergy$clergy_binary)

wd_clergy = risktol %>%
  inner_join(clergy)

wd_clergy %>%
  ggplot(aes(x = as.factor(clergy_binary), y = resid_pgs)) +
  geom_boxplot() +
  geom_hline(yintercept = 0, color = 'red') +
  labs(title = 'Genetic Propensity for Risk Tolerance in Religious Leaders',
       x = 'Job', y = 'Risk Tolerance PGS') +
  theme(text = element_text(size = 25), axis.text = element_text(size = 20)) +
  scale_x_discrete(breaks=c('0','1'), labels=c('all jobs', 'religious leader'))
t.test(wd_clergy$resid_pgs ~ wd_clergy$clergy_binary) 

################################## a new pgs ################################################

