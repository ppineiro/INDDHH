var UI = {
  doEncrypt: function(evt) {
		this.encrypted.value = new AesUtil(keySize, iterationCount).encrypt(salt, iv, passPhrase, this.value);
	},

  encrypted: function(ele) {
		ele = $(ele);
		if (ele.encrypted != null) return;
		
		ele.encrypted = ele.clone();
		ele.encrypted.id = '';
		ele.encrypted.type = 'hidden';
		ele.encrypted.inject(ele.getParent());
		ele.encrypted.removeAttribute('required');
		ele.name = '';
		
		ele.addEvent('blur', UI.doEncrypt);
		ele.addEvent('keypress', function(evt) {
			if (evt.key == 'enter') this.fireEvent('blur');
		});
	}
}