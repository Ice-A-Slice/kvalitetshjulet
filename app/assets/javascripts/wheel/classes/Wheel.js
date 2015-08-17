var Wheel = function(data) {
    data = data || {};

    var _this = this;

    _this._weekCount = 52;
    _this._rings = {};
    _this.container = data.container || Wheel.DEFAULT_CONTAINER;
    _this._stage = new Kinetic.Stage({
        container: _this.container
    });
    _this._backgroundLayer = new Kinetic.Layer();

    _this.setWidth(data.width || Wheel.DEFAULT_WIDTH);
    _this.setHeight(data.height || Wheel.DEFAULT_HEIGHT);
    _this._radius = _this.width()/2 * 0.9375;
    _this._pictureRadius = _this.getRadius() * 0.4;
    _this._margin = Wheel.DEFAULT_MARGIN;
    _this._hiddenEventColors = [];

    _this.setTitleBox();
    
    _this.getStage().add(_this.getBGLayer());

    _this.selectedWedges = {};

    imagemaker(_this.getBGLayer());

    return _this;
}

Wheel.prototype = {

    // Add all inital rings here
    createRings: function(rings) {
        if (!(rings instanceof Array)) rings = [rings];

        for (var i = 0, r; r = rings[i++];) {
            this.createRing(r.name, r.realName);
        }

        wheel.autoSize();

        return this;
    },

    setTitleBox: function() {
        this._titleBox = $('#eventTitles');
        var _this = this,
            pictureRadius = _this.getPictureRadius(),
            radius = _this.getRadius();

        // console.log(pos);
        this.getTitleBox().css({
            width: pictureRadius*2,
            height: pictureRadius*2,
            top: radius - (pictureRadius/2) - 40,
            left: (radius - (pictureRadius/2)) * 0.835,
            borderRadius: pictureRadius*2
        }).hide().appendTo($('#wheel_container'));

    },

    setTitles: function($elem) {
        this.getTitleBox().find('table').html($elem);
        return this;
    },

    getTitleBox: function() {
        return this._titleBox;
    },

    hideTitleBox: function() {
        this.getTitleBox().hide();
    },

    showTitleBox: function() {
        this.getTitleBox().show();
    },

    getContainer: function() {
        return this.container;
    },

    hasRing: function(ringName) {
        return typeof(this._rings[ringName]) !== 'undefined'
    },

    createEvents: function(events) {

        // Creates two events on the first week of the year of 
        // the admin-ring, colored green and yellow, with respective titles.
        /*
        *  this.createEvent('admin', 0, 'green', 'Title one')
        *      .createEvent('admin', 0, 'yellow', 'Title two');
        */

        for (var ringName in events) {
            if (events.hasOwnProperty(ringName)) {
                var ringEvents = events[ringName],
                    colors = [],
                    titles = [];

                for (var week = 0, arr; arr = ringEvents[week++];) {
                    if (arr.length > 0) {
                        this.createEvent({
                            ringName: ringName,
                            week: week-1,
                            events: arr
                        });
                    }
                }

            }
        }

        return this;
    },

    updateEventColor: function(ringName, week, fromColor, toColor) {
        this.getRing(ringName).getWedge(week).updateColor(fromColor, toColor);
        return this;
    },

    destroyEvent: function(ringName, weekNr, color, title) {
        var wedge = this.getRing(ringName).getWedge(weekNr);

        wedge.destroyEvent(color, title);

        return this;
    },

    createEvent: function(data) {
        data = data || {};
        if (typeof(data.ringName) !== 'string') throw new Error('data.ringName must be a string in function createEvent(data)');
        if (typeof(data.week) !== 'number') throw new Error('data.weekNr must be a number in function createEvent(data)');

        var ring = this.getRing(data.ringName),
            wedge = ring.getWedge(data.week);

        for (var i = 0, e; e = data.events[i++];) {
            wedge.addEvent(e.color, e.title);
        }

        return this;
    },

    createRing: function(name, realName, outerBounds, width) {
        if (typeof(name) !== 'string') throw new Error('name in function wheel.createRing(name, outerBounds, width) must be a string.')

        var width = width || Ring.getDefault('WIDTH'),
            centerX = this.getCenterX(),
            centerY = this.getCenterY(),
            oR = outerBounds || Ring.getDefault('OUTER_BOUNDS'),
            weekCount = this.getWeekCount();

        var ring = new Ring({
            name: name,
            realName: realName,
            width: width,
            outerRadius: oR,
            centerX: centerX,
            centerY: centerY,
            weekCount: weekCount
        });

        this.addRing(ring);
        this.updateAllRingsBounds();
        return this;
    },

    redrawRing: function(ringName) {
        this.getRing(ringName).redraw();
        return this;
    },

    getRing: function(name) {
        if (!this._rings[name]) console.error('There is no ring called ' + name);
        return this._rings[name];
    },

    getRings: function() {
        return this._rings;
    },

    getRingsArray: function() {
        var rings = this.getRings(),
            ret = [];
        for (var k in rings) {
            if (rings.hasOwnProperty(k)) ret.push(rings[k]);
        }
        return ret;
    },

    getHiddenEventColors: function() {
        return this._hiddenEventColors;
    },

    addToHiddenEventColors: function(color) {
        this._hiddenEventColors.push(color);
        return this;
    },

    hideEventsColored: function(color) {
        this.addToHiddenEventColors(color)
            .redrawAllDots()
            .getStage().draw();

        return this;
    },

    showEventsColored: function(color) {
        this.removeFromHiddenEventColors(color)
            .redrawAllDots()
            .getStage().draw();

        return this;
    },

    toggleEventsWithColor: function(color) {
        this.getHiddenEventColors().contains(color) ?
            this.showEventsColored(color):
            this.hideEventsColored(color);

        return this;
    },

    removeFromHiddenEventColors: function(color) {
        var arr = this.getHiddenEventColors();
        for (var i = 0, col; col = arr[i++];) {
            if (col === color) {
                arr = arr.splice(i-1,1)
                break;
            }
        }
        return this;
    },

    setRing: function(ringName, ring) {
        if (!(ring instanceof Ring)) throw new Error('Only Ring-objects are allowed in Wheel.setRing()');
        this._rings[ringName] = ring;
        return this;
    },

    getRingCount: function() {
        return this.getRingsArray().length;
    },

    redrawAllDots: function() {
        var rings = this.getRings();
        for (var r in rings) {
            if (rings.hasOwnProperty(r)) {
                rings[r].redrawDots();
            }
        }
        return this;
    },

    getVisibleRings: function() {
        var rings = this.getRings(),
            ret = {};
        for (var r in rings) {
            if (rings.hasOwnProperty(r) && rings[r].isVisible()) {
                ret[r] = rings[r];
            }
        }
        return ret;
    },

    getHiddenRings: function() {
        var rings = this.getRings(),
            ret = {};
        for (var r in rings) {
            if (rings.hasOwnProperty(r) && !rings[r].isVisible()) {
                ret[r] = rings[r];
            }
        }
        return ret;
    },

    getCountOfVisibleRings: function() {
        return Helper.objectSize(this.getVisibleRings());
    },

    addRing: function(ring) {
        this.setRing(ring.getName(), ring);
        this.getStage().add(ring.getLayer());
    },

    getWedge: function(ringName, weekNr) {
        return this.getRing(ringName).getWedge(weekNr);
    },

    getStage: function() {
        return this._stage;
    },

    getMargin: function() {
        return this._margin;
    },

    getBGLayer: function() {
        return this._backgroundLayer;
    },

    getWeekCount: function() {
        return this._weekCount;
    },
    getRadius: function() {
        return this._radius;
    },
    getPictureRadius: function() {
        return this._pictureRadius;
    },

    setWidth: function(width) {
        this._width = width;
        this.getStage().setWidth(width);
    },
    setHeight: function(height) {
        this._height = height;
        this.getStage().setHeight(height);
    },

    width: function(width) {
        return this._width;
    },
    height: function(height) {
        return this._height;
    },

    getCenterX: function() {
        return this.width() / 2;
    },
    getCenterY: function() {
        return this.height() / 2;
    },

    getCurrentRingCount: function() {
        return Helper.objectSize(this.getRings());
    },

    draw: function() {
        this.createBackground()
            .createRings()
            .createEvents();

        var _this = this;
        setTimeout(function() {
            _this.getStage().draw();
        }, 100);
    },

    addToSelectedWedges: function(ringName, week) {
        if (typeof this.selectedWedges[ringName] === 'undefined') this.selectedWedges[ringName] = [];
        this.selectedWedges[ringName].push(week);
        return this;
    },

    removeFromSelectedWedges: function(ringName, week) {
        if (typeof this.selectedWedges[ringName] === 'undefined' || !this.selectedWedges[ringName].contains(week)) {
            return this;
        }

        var i = this.selectedWedges[ringName].indexOf(week);
        this.selectedWedges[ringName].splice(i,1);

        if (this.selectedWedges[ringName].length === 0) {
            delete this.selectedWedges[ringName];
        }

        return this;
    },

    unselectAllWedges: function() {
        var ws = this.selectedWedges;
        for (var w in ws) {
            if (ws.hasOwnProperty(w)) {
                this.getRing(w).getWedge(ws[w]).unsetSelected();

                delete ws[w]
            }
        }
        return this;
    },

    autoSize: function() {
        var vr = this.getVisibleRings(),
            hr = this.getHiddenRings(),
            vrCount = Helper.objectSize(vr),
            hrCount = Helper.objectSize(hr),
            m = this.getMargin(),
            r = this.getRadius() - m,
            pr = this.getPictureRadius() + m,
            range = r - pr,
            w = (range / vrCount);

        var i = vrCount;
        for (var r in vr) {
            if(vr.hasOwnProperty(r)) {
                vr[r].setWidth(w * 0.8);
                var v = w * i + pr + (range / vrCount)/4 - w/3;
                vr[r].setBounds(v);
                vr[r].redraw();

                i--;
            }
        }
    },

    updateAllRingsBounds: function() {
        var rings = this.getRings();
        for (var r in rings) {
            rings[r].updateBounds();
        }
    },

    createBackground: function() {
        var _this = this,
            today = new Date(),
            thisYear = today.getFullYear(),
            weekCount = _this.getWeekCount(),
            radius = _this.getRadius(),
            pictureRadius = _this.getPictureRadius(),
            centerX = _this.getCenterX(),
            centerY = _this.getCenterY(),
            backgroundLayer = _this.getBGLayer();

        // Helper.getMonthDayCount(thisYear) gets the daycount of all
        // the months, with the amount of days from december last year
        // in this year as the first, ex: [2, 31, 28, 31...
        var thisYearMonthDayCount = Helper.getMonthDayCount(thisYear),
            dayWidth = Wheel.DEFAULT_DEGREES / Wheel.DEFAULT_DAY_COUNT,
            startingAngle = 0,
            endingAngle = 270 - dayWidth/2,
            col;

        thisYearMonthDayCount.forEach( function(monthCount, i) {
            startingAngle = endingAngle;
            endingAngle = endingAngle + dayWidth * monthCount;
            col = i % 2 === 0 ? Wheel.getColor('primary') : Wheel.getColor('secondary');

            var mc = Draw.monthColors({
                color: col,
                centerX: _this.getCenterX(),
                centerY: _this.getCenterY(),
                startingAngle: startingAngle,
                endingAngle: endingAngle,
                innerRadius: pictureRadius,
                outerRadius: radius,

            });
            backgroundLayer.add(mc);
        });

        backgroundLayer.add(Draw.outerRing({
            centerX: _this.getCenterX(),
            centerY: _this.getCenterY(),
            radius: radius
        }));

        for (var i = 0; i < weekCount; i++) {
            var angle = (Wheel.DEFAULT_DEGREES / weekCount) * i,
                theta = Helper.radians(angle);

            var xLineStart = centerX + radius * Math.cos(theta),
                yLineStart = centerY + radius * Math.sin(theta),
                xLineEnd = centerX + pictureRadius * Math.cos(theta),
                yLineEnd = centerY + pictureRadius * Math.sin(theta);

            var line = Draw.line({
                x1: xLineStart,
                y1: yLineStart,
                x2: xLineEnd,
                y2: yLineEnd
            });

            backgroundLayer.add(line);
        }

        return this;
    },

}

Wheel.getColor = function(c) {
    if (!Wheel.DEFAULT_COLORS[c.toUpperCase()]) throw new Error('Wheel has no color called ' + c);
    return Wheel.DEFAULT_COLORS[c.toUpperCase()];
}

Wheel.setDefaults = function() {
    Wheel.DEFAULT_COLORS = {
        PRIMARY: '#fff',
        SECONDARY: "#d7e5ec"
    }
    Wheel.DEFAULT_WIDTH = 500;
    Wheel.DEFAULT_HEIGHT = 500;
    Wheel.DEFAULT_DAY_COUNT = 365;
    Wheel.DEFAULT_DEGREES = 360;
    Wheel.DEFAULT_MARGIN = 20;
    Wheel.DEFAULT_CONTAINER = 'wheel-container';
}