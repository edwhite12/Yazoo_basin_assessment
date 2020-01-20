# Yazoo_basin_assessment
 data processing scripts and Excel plots for Yazoo Watershed Assessment project - RCSE-6840 - Spring 2019

.\assessment\
This directory contains raw data download files, files used for mapping in Google Earth, and the final report documents.
There are also Excel files which used formatted USGS data to plot a variety of data in various formats (timeseries, histograms, box-whisker)
R scripts that processed the raw data to be imported to these Excel files are saved in a different directory called 'inventory'.

.\inventory\
This directory stores all R scripts that were developed for downloading and formatting the USGS data.

.\inventory\nwis_inventory_dv.R 
This script writes a summary table for each site that counts the number of data points and calculates some basic statistics. The output summary tables are saved in …\daily_data\flow

.\inventory\nwis_inventory_dv_compile.R
This script combines the count values from each of the summary tables and writes a master output file. The output table can then be added to the Yazoo_River_basin_daily_data_inventory.xlsx Excel file in \inventory_plots to build the graphs.

.\inventory\nwis_inventory_qw.R
This builds the summary tables for each parameter group of the water quality data at each site. These output tables can then be added to the Yazoo_River_basin_daily_data_inventory.xlsx Excel file.


.\Rwd\
Working directory used by the R scripts to store temporary files
