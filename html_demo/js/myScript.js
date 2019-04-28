function startTime() {
    var today = new Date();
    var hh = today.getHours();
    var mm = today.getMinutes();
    var ss = today.getSeconds();
    mm = checkTime(mm);
    ss = checkTime(ss);

    document.getElementById("txt").innerHTML = hh + ":" + mm + ":" + ss;
    t = setTimeout(function () {
        startTime()
    }, 500);

}

function checkTime(ii) {
    if (ii < 10) {
        ii = "0" + ii;
    }
    return ii;
}
