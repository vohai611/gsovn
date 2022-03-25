#' Load data set from URL
#'
#' This function return a dataset retrieve from gso.gov.vn from user provided URL
#' @importFrom dplyr %>%


url = x$link[1]
conf = httr::config(ssl_verifypeer = FALSE)

page = httr::with_config(conf, httr::GET(url))
library(rvest)

url2 = page %>%
  read_html() %>%
  html_element('iframe') %>%
  html_attr("src")


page2 = httr::with_config(conf, httr::GET(url2))

choosen = page2 %>%
  read_html() %>%
  html_elements("option") %>%
  html_text2()


form = page2 %>%
  read_html() %>%
  html_form(base_url = url2) %>%
  .[[1]]

# form_set = html_form_set(form,
#               `ctl00$ContentPlaceHolderMain$VariableSelector1$VariableSelector1$VariableSelectorValueSelectRepeater$ctl01$VariableValueSelect$VariableValueSelect$ValuesListBox` = 0:63,
#               `ctl00$ContentPlaceHolderMain$VariableSelector1$VariableSelector1$VariableSelectorValueSelectRepeater$ctl02$VariableValueSelect$VariableValueSelect$ValuesListBox` = 0:4,
#               `ctl00$ContentPlaceHolderMain$VariableSelector1$VariableSelector1$VariableSelectorValueSelectRepeater$ctl03$VariableValueSelect$VariableValueSelect$ValuesListBox` = 0:4,
#               `ctl00$ContentPlaceHolderMain$VariableSelector1$VariableSelector1$OutputFormats$OutputFormats$OutputFormatDropDownList` = "FileTypeCsvWithoutHeadingAndComma"
#               )
#



# scrape data to prepare form

option_count = page2 %>% read_html() %>%
  html_elements(".variableselector_valuesselect_statistics") %>%
  html_text() %>%
  stringr::str_extract("[0-9]*")

option_count = as.numeric(option_count[option_count != ""])

### create form
library(purrr)

form_key  = paste0("ctl00$ContentPlaceHolderMain$VariableSelector1$VariableSelector1$VariableSelectorValueSelectRepeater$ctl0",
       seq_along(option_count),
       "$VariableValueSelect$VariableValueSelect$ValuesListBox")

form_value = map(option_count-1, ~ 0:.x)
names(form_value)=  form_key

form_list = c(form_value, `ctl00$ContentPlaceHolderMain$VariableSelector1$VariableSelector1$OutputFormats$OutputFormats$OutputFormatDropDownList` = "FileTypeCsvWithoutHeadingAndComma")

form_set = html_form_set(form , !!!form_list)

## submit form and read respond
tmp_file = tempfile()
html_form_submit(form_set,
                 submit =  "ctl00$ContentPlaceHolderMain$VariableSelector1$VariableSelector1$ButtonViewTable") %>%
  httr::content(as = "text",encoding = "UTF-8") %>%
  writeLines(con = file(tmp_file))

read.csv(tmp_file) %>% tibble::tibble() %>% janitor::clean_names()

## on.exit to close file connect (might be remove tmpfile)
