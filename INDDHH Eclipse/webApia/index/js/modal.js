/** Constants types **/
var LOAD_TEXT		= "text";
var LOAD_FORM		= "form";
var LOAD_TABLE		= "table";
var LOAD_FUNCTION	= "function";

var currentZIndex = 1000;

AjaxPanel = new Class({
	Implements: Options,
	
	options: {
	},

	//--- Constructors --------------------------
	initialize: function(options) {
		//Set options
		this.setOptions(options);
		this.panel			= new Array();
		this.wait			= new Array();
		this.showingLoading = false;
	},
	
	hasActive: function () {//Returns true if the there is an active panel
		return this.panel.length > 0;
	},
	
	getActive: function(avoidResetLoading) { //Retrieves the active panel, if no one is active, creates one
		if (this.panel.length == 0) return this.newPanel(avoidResetLoading);
		if (! avoidResetLoading) this.showingLoading = false;
		return this.panel[this.panel.length - 1];
	},
	
	closeActive: function() {//Close de active panel, closeing the shadow shape
		if (this.panel.length != 0) {
			var elePanel = this.panel.pop();
			var eleWait = this.wait.pop();
		
			if (elePanel.onclose) elePanel.onclose();

			elePanel.dispose();
			eleWait.dispose();
			
			this.showingLoading = false;
			
			if(this.panel.length == 0) {
				//Era el ultimo panel
				if(window.frameElement && $(window.frameElement).hasClass('modal-content')) {
					var mdlDocumentContainer = $('mdlDocumentContainer')
					if(!mdlDocumentContainer || mdlDocumentContainer && mdlDocumentContainer.hasClass('hiddenModal')) {
						$(window.frameElement).fireEvent('unblock');
					}
				}
			}
			
			//cancelAjaxHidde();
			currentZIndex-=1;
		}
	},
	
	closeLoading: function() {//Close the loading panel, only if it is showing
		if (this.showingLoading != null && this.showingLoading) this.closeActive();
	},
	
	hiddeActive: function() {//Hiddes the active panel, leaving the shadow shape
		var elePanel = this.getActive();

		if (elePanel.onhidde) elePanel.onhidde();
		elePanel.addClass("hidden");
		
		if (this.panel.length == 0) changeFlashVisibility(true);
	},
	
	closeAll: function() {//Close all panels, closeing all the shadow shapres
		while (this.panel.length != 0) {
			var elePanel = this.panel.pop();
			var eleWait = this.wait.pop();
		
			if (elePanel.onclose) elePanel.onclose();
			
			elePanel.dispose();
			eleWait.dispose();
		}

		this.showingLoading = false;
		
		//cancelAjaxHidde();
		currentZIndex = 1000;
	},
	
	getNewZIndex: function() {//Close all panels, closeing all the shadow shapres
		currentZIndex += 1;
		return currentZIndex;
	},
	
	newError: function() {//Generates a new error panel
		this.wait.push(this.createDiv("modalBlocker",true));
		this.panel.push(this.createDiv("modalContent",false));
		
		return this.getActive();
	},
	
	newPanel: function(avoidResetLoading) {//Generates a new comun panel
		this.wait.push(this.createDiv("modalBlocker",true));
		this.panel.push(this.createDiv("modalContent",false));
		
		return this.getActive(avoidResetLoading);
	},
	
	refresh: function(autoExpand) {//Refresh all panels locations
		this.adjustVisual(autoExpand);
		
		for (var i = 0; i < this.panel.length; i++) {
			var elePanel = this.panel[i];
			elePanel.position();
		
			if (elePanel.onrefresh) elePanel.onrefresh();
		}
		
		return true;
	},
	
	createDiv: function(aClassName, isWait) {//Creates an internal div panel (private)
		var newDiv = new Element("div", {'class': aClassName, 'tabIndex': 0});
		newDiv.setStyle('zIndex', this.getNewZIndex());

		if (isWait) {
			newDiv.setStyle('width', '100%');
			newDiv.setStyle('height', '100%');
			newDiv.setStyle('position', 'fixed');
			newDiv.setStyle('top', '0px');
			newDiv.setStyle('left', '0px');
		} else {
			var newDiv = new Element("div", {'class': aClassName});
			newDiv.setStyle('zIndex', SYS_PANELS.getNewZIndex());
			newDiv.header = new Element("div", {'class': 'header'});
			newDiv.content = new Element("div", {'class': 'content'});
			newDiv.footer = new Element("div", {'class': 'footer'});

			newDiv.header.inject(newDiv);
			newDiv.content.inject(newDiv);
			newDiv.footer.inject(newDiv);
		}
		newDiv.inject(document.body);
		if (! isWait) newDiv.position();
		
		//Perder foco
		newDiv.focus();
		
		return newDiv;
	},
	
	showLoading: function() {//Shows the loading panel in the active panel
		if (this.showingLoading == null || ! this.showingLoading) {
			this.showingLoading = true;
			var section = this.newPanel(true);
			section.content.innerHTML = MSG_LOADING;//"loading...";
			section.position();
			section.focus();
			
			if (section.content.isVisible()) {
				return this.refresh();
			}
			
			return null;
		}
	},
	
	adjustVisual: function(autoExpand) {//Adjusts all panels to fit visual properties
		var element = (this.panel.length == 0) ? null : this.getActive(true);
		
		if (element == null) return;
		
		var ajaxResultContent = element.getElement("ajaxResultContent");
		
		autoExpand = toBoolean(autoExpand);
		//autoExpand = true;
	
		if (element != null && ajaxResultContent != null && autoExpand ) {
			var maxWidth = Math.round(getStageWidth() * .85);
			var maxHight = Math.round(getStageHeight() * .70);

			if (ajaxResultContent.scrollHeight > maxHight) {
				ajaxResultContent.style.height = maxHight + "px";
			} else if (ajaxResultContent.scrollHeight > element.offsetHeight) {
				ajaxResultContent.style.height = ajaxResultContent.offsetHeight + "px";
			}

			if (ajaxResultContent.scrollWidth > maxWidth) {
				element.style.width = maxWidth + "px";
			} else if (ajaxResultContent.scrollWidth > element.offsetWidth) {
				element.style.width = ajaxResultContent.scrollWidth + "px";
			}
		}
		
		element.position();
	},
	
	addClose: function(ele, closeAll, onClose) {
		if (!ele) ele = this.getActive();
		
		var sector = new Element("div", {'class': 'close', html: BTN_CLOSE}); //BTN_CANCEL
		sector.inject(ele.footer);
		ele.closeButton = sector;
		if (toBoolean(closeAll)) {
			sector.addEvent('click', function(evt){ 
				if (onClose != "" && onClose != null) {
					if(typeOf(onClose) == 'string') {
						var fn = window[onClose];
						jsCaller(fn, null);
					} else if(typeOf(onClose) == 'function') {
						onClose();
					}
				}
				if(SYS_PANELS)
					SYS_PANELS.closeAll(); 
			});
		} else {
			sector.addEvent('click', function(evt){
				if (onClose != "" && onClose != null) {
					if(typeOf(onClose) == 'string') {
						var fn = window[onClose];
						jsCaller(fn, null);
					} else if(typeOf(onClose) == 'function') {
						onClose();
					}
				}
				if(SYS_PANELS)
					SYS_PANELS.closeActive(); 
			});
		}
	},
	
	addConfirm: function(ele, onConfirm) {
		if (!ele) ele = this.getActive();
		
		var sector = new Element("div", {'class': 'button', html: BTN_CONFIRM});
		sector.inject(ele.footer);
		
		sector.addEvent('click', function(evt){
			if (onConfirm != "" && onConfirm != null) {
				if(typeOf(onConfirm) == 'string') {
					var fn = window[onConfirm];
					jsCaller(fn, null);
				} else if(typeOf(onConfirm) == 'function') {
					onConfirm();
				}
			}
			SYS_PANELS.closeActive(); 
		});
	}
});


