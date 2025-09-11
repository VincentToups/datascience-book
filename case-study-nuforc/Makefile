.PHONY: clean

clean:
	rm -rf figures
	rm -rf derived_data
	rm exploration.md

figures/time_diagnostics.png\
 figures/state_country_shape.png\
 derived_data/tidied_deduplicated.csv\
 exploration.md:\
  basic_exploration.R\
  source_data/nuforc_sightings.csv
	Rscript basic_exploration.R

derived_data/us_state_population_2024.csv: get_pop_data.R
	Rscript get_pop_data.R

figures/sightings_per_state_per_capita.png: derived_data/tidied_deduplicated.csv derived_data/us_state_population_2024.csv us_states_norm_pop.R
	Rscript us_states_norm_pop.R

