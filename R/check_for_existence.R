#' check_for_existence
#'
#' @name check_for_existence
#'
#' @export
#'
#' @param check_here A folder on your computer to save the PDFs to, for instance "/Desktop/arxiv"
#' @param the_dataset The tibble that has the URLs that you'll be getting and the full filenames
#' that you'd like to save them to.
#' @param the_column The column that contains the full filenames that you'd like
#' to save them to. This needs to be a character vector.
#'
#' @description The `check_for_existence` function looks at the folder that you're
#' going to save your PDFs to and checks whether you've already got any of them. It
#' then suggests that you filter to remove them.
#'
#' @examples
#' \dontrun{two_pdfs <-
#'  tibble::tibble(
#'   locations_are = c("https://osf.io/preprints/socarxiv/z4qg9/download",
#'     "https://osf.io/preprints/socarxiv/a29h8/download"),
#'   save_here = c("~/competing_effects_on_the_average_age_of_infant_death.pdf",
#'      "~/cesr_an_r_package_for_the_canadian_election_study.pdf")
#'    )
#'
#' heapsofpapers::get_and_save(
#' data = two_pdfs,
#' links = "locations_are",
#' save_names = "save_here"
#' )
#'
#' check_for_existence("~", two_pdfs, "save_here")
#'}
check_for_existence <-
  function(check_here, the_dataset, the_column){
    if (class(check_here) != "character") {
      stop("Please specify the path identifying the folder the pdfs are as a character.")
    }
    if (class(the_column) != "character") {
      stop("Please specify the column that contains the filepaths as a character.")
    }
    # Check what's already been downloaded
    already_got <- list.files(path = check_here, full.names = TRUE)

    the_dataset <-
      the_dataset %>%
      dplyr::mutate(got_this_already = dplyr::if_else(
        the_dataset[[the_column]] %in% already_got,
        1,
        0)
      )
    message <- paste0("You already have ", sum(the_dataset$got_this_already, na.rm = TRUE), " of these. Consider filtering before running `get_these_and_save_them()`")
    print(message)
    return(the_dataset)
  }