var SYS_PANELS = new AjaxPanel();
 
function modalProcessXml(xml,element,showOops) {
	var result = false;
	
	if (element == null && SYS_PANELS.hasActive()) element = SYS_PANELS.getActive();
	
	if (xml != null) {
		var useActivePanel = true;
		
		if (xml.getElementsByTagName("load").length != 0) {
			var toLoad		= xml.getElementsByTagName("load").item(0);
			var toLoadType	= toLoad.getAttribute("type");
			var canClose	= toBoolean(toLoad.getAttribute("canClose"));
			
			if (LOAD_TEXT == toLoadType) {
				SYS_PANELS.showingLoading = false;
				useActivePanel = false;
				processModalXmlText(xml,element,canClose);
				result = true;
			
			} else if (LOAD_FORM == toLoadType) {
				SYS_PANELS.showingLoading = false;
				useActivePanel = false;
				processModalXmlForm(xml,element,canClose);
				result = true;
			
			} else if (LOAD_FUNCTION == toLoadType) {
				SYS_PANELS.showingLoading = false;
				useActivePanel = false;
				processModalXmlFunction(xml,element,canClose);
				result = true;
			}
		}
		
		if (xml.getElementsByTagName("actions").length != 0) {
			result = processXmlActions(xml.getElementsByTagName("actions").item(0), element);
		}
		
		if (xml.getElementsByTagName("sysExceptions").length != 0) {
			result = result | processXmlExceptions(xml.getElementsByTagName("sysExceptions").item(0), useActivePanel);
			useActivePanel = false;
		}
		
		if (xml.getElementsByTagName("exceptions").length != 0) {
			result = result | processXmlExceptions(xml.getElementsByTagName("exceptions").item(0), useActivePanel);
			useActivePanel = false;
		}
		
		if (xml.getElementsByTagName("sysMessages").length != 0) {
			result = result | processXmlMessages(xml.getElementsByTagName("sysMessages").item(0), useActivePanel);
		}
		
		if (xml.getElementsByTagName("code").length != 0) {
			if (! checkXmlResultCode(xml.getElementsByTagName("code"))) {
				SYS_PANELS.refresh();
				return false;
			}
		}
	}
	
	if (result == true) {
		SYS_PANELS.refresh();
		return result;
	}
	
	if(showOops==undefined || showOops){
		showMessage(ERR_NOTHING_TO_LOAD);
	}
	
	return false;
}

function processXmlExceptions(xml,useActivePanel) {
	var exceptions = xml.getElementsByTagName("exception");
	if (exceptions != null && exceptions.length != 0) {
		var element = useActivePanel ? SYS_PANELS.getActive() : SYS_PANELS.newPanel();
		SYS_PANELS.showingLoading = false;
		element.addClass("modalError");
		element.header.innerHTML = GNR_TITILE_EXCEPTIONS;
		
		var html = "";
		
		for (var i = 0; i < exceptions.length; i++) {
			var exception = exceptions[i];
			var text = exception.getAttribute("text");
			html += "<label>" + text + "</<label>";
			
			//var value	= (exception.childNodes.length > 0) ? exception.firstChild.nodeValue : "";
			var value	= getTagContent(exception);
			if (value != null && value != "") html += "<div class='stacktrace'>" + value + "</div>";
			
			html += "<br>";
		}
		
		element.content.innerHTML = html;
		SYS_PANELS.addClose(element, true);
		element.position();
		
		return true;
	}
	
	return false;
}

function processXmlMessages(xml,useActivePanel) {
	var messages = xml.getElementsByTagName("message");
	if (messages != null && messages.length != 0) {
		var element = useActivePanel ? SYS_PANELS.getActive() : SYS_PANELS.newPanel();
		SYS_PANELS.showingLoading = false;

		element.header.innerHTML = GNR_TITILE_MESSAGES;
		
		var html = "";
		
		for (var i = 0; i < messages.length; i++) {
			var message = messages[i];
			var exception = message.getAttribute("text");
			html += exception + "<br>";
		}
		
		element.content.innerHTML = html;
		SYS_PANELS.addClose(element, false);
		//element.setAttribute('z-index',99999);
		element.setAttribute('z-index',SYS_PANELS.getNewZIndex());
		element.position();
		
		return true;
	}
	
	return false;
}

var lastFunctionAjaxCall = null;
function processModalXmlFunction(xml,element,canClose) {
	var toLoad				= xml.getElementsByTagName("load").item(0);
	lastFunctionAjaxCall	= toLoad.getElementsByTagName("function").item(0);
	
	var functionName = lastFunctionAjaxCall.getAttribute("name");
	
	//window.setTimeout(functionName + "()",10);
	//Para que se le pueda pasar parametros a la funcion a invocar
	if (functionName.indexOf("(")!=-1){
		eval(functionName);	
	}else{
		eval(functionName + "()");
	}
	return true;
}

function getLastFunctionAjaxCall() {
	var xml = lastFunctionAjaxCall;
	lastFunctionAjaxCall = null;
	return xml;
}

