/**
 * Clase para generar un progress bar
 */
var ProgressBar = new Class({
	
	//implements
	Implements: [Events, Options],

	alive: true,
	
	status_url: '',
	
	//options
	options: {
		container: '',
		boxID:'progress-bar-box-id',
		percentageID:'progress-bar-percentage-id',
		displayID:'progress-bar-display-id',
		startPercentage: 0,
		displayText: false,
		speed:10,
		step:1,
		allowMore: false,
		frecuency: 500,
		autostart: true
	},
	
	//initialization
	initialize: function(url, options) {
		//set options
		this.setOptions(options);
		//quick container
		if(this.options.container)
			this.options.container = $(this.options.container);
		else
			this.options.container = $(document.body);
		
		//create elements
		this.createElements();
		
		this.status_url = url;
		
		if(this.options.autostart)
			this.checkProgress();
	},
	
	start: function() {
		this.alive = true;
		this.checkProgress();
	},
	
	stop: function() {
		this.alive = false;
		$(this.options.boxID).setStyle('display', 'none');
	},
	
	checkProgress: function() {
		if(!this.alive)
			return;
		else $(this.options.boxID).setStyle('display', '');
		
		new Request({
			url: this.status_url + '?action=getStatusProgress' + TAB_ID_REQUEST,
			onSuccess: function(responseText, responseXML) {
		    	//AJAX exitoso
		    	if(responseXML && responseXML.childNodes && responseXML.childNodes.length) {
		    		var response = responseXML.childNodes.length == 1 ? responseXML.childNodes[0] : responseXML.childNodes[1];
		    		
		    		if(response.tagName == 'result' && response.getAttribute('progress')) {
		    			var progress = Number.from(response.getAttribute('progress'));
		    			this.set(progress);
		    			
		    			if(progress == 100) {
		    				$(this.options.boxID).setStyle('display', 'none');
		    				this.alive = false;
		    				return;
		    			}
		    		}
		    	}
		    	
		    	setTimeout(this.checkProgress.bind(this), this.options.frecuency);
			}.bind(this)
		 }).send();

	},
	
	//creates the box and percentage elements
	createElements: function() {
		var box = new Element('div.progress-bar-box', { 
			id:this.options.boxID 
		});
		var perc = new Element('div.progress-bar-perc', { 
			id:this.options.percentageID, 
			'style':'width:0px;' 
		});
		perc.inject(box);
		box.inject(this.options.container);
		if(this.options.displayText) { 
			var text = new Element('div', { 
				id:this.options.displayID 
			});
			text.inject(this.options.container);
		}
		this.set(this.options.startPercentage);
	},
	
	//calculates width in pixels from percentage
	calculate: function(percentage) {
		return ($(this.options.boxID).getStyle('width').replace('px','') * (percentage / 100)).toInt();
	},
	
	//animates the change in percentage
	animate: function(go) {
		var run = false;
		var self = this;
		if(!self.options.allowMore && go > 100) { 
			go = 100; 
		}
		self.to = go.toInt();
		$(self.options.percentageID).set('morph', { 
			duration: this.options.speed,
			link:'cancel',
			onComplete: function() {
				self.fireEvent('change',[self.to]);
				if(go >= 100)
				{
					self.fireEvent('complete',[self.to]);
				}
			}
		}).morph({
			width:self.calculate(go)
		});
		if(self.options.displayText) { 
			$(self.options.displayID).set('text', self.to + '%'); 
		}
	},
	
	//sets the percentage from its current state to desired percentage
	set: function(to) {
		this.animate(to);
	},
	
	//steps a pre-determined percentage
	step: function() {
		this.set(this.to + this.options.step);
	}
	
});