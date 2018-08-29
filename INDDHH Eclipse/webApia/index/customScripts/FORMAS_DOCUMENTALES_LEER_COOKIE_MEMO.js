
function fnc_1001_1768(evtSource) { 
	nombre = 'ID';
   	a = document.cookie.substring(document.cookie.indexOf(nombre + '=') + nombre.length + 1,document.cookie.length);
   	if(a.indexOf(';') != -1)a = a.substring(0,a.indexOf(';'))
   		document.write(a);

//function leerCookie(nombre) {
  // a = document.cookie.substring(document.cookie.indexOf(nombre + '=') + nombre.length + 1,document.cookie.length);
   //if(a.indexOf(';') != -1)a = a.substring(0,a.indexOf(';'))
   //return a; 
//} 

return true; // END
} // END
