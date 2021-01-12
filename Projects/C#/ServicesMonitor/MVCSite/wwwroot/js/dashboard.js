var dataTable;

$(document).ready(function () {
    //loadGroup(0);
    loadDataTable();
    loadSummary();
    updateData();
    loadAlertConfig();
});

function updateData() {
    setInterval(loadDataTable, 60000);
    setInterval(loadSummary, 60000);
}

$('#DDL_Load').on('change', function () {
    loadDataTable();
});

function loadDataTable() {
    //var selectedId = $("#DDL_Load").val();
    var url = "/api_service/GetServiceListByStatus?status=0";
    if ($.fn.dataTable.isDataTable('#DT_load')) {
        dataTable = $('#DT_load').DataTable();
        dataTable.destroy();
    }

    dataTable = $('#DT_load').DataTable({
        "ajax": {
            "url": url,
            "type": "GET",
            "datatype": "json"
        },
        "createdRow": function (row, data, dataIndex) {
            if (data.status === 0) {
                $(row).addClass("red");
            }
        },
        "columns": [
            { "data": "Id", "className": "text-center" },
            { "data": "Name" },
            { "data": "GroupName" },
            { "data": "Url" },
            //{
            //    "data": "Status",
            //    "className": "text-center",
            //    "render": function (data) {
            //        if (data === 1) return "OK";
            //        else return "ERROR";
            //    }
            //},
            {
                "data": "UpdatedTime",
                "render": function (data) {
                    return convertDatetimeOffset(data);
                }
            }
        ],
        "language": {
            "emptyTable": "no data found"
        },
        "width": "100%",
        "paging": false,
        "ordering": true,
        "info": true
    });
}

function loadSummary() {
    $.ajax({
        type: 'GET',
        dataType: 'json',
        url: '/api/GetServiceSummary',
        success: function (data) {
            $("#totalServiceCount").text(data[0].TotalService);
            $("#errorServiceCount").text(data[0].ErrorService);
        },
        error: function (data) {
            // `data` will not be JSON
        }
    });
}

function loadAlertConfig() {
    $.ajax({
        type: 'GET',
        dataType: 'json',
        url: '/api_alert/Get?id=1',
        success: function (data) {
            $("#lblServiceStatus").text(data.pause_status);
            (data.pause_status === "ON") ? $("#updateAlertStatus").text("Pause Alert").addClass("btn-danger") : $("#updateAlertStatus").text("Enable Alert").addClass("btn-success");
        },
        error: function (data) {
            // `data` will not be JSON
        }
    });
}

function updateWarningStatus(url) {
    var status =$("#lblServiceStatus").text() === "ON" ? 1 : 0;
    url = url + "&pause=" + status;
    swal({        title: "Are you sure?",
        text: "",
        icon: "warning",
        buttons: true,
        dangerMode: true
    }).then((willUpdate) => {
        if (willUpdate) {
            $.ajax({
                type: "POST",
                url: url,
                success: function (data) {
                    if (data.success) {
                        toastr.success(data.message);
                        (data.pause_status === 1) ? $("#lblServiceStatus").text("OFF") : $("#lblServiceStatus").text("ON");
                        (data.pause_status === 0) ? $("#updateAlertStatus").text("Pause Alert").removeClass("btn-success").addClass("btn-danger") : $("#updateAlertStatus").text("Enable Alert").removeClass("btn-danger").addClass("btn-success");
                    }
                    else {
                        toastr.error(data.message);
                    }
                }
            });
        }
    });
}