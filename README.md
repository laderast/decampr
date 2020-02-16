# decampr

<!-- badges: start -->
<!-- badges: end -->

`decampr` consists of some simple utilities to:

1. [**Start a course from scratch** ](https://laderast.github.io/decampr/articles/from_scratch.html) using [Ines Montani's Gatsby/Binder based course setup]( https://github.com/ines/course-starter-r) with some convenience functions to create and update content.
2. [**Process and convert R-based DataCamp lessons**](https://laderast.github.io/decampr/articles/converting-repo.html) to Ines Montani's Gatsby/Binder based course setup.

Note that I'm mostly focusing on use case #1 these days. 

## Installation

You can install the github version of `decampr` with:

``` r
install.packages("remotes")
remotes::install_github("laderast/decampr")
```

## Acknowledgements

Thank you so much to Ines Montani for making such a great alternative to DataCamp lessons. Also, thank you to Noam Ross for his [GAMs in R course](https://github.com/noamross/gams-in-r-course/), which helped me understand the structure of the lesson framework and how I needed to parse the DataCamp format.

## Contributing

Please note that the 'decampr' project is released with a [Contributor Code of Conduct](CODE_OF_CONDUCT.md). By contributing to this project, you agree to abide by its terms.

Note that I'm not a regular expression master and I don't have access to any DataCamp repositories other than my own online one here: http://github.com/laderast/RBootcamp_old. If you have an example chapter and would like to contribute it as a reproducible example, please add a PR and put it in `inst/extdata`. 

## License

Licensed with an MIT license.
