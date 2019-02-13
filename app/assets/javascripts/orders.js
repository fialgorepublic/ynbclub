$(document).ready(function() {
  $('#my-orders').dataTable( {
    "pagingType": "full_numbers",
    "order": [[0, "desc"]],
    "info": false
  });

  $('#referral-sales').dataTable( {
    "pagingType": "full_numbers",
    "order": [[0, "desc"]],
    "paging": false,
    "info": false
  });
})
