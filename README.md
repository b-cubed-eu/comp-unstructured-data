# Compare unstructured data
Scripts to explore the conditions that determine the reliability of models, trends and status by comparing aggregated cubes with structured monitoring schemes.

## Repo structure

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
