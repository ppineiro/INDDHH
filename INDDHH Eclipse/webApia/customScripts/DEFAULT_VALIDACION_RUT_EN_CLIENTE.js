
function DEFAULT_VALIDACION_RUT_EN_CLIENTE(evtSource, par_nomFrm, par_nomAtt) { 

var form = ApiaFunctions.getForm(par_nomFrm);
var field = form.getField(par_nomAtt);


var rut = field.getValue().split("");
var ultimoNro = rut[rut.length-1];

var factor;
		var suma = 0;
		var modulo = 0;
		var digitoVerificador = -1;
	
		if (rut.length != 12 ) {
			digitoVerificador = -2;
		} else  {
	
          
          	factor=2;
				var total = rut.length-1;
				for ( i = total; i >= 1 ; i--) {
					suma = suma + (parseInt(rut[i-1])*factor);
				
                  if(factor==9){
                    factor = 2;
                  }                  
                  
                  else{
                  
                    factor =factor+1; 
                  }
                  }
				//calculo el modulo 11 de la suma
				modulo = suma % 11;
				digitoVerificador = 11 - modulo;
				if(digitoVerificador==11){
					digitoVerificador = 0;
				}
				if(digitoVerificador==10){
					digitoVerificador = 1;
				}
			
		}
	
if (digitoVerificador == -2 ) {
				alert("El rut debe contener 12 digitos");
}

else if(digitoVerificador == -3 ){
				alert("El RUT solo puedo contener dígitos numéricos.");
				
			}

else if (digitoVerificador != parseInt(ultimoNro)) {
					alert("El RUT ingresado no es válido.");
					
				}







return true; // END
} // END
