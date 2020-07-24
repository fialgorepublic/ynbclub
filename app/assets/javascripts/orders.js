
$(document).on('turbolinks:load', function() {
  $('#orders').dataTable( {
    "info":        false,
    "scrollX":     true,
    'pagination':  false,
    'paging':      false,
    "scrollY":     600,
    searching:     false,
    "order":       [],
    rowCallback: function(row, data, index){
      if (data[2] == 'Paid') { $('td', row).css('background-color', '#8abfef'); return; }
      string_index = data[9].indexOf('"selected"');
      value = JSON.parse(data[9].substring(string_index, string_index + 20).split(' ')[1].split('=')[1])
      if(value == '1'){
        $('td', row).css('background-color', '#e8f4e7');
      }
      else if(value == '2'){
        $('td', row).css('background-color', '#fff5c7');
      }
      else if(value == '3'){
        $('td', row).css('background-color', '#f9dcbe');
      }
      else if(value == '4'){
        $('td', row).css('background-color', '#f0b9a2');
      }
      else if(value == '5'){
        $('td', row).css('background-color', '#fa9b9b');
      }
       else if(value == '6'){
        $('td', row).css('background-color', '#eeacef');
      }
    }
  });

  $('#my-orders').dataTable({
    "pagingType": "full_numbers",
    "paging": false,
    "info": false,
    "scrollY": 600,
    'scrollX': true
  });

  $('#referral-sales').dataTable( {
    "pagingType": "full_numbers",
    "order": [[0, "desc"]],
    "paging": false,
    "info": false,
    "scrollY":  600,
    'scrollX': true
  });

  $("#orders").on("click", ".send_to_ghtk", function () {
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


  $("#orders").on("click", ".edit_address", function () {
    order_id = $(this).data('order-id');
    $('#edit_address_modal').modal('show');
    $.ajax({
      url: `/orders/${order_id}/edit_address`,
      type: 'get',
      contentType: 'json',
      error: function () {
        $('.loader').hide();
        alert('Error');
      }
    });
  });

  $("#orders").on("change", ".phone-status", function () {
    order_id = $(this).data('order-id');
    status = $(this).val();
    $.ajax({
      url: `/orders/${order_id}/update_phone_status?status=${status}`,
      type: 'get',
      contentType: 'json',
      success: function (data) {
        if(data.result) {
          // toastr.success('Phone Status updated successuflly.');
          // window.location.href = '/orders?id='+order_id;
        }
        else
          toastr.error('Somethng Went wrong.')
      },
      error: function () {
        $('.loader').hide();
        alert('Error');
      }
    });
  });

  $('#clear-btn').click(function(){
    value = $('#search-field').val();
    if (value == "") { return false; }
    $('#search-field').val('');
    url = $(this).data('url');
    window.location.href = url
  });

  $("#sort-phone-status").change(function() {
    $('#search-order').click();
  });

  $( "#edit_product_warranty_modal" ).on('shown.bs.modal', function(){
    $(".warranty_number").each(function(){
      id = this.id.split("-")[1]
      $input = $(`[data-behavior='autocomplete-${$(this).data('id')}']`)
      var options = {
        getValue: "number",
        url: function(phrase) {
          return "/search_warranty.json?q=" + phrase;
        },
        categories: [
          {
            listLocation: "product_warranties",
            header: "<strong>Warranties</strong>",
          }
        ],
        list: {
          onChooseEvent: function() {
            $input.getSelectedItemData().warranty_number
          }
        }
      }
      $input.easyAutocomplete(options)
    });
  });
})
