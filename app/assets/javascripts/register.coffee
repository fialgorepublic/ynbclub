$(document).ready ->
  $('#user_name').keypress (event) ->
    inputValue = event.which
    # allow letters and whitespaces only.
    if inputValue == 95 || inputValue == 94
      event.preventDefault()
    if !(inputValue >= 65 and inputValue <= 122) and inputValue != 32 and inputValue != 0
      event.preventDefault()
