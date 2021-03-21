#' get_these_and_save_them
#' @name get_and_save
#'
#' @export
#'
#' @param data A dataframe that contains URLs that you want to download and the names
#' that you want to save them as.
#' @param links The name of the column whose values should be the URLs that you
#' want to download, `link_pdf` by default.
#' @param save_names The name of the column whose values should be the saved
#' file names where the downloaded file will be saved, `id` by default.
#' @param dir The directory to download files to, defaults to current working directory.
#' @param bucket name of AWS S3 bucket to save files to.
#' @param delay The number of seconds to wait between downloads, default (and
#' minimum) is five seconds. We automatically add a bit of noise to lessen the effect
#' on systematic processes that might be otherwise working.
#'
#' @description The `get_and_save` function works with a tibble of
#' locations (usually URLs) and file names, and then downloads the PDF from the
#' location to the file name, saving as it goes, and letting you know where it's
#' up to. It politely waits around 7 seconds between calls to the
#' location, and skips locations that give an error.
#'
#' @examples
#' \dontrun{two_pdfs <-
#' tibble::tibble(
#'   locations_are = c("https://osf.io/preprints/socarxiv/z4qg9/download",
#'                     "https://osf.io/preprints/socarxiv/a29h8/download"),
#'   save_here = c("competing_effects_on_the_average_age_of_infant_death.pdf",
#'                 "cesr_an_r_package_for_the_canadian_election_study.pdf")
#' )
#'
#' heapsofpapers::get_and_save(
#' data = two_pdfs,
#' links = "locations_are",
#' save_names = "save_here"
#' )
#'}
get_and_save <-
  function(data, links = "links", save_names = "save_names", dir = ".", bucket = NULL, delay = 5){

    if (isFALSE(curl::has_internet())) {
      stop("The function get_and_save() needs the internet, but isn't able to find a connection right now.")
    }

    if (isFALSE(dir.exists(dir))){
      # dir.create(dir)
      stop("The specified directory does not exist. Please create it and then run get_and_save() again.")
    }

    if (delay < 5) {
      stop("It's respectful to wait between calls to the server. Please either leave
           blank (defaults to 5 seconds) or specify a value more than 5.")
    }

    # A has a check for PDF in the links column - that's a good idea, but limits the use - could ask the user to specific?
    # A has a check for PDF in the save_names column - that's a good idea, but limits the use - could ask the user to specify?

    for (i in 1:nrow(data)) {

        url <- data[i, links] %>% dplyr::pull()
        file_name <- data[i, save_names] %>% dplyr::pull()

        # if no bucket is specified, save to disk
        if (is.null(bucket)) {
          save_path <- file.path(dir, file_name)
          utils::download.file(url, save_path, mode = "wb")
        } else {
          # check system environment for s3 credentials
          if (nchar(Sys.getenv("AWS_ACCESS_KEY_ID")) < 16) {
            warning('AWS_ACCESS_KEY_ID environment variable not set. Use Sys.setenv("AWS_ACCESS_KEY_ID" = "your-key-here") to set the key ID.')
          }
          if (nchar(Sys.getenv("AWS_SECRET_ACCESS_KEY")) < 16) {
            warning('AWS_SECRET_ACCESS_KEY environment variable not set. Use Sys.setenv("AWS_SECRET_ACCESS_KEY" = "your-secret-key") to set the secret key.')
          }
          if(nchar(Sys.getenv("AWS_DEFAULT_REGION")) < 2) {
            warning('AWS_DEFAULT_REGION environment variable not set. Use Sys.setenv("AWS_DEFAULT_REGION" = "aws-region-name") to set the region.')
          }

          # check that the bucket is accessible with given credentials
          if (!aws.s3::bucket_exists(bucket)) {
            stop(paste0("Could not access ", bucket, ". Check bucket name and/or credentials."))
          }
          # write to s3 bucket
          aws.s3::s3write_using(url,
                                FUN = utils::download.file,
                                mode = "wb",
                                bucket = bucket,
                                object = file_name)
        }

        # Let the user know where it's up to
        message <- paste0("The file from ", url, " has been saved to ", save_path, " at ", Sys.time(), ".")
        print(message)

        # Pause before downloading the next paper
        if (i == nrow(data)) {
          print("All done!")
        } else {
        Sys.sleep(
          sample(x = c((delay):(delay+5)),
                 size = 1)
        )
        }
    }
  }

