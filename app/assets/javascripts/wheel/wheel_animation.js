function animation(ajax) {
    if (wheelIsCentered()) {
        
        // Check if screen is big enought for animating the form on the left side of the wheel
        if ($(window).width() > 1100) {    
            // $('.kineticjs-content').animate({'margin-left': '0px'}, 680);
            // $('#wheel_container').animate({'width:640;': '0px'}, 680);
            toggleWheelLeft();
        } else {
            // showEventsAtBottom();
        }

        setTimeout(function () {
            var css = {
                'border-left': '1px solid #f6f6f6', 
                'background': '-webkit-radial-gradient( 0% 50%, 5% 70%, rgba(200,200,200,1) 0%, rgba(210,210,210,0.00) 75% )',
                'padding-right': '10px' 
           };

            $('#ev_wrap').css(css);
        }, 680);

        setTimeout(function () {
            if (Object.prototype.toString.call(ajax) === '[object Array]' ) {
                loadMultipleShows(ajax);
            } else {
                loadSideWithAjax(ajax);
            }
        }, 250);

    } else {
        if (Object.prototype.toString.call(ajax) === '[object Array]' ) {
            loadMultipleShows(ajax)
        } else {
            loadSideWithAjax(ajax);
        }
    }
}

var toggleWheelLeft = (function() {
    var initialWidth = 'large-8',
        fullWidth = 'large-12',
        initialEWidth = 'large-3',
        fullEWidth = 'large-6';

    return function() {
        var c = $('#outer-wheel-container');
        var e = $('#outer-event-container');
        if (c.has("[class^='large']")) {
            var classes = c[0].className.split(' ');
            for (var i = 0, child; child = classes[i++];){
                if (child.slice(0,6) === 'large-') {

                    if (initialWidth === null) {
                        initialWidth = child;
                    }

                    if (initialWidth === child) {
                        c.removeClass(child)
                            .addClass(fullWidth)
                        // e.removeClass(initialEWidth)
                        //     .addClass(fullEWidth)

                        return '100% width';
                    } else {

                        c.removeClass(fullWidth)
                            .addClass(initialWidth)
                        // e.removeClass(fullEWidth)
                        //     .addClass(initialEWidth)

                        return 'initial width';
                    }

                    break;
                }
            }
        }
    }
})();

var showEventsAtBottom = (function() {
    var initialWidth = 'large-6',
        fullWidth = 'large-12';

    return function() {
        var c = $('#outer-event-container'),
            w = $('#outer-wheel-container');

        c.css('margin-top', w.height() + 5);

    }
})();

var hideWheel = function() {

}

function wheelIsCentered() {
    return ($('#outer-wheel-container').hasClass('large-12'))
}