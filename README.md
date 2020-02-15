# decampr

<!-- badges: start -->
<!-- badges: end -->

`decampr` consists of some simple utilities to:

1. Process and convert R-based DataCamp lessons to Ines Montani's Gatsby/Binder based course setup available here: https://github.com/ines/course-starter-r 
2. Start a course from scratch with some convenience functions to create and update content.

Note that I'm mostly focusing on use case #2 these days.

## Installation

You can install the github version of `decampr` with:

``` r
install.packages("remotes")
remotes::install_github("laderast/decampr")
```

## Using `decampr` to create a course repo from scratch

`decampr` assumes that your datacamp repo is local to your system.

The first thing to do is to use `decampr::create_course_repo()` to clone Ines' basic course repository to your computer:

```r
decampr::create_course_repo()
```

This will clone the `course-starter-r` repo to your computer (by default, it saves it to your Desktop) and open up a new project with your cloned repo.

Make sure to rename it and save it as a new project. Also, use `use_github()` to add it to GitHub, so you can serve the repository up to both your webhost and mybinder.org.

## Editing Individual Exercises

The `open_exercise()` function will open the exercises in Rstudio with a particular_id. For example, if I wanted to edit the `03_03` exercise, solutions, and prexercise code (which would be `exercises/exc_03_03.R`, `exercises/solution_03_03.R` and `exercises/preexercise_03_03.R`), I could use:

```r
open_exercise("03_03")
```

And edit windows for each of these files would pop up.

## Adding a new chapter file.

We've got you covered. You can use `add_chapter()` to initialize a new chapter file and open it automatically.

Say I wanted to add a new `chapter6.md` to my course. I can use

```r
add_chapter("chapter6.md")
```

And this file will be created, along with the relevant YAML to get the course to work.

I can then start adding exercises using the `add_exercise()` function (see below).

## Adding an exercise to the end of your chapter

If you want to expand on your work, there is another convenience function called `add_exercise()`:

```r
add_exercise("chapter1.md", "01_10")
```

Which will add a new set of HTML exercise tags for your exercise to your `chapter1.md` file, and will open this file for further editing. Furthermore, the exercise, solution, and pre-exercise files will be open.

Note that if you already have a codeblock with that id, function will return an error, preventing you from overwriting the files.

## TODO: add_multiple_choice()

Coming soon!

## TODO: add_slides()

Coming soon!

## Acknowledgements

Thank you so much to Ines Montani for making such a great alternative to DataCamp lessons. Also, thank you to Noam Ross for his [GAMs in R course](https://github.com/noamross/gams-in-r-course/), which helped me understand the structure of the lesson framework and how I needed to parse the DataCamp format.

## Contributing

Please note that the 'decampr' project is released with a [Contributor Code of Conduct](CODE_OF_CONDUCT.md). By contributing to this project, you agree to abide by its terms.

Note that I'm not a regular expression master and I don't have access to any DataCamp repositories other than my own online one here: http://github.com/laderast/RBootcamp_old. If you have an example chapter and would like to contribute it as a reproducible example, please add a PR and put it in `inst/extdata`. 

## License

Licensed with an MIT license.
