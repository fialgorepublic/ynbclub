$(document).on('turbolinks:load', function () {
  initMediumEditor();
  submitForm();
  initTagsInput();

  function initMediumEditor(){
    if ($('.medium-editor').length == 0) { return; }
    var editor = new MediumEditor('.medium-editor', {
    });

    $('.medium-editor').mediumInsert({
      editor: editor
    });
  }

  function submitForm(){
    $('.submit-conversatioin-form').click(function(){
      $('#submit-button').click();
    });
  }

  function initTagsInput() {
    $('input[data-role="tagsinput"]').tagsinput({
      allowDuplicates: false
    });
  }
});