/** Encargado de procesar una tabla y sus elementos. Crea una tabla en funci�n
 * de la informaci�n recibida.<b>
 * @param object xml de la tabla
**/
function processModalXmlFormTable(xmlTable) {
	var html = "";

	if (xmlTable != null && xmlTable.length > 0) {
		var aTable	= xmlTable.item(0);
		var rows	= aTable.getElementsByTagName("row");
		
		html += "<table width=\"100%\" " + processXmlTagAttributes(aTable) + ">";

		for (var i = 0; rows != null && i < rows.length; i++) {
			var row		= rows.item(i);
			var cells	= row.getElementsByTagName("cell");
			
			html += "<tr " + processXmlTagAttributes(row) + ">";
			
			for (var j = 0; cells != null && j < cells.length; j++) {
				var cell	= cells.item(j);
				var value	= getTagContent(cell); //(cell.childNodes.length > 0)?cell.firstChild.nodeValue:"";
				
				html += "<td " + processXmlTagAttributes(cell) + ">" + value + "</td>";
			}
			
			html += "</tr>";
		}
		
		html += "</table>";
	}

	return html;
}

/**
 * Encargado de procesar los elementos recibidos en el xml. Crea
 * el c�digo HTML para cada uno de los elementos recibidos.
 * @param object xml de los elementos
**/
function processModalXmlFormElements(xmlElements, forFilter) {
	var html = "";

	if (xmlElements != null && xmlElements.length > 0) {
		var elements = xmlElements.item(0).getElementsByTagName("element");
	
		html += "<table";
		if (forFilter) {
		}
		html += ">";
		
		htmlHidden = "";
	
		var mustOpenTr = true;
		var mustCloseTr = true;
		
		for (var i = 0; elements != null && i < elements.length; i++) {
			var element = elements.item(i);
			if (element != null) {
				var type				= element.getAttribute("type");
				var name				= element.getAttribute("name");
				var text				= element.getAttribute("text");
				var title				= element.getAttribute("title");
				var valueAsAttribute	= element.getAttribute("valueAsAttribute");
				var value				= toBoolean(valueAsAttribute) ? element.getAttribute("value") : ((element.firstChild != null) ? element.firstChild.nodeValue : "");
				var id					= element.getAttribute("id");
				var idName				= id;
				var isHtml				= element.getAttribute("html");
				var selected			= element.getAttribute("selected");
				var disabled			= element.getAttribute("disabled");
				var onChange			= element.getAttribute("onChange");
				var mandatory			= toBoolean(element.getAttribute("mandatory"));
				var cssClass			= element.getAttribute("class");
				var maxlength			= (element.getAttribute("maxlength") != null) ? element.getAttribute("maxlength") : "";
				var readOnly			= toBoolean(element.getAttribute("readonly"));
				var style				= element.getAttribute("style");
				var size				= element.getAttribute("size");
				var modal				= element.getAttribute("modal");
				var modalFunction		= element.getAttribute("modalFunction");
				var normalWhiteSpace	= toBoolean(element.getAttribute("normalWhiteSpace"));
				
				if (title == null) title = "";
				if (title != "") title = " title=\"" + title + "\" ";
				
				if (forFilter) mustCloseTr = !mustCloseTr;
				
				if (id == null) id = "";
				if (id != "") id = "id=\"" + id + "\"";
				
				if (onChange == null) onChange = "";
				if (onChange != "") onChange = "onChange=\"" + onChange + "\"";
				
				var htmlOptions = "";
				if (type == "select" || type == "radio" || type == "list") {
					htmlOptions = processModalXmlFormElementOptions(element.getElementsByTagName("options").item(0),value,type,name,onChange);
				} else if (type == "selectMultiple") {
					type = "selectMultiple";
					htmlOptions = processModalXmlFormElementOptionsValues(element.getElementsByTagName("options").item(0),element.getElementsByTagName("values").item(0),type,name);
				}

				if (isHtml == "false") value = value.replace("<","&lt;").replace(">","&gt;");
				
				if (style == null) style = "";
				if (style != "") style = " style=\"" + style + "\" ";
				
				if (size == null) size = "";
				if (size != "") size = " size= \"" + size + "\" ";
	
				if (type == "select") {
					if (mustOpenTr) html += "<tr>";
					if (mandatory){
						if (text!=""){
							html += "<td class=\"text required" + (normalWhiteSpace ? " normalWhiteSpace" : "") + "\"" + title + ">" + text + ":</td>";
						}else{
							html += "<td class=\"text required" + (normalWhiteSpace ? " normalWhiteSpace" : "") + "\"" + title + ">" + text + "</td>";
						}
						html +="<td class=\"content\"><select " + id + " " + onChange + " name=\"" + name + "\" class=\"" + cssClass + "\"" + style + ">" + htmlOptions + "</select></td>";
					} else {
						if (text!=""){
							html += "<td class=\"text\"" + title + ">" + text + ":</td>";
						}
						html += "<td class=\"content\"><select " + id + " " + onChange + " name=\"" + name + "\" class=\"" + cssClass +"\"" + style + ">" + htmlOptions + "</select></td>";
					}
					if (mustCloseTr) html += "</tr>";
				
				} else if (type == "selectMultiple") {
					if (mustOpenTr) html += "<tr>";
					html += "<td class=\"text\"" + title + ">" + text + ":</td><td class=\"content\"><select " + id + " " + onChange + " name=\"" + name + "\" multiple size=\"5\">" + htmlOptions + "</select></td>";
					if (mustCloseTr) html += "</tr>";
				
				} else if (type == "textarea") {
					if (mustOpenTr) html += "<tr>";
					
					var height = element.getAttribute("height");
					var width = element.getAttribute("width");
					
					var textareaStyle = "";
					if (height != null && height != "") textareaStyle += "height: " + height + "px; ";
					if (width != null && height != "") textareaStyle += "width: " + width + "px; ";
					if (textareaStyle != "") textareaStyle = " style=\"" + textareaStyle + "\" ";
					
					if (text != null && text != "") {
						html += "<td class=\"text\"" + title + ">" + text + ":</td><td class=\"content\">";
					} else {
						html += "<td class=\"content\" colspan=\"2\">";
					}
					html += "<textarea isEditor=\"false\" " + id + " " + onChange + textareaStyle + " name=\"" + name + "\">" + value + "</textarea></td>";
					if (mustCloseTr) html += "</tr>";
				
				} else if (type == "editor") {
					if (mustOpenTr) html += "<tr>";
					
					html += "<td colspan=\"2\">";
					html += "<textarea name=\"" + name + "\" " + id + " isEditor=\"true\">" + value + "</textarea>";
					html += "</td>";
					
					if (mustCloseTr) html += "</tr>";
					
				} else if (type == "fixed") {
					if (mustOpenTr) html += "<tr>";
					if (text != "") text += ":";
					html += "<td class=\"text\"" + title + ">" + text + "</td><td class=\"content\">" + value + "</td>";
					if (mustCloseTr) html += "</tr>";
				
				} else if (type == "2column") {
					if (mustOpenTr) html += "<tr>";
					
					if (text == "" || text == null) text = value;
					
					if (cssClass) { 
						html += "<td colspan=\"2\" class=\""+cssClass+"\">" + text + "</td>"; 
					} else {
						html += "<td colspan=\"2\">" + text + "</td>"; 
					}
					
					
					if (mustCloseTr) html += "</tr>";
				
				} else if (type == "checkbox") {
					selected = toBoolean(selected) ? "checked " : "";
					disabled = toBoolean(disabled) ? "disabled " : "";
					if (mustOpenTr) html += "<tr>";
					html += "<td colspan=\"2\"" + title + "><input type=\"checkbox\" class=\"default\" " + (value?"value=\"" + value + "\"":"") + " " + selected + disabled + id + " " + onChange + " name=\"" + name + "\">" + text + "</td>";
					if (mustCloseTr) html += "</tr>";
				
				} else if (type == "2columnTitle") {
					if (mustOpenTr) html += "<tr>";
					html += "<td colspan=\"2\"" + title + "><b>" + text + "</b></td>";
					if (mustCloseTr) html += "</tr>";
				
				} else if (type == "radio") {
					if (text == "") {
						if (mustOpenTr) html += "<tr>";
						html += "<td colspan=\"2\"" + title + ">" + htmlOptions + "</td>";
						if (mustCloseTr) html += "</tr>";
					} else {
						if (mustOpenTr) html += "<tr>";
						html += "<td class=\"text\"" + title + ">" + text + ":</td><td class=\"content\">" + htmlOptions + "</td>";
						if (mustCloseTr) html += "</tr>";
					}
				
				} else if (type == "list") {
					if (mustOpenTr) html += "<tr>";
					html += "<td class=\"text\">" + text + ":</td><td class=\"content\">" + htmlOptions + "</td>";
					if (mustCloseTr) html += "</tr>";
				
				} else if (type == "hidden") {
					htmlHidden += "<input type=\"" + type + "\"  class=\"default\" " + id + " " + onChange + " name=\"" + name + "\" value=\"" + value + "\">";
				
				} else if (type == "image") {
					if (mustOpenTr) html += "<tr>";
					html += "<td colspan=\"2\"><img onload=\"SYS_PANELS.refresh();\" src=\"" + value + "\" alt=\"" + text + "\" " + id + " " + onChange + " name=\"" + name + "\" id=\"" + name + "\"></td>";
					if (mustCloseTr) html += "</tr>";
				
				} else if (type == "flash") {
					if (mustOpenTr) html += "<tr>";
					html += "<td colspan=\"2\"><object width=550 height=300 modalFlash=true><param name=\"movie\" value=\"" + value + "\"><embed width=550 height=300 src=\"" + value + "\"></embed></object></td>";
					if (mustCloseTr) html += "</tr>";
				
				} else if (type == "flashVideo") {
					value = value.split("&").join("%26") + ".flv";
					
					var htmlVar = "";
					htmlVar += "file=" + SITE_CONTEXT + "/" + value;
					htmlVar += "&autostart=true";
					htmlVar += "&controlbar=over";
					htmlVar += "&fullscreen=true";
					htmlVar += "&stretching=fill";
					
					if (mustOpenTr) html += "<tr>";
					html += "<td colspan=\"2\" align=\"cener\">";
					html += "<object modalFlash=true classid=\"clsid:d27cdb6e-ae6d-11cf-96b8-444553540000\" ";
					html += "	codebase=\"http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=9,0,0,0\""; 
					html += "	width=\"500\" ";
					html += "	height=\"380\" ";
					html += "	id=\"player\" ";
					html += "	align=\"middle\">";
					html += "	<param name=\"allowFullScreen\" value=\"true\" />";
					html += "	<param name=\"flashvars\" value=\"" + htmlVar + "\" />";
					html += "	<param name=\"swliveconnect\" value=\"true\">";
					html += "	<param name=\"movie\" value=\"" + SITE_CONTEXT + "/pages/player/player.swf" + "\" />";
					html += "	<param name=\"quality\" value=\"high\" />";
					html += "	<param name=\"bgcolor\" value=\"#000000\" />";
					html += "	<embed ";
					html += "		src=\"" + SITE_CONTEXT + "/pages/player/player.swf" + "\""; 
					html += "		quality=\"high\" ";
					html += "		swliveconnect=\"true\""; 
					html += "		bgcolor=\"#000000\" ";
					html += "		width=\"500\" ";
					html += "		height=\"380\" ";
					html += "		name=\"player\" ";
					html += "		align=\"middle\" ";
					html += "		allowFullScreen=\"true\""; 
					html += "		type=\"application/x-shockwave-flash\""; 
					html += "		pluginspage=\"http://www.macromedia.com/go/getflashplayer\""; 
					html += "		flashvars=\"" + htmlVar + "\" />";
					html += "</object>";
					html += "</td>";
					if (mustCloseTr) html += "</tr>";
				
				} else if (type == "empty") {
					if (mustOpenTr) html += "<tr>";
					html += "<td colspan=\"2\">&nbsp;</td>";
					if (mustCloseTr) html += "</tr>";
				
				} else {
					var mdlHtml = "";
					if (modal!=null && modal!= ""){
						mdlHtml += "<img src=\"" + CONTEXT + "/css/" + STYLE + "/img/btnQuery.gif\" onclick=\"" + modalFunction + "\">";
					}
					
					if (text != null && text != "") text += ":";
					if (mustOpenTr) html += "<tr>";
					if (mandatory){
						html += "<td class=\"text required" + (normalWhiteSpace ? " normalWhiteSpace" : "") + "\"" + title + ">" + text + "</td><td class=\"content\"><input type=\"" + type + "\" " + id + " " + onChange + " name=\"" + name + "\" value=\"" + value + "\" maxlength=\"" + maxlength  + "\" "  + (readOnly?" readonly='true' ":"") +  " class=\""+cssClass +"\"" + size + ">" + mdlHtml + "</td>";
					}else{
						html += "<td class=\"text" + (normalWhiteSpace ? " normalWhiteSpace" : "") + "\"" + title + ">" + text + "</td><td class=\"content\"><input type=\"" + type + "\" " + id + " " + onChange + " name=\"" + name + "\" value=\"" + value + "\" maxlength=\"" + maxlength +"\""  + (readOnly?" readonly='true' ":"") +  " class=\""+cssClass +"\"" + size + ">" + mdlHtml + "</td>";
					}
					if (mustCloseTr) html += "</tr>";
				}
				
				if (forFilter) mustOpenTr = !mustOpenTr;
			}
		}
		if (!mustCloseTr) html += "</tr>";
		
		if (htmlHidden != "") {
			html += "<tr><td colspan=\"2\">" + htmlHidden + "</td></tr>";
		}
		
		html += "</table>";
	}

	return html;
}

