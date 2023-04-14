##### analysis
# so we want two graphs. the first we want to compare pgs and job_sat for creative, the second for non-creative. (third for 0 to check)
# sex, start, array will be covariates

library(tidyverse)
dat = read_csv('/wdata/cries/career_proj/tmp/biol-4386-course-project-clries/pgs_sat_data.csv')

new_label = c('-1' = "Low creativity job", '1' = "High creativity job", '0' = 'Other')

dat %>% ggplot(aes(x = adj_pgs, y = job_sat)) +
  geom_jitter(alpha = 0.5, color = '#B2182B') + 
  geom_smooth(method = 'lm', color = '#2166AC') +
  facet_wrap(~creative, labeller = labeller(creative = new_label)) +
  labs(y = 'Job Satisfaction', x = 'Bipolar Disorder Polygenic Risk Score', title = 'Bipolar Risk and Job Satisfaction in Creative Careers') +
  theme_bw() +
  theme(strip.text = element_text(face = 'bold', size = 15), 
        plot.title = element_text(hjust = 0.5, size = 25),
        axis.title = element_text(size = 20),
        axis.text = element_text(size = 15))

create = dat %>%
  filter(creative == 1)

lm(job_sat ~ adj_pgs + sexMale + array + start, data = create)

bore = dat %>%
  filter(creative == -1)
lm(job_sat ~ adj_pgs + sexMale + array + start, data = bore)


medium = dat %>%
  filter(creative == 0)

lm(job_sat ~ adj_pgs + sexMale + array + start, data = medium)

#plot without 'other'
noother <- dat %>% filter(creative != 0)
noother %>% ggplot(aes(x = adj_pgs, y = job_sat)) +
  geom_jitter(alpha = 0.5, color = '#B2182B') + 
  geom_smooth(method = 'lm', color = '#2166AC') +
  facet_wrap(~creative, labeller = labeller(creative = new_label), scales = 'free_y') +
  labs(y = 'Job Satisfaction', x = 'Bipolar Disorder Polygenic Risk Score', title = 'Bipolar Risk and Job Satisfaction in Creative Careers') +
  theme_bw() +
  theme(strip.text = element_text(face = 'bold', size = 15), 
        plot.title = element_text(hjust = 0.5, size = 25),
        axis.title = element_text(size = 20),
        axis.text = element_text(size = 15))
