
test_that("check_for_existence errors if passed a directory that doesn't exist", {
  two_pdfs <-
    tibble::tibble(
      locations_are = c("https://osf.io/preprints/socarxiv/z4qg9/download",
                        "https://osf.io/preprints/socarxiv/a29h8/download"),
      save_here = c("competing_effects_on_the_average_age_of_infant_death.pdf",
                    "cesr_an_r_package_for_the_canadian_election_study.pdf")
    )

  # User specifies a directory that doesn't exist
  expect_error(
    heapsofpapers::check_for_existence(data = two_pdfs,
                                save_names = "save_names",
                                dir = "baby_beluga_in_the_deep_blue_sea"),
    "The specified directory does"
    )
  }
  )
