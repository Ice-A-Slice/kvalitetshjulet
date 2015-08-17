   ////////////////////////////////////////////
  // Function to draw months grey/white     //
 // Grund: Shining                         //
////////////////////////////////////////////

function backRing(startingAngle, endingAngle, color) {
    var monthRing = new Kinetic.Shape({
        x: cX,
        y: cY,
        sceneFunc: function (context) {
            context.beginPath();
            context.arc(0, 0, 210, radians(startingAngle), radians(endingAngle), false);
            context.fillStrokeShape(this);
        },
        fill: color,
        opacity: 1,
        stroke: color,
        strokeWidth: 180
    });

    backgroundLayer.add(monthRing);
}

   ////////////////////////////////////////////
  // Function to draw the triangular wedges //
 //  Grund: Shining                        //
////////////////////////////////////////////

function linemaker(xls, yls, xle, yle) {
    var line = new Kinetic.Line({
            points: [xls, yls, xle, yle],
            stroke: '#444',
            strokeWidth: 1
    });

    backgroundLayer.add(line);
}


//Ring on outer edge
function outerRingmaker() {
    var ring = new Kinetic.Shape({
        x: cX,
        y: cY,
        radius1: 300,
        radius2: 301,
        start: 0,
        stop: 360,

        sceneFunc: function (context) {
            context.beginPath();

            var start = radians(this.attrs.start), stop = radians(this.attrs.stop);

            context.arc(0, 0, this.attrs.radius1, start, stop, false);
            context.arc(0, 0, this.attrs.radius2, stop, start, true);
            context.closePath();
            context.fillStrokeShape(this);
        },
        fill: '#444',
        opacity: 0.8,
        stroke: '#444',
        strokeWidth: 0.5
    });
    backgroundLayer.add(ring);
}