function processModalXmlFormElementsEditorToActivate(xmlElements) {
	var result = new Array();

	if (xmlElements != null && xmlElements.length > 0) {
		var elements = xmlElements.item(0).getElementsByTagName("element");
		
		for (var i = 0; elements != null && i < elements.length; i++) {
			var element = elements.item(i);
			if (element != null) {
				var type		= element.getAttribute("type");
				var id			= element.getAttribute("id");
	
				if (id == null) continue;
				if (id == "") continue;
				
				if (type == "editor") {
					result.push(id);
				}
			}
		}
	}

	return result;
}

/**
 * Encargado de procesar los options de un element SELECT recibidos en el xml. Crea
 * el c�digo HTML para cada uno de los options recibidos.
 * @param object xml de los options de un element
 * @param string valor seleccionado en el select
 * @param string tipo de elemento para el cual son las opciones
 * @param string nombre del elemento si es necesario (solo para radio buttons)
**/
function processModalXmlFormElementOptions(xmlOptions,selectedValue,type,name,onChange) {
	var html = "";
	
	if (xmlOptions == null) return html;
	var options = xmlOptions.getElementsByTagName("option");

	for (var i = 0; i < options.length; i++) {
		var option = options.item(i);
		if (option != null) {
			var value		= option.getAttribute("value");
			var text		= (option.firstChild != null)?option.firstChild.nodeValue:"";
			var selected	= (value == selectedValue)?((type == "radio")?"checked ":"selected "):" ";
			var tooltip 	= option.getAttribute("tooltip");
			
			if (!tooltip) tooltip = "";
			
			if (type == "radio") {
				html += "<input type=\"radio\" class=\"default\" id=\"" + value +"\" name=\"" + name + "\" value=\"" + value + "\" " + selected + onChange + ">" + text + "</option>";
				html += "<br>";
			
			} else if (type == "list") {
				html += text;
				html += "<br>";
			
			} else {
				html += "<option value=\"" + value + "\" " + selected + " title=\"" + tooltip + "\">" + text + "</option>";
			}
		}
	}
	return html;
}
/**
 * Encargado de procesar los options y values de un element SELECT MULTIPLE recibidos en el 
 * xml. Crea el c�digo HTML para cada uno de los options recibidos.
 * @param object xml de los options de un element
 * @param object xml de los valores seleccionado en el select
 * @param string tipo de elemento para el cual son las opciones
 * @param string nombre del elemento si es necesario (solo para radio buttons)
 **/
