#' Create a new lesson repo
#'
#' Use this function to start a brand new course based on the template available
#' at https://github.com/ines/course-starter-r/
#'
#' @param destdir - destination directory for creating the course repository.
#' It will be created as `course-starter-r`.
#'
#' @return new project as created by usethis::create_from_github
#' @export
#'
#' @examples
create_lesson_repo <- function(destdir = NULL) {
  usethis::create_from_github("ines/course-starter-r",destdir = destdir)
  ui_done("Course is now created. Please rename your project folder when you have a chance.")
}
