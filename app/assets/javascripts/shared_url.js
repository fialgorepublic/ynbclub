$(document).ready(function(){
  $("#shared-urls").dataTable({
    "pagingType": "full_numbers",
    searching: false,
    "order": [[0, "desc"]]
  })
});
