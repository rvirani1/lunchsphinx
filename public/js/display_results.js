var placeid = $( "#data" ).data( "placeid" );

$( document ).ready( function() {
    // Initiate the request!
    $( "td" ).hover(
        function() {
            $( this ).addClass( "hover" );
        }, function() {
            $( this ).removeClass( "hover" );
        }
    );

    $('#f1_container').hover(
        function() {
            var req = $.ajax({
                url: '/' + placeid + '/details.json',
                type: 'GET',
                dataType: 'json',
                success: function( resp ) {
                    console.log( resp );
                    $( '#details-name' ).html( resp["name"] );
                    $( '#details-address' ).html( resp["formatted_address"] );
                    $( '#details-phone' ).html( resp["formatted_phone_number"] );
                    $( '#details-rating' ).html( resp["rating"] );
                    $( '#details-website' ).html( resp["website"] );
                    $( '#details-types' ).html( resp["types"] );
                },
                error: function( req, status, err ) {
                    console.log( 'something went wrong', status, err );
                }
            } );
    }, function () {
        console.log("hover out")
        }
    );
} );

