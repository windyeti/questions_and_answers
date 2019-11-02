$(document).on('turbolinks:load', function() {

  if (!App.questions) {
    App.questions = App.cable.subscriptions.create('QuestionsChannel', {
      connected: function() {
        console.log('Connected!!!');
        this.perform('follow')
      },
      received: function(data) {
        $('table').append(JST["templates/question"]({question: data.question}))
      }
    })
  }
});
