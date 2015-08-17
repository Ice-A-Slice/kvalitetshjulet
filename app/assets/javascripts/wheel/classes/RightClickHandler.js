var RightClickHandler = {};

RightClickHandler.initiate = function(wheel) {
    var ringItems = {},
        ringsArray = wheel.getRingsArray(),
        eventTypes = gon.event_types;

    for (var i = 0, len = ringsArray.length, r; r = ringsArray[i++];) {
        var name = r.getName();
        ringItems['hide-' + name] = {
            name: wheel.getRing(name).getRealName(),
            type: 'checkbox',
            className: 'checkbox-' + name,
            ringName: name,
            callback: function(e) {}
        };
    }


    /* 
    *  So far this code only shows the event-types when you 
    *  rightclick, the functionality is not yet implemented.
    *
    
    ringItems['sep' + (i+1)] = '---------';

    for (var e in eventTypes) {
        if (eventTypes.hasOwnProperty(e)) {
            var et = eventTypes[e];

            ringItems['hide-' + et.name] = {
                name: et.name,
                type: 'checkbox',
                className: 'checkbox-' + et.name,
                ringName: et.name,
                callback: function(e) {}
            }
        }
    }
    */


    $.contextMenu({
        selector: '.kineticjs-content',
        className: 'context-title',
        callback: function(key, options) {
            var m = "clicked: " + key;
            window.console && console.log(m) || alert(m); 
        },
        items: ringItems,
        events: {
            show: function(opt) {
                var $this = this;
                $.contextMenu.setInputValues(opt, $this.data());
                for (var i = 0, ring, name, $checkbox; ring = ringsArray[i++];) {
                    $checkbox = $('.checkbox-' + ring.name).find(':checkbox');
                    $checkbox.data('ring-name', ring.name)
                    name = 'hide-' + ring.name;
                    if (ring.isVisible() && !($checkbox.is(':checked'))) {
                        opt.items[name].selected = true;
                    } else if (!ring.isVisible() && $checkbox.is(':checked')) {                 
                        opt.items[name].selected = false;
                    }
                }
            },
            hide: function(opt) {
                var $this = this;
                $.contextMenu.getInputValues(opt, $this.data());
            }
        }
        
    });
    
    $(document).on('click', '.context-menu-list :checkbox', function() {
        var $this = $(this),
            ringName = $this.data('ring-name');

        if (wheel.hasRing(ringName)) {
            if($this.is(':checked')) {
                wheel.getRing(ringName).show();
            } else {
                wheel.getRing(ringName).hide();
            }
        }
        
        wheel.autoSize();
    });
}