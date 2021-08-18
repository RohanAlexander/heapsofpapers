
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

  does_it_exist <- fs::dir_exists("baby_beluga_in_the_deep_blue_sea")

  fs::dir_delete("baby_beluga_in_the_deep_blue_sea")

  expect_true(does_it_exist)
  }
  )


test_that("check_for_existence identifies one file that already exists in directory", {

  skip_if_offline()
  skip_on_cran()

  one_pdf <-
    tibble::tibble(
      locations_are = c("https://osf.io/preprints/socarxiv/z4qg9/download"),
      save_here = c("competing_effects_on_the_average_age_of_infant_death.pdf"),
    )

  # Download a paper
  heapsofpapers::get_and_save(data = one_pdf,
                              links = "locations_are",
                              save_names = "save_here",
                              dir = "helen"
                              )

  # Check that it exists
  check_data <-
    heapsofpapers::check_for_existence(data = one_pdf,
                                       save_names = "save_here",
                                       dir = "helen"
                                       )

  # Test if the entry in the updated dataset is one
  should_be_one <-
    check_data$got_this_already[check_data$save_names_full_path == fs::path("helen", "competing_effects_on_the_average_age_of_infant_death.pdf")]

  fs::dir_delete("helen")

  expect_equal(should_be_one, 1)
}
)


test_that("check_for_existence identifies a file that already exists in a specified directory", {

  skip_if_offline()
  skip_on_cran()

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
    check_data$got_this_already[check_data$save_names_full_path == fs::path("put_it_here", "cesr_an_r_package_for_the_canadian_election_study.pdf")]

  fs::dir_delete("put_it_here")

  expect_equal(should_be_one, 1)
}
)
