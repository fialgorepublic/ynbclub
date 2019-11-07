$(document).on('turbolinks:load', function () {
  initMediumEditor();
  function initMediumEditor(){
    if ($('.medium-editor').length == 0) { return; }
    var editor = new MediumEditor('.medium-editor', {
    });

    $('.medium-editor').mediumInsert({
      editor: editor
    });
  }
});
