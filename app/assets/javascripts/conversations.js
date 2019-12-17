$(document).on('turbolinks:load', function () {
  initMediumEditor();
  submitForm();
  initTagsInput();
  initSort();

  function initMediumEditor(){
    if (location.protocol == 'https:')
    {
     location.href = 'http:' + window.location.href.substring(window.location.protocol.length);
      return false
    }
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

  $(".new_reply_btn").click(function(e){
    e.preventDefault();
    get_id = this.id.split("-")[1]
    find_reply_form = document.getElementById("new-reply-"+get_id)
    $(find_reply_form).show();
  })

  $(".reply-cancel").click(function(e){
    e.preventDefault();
    get_id = this.id.split("-")[1]
    find_reply_form = document.getElementById("new-reply-"+get_id)
    $(find_reply_form).hide();
  })

});