
function DEFAULT_JS_SHOW_HELP(evtSource, par_nameFrm, par_nameAtt) { 
	
var myForm = ApiaFunctions.getEntityForm(par_nameFrm);
var field = myForm.getField("IMAGEN");
//field.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, false);
var x = event.clientX -200;     // Get the horizontal coordinate
var y = event.clientY -200;  
//var rect = field;//boton.getBoundingClientRect();

//var xmlHttp = getXmlHttp();
//xmlHttp.onreadystatechange = function() {
//if (xmlHttp.readyState==4 && xmlHttp.status==200){
//var htmlCode = xmlHttp.responseText;
var div_tits = document.getElementById("ayuda_div");
x= 200;
y=400;
div_tits.style.top = x + "px";//rect.bottom + document.body.scrollTop + 5;
div_tits.style.left = y + "px";//rect.left + document.body.scrollLeft;
div_tits.style.display = "block";
div_tits.innerHTML = "<p>Prueba</p>";//htmlCode.trim();


//URL = "http://apia.statum.biz/Apia/page/login/classic/login.jsp";

//xmlHttp.open("POST" , URL , false);
//xmlHttp.send(null);












return true; // END
} // END
