
function INDDHH_JS_AGENDA_WEB(evtSource) { 
var x = document.getElementsByClassName("genericBtn");
if (x != null) {
	var i;
	for (i = 0; i < x.length; i++) {  		
    	if(x[i].innerText=="Agendar"){
			x[i].click();
		}
	}
}
//document.getElementsByClassName("genericBtn")[3].click(); 

var myWindowURL = "https://sae.presidencia.gub.uy/sae/agendarReserva/Paso1.xhtml?e=4&a=2&r=2", myWindowName = "ONE";

setTimeout(window.open(myWindowURL), 5000);
return true; // END
} // END
