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

  $('.send_to_ghtk').click(function(){
    order_id = $(this).data('order-id');
    $('.loader').show();
    $.ajax({
      url: `/orders/${order_id}/send_to_ghtk`,
      type: 'get',
      contentType: 'json',
      error: function () {
        $('.loader').hide();
        alert('Error');
      }
    });
  });
})
