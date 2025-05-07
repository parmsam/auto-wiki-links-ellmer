#' Get Wikipedia Link
#'
#' This function generates a Wikipedia link for a given keyword.
#'
#' @param keyword A character string representing the keyword for which the Wikipedia link is to be generated.
#' @return A character string containing the URL of the Wikipedia page for the given keyword.
#' @examples
#' get_wikipedia_link("R programming")
#' get_wikipedia_link("Data Science")
#' @export
get_wikipedia_link <- function(keyword) {
  url <- paste0("https://en.wikipedia.org/wiki/", URLencode(keyword))
  response <- httr::GET(url)
  if (httr::status_code(response) == 200) {
    return(url)
  } else {
    return(NULL)
  }
}

auto_link_wikipedia <- function(text) {
  chat <- ellmer::chat_openai(
    model = "gpt-4o-mini",
    system_prompt = paste(collapse = "\n", readLines("prompt.md", warn = FALSE))
  )
  chat$register_tool(
    ellmer::tool(
      get_wikipedia_link,
      "Gets a Wikipedia link for a given keyword",
      keyword = ellmer::type_string(
        "The keyword to get a Wikipedia link for",
        required = TRUE
      ),
    )
  )
  chat$chat(text)
}
