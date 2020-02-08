$(document).on('turbolinks:load', function() {
  if (gon.question_id) {
    App.cable.subscriptions.create({ channel: 'AnswersChannel', question_id: gon.question_id }, {
      connected: function() {
        this.perform('follow')
      },
      received: function(data) {
        console.log('Answers', data);
        $('.answers').append(JST['templates/answer']({
            answer_id: data.answer_id,
            answer_user_id: data.answer_user_id,
            answer_body: data.answer_body,
            answer_best: data.answer_best,
            answer_balance_votes: data.answer_balance_votes,
            answer_links: data.answer_links,
            answer_files: data.answer_files
          })
        )
      }
    })
  }
})
