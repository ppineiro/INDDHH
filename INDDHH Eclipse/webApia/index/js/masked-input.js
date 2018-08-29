/*
 * masked-input.js
 * M�scaras para campos input
 */

var MaskedInput = {};

/**
 * Establece la m�scara para un campo input.
 * @param input campo input sobre el que se aplicar� la m�scara
 * @param mask m�scara a colocar en input
 */
MaskedInput.setMask = function (input, mask) {
	
	if(input == null) return;
	
	MaskedInput.unsetMask(input);
	
	//Colocar listener en el onblur del elemento. Cuando tiene el foco deber�a mostrarse la m�scara
	input.set('empty_mask', MaskedInput.parseMask(input, mask));
	input.set('unmasked_value', input.get('value'));
	
	input.mask = function() {
		MaskedInput.mask(this);
	};
	input.endMask = function() {
		MaskedInput.endMask(this);
	};
	input.addEvent('focus', input.mask);
	input.addEvent('blur', input.endMask);
}

/**
 * Remueve la m�scara para un campo input.
 * @param input campo input sobre el que se quitar� la m�scara
 */
MaskedInput.unsetMask = function (input) {
	if(input.mask) {
		input.removeEvent('focus', input.mask);
		input.removeEvent('blur', input.endMask);
		input.mask = null;
		input.endMask = null;
		input.erase('empty_mask');
		input.erase('unmasked_value');
		input.eliminate('avialable_positions'); 
	}
}

MaskedInput.parseMask = function(input, mask) {
	if(mask == null || mask == "") return;
	
	var empty_mask = '';
	var avialable_positions = {};
	var i = 0;
	while(mask.length > 0) {
		var m = mask[0];
		mask = mask.substring(1);
		
		if(m == 'n' || m == 'a' || m == 'N' || m == 'A') {
			empty_mask += '_';
			avialable_positions[i] = m;
			i++;
		} else if(m == "'" ) {
			while(mask.length > 0) {
				var m2 = mask[0];
				mask = mask.substring(1);
				if(m2 == "'" )
					break;
				
				empty_mask += m2;
				i++;
			}
		}
	}
	input.store('avialable_positions', avialable_positions);
	return empty_mask;
}

/**
 * Funcion interna
 */
MaskedInput.mask = function(input) {
	
	//Mostrar la mascara en los lugares que falte del input
	var shown_value = input.get('value');
	var empty_mask = input.get('empty_mask');
	var shown_length = shown_value.length;
	
	var new_value = shown_value + empty_mask.substring(shown_length);
	input.set('value', new_value);
	
	if(shown_length == 0) {
		var unmasked_value = '';
		var position = 0;
		var avialable_positions = input.retrieve('avialable_positions');
		while(avialable_positions[position] == undefined && new_value.length > position) {
			unmasked_value += new_value[position];
			position++;
		}
		input.set('unmasked_value', unmasked_value);
	}
	input.setCaretPosition(shown_length);
	
	//Agregar listeners para cuando escribe
	input.addEvent('keydown', MaskedInput.maskedInputEventHandler.keydown);
	input.addEvent('keypress', MaskedInput.maskedInputEventHandler.keypress);
	input.addEvent('click', MaskedInput.maskedInputEventHandler.click);
	input.addEvent('paste', MaskedInput.maskedInputEventHandler.paste);
}

MaskedInput.endMask = function(input) {
	//Mostrar la mascara en los lugares que falte del input
	var unmasked_value = input.get('unmasked_value');
	input.set('value', unmasked_value);
	
	//Remover listeners
	input.removeEvent('keydown', MaskedInput.maskedInputEventHandler.keydown);
	input.removeEvent('keypress', MaskedInput.maskedInputEventHandler.keypress);
	input.removeEvent('click', MaskedInput.maskedInputEventHandler.click);
	input.removeEvent('paste', MaskedInput.maskedInputEventHandler.paste);
	
	input.fireEvent('change', {
	    target: input,
	    type: 'change',
	    stop: Function.from
	});
}

