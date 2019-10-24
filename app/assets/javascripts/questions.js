$(document).on('turbolinks:load', function() {
  $('.vote').on('ajax:success', function(e) {
    // console.log(e.detail[0].value)
    // console.log($(e.target).closest('.vote__value').html())

    $(e.target).closest('.vote').find('.vote__value').html(e.detail[0].value)

    // var $voteValue = $(e.target).closest('.vote__value');
    // var $containerLink = $(e.target).parent();
    // if ($containerLink.hasClass('vote__up')) {
    //   $voteValue.text($(this) + 1)
    // }
    $(this).find('.vote__up, .vote__reset').toggleClass('hidden_item')
  })
})
