## 0.1.0 Resubmission

### Review 1 - 2021-08-19

> Please add \value to .Rd files regarding exported methods and explain
> the functions results in the documentation. Please write about the
> structure of the output (class) and also what the output means. (If a
> function does not return a value, please document that too, e.g.
> \value{No return value, called for side effects} or similar)
> Missing Rd-tags:
>    check_for_existence.Rd: \value
>    get_and_save.Rd: \value

Added return value descriptions for both functions.

### Auto checks 2021-08-18

This is a resubmission. In this version I have:

* Changed two tests to not run on CRAN as they require downloading data.

## Test environments
* local R installation, R 4.0.3
* ubuntu 16.04 (on travis-ci), R 4.0.3
* win-builder (devel)

## R CMD check results

0 errors | 0 warnings | 1 note

* This is a new release.
