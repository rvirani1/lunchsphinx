$( document ).ready( function() {
    console.log("in the javascript file");
//    Clicking the submit button
    $('#submit').click(function() {
        //    Get location and show error message to user
        distance = parseInt($("#distance").val());
        console.log("Distance is " + distance);
        navigator.geolocation.getCurrentPosition(GetLocation);
        function GetLocation(loc_data) {
            console.log("getting position");
            latitude = loc_data.coords.latitude;
            longitude = loc_data.coords.longitude;
            console.log("latitude is " + latitude);
            console.log("longitude is " + longitude);
            console.log("accuracy is " + loc_data.coords.accuracy);
            window.location = 'http://' + location.host + '/randomrestaurant?latitude=' + latitude + '&longitude=' + longitude + '&distance=' + distance;
        }
    }); // closing the click function



} );