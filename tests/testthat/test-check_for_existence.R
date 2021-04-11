
test_that("check_for_existence creates the directory if passed a directory that doesn't exist", {

  one_pdf <-
    tibble::tibble(
      locations_are = c("https://osf.io/preprints/socarxiv/z4qg9/download"),
      save_here = c("competing_effects_on_the_average_age_of_infant_death.pdf")
    )

  # User specifies a directory that doesn't exist
  heapsofpapers::check_for_existence(data = one_pdf,
                                     save_names = "save_here",
                                     dir = "baby_beluga_in_the_deep_blue_sea")

  does_it_exist <- dir.exists("baby_beluga_in_the_deep_blue_sea")

  unlink("baby_beluga_in_the_deep_blue_sea", recursive = TRUE)

  expect_equal(does_it_exist, TRUE)
  }
  )


test_that("check_for_existence identifies one file that already exists in directory", {

  dir_temp <- tempdir()

  one_pdf <-
    tibble::tibble(
      locations_are = c("https://osf.io/preprints/socarxiv/z4qg9/download"),
      save_here = c("competing_effects_on_the_average_age_of_infant_death.pdf"),
    )

  # Download a paper
  heapsofpapers::get_and_save(data = one_pdf,
                              links = "locations_are",
                              save_names = "save_here",
                              dir = dir_temp
                              )

  # Check that it exists
  check_data <-
    heapsofpapers::check_for_existence(data = one_pdf,
                                       save_names = "save_here",
                                       dir = dir_temp
                                       )

  # Test if the entry in the updated dataset is one
  should_be_one <-
    check_data$got_this_already[check_data$save_names_full_path == file.path(dir_temp, "competing_effects_on_the_average_age_of_infant_death.pdf")]

  expect_equal(should_be_one, 1)
}
)


test_that("check_for_existence identifies a file that already exists in a specified directory", {
  one_pdf <-
    tibble::tibble(
      locations_are = c("https://osf.io/preprints/socarxiv/a29h8/download"),
      save_here = c("cesr_an_r_package_for_the_canadian_election_study.pdf")
    )

  # Download a paper
  heapsofpapers::get_and_save(data = one_pdf,
                              links = "locations_are",
                              save_names = "save_here",
                              dir = "put_it_here"
  )

  # Check that it exists
  check_data <-
    heapsofpapers::check_for_existence(data = one_pdf,
                                       save_names = "save_here",
                                       dir = "put_it_here"
    )

  # Test if the entry in the updated dataset is one
  should_be_one <-
    check_data$got_this_already[check_data$save_names_full_path == "put_it_here/cesr_an_r_package_for_the_canadian_election_study.pdf"]

  unlink("put_it_here", recursive = TRUE)

  expect_equal(should_be_one, 1)
}
)
