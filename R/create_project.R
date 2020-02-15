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


add_data_to_lesson <- function(dataobj){
  git2r::branches()
  usethis::use_data(dataobj)
  git2r::commit()
  git2r::checkout(branch = "binder")
  usethis::use_data(dataobj)
  data_obj_name <- deparse(substitute(dataobj))
  git2r::commit(message=paste("Adding", data_obj_name, "to binder branch")))
  usethis::ui_done("")
}

test_exercise <- function(exercise_number){

  source()
}
