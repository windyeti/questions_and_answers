$(document).on('turbolinks:load', function() {
  if (gon.question_id) {
    App.cable.subscriptions.create('CommentsChannel', {
      connected: function() {
        this.perform('follow', { question_id: gon.question_id })
      },
      received: function(data) {
        var selector = '#' + data.commentable_type + '_' + data.commentable_id + ' .comments';
        $(selector).append(JST['templates/comment']({
          commentable_type: data.commentable_type,
          commentable_id: data.commentable_id,
          body: data.body,
          creator_id: data.creator_id
          })
        )
      }
    })
  }
})
