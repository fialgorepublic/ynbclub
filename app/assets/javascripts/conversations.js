$(document).on('turbolinks:load', function () {
  initMediumEditor();
  submitForm();
  initTagsInput();
  initSort();

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

  function initSort(){
    $('#subject-sort').on('change', function () {
      sortType = $(this).val();
      params = `sort_type=${sortType}`;
      fetchConversations(params);
    });
  }

  function fetchConversations(params) {
    $('.loader').show()
    $.ajax({
      url: `/conversations?${params}`,
      method: 'get',
      dataType: 'script'
    })
  }

  var enableSubmit = function(ele) {
    $(ele).removeClass("disabled");
}

$(".click").click(function() {
    var that = this;
    $(this).addClass("disabled")
    setTimeout(function() { enableSubmit(that) }, 3000);
});

});
