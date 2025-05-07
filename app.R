library(shiny)
library(bslib)
library(ellmer)
library(clipr)
library(markdown)

source("functions.R")

default_text <- "Evangelion is set 15 years after a worldwide cataclysm in the futuristic fortified city of Tokyo-3. The protagonist is Shinji Ikari, a teenage boy recruited by his father Gendo to the mysterious organization Nerv. Shinji must pilot an Evangelion, a giant biomechanical mecha, and fight beings known as Angels."

ui <- page_fluid(
    h1("Wiki Autolink Markdown"),
    textAreaInput(
      "text_input",
      "Enter your text:", 
      placeholder = "Type here...",
      rows=5,
      width = "100%",
      value = default_text
    ),
    checkboxInput("view_toggle", "Show Markdown Code", value = FALSE),
    actionButton("generate_btn", "Generate Markdown"),
    actionButton("copy_btn", "Copy to Clipboard", class ="btn-primary"),
    uiOutput("output_view")
)

server <- function(input, output, session) {
  observeEvent(input$generate_btn, {
    req(input$text_input)
    showNotification("Generating markdown...", type = "message")
  })

  observeEvent(input$copy_btn, {
    req(input$text_input)
    write_clip(autolinked_text()) # Copy the generated markdown to clipboard
    showNotification("Copied to clipboard!", type = "message")
  })

  output$output_view <- renderUI({
    req(input$text_input)
    if (input$view_toggle) {
      verbatimTextOutput("markdown_code")
    } else {
      htmlOutput("rendered_markdown")
    }
  })

  autolinked_text <- eventReactive(input$generate_btn, {
    auto_link_wikipedia(input$text_input)
  })

    observeEvent(autolinked_text(), {
    showNotification("Markdown generated successfully!", type = "default")
 })

  output$markdown_code <- renderText({
    autolinked_text()
  })

  output$rendered_markdown <- renderUI({
    HTML(
      markdownToHTML(
        text = autolinked_text(), 
        fragment.only = TRUE
      )
    )
  })
}

shinyApp(ui, server)
