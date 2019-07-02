$(document).on('turbolinks:load', function() {
  $('.question').on('click', '.js-question-edit-link', function(e) {
    e.preventDefault();

    $(this).hide();
    $(this).closest('.question').find('.question__edit').removeClass('hide');
  })
})
