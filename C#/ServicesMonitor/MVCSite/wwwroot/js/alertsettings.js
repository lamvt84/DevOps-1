var dataTable;

$(document).ready(function () {
    loadDataTable();
});

function loadDataTable() {
    dataTable = $('#DT_EmailLoad').DataTable({
        "ajax": {
            "url": "/api_alert/GetEmailConfigList/",
            "type": "GET",
            "datatype": "json"
        },
        "columns": [
            { "data": "alertConfigId", "className": "text-center" },
            { "data": "senderName" },
            { "data": "toMail" },
            { "data": "ccMail" },
            { "data": "dataSign" },
            {
                "data": "id",
                "render": function (data) {
                    return `<div class="text-center">                       
                        <a href="/Config/EmailInsertOrUpdate?id=${data}" class='btn btn-success text-white' style='cursor:pointer; width:70px;'>
                            Edit
                        </a>                            
                        </div>`;
                }
            }
        ],
        "language": {
            "emptyTable": "no data found"
        },
        "width": "100%"
    });

    dataTable = $('#DT_SmsLoad').DataTable({
        "ajax": {
            "url": "/api_alert/GetSmsConfigList/",
            "type": "GET",
            "datatype": "json"
        },
        "columns": [
            { "data": "alertConfigId", "className": "text-center" },
            { "data": "accountName" },
            { "data": "mobile" },
            { "data": "message" },
            { "data": "dataSign" },
            {
                "data": "id",
                "render": function (data) {
                    return `<div class="text-center">
                        <a href="/Config/SmsInsertOrUpdate?id=${data}" class='btn btn-success text-white' style='cursor:pointer; width:70px;'>
                            Edit
                        </a>
                        &nbsp;
                        <a class='btn btn-danger text-white' style='cursor:pointer; width:70px;'
                            onclick=Delete('/api_alert/DeleteSmsConfig?id='+${data})>
                            Delete
                        </a>                        
                        </div>`;
                }
            }
        ],
        "language": {
            "emptyTable": "no data found"
        },
        "width": "100%"
    });
}

function UpdateStatus(url) {
    $.ajax({
        type: "DELETE",
        url: url,
        success: function (data) {
            if (data.success) {
                toastr.success(data.message);
            }
            else {
                toastr.error(data.message);
            }
        }
    });
}