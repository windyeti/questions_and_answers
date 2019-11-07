$(document).on('turbolinks:load', function() {
  App.cable.subscriptions.create('QuestionsChannel', {
    connected: function() {
      console.log('===> QuestionsChannel Connected!!! <===');
      this.perform('follow')
    },
    received: function(data) {
      $('table').append(JST["templates/question"]({question: data.question}))
    }
  })
});
