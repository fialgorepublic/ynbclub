$( document ).on('turbolinks:load', function() {
  closeBlogModal()
  
  function closeBlogModal(){
    $("#remove-modal").click(function(){
      $("#new-blog").modal("hide")
      $("#create-blog").html('');
      $(".modal-backdrop").removeClass();
      blogsTab = document.getElementById("blogs-tab")
       if (blogsTab == null) {
      history.pushState({}, null, window.location.href.split("blogs")[0]+"blogs");
      }
      else {
        window.history.replaceState({},'','/dashboard');
      }
    })
  }
});
