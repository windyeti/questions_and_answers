$(document).on('turbolinks:load', function() {
  App.cable.subscriptions.create('QuestionsChannel', {
    connected: function() {
      this.perform('follow')
    },
    received: function(data) {
      console.log('Questions', data);
      $('table').append(JST["templates/question"]({
        question_id: data.question_id,
        question_title: data.question_title,
        question_body: data.question_body,
        question_user_id: data.question_user_id,
      }))
    }
  })
});
