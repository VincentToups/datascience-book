.PHONY: clean

clean:
	rm -rf derived_data
	rm -rf figures

derived_data/voltages_long.csv figures/voltages.png: plot_voltages.R source_data/voltages_wide.csv
	Rscript plot_voltages.R


report.pdf: report.Rmd figures/voltages.png
	Rscript --vanilla -e "rmarkdown::render('report.Rmd', output_file = 'report.pdf', output_format = 'pdf_document')"
