var Draw = {};

   ////////////////////////////////////////////
  // Function to draw months grey/white     //
 //  Created By: Alfred                    //
////////////////////////////////////////////

Draw.monthColors = function(data) {
    var monthRing = new Kinetic.Shape({
        x: data.centerX,
        y: data.centerY,
        sceneFunc: function (context) {
            context.beginPath();
            context.arc(0, 0, (data.outerRadius - data.innerRadius) * 1.1625, Helper.radians(data.startingAngle), Helper.radians(data.endingAngle), false);
            context.fillStrokeShape(this);
        },
        fill: data.color,
        opacity: 1,
        stroke: data.color,
        strokeWidth: data.outerRadius - data.innerRadius
    });

    return monthRing;
}

   ////////////////////////////////////////////
  // Function to draw the triangular wedges //
 //  Created By: Alfred                    //
////////////////////////////////////////////

Draw.line = function(data) {
    if (!data || !data.x1 || !data.x2 || !data.y1 || !data.y2 ) throw new Error('You must insert an object with correct values into Draw.line()')
    var line = new Kinetic.Line({
            points: [data.x1, data.y1, data.x2, data.y2],
            stroke: data.color || Draw.DEFAULT_COLOR,
            strokeWidth: 1
    });
    return line;
}


   ////////////////////////////////////////////
  // Function to draw the outer ring        //
 //  Created By: Alfred                    //
////////////////////////////////////////////

Draw.outerRing = function(data) {
    var ring = new Kinetic.Shape({
        x: data.centerX,
        y: data.centerY,
        radius1: data.radius,
        radius2: data.radius,
        start: 0,
        stop: 360,

        sceneFunc: function (context) {
            context.beginPath();

            var start = Helper.radians(this.attrs.start), stop = Helper.radians(this.attrs.stop);

            context.arc(0, 0, this.attrs.radius1, start, stop, false);
            context.arc(0, 0, this.attrs.radius2, stop, start, true);
            context.closePath();
            context.fillStrokeShape(this);
        },
        fill: data.color || Draw.DEFAULT_COLOR,
        opacity: 0.8,
        stroke: data.color || Draw.DEFAULT_COLOR,
        strokeWidth: 0.5
    });
    return ring;
}

Draw.eventDot = function(data) {
    data = data || {};
    if (!data.events) throw new Error('data.events is required in Draw.eventDot(data)');
    var len = data.events.length;
    if (len < 1) throw new Error('Atleast one event is needed in Draw.eventDot(x, y, rad, data)');

    if (len === 1) {
        var circle = new Kinetic.Circle({
            x: data.x || 100,
            y: data.y || 100,
            radius: data.radius || 20,
            fill: data.events[0] || Draw.DEFAULT_DOT_COLOR,
            stroke: data.stroke || Draw.DEFAULT_COLOR,
            strokeWidth: Draw.DEFAULT_DOT_STROKE_WIDTH,
            listening: false
        });
        return circle;
    }
    var dotLayer = new Kinetic.Group();
    for (var i = 0, e, dot; e = data.events[i++];) {
        dot = new Kinetic.Wedge({
            x: data.x || 100,
            y: data.y || 100,
            radius: data.radius || 20,
            angle: 360 / len,
            fill: e || DRAW.DEFAULT_DOT_COLOR,
            rotation: Draw.DEFAULT_DOT_ROTATION + (360 / len) * i,
            stroke: Draw.DEFAULT_COLOR,
            strokeWidth: Draw.DEFAULT_DOT_STROKE_WIDTH,
            visible: true,
            listening: false
        });
        dotLayer.add(dot);
    }

    return dotLayer;

}


Draw.DEFAULT_COLOR = "#444"
Draw.DEFAULT_DOT_COLOR = "#F00"
Draw.DEFAULT_DOT_ROTATION = -90
Draw.DEFAULT_DOT_STROKE_WIDTH = -90