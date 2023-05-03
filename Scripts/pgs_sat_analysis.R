##### analysis
# so we want two graphs. the first we want to compare pgs and job_sat for creative, the second for non-creative. (third for 0 to check)
# sex, start, array will be covariates

library(tidyverse)

dat = read_csv('/wdata/cries/career_proj/tmp/biol-4386-course-project-clries/Data/pgs_sat_data.csv')

####### part 1: label jobs as non-creative and store in creative column as -1
### This couldn't be done in wrangle because I chose based on rows when calling unique to the completed data
non_creative = dat$job %>% unique() 
nc_vec <- c(3,23,29,32,53,58,59,61,62,75,77,82,91,106,113,118,119,121,134,101,154,159,162,163,165,174,187,191,193,196,198,206,223,228,237,241,245,
            249,250,251,253,258,267,273,274,278,286,299,302,306,314,347,362,367,370,382,385,394,397,398,400,405,407,413,425,427,433,438,451,470,486,492,496,89)
non_creative = non_creative[nc_vec]
###### save noncreative jobs to a file for github
data.frame("non_creative_jobs" = non_creative) %>% 
  write_csv('/wdata/cries/career_proj/tmp/biol-4386-course-project-clries/Data/noncreative_jobs.tsv')

dat2 <- dat %>%
  mutate(creative = case_when(job %in% non_creative ~ -1,
                              TRUE ~ creative)
         )
# see how many individuals fall under each job category
table(dat2$creative)
####### resave data files from wrangle with noncreative data
dat2 %>%
  select(-c(IID)) %>%
  filter(creative != 0) %>%
  write_csv('/wdata/cries/career_proj/tmp/biol-4386-course-project-clries/Data/dat_subset.csv')
dat2 %>%
  write_csv('/wdata/cries/career_proj/tmp/biol-4386-course-project-clries/Data/pgs_sat_data.csv')


### set up descriptive label for graph
new_label = c('-1' = "Low creativity job", '1' = "High creativity job", '0' = 'Other')

######### Part 2: creating the graph for all 3 job categories
dat2 %>% 
  mutate(job_sat_z = scale(job_sat)[,1]) %>%
  ggplot(aes(x = adj_pgs, y = job_sat_z)) +
  geom_jitter(alpha = 0.5, color = '#B2182B') + 
  geom_smooth(method = 'lm', color = '#2166AC') +
  geom_hline(yintercept = 0, color = 'chocolate1', linetype = 'dashed', size = 1.05) +
  facet_wrap(~creative, labeller = labeller(creative = new_label)) +
  labs(y = 'Job Satisfaction Z-Score', x = 'Bipolar Disorder Polygenic Risk Score', title = 'Bipolar Risk and Job Satisfaction in Creative Careers') +
  theme_bw() +
  theme(strip.text = element_text(face = 'bold', size = 15), 
        plot.title = element_text(hjust = 0.5, size = 25),
        axis.title = element_text(size = 18),
        axis.text = element_text(size = 15))

################ Part 3: creating the graph but only for noncreative and creative
noother <- dat2 %>% filter(creative != 0)

noother %>% 
  mutate(job_sat_z = scale(job_sat)[,1]) %>%
  ggplot(aes(x = adj_pgs, y = job_sat_z)) +
  geom_jitter(alpha = 0.5, color = '#B2182B') + 
  geom_smooth(method = 'lm', color = '#2166AC') +
  geom_hline(yintercept = 0, color = 'chocolate1', linetype = 'dashed', size = 1.05) +
  facet_wrap(~creative, labeller = labeller(creative = new_label)) +
  labs(y = 'Job Satisfaction Z-Score', x = 'Bipolar Disorder Polygenic Risk Score', title = 'Bipolar Risk and Job Satisfaction in Creative Careers') +
  theme_bw() +
  theme(strip.text = element_text(face = 'bold', size = 15), 
        plot.title = element_text(hjust = 0.5, size = 25),
        axis.title = element_text(size = 18),
        axis.text = element_text(size = 15))


###################### Part 4: analysis (not included in project)
#looking at linear model for creative jobs
create = dat2 %>%
  filter(creative == 1)
lm(job_sat ~ adj_pgs + sexMale + array + start, data = create)
#for non creative jobs
bore = dat2 %>%
  filter(creative == -1)
lm(job_sat ~ adj_pgs + sexMale + array + start, data = bore)
#for jobs that fit neither
medium = dat2 %>%
  filter(creative == 0)
lm(job_sat ~ adj_pgs + sexMale + array + start, data = medium)


# significance stats for jobsat/pgs and confounding variables
broom::tidy(lm(job_sat ~ adj_pgs * creative + sexMale + array + start, data = dat))
