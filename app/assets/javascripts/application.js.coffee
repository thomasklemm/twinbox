# application.js.coffee
# insert after jQuery
#
//= require jquery_ujs
//= require ember

# Twinbox
$ ->
  ##
  # Flash messages
  # Close on click
  $('.flash-message .close').click ->
    $(this).parent().fadeOut()

  $('.flash-message').click ->
    $(this).fadeOut()


  ##
  # Tweets
  $('.destroy-tweet').live 'click', () ->
    $(this).parent().slideUp(150)
