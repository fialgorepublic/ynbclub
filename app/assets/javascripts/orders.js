$(document).ready(function() {
  $('#my-orders').dataTable( {
    "pagingType": "full_numbers",
    "info": false,
    "scrollX": true
  });

  $('#referral-sales').dataTable( {
    "pagingType": "full_numbers",
    "order": [[0, "desc"]],
    "paging": false,
    "info": false
  });
})
