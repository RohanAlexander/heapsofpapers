#' get_this_and_save_it
#'
#' @name get_this_and_save_it
#'
#' @export
#'
#' @param get_it_from_here A URL of a PDF.
#' @param put_it_here A location on your computer to save the PDF to.
#' @param pause_for_this_many_seconds Wait this many seconds between calls. If
#' not specified then defaults to 7 seconds. The value cannot be less than 7.
#'
#' @description The `get_this_and_save_it` function works with one PDF, taking the URL
#' of where that PDF is saved - get_it_from_here - and saving it to your computer at the
#' location that you specify in put_it_here. It prints a status to let you know
#' that it's done.
#'
#' @examples
#' from_here  <- "https://osf.io/preprints/socarxiv/z4qg9/download"
#' put_it_here  <- "~/competing_effects_on_the_average_age_of_infant_death.pdf"
#'
#' get_this_and_save_it(from_here, put_it_here)
#'
get_this_and_save_it <-
  function(get_it_from_here, put_it_here, pause_for_this_many_seconds = 7){
    utils::download.file(get_it_from_here, put_it_here, mode = "wb")
    message <- paste0("Done with ", get_it_from_here, " at ", Sys.time())
    print(message)
    Sys.sleep(
      sample(x = c((pause_for_this_many_seconds-3):(pause_for_this_many_seconds+3)),
             size = 1)
      )
  }

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
#' two_pdfs <-
#'  tibble::tibble(
#'   locations_are = c("https://osf.io/preprints/socarxiv/z4qg9/download",
#'     "https://osf.io/preprints/socarxiv/a29h8/download"),
#'   save_here = c("~/competing_effects_on_the_average_age_of_infant_death.pdf",
#'      "~/cesr_an_r_package_for_the_canadian_election_study.pdf")
#'    )
#' get_these_and_save_them(two_pdfs$locations_are, two_pdfs$save_here)
#'
#' check_for_existence("~", two_pdfs, "save_here")
#'
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


#' get_these_and_save_them
#' @name get_these_and_save_them
#'
#' @export
#'
#' @param get_them_from_here A column of URLs from a tibble in character format.
#' @param put_them_here_as_this A column of filenames from a tibble that includes the full
#'  path, in character format, that specify where and what you would like to save
#'  the PDF as.
#' @param wait_this_long integer, that indicates the number of seconds to wait
#' between the requests. Automatically adds a bit of noise to lessen the effect
#' on systematic processes that might be otherwise working.
#'
#' @description The `get_these_and_save_them` function works with a tibble of
#' locations (usually URLs) and file names, and then downloads the PDF from the
#' location to the file name, saving as it goes, and letting you know where it's
#' up to. It politely waits around 7 seconds between calls to the
#' location, and skips locations that give an error.
#'
#' @examples
#' two_pdfs <-
#'  tibble::tibble(
#'   locations_are = c("https://osf.io/preprints/socarxiv/z4qg9/download",
#'     "https://osf.io/preprints/socarxiv/a29h8/download"),
#'   save_here = c("~/competing_effects_on_the_average_age_of_infant_death.pdf",
#'      "~/cesr_an_r_package_for_the_canadian_election_study.pdf")
#'    )
#' get_these_and_save_them(two_pdfs$locations_are, two_pdfs$save_here)
#'
get_these_and_save_them <-
  function(get_them_from_here, put_them_here_as_this, wait_this_long = 7){
    if (wait_this_long < 7) {
      stop("It's respectful to wait between calls to the server. Please either leave
           blank (defaults to 7 seconds) or specify a value more than 7.")
    }
    purrr::pwalk(list(get_them_from_here,
                      put_them_here_as_this,
                      wait_this_long),
                 purrr::safely(get_this_and_save_it))
    }
