var Wedge = function(data) {
    var _this = this;
    this.parentRing = data.parentRing;
    this.weekNr = data.weekNr;
    this.innerRadius = data.innerRadius;
    this.outerRadius = data.outerRadius;
    this.startPoint = data.startPoint;
    this.wedgeWidth = data.wedgeWidth;
    this.stopPoint = data.startPoint + this.wedgeWidth;
    this.centerX = data.centerX;
    this.centerY = data.centerY;
    this.color = data.color;
    this.hideShape = null;
    this.opacity = data.opacity || Wedge.DEFAULT_OPACITY;
    this.strokeColor = data.strokeColor || Wedge.DEFAULT_STROKE_COLOR;
    this.strokeWidth = data.strokeWidth || Wedge.DEFAULT_STROKE_WIDTH;
    this.events = [];
    this.titles = [];
    this.dot = null;
    this.mouseOver = null;

    this.updateShape();

    this.bindEvents();

    return this;
};

Wedge.prototype = {

    setColor: function(color) {
        this.color = color;
        this.shape.fill(color);
        return this;
    },

    setOpacity: function(opacity) {
        this.opacity = opacity;
    },

    setWidth: function(w) {
        this.outerRadius += w/2;
        this.innerRadius -= w/2;
        return this;
    },

    updateShape: function() {
        var _this = this;
        _this.shape = new Kinetic.Shape({
            sceneFunc: function(context) {
                context.beginPath();
                var start = Helper.radians(_this.startPoint),
                    stop = Helper.radians(_this.stopPoint);

                // Outer arc
                context.arc(_this.centerX, _this.centerY, _this.outerRadius, start, stop, false);

                // Inner arc
                context.arc(_this.centerX, _this.centerY, _this.innerRadius, stop, start, true);

                context.closePath();
                context.fillStrokeShape(this);
            },
            fill: _this.color,
            opacity: _this.opacity,
            stroke: _this.strokeColor,
            strokeWidth: _this.strokeWidth
        });
    },

    getParent: function() {
        return this.parentRing;
    },

    getRingName: function() {
        return this.getParent().getName();
    },

    getWeekNr: function() {
        return this.weekNr;
    },

    getShape: function() {
        return this.shape;
    },

    setBounds: function(outer, inner) {
        this.outerRadius = outer;
        this.innerRadius = inner;
        this.updateShape();
        if (this.hasEvents()) this.drawDot();
    },

    hasEvents: function() {
        return this.getEventCount() > 0;
    },

    unsetDot: function() {
        if (this.hasDot()) {
            this.getDot().remove();
            this.dot = null;
        }
        return this;
    },

    getEventCount: function() {
        return this.getEventColors().length;
    },

    getEventColors: function() {
        return this.events;
    },

    setEventColors: function(colorArray) {
        this.events = colorArray;
        return this;
    },

    updateColor: function(from, to) {
        var colorArray = this.getEventColors();

        for (var i = 0, len = colorArray.length; i < len; i++) {
            if (colorArray[i] === from) {
                colorArray[i] = to;
                break;
            }

            if (i === len-1) {
                console.warn('There were no event colored ' + from + ' on week ' + this.getWeekNr());
            }
        }
        this.setEventColors(colorArray);
        this.drawDot();
        return this;
    },

    update: function(data) {
        var colorArray = this.getEventColors(),
            titleArray = this.getTitles(),
            from = data.from,
            to = data.to;

        for (var i = 0, len = colorArray.length; i < len; i++) {
            if (colorArray[i] === from.color && titleArray[i] === from.title) {
                colorArray[i] = to.color;
                titleArray[i] = to.title;
                break;
            }

            if (i === len-1) {
                console.warn('There were no event colored ' + from + ' on week ' + this.getWeekNr());
            }
        }
        this.setEventColors(colorArray);
        this.setTitlesArray(titleArray);

        this.drawDot();
        return this;

    },

    setTitlesArray: function(arr) {
        this.titles = arr;
    },

    getCenterPosition: function() {
        var centerAngle = this.stopPoint - ((this.stopPoint - this.startPoint) / 2);
        var rad = this.outerRadius - ((this.outerRadius - this.innerRadius) / 2)
        return {
            x: this.centerX + rad * Math.cos(Helper.radians(centerAngle)),
            y: this.centerY + rad * Math.sin(Helper.radians(centerAngle))
        };
    },

    onMouseClick: function(wedge) {
        var _this = wedge;
        return function(e) {
            // if (permissionHandler.userType(gon.current_user_type).canEdit(_this.getRingName())) {
            //     console.log('yeap');
            // } else {
            //     console.log('nope');
            // }

            if (e.which !== 1) return;

            var weekNumber = _this.getWeekNr(),
                userType = gon.current_user_type,
                ringName = _this.getRingName();

            if (_this.hasEvents()) {
                if (ringName === 'principal') {
                    if (gon.current_schools.length) {
                        var arr = [];
                        gon.current_schools.forEach( function(school) {
                            arr.push("sessions/show_week_events/" + weekNumber + "/" + school.id);
                        });
                        animation(arr);
                    } else {
                        animation("sessions/show_week_events/" + weekNumber + "/" + userType);
                    }
                } else {
                    var url = "sessions/show_week_events/" + weekNumber + "/" + ringName;
                    animation(url);
                }
                
                wheel.unselectAllWedges();
                _this.hideShape = this;
                _this.setSelected();

            } else {
                if (permissionHandler.userType(userType).canEdit(ringName)) {
                    
                    animation("sessions/new_week_event/" + weekNumber + "/" + ringName);

                    wheel.unselectAllWedges();
                    _this.hideShape = this;
                    _this.setSelected();
                }
            }
        }
    },

    setSelected: function() {
        if (this.hideShape !== null) {
            wheel.addToSelectedWedges(this.getRingName(), this.getWeekNr());
            this.hideShape.opacity(0.5);
            this.getParentLayer().draw();
        }
        return this;
    },

    unsetSelected: function() {
        if (this.hideShape !== null) {
            this.hideShape.opacity(1);
            this.getParentLayer().draw();
        }
    },
    startTimerForHover: function() {
        var _this = this;
        setTimeout(function() {
            if (_this.mouseOver) {
                _this.setTitles();
                wheel.showTitleBox();
            }
        }, 500);
    },

    setTitles: function() {
        wheel.setTitles(this.titlesToHML());
        return this;
    },

    stringifyTitles: function() {
        return this.getTitles().join(', ')
    },

    getTitles: function() {
        return this.titles;
    },

    titlesToHML: function() {
        var $cont = $('<div/>'),
            colors = this.getEventColors(),
            titles = this.getTitles();

        for (var i = 0, color; color = colors[i]; i++) {
            var t = titles[i];
            if (t.length > 20) {
                t = t.slice(0, 17);
                while (t[t.length-1] === ' ') t = t.slice(0, t.length-1)

                t += '...';
            }

            $('<tr>').append(
                $('<td/>').append(
                    $('<div/>', {
                        class: 'marker',
                        css: { backgroundColor: color }
                    })
                )
            ).append($('<td/>').append(
                    $('<span/>', { html: t })
                )
            ).appendTo($cont)
        }
        return $cont.html();
    },

    onMouseOver: function(wedge) {
        var _this = wedge;
        return function(e) {
            _this.mouseOver = true;
            if (_this.hasEvents()) {
                _this.startTimerForHover();
            }
            if (_this.hasEvents() || permissionHandler.userType(gon.current_user_type).canEdit(_this.getRingName())) {
                $('canvas').css('cursor','pointer');
            }
        }
    },

    onMouseOut: function(wedge) {
        var _this = wedge;
        return function() {
            _this.mouseOver = false;
            wheel.hideTitleBox();
            if ($('canvas').css('cursor') !== 'default') $('canvas').css('cursor','default');
            $(document).children('.event-title.box').hide();
        }
    },

    bindEvents: function() {
        var _this = this;
        _this.shape.on('click', _this.onMouseClick(_this))
            .on('mouseover', _this.onMouseOver(_this))
            .on('mouseout', _this.onMouseOut(_this));
    },

    addEvent: function(color, title) {
        if (typeof color !== 'string') throw new Error('function Wedge.addEvent(color) accepts only a string as parameters')
        this.events.push(color);

        if (typeof title === 'undefined') title = "Ingen titel"
        this.titles.push(title)

        this.drawDot();
    },

    getDot: function() {
        return this.dot;
    },

    hasDot: function() {
        return this.dot !== null;
    },

    destroyEvent: function(color, title) {

        var colors = this.getEventColors(),
            titles = this.getTitles(),
            len = colors.length;

        console.log(this.getEventColors());
        if (len === 0) {
            console.warn('There are no events on \n'
                + ' ring: ' + this.parentRing.getName() + '\n'
                + ' week: ' + this.weekNr);
            return this;
        }

        for (var i = 0; i < len; i++) {
            if (color === colors[i] && title === titles[i]) {
                this.events.splice(i, 1);
                this.titles.splice(i, 1);

                this.drawDot();
                break;
            }

            if (i === len) {
                console.warn('There are no events colored ' + color + ' on \n'
                    + ' ring: ' + this.parentRing.getName() + '\n'
                    + ' week: ' + this.weekNr);
                return this;
            }
        }
        return this;
    },

    drawDot: function() {
        var pos = this.getCenterPosition(),
            events = this.getEventColors().except(wheel.getHiddenEventColors())

        this.unsetDot();

        if (this.hasEvents() && events.length > 0) {
            this.dot = Draw.eventDot({
                events: events,
                x: pos.x,
                y: pos.y,
                radius: this.wedgeWidth * 1.2
            });
            this.getParentLayer().add(this.getDot());
        }

        // this.titleBox.html(this.stringifyTitles());
        
        return this;
    },

    getParentLayer: function() {
        return this.getParent().getLayer();
    },

    getWeekNr: function() {
        return this.weekNr;
    },

    setOpacity: function(opacity) {
        this.opacity = opacity;
        this.updateShape();
    }
}


Wedge.setDefaults = function() {
    Wedge.DEFAULT_STROKE_COLOR = '#444';
    Wedge.DEFAULT_STROKE_WIDTH = 0.5;
    Wedge.DEFAULT_EVENT_COUNT = 0;
    Wedge.DEFAULT_OPACITY = 1;
}