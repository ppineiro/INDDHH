
function DEFAULT_INDDHH_JS_GOOGLEMAPS2(evtSource) { 
//PARAMETRIZAR
var direccion = "palacio legislativo, Montevideo";


// ==============================================================================================================

  document.getElementsByClassName("sapelo")[0].innerHTML = "<div id='mapa-geocoder' style='width: 200px; display: block; position: absolute; background: rgb(242, 119, 122) none repeat scroll 0% 0%; height: 200px;'></div>";


function loadScript(url, callback){

    var head = document.getElementsByTagName('head')[0];
    var script = document.createElement('script');
    script.type = 'text/javascript';
    script.src = url;
    script.onreadystatechange = callback;
    script.onload = callback;
    head.appendChild(script);
}

function localizar(elemento,direccion) {
	var geocoder = new google.maps.Geocoder();

	var map = new google.maps.Map(document.getElementById(elemento), {
	  zoom: 16,
	  scrollwheel: true,
	  mapTypeId: google.maps.MapTypeId.ROADMAP
	});
	
	geocoder.geocode({'address': direccion}, function(results, status) {
		if (status === 'OK') {
			var resultados = results[0].geometry.location,
				resultados_lat = resultados.lat(),
				resultados_long = resultados.lng();
			
			map.setCenter(results[0].geometry.location);
			var marker = new google.maps.Marker({
				map: map,
				position: results[0].geometry.location
			});
		} else {
			var mensajeError = "";
			if (status === "ZERO_RESULTS") {
				mensajeError = "No hubo resultados para la dirección ingresada.";
			} else if (status === "OVER_QUERY_LIMIT" || status === "REQUEST_DENIED" || status === "UNKNOWN_ERROR") {
				mensajeError = "Error general del mapa.";
			} else if (status === "INVALID_REQUEST") {
				mensajeError = "Error de la web. Contacte con Name Agency.";
			}
			alert(mensajeError);
		}
	});
}



loadScript("https://maps.googleapis.com/maps/api/js?key=AIzaSyBnAQEimy4AN9scdx70N_oQc7YD0q4dYVw", function(){
	if (direccion !== "") {
		localizar("mapa-geocoder", direccion);
	}
});




return true; // END
} // END
