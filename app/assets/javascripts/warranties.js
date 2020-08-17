$(document).on('turbolinks:load', function() {
  $('#warranties').dataTable( {
    "pagingType": "full_numbers",
    "order": [[0, "desc"]],
    "paging": false,
    "info": false,
    "scrollY":  600,
    'scrollX': true
  });

  $( "#new_warranty" ).submit(function( event ) {
    $('.warranty-loader').show()
    setTimeout(function() {
      $('.warranty-loader').fadeOut('fast');
    }, 6000);
  });
})
