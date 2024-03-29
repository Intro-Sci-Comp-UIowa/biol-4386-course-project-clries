## DATA
Data was taken from the UK Biobank.
5,260 individuals--1402 creative, 694 non-creative.
Individuals were required to be employed in 2010 and have job satisfaction data in order to be included in the dataset.
The full data is included in pgs_sat_data.csv.
A subset of this data only including participants with jobs marked as creative or noncreative is included as dat_subset.csv, in order for important data to be 'beautiful and searchable' in github.

#### Data access
All job and job satisfaction data, as well as other participant data, can be downloaded from the UKBiobank with permissions. 
Unfortunately, PRS were calculated in-lab (by Taylor Thomas) and due to UK privacy laws cannot be published in full for access on this page.
See 'Methods' in the README.md file and the associated references to reproduce these PRS.

#### Creative vs. Non-creative careers
The list of UKB jobs defined as 'noncreative' is stored in noncreative_jobs.tsv.
The list of UKB jobs defined as 'creative' is stored in creative_jobs.csv.

#### Data Dictionary
* 'IID' is an individual identifier. It has been removed from this dataset for privacy.
* 'array' notes the individual's sequencing array placement.
* 'job' listed is the one held in 2010, when job satisfaction data was collected.
* 'start' describes the start year of the job listed. 
* 'creative' assigns score 1 for top creative jobs, -1 for least creative jobs, and 0 otherwise. 
* 'adj_pgs' is the individual's calculated polygenic risk score for Bipolar I or II.
* 'sexMale' defines male participants as 1 and female participants as 0.
* 'job_sat' provides a participant's level of job satisfaction:
    0-  Extremely unhappy
    1- Very unhappy
    2- Moderately unhappy
    3- Moderately happy
    4- Very happy
    5- Extremely happy
