# correlation 0.3.0

## Changes

- Improved documentation (#45, #63)

## Bug fixes


# correlation 0.2.0

## Changes

- Some changes were made.

## Bug fixes

- Some bugs were fixed.

# correlation 0.1.0

## Changes

- Initial CRAN release.
- Add `plot()`-method for `summary()`.

## Bug fixes

- Fixed issue in `correlation()` for some edge cases when `include_factors = TRUE`.
- Fixed issue in `correlation()` for correlation coefficients with less than four complete pairs of observations (in such cases, `cor_test()` now returns `NA` for the confidence intervals).