function processModalXmlFormElementOptionsValues(xmlOptions,xmlSelectedValues,type,name) {
	var options = xmlOptions.getElementsByTagName("option");
	var values = (xmlSelectedValues != null) ? xmlSelectedValues.getElementsByTagName("text") : null;
	var html = "";

	var theValues = new Array();
	
	if (values != null) {
			for (var i = 0; i < values.length; i++) {
			var value = values.item(i);
			if (value != null) {
				theValues[theValues.length] = (value.firstChild != null) ? value.firstChild.nodeValue : "";
			}
		}
	}
	
	for (var i = 0; i < options.length; i++) {
		var option = options.item(i);
		if (option != null) {
			var value		= option.getAttribute("value");
			var text		= (option.firstChild != null)?option.firstChild.nodeValue:"";
			var selected	= (isInArray(theValues,value)) ? "selected" : "";
			
			html += "<option value=\"" + value + "\" " + selected + ">" + text + "</option>";
		}
	}
	return html;
}

function processModalXmlFormButtons(xmlButtons,element,formId) {
	var html = "";

	if (xmlButtons != null && xmlButtons.length > 0) {
		var buttons = xmlButtons.item(0).getElementsByTagName("button");
	
		for(var i = 0; i < buttons.length; i++) {
			var button = buttons.item(i);
			if (button != null) {
				var value	= button.getAttribute("text");
				var onclick	= button.getAttribute("onclick");
				var type	= button.getAttribute("type");
				var id		= button.getAttribute("id");
				
				if (id == null) id = "";
				if (id != "") id = "id=\"" + id + "\"";
				
				if (onclick == "hiddeElement") {
					onclick = "SYS_PANELS.hiddeActive()";
				}
				
				if (onclick == null) { onclick = ""; } else { onclick += ";"; }
				
				if (type == "showAjax") {
					type	= "button";
					onclick	+= "SYS_PANELS.newPanel(); doModalAjax('" + onclick + "',event);";
				} else if (type == "url") {
					type = "button";
					onclick = "SYS_PANELS.showLoading(); doLink('" + CONTEXT + onclick + "');";
				} else if (type == "submitAjax") {
					type = "button";					
					onclick += "doAjaxSubmit('" + formId + "', true);";
				} else if (type == "submit") {
					onclick = "if (doNormalSubmit('" + formId + "',this)) { " + onclick + " } ";
				}
				
				//html += "<input type=\"" + type + "\" " + id + " value=\"" + value + "\" onClick=\"" + onclick + "\">";
				html += "<div class='button' " + id + " formId=\"" + formId + "\" onClick=\"" + onclick + "\">" + value + "</div>";
			}
		}
	}
	
	return html;
}

function processModalXmlText(xml,element,canClose) {
	var toLoad		= xml.getElementsByTagName("load").item(0);
	var onClose 	= xml.getElementsByTagName("data").item(0).getAttribute("onClose");
	var theText		= toLoad.getElementsByTagName("text").item(0);
	var closeAll	= theText.getAttribute("closeAll");
	var addClass	= theText.getAttribute("addClass");
	var title		= theText.getAttribute("title");
	
	var html = getTagContent(theText);

	if (element == null && html != null && html.length > 0) element = SYS_PANELS.getActive();
	if (element != null) {
		element.addClass("addClass");
		element.content.innerHTML = html;
		if (title && title != ""){
			element.header.innerHTML = title;
		} else {
			element.header.innerHTML = "";
		}
		if (addClass && addClass != "") element.addClass(addClass);
		if (canClose) {
			element.footer.innerHTML = "";
			SYS_PANELS.addClose(element, closeAll, onClose);
		}
	}
}

