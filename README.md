
<!-- README.md is generated from README.Rmd. Please edit that file -->

# heapsofpapers

<!-- badges: start -->
<!-- badges: end -->

The goal of `heapsofpapers` is to make it really easy to politely get,
well, heaps of papers. For instance, you may want to understand the
state of open code and open data across a bunch of different pre-print
repositories, e.g. Collins and Alexander, 2021. In that case you need a
way to quickly get heaps of papers.

Essentially the main function in the package is a wrapper around
`purrr::walk2` and `utils::download.file`, but there are a bunch of
small things that make it handy to use instead of rolling your own each
time. For instance, the package automatically slows down your requests
by 5-10 seconds, it also prints where it is up to.

## Installation

You can `heapsofpapers` from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("RohanAlexander/heapsofpapers")
```

## Example

Here is an example of getting two papers from socarxiv:

``` r
library(heapsofpapers)
two_pdfs <-
  tibble::tibble(
    locations_are = c("https://osf.io/preprints/socarxiv/z4qg9/download",
                      "https://osf.io/preprints/socarxiv/a29h8/download"),
    save_here = c("~/competing_effects_on_the_average_age_of_infant_death.pdf",
                  "~/cesr_an_r_package_for_the_canadian_election_study.pdf")
    )

heapsofpapers::get_these_and_save_them(two_pdfs$locations_are, two_pdfs$save_here)
```

## Roadmap

-   Make the length of the pause dependent on the size of the file that
    is downloaded, by default. Allow the user to specify how long they
    would like to wait.
-   Make the printing of the message again optional, or every X or
    similar, as specified by the user.

## Citation

Please cite the package if you use it: Alexander, Rohan, and Annie
Collins, 2021, ‘heapsofpapers: Easily get heaps of papers’ 6 March,
<https://github.com/RohanAlexander/heapsofpapers>.
