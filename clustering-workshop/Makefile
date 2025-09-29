all: derived_data/power_grid_levels.csv \
     derived_data/power_grid_characters.csv \
     figures/records_per_character.png \
     logs/basic_observations.md \
     derived_data/power_grid_characters_imputed.csv \
     derived_data/clustered_characters.csv \
     derived_data/pca_projection.csv \
     derived_data/tsne_projection.csv \
     figures/pca_scatter.png \
     figures/pca_cumvar.png \
     figures/tsne_scatter.png \
     figures/tsne_clusters.png \
     figures/tsne_interactive.html

derived_data:
	mkdir -p derived_data

figures:
	mkdir -p figures

logs:
	mkdir -p logs

derived_data/power_grid_levels.csv: scrape_powergrid.py | derived_data
	python3 ./scrape_powergrid.py -o derived_data/power_grid_levels.csv --sleep 0.5

derived_data/power_grid_characters.csv: scrape_powergrid_characters.py derived_data/power_grid_levels.csv | derived_data
	python3 ./scrape_powergrid_characters.py -i derived_data/power_grid_levels.csv -o derived_data/power_grid_characters.csv --sleep 0.5


# Basic EDA before imputation
figures/records_per_character.png logs/basic_observations.md: basic_analysis.R derived_data/power_grid_characters.csv | figures logs
	Rscript ./basic_analysis.R

# Impute the wide-format character stats with missForest
derived_data/power_grid_characters_imputed.csv: impute_characters.R derived_data/power_grid_characters.csv | derived_data
	Rscript ./impute_characters.R

derived_data/clustered_characters.csv: cluster_characters.R derived_data/power_grid_characters_imputed.csv | derived_data
	Rscript ./cluster_characters.R

figures/pca_scatter.png figures/pca_cumvar.png derived_data/pca_projection.csv: pca_figs.R derived_data/clustered_characters.csv derived_data/power_grid_characters_imputed.csv | derived_data figures
	Rscript ./pca_figs.R

figures/tsne_scatter.png figures/tsne_clusters.png derived_data/tsne_projection.csv: tsne_figs.R derived_data/clustered_characters.csv derived_data/power_grid_characters_imputed.csv | derived_data figures
	Rscript ./tsne_figs.R

figures/tsne_interactive.html: tsne_plotly.R derived_data/tsne_projection.csv derived_data/power_grid_characters_imputed.csv derived_data/power_grid_characters.csv | figures
	Rscript ./tsne_plotly.R

clean:
	rm -rf derived_data figures

clear_cache:
	rm -rf http_cache

.PHONY: all clean clear_cache
