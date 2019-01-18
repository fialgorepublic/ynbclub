$(document).ready(function(){
  $("#shared-urls").dataTable({
    "pagingType": "full_numbers",
    searching: false,
    "order": [[0, "desc"]]
  })

  $("#bs4-table").dataTable({
    searching: false,
    "order": [[5, "desc"]]
  })
});
