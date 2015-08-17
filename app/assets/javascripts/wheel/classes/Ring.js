var Ring = function(data) {
    var _this = this;
    _this.name = data.name;
    _this.width = data.width;
    _this.layer = new Kinetic.Layer();
    _this.outerRadius = data.outerRadius;
    _this.centerX = data.centerX;
    _this.centerY = data.centerY;
    _this.weekCount = data.weekCount;
    _this.thisYearsDayCount = Ring.getDefault('DAY_COUNT');
    _this.wedgeWidth = Ring.getDefault('DEGREES') / _this.weekCount;
    _this.color = data.color || Ring.getDefault('COLOR');
    _this.startingAngle = data.startingAngle || Ring.getDefault('STARTING_ANGLE');
    _this.opacity = data.opacity || Ring.getDefault('OPACITY');
    _this.margin = data.margin || Ring.getDefault('MARGIN');
    _this.visible = true;
    _this.wedges = [];
    _this.animations = {};

    _this.realName = data.realName;

    _this.innerRadius = _this.outerRadius - _this.margin;

    AnimationFactory.prototype.callAnimations.call(this, ['hide', 'show']);

    for (var i = 0, w; i < this.weekCount; i++) {
        w = new Wedge({
            parentRing: _this,
            weekNr: i,
            innerRadius: _this.innerRadius,
            outerRadius: _this.outerRadius,
            startPoint: _this.startingAngle + _this.wedgeWidth * i,
            wedgeWidth: _this.wedgeWidth,
            centerX: data.centerX,
            centerY: data.centerY,
            color: _this.color,
        })
        _this.wedges.push(w);
        _this.layer.add(w.getShape());
    }

    return this;
}

Ring.prototype = {
    getLayer: function() {
        return this.layer;
    },

    getName: function() {
        return this.name;
    },

    getRealName: function() {
        return this.realName;
    },

    setRealName: function(name) {
        this.realName = name;
        return this;
    },

    getAllEvents: function() {
        var ret = [],
            wedges = this.getWedges(),
            ringName = this.getName();

        for (var i = 0, w; w = wedges[i++];) {
            var events = w.getEventColors();
            for (var x = 0, e; e = events[x++];) {
                ret.push({week: w.getWeekNr(), color: e});
            }
        }

        return ret;

    },

    redraw: function() {
        this.getLayer().draw();
        return this;
    },

    getWidth: function() {
        return this.width;
    },

    setWidth: function(w) {
        this.width = w;
        for (var i = 0, wedge; wedge = this.wedges[i++];) {
            wedge.setWidth(w);
        }
    },

    setBounds: function(outerBounds, innerBounds) {
        this.outerRadius = outerBounds;
        this.innerRadius = (typeof innerBounds !== 'undefined') ? innerBounds : outerBounds - this.width;
        this.updateBounds();
        return this;
    },

    updateBounds: function() {
        var _this = this;
        for (var i = 0, w; w = this.wedges[i++];) {
            w.setBounds(_this.innerRadius, _this.outerRadius);
        }
    },

    getWedge: function(weekNr) {
        if (!this.wedges[weekNr]) throw new Error('There doesn\'t seen to be a wedge on week ' + weekNr);
        return this.wedges[weekNr];
    },

    getWedges: function() {
        return this.wedges;
    },

    updateShapes: function() {

    },

    getOpacity: function(opacity) {
        return this.getLayer().opacity();
    },

    isVisible: function() {
        return this.visible;
    },

    redrawDots: function() {
        var wedges = this.getWedges();
        for (var i = 0, w; w = wedges[i++];) {
            w.drawDot();
        }   
    },

    setOpacity: function(opacity) {
        var _this = this;
        this.opacity = opacity;
        for (var i = 0, w; w = this.wedges[i++];) {
            w.setOpacity(opacity);
        }
        this.getLayer().opacity(opacity);
        return this;
    },

    startAnimation: function(ani) {
        this.getAnimation(ani).start();
    },

    getAnimation: function(name) {
        if (!this.animations[name]) throw new Error('No animation found called ' + name);
        return this.animations[name];
    },

    hide: function() {
        this.startAnimation('hide');
        this.visible = false;
        return this;
    },

    show: function() {
        this.startAnimation('show');
        this.visible = true;
        return this;
    }
}

Ring.getDefault = function(name) {
    return Ring['DEFAULT_' + name];
}

Ring.setDefaults = function() {
    Ring.DEFAULT_COLOR = "#dcdcdc";
    Ring.DEFAULT_STARTING_ANGLE = -90;
    Ring.DEFAULT_DAY_COUNT = Wheel.DEFAULT_DAY_COUNT;
    Ring.DEFAULT_DEGREES = Wheel.DEFAULT_DEGREES;
    Ring.DEFAULT_WIDTH = 25;
    Ring.DEFAULT_MARGIN = 25;
    Ring.DEFAULT_OPACITY = 1;
    Ring.DEFAULT_OUTER_BOUNDS = 100;
}
