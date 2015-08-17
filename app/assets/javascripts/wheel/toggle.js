function toggle() {
    var r = confirm('Är du säker på att du vill avbryta?');
    if (r == true) {
        $('#event_wrapper').toggle('slide', 'left', 400)
        setTimeout(function () {
            if ($(window).width() > 1100) toggleWheelLeft();
            $('#ev_wrap').css({ borderLeft: 'none', 
                                background: 'none', 
                                paddingRight: 0,
                                height: 'auto' });
        }, 250);
    }
}

function deleteEvent(thisEvent, week) {
    var r = confirm('Är du säker på att du vill ta den här händelsen?');
    if (r == true) {
        $(thisEvent).parent().hide();
        if (gon.c_user_type == "teacher") {
            week = parseInt(week)-1;
            wheel.rings[gon.c_user_type].getWedgeById(week).removeHighLight();
            Layers[gon.c_user_type].draw();
        }
    }
}
