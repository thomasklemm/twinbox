# application.js.coffee
# insert after jQuery
#
//= require jquery_ujs

# Twinbox
$ ->
  ##
  # Flash messages
  # Close on click
  $('.flash-message .close').click ->
    $(this).parent().fadeOut()

  $('.flash-message').click ->
    $(this).fadeOut()
