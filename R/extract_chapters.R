#' @export
convert_to_unix_linebreaks <- function(text){

  gsub("\r", "", text)

}

#' @importFrom magrittr %>%
run_regex <- function(text, regex){

  stringr::str_match_all(string = text, regex)[[1]] %>%
    data.frame() %>% dplyr::pull(X2) %>% as.character()
}

#' @importFrom magrittr %>%
run_regex_match <- function(text, regex){
  stringr::str_match_all(string=text, regex)[[1]]

}

get_title <- function(text){
  title_regex <- "## ([\\s\\S]*?)\n"
  run_regex(text, title_regex)
}

get_introduction <- function(text){
  introduction_regex <- "## .+\n([\\s\\S]*?)\n*\\*\\*\\*"
  introduction <- run_regex(text, introduction_regex)
  return(introduction)
}

get_instructions <- function(text){
  instructions_regex <- "\\*\\*\\* \\=instructions([\\s\\S]*?){1}\\*\\*\\*"

  instructions <- run_regex(text, instructions_regex)
  return(instructions)
}


get_hint <- function(text){
  instructions_regex <- "\\*\\*\\* \\=hint\n([\\s\\S]*?)\n\n\\*\\*\\* \\="

  instructions <- run_regex(text, instructions_regex)
  return(instructions)
}


#' Loads chapters into memory from a DataCamp Repository
#'
#' @param path - path to root path of DataCamp Repository
#'
#' @return named list with each chapter.md file in a separate slot.
#' @export
#'
#' @examples
#' chapter_file_path <- system.file("extdata/", package="decampr")
#' chapter_list <- get_chapters(chapter_file_path)
#' chapter_list[[1]]
get_chapters <- function(path) {
  file_names <- list.files(path=path, pattern="chapter")
  file_list <- list.files(path = path, pattern = "chapter", full.names = TRUE)
  chapter_list <- lapply(file_list, readr::read_file)
  chapter_list <- lapply(chapter_list, convert_to_unix_linebreaks)
  names(chapter_list) <- file_names
  chapter_list
}

get_pre_exercise <- function(text){
  pre_exercise_regex <- "\\*\\*\\* \\=pre_exercise_code\n```\\{[a-z]\\}*\n([\\s\\S]*?){1}\n```"
  pre_exercise <- run_regex(text, pre_exercise_regex)
  return(pre_exercise)
}

get_sample_code <- function(text){
  sample_code_regex <- "\\*\\*\\* \\=sample_code\n```\\{[a-z]\\}*\n([\\s\\S]*?){1}\n```"
  sample_code <- run_regex(text, sample_code_regex)
  return(sample_code)
}

get_solution <- function(text){
  solution_regex <- "\\*\\*\\* \\=solution\n```\\{[a-z]\\}*\n([\\s\\S]*?){1}\n```"
  solution_code <- run_regex(text, solution_regex)
  return(solution_code)
}

get_sct <- function(text){
  sct_regex <- "\\*\\*\\* \\=sct\n```\\{[a-z]\\}*\n([\\s\\S]*?){1}\n```"
  sct <- run_regex(text, sct_regex)
  return(sct)
}

extract_normal_exercise <- function(text){
  title <- get_title(text)
  instructions <- get_instructions(text)
  pre_exercise <- get_pre_exercise(text)
  sample_code <- get_sample_code(text)
  solution <- get_solution(text)
  introduction <- get_introduction(text)
  hint <- get_hint(text)
  if(length(hint)==0){
    hint <- ""
  }
  out_list <- list(title = title, introduction=introduction,
                   instructions=instructions,
                   pre_exercise=pre_exercise,
                   sample_code = sample_code,
                   solution = solution, hint=hint,
                   type="Normal")

  out_list
}

extract_multiple_exercise <- function(text){
  title <- get_title(text)
  instructions <- get_instructions(text)
  sct <- get_sct(text)
  hint <- get_hint(text)
  if(length(hint)==0){
    hint <- ""
  }
  introduction <- get_introduction(text)
  out_list <- list(title = title, introduction = introduction,
                   instructions=instructions, sct=sct,
                   hint=hint, type="Multiple")
  out_list
}


#' Title
#'
#' @param chapter_file
#'
#' @return
#' @export
#'
#' @examples
#' chapter_file_path <- system.file("extdata/", package="decampr")
#' chapter_list <- get_chapters(chapter_file_path)
#' exercise_list <- get_exercises(chapter_list[[1]])
#' exercise_list[[1]]
get_exercises <- function(chapter_file){

  chapter_file <- convert_to_unix_linebreaks(chapter_file)
  exercise_name_regex <- "--- type:*.+[\\s\\S]*?\n"
  exercise_regex <-  "--- type:*.+Exercise*.+\n([\\s\\S]*?)\n\n\n"
  exercise_names <- run_regex_match(chapter_file, exercise_name_regex)
  exercise_list <- run_regex(chapter_file, exercise_regex)
  names(exercise_list) <- exercise_names
  exercise_list

}

#' @export
get_chapter <- function(chapter_file_name){
  out <- readr::read_file(chapter_file_name)
  out
}

get_yaml <- function(chapter_file_name){
  rmarkdown::yaml_front_matter(chapter_file_name)
}

#' Numbers an exercise list according to naming conventions
#'
#' @param exlist exercise_list from parse_exercise_list
#' @param prefix for exercises. Example: for chapter1.md, it should
#' be "01"
#'
#' @return
#' @export
#'
#' @examples
number_ex_list <- function(exlist, basename = "01"){
  end_num <- sprintf("%02d",1:length(exlist))
  out_names <- paste(basename, end_num, sep="_")
  exlist <- lapply(1:length(exlist), function(x){
    out <- exlist[[x]]
    out$id <- x
    out
  })
  names(exlist) <- out_names

  return(exlist)
}

get_feedback_vector <- function(sct){
  feedback_regex <- '\\"([\\s\\S]*?)\\"'
  run_regex(sct, feedback_regex)
}

get_answer_vector <- function(instructions){
  answer_regex <- '- ([\\s\\S]*?)\n'
  run_regex(instructions, answer_regex)
}

make_exercise_block <- function(block_name, block){
  begin_block <- glue::glue(
  '<exercise id="{id}" title="{title}">\n',
  '{introduction}\n',
  '{instructions}\n\n',
  '<codeblock id="{ex_id}">\n',
 instructions=block$instructions,id = block$id,
 ex_id = block_name, title = block$title,
 introduction = block$introduction)

  if(grepl(pattern = "pre_exercise", block$hint)){
    block$hint <- ""
  }

  if(length(block$hint)>0 | block$hint != ""){
    hint_block <- glue::glue('{hint}',hint=block$hint)
    begin_block <- paste(begin_block, hint_block, sep="\n")
  }
  begin_block <- paste(begin_block, '</codeblock></exercise>\n', sep="")
  return(begin_block)
}

#' Read and write an appropriate YAML block
#'
#' @param chapter_name - chapter name without full path, such as "chapter1.md"
#' @param chapter_file_path - full file path to the chapter.md file in the
#' DataCamp repository, such as "c:/Code/RBootcamp_old/". Set this argument
#' to NULL if you don't have a chapter heading.
#'
#' @return yaml block as a glue class
#'
#' @examples
#'
#' make_yaml_block("chapter1.md", chapter_file_path = NULL)
#'
#' make_yaml_block("chapter1.md, chapter_file_path =
#'          system.file("extdata/chapter1.md", package="decampr"))
make_yaml_block <- function(chapter_name, chapter_file_path){

  title <- "Add your chapter title here"
  description <- "Add your description here"

  if(!is.null(chapter_file_path)){
    yaml_list <- get_yaml(chapter_file_path)
    title <- yaml_list$title
    description <- yaml_list$description
  }

  #get the chapter number and use it to calculate previous
  #and next chapter names
  chapter_regex <- "chapter(\\d).md"
  id <- as.numeric(run_regex(chapter_name, chapter_regex))
  prev_id = id -1
  prev_id = paste0("/chapter", prev_id)
  if(prev_id == "/chapter0"){prev_id <- "null"}
  next_id = id+1
  next_id = paste0("/chapter", next_id)

  #return the new yaml
  glue::glue("---\n","title: 'Chapter {id}: {title}' \n",
             "description: {description}\n",
             "prev: {prev_id}\n",
             "next: {next_id}\n",
             "id: {id}\n",
             "type: chapter\n",
             "---\n", id=id, prev_id=prev_id, next_id=next_id,
             title = title,description = description)
}


make_multiple_block <- function(block_name, block){
  answer_vec <- get_answer_vector(block$instructions)
  feedback_vec <- get_feedback_vector(block$sct)
  textblock <- glue::glue(
    '<exercise id="{id}" title="{title}">\n', '{introduction}\n\n<choice>\n' ,
    id=block$id, title = block$title, introduction = block$introduction)


  question_block <- lapply(1:length(answer_vec), function(x){
    glue::glue(
               '<opt text="{optext}">\n',
               '{feedback}</opt>\n', optext = answer_vec[x],
               feedback=feedback_vec[x])
  })

  question_block <- glue::glue_collapse(question_block, "\n")

  # for(i in 1:length(answer_vec)){
  #   print(answer_vec[i])
  #   print(feedback_vec[i])
  #   loop_block <- glue::glue(loop_block,
  #                           '<opt text="{optext}">\n',
  #              '{feedback}</opt>\n', optext = answer_vec[i],
  #              feedback=feedback_vec[i])
  # }

  print(textblock)
  print(question_block)

  textblock <- paste0(textblock, "\n", question_block, "</choice>", "\n", "</exercise>\n")
  return(textblock)
}

#' Parses exercise block into code chunks
#'
#' @param exercise_list
#'
#' @return list with each slot containing either type "multiple"
#' or type "Normal" with the appropriate code chunks.
#' @export
#'
#' @examples
#' chapter_file_path <- system.file("extdata/", package="decampr")
#' chapter_list <- get_chapters(chapter_file_path)
#' exercise_list <- get_exercises(chapter_list[[1]])
#' exercise_list <- parse_exercise_list(exercise_list)
#' #show multiple exercise example
#' exercise_list[[4]]
#' #show normal exercise example
#' exercise_list[[5]]
parse_exercise_list <- function(exercise_list){
  exercise_out_list <- lapply(names(exercise_list), function(x){
    out_list <- NULL
    if(grepl("Normal",x, fixed=TRUE) | grepl("Tab", x, fixed=TRUE)){
      out_list <- extract_normal_exercise(exercise_list[[x]])
    }
    if(grepl("Multiple", x, fixed=TRUE)){
      out_list <- extract_multiple_exercise(exercise_list[[x]])
    }
    return(out_list)
  })
  return(exercise_out_list)
}


make_exercise_path_files <- function(exercise_name){
  x <- exercise_name
  ex_file_name <- paste0("exc_", x, ".R")
  solution_file_name <- paste0("solution_", x, ".R")
  #pre_ex_name <- paste0("preexercise_", x, ".R")

  ex_file_path <- here("exercises", ex_file_name)
  solution_file_path <- here("exercises", solution_file_name)
  #pre_ex_path <- here("exercises", pre_ex_name)

  return(list(exercise_file = ex_file_path,
              solution_file = solution_file_path
              ))
}


#' Given an exercise list and a chapter name, writes files to project directory
#'
#' @param ex_list
#' @param chapter_name
#'
#' @return written exercises/solutions in `exercises/` and written chapter in `chapters/`
#' @export
#' @import here
#'
#' @examples
save_exercise_list <- function(ex_list, chapter_name, chapter_file_path){
  ex_path <- "exercises"
  chapter_path <- "chapters"
  slides_path <- "slides"

  out_list <- lapply(names(ex_list), function(x){
    print(x)
    out_block <- NULL
    ex <- ex_list[[x]]
    file_list <- make_exercise_path_files(x)

    ex_file_name <- file_list$exercise_file
    solution_file_name <- file_list$solution_file
    #pre_ex_name <- file_list$pre_ex_file

    #writeLines(as.character(ex$pre_exercise),
    #           con=pre_ex_name, sep="")

    if(ex$type == "Normal"){
      write(as.character(ex$pre_exercise),
                 file=ex_file_name, sep="", append=FALSE)
      write(as.character(ex$sample_code),
                 file=ex_file_name, append=TRUE, sep="")

      write(as.character(ex$pre_exercise),
            file=solution_file_name, sep="", append=FALSE)
      write(as.character(ex$solution),
                 file=solution_file_name, sep="", append=TRUE)

      out_block <- make_exercise_block(block_name = x, block=ex)
    }
    if(ex$type == "Multiple"){
      out_block <- make_multiple_block(x, ex)

    }
    return(as.character(out_block))
  })

  con = here(chapter_path, chapter_name)
  yaml_block <- make_yaml_block(chapter_name, chapter_file_path)
  write(yaml_block, file=con, append=FALSE, sep="")
  lapply(out_list, write, file=con, append=TRUE, sep="")

}


#' Opens exercise files for editing
#'
#' @param id - id of the exercise/solution/pre-exercise (such as "01_02")
#' @param create - boolean. If FALSE, won't create the relevant files and returns NULL.
#' If TRUE, then will create files in exercises directory
#'
#' @return opens exercise files
#' @export
#'
#' @examples
open_exercise <- function(id, create=FALSE){
  exercise_path <- "exercises"
  exercise_file <- paste0("exc_", id, ".R")
  solution_file <- paste0("solution_", id, ".R")
  #pre_exercise_file <- paste0("preexercise_", id, ".R")

  ex_location <- here::here(exercise_path, exercise_file)

  if(file.exists(ex_location)| create == TRUE){
    usethis::edit_file(ex_location)
  }

  sol_location <- here::here(exercise_path, solution_file)
  if(file.exists(sol_location) | create == TRUE){
    usethis::edit_file(sol_location)
  }

  #pre_location <- here::here(exercise_path, pre_exercise_file)
  #if(file.exists(pre_location) | create == TRUE){
  #  usethis::edit_file(pre_location)
  #}

}

#' Opens a chapter from the file name
#'
#' @param chapter_name - name of the chapter to open. Note that chapter names
#' are numbered numerically (examples: 'chapter1.md', 'chapter2.md').
#'
#' @return opened chapter file if in an interactive session
#' @export
#'
#' @examples
open_chapter <- function(chapter_name){
  chapter_path <- here("chapters", chapter_name)

  if(!file.exists(chapter_path)){
    stop("Your chapter file isn't made yet - use add_chapter() to add it")
  }

  usethis::edit_file(chapter_path)
}

