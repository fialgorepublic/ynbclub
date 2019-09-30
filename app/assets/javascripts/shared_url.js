$(document).on('turbolinks:load', function(){
  $("#shared-urls").dataTable({
    "pagingType": "full_numbers",
    searching: true,
    "order": [[0, "desc"]]
  })

  $("#bs4-table").dataTable({
    searching: true,
    "pagingType": "full_numbers",
    "order": [[5, "desc"]],
    "paging": false,
    "info": false,
    scrollY:  600,
    scrollCollapse: true,
    scrollX: true
  })

  $("#exchanged-coins").dataTable({
    searching: true,
    "order": [],
    "pagingType": "full_numbers",
    "paging": false,
    "info": false,
  })


  $("#ban_users_table").dataTable({
    searching: true,
    "pagingType": "full_numbers",
    "paging": false,
    "info":   false,
    scrollY:  600,
    scrollCollapse: true,
    scrollX: true
  })

  $("#deduct_points_table").dataTable({
    searching: true,
    "pagingType": "full_numbers",
    "paging": false,
    "info":   false,
    scrollY:  600,
    scrollCollapse: true,
    scrollX: true,
    "order": [[4, "desc"]],
  })

  $("#notifications-table").dataTable({
    searching: true,
    "pagingType": "full_numbers",
    "paging": false,
    "info":   false,
    scrollY:  600,
    scrollCollapse: true,
    scrollX: true
  })

  $("#share-link-count-table").dataTable({
    searching: true,
    "paging": false,
    "info":   false,
    scrollY:  600,
    scrollCollapse: true,
    scrollX: true,
    "order": [[3, "desc"]]
  })
});
