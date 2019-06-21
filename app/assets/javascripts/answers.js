$(document).on('turbolinks:load', function() {
  $('.question__answers').on('click', '.edit-answer-link', function(e){
    e.preventDefault();
    $(this).hide();
    $(this).closest('.answer').find('form').removeClass('hide');
  })
})