/**
 * Encargado de procesar el xml y generar un formulario con la distinta informaci�n recibida.
 * @param object el xml recibido
 * @param object el elemento en donde ser� cargado el xml procesado
**/
function processModalXmlForm(xml,element,canClose) {
	if (element == null) element = SYS_PANELS.newPanel();
	
	var toLoad = xml.getElementsByTagName("load").item(0);
	var theForm = toLoad.getElementsByTagName("form").item(0);
	
	var formAction			= theForm.getAttribute("action");
	var multiPartForm		= toBoolean(theForm.getAttribute("multiPart"));
	var formAjaxSumbit		= theForm.getAttribute("ajaxsubmit");
	var formAjaxNewPanel	= toBoolean(theForm.getAttribute("ajaxNewPanel"));
	var formDoEscape		= toBoolean(theForm.getAttribute("doEscape"));
	var formTitle 			= theForm.getAttribute("title");
	var formAutoExpand 		= theForm.getAttribute("autoExpand");
	var closeAll 			= theForm.getAttribute("closeAll");
	var addClass			= theForm.getAttribute("addClass");
	var onLoad				= theForm.getAttribute("onLoad");
	//var onClose				= theForm.getAttribute("onClose");
	var onClose				= xml.getElementsByTagName("data").item(0).getAttribute("onClose");
	var formMethod 			= "post";
	
	var showErrors = toBoolean(theForm.getAttribute("showErrors"));
	
	if (formDoEscape) {
		formDoEscape = "doEscape='true' "
	} else {
		formDoEscape = "";
	}
	
	if (formAjaxSumbit == "true") {
		//formAjaxSumbit = "onsubmit=\" return doAjaxSubmit(this," + formAjaxNewPanel + ");\"";
		//Realiza el mismo comportamiento al darle enter que con clic
		//formAjaxSumbit = "onsubmit=\"SYS_PANELS.showLoading(); return doAjaxSubmit(this," + formAjaxNewPanel + ");\""; 
	} else {
		if (formAction.indexOf("/") != 0) formAction = "/" + formAction;
		//if (formAction.indexOf(CONTEXT) == -1) formAction = CONTEXT + formAction;
	}
	
	if (formTitle != "") {
		element.header.empty();
		new Element("span", {html: formTitle}).inject(element.header);
	}
	
	if (addClass && addClass != "") element.addClass(addClass);
	
	var formStart = "";
	var formEnd = "";
	
	var theId = null;
	
	if (formAction != null && formAction != "") {
		var htmlMultipart = "";
		if (multiPartForm) {
			htmlMultipart = " enctype=\"multipart/form-data\" target=\"iframeUpload\" ";
		}

		theId = "frm" + new Date().getTime();
		
		formStart = "<form action=\"" + formAction + "\" method=\"" + formMethod + "\" id=\"" + theId + "\" " + htmlMultipart + formDoEscape + " >";
		formEnd = "</form>";
		
		if (multiPartForm) {
			formStart = "<iframe name=\"iframeUpload\" id=\"iframeUpload\" style=\"display:none;\"></iframe>" + formStart;
		}
	}
	
	var theFilters	= theForm.getElementsByTagName("filters");
	var theElements	= theForm.getElementsByTagName("elements");
	var theFooters	= theForm.getElementsByTagName("footers");
	
	var theElementsHeight = (theElements != null && theElements.length > 0) ? theElements.item(0).getAttribute("height") : "";
	
	var formFilters		= processModalXmlFormElements(theFilters, true);
	var formElements	= processModalXmlFormElements(theElements, false);
	var formFooters		= processModalXmlFormElements(theFooters, true);
	
	var editorsToActivate = processModalXmlFormElementsEditorToActivate(theElements);
	
	var formTable		= processModalXmlFormTable(theForm.getElementsByTagName("table"));
	var formButtons		= processModalXmlFormButtons(theForm.getElementsByTagName("buttons"),element,theId);
	
	var onCloseEvent = "";
	for (var i = 0; i < editorsToActivate.length; i++) {
		onCloseEvent += "deactivateEditor('" + editorsToActivate[i] + "');";
	}
	

	var formFooter = "";
	if (formFooters != null && formFooters.length > 0) formFooter += "<table><tr><td valign=top>";
	formFooter += formButtons;
	if (formFooters != null && formFooters.length > 0) formFooter += "</td><td valign=top>";
	formFooter += formFooters;
	if (formFooters != null && formFooters.length > 0) formFooter += "</td></tr></table>";
	formFooter += "</div>";
	
	var formFilter = "";
	
	if (formFilters != null && formFilters.length > 0) { 
		formFilter += "<div id=\"ajaxResultFilter\" class=\"ajaxResultFilter\">" + formFilters + "</div>";
	}

	var htmlForm  = "";
	htmlForm += formStart;
	htmlForm += formFilter;
	htmlForm += formTable;
	htmlForm += formElements;
	htmlForm += formEnd;

	//Definir el footer
	element.footer.innerHTML = formFooter;
	//if (canClose) SYS_PANELS.addClose(element, closeAll);
	if (canClose) SYS_PANELS.addClose(element, closeAll, onClose);
	
	
	element.content.innerHTML = htmlForm;
	
	if (theId) {
		var theFormId = $(theId);
		
		theFormId.formChecker = new FormCheck(
			theId,
			{
				submit:false,
				display : {
					keepFocusOnError : 1,
					tipsPosition: 'left',
					tipsOffsetY: -12,
					tipsOffsetX: -10
				}
			}
		);
		if (formAjaxSumbit == "true") {
			theFormId.addEvent('submit', function() {
				/*SYS_PANELS.showLoading();
				return doAjaxSubmit(this, formAjaxNewPanel);*/
			});
		}
	}
	
		if (theElementsHeight != null && theElementsHeight != "") {
			ajaxResultContent.style.height = theElementsHeight;
			formAutoExpand = false;
		
		} else if (document.all && typeof document.body.style.maxHeight == "undefined") {
			var height = element.content.offsetHeight;
			element.content.style.height = "100%";
			if (element.content.offsetHeight > height) {
				element.content.style.height = height + "px";
			}
		
		} else { 
			element.content.style.height = "100%";
		}
	
	for (var i = 0; i < editorsToActivate.length; i++) {
		activateEditor(editorsToActivate[i]);
	}
	
	SYS_PANELS.refresh(toBoolean(formAutoExpand));
	
	if (onLoad != "" && onLoad != null) {
		var fn = window[onLoad];
		jsCaller(fn, null);
	}
	
	//if (showErrors) showAjaxErrors();
}

