$(document).on('turbolinks:load', function() {
  $('.question, .answers').on('ajax:success', function(e) {
    var $target = $(e.target)
    if ($target.hasClass('link__vote__up') || $target.hasClass('link__vote__down') || $target.hasClass('link__vote__reset')) {
      $target.closest('.vote').find('.vote__value').html(e.detail[0].value)
      $(this).find('.vote__up, .vote__reset').toggleClass('hidden_item')
    }
  })
})
