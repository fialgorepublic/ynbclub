$(document).ready(function() {
  $('#my-orders').dataTable( {
    "pagingType": "full_numbers",
    "order": [[0, "desc"]]
  });

  $('#referral-sales').dataTable( {
    "pagingType": "full_numbers",
    "order": [[0, "desc"]]
  });
})