/**
 * Process the xml actions and creates the corresponding timeout functions to be executed. Call 
 * cancelAjaxHidde to cancel all the timeout functions.
 */
function processXmlActions(xmlActions, element) {
	var actions = xmlActions.getElementsByTagName("action");
	var result = false;
	
	for (var i = 0; i < actions.length; i++) {
		var action = actions.item(i);
		result = true;
		
		if (action != null) {
			var toDo = action.getAttribute("toDo");
			
			if (toDo == "ajaxTimed") {
				var paramTime	= action.getElementsByTagName("param").item(0).firstChild.nodeValue;
				var paramUrl	= action.getElementsByTagName("param").item(1).firstChild.nodeValue;
				
				ajaxTimeout1 = setTimeout("doModalAjaxTimed('" + paramUrl + "')",paramTime);
			} else if (toDo == "functionTimedCall") {
				var paramTime	= action.getElementsByTagName("param").item(0).firstChild.nodeValue;
				var paramFnc	= action.getElementsByTagName("param").item(1).firstChild.nodeValue;
				
				if(paramFnc.indexOf('(') != -1){
					setTimeout(function() {
						eval(paramFnc);
					},paramTime);
				} else {
				
					var fn = window[paramFnc];
				
					ajaxTimeout1 = setTimeout(fn,paramTime);
				}
			} else if (toDo == "linkTimed") {
				var paramTime	= action.getElementsByTagName("param").item(0).firstChild.nodeValue;
				var paramUrl	= action.getElementsByTagName("param").item(1).firstChild.nodeValue;

				if (paramUrl.indexOf("/") != 0) paramUrl = "/" + paramUrl;
				
				ajaxTimeout1	= setTimeout("doLink('" + CONTEXT + paramUrl + "')",paramTime);
				
			} else if (toDo == "ajaxHidde") {
				var paramTime	= action.getElementsByTagName("param").item(0).firstChild.nodeValue;
				ajaxTimeout2	= setTimeout("SYS_PANELS.closeActive()",paramTime);
				
			} else if (toDo == "ajaxHiddeAll") {
				var paramTime	= action.getElementsByTagName("param").item(0).firstChild.nodeValue;
				ajaxTimeout2	= setTimeout("SYS_PANELS.closeAll()",paramTime);
				
			}
		}
	}
	
	return result;
}

function doLink(url) {
	document.location = url;
}

function doNormalSubmit(name,btn) {
	var form = $(name);
	
	if (! form.formChecker) {
		form.formChecker = new FormCheck(
				form,
				{
					submit:false,
					display : {
						keepFocusOnError : 1,
						tipsPosition: 'left',
						tipsOffsetY: -12,
						tipsOffsetX: -10
					}
				}
		);
	}

	if (!form.formChecker.isFormValid()) return false;
	$(btn).setStyle('display','none') ;
	form.submit();
	return true;
}

function doAjaxSubmit(name,newPanel,event,showLoading) {
	var form = $(name);
	
	if (! form) return;
	
	if (! form.formChecker) {
		form.formChecker = new FormCheck(
				form,
				{
					submit:false,
					display : {
						keepFocusOnError : 1,
						tipsPosition: 'left',
						tipsOffsetY: -12,
						tipsOffsetX: -10
					}
				}
		);
	}
	
	if (!form.formChecker.isFormValid()) return ;
	if (showLoading == null) showLoading = true;
	
	var url = form.getAttributeNode("action").value;
	var params = "";
	
	var doEscape = form.getAttribute("doescape") == "true";
	
	if (form.childNodes.length > 0) {
		for (var i = 0; i < form.elements.length; i++) {
			var formElement = form.elements[i];
			
			var formEleName = formElement.name;
			var formEleValue = formElement.value;
			var avoidSend = toBoolean(formElement.getAttribute("avoidSend"));
			
			if (avoidSend) continue;
			if (formEleName == null || formEleName == "") continue;
			
//			if (formElement.tagName == "TEXTAREA" && toBoolean(formElement.getAttribute("isEditor"))) {
//				var inst = tinyMCE.getInstanceById(formElement.id);
//				formEleValue = inst.getContent();
//				tinyMCE.execCommand('mceRemoveControl', false, formElement.id);
//			}
			
			if (formElement.type == "select-multiple") {
				for ( var j = 0; j < formElement.options.length; j++) {
					if (formElement.options[j].selected) {
						if (params != "") params += "&";
						params += formEleName + "=" + formElement.options[j].value;
					}
				}
			} else if ((formElement.type == "checkbox" && formElement.checked) || (formElement.type == "radio" && formElement.checked) || (formElement.type != "radio" && formElement.type != "checkbox"))  {
				if (params != "") params += "&";
				params += formEleName + "=" + (doEscape ? encodeURIComponent(formEleValue) : formEleValue);
				//params += formEleName + "=" + escape(formEleValue);
				//params += formEleName + "=" + formEleValue;
			}
		}
	}

	if (newPanel == null) newPanel = false;
	if (newPanel) SYS_PANELS.showLoading();
	
	new Request({
		method: 'post',
		url: CONTEXT + url,
		onComplete: function(resText, resXml) { modalProcessXml(resXml);  }
	}).send(params);
	
	return false;
}

function ajaxUploadStartStatus() {
	AJAX_PANEL.newPanel();
	var panel = AJAX_PANEL.getActive();
	
	var html = "";
	
	html += "<div style='border: thin #FFFFFF solid; width: 200px;' id='progressBarContainer'><img id='progressBar' src='" + SITE_SKIN_CONTEXT + "/images/progress.gif' height='10px' width='0px'></div>";

	panel.innerHTML = html;
	
	ajaxUploadCallStatusUrl();
}

function ajaxUploadCallStatusUrl() {
	new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX + "?action=ajaxUploadFileStatus&isAjax=true" + TAB_ID_REQUEST,
		onComplete: function(resText, resXml) { modalProcessXml(resXml);  }
	}).send();
}

function ajaxUploadClearStatus() {
	var progressMessages		= $("progressMessages");
	var progressBar				= $("progressBar");
	var progressBarContainer	= $("progressBarContainer");
	
	if (progressMessages != null) progressMessages.empty();
	if (progressBar != null) progressBar.style.width = "0px";
}

