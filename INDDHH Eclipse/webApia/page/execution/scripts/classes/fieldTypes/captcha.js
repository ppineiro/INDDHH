/**
 * Campo Href
 */
var Captcha = new Class({
	
	Extends: Field,
	
	initialize: function(form, frmId, xml, rowXml) {
		//Establecer las opciones
		this.setDefaultOptions();		
		this.xml = xml;
		
		//No es de una grilla
		this.parent(form, frmId, xml.getAttribute("id"), JSON.decode(xml.getAttribute(Field.FIELD_PROPERTIES)), xml.getAttribute("attId"));
		this.parseXML();
		
	},
		
	setDefaultOptions: function() {
		this.options[Field.PROPERTY_CSS_CLASS]			= null;
	},
	
	/**
	 * Metodo de APIJS para establecer propiedades
	 */
	apijs_setProperty: function(prp_name, prp_value) {
		
		if(this.form.readOnly) return;
		
		if(prp_name == Field.PROPERTY_CSS_CLASS) {
			
			var p = this.content.getParent().erase('class');
			
			this.options[Field.PROPERTY_CSS_CLASS] = prp_value;
			if(this.options[Field.PROPERTY_CSS_CLASS])
				this.options[Field.PROPERTY_CSS_CLASS].split(' ').each(function(clase) {
					if(clase) p.addClass(clase);
				});
		} else {
			//throw new Error('Property not found or not available for this field.');
		}
	},
	
	/**
	 * Parsea el xml
	 */
	parseXML: function() {
		
		//Hace espacio en el formulario y ubica el campo en su lugar.
		this.parseXMLposition();
		
		//TODO: Field_PROPERTY_NAME
		
		if(this.options[Field.PROPERTY_CSS_CLASS])
			this.options[Field.PROPERTY_CSS_CLASS].split(' ').each(function(clase) {
				if(clase) this.content.getParent().addClass(clase);
			}.bind(this));
		
		if(!this.form.readOnly) {
			var link = new Element('a', {
				href: '#'
			});
			
			
			link.addClass('monitor-href');
			this.content.addClass('monitor_field');
			
			var uniqueId = this.makeUniqueId();
			var contenedor = new Element('div');
			var label = new Element('label',{'for':uniqueId});
			var spanLabel = new Element('span.asLabel');			
			spanLabel.appendText(this.xml.getAttribute("attLabel") + ':');
			spanLabel.inject(label);
			var params = getCaptchaParams(this.frmId);

			var captchaContainer = new Element('div.captcha-container');
			
			var img = new Element('img', {
				'data-fld_id': this.frmId + "_" + this.fldId,
				type: "text",
				style:"float:left;",
				alt:"Img",
				src: CONTEXT + '/captchaImg?' + params
			}).inject(captchaContainer);
			img.store('params',params);
			
			var optionContainer = new Element('div', {
				styles:{'width': '20px', 'float':'left'}
			}).inject(captchaContainer);
			
			var imgReload = new Element('img', {
				type:"text",
				src: CONTEXT + '/css/base/img/captcha_refresh.png',
				style: "height:20px;width:20px;cursor:pointer;",
				alt:"Reload",
				'class':'reloadCaptcha'
			}).inject(optionContainer);
			
			imgReload.addEvent('click', function(e) {
				if(frmData.captchas) {
					for(var i = 0; i < frmData.captchas.length; i++ ) {
						//Control para captcha en mismo formulario
						if (this.frmId == frmData.captchas[i].frmId){
							frmData.captchas[i].reloadContent();	
						}
					}
				}
			}.bind(this));
			
			this.audio = new Element('audio');
			this.audio.volume = 1;
			this.audio.setAttribute('disabled','true');
			
			var imgAudio = new Element('img', {
				type:"text",
				src: CONTEXT + '/css/base/img/captcha_audio.png',
			    styles: {'height':'20px','width':'20px','margin-top':'2px','opacity':'0.4','cursor':'pointer'},
				'class':'audioCaptcha',
				alt:"audio"
			}).inject(optionContainer);
			
			imgAudio.addEvent('click', function(e) {
				if (this.getAttribute('disabled')!='true'){
					this.play();	
				}				
			}.bind(this.audio));
				
			var input = new Element('input', {
				id:uniqueId,
				'data-fld_id': this.frmId + "_" + this.fldId,
				'data-attLabel': this.xml.getAttribute("attLabel") ,
				type: "text"
			}).addClass('validate["required"]');
			
			this.content.addClass('required');
			
			label.inject(contenedor);
			captchaContainer.inject(contenedor);
			input.inject(contenedor);
			contenedor.inject(this.content);
			
			this.loadCaptchaAudio();
			
			var frmData = $('frmData');
			
			if(!frmData.captchas)
				frmData.captchas = [];
			
			frmData.captchas.push(this);
			frmData.formChecker.register(input);
		}
	},
	
	getPrintHTML: function(formContainer) {
		
		var fieldContainer = this.parsePrintXMLposition(formContainer);
		
		var span = new Element('span', {text: this.xml.getAttribute(Field.PROPERTY_VALUE)});
		
		span.setStyles({
			'text-decoration': 'underline',
			color: '#0000ee',
			'-webkit-touch-callout': 'none',
			'-webkit-user-select': 'none',
			'-khtml-user-select': 'none',
			'-moz-user-select': 'none',
			'-ms-user-select': 'none',
			'user-select': 'none',
			cursor: 'default'
		});
		
		span.inject(fieldContainer);
		
	},
	
	processSubmit: function(frmData) {
		var previousField = $('captcha' + TAB_ID + this.frmId);
		if(previousField) {
			previousField.set('value', this.content.getElement('input').get('value'));
		} else {
			new Element('input', {
				name: TAB_ID + this.frmId,
				id: 'captcha' + TAB_ID + this.frmId,
				value: this.content.getElement('input').get('value')
			}).setStyle('display', 'none').inject(frmData);
		}
	},
	
	reloadContent: function () {
		var params = getCaptchaParams(this.frmId);
		var prevCaptcha = this.content.getElementsByTagName('img')[0];
		prevCaptcha.setAttribute('src', CONTEXT + '/captchaImg?' + params);
		prevCaptcha.store('params',params);
		this.content.getElementsByTagName('input')[0].value='';
				
		//Se resetea informacion de audio
		this.audio.setAttribute('disabled','true');
		this.audio.empty();
		this.content.getElement('img.audioCaptcha').setStyle('opacity',0.4);
	},
	
	showFormListener: function() {
		var cap = this.content.getElementsByTagName('input')[0];
		if(cap)
			cap.erase('disabledCheck');
	},
	
	hideFormListener: function() {
		var cap = this.content.getElementsByTagName('input')[0];
		if(cap)
			cap.set('disabledCheck', 'true');
	},
	
	loadCaptchaAudio: function(){
		var audio = this.audio;
		var prevCaptcha = this.content.getElementsByTagName('img')[0];
		var imgAudioCaptcha = this.content.getElement('img.audioCaptcha');
		
		//Se espera a cargar imagen del captcha para solicitar audio
		prevCaptcha.addEvent('load', function(){
			var params = this.retrieve('params');
			audio.setAttribute('src',CONTEXT + '/captchaAudio?' + params + '&langCode=' + LANG_CODE);

			audio.removeAttribute('disabled');
			imgAudioCaptcha.fade(1);
		})
	}
});

function getCaptchaParams(frmId){
	return 'captchaName=' + TAB_ID + frmId + '&t=' + new Date().getTime();
}