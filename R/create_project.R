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


#' Adds a data object to both the master and binder branch
#'
#' @param dataobj - a data object, usually a tibble or data.frame
#'
#' @return added and committed objects to both the binder and test branches
#' @export
#'
#' @examples
add_data_to_lesson <- function(dataobj){
  current_branch <- get_branch_head()

  #check and make sure we're on master first
  if(current_branch != "master"){
    git2r::checkout(branch="master")
  }

  data_obj_name <- deparse(substitute(dataobj))
  msg <- paste("Adding", data_obj_name, "to master branch")

  usethis::use_data(dataobj)
  git2r::commit(message=msg)

  git2r::checkout(branch = "binder")
  usethis::use_data(dataobj)

  msg <- paste("Adding", data_obj_name, "to binder branch")
  git2r::commit(message=msg)

  git2r::checkout(branch="master")
  usethis::ui_done("Added your object to both binder and master branches")
}

get_branch_head <- function(){
  branches <- git2r::branches(flags="local")
  branch_stat <- unlist(lapply(branches, git2r::is_head))
  head_branch <- names(which(branch_stat))
  return(head_branch)
}

test_exercise <- function(exercise_number){
  ex_files <- list.files("exercises",pattern = exercise_number)

  source_list <- sapply(ex_files, sources_correctly)
  names(source_list) <- ex_files

  failed_files <- names(which(source_list))

  ui_done("The following files did not run correctly")
}

#need function to source a file and return its error
#this is from https://stackoverflow.com/questions/5218945/using-trycatch-and-source
sources_correctly <- function(file)
{
  fn <- try(source(file))
  !inherits(fn, "try-error")
}
