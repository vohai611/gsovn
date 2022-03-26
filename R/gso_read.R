#' Load data set from URL
#'
#' This function return a dataset retrieve from gso.gov.vn from user provided URL
#' @importFrom dplyr %>%

gso_read = function(url){
  #url = x$link[1]
# send request with no-SSL config
  conf = httr::config(ssl_verifypeer = FALSE)
  page = httr::with_config(conf, httr::GET(url))

# find the URL inside iframe
  url2 = page %>%
    rvest::read_html() %>%
    rvest::html_element('iframe') %>%
    rvest::html_attr("src")

# get the form
page2 = httr::with_config(conf, httr::GET(url2))
form = page2 %>%
  rvest::read_html() %>%
  rvest::html_form(base_url = url2) %>%
  .[[1]]

# scrape data to prepare form

option_count = page2 %>%
  rvest::read_html() %>%
  rvest::html_elements(".variableselector_valuesselect_statistics") %>%
  rvest::html_text() %>%
  stringr::str_extract("[0-9]*")

option_count = as.numeric(option_count[option_count != ""])

form_key  = paste0("ctl00$ContentPlaceHolderMain$VariableSelector1$VariableSelector1$VariableSelectorValueSelectRepeater$ctl0",
       seq_along(option_count),
       "$VariableValueSelect$VariableValueSelect$ValuesListBox")

form_value = lapply(option_count - 1, function(x) 0:x)
names(form_value)=  form_key

# write csv then read
#form_list = c(form_value, `ctl00$ContentPlaceHolderMain$VariableSelector1$VariableSelector1$OutputFormats$OutputFormats$OutputFormatDropDownList` = "FileTypeCsvWithoutHeadingAndComma")
#tmp_file = tempfile()
# writeLines(con = file(tmp_file))
# readLines(tmp_file) %>% tibble::tibble()

form_list = c(form_value, `ctl00$ContentPlaceHolderMain$VariableSelector1$VariableSelector1$OutputFormats$OutputFormats$OutputFormatDropDownList` = "tableViewLayout1")

form_set = rvest::html_form_set(form , !!!form_list)


result = rvest::html_form_submit(form_set,
                 submit =  "ctl00$ContentPlaceHolderMain$VariableSelector1$VariableSelector1$ButtonViewTable") %>%
  #httr::content(as = "text", encoding = "UTF-8")
  rvest::read_html()

title = result %>% rvest::html_element(".table-title") %>% rvest::html_text()

data = result %>%
  rvest::html_table() %>%
  .[[1]]
colnames(data) = data[1, ]
data= data[-1, ]

list(title = title, data= data)
}








# form_set = html_form_set(form,
#               `ctl00$ContentPlaceHolderMain$VariableSelector1$VariableSelector1$VariableSelectorValueSelectRepeater$ctl01$VariableValueSelect$VariableValueSelect$ValuesListBox` = 0:63,
#               `ctl00$ContentPlaceHolderMain$VariableSelector1$VariableSelector1$VariableSelectorValueSelectRepeater$ctl02$VariableValueSelect$VariableValueSelect$ValuesListBox` = 0:4,
#               `ctl00$ContentPlaceHolderMain$VariableSelector1$VariableSelector1$VariableSelectorValueSelectRepeater$ctl03$VariableValueSelect$VariableValueSelect$ValuesListBox` = 0:4,
#               `ctl00$ContentPlaceHolderMain$VariableSelector1$VariableSelector1$OutputFormats$OutputFormats$OutputFormatDropDownList` = "FileTypeCsvWithoutHeadingAndComma"
#               )
#





### create form



## submit form and read respond


## on.exit to close file connect (might be remove tmpfile)
