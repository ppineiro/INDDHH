var ajax;
var MSIE = window.navigator.appVersion.indexOf("MSIE")>=0;

function funcionCallBackcargarDetalleEELoaded(event, nameDivFlotante){
	
	// Escribimos el resultado en la pagina HTML mediante DHTML
	var result = ajax.responseText;
	
	var d = document.getElementById(nameDivFlotante);	
	d.innerHTML = result;	
	showdiv(event, nameDivFlotante);	
}

function cargarDetalleEEold(event, nameDivFlotante, nroEE, indice){
	
	alert("cargarDetalleEE");
	
	/*
	
	// Creamos el control XMLHttpRequest segun el navegador en el que estemos
	if( !MSIE ){
		ajax = new XMLHttpRequest(); // No Internet Explorer
		ajax.onload = function(){			
			funcionCallBackcargarDetalleEELoaded(event, nameDivFlotante);
		}
	}else{		
		ajax = new ActiveXObject("Microsoft.XMLHTTP"); // Internet Explorer
		// Almacenamos en el control al funcion que se invocara cuando la peticion
		// cambie de estado		
		ajax.onreadystatechange = funcionCallBackcargarDetalleEELoaded(event, nameDivFlotante);
	}
	// Enviamos la peticion	
	var URL = getUrlApp() + "/expedientes/buscador/generarCaratulaEE.jsp?nroEE=" + nroEE + "&indice=" + indice;
	alert(URL);
	ajax.open( "POST", URL, false );	
	ajax.send( "" );
	*/	
}

function hidediv(event, nameDivFlotante){
	document.getElementById(nameDivFlotante).style.display = 'none';
	
}

//Funcion que muestra el div en la posicion del mouse
function showdiv(event, nameDivFlotante){
	
	alert("showdiv");
	
	//determina un margen de pixels del div al raton
	var marginTop=-200;
	var marginLeft=50;
 
	//La variable IE determina si estamos utilizando IE
	var IE = document.all?true:false;
	//Si no utilizamos IE capturamos el evento del mouse
	if (!IE) document.captureEvents(Event.MOUSEMOVE)
 
	var tempX = 0;
	var tempY = 0;
 
	if(IE)
	{ //para IE
		tempX = event.clientX + document.body.scrollLeft;
		tempY = event.clientY + document.body.scrollTop;
	}else{ //para netscape
		tempX = event.pageX;
		tempY = event.pageY;
	}
	if (tempX < 0){tempX = 0;}
	if (tempY < 0){tempY = 0;}
 
	//modificamos el valor del id posicion para indicar la posicion del mouse
	//document.getElementById('posicion').innerHTML="PosX = "+tempX+" | PosY = "+tempY;
 
	document.getElementById(nameDivFlotante).style.top = (tempY+marginTop);
	document.getElementById(nameDivFlotante).style.left = (tempX+marginLeft);
	document.getElementById(nameDivFlotante).style.display='block';
	
	document.getElementById("search").value = (tempY+marginTop) + " - " +  (tempX+marginLeft();

	setTimeout(function(){ hidediv(event, 'DetalleEE'); }, 5000);
		
	return;
}

function ponerMayusculas(nombre, evnt){

	var ev = (evnt) ? evnt : event;
	var code=(ev.which) ? ev.which : event.keyCode;
	
	if(!((code>=48)&(code<=57))){
		nombre.value=nombre.value.toUpperCase();
	} 
} 