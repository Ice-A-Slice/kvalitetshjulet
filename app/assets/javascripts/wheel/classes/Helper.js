var Helper = {};


//Function for getting the radians on an angle
Helper.radians = function(degrees) {
    return (Math.PI / 180) * degrees;
}

// Returns an array with the amount of days in every month
// and the count of days of december last year in week 1 as
// the first value in the array.
Helper.getMonthDayCount = function(year){
    var dayCounts = [];
    var firstDateOfTheYear = new Date(year, 0, 0);
    var numberOfWeekDay = firstDateOfTheYear.getDay();
    dayCounts.push(numberOfWeekDay);

    // Pushes the day-count of all the months into the array
    for (var i = 1; i <= 12; i++) {
        dayCounts.push(new Date(year, i, 0).getDate());
    }

    return dayCounts;
}

Helper.objectSize = function(obj) {
    var size = 0, key;
    for (key in obj) {
        if (obj.hasOwnProperty(key)) size++;
    }
    return size;
}

String.prototype.capitalizeFirstLetter = function() {
    return this.charAt(0).toUpperCase() + this.slice(1);
}

String.prototype.toFnName = function() {
    var arr = this.split("-"),
        ret = arr[0];

    for (var i = 1; child = arr[i++];) {
        ret += child.capitalizeFirstLetter();
    }

    return ret;
}

Array.prototype.contains = function(obj) {
    return this.indexOf(obj) > -1;
}

Array.prototype.except = function(remove) {
    if (!(remove instanceof Array)) remove = [];

    var ret = this.filter(function(item) {
        return remove.indexOf(item) === -1;
    });

    return ret;
}