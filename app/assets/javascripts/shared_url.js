$(document).ready(function(){
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
        scrollY: '60vh',
        scrollCollapse: true,
        scrollX: true

    })
});
