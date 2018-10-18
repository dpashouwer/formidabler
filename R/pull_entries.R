#' Pull Formidable Entries
#'
#' @param url website url
#' @param my_username Formidable Username
#' @param my_password Formidable Password
#' @param page_size Number of entries per page
#'
#' @return Returns the Formidable entries as a data frame.
#' @export
pull_entries <- function(url, my_username, my_password, page_size = 500){

  page <- 1

  r <- httr::GET(url = paste0(url, "entries?page_size=", page_size, "&page=", page), config = httr::authenticate(my_username, my_password)) %>%
    httr::stop_for_status(task = "pull data. Check url, username, and password.")

  all_entries <- r %>%
    httr::content("text") %>%
    jsonlite::fromJSON()

  message("Retrieved page: ", page)

  next_page <- TRUE

  while(next_page){

    page <- page + 1

    # pull data from website
    page_data <- httr::GET(url = paste0(url, "entries?page_size=", page_size, "&page=", page), config = httr::authenticate(my_username, my_password)) %>%
      httr::content("text") %>%
      jsonlite::fromJSON()

    # test if it's empty
    if(length(page_data) == 0){
      next_page <- FALSE
    } else {
      # make tbl_json
      all_entries <- dplyr::union(all_entries, page_data)

      message("Retrieved page: ", page)
    }
  }

  purrr::map_df(all_entries, collapse_list_item_to_df)
}

# collapse questions that have multiple selections
collapse_multi_selection <- function(x){
  if(length(x) > 1){
    x <- stringr::str_flatten(x, collapse = ", ")
  } else x
}

# make tibble
collapse_list_item_to_df <- function(x){
  x %>%
    purrr::flatten() %>%
    purrr::map(collapse_multi_selection) %>%
    purrr::flatten() %>%
    tibble::as_tibble()
}

