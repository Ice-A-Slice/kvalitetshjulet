var wheel, permissionHandler;

function hideThis(e) {
    e.parentNode.remove()
};

function setDefaults() {
    var classes = [Wheel, Ring, Wedge, PermissionHandler];
    for (var i = 0, cl; cl = classes[i++];) cl.setDefaults();
}

function setPermissions() {
    permissionHandler = new PermissionHandler();

    var sets = ['admin', 'juror', 'principal', 'teacher'];

    permissionHandler.addUserTypes(sets)
        .addClearance(sets);

    // Makes every user-type able to view event on their ring
    for (var i = 0, child; child = sets[i++];) {
        permissionHandler.set([
            child + ' can-edit ' + child,
            child + ' can-view ' + child
        ]);
    }

    permissionHandler.set([
        'admin can-edit juror',
        'admin can-view juror',

        'juror can-view admin',
        'principal can-view admin',
        'teacher can-view admin',

        'principal can-view juror',
        'teacher can-view juror',
    ]);

}

function testing() {
    var w = wheel.getWedge('admin', 1);
    // w.addEvent('blue', 'this actually works!');
    w.drawDot();
    // w.showTitleBox();
}

function setYear(el) {
    window.location.href = "/sessions/changeyear/" + el.value;
}

$(document).ready( function() {
    if($("#wheel_container").length > 0) {
        // console.log('document.ready initiated');

        setDefaults();

        setPermissions();

        wheel = new Wheel({
            width: 640,
            height: 640,
            container: 'wheel_container'
        });

        wheel.createRings([
            { name: 'admin', realName: 'Utbildningsnämnden' },
            { name: 'juror', realName: 'Utbildningsförvaltningen' },
            { name: 'principal', realName: 'Skola' },
            { name: 'teacher', realName: 'Personal' }
        ]);

        wheel.createEvents(gon.school_events);

        // The wheel is drawn 100ms after this command.
        // KineticJS wont draw anything if there's no delay.
        wheel.draw();

        var rings = wheel.getRings();
        RightClickHandler.initiate(wheel);
        wheel.autoSize();

        initiateEventTypesOverWheel();


        testing();
    };
});