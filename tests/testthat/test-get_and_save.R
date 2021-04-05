
test_that("get_and_save errors if passed a directory that doesn't exist", {
  # User specifies a directory that doesn't exist
  expect_error(
    heapsofpapers::get_and_save(data = two_pdfs,
                                save_names = "save_names",
                                dir = "baby_beluga_in_the_deep_blue_sea"),
    "The specified directory does"
    )
  }
  )

test_that("get_and_save errors if passed a character for print_every", {
  # Try changing the print message to a character
  expect_error(
    heapsofpapers::get_and_save(
      data = two_pdfs,
      links = "locations_are",
      save_names = "save_here",
      print_every = "swim_so_wild_and_you_swim_so_free"
      ),
    "The specified value to print_every"
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

  check_downloaded <- file.exists("./competing_effects_on_the_average_age_of_infant_death.pdf")
  file.remove("./competing_effects_on_the_average_age_of_infant_death.pdf")
  expect_equal(check_downloaded, TRUE)

}
)

