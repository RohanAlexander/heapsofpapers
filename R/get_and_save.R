#' get_these_and_save_them
#' @name get_and_save
#'
#' @export
#'
#' @param data A dataframe that contains URLs that you want to download and the names
#' that you want to save them as.
#' @param links The name of the column whose values should be the URLs that you
#' want to download, `links` by default.
#' @param save_names The name of the column whose values should be the saved
#' file names where the downloaded file will be saved, `save_names` by default.
#' @param dir The directory to download files to, current working directory by default.
#' @param bucket name of AWS S3 bucket to save files to.
#' @param delay The number of seconds to wait between downloads, default (and
#' minimum) is five seconds. We automatically add a bit of noise to lessen the effect
#' on systematic processes that might be otherwise working.
#' @param print_every The default is that you get a print message for every file, but
#' you can change this. If you want to print an update for every second file then
#' set this equal to 2, for a printed update every tenth file, set it to 10, etc.
#' @param dupe_strategy There are a variety of ways of dealing with the situation where
#' you already have some of the files downloaded. By default the function will just get
#' them again and overwrite. However you can also specify 'ignore' in which case those
#' files will be ignored. You can also investigate duplicates yourself using
#' heapsofpapers::check_for_existence().
#'
#' @return A print statement in the console about whether each of the `links` was
#' saved (if not turned off by the user), and notification that the function has
#' finished.
#'
#' @description The `get_and_save` function works with a tibble of
#' locations (usually URLs) and file names, and then downloads the PDF from the
#' location to the file name, saving as it goes, and letting you know where it is
#' up to. It politely waits around 5 seconds between calls to the
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
#' @importFrom rlang .data
get_and_save <-
  function(data, links = "links", save_names = "save_names", dir = "heaps_of", bucket = NULL, delay = 5, print_every = 1, dupe_strategy = "overwrite"){

    if (isFALSE(curl::has_internet())) {
      stop("The function get_and_save() needs the internet, but isn't able to find a connection right now.")
    }

    if (!is.data.frame(data)){
      stop("The specified value to data is not a data frame.")
    }

    if (!is.character(save_names)){
      stop("The specified value to save_names is not a character.")
    }

    if (isFALSE(fs::dir_exists(dir))){
      ask <- utils::askYesNo("The specified directory does not exist. Would you like it to be created?")

      if (ask == TRUE){
        fs::dir_create(dir)
      } else {
      stop()
      }
    }

    if (delay < 1) {
      stop("Please consider waiting longer between calls to the server by leaving 'delay' blank (defaults to 5 seconds) or specifying a value that is at least 1.")
    }

    if (!is.numeric(print_every)){
      stop("The specified value to print_every is not a number - please either leave blank or specify a number.")
    }

    if (dupe_strategy == "ignore") {
      data <-
        heapsofpapers::check_for_existence(data = data,
                                           save_names = save_names,
                                           dir = dir)
      data <- data %>%
        dplyr::filter(.data$got_this_already == 0) %>%
        dplyr::select(-.data$save_names_full_path, -.data$got_this_already)
    }

    if (nrow(data) == 0) {
      stop("There is nothing left to get. Possibly all the files already exist in the directory.")
    }

    for (i in 1:nrow(data)) {

        url <- data[i, ] %>% dplyr::pull(links)
        file_name <- data[i, ] %>% dplyr::pull(save_names)

        # If no bucket is specified, save to disk
        if (is.null(bucket)) {

          save_path <- fs::path(fs::path_real(dir), file_name)

          tryCatch(utils::download.file(url, save_path, method = "auto", mode = "wb", quiet = TRUE),
                   error = function(e) print(paste(url, 'Did not download'))) %>%
            suppressWarnings()
          } else {
            # Check system environment for s3 credentials
            if (nchar(Sys.getenv("AWS_ACCESS_KEY_ID")) < 16) {
              warning('AWS_ACCESS_KEY_ID environment variable not set. Use Sys.setenv("AWS_ACCESS_KEY_ID" = "your-key-here") to set the key ID.')
              }
            if (nchar(Sys.getenv("AWS_SECRET_ACCESS_KEY")) < 16) {
              warning('AWS_SECRET_ACCESS_KEY environment variable not set. Use Sys.setenv("AWS_SECRET_ACCESS_KEY" = "your-secret-key") to set the secret key.')
              }
            if(nchar(Sys.getenv("AWS_DEFAULT_REGION")) < 2) {
              warning('AWS_DEFAULT_REGION environment variable not set. Use Sys.setenv("AWS_DEFAULT_REGION" = "aws-region-name") to set the region.')
              }
            # Check that the bucket is accessible with given credentials
            if (!aws.s3::bucket_exists(bucket)) {
              stop(paste0("Could not access ", bucket, ". Check bucket name and/or credentials."))
              }
            # Write to s3 bucket
            aws.s3::s3write_using(url,
                                  FUN = utils::download.file,
                                  mode = "wb",
                                  bucket = bucket,
                                  object = file_name)
            }

        # Let the user know where it is up to
        # Check if the file downloaded:
        got_file <- fs::file_exists(save_path)
        if (got_file == TRUE) {
          message <- paste0("The file from ", url, " has been saved to ", save_path, " at ", Sys.time(), ". You are done with ", scales::percent(i / nrow(data)), ".")
        } else {
          message <- paste0("The file from ", url, " was not saved at ", Sys.time(), ". It was meant to save to ", save_path,".  You are done with ", scales::percent(i / nrow(data)), ".")
        }

        if (i%%print_every == 0) {
          print(message)
        }

        # Pause before downloading the next paper
        if (i == nrow(data)) {
          # No need to pause after the last file
          print("All done!")
        } else if (got_file == FALSE) {
          # No need to pause if the file was not downloaded
          Sys.sleep(0)
        } else {
        Sys.sleep(
          sample(x = c((delay):min(delay*2,(delay+5))),
                 size = 1)
        )
        }
    }

  }

