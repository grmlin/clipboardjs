class MessageAbstractor
  @ABSTRACT_LINE_LENGTH = 100
  @ABSTRACT_LINES = 14
  @ABSTRACT_LINE_PUFFER = 3

  getAbstract: (message, language) ->
    highlighter = new Highlighter()
    lines = message.split(/\r?\n/);

    lines.forEach (line, index) ->
      if line.length > MessageAbstractor.ABSTRACT_LINE_LENGTH
        lines[index] = line.slice MessageAbstractor.ABSTRACT_LINE_LENGTH
        line += "..."

    if lines.length > MessageAbstractor.ABSTRACT_LINES + MessageAbstractor.ABSTRACT_LINE_PUFFER
      part1 = lines.slice(0, MessageAbstractor.ABSTRACT_LINES / 2 - 1).join('\n')
      part2 = lines.slice(-MessageAbstractor.ABSTRACT_LINES / 2 - 1).join('\n')

      messageAbstract = highlighter.highlight(part1, language).value + "\n <span class='divider'>...</span> \n" + highlighter.highlight(part2, language).value
    else
      part = lines.join('\n')
      messageAbstract = highlighter.highlight(part, language).value

    return messageAbstract