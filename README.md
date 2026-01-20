<!-- badges: start -->
![GitHub](https://img.shields.io/github/license/b-cubed-eu/comp-unstructured-data)
[![repo status](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)
![GitHub repo size](https://img.shields.io/github/repo-size/b-cubed-eu/comp-unstructured-data)
[![funder](https://badgen.net/static/funder/European%20Union/f2a)](https://doi.org/10.3030/101059592)
<!-- badges: end -->

# Compare unstructured data

[Langeraert, Ward![ORCID logo](https://info.orcid.org/wp-content/uploads/2019/11/orcid_16x16.png)](https://orcid.org/0000-0002-5900-8109)[^aut][^cre][^INBO]
[Cartuyvels, Emma![ORCID logo](https://info.orcid.org/wp-content/uploads/2019/11/orcid_16x16.png)](https://orcid.org/0000-0001-7856-6360)[^aut][^INBO]
[Van Daele, Toon![ORCID logo](https://info.orcid.org/wp-content/uploads/2019/11/orcid_16x16.png)](https://orcid.org/0000-0002-1362-853X)[^aut][^INBO]
Research Institute for Nature and Forest (INBO)[^cph]
European Union's Horizon Europe Research and Innovation Programme (ID No 101059592)[^fnd]

[^cph]: copyright holder
[^fnd]: funder
[^aut]: author
[^cre]: contact person
[^INBO]: Research Institute for Nature and Forest (INBO), Herman Teirlinckgebouw, Havenlaan 88 PO Box 73, B-1000 Brussels, Belgium

**keywords**: structured data; data quality; unstructured data; data cubes; biodiversity informatics

<!-- community: b3 -->
<!-- community: inbo -->

<!-- description: start -->
Scripts to explore the conditions that determine the reliability of models, trends and status by comparing aggregated cubes with structured monitoring schemes.
<!-- description: end -->

This code is developed in context of **T4.5** of the [B-Cubed project](https://b-cubed.eu/).

### Analyses workflow
To download the latest version of each of the data sets run `prepare_abv_data.Rmd` and `Prepare_data_10km.Rmd`.
Alternatively, you can download the exact same data we used by following the GBIF links in these same Rmd's.
These data sets are saved under `data/raw`, the Rmd's further clean the data and add geometric properties.
The cleaned data is stored in both `.csv` and `.gpkg` format under `data/interim`.

To get the list of ABV birds used to filter the data in both pipelines run the `get_abv_species.R` after sourcing the functions in `taxon_mapping.R`.

To run the targets pipelines, run `run_pipeline.R` in the folder of the pipeline you want to run.
Afterwards, you can run the associated Rmd found under `reports`.


### Repo structure

```
├── source                         ├ 
│   ├── pipelines                  ├ target pipelines https://books.ropensci.org/targets/
│   ├── R                          ├ R scripts and R markdown files
│   └── reports                    ├ reports based on output from target pipelines
├── data
│   ├── raw                        ├ create this folder and store raw data, see prepare_abv_data.Rmd
│   ├── intermediate               ├ store intermediate data
│   └── processed                  ├ store processed data
├── checklist.yml                  ├ options checklist package (https://github.com/inbo/checklist)
├── organisation.yml               ├ organisation info (https://inbo.github.io/checklist/articles/organisation.html)
├── inst
│   └── en_gb.dic                  ├ dictionary with words that should not be checked by the checklist package
├── .github                        │ 
│   ├── workflows                  │ 
│   │   └── checklist_project.yml  ├ GitHub repo settings
│   ├── CODE_OF_CONDUCT.md         │ 
│   └── CONTRIBUTING.md            │
├── comp-unstructured-data.Rproj   ├ R project
├── README.md                      ├ project description
├── LICENSE.md                     ├ licence
├── LICENSE                        │
├── CITATION.cff                   ├ citation info
├── .zenodo.json                   ├ zenodo metadata
└── .gitignore                     ├ files to ignore
```
