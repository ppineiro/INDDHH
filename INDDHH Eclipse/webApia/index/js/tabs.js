/*

<div class='tabComponent' id="tabComponent">
	<div class='aTab'>
		<div class='tab'>t1</div>
		<div class='contentTab'>c1 <a href="#" onclick="$('tabComponent').changeTo(1);">go to next</a></div>
	</div>
	<div class='aTab'>
		<div class='tab'>t2</div>
		<div class='contentTab'>c2 <a href="#" onclick="$('tabComponent').add('asdadas');">add</a></div>
	</div>
	<div class='aTab'>
		<div class='tab'>t3</div>
		<div class='contentTab'>
			c3 <a href="#" onclick="$('tabComponent').remove($('tabComponent').countTabs()-1);">remove last</a>
		</div>
	</div>
</div>


funcionse que tiene que tener
.- cambiar tab: changeTo, changeToTitle, changeToTab
.- agregar tab: add, addTab
.- eliminar tab: remove, removeByTitle
.- obtener contenido tab: getContentTab, getContentTabByTitle
.- cantidad de tabs: countTabs
 */

function initTabs() {
	
	$$('div.tabComponent').each(function(container){
		
		container.tabs = new Array();
		container.tabsTitle = new Array();
		container.contents = new Array();
		container.currentActive = -1;
		
		//Crear el contenedor de los tabs
		container.containerTabs = new Element('div', {'class': 'tabHolder', 'id': 'tabHolder'});
		container.containerTabs.inject(container, 'before');
		
		container.containerTabs.set('changeEvent',container.get('changeEvent'));
		
		//Establecer el comportamiento del componente
		/* Cambiar a una posici�n espec�fica, devuelve true si se pudo cambiar, false si no se pudo */
		container.changeTo = function(pos) {
			var body = $(document.body);
			if (pos == null) return false;
			if (pos == -1) return false;
			if (pos == this.currentActive) return false;
			
			if (this.currentActive != -1) {
				this.contents[this.currentActive].lastScroll = body.getScroll();
				this.tabs[this.currentActive].removeClass('active');
				this.contents[this.currentActive].removeClass('active');
				
				this.tabs[this.currentActive].fireEvent("blur");
				this.tabs[this.currentActive].fireEvent("custom_blur");
			}
			
			this.currentActive = pos;
			
			this.tabs[this.currentActive].addClass('active');
			this.contents[this.currentActive].addClass('active');
			this.tabs[this.currentActive].fireEvent("focus");
			
			var scrollTo = {x: 0, y: 0};
			if (this.contents[this.currentActive].lastScroll) scrollTo = this.contents[this.currentActive].lastScroll;
			$(document.body).scrollTo(scrollTo.x, scrollTo.y);
			
			return true;
		};
		
		/* Cambia a un tab seg�n s� t�tulo, devuelve true si se pudo cambiar, false si no se pudo */
		container.changeToTitle = function(title) {
			return this.changeTo(this.tabsTitle.indexOf(title));
		};
		
		/* Cambia a un tab seg�n el tab, devuelve true si se pudo cambiar, false si no se pudo */
		container.changeToTab = function(tab) {
			return this.changeTo(this.tabs.indexOf(tab));
		}
		
		/* Agrega un nuevo tab, sin contenido, devolviendo el contenido de este. Devuelve el contenido agregado */
		container.add = function(title) {
			var tab = new Element('div', {'class': 'tab', html: title});
			var tabContent = new Element('div', {'class': 'aTab'});
			var content = new Element('div', {'class': 'contentTab'});
			content.inject(tabContent);
			
			this.grab(tabContent);
			
			this.addTab(tab, content);
			
			return content;
		};
		
		/* Agrega un tab y su contenido a la estructura interna */
		container.addTab = function(tab, content) {
			this.tabs.push(tab);
			this.tabsTitle.push(tab.innerText);
			this.contents.push(content);
			
			tab.tabContainer = this;			
			tab.addEvent('click', function(evt){
				var res = true;
				if(this.beforechange) {
					res = this.beforechange();
					if(res != false) res = true;
				}
				if(res) {
					this.tabContainer.changeToTab(this);
					if(this.getParent().get('changeEvent')){
						eval(this.getParent().get('changeEvent'));
					}
				}
			});
			
			
			
			content.tabContainer = this;
			content.tabTitle = tab;
			content.showTab = function () { this.tabContainer.changeToTab(this.tabTitle); };
			
			this.containerTabs.grab(tab);
		}
		
		/* Elimina un tab seg�n la posici�n */
		container.remove = function(pos) {
			if (pos == null) return false;
			if (pos == -1) return false;
			
			if (this.currentActive == pos) {
				if (this.currentActive == 0) {
					this.changeTo(this.currentActive+1);
				} else {
					this.changeTo(this.currentActive-1);
				}
			}
			
			var tab = this.tabs[pos];
			var content = this.contents[pos];
			
			this.tabs.splice(pos,1);
			this.tabsTitle.splice(pos,1);
			this.contents.splice(pos,1);
			
			if (pos <= this.currentActive) this.currentActive --;
			
			tab.dispose();
			content.dispose();
			
			return true;
		};
		
		/* Elimina un tab seg�n su t�tulo */
		container.removeByTitle = function(title) {
			return this.remove(this.tabsTitle.indexOf(title));
		}
		
		/* Devuelve el contenido de un tab seg�n su posici�n */
		container.getContentTab = function(pos) {
			if (pos == null) return null;
			if (pos == -1) return null;
			
			return this.contents[pos];
		};
		
		/* Devuelve el contenido de un tab seg�n el t�tulo */
		container.getContentTabByTitle = function(title) {
			return this.getContentTab(this.tabsTitle.indexOf(title));
		};
		
		/* Retorna la cantidad de tabs activos que hay */
		container.countTabs = function() {
			return this.tabs.length;
		}
		
		/* Retorna el tab seleccionado actualmente */
		container.getActiveTabId = function() {
			return this.currentActive;
		}
		
		
		//carga los distintos tabs
		container.getChildren('div.aTab').each(function(aTab){
			var tab = aTab.getChildren('div.tab')[0];
			var content = aTab.getChildren('div.contentTab')[0];
			container.addTab(tab, content);
		});
		
		/*
		//Ver si existe un header
		var aTabHeader = container.getChildren('.aTabHeader');
		aTabHeader = aTabHeader && aTabHeader.length && aTabHeader.length > 0 ? aTabHeader[0] : null;
		
		if (aTabHeader) aTabHeader.inject(container.containerTabs, 'top');
		
		container.setStyle('margin-top', container.containerTabs.offsetHeight);
		*/
		container.changeTo(0);
	});
}