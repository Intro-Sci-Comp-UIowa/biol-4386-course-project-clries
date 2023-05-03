## Scripts README
There are two scripts involved in this analysis.

#### 1. ukb_wrangle
* Defines job data as creative/else.
	* creates a csv file with 'creative' jobs for reference.
* Combines participant job data with PGS for BPD **and** job satisfaction data
	* excludes participants with missing data in any of these categories
* Assigns columns more descriptive names
* Assigns a numeric value to job satisfaction
* Creates "pgs_sat_data.csv" and "dat_subset.csv" (see data README)

#### 2. pgs_sat_analysis
* Defines job data as noncreative/else.
	* updates "pgs_sat_data.csv" and "dat_subset.csv"
	* creates a tsv file with 'noncreative' jobs for reference.
* Creates 2 linear regression graphs, one including and one excluding careers neither marked as creative nor noncreative.
	* see Results for these graphs
* Creates summary statistics for the linear models.
