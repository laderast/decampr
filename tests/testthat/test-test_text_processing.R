library(here)
source(here("R/extract_chapters.R"))
chapter_file <- readr::read_file(here("inst/extdata/chapter1.md"))
chapter_file <- convert_to_unix_linebreaks(chapter_file)
exercise_list <- get_exercises(chapter_file)

test_that("converting to linux breaks", {
  expect_equal(convert_to_unix_linebreaks("test\r\n"), "test\n")
})

test_that("extract_exercise", {
  expect_equal(length(exercise_list), 9)
})

test_that("get_answer", {
  test_text <- "##run head on gap1992\nhead(gap1992)\n##run colnames here on gap1992\ncolnames(gap1992)\n##run nrow() on gap1992\nnrow(gap1992)"
  ex_text <- get_solution(exercise_list[[1]])
  expect_equal(test_text, ex_text)
})

test_that("get_hint", {
  hint_text <- get_hint(exercise_list[[2]])
  expect_equal("Look at the y-axis.\n\n", hint_text)
})

test_that("get_introduction", {
  introduction <- get_introduction(exercise_list[[3]])

})
