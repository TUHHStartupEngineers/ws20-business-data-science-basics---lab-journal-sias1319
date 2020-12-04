library(data.table)

patent_tbl <- readRDS("./02_data_wrangling/patent.rds")
assignee_tbl <- readRDS("./02_data_wrangling/assignee.rds")
mainclass_tbl <- readRDS("./02_data_wrangling/mainclass.rds")
mainclass_current_tbl <- readRDS("./02_data_wrangling/mainclass_current.rds")
patent_assignee_tbl <- readRDS("./02_data_wrangling/patent_assignee.rds")
uspc_tbl <- readRDS("./02_data_wrangling/uspc.rds")

setkey(patent_tbl, id)
setkey(assignee_tbl, id)
setkey(mainclass_tbl, id)
setkey(mainclass_current_tbl, id)
setkey(patent_assignee_tbl, patent_id)
setkey(uspc_tbl, uuid)

