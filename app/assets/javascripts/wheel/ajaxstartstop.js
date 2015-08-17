
///////////////////////////////////
// Function to slide out events  //
//  Grund: Khyber                //
///////////////////////////////////
function loadSideWithAjax(sUrl) {
    $.ajax({
        url: sUrl,
        type: "get",
        dataType: "html",
        // Data from the database prints out in a div with the id event_wrapper this.attrs.id.
        success: function (resp) {
            $("#event_wrapper").empty()
                .hide()
                .html(resp);
            // Toggle Options
            // 1. Desired Effect
            // 2. What Direction
            // 3. Duration in millisecs.
            $('#event_wrapper').show('slide', { direction : 'left', speed : 400 });
            //console.log('loaded: ' + sUrl);
        }
    });
    setTimeout(function () {
        $("#ev_wrap").css({'height': ($("#event_wrapper").height())});
    }, 685);
}
function loadMultipleShows(urlArr) {
    var test = "";
    $("#event_wrapper").empty().hide();
    urlArr.forEach(function(url) {
        $.ajax({
            type: "get",
            url: url,
            dataType: "html",
            success: function(data) {
                $("#event_wrapper").append(data);
                test += data;
            }
        });
    });
    $('#event_wrapper').show('slide', { direction : 'left', speed : 400 });
}

/////////////////////////////////////////////////////////
// Runs everytime Ajax has finished to bind clickables //
//  Base: Alfred                                       //
/////////////////////////////////////////////////////////

$(document).ajaxStop(function () {

// Reassures that the buttons functions doesn't run twice when pressed
    $('button.unbind_click').unbind('click');

    $('button[data-deletefile]').click(function () {
        var r = confirm("Are you sure?");
        if (r == true) {
            $(this).parent().hide();
            $.ajax({
                url: $(this).data('deletefile'),
                type: 'get',
                dataType: 'html',

                success: function (resp) {
                    $("#delete_file").hide();
                }
            });
        }
    });
// Sets the current in high_lights hidden field
    var c_year = new Date().getFullYear();
    $("#high_light_year").val(c_year);

    var year = gon.year_selected - 1;
    
    var week = $("#event_datetime").data('week') + 1;
    console.log(week, year);
    var d = new Date("Dec 30, " + year + " 01:00:00");
    var w = d.getTime() + 604800000 * (week - 1);
    var n1 = new Date(w);
    var n2 = new Date(w + 518400000);

// Adds the calenderview input to the form
// minDate and maxDate sets the restrictions for ea week. Will be changed to working variables.
    $(function () {
        $("#event_datetime").datepicker({
            showWeek: true,
            firstDay: 1,
            minDate: n1,
            maxDate: n2,
            showOtherMonths: true,
            selectOtherMonths: true,
            dateFormat: 'yy-mm-dd'
        });
    });

    $('#output').colorPicker({
        defaultColor: $('#pre_color').val(),
        click: function(id){$('#dot_color input').val(id);}
    });

    $('button[data-editevent]').click(function () {
        loadSideWithAjax($(this).data('editevent'));
    });
});