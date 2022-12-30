#' YAML get
#'
#' Gets YAML from header (with some nice error check)
#'
#' @param md_file File with a YAML header.
#' @return File with a YAML header.
#'
#' @export

yaml_get <- function(md_file){
#read the yaml from your file modifying response from # https://stackoverflow.com/questions/62095329/how-to-edit-an-r-markdown-yaml-header-programmatically also useful # https://stackoverflow.com/questions/23622307/strip-yaml-from-child-docs-in-knitr
#read the file
input_lines <- readLines(md_file)
#find the yaml delimiters present
delimiters <- grep("^---\\s*$", input_lines)
if (!length(delimiters)) {
  stop("unable to find yaml delimiters")
} else if (length(delimiters) == 1L) {
  if (delimiters[1] == 1L) {
    stop("cannot find second delimiter, first is on line 1")
  } else {
    # found just one set, assume it is *closing* the yaml matter;
    # fake a preceding line of delimiter
    delimiters <- c(0L, delimiters[1])
  }
}

#read the yaml values
delimiters <- delimiters[1:2]
yaml_list <- yaml::yaml.load(
  input_lines[ (delimiters[1]+1):(delimiters[2]-1) ])

#get the content of the md file
md_content <- input_lines[ (delimiters[2]+1):length(input_lines)]

return(list(md_content = md_content, yaml_list = yaml_list))

}
