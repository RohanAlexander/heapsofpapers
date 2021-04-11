
test_that("get_and_save creates the directory if it doesn't exist", {
  one_pdf <-
    tibble::tibble(
      locations_are = c("https://osf.io/preprints/socarxiv/z4qg9/download"),
      save_here = c("competing_effects_on_the_average_age_of_infant_death.pdf")
    )

  # User specifies a directory that doesn't exist
  heapsofpapers::get_and_save(data = one_pdf,
                              links = "locations_are",
                              save_names = "save_here",
                              dir = "baby_beluga_in_the_deep_blue_sea")

  does_it_exist <- dir.exists("baby_beluga_in_the_deep_blue_sea")

  unlink("baby_beluga_in_the_deep_blue_sea", recursive = TRUE)

  expect_equal(does_it_exist, TRUE)
  }
  )

test_that("get_and_save errors if passed a character for data or print_every", {
  one_pdf <-
    tibble::tibble(
      locations_are = c("https://osf.io/preprints/socarxiv/z4qg9/download"),
      save_here = c("competing_effects_on_the_average_age_of_infant_death.pdf")
    )

  # Try changing the print message to a character
  expect_error(
    heapsofpapers::get_and_save(
      data = one_pdf,
      links = "locations_are",
      save_names = "save_here",
      print_every = "swim_so_wild_and_you_swim_so_free"
      ),
    "The specified value to print_every"
    )

  # Try changing the print message to a character
  expect_error(
    heapsofpapers::get_and_save(
      data = "one_pdf",
      links = "locations_are",
      save_names = "save_here",
      print_every = 1
    ),
    "The specified value to data is not a data frame."
  )

  }
  )


test_that("get_and_save errors if not passed a character for links or save_names", {
  one_pdf <-
    tibble::tibble(
      locations_are = c("https://osf.io/preprints/socarxiv/z4qg9/download"),
      save_here = c("competing_effects_on_the_average_age_of_infant_death.pdf")
    )

  # Try changing the print message to a character
  expect_error(
    heapsofpapers::get_and_save(
      data = "one_pdf",
      links = "locations_are",
      save_names = "save_here",
      print_every = 1
    ),
    "The specified value to data is not a data frame."
  )

}
)


test_that("get_and_save downloads a paper if the circumstances are correct", {

  skip_if_offline()
  skip_on_cran()

  one_pdf <-
    tibble::tibble(
      locations_are = c("https://osf.io/preprints/socarxiv/z4qg9/download"),
      save_here = c("competing_effects_on_the_average_age_of_infant_death.pdf")
    )

  heapsofpapers::get_and_save(
    data = one_pdf,
    links = "locations_are",
    save_names = "save_here"
  )

  file_to_check_does_download <- file.path(".", "competing_effects_on_the_average_age_of_infant_death.pdf" )

  check_downloaded <- file.exists(file_to_check_does_download)
  file.remove(file_to_check_does_download)
  expect_equal(check_downloaded, TRUE)

}
)


test_that("get_and_save errors if you already have all the papers and dupe_strategy is 'ignore'", {

  skip_if_offline()
  skip_on_cran()

  one_pdf <-
    tibble::tibble(
      locations_are = c("https://osf.io/preprints/socarxiv/z4qg9/download"),
      save_here = c("competing_effects_on_the_average_age_of_infant_death.pdf")
    )

  heapsofpapers::get_and_save(
    data = one_pdf,
    links = "locations_are",
    save_names = "save_here"
  )

  expect_error(
    heapsofpapers::get_and_save(
      data = one_pdf,
      links = "locations_are",
      save_names = "save_here",
      dupe_strategy = "ignore"
    ),
    "There is nothing left to get. Possibly"
  )

  file_to_check_does_not_download_twice <- file.path(".", "competing_effects_on_the_average_age_of_infant_death.pdf" )

  file.remove(file_to_check_does_not_download_twice)

}
)


test_that("get_and_save ignores a PDF where the URL doesn't work but gets the other one.", {

  skip_if_offline()
  skip_on_cran()

  one_wrong_pdf <-
    tibble::tibble(
      locations_are = c("https://should_error",
                        "https://osf.io/preprints/socarxiv/a29h8/download"),
      save_here = c("should_error.pdf",
                    "cesr_an_r_package_for_the_canadian_election_study.pdf")
    )

  heapsofpapers::get_and_save(
    data = one_wrong_pdf,
    links = "locations_are",
    save_names = "save_here"
  )

  file_to_check_did_not_download <- file.path(".", "should_error.pdf" )

  check_did_not_download <- file.exists(file_to_check_did_not_download)
  if (check_did_not_download == TRUE) {
    file.remove(file_to_check_did_not_download)
  }

  expect_equal(check_did_not_download, FALSE)

  file_to_check_did_download <- file.path(".", "cesr_an_r_package_for_the_canadian_election_study.pdf" )

  check_downloaded <- file.exists(file_to_check_did_download)
  file.remove(file_to_check_did_download)

  expect_equal(check_downloaded, TRUE)

}
)
