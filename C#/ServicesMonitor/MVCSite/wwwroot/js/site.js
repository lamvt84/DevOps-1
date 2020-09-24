// Please see documentation at https://docs.microsoft.com/aspnet/core/client-side/bundling-and-minification
// for details on configuring this project to bundle and minify static web assets.

// Write your JavaScript code.
function convertDatetimeOffset(data) {
    var dt = new Date(data);
    var day = (dt.getDate() < 10) ? "0" + (dt.getDate()) : dt.getDate(),
        month = (dt.getMonth() + 1 < 10) ? "0" + (dt.getMonth() + 1) : dt.getMonth() + 1,
        year = dt.getFullYear(),
        hours = dt.getHours(),
        minutes = dt.getMinutes(),
        seconds = dt.getSeconds();

    //04/12/2018 8:53:42
    return (year + '/' + month + '/' + day + ' ' + hours + ':' + minutes + ':' + seconds);
}

function Delete(url) {
    swal({
        title: "Are you sure?",
        text: "Once deleted, you will not be able to recover",
        icon: "warning",
        buttons: true,
        dangerMode: true
    }).then((willDelete) => {
        if (willDelete) {
            $.ajax({
                type: "POST",
                url: url,
                success: function (data) {
                    if (data.success) {
                        toastr.success(data.message);
                        dataTable.ajax.reload();
                    }
                    else {
                        toastr.error(data.message);
                    }
                }
            });
        }
    });
}

function loadGroup(id) {
    $.ajax({
        type: 'GET',
        dataType: 'json',
        url: '/api_group/GetList',
        success: function (response) {
            $.each(response.data,
                function (i, item) {
                    var opt = new Option(item.name, item.id);
                    $("#DDL_Load").append(opt);
                    if (id === item.id) opt.setAttribute("selected", "selected");
                });
        },
        error: function (data) {
            // `data` will not be JSON
        }
    });
}