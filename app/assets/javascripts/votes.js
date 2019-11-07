$(document).on('turbolinks:load', function() {
  $('.question, .answers').on('ajax:success', function(e) {
    $(e.target).closest('.vote').find('.vote__value').html(e.detail[0].value)
    $(this).find('.vote__up, .vote__reset').toggleClass('hidden_item')
  })
})
