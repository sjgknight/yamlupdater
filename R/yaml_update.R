#' YAML Update
#'
#' Updates YAML header in file given user YAML key value pairs.
#'
#' @param md_file File with a YAML header.
#' @param method Either merge (key clashes result in lists), combine (new keys included, no overwriting), or overwrite (new yaml overwrites old). If a single "merge" or "overwrite" is provided, this will respectively (1) combine the two yamls provided (giving precedence to the new yaml over the md where keys conflict), OR (2) overwrite the file yaml with the new yaml entirely. Alternatively, a named list can be provided which indicates how each key should be combined (keys don't have to exist for this to work), as in c(title = "overwrite", author = "keep", tags = "merge")
#' @param unmentioned If using a list of key-methods, how to treat keys not mentioned; discard, or keep (if kept, defaults to 'overwrite' method from new yaml). Merge keeps md yaml that isn't overwritten. Overwrite discards.
#' @param yaml user value key pairs this should be in a list (NOT as yaml)
#' @param output Specify if a different file should be written. Defaults to input file.
#' @param ... at some point may be useful to pass other args.
#' @return File with a YAML header.
#'
#' @export


# md_file = "inst/extdata//sample.md"
# method = list(tags = "merge", title = "overwrite")
# yaml = list(title = "overwrtitten hello world", tags = "mynwewtag3", unlikelyfield = "a-test")
# unmentioned = c("keep","discard")

yaml_update <- function(md_file = "inst/extdata/sample.md",
                        method = list(tags = "merge", title = "overwrite"),
                        yaml = list(title = "overwritten hello world", tags = "mynewtag3", unlikelyfield = "a-test"), #ymlthis::as_yml(list(title = "hello world", tags = "mytag3", unlikelyfield = "a-test")),
                        unmentioned = c("keep","discard"),
                        output = md_file,
                        ...) {


yaml_md <- yaml_get(md_file)
yaml_list <- yaml_md$yaml_list
md_content <- yaml_md$md_content

rm(yaml_md)
#read your yaml
#ym <- yaml::yaml.load(yaml)
ym <- yaml

#if overwrite, skip to end.
#if merge, decide which one takes precedence and use that one to resolve clashes, otherwise merge keys, OR, accept a list of key:source pairs e.g. title=yaml, tags=combine, subtitle=file
#default is to merge with yaml used to overwrite any clashes unless they're lists


#this one overwrites any elements in md with new values from yaml
#it assumes it's being given a map in either [] or - lists
yml_key_overwrite <- function(element_name){
  if(element_name %in% names(yaml_list)) {
    yaml_list[element_name] <<- yaml[element_name]
  } else {
    yaml_list <<- c(yaml_list,yaml[element_name])
  }
}



yml_overwrite <- function(yaml, yaml_list){
  for (element_name in names(yaml)){
    yml_key_overwrite(element_name)
  }
}

#pull out the key merging bit so it can be used below
yml_key_merge <- function(this_element, ...){
  if(this_element %in% names(yaml_list)){
    element <- yaml_list[this_element]
    element_replace <- c(unique(mapply(c,element,yaml[this_element])))
    #xl <- length(x_replace)
    yaml_list[[this_element]] <<- element_replace
  } else {
    yaml_list <<- c(yaml_list,yaml[this_element])
  }
}

#merge_key requires a mapping field
yml_merge <- function(yaml, yaml_list){
  for (element_name in names(yaml)){
    yml_key_merge(element_name)
  }
}

#test if we're getting a list of methods. If TRUE use the single elements in the functions above.
#Else use wrappers to apply those functions to all the elements in the yaml.
if(is.list(method)){
  i <- 0
  #method <- list(title = "overwrite", tags = "merge", author = "keep")
  for(key in method){
    i <- i+1
    element_name <- names(method[i])
    if(key == "merge"){
      yml_key_merge(element_name)
      #function works but
    } else {
      if(key == "overwrite"){
        yml_key_overwrite(element_name)
      } else {
      #assumes keep
      cat(element_name)
    }
  }
}
  } else {
  if(method == "overwrite") {yml_overwrite(yaml, yaml_list)}
  if(method == "merge") {yml_merge(yaml, yaml_list)}
}

if(unmentioned == "keep"){
  #find the index of keys in the md, but not in the yaml
  unmatched <- which(!names(yaml_list) %in% names(yaml))
  unmatched <- yaml_list[unmatched]
}

md_new <- yaml::as.yaml(yaml_list)
readr::write_lines(c("---",md_new, "\n---\n",md_content),
                   output)


}

#md_new <- ymlthis::as_yml(yaml_list)
#md <- ymlthis::yml_replace(md, tags = c(md_new))
#md <- yaml::as.yaml(md)
# md_body <- stringr::str_replace_all(readr::read_file(mdf),
#                                     "^(-{3})(\\s|\\S|.)*(-{3})",
#                                     "")

