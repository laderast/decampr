get_last_exercise <- function(){

}

get_position_of_exercise <- function(){}


#' Add a new chapter file to your course
#'
#' @param chapter_name - the new chapter name, such as "chapter2.md"
#'
#' @return the new chapter file with YAML, which is saved in `chapters/`. RStudio
#' will open the file for editing.
#' @export
#'
#' @examples
add_chapter <- function(chapter_name){
  chapter_file_path <- here::here("chapters", chapter_name)
  if(file.exists(chapter_file_path)){
    stop("chapter already exists - you can use open_chapter('chapter.md') to open it")
  }

  yaml <- make_yaml_block(chapter_name, chapter_file_path = NULL)
  write(yaml, file=chapter_file_path,append = FALSE)
  open_chapter(chapter_name)

}

make_chapter_path <- function(chapter_number){


}

get_id_list <- function(chapter_file_name){
  chapter_file_path <- here::here("chapters",chapter_file_name)

  if(!file.exists(chapter_file_path)){
    stop("Chapter file doesn't exist yet - you can use add_chapter() to add one.")
  }
  chapter_text <- readr::read_file(chapter_file_path)

  id_regex <- 'codeblock\\sid=\\"([\\s\\S]*?)\\"'
  id_list <- decampr:::run_regex_match(chapter_text, id_regex)
  return(id_list[,2])
}

exercise_exists <- function(exercise_id){
  file_list <- make_exercise_path_files(exercise_id)

  exists_flag <- NULL

  if(file.exists(file_list$exercise_file)){
    exists_flag <- TRUE
  } else{
    exists_flag <- FALSE
  }
  return(exists_flag)
}

extract_numeric_id <- function(exercise_id){
  parse_regex <- "_([\\s\\S]*?)$"
  out_id <- decampr:::run_regex(exercise_id, parse_regex)
  out_id <- as.numeric(out_id)
  return(out_id)
}

init_exercise_block <- function(exercise_id,
                                title="Add your exercise title here"){
  parsed_id <- extract_numeric_id(exercise_id)

  begin_block <- glue::glue(
    '<exercise id="{parsed_id}" title="{title}">\n\n',
    'add exercise text here\n\n',
    '## Instructions\n\n\n',
    '<codeblock id="{exercise_id}">\n',
    exercise_id = exercise_id, parsed_id=parsed_id, title=title)

  finish_block <- "\n</codeblock>\n</exercise>\n\n"

  out_block <- paste0(begin_block, finish_block)
  out_block
}


#' Adds an exercise block to the end of a chapter
#'
#' @param chapter_file - name of the chapter, such as "chapter1.md"
#' without the path
#' @param exercise_id - id of the exercise, such as "01_03"
#'
#' @return - opened files including the chapter file, with the new
#' exercise/codeblock appended and the exercises opened
#' @export
#'
#' @examples
add_exercise <- function(chapter_file="chapter1.md", exercise_id = "01_01"){
  #if null, add the exercise text to the end of file
  chapter_file_path <- here("chapters", chapter_file)

  if(!file.exists(chapter_file_path)){
    stop("Your chapter file doesn't exist yet")
  }

  if(file.exists(chapter_file_path)){
    id_list <- get_id_list(chapter_file)
  }

  if(exercise_id %in% id_list){
    stop("Your id already exists in the chapter file")
  }

  exercise_block <- init_exercise_block(exercise_id)
  write(exercise_block, file=chapter_file_path, append = TRUE)

  open_chapter(chapter_file)
  cat(chapter_file, " is opened for editing")

  if(exercise_exists(exercise_id)){
      open_exercise(exercise_id)

  }else{
    open_exercise(exercise_id, create=TRUE)
    }

  cat(exercise_id, " exercises are now open for editing")

}
