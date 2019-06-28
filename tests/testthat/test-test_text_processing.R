library(here)
#source(here("R/extract_chapters.R"))
chapter_file <- readr::read_file(system.file("extdata/chapter1.md", package="decampr"))
chapter_file <- decampr:::convert_to_unix_linebreaks(chapter_file)
exercise_list <- get_exercises(chapter_file)
exercise_text <- "## Thinking about aesthetics\nNow that we've learned a little about the `data.frame`, we can get to the fun part: making graphs.\n\nThe first thing we are going to is think about how we represent variables in a plot. \n\nHow do we visually represent a variable in our dataset? Take a look at this graph. What variable is mapped to `y`, and what is mapped to `x`, and what is mapped to `color`?\n\n***=pre_exercise_code\n```{r}\nlibrary(dplyr)\nlibrary(gapminder)\nlibrary(ggplot2)\ngap1992 <- gapminder %>% filter(year == 1992)\n\nggplot(gap1992, aes(x = log(gdpPercap), y = lifeExp, size=pop, color=continent)) +\n  geom_point() + ggtitle(\"Gapminder for 1992\")\n```\n\n*** =instructions\n- x = gdpPercap, y = log(lifeExp), color = continent\n- x = continent, y = year, color = pop\n- y = lifeExp, x = log(gdpPercap), color = continent\n\n*** =hint\nLook at the y-axis.\n\n*** =sct\n```{r}\nmsg1 = \"You have things reversed, and you're taking the log of the wrong variable\"\nmsg2 = \"Wrong variables. Go back and look at what's being mapped\"\nmsg3 = \"Correct! We are displaying lifeExp as our y variable and log(gdpPercap) as our x variable\"\n\ntest_mc(correct = 3, feedback_msgs=c(msg1, msg2, msg3))\n```"

test_that("converting to linux breaks", {
  expect_equal(convert_to_unix_linebreaks("test\r\n"), "test\n")
})

test_that("get_exercises", {
  exercise_list <- get_exercises(chapter_file)
  expect_equal(length(exercise_list), 9)
})

test_that("get_answer", {
  test_text <- "##run head on gap1992\nhead(gap1992)\n##run colnames here on gap1992\ncolnames(gap1992)\n##run nrow() on gap1992\nnrow(gap1992)"
  ex_text <- get_solution(exercise_list[[1]])
  expect_equal(test_text, ex_text)
})

test_that("get_hint", {
  hint_text <- get_hint(exercise_list[[2]])
  expect_equal("Look at the y-axis.", hint_text)

  hint_text <- "*** =instructions\nJust move on to the next exercise! (CTRL+K)\n*** =hint\n\n*** =pre_exercise_code"
  ex_text <- decampr:::get_hint(hint_text)
  expect_equal(length(ex_text), 0)
})


intro <- "Now that we've learned a little about the `data.frame`, we can get to the fun part: making graphs.\n\nThe first thing we are going to is think about how we represent variables in a plot. \n\nHow do we visually represent a variable in our dataset? Take a look at this graph. What variable is mapped to `y`, and what is mapped to `x`, and what is mapped to `color`?"

test_that("get_introduction", {
  introduction <- get_introduction(exercise_text)
  expect_equal(introduction, intro)
})

test_that("extract_multiple_exercise",{
          mult <- extract_multiple_exercise(exercise_list[[2]])
          expect_equal(mult$title, "Thinking about aesthetics")
          expect_equal(length(mult), 6)
          expect_equal(mult$type, "Multiple")
          })

test_that("extract_normal_exercise",{
          norm <- extract_normal_exercise(exercise_list[[5]])
          expect_equal(norm$title, "Points versus lines")
          expect_equal(norm$type, "Normal")

})

test_that("number_ex_list", {
  ex_list <- parse_exercise_list(exercise_list)
  ex_list <- number_ex_list(ex_list, "01")
  expect_equal(names(ex_list)[1], "01_01")
})

test_that("make_yaml_block", {
  out <- make_yaml_block("chapter1.md", system.file("extdata/chapter1.md", package="decampr"))
})


