library(vroom)
library(data.table)
col_types <- list(
  id = col_character(),
  type = col_skip(),
  number = col_character(),
  country = col_character(),
  date = col_date("%Y-%m-%d"),
  abstract = col_skip(),
  title = col_skip(),
  kind = col_skip(),
  num_claims = col_skip(),
  filename = col_skip(),
  withdrawn = col_skip()
)

patent_tbl <- vroom(
  file       = "./02_data_wrangling/patent.tsv", 
  delim      = "\t", 
  col_types  = col_types,
  na         = c("", "NA", "NULL")
)

setDT(patent_tbl)
saveRDS(patent_tbl,"./02_data_wrangling/patent.rds")

col_types <- list(
  id = col_character(),
  type = col_integer(),
  name_first = col_skip(),
  name_last = col_skip(),
  organization = col_character()
)

assignee_tbl <- vroom(
  file       = "./02_data_wrangling/assignee.tsv", 
  delim      = "\t", 
  col_types  = col_types,
  na         = c("", "NA", "NULL")
)

setDT(assignee_tbl)
saveRDS(assignee_tbl,"./02_data_wrangling/assignee.rds")

col_types <- list(
  id = col_character()
)

mainclass_tbl <- vroom(
  file       = "./02_data_wrangling/mainclass.tsv", 
  delim      = "\t", 
  col_types  = col_types,
  na         = c("", "NA", "NULL")
)

setDT(mainclass_tbl)
saveRDS(mainclass_tbl,"./02_data_wrangling/mainclass.rds")

col_types <- list(
  id = col_character(),
  title = col_character()
)

mainclass_current_tbl <- vroom(
  file       = "./02_data_wrangling/mainclass_current.tsv", 
  delim      = "\t", 
  col_types  = col_types,
  na         = c("", "NA", "NULL")
)

setDT(mainclass_current_tbl)
saveRDS(mainclass_current_tbl,"./02_data_wrangling/mainclass_current.rds")

col_types <- list(
  patent_id = col_character(),
  assignee_id = col_character(),
  location_id = col_character()
)

patent_assignee_tbl <- vroom(
  file       = "./02_data_wrangling/patent_assignee.tsv", 
  delim      = "\t", 
  col_types  = col_types,
  na         = c("", "NA", "NULL")
)

setDT(patent_assignee_tbl)
saveRDS(patent_assignee_tbl,"./02_data_wrangling/patent_assignee.rds")


col_types <- list(
  uuid = col_character(),
  patent_id = col_character(),
  mainclass_id = col_character(),
  subclass_id = col_character(),
  sequence = col_skip()
)

uspc_tbl <- vroom(
  file       = "./02_data_wrangling/uspc.tsv", 
  delim      = "\t", 
  col_types  = col_types,
  na         = c("", "NA", "NULL")
)

setDT(uspc_tbl)
saveRDS(uspc_tbl,"./02_data_wrangling/uspc.rds")



