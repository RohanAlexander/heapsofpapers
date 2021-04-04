test_that("get_and_save errors if passed a directory that doesn't exist", {
  expect_error(heapsofpapers::check_for_existence(data = two_pdfs,
                                                  save_names = "save_names",
                                                  dir = "my_weird_folder")
               )
})

