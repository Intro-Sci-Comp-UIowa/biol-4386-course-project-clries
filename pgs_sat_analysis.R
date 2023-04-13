##### analysis
# so we want two graphs. the first we want to compare pgs and job_sat for creative, the second for non-creative. (third for 0 to check)
# sex, start, array will be covariates

library(tidyverse)
dat = read_csv('/wdata/cries/career_proj/tmp/biol-4386-course-project-clries/pgs_sat_data.csv')

dat %>% ggplot(aes(x = adj_pgs, y = job_sat)) +
  geom_point() + 
  geom_smooth(method = 'lm') +
  facet_wrap(~creative)

create = dat %>%
  filter(creative == 1)

lm(job_sat ~ adj_pgs + sexMale + array + start, data = create)

bore = dat %>%
  filter(creative == -1)
lm(job_sat ~ adj_pgs + sexMale + array + start, data = bore)


medium = dat %>%
  filter(creative == 0)

lm(job_sat ~ adj_pgs + sexMale + array + start, data = medium)
