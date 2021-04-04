
test_that("check_for_existence errors if passed a directory that doesn't exist", {
  # User specifies a directory that doesn't exist
  expect_error(
    heapsofpapers::check_for_existence(data = two_pdfs,
                                save_names = "save_names",
                                dir = "baby_beluga_in_the_deep_blue_sea"),
    "The specified directory does"
    )
  }
  )
