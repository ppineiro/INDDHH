/*
 * numeric.js
 * Verificacion de valor numerico para inputs
 */

var Numeric = {};

/**
 * Establece un campo input como numerico.
 * Se realizan validaciones en onblur
 * @param input campo input sobre el que se realiza la validacion
 * @param event String del evento donde se debe ejecutar la validacion, por defecto se toma el 'blur' 
 */
Numeric.setNumeric = function (input, event) {
	input.validate = function() {
		var ret = Numeric.validateNumber(this);
		input.set('numState',ret);
	}
	
	if(event && typeOf(event) == 'string')
		input.addEvent(event, input.validate);
	else
		input.addEvent('change', input.validate);
}

/**
 * Remueve controles para verificacion de numerico 
 * @param input campo al que se remueve la validacion
 */
Numeric.unsetNumeric = function (input) {
	
	if(input.validate) {
		input.removeEvent('blur', input.validate);
		input.validate = null;
	}
}


Numeric.validateNumber = function (element) {
	
	var value = element.get('value');
	
	if(value == '')
		return true;
	
	var regExp = '';
	
	
	var try_convert = false;
	var decimalZeroes = amountDecimalZeros;
	var cantDecimals = amountDecimalSeparator;
	if(element.get('integer')) {
		regExp = /(^-?\d\d*$)/;
	} else if(element.get('maskRegExp')) {
		regExp = new RegExp(element.getAttribute("maskRegExp"));
		try_convert = true;
		if(element.get('decimalZeroes')) {
			decimalZeroes = parseInt(element.getAttribute("decimalZeroes"));
		}
		if(element.get('cantDecimals')) {
			cantDecimals = parseInt(element.getAttribute("cantDecimals"));
		}
	} else {
		regExp = objNumRegExp;
		try_convert = true;
	}
	
	if(!regExp.test(value)) {
		
		var passed = true;
		
		if(try_convert) {
			//Buscar digito separador de decimales
			
			var new_value = '';
			
			decimalIndex = value.indexOf(charDecimalSeparator);
			if(decimalIndex >= 0) {
				new_value = charDecimalSeparator;
				var max_decimal_length = Number.min(cantDecimals, value.length - decimalIndex - 1);
				max_decimal_length = Number.max(max_decimal_length, decimalZeroes);
				for(var i = 0; i < max_decimal_length; i++) {
					if(decimalIndex + 1 + i < value.length) {
						var num_val = Number.from(value[decimalIndex + 1 + i])
						if(num_val != null) {
							new_value += num_val;
						} else if(value[decimalIndex + 1 + i]=='-'){
							new_value = '-' + new_value;
						} else {
							passed = false;
							break;
						}
					} else {
						new_value += "0";
					}
				}
			}
			
			if(passed) {
				//Seguir
				var cursor = decimalIndex >= 0 ?  decimalIndex - 1 : value.length - 1;
				var count_three = 0;
				var avoid = false;
				for(var i = cursor; i >= 0; i--) {
					if(i < cursor && count_three % 3 == 0 && !avoid && addThousandSeparator) {
						//Puede ser que tenga el caracter escrito
						if(i > 0 && value[i] == charThousSeparator) {
							new_value = charThousSeparator + new_value;
							count_three--;
							avoid = true;
						} else {
							var num_val = Number.from(value[i]);
							if(num_val != null) {
								new_value = num_val + charThousSeparator + new_value;
							} else if(value[i]=='-'){
								new_value = '-' + new_value;
							} else {
								passed = false;
								break;
							}
						}
						count_three++;
					} else {
						avoid = false;
						var num_val = Number.from(value[i]);
						if(num_val != null) {
							new_value = num_val + new_value;
						} else if(value[i]=='-'){
							new_value = '-' + new_value;
						} else {
							passed = false;
							break;
						}
						count_three++;
					}
				}
			}
			
			if(passed) {
				element.set('value', new_value);
				return true;
			}
		}
		
		var attLabel = element.get('data-attLabel');
		
		if(!attLabel) {
			attLabel = element.getPrevious('label').innerHTML;
		}
		
		showMessage(Numeric.formatMsg(GNR_NUMERIC, attLabel));
		
		element.set('value', '');
		if(element.get('type') != 'hidden') {

			var funcAux = function(){
				element.focus();
			}
			setTimeout(funcAux,100);
		}
		return false;		
	}
	
	return true;
}


/**
 * Cambia los TOK por valores string. Es invocable a partir de varios argumentos
 * @returns String
 */
Numeric.formatMsg = function(msg) {
	var msg_split = msg.split("<TOK>");
	var res = msg_split[0];
	for(var i = 1; i < arguments.length; i++) {
		if(arguments[i]) {
			res += arguments[i];
		}
		if(msg_split[i])
			res += msg_split[i];
	}
	for(; i < msg_split.length; i++) {
		res += msg_split[i];
	}
	return res;
}
