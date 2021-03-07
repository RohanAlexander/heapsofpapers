#' get_this_and_save_it
#'
#' @export
#'
#' @name get_this_and_save_it
#'
#' @param get_it_from_here A URL of a PDF.
#' @param put_it_here A location on your computer to save the PDF to.
#'
#' @description The `get_this_and_save_it` function works with one PDF, taking the URL
#' of where that PDF is saved - get_it_from_here - and saving it to your computer at the
#' location that you specify in put_it_here. It prints a status to let you know
#' that it's done.
#'
#' @examples
#' from_here  <- c("https://osf.io/preprints/socarxiv/z4qg9/download")
#' put_it_here  <- c("~/competing_effects_on_the_average_age_of_infant_death.pdf")
#'
#' get_this_and_save_it(from_here, put_it_here)
#'
get_this_and_save_it <-
  function(get_it_from_here, put_it_here){
    utils::download.file(get_it_from_here, put_it_here, mode = "wb")
    message <- paste0("Done with ", get_it_from_here, " at ", Sys.time())
    print(message)
    Sys.sleep(sample(x = c(5:10), size = 1))
  }

#' get_these_and_save_them
#' @name get_these_and_save_them
#'
#' @export
#'
#' @param get_them_from_here A bunch of URLs where the PDFs are, usually a column.
#' @param put_them_here A location on your computer to save the PDF to.
#'
#' @description The `download_pdfs` function works with one PDF takes a tibble of locations (usually
#' URLs) and file names, and then downloads the PDF from the location to the file
#' name, saving as it goes. It politely waits 10 seconds between calls to the
#' location, skips locations that give an error and (optionally) prints a status
#' message. It will also (optionally) let you know about any PDFs that are very
#' small (which usually indicates there's something wrong with them).
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
  function(get_them_from_here, put_them_here){
    purrr::walk2(get_them_from_here,
                 put_them_here,
                 purrr::safely(get_this_and_save_it))
    }
