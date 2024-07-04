<!-- badges: start -->
![GitHub](https://img.shields.io/github/license/b-cubed-eu/comp-unstructured-data)
[![repo status](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)
![GitHub repo size](https://img.shields.io/github/repo-size/b-cubed-eu/comp-unstructured-data)
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

<!-- community: b3; inbo -->

### Description
<!-- description: start -->
Scripts to explore the conditions that determine the reliability of models, trends and status by comparing aggregated cubes with structured monitoring schemes.
<!-- description: end -->

### Repo structure

```
├── source                         ├ R markdown files
│   └── scripts                    ├ R scripts
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
