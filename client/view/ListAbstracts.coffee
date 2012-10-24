do ->
  MONTH_NAMES = [ "January", "February", "March", "April", "May", "June",
    "July", "August", "September", "October", "November", "December" ]

  Template.message_abstr.helpers
    get_date: (time)->
      date = new Date(time)
      day = date.getDay()
      month = MONTH_NAMES[date.getMonth()]
      year = date.getYear()
      month.toString() + " " + day.toString() + ", " + year.toString()
  
    is_active: (id)->
      id is Session.get(SESSION_SHORT_MESSAGE_ID)
  
  Template.stream_abstr.helpers
    is_active : (id) ->
      id is Session.get SESSION_SHORT_STREAM_ID