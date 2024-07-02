<!-- badges: start -->
![GitHub](https://img.shields.io/github/license/b-cubed-eu/comp-unstructured-data)
![GitHub repo size](https://img.shields.io/github/repo-size/b-cubed-eu/comp-unstructured-data)
<!-- badges: end -->

# Compare unstructured data

<!-- spell-check: ignore:start -->
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
<!-- spell-check: ignore:end -->

**keywords**: structured data; data quality; unstructured data; data cubes; biodiversity informatics

<!-- community: inbo -->

### Description
<!-- description: start -->
Scripts to explore the conditions that determine the reliability of models, trends and status by comparing aggregated cubes with structured monitoring schemes.
<!-- description: end -->

### Repo structure

```bash
├── source                         ├ markdown and R files (see order of execution)
│
├── data
│   ├── raw                        ├ create this folder and store raw data if at your disposal
│   ├── intermediate               ├ will be created in step 1 or 2 (see order of execution)
│   └── processed                  ├ will be created in step 2, 3, 4 or 5 (see order of execution)
├── output                         ├ folder to store outputs (will be created in step 4, 5 or 6)
├── media                          ├ folder to store media (will be created in step 6)
├── checklist.yml                  ├ options checklist package (https://github.com/inbo/checklist)
├── inst
│   └── en_gb.dic                  ├ dictionary with words that should not be checked by the checklist package
├── .github                        │ 
│   ├── workflows                  │ 
│   │   └── checklist_project.yml  ├ GitHub repo settings
│   ├── CODE_OF_CONDUCT.md         │ 
│   └── CONTRIBUTING.md            │
├── macro-moths-msci.Rproj         ├ R project
├── README.md                      ├ project description
├── LICENSE.md                     ├ licence
├── CITATION.cff                   ├ citation info
├── .zenodo.json                   ├ zenodo metadata
└── .gitignore                     ├ files to ignore
```
