#' check_for_existence
#'
#' @name check_for_existence
#'
#' @export
#'
#' @param data A dataframe that contains URLs that you want to download and the names
#' that you want to save them as.
#' @param save_names The name of the column whose values should be the saved
#' file names where the downloaded file will be saved, `save_names` by default.
#' @param dir The directory to download files to, current working directory by default.
#'
#' @description The `check_for_existence` function looks at the folder that you
#' are going to save your PDFs to and checks whether you have already got any of
#' them. It then suggests that you filter to remove them.
#'
#' @return The `data` dataframe with a column specifying whether the file has
#' been downloaded.
#'
#' @examples
#' \dontrun{two_pdfs <-
#'  tibble::tibble(
#'   locations_are = c("https://osf.io/preprints/socarxiv/z4qg9/download",
#'     "https://osf.io/preprints/socarxiv/a29h8/download"),
#'   save_here = c("competing_effects_on_the_average_age_of_infant_death.pdf",
#'      "cesr_an_r_package_for_the_canadian_election_study.pdf")
#'    )
#'
#' heapsofpapers::get_and_save(
#' data = two_pdfs,
#' links = "locations_are",
#' save_names = "save_here"
#' )
#'
#' heapsofpapers::check_for_existence(data = two_pdfs, save_names = "save_here")

#'}
#' @importFrom rlang .data
check_for_existence <-
  function(data, save_names = "save_names", dir = "heaps_of"){

    if (isFALSE(fs::dir_exists(dir))){
      ask <- utils::askYesNo("The specified directory does not exist. Would you like it to be created?")
      if (ask == TRUE){
        fs::dir_create(dir)
        } else {
          stop()
        }
      }

    # Check what has already been downloaded
    already_got <-
      fs::dir_ls(path = dir, recurse = TRUE)

    data <-
      data %>%
      dplyr::mutate(save_names_full_path =
                      fs::path(dir, .data[[save_names]])) %>%
      dplyr::mutate(got_this_already =
                      dplyr::if_else(
                        .data$save_names_full_path %in% already_got,
                        1,
                        0)
                    )

    already_got_this_number <- sum(data$got_this_already, na.rm = TRUE)

    if (already_got_this_number == 0) {
      message <- paste0("You do not have any of these.")
    } else (
      message <- paste0("You already have ", already_got_this_number, " of these. Consider filtering before running `get_and_save()` or running `get_and_save()` with dupe_strategy = 'ignore'.")
    )

    print(message)
    return(data)
  }
