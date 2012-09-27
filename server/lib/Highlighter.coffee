Highlighter = do ->
  highlight = meteorNpm.require "highlight.js"

  class Highlighter
    highlight: (content, language) ->
      try
        switch language
          when "auto"
            highlightResult = highlight.highlightAuto content
          else
            highlightResult = highlight.highlight language, content

        contentHighlighted = highlightResult.value if highlightResult isnt null
        contentLang = highlightResult.language if highlightResult isnt null

      catch error
        console.log error
        contentHighlighted = HtmlEncoder.encode content
        contentLang = "plain"

      res =
        language: contentLang,
        value: contentHighlighted

