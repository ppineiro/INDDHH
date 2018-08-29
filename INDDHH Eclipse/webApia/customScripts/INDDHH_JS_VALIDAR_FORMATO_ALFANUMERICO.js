
function INDDHH_JS_VALIDAR_FORMATO_ALFANUMERICO(evtSource, par_form, par_attrib, par_paramCantLetras, par_paramCantNumeros, par_letrasPrimero) { 
var strValue = ApiaFunctions.getForm(par_form).getField(par_attrib).getValue();
var letras = "abcdefghijklmn?opqrstuvwxyz";
var numeros = "0123456789";
var cantLetras = par_paramCantLetras;
var cantNumeros = par_paramCantNumeros;
var orden = par_letrasPrimero;

var topeUno = 0;
var topeDos = 0;
var baseUno = 0;
var baseDos = 0;

if (orden) {
	topeUno = cantLetras;
	topeDos = cantNumeros;
	baseUno = 0;
	baseDos = cantLetras + 1;
}
else {
	topeUno = cantLetras + cantNumeros;
	topeDos = cantLetras;
	baseUno = cantNumeros + 1;
	baseDos = 0;
}

if (!(sonLetras(strValue) && sonNumeros(strValue)) || (strValue.length != cantLetras + cantNumeros)) {
	ApiaFunctions.getForm(par_form).getField(par_attrib).clearValue();
    var mensaje = "El formato debe ser ";
  if (cantNumeros>0) {
    mensaje = mensaje+cantNumeros + "n�meros ";
  }
  if (cantLetras>0) {
    mensaje = mensaje+cantLetras + " letras ";
  }
    alert(mensaje);
}

function sonLetras (strValue) {
	strValue = strValue.toLowerCase();
	
	for (var i = baseUno; i < topeUno; i++) {
		//Si encuentra algo distinto de una letra, retorna false y sale de la funci�n
		if (letras.indexOf(strValue.charAt(i),0) == -1) {
			return false;
		}
	}
	return true;
}

function sonNumeros (strValue) {
	for (var i = baseDos; i < topeUno + topeDos; i++) {
		//Si encuentra algo distinto de un n�mero, retorna false y sale de la funci�n
		if (numeros.indexOf(strValue.charAt(i),0) == -1) {
			return false;
		}
	}
	return true;
}


return true; // END
} // END
