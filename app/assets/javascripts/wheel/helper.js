
//Function for getting the radians on an angle
function radians(degrees) {
    return (Math.PI / 180) * degrees;
}

// Returns an array with the amount of days in every month
// and the count of days of december last year in week 1 as
// the first value in the array
function getMonthDayCount(year){
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