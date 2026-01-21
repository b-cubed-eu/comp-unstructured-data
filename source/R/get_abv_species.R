# First source functions in taxon_mapping.R
source(here::here("source", "R", "taxon_mapping.R"))

# Get species
example_specs <- c(
  "Cetti's zanger", "Putter", "Kleine mantelmeeuw", "Roek", "Kuifeend",
  "Halsbandparkiet", "Aalscholver", "Kauw", "Buizerd", "Nijlgans",
  "Roodborsttapuit", "Boomklever", "Meerkoet", "Zwarte roodstaart",
  "Grote bonte specht", "Roodborst", "Krakeend", "Boomleeuwerik",
  "Bonte vliegenvanger", "Grauwe gans", "Torenvalk", "Zwartkop",
  "Witte kwikstaart", "Boomkruiper", "Grasmus", "Pimpelmees", "Vink",
  "Boerenzwaluw", "Tjiftjaf", "Zwarte kraai", "Houtduif", "Kleine karekiet",
  "Fazant", "Gaai", "Groene specht", "Ekster", "Koolmees", "Gele kwikstaart",
  "Groenling", "Holenduif", "Winterkoning", "Scholekster", "Koekoek",
  "Heggenmus", "Spreeuw", "Turkse tortel", "Veldleeuwerik", "Geelgors",
  "Goudhaan", "Kuifmees", "Zilvermeeuw", "Matkop", "Huismus", "Wilde eend",
  "Waterhoen", "Zanglijster", "Merel", "Tuinfluiter", "Zwarte mees", "Patrijs",
  "Graspieper", "Fitis", "Stadsduif", "Wielewaal", "Grutto", "Kievit",
  "Grote lijster", "Ringmus", "Sprinkhaanzanger", "Kokmeeuw", "Sperwer",
  "Bruine kiekendief", "Fuut", "Gekraagde roodstaart", "Bergeend", "Kneu",
  "Rietzanger", "Blauwe reiger", "Wulp", "Blauwborst", "Zwarte specht",
  "Boompieper", "Rietgors", "Canadese gans", "Spotvogel", "Bosrietzanger",
  "Knobbelzwaan", "Havik", "Glanskop", "Middelste Bonte Specht", "Tafeleend",
  "Gierzwaluw", "Nachtegaal", "Huiszwaluw", "Staartmees", "Dodaars"
)
abv_ana_birds <- data.frame(
  id = seq_along(example_specs),
  dwc_vernacularName = example_specs,
  dwc_class = rep("Aves", 3)
)
abv_ana_birds

abv_birds <- map_taxa_from_vernacular(
  vernacular_name_df = abv_ana_birds,
  vernacular_name_col = "dwc_vernacularName",
  filter_cols = list(class = "dwc_class"),
  out_cols = "species",
  increment = 100
)
abv_birds

# Write out data
write.csv(abv_birds, "./data/processed/abv_birds.csv")