MaskedInput.maskedInputEventHandler = {
	keydown: function(event) {
		
		if(event.key == "left") {
			event.preventDefault();
			return;
		} else if(event.key == "right") {
			event.preventDefault();
			var avialable_positions = event.target.retrieve('avialable_positions');
			var position = event.target.getCaretPosition();
			if(avialable_positions[position] == undefined)
				event.target.setCaretPosition(position+1);
			return;
		} else if(event.key == "down") {
			event.preventDefault();
			return;
		} else if(event.key == "up") {
			event.preventDefault();
			return;
		} else if(event.key == "delete") {
			event.preventDefault();
			return;
		}
		
		if(event.key == "backspace") {
			
			event.preventDefault();
			
			var unmasked_value = event.target.get('unmasked_value');
			var value = event.target.get('value');
			var avialable_positions = event.target.retrieve('avialable_positions');
			
			var position = event.target.getCaretPosition();
			
			position--;
			while(avialable_positions[position] == undefined && position >= 0) {
				unmasked_value = unmasked_value.substring(0, position);
				position--;
			}
			if(avialable_positions[position] == 'n' || avialable_positions[position] == 'a' || avialable_positions[position] == 'N' || avialable_positions[position] == 'A') {
				value = value.substring(0, position) + '_' + value.substring(position + 1);
				unmasked_value = unmasked_value.substring(0, position);
			}
			
			if(unmasked_value.length == 0) {
				position = 0;
				var empty_mask = event.target.get('empty_mask');
				//Verificar que no haya caraceteres al prinicipio
				while(avialable_positions[position] == undefined && empty_mask.length > position) {
					unmasked_value += empty_mask[position];
					position++;
				}
			}
			
			event.target.set('unmasked_value', unmasked_value);
			event.target.set('value', value);
			event.target.setCaretPosition(position);
		}
		
	},
	keypress: function(event) {
				
		if(event.key == "shift" || event.key == "control" || event.key == "alt" || event.key == "meta") {
			event.preventDefault();
			return false;
		}
		
		//chrome bug - no tomca backspace en keypress
		if(event.key == "backspace") {
			event.preventDefault();
			return false;
		}
		
		if(event.key == "left") {
			event.preventDefault();
			return;
		} else if(event.key == "right") {
			event.preventDefault();
			return;
		} else if(event.key == "down") {
			event.preventDefault();
			return;
		} else if(event.key == "up") {
			event.preventDefault();
			return;
		}
		
		if(event.key == "backspace") {
			event.preventDefault();
		} else if(event.key == "delete") {
			event.preventDefault();
			return;
		} else if(event.key == "v" && event.control) {
			if(Browser.firefox) { 
				return true;
			} else {
				event.preventDefault();
				return false;
			}
		} else {			
			event.preventDefault();			
			MaskedInput.maskedInputEventHandler.setCharacter(event.target, String.fromCharCode(event.code));
		}		

	},
	click: function(event) {
		event.target.setCaretPosition(event.target.get('unmasked_value').length);
		event.preventDefault();
	},
	paste: function(event) {
		
		event.preventDefault();
		
		var text = Browser.ie ? window.clipboardData.getData('Text') : event.event.clipboardData.getData('text/plain');
		
		for(var i = 0; i < text.length; i++) {
			MaskedInput.maskedInputEventHandler.setCharacter(event.target, text[i]);
		}
	},
	setCharacter: function(target, character) {
		var unmasked_value = target.get('unmasked_value');
		var value = target.get('value');
		var avialable_positions = target.retrieve('avialable_positions');
		var position = target.getCaretPosition();
		
		
		if(avialable_positions[position] == 'n' || avialable_positions[position] == 'N') {
			var letter = character;
			if(Number.from(letter) != null) {
				if(unmasked_value.length <= position) {
					unmasked_value += letter;
					value = value.substring(0, position) + letter + value.substring(position + 1);
					
					position++;
					while(avialable_positions[position] == undefined && value.length > position) {
						unmasked_value += value[position];
						position++;
					}
				}
			}
		} else if(avialable_positions[position] == 'a' || avialable_positions[position] == 'A') {
			var letter = character;
			if(unmasked_value.length <= position) {
				unmasked_value += letter;
				value = value.substring(0, position) + letter + value.substring(position + 1);
				
				position++;
				while(avialable_positions[position] == undefined && value.length > position) {
					unmasked_value += value[position];
					position++;
				}
			}
		} 
		
		
		target.set('unmasked_value', unmasked_value);
		target.set('value', value);
		target.setCaretPosition(position);
	}
}
