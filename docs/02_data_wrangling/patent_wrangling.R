library(lubridate)

company_assigned_patent_tbl <- assignee_tbl[patent_assignee_tbl, on = c(id = "assignee_id")][type == 2]
company_assigned_patent_world <- assignee_tbl[patent_assignee_tbl, on = c(id = "assignee_id")][type == 2 | type == 3]

top_company_tbl <- company_assigned_patent_tbl[, .(numOfPatents = .N), by = organization][order(-numOfPatents)][1:10]

top_company_tbl

top_company_tbl_2019 <- patent_tbl[company_assigned_patent_tbl, on = c(number = "patent_id")][lubridate::year(date) == 2019][
                                      , .(numOfPatents = .N), by = organization][order(-numOfPatents)][1:10]
top_company_tbl_2019

top_company_world <- company_assigned_patent_world[, .(numOfPatents = .N), by = organization][order(-numOfPatents)][1:10]
top_company_world

top_company_patents <- company_assigned_patent_world[organization %in% top_company_world[,organization]]

top_uspc_id_tbl <- top_company_patents[uspc_tbl, on = c(patent_id = "patent_id"), nomatch=0][, 
                                      .(patentsPerCat = .N), by = mainclass_id][order(-patentsPerCat)][1:5]
top_uspc_tbl <- mainclass_current_tbl[top_uspc_id_tbl, on = c(id="mainclass_id")]

top_uspc_tbl

