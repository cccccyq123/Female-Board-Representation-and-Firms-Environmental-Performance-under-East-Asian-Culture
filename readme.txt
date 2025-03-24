Overview:
The code in this replication package constructs the analysis file from the six main data sources (Datastream, CSMAR, BoardEx, SNSI, Bloomberg, CNRDS) using Stata and Python. The bulk of the analysis and statistical output (i.e., output that constitutes figures and tables in the text) is performed in main_results.do. 
Tables in the supplementary materials are generated using supplementary_materials.do. Figures in the supplementary materials are generated using fig_s1.py and fig_s2.py.

Data availability and provenance statements:
The data used in this study are obtained from third-party proprietary databases and are subject to licensing restrictions. Due to confidentiality agreements and data usage policies, we are unable to publicly share the raw data. 
Researchers interested in accessing the data may contact the respective data providers for information on data availability and licensing terms.

Datasets mentioned in the following programs:
The file “international female sample data.dta” contains the complete dataset for the international sample, including environmental scores, company financial characteristics and board characteristics.
The file “Chinese female sample data.dta” contains the complete dataset for the Chinese sample, including environmental performance,  company financial characteristics and board characteristics.
The file “international female characteristics data.dta” contains personal characteristics of female directors from the United States, Europe and China.
The file “Chinese directors data.dta” contains personal characteristics of male and female directors in China.

Sources of datasets:
Data files                                                                   Source
intetnational female sample data.dta                                         Datastream
Chinese female sample data.dta                                               CSMAR, SNSI, Bloomberg, CNRDS
intetnational female characteristics data.dta                                BoardEx, CSMAR
Chinese directors data.dta                                                   CSMAR

Description of programs:
The programs in main_results.do create all the output required for tables in the text, except for Table1.
The programs in supplementary_materials.do create all the output required for tables in the supplementary materials, except for Table S1.
The programs in fig_s1.py create Fig S1 in the supplementary materials. 
The programs in fig_s2.py create Fig S2 in the supplementary materials.

Software requirements:
Stata (code was last run with version 17)
Python (code was last run with version 3.12.7)

Programs list:
The provided code reproduces tables and figures in the paper. All of the following files require confidential data.

Figure/Table                           		Program                                  	Line
Table2                                		main_results.do                          	15
Table3                                 		main_results.do                          	24
Table4                                 		main_results.do                          	35
Table5                                 		main_results.do                          	56
Table6                                 		main_results.do                          	73
Table7                                 		main_results.do                          	82
Table8                                 		main_results.do                          	87
Table9                                 		main_results.do                          	102
Table10                                		main_results.do                          	192
Table11                                		main_results.do                          	220
Endogeneity Concern Table1            	        supplementary_materials.do               	2
Endogeneity Concern Table2             	        supplementary_materials.do               	18
Table S2                               		supplementary_materials.do               	123
Table S3                               		supplementary_materials.do               	145
Table S4                               		supplementary_materials.do               	161
Table S5                               		supplementary_materials.do               	173
Fig S1                                 		fig_s1.py                                       31
Fig S2                                 		fig_s2.py                                	23