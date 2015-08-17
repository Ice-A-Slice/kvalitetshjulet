/**
 * Created by Shin1ng on 2014-09-10.
 */

   /////////////////////////////////////////////////
  // Function to toggle events shown in wheel    //
 //  Grund: Shining                             //
/////////////////////////////////////////////////

var savedDots = [];


function eventPicker(){

    $('#eventViews').children('.eventChoose').each(function() {
        var $this = $(this),
            $marker = $this.find('.eventMarker');
        $marker.css("background-color", $marker.data('color'));
    });

    $('.eventMarker').on('click', function() {
        var originColor = getBackgroundColor($(this).data('color'));

        for (var t in wheel.rings){
            if($(this).css('background-color') == originColor) {
                for(var i = 0; i < weekcount; i++){
                    var dotArray = wheel.rings[t].getWedgeById(i).getAttrs().dot;
                    if(dotArray != null){
                        wheel.rings[t].getWedgeById(i).removeEvent(originColor);
                    }
                }
            } else {
                for(var i = 0; i < gon.school_events[t].length; i++) {
                    wheel.rings[t].getWedgeById(i).addEvent(originColor);
                }
            }
        }

        $(this).css('background-color', $(this).css('background-color') == originColor ? "rgb(255, 255, 255)" : originColor );


        stage.draw();
    });

    function getBackgroundColor(data){
        return colorObj[data];
    }
}

function initiateEventTypesOverWheel() {
    var eventTypes = gon.event_types,
        $container = $('#eventViews');
    
    var $box = $('<div/>',  { class: 'eventChoose' })
        .append($('<div/>', { class: 'eventMarker' }))
        .append($('<span/>',{ 'data-type': 'name'  }));

    for (var et in eventTypes) {
        if (eventTypes.hasOwnProperty(et)) {
            var $tag = $box.clone();
            $tag.find('[data-type="name"]').html(eventTypes[et].name);
            $tag.find('.eventMarker').attr('data-color', eventTypes[et].color)
                .css('background-color', eventTypes[et].color);
            $tag.appendTo($container);
        }
    }

    $(document).on('click', '.eventChoose', function() {
        var $this = $(this),
            eventMarker = $this.find('.eventMarker'),
            color = eventMarker.data('color');
        wheel.toggleEventsWithColor(color);

        eventMarker.css('background-color', eventMarker.css('background-color') != "rgb(255, 255, 255)" ? "rgb(255, 255, 255)" : color);
    });
    
}

/*
<div class="eventChoose">
    <div class="eventMarker" data-color="green"></div>
    <span>Värdegrundsarbete</span>
</div>
*/
