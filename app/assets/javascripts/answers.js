$(document).on('turbolinks:load', function() {
  if (gon.question_id) {
    App.cable.subscriptions.create({ channel: 'AnswersChannel', question_id: gon.question_id }, {
      connected: function() {
        this.perform('follow')
      },
      received: function(data) {
        console.log(data);
        $('.answers').append(JST['templates/answer']({
            answer: data.answer,
            answer_balance_votes: data.answer_balance_votes,
            answer_links: data.answer_links,
            answer_files: data.answer_files
          })
        )
      }
    })
  }
})
