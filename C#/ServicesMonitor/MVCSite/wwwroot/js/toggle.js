var sidebarState = sessionStorage.getItem('sidebarState');
var menuState = sessionStorage.getItem('menuState');

windowWidth = $(window).width();

//$(window).resize(function () {
//    windowWidth = $(window).width();

//    if (windowWidth < 992) { //992 is the value of $screen-md-min in boostrap variables.scss
//        $('#main-section').removeClass('sidebar-expanded').addClass('sidebar-collapsed');
//        $('#toggle-collapse').removeClass('glyphicon-circle-arrow-left').addClass('glyphicon-circle-arrow-right');
//    }
//    else {
//        if (sidebarState) {
//            $('#main-section').addClass('sidebar-collapsed').removeClass('sidebar-expanded');
//            $('#toggle-collapse').removeClass('glyphicon-circle-arrow-left').addClass('glyphicon-circle-arrow-right');
//        }
//        else {
//            $('#main-section').addClass('sidebar-expanded').removeClass('sidebar-collapsed');
//            $('#toggle-collapse').removeClass('glyphicon-circle-arrow-right').addClass('glyphicon-circle-arrow-left');
//        }
//    }
//});


$(function () {
    // Sidebar toggle behavior
    $('#sidebarCollapse').on('click', function () {
        $('#sidebar, #content').toggleClass('active');
    });
});

function setState(item,value) {
    sessionStorage.setItem(item, value);
}

function clearState(item) {
    sessionStorage.removeItem(item);
}

$('#subConfigs').on('shown.bs.collapse',
    function () {
        setState('menuState', 'show');
    });
$('#subConfigs').on('hidden.bs.collapse',
    function () {
        setState('menuState', 'hide');
    });

$(function() {
    if (menuState === 'show') {
        $('.collapse').collapse();
    }
});