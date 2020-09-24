var dataTable;

$(document).ready(function () {
    loadDataTable();
});

function loadDataTable() {
    dataTable = $('#DT_load').DataTable({
        "ajax": {
            "url": "/api_user/GetList/",
            "type": "GET",
            "datatype": "json"
        },
        "columns": [
            { "data": "userName", "width": "10%" },
            { "data": "firstName", "width": "10%" },
            { "data": "lastName", "width": "10%" },
            { "data": "email", "width": "20%" },
            {
                "data": "createdTime",
                "width": "20%",
                "render": function(data) {
                    return convertDatetimeOffset(data);
                }
            },
            {
                "data": "id",
                "render": function (data) {
                    return `<div class="text-center">
                        <a href="/Config/UserInsertOrUpdate?id=${data}" class='btn btn-success text-white' style='cursor:pointer; width:70px;'>
                            Edit
                        </a>
                        &nbsp;
                        <a class='btn btn-danger text-white' style='cursor:pointer; width:70px;'
                            onclick=Delete('/api_user/Delete?id='+${data})>
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