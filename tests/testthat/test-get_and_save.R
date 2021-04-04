
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
