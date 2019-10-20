$(document).on('turbolinks:load', function() {
  $('.vote_up').on('ajax:success', function(e) {
    $(this).hide().closest('.vote').find('.vote_reset').show().text(e.detail[0].text)
  })
})
