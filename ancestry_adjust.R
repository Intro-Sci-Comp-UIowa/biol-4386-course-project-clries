library(tidyverse)
pc = read_tsv('/sdata/UK_Biobank/data_queries/genetic_pca.tab') %>% select(1:21)

files = list.files(path = '/wdata/cries/Fall_2022/LDPred2', recursive = TRUE, pattern = 'PGS', full.names = TRUE)
for (f in files) {
  message('working on file: ', f)
  
  cp1 = read_tsv(file = f)
  merged = inner_join(cp1, pc, by = c('IID' = 'f.eid'))
  merged = merged %>% mutate(resid_pgs = resid(lm(PGS ~ f.22009.0.1 + f.22009.0.2 + f.22009.0.3 + f.22009.0.4 + f.22009.0.5 + f.22009.0.6 + f.22009.0.7 + f.22009.0.8 + f.22009.0.9 + f.22009.0.10 + f.22009.0.11
                                                  + f.22009.0.12 + f.22009.0.13 + f.22009.0.14 + f.22009.0.15 + f.22009.0.16 + f.22009.0.17 + f.22009.0.18 + f.22009.0.19 + f.22009.0.20))) %>%
    mutate(resid_pgs = scale(resid_pgs)[,1])
#  hist(merged$PGS)
  hist(merged$resid_pgs)
  
  outfile = str_c(dirname(f), 'ancestry_adjusted_pgs.tsv')
  
  message('writing out file to: ', outfile)
  write_tsv(merged, file = outfile)
}


