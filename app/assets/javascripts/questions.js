$(document).on('turbolinks:load', function() {
  $('.vote').on('ajax:success', function() {
    $(this).find('.vote__up, .vote__reset').toggleClass('hidden_item')
  })
})
