#' Retrieve available data set
#'
#' Get available data on https://www.gso.gov.vn/so-lieu-thong-ke/
#' @param lang Language of choices: Vietnamese or English
#' @importFrom dplyr %>%
#' @return A tibble contain all data set tittle and link to them from gso.gov.vn
#' @export

gso_avail = function(lang = c("vi", "en")){
  link = title = NULL
  lang = match.arg(lang)

  if (lang == "vi") {
    url = "https://www.gso.gov.vn/so-lieu-thong-ke/"
  } else {
    url = "https://www.gso.gov.vn/en/statistical-data/"
  }
  #on.exit(close(url(url, 'rb')), add = TRUE)

  # turn off SSL
  conf = httr::config(ssl_verifypeer = FALSE)

  elements = httr::with_config(conf, httr::GET(url)) %>%
    rvest::read_html() %>%
    rvest::html_elements("#content a")

  df = tibble::tibble(title = elements %>% rvest::html_text(),
              link = elements %>% rvest::html_attr("href")
  )  %>%
    dplyr::filter(stringr::str_detect(link, "https")) %>%
    dplyr::filter(!stringr::str_detect(title, "Thai Ha"))

  df = df %>%
    dplyr::mutate(title_clean =  stringi::stri_trans_general(title, id = "Latin - ASCII"))
  #%>%
    # dplyr::mutate(code = vapply(title, rlang::hash, character(1)),
    #               code= paste0(stringr::str_sub(title_clean, 1,2), stringr::str_sub(code, 1,5)),
    #               .before= title)

  df
}