function ajaxUploadUpdateStatus() {
	var doCall = false;
	var doClose = true;
	var ajaxCallXml = getLastFunctionAjaxCall();
	if (ajaxCallXml != null) {
		var messages = ajaxCallXml.getElementsByTagName("messages");
		
		if (messages != null && messages.length > 0 && messages.item(0) != null) {
			messages = messages.item(0).getElementsByTagName("message");
			
			var status		= null;
			var totalRead	= 0;
			var totalSize	= 1;
			var theMessage	= "";
			
			for(var i = 0; i < messages.length; i++) {
				var message = messages.item(i);
				var param	= message.getAttribute("name");
				var text 	= "";
				
				if (message.firstChild != null) text = message.firstChild.nodeValue;
				
				if ("status" == param) {
					status = text;
				
				} else if ("totalRead" == param) {
					totalRead = text;
				
				} else if ("totalSize" == param) {
					totalSize = text;
					
				} else if ("message" == param) {
					theMessage = text;
				}
			}

			var progressMessages		= $("progressMessages");
			var progressBar				= $("progressBar");
			var progressBarContainer	= $("progressBarContainer");

			if (progressBar != null && progressBarContainer != null)	progressBar.style.width = (progressBarContainer.offsetWidth * parseInt((totalRead / totalSize) * 100) / 100) + "px";
			if (progressMessages != null) {
				progressMessages.innerHTML = theMessage;
			}
			
			doCall = status == -1 || status == 1 || status == 2;
			doClose = (theMessage == null || theMessage == "") && ! doCall;
			
			if(status == 2){
				progressBar.style.width = "0px";
				
				
				if (! progressMessages.modalSpinnerWaiting) {
					progressMessages.modalSpinnerWaiting = true;
					progressMessages.innerHTML = "<img src='" + CONTEXT + "/css/" + STYLE + "/spinner.gif'></img>";
				} else {
					progressMessages.innerHTML == null;
					progressMessages.modalSpinnerWaiting = false;
					enableModal(SYS_PANELS.getActive(true));
					doCall = false;
				}
			}
		}
	}
	
	if (doCall) { 
		var funCall = ajaxCallXml.getAttribute("funCall");
		if (funCall!=null){
			setTimeout(funCall,200);
		}else{
			setTimeout("ajaxUploadCallStatusUrl()",200);
		}
	} else if (doClose) {
		SYS_PANELS.closeAll();
	}
	
	return true;
}

function isInArray(arr,value){
	for (var i=0;i<arr.length;i++){
		if (arr[i]==value){
			return true;
		}
	}
	return false;
}

function disableModal(modal){
	if (modal){
		
		modal.setAttribute("modalDisabled","true");
		var idsFieldsDisabled = ";";
		var idsFieldsReadOnly = ";";
		var idsFieldsClassReadOnly = ";";
	
		//Campos
		modal.getElements("input").each(function(input){
    		if (input.disabled == true){
    			idsFieldsDisabled += input.getAttribute("id") + ";"; 
    		} else {
    			input.disabled = true;
    		}
    		if (input.readOnly == true){
    			idsFieldsReadOnly += input.getAttribute("id") + ";";
    		} else {
    			input.readOnly = true;
    		}
    		if (input.hasClass("readonly")){
    			idsFieldsClassReadOnly += input.getAttribute("id") + ";";
    		} else{
    			input.addClass("readonly");
    		}
    		
    	});
		modal.getElements("select").each(function(select){
			if (select.disabled == true){
				idsFieldsDisabled += select.getAttribute("id") + ";"; 
    		} else {
    			select.disabled = true;
    		}
    		if (select.readOnly == true){
    			idsFieldsReadOnly += select.getAttribute("id") + ";";
    		} else {
    			select.readOnly = true;
    		}
    		if (select.hasClass("readonly")){
    			idsFieldsClassReadOnly += select.getAttribute("id") + ";";
    		} else{
    			select.addClass("readonly");
    		}
    	});
		
		//Botones
		modal.getElements("div.button").each(function (button){
			button.addClass("hiden");
		});
		modal.getElements("div.close").each(function (close){
			close.style.display = "none";
		});
		
		
		modal.setAttribute("idsFieldsDisabled",idsFieldsDisabled); 
		modal.setAttribute("idsFieldsReadOnly",idsFieldsReadOnly);
		modal.setAttribute("idsFieldsClassReadOnly",idsFieldsClassReadOnly);
	}
}

function enableModal(modal){
	
	if (modal && toBoolean(modal.getAttribute("modalDisabled"))){
		
		modal.setAttribute("modalDisabled","false");
		
		var idsFieldsDisabled = modal.getAttribute("idsFieldsDisabled");
		var idsFieldsReadOnly = modal.getAttribute("idsFieldsReadOnly");
		var idsFieldsClassReadOnly = modal.getAttribute("idsFieldsClassReadOnly");		
	
		//Campos
		modal.getElements("input").each(function(input){
    		if (idsFieldsDisabled.indexOf(";"+input.getAttribute("id")+";") < 0){
    			input.disabled = false;
    		}
    		if (idsFieldsReadOnly.indexOf(";"+input.getAttribute("id")+";") < 0){
    			input.readOnly = false;
    		}
    		if (idsFieldsClassReadOnly.indexOf(";"+input.getAttribute("id")+";") < 0){
    			input.removeClass("readonly");
    		}
    		
    	});
		modal.getElements("select").each(function(select){
			if (idsFieldsDisabled.indexOf(";"+select.getAttribute("id")+";") < 0){
				select.disabled = false;
    		}
    		if (idsFieldsReadOnly.indexOf(";"+select.getAttribute("id")+";") < 0){
    			select.readOnly = false;
    		}
    		if (idsFieldsClassReadOnly.indexOf(";"+select.getAttribute("id")+";") < 0){
    			select.removeClass("readonly");
    		}
    	});
		
		//Botones
		modal.getElements("div.button").each(function (button){
			button.removeClass("hiden");
			button.style.display = "";
		});
		modal.getElements("div.close").each(function (close){
			close.style.display = "";
		});
		
		
		modal.setAttribute("idsFieldsDisabled",""); 
		modal.setAttribute("idsFieldsReadOnly","");
		modal.setAttribute("idsFieldsClassReadOnly","");
		
	}
}

function getTagContent(tag) {
	var result = "";
	for (var i = 0; i < tag.childNodes.length; i++) {
		result += tag.childNodes[i].nodeValue;
	}
	return result;
}