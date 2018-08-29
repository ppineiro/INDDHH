/*var xml_in = getTables();'<tables><table name="Tabla1"><field name="Field1"/><field name="Field2"/></table><table name="Tabla2"><field name="Field3"/></table></tables>';*/
/*var xml_dim = '<dimensions><dimension foreignKey="PRODUCTO (ENTITY).ID_PRODUCTO" type="Time Dimension" name="PRODUCTOS"><hierarchy type="String" name="PRODUCTOS" view="SELECT * from pepe" aliasView="view1"><level hideMemberIf="Never" levelType="Regular" column="column" name="PRODUCTO" /><level hideMemberIf="Never" levelType="Regular" column="column" name="PRODUCTO" /></hierarchy></dimension><dimension foreignKey="CLIENTE (ENTITY).ID_CLIENTE" type="Time Dimension" name="CLIENTES"><hierarchy table="" primaryKeyTable="primaryKeyTable" primaryKey="primaryKey" column="column" type="String" name="CLIENTES" ><level hideMemberIf="Never" levelType="Regular" column="column" name="CLIENTE"/></hierarchy></dimension></dimensions>';*/
/*var def_xml_str = '<result><dimension type="normal" ><input name="Nombre"  prp="name" /><combo name="Tipo"  prp="type" >Standard,Time Dimension</combo><combo name="Clave foránea"  func="getColumns"  prp="foreignKey" /></dimension><dimension type="virtual" ><input name="Nombre"  prp="name" /><combo name="Tipo"  prp="type" >Standard,Time Dimension</combo></dimension><hierarchy type="normal" ><input name="Nombre"  prp="name" /><input name="Nombre para agrupación"  prp="allMemberName" /><combo name="Clave primaria"  func="getColumns"  prp="primaryKey" /><combo name="Tabla de la clave primaria"  func="getTables"  prp="primaryKeyTable" /><combo name="Tabla"  func="getTables"  prp="table" /></hierarchy><hierarchy type="virtual" ><input name="Nombre"  prp="name" /><input name="Nombre para agrupación"  prp="allMemberName" /></hierarchy><level><input name="Nombre"  prp="name" /><input name="Columna"  prp="column" /><combo name="Tipo"  prp="type" >String,Numeric,Integer,Boolean,Date</combo><combo name="Miembros únicos"  prp="uniqueMembers" >true,false</combo><combo name="Tipo de nivel"  prp="levelType" >Regular,TimeYears,TimeQuarters,TimeMonths,TimeDays</combo><combo name="Ocultar si"  prp="hideMemberIf" >Never,IfBlankName,IfParentsName</combo><combo name="Ordenar según columna"  func="getColumns"  prp="ordinalColumn" /></level></result>';*/

var def_xml;

window.addEvent('domready', function() {
	
	//Cargar definiciones
	if (window.DOMParser) {
		parser = new DOMParser();
		def_xml = parser.parseFromString(def_xml_str,"text/xml");
	} else {
		// Internet Explorer
		def_xml = new ActiveXObject("Microsoft.XMLDOM");
		def_xml.async = false;
		def_xml.loadXML(def_xml_str);
	}
	
	var xml_in = getXMLTables();
	
	//Cargar campos fuentes
	//Parsear XML
	var xmlDoc_in;
	if (window.DOMParser) {
		parser = new DOMParser();
		xmlDoc_in = parser.parseFromString(xml_in,"text/xml");
	} else {
		// Internet Explorer
		xmlDoc_in = new ActiveXObject("Microsoft.XMLDOM");
		xmlDoc_in.async = false;
		xmlDoc_in.loadXML(xml_in); 
	}
	
	var tables = xmlDoc_in.childNodes[0].childNodes;
	for(var i = 0; i < tables.length; i++) {
		addMesure(tables[i]);
	}
	
	//Cargar dimensiones
	var xmlDoc_dim;
	if (window.DOMParser) {
		parser = new DOMParser();
		xmlDoc_dim = parser.parseFromString(xml_dim,"text/xml");
	} else {
		// Internet Explorer
		xmlDoc_dim = new ActiveXObject("Microsoft.XMLDOM");
		xmlDoc_dim.async = false;
		xmlDoc_dim.loadXML(xml_dim); 
	}	
	
	var dimensions = xmlDoc_dim.childNodes[xmlDoc_dim.childNodes.length == 1 ? 0: 1].childNodes;
	for(i = 0; i < dimensions.length; i++) {
		addDimension(dimensions[i]);
	}
	
	
	$('addDimension').addEvent('click', function() {
		this.highlight();
		
		//Levantar modal
		$('dimDesignContainer').mask();
		
		$('dimDesignAdder').setStyle('display', 'block');
		$('dimDesignAdder').position({
			relativeTo: $('dimDesignContainer'),
			position: 'center'
		});
		
		$('newDimName').focus();
	});
	$('removeDimension').addEvent('click', function() {
		this.highlight();
		
		var to_delete = $$('span.selected');
		if(to_delete) {
			for(i = 0; i < to_delete.length; i++ ) {
				if(!to_delete[i].get('cant_remove'))
					remove(to_delete[i]);				
			}
			$('propertiesDesign').getElements('tbody')[0].empty();
		}
	});
	$('upDimension').addEvent('click', function() {
		this.highlight();
		var to_move = $$('span.selected');
		if(to_move) {			
			for(i = 0; i < to_move.length; i++ ) {
				up(to_move[i]);
			}
		}
	});
		
	$('downDimension').addEvent('click', function() {
		this.highlight();
		var to_move = $$('span.selected');
		if(to_move) {			
			for(i = 0; i < to_move.length; i++ ) {
				down(to_move[i]);
			}
		}
	});
	
	$('acceptAdd').addEvent('click', function() {
		var dimName = $('newDimName').get('value');
		if(dimName) {
			if(isValidDimensionName(dimName)) {
				
				var type = $('newDimType').get('checked') ? 'virtual' : 'normal';
				$('newDimType').erase('checked');
				
				var obj = addDimension(null, dimName, type);
				$('newDimName').set('value', '');
				$('dimDesignContainer').unmask();		
				$('dimDesignAdder').setStyle('display', 'none');
				
				obj.fireEvent('click');
			} else {
				var msg = MSG_INV_NAME.split('<TOK1>');
				showMessage(msg[0] + dimName + msg[1], GNR_TIT_WARNING, 'modalWarning');
			}
		} else {
			var msg = MSG_INV_NAME.split('<TOK1>');
			showMessage(msg[0] + ' ' + msg[1], GNR_TIT_WARNING, 'modalWarning');
		}
	});
	$('newDimName').addEvent('keyup', function(e) {
		if(e.key == 'enter'){
			$('acceptAdd').fireEvent('click');
		}
	});
	$('cancelAdd').addEvent('click', function() {
		$('dimDesignContainer').unmask();		
		$('dimDesignAdder').setStyle('display', 'none');
	});
	
	$(document.body).addEvent('click', function(e) {
		if(!(e.target && e.target.get('tag') == 'span' && e.target.hasClass('selectable') || 
				(e.target && e.target.getParent() && e.target.getParent().hasClass('dimensionDesignBtns')) ||
				(e.target && e.target.getParent('div.dont-unselect')) ||
				(e.target && e.target.hasClass('dont-unselect')))) {
			
			$$('ol.tree span.selectable').removeClass('selected');
			$('propertiesDesign').getElements('tbody')[0].empty();
		}
	})
	
	$('newDimTypeSpan').addEvent('click', function() {
		$('newDimType').set('checked', !$('newDimType').get('checked'));
	});
	
	Generic.setButton($('acceptAdd'));
	Generic.setButton($('cancelAdd'));
});

function getXMLTables() {
	var fields = getColumns().split(',');
	var table_hash = {};
	var tables = new Array();
	
	for(var i = 1; i < fields.length; i++) {
		var tbl = fields[i].split('.')[0];
		var fld = fields[i].split('.')[1];
		if(!table_hash[tbl]) {
			table_hash[tbl] = new Array();
			tables.push(tbl);
		}
		table_hash[tbl].push(fld);
	}
	
	var res = '<tables>';
	for(i = 0; i < tables.length; i++) {
		res += '<table name="' + tables[i] + '">';
		var tbl_fields = table_hash[tables[i]];
		for(var j = 0; j < tbl_fields.length; j++) {
			res += '<field name="' + tbl_fields[j] + '"/>';
		}
		res += '</table>';
	}
	
	res += '</tables>';
	
	return res;
}

function remove(ele) {
	ele.getParent('li').destroy();
}

function up(ele) {
	var prev = ele.getParent('li').getPrevious('li');
	if(prev) {
		ele.getParent('li').inject(prev, 'before');
	}
}

function down(ele) {
	var next = ele.getParent('li').getNext('li');
	if(next) {
		ele.getParent('li').inject(next, 'after');
	}
}

function getDimensionsNames() {
	var res = '';
	$('dimensionDesign').getElements('span.dimension').each(function (span) {
		if(res)	res += ';';
		res += span.get('html');
	});
	return res;
}

function expandHandler() {
	var target = this.getNext('ol.tree');
	
	if(target.get('inTransition'))
		return;
	target.set('inTransition', true);
	
	if(this.hasClass('expanded')) {
		//Colapsar
		this.removeClass('expanded').addClass('collapsed');
		
		var fx = new Fx.Morph(target);
		fx.start({
			opacity: 0
		}).chain(function() {
			target.setStyle('display', 'none');
			target.erase('inTransition');
		});
	} else {
		//Expandir
		this.removeClass('collapsed').addClass('expanded');
		
		var fx = new Fx.Morph(target);
		target.setStyle('display', '');
		fx.start({
			opacity: 1
		}).chain(function() {
			target.erase('inTransition', false);
		});
	}
}

function refreshData() {
	
	var xml_in = getXMLTables();
	
	//Cargar campos fuentes
	//Parsear XML
	var xmlDoc_in;
	if (window.DOMParser) {
		parser = new DOMParser();
		xmlDoc_in = parser.parseFromString(xml_in,"text/xml");
	} else {
		// Internet Explorer
		xmlDoc_in = new ActiveXObject("Microsoft.XMLDOM");
		xmlDoc_in.async = false;
		xmlDoc_in.loadXML(xml_in); 
	}
	
	var tables = xmlDoc_in.childNodes[0].childNodes;
		
	$('messuresDesign').getElement('ol.tree').empty();
	
	for(var i = 0; i < tables.length; i++) {
		addMesure(tables[i]);
	}
	
	//Verificar si los valores de las medidas
	var fields = getColumns().split(',');
	var table_hash = {};
	var tables = new Array();
	
	for(var i = 1; i < fields.length; i++) {
		var tbl = fields[i].split('.')[0];
		var fld = fields[i].split('.')[1];
		if(!table_hash[tbl]) {
			table_hash[tbl] = new Array();
			tables.push(tbl);
		}
		table_hash[tbl].push(fld);
	}
	
	//Recorrer todas las dimensiones, jerarquias y niveles, verificando que las tablas y campos que usa existan
	var dimensions = $('dimensionDesignContainer').getElements('.dimension-tree');
	if(dimensions) {
		for(var i = 0; i < dimensions.length; i++) {
			var dim_xml = dimensions[i].getElement('span.selectable').retrieve('prp_xml');
			
			var prps = dim_xml.childNodes;
			
			if(prps) {
				for(var j = 0; j < prps.length; j++) {
					if(!verifyChange(prps[j], table_hash)) {
						//HAY COSAS QUE NO MAPEAN
						dimensions[i].getElement('span.selectable').getParent('li').addClass('dim-error');
					}
				}
			}
			
			var hierarchies = dimensions[i].getElements('.hierarchy-tree');
			if(hierarchies) {
				for(var i2 = 0; i2 < hierarchies.length; i2++) {
					var hie_xml = hierarchies[i2].getElement('span.selectable').retrieve('prp_xml');
					
					prps = hie_xml.childNodes;
					
					if(prps) {
						for(j = 0; j < prps.length; j++) {
							if(!verifyChange(prps[j], table_hash)) {
								//HAY COSAS QUE NO MAPEAN
								hierarchies[i2].getElement('span.selectable').getParent('li').addClass('dim-error');
							}
						}
					}
					
					var levels = hierarchies[i2].getElements('.level-tree');
					if(levels) {
						for(var i3 = 0; i3 < levels.length; i3++) {
							var lvl_xml = levels[i3].getElement('span.selectable').retrieve('prp_xml');
							
							prps = lvl_xml.childNodes;
							
							if(prps) {
								for(j = 0; j < prps.length; j++) {
									if(!verifyChange(prps[j], table_hash)) {
										//HAY COSAS QUE NO MAPEAN
										levels[i3].getElement('span.selectable').getParent('li').addClass('dim-error');
									} 
								}
							}
						}
					}
				}
			}
		}
	}
}


/**
 * Verifica si existe todavia la tabla o campo al que se hace referencia
 */
function verifyChange(obj, tables) {
	if(obj.getAttribute('useTables') && obj.getAttribute('value')) {
		if(!tables[obj.getAttribute('value').toUpperCase()] && obj.getAttribute('value').toUpperCase().indexOf('[VIEW]') != 0) {
			
			obj.setAttribute('value', '');
			obj.setAttribute('dirty', 'true');
			
			return false;
		}
	} else if(obj.getAttribute('useFields') && obj.getAttribute('value')) {
		var tbl = obj.getAttribute('value').split('.');
		var fld = tbl[1].toUpperCase();
		tbl = tbl[0].toUpperCase();
		if(!tables[tbl]) {
			
			obj.setAttribute('value', '');
			obj.setAttribute('dirty', 'true');
			
			return false;
		} else if (tables[tbl].indexOf(fld) < 0) {
			
			obj.setAttribute('value', '');
			obj.setAttribute('dirty', 'true');
			
			return false;
		}
	}
	return true;
}

/**
 * Agrega una medida a la tabla de medidas
 * @param xml
 */
function addMesure(xml) {
	var tbl_name = xml.getAttribute("name");
	
	var li = new Element('li');
	
	new Element('div.expanded').inject(li).addEvent('click', expandHandler);
	new Element('span', {html: tbl_name}).inject(li);	
	var sub_tree = new Element('ol.tree').inject(li);
	
	var fields = xml.childNodes;
	for(var j = 0; j < fields.length; j++) {
		var fld_name = fields[j].getAttribute("name");
		new Element('span', {html: fld_name}).inject(new Element('li').inject(sub_tree)).addEvent('mousedown', function(e) {
			
			e.stop();
			var f = e.target;
			
			var clone = new Element('span.dragging', {html: f.get('html')}).setStyles(f.getCoordinates()).setStyles({
				position: 'absolute'
			}).inject(document.body);	
			
			var table_field = this.getParent('ol.tree').getPrevious('span').childNodes[0].nodeValue + "." + this.childNodes[0].nodeValue;
			
			var drag = new Drag.Move(clone, {
				droppables: $$('.droppable'),
				onDrop: function(dragging, target) {

					var lvl_name = dragging.get('html');
			        dragging.destroy();

			        if (target != null) {
			          	var parent = target.getElement('ol.tree').getElement('ol.tree');
			          	var lvl = addLevel(null, parent, lvl_name, table_field);
			          	lvl.fireEvent('click');
			        }
			        
			        //End dimensionDesign highlight
			       $$('.droppable').removeClass('dropHighlight');
			    },
			   	onCancel: function(dragging) {
		        	dragging.destroy();
		        	$$('.droppable').removeClass('dropHighlight');
				},
				onEnter: function(dragging, target) {
					target.addClass('dropHighlight');
				},
				onLeave: function(dragging, target) {
					target.removeClass('dropHighlight');
				}
			});
			
		    drag.start(e);
		});
	}
	li.inject($('messuresDesign').getElement('ol.tree'));
}

function addDimension(xml, name, type) {
	
	var dim_name = name;
	var prp_xml;
	
	if(xml)
		dim_name = xml.getAttribute("name");
	if(xml && !type)
		type = xml.getAttribute("innerDimension") == 'true' ? 'virtual' : 'normal';
	if(!type)
		type = "normal";
	
	var all_dims = def_xml.getElementsByTagName('dimension');
	var i = 1;
	prp_xml = all_dims[0];
	while(i < all_dims.length && prp_xml.getAttribute("type") != type) {
		prp_xml = all_dims[i];
		i++;
	}
	if(!prp_xml) {
		
		showMessage(MSG_ERR_LOADING_DIM_DEF, GNR_TIT_WARNING, 'modalWarning');
	}
	prp_xml = def_xml.createElement('properties').appendChild(prp_xml.cloneNode(true));
	/*
	var prp_inputs = prp_xml.getElementsByTagName('input');
	for(var i = 0; i < prp_inputs.length; i++) {
		if(prp_inputs[i].getAttribute('prp') == 'name')
			prp_inputs[i].setAttribute('value', dim_name);
	}
	*/
	var prp_fields = prp_xml.childNodes;
	for(var i = 0; i < prp_fields.length; i++) {
		if(prp_fields[i].getAttribute('prp') == 'name') {
			prp_fields[i].setAttribute('value', dim_name);
		} else if(xml && xml.getAttribute(prp_fields[i].getAttribute('prp'))){
			prp_fields[i].setAttribute('value', xml.getAttribute(prp_fields[i].getAttribute('prp')));
		}
	}
	
	var li = new Element('li.droppable').addClass('dimension-tree');
	new Element('div.expanded').inject(li).addEvent('click', expandHandler);
	
	var span = new Element('span.dimension', {html: dim_name}).addClass('selectable').inject(li).addEvent('click', function() {
		$$('ol.tree span.selectable').removeClass('selected');
		this.addClass('selected');
		loadPrp(this.retrieve('prp_xml'), this);
	}).store('prp_xml', prp_xml);
	
	var sub_tree = new Element('ol.tree').inject(li);
	
	if(xml) {
		var hierarchies = xml.childNodes;
		for(var j = 0; j < hierarchies.length; j++) {
			addHierarchy(hierarchies[j], sub_tree, type);
		}
	} else {
		addHierarchy(null, sub_tree, type, dim_name);
	}
	
	li.inject($('dimensionDesign').getElement('ol.tree'));
	
	return span;
}

function addHierarchy(xml, parent, type, name) {
	
	var hie_name = name;
	var prp_xml;
	
	if(xml)
		hie_name = xml.getAttribute("name");
	
	var all_hie = def_xml.getElementsByTagName('hierarchy');
	var i = 1;
	prp_xml = all_hie[0];
	while(i < all_hie.length && prp_xml.getAttribute("type") != type) {
		prp_xml = all_hie[i];
		i++;
	}
	if(!prp_xml)
		showMessage(MSG_ERR_LOADING_HIER_DEF, GNR_TIT_WARNING, 'modalWarning');
	
	prp_xml = def_xml.createElement('properties').appendChild(prp_xml.cloneNode(true));
	/*
	var prp_inputs = prp_xml.getElementsByTagName('input');
	for(var i = 0; i < prp_inputs.length; i++) {
		if(prp_inputs[i].getAttribute('prp') == 'name')
			prp_inputs[i].setAttribute('value', hie_name);
	}
	*/
	var prp_fields = prp_xml.childNodes;
	for(var i = 0; i < prp_fields.length; i++) {
		if(prp_fields[i].getAttribute('prp') == 'name') {
			prp_fields[i].setAttribute('value', hie_name);
		} else if(xml && xml.getAttribute(prp_fields[i].getAttribute('prp'))){
			prp_fields[i].setAttribute('value', xml.getAttribute(prp_fields[i].getAttribute('prp')));
		}
	}
	
	var li = new Element('li').addClass('hierarchy-tree');
	new Element('div.expanded').inject(li).addEvent('click', expandHandler);
	
	new Element('span.hierarchy', {html: hie_name}).addClass('selectable').inject(li).addEvent('click', function() {
		$$('ol.tree span.selectable').removeClass('selected');
		this.addClass('selected');
		loadPrp(this.retrieve('prp_xml'), this);
	}).set('cant_remove', true).store('prp_xml', prp_xml);
	
	var sub_tree = new Element('ol.tree').inject(li);
	
	if(xml) {
		var levels = xml.childNodes;
		for(var j = 0; j < levels.length; j++) {
			addLevel(levels[j], sub_tree);
		}
	}
	
	li.inject(parent);
}

function addLevel(xml, parent, name, table_field) {
	
	var lvl_name = name;
	if(xml)
		lvl_name = xml.getAttribute("name");
	
	var prp_xml = def_xml.getElementsByTagName('level')[0];
	
	prp_xml = def_xml.createElement('properties').appendChild(prp_xml.cloneNode(true));
	
	
	
	if(!table_field)
		table_field = xml.getAttribute('column').toUpperCase();
	
	
	/*
	var prp_inputs = prp_xml.getElementsByTagName('input');
	
	for(var i = 0; i < prp_inputs.length; i++) {
		if(prp_inputs[i].getAttribute('prp') == 'name')
			prp_inputs[i].setAttribute('value', lvl_name);
		else if(prp_inputs[i].getAttribute('prp') == 'column')
			prp_inputs[i].setAttribute('value', table_field);
	}
	*/
	
	var prp_fields = prp_xml.childNodes;
	for(var i = 0; i < prp_fields.length; i++) {
		if(prp_fields[i].getAttribute('prp') == 'name') {
			prp_fields[i].setAttribute('value', lvl_name);
		} else if(prp_fields[i].getAttribute('prp') == 'column') {
			prp_fields[i].setAttribute('value', table_field);
		} else if(xml && xml.getAttribute(prp_fields[i].getAttribute('prp'))){
			prp_fields[i].setAttribute('value', xml.getAttribute(prp_fields[i].getAttribute('prp')));
		}
	}
	
	var li = new Element('li').addClass('level-tree');
	var span;
	
	if(xml && xml.childNodes && xml.childNodes.length) {

		var levels = xml.childNodes;
		
		new Element('div.expanded').inject(li).addEvent('click', function() {
			//Expandir
			if(this.hasClass('expanded')) {
				//Colapsar
				this.removeClass('expanded').addClass('collapsed');
				this.getNext('ol.tree').setStyle('display', 'none');
			} else {
				//Expandir
				this.removeClass('collapsed').addClass('expanded');
				this.getNext('ol.tree').setStyle('display', 'block');
			}
		});
		
		span = new Element('span.leaf', {html: lvl_name}).addClass('selectable').inject(li).addEvent('click', function() {
			$$('ol.tree span.selectable').removeClass('selected');
			this.addClass('selected');
			loadPrp(this.retrieve('prp_xml'), this);
		}).store('prp_xml', prp_xml);
		
		var sub_tree = new Element('ol.tree').inject(li);
		
		for(var j = 0; j < levels.length; j++) {
			addLevel(levels[j], sub_tree);
		}
	} else {
		span = new Element('span.leaf', {html: lvl_name}).addClass('selectable').inject(li).addEvent('click', function() {
			$$('ol.tree span.selectable').removeClass('selected');
			this.addClass('selected');
			loadPrp(this.retrieve('prp_xml'), this);
		}).store('prp_xml', prp_xml);
	}
	
	li.inject(parent);
	
	return span;
}

/**
 * Cargado de propiedades de dimensiones/jeraruias/niveles
 */
function loadPrp(xml, parent) {
	var tbody = $('propertiesDesign').getElements('tbody')[0];
	tbody.empty();
	
	var prps = xml.childNodes;
	for(var i = 0; i < prps.length; i++) {
		var tr = new Element('tr');
		if(prps[i].tagName == 'input') {
			new Element('span', {html: prps[i].getAttribute("name")}).inject(new Element('td.first-col').inject(tr));
			var input = new Element('input', {
				type: 'text',
				prp_id: prps[i].getAttribute("prp"),
				value: prps[i].getAttribute("value")
			}).inject(new Element('td').inject(tr)).addEvent('change', function() {
				var prp_xml = parent.retrieve('prp_xml');
				var all_inputs = prp_xml.getElementsByTagName('input');
				var i = 0;
				while(all_inputs[i] && all_inputs[i].getAttribute('prp') != this.get('prp_id')) {
					i++;
				}
				if(all_inputs[i]) {
					
					if(this.get('prp_id') == 'name')
						parent.childNodes[0].nodeValue = this.get('value');
					
					all_inputs[i].setAttribute('value', this.get('value'));
					all_inputs[i].removeAttribute('dirty');
					
					if(!checkIfParentIsDirty(prp_xml))
						parent.getParent('li').removeClass('dim-error');
				}
			});
			
			if(prps[i].getAttribute("prp") == 'name') {
				input.addEvent('blur', function() {
					if(!isValidDimensionName(this.get('value'))) {
						var msg = MSG_INV_NAME.split('<TOK1>');
						showMessage(msg[0] + this.get('value') + msg[1], GNR_TIT_WARNING, 'modalWarning');
						this.focus();
						this.select();
					}
				});
			}
			if(prps[i].getAttribute("prp") == 'column')
				input.set('disabled', true);
		} else if(prps[i].tagName == 'combo') {
			new Element('span', {html: prps[i].getAttribute("name")}).inject(new Element('td.first-col').inject(tr));
			var select = new Element('select', {
				type: 'text',
				prp_id: prps[i].getAttribute("prp")
			}).inject(new Element('td').inject(tr));
						
			if(prps[i].childNodes && prps[i].childNodes.length) {
				var options = prps[i].childNodes[0].nodeValue.split(',');
				for(var j = 0; j < options.length; j++) {
					var o = new Element('option', {html: options[j]}).inject(select);
					
					if(options[j] == prps[i].getAttribute('value'))
						o.set('selected', true);
				}
			} else if (prps[i].getAttribute('func')){
				var f_str = prps[i].getAttribute('func');
				if(f_str) {
					var f = window[f_str];
					if(f) {
						var res_options = f();
						
						if(prps[i].getAttribute('prp') == 'table') {
							res_options = res_options != '' ? res_options + ',[VIEW]' : '[VIEW]';
							
							select.addEvent('change', function(e) {
								//Mostrar, quitar el input y boton en caso de que no se seleccione la vista
								if(e.target.get('value') == '[VIEW]') {
									
									var input = new Element('input.view-input').addEvent('change', function() {
										var prp_xml = parent.retrieve('prp_xml');
										var all_combos = prp_xml.getElementsByTagName('combo');
										var i = 0;
										while(all_combos[i] && all_combos[i].getAttribute('prp') != 'table') {
											i++;
										}
										if(all_combos[i]) {
											all_combos[i].setAttribute('value', '[VIEW];' + this.get('value'));
										}
									});
									
									Generic.setButton(new Element('div.view-button', {html: 'Test'}).inject(select, 'after')).addEvent('click', function(e) {
										testSQLFromDimensions(input.get('value'));
									});
									
									input.inject(select, 'after');
									
									new Element('br').inject(select, 'after');
									
								} else {
									if(select.getParent().getElement('div.view-button'))
										select.getParent().getElement('div.view-button').destroy();
									if(select.getParent().getElement('input.view-input'))
										select.getParent().getElement('input.view-input').destroy();
									if(select.getParent().getElement('br'))
										select.getParent().getElement('br').destroy();
								}
							});
						}
						
						var res_options = res_options.split(',');
						for(var j = 0; j < res_options.length; j++) {
							var o = new Element('option', {html: res_options[j]}).inject(select);
							
							if(res_options[j] == prps[i].getAttribute('value') || (
									prps[i].getAttribute('value') != null && res_options[j] == prps[i].getAttribute('value').toUpperCase())) {
								o.set('selected', true);
							} else if(res_options[j] == '[VIEW]' && prps[i].getAttribute('value') && prps[i].getAttribute('value').indexOf('[VIEW]') >= 0) {
								o.set('selected', true);
								
								var value = prps[i].getAttribute('value').substring(7);
								
								var input = new Element('input.view-input', {value: value}).addEvent('change', function() {
									var prp_xml = parent.retrieve('prp_xml');
									var all_combos = prp_xml.getElementsByTagName('combo');
									var i = 0;
									while(all_combos[i] && all_combos[i].getAttribute('prp') != 'table') {
										i++;
									}
									if(all_combos[i]) {
										all_combos[i].setAttribute('value', '[VIEW];' + this.get('value'));
									}
								});
								
								Generic.setButton(new Element('div.view-button', {html: 'Test'}).inject(select, 'after')).addEvent('click', function(e) {
									testSQLFromDimensions(input.get('value'));
								});
								
								input.inject(select, 'after');
								
								new Element('br').inject(select, 'after');
							}
						}
					}
				}	
			}
			
			select.addEvent('change', function() {
				var prp_xml = parent.retrieve('prp_xml');
				var all_combos = prp_xml.getElementsByTagName('combo');
				var i = 0;
				while(all_combos[i] && all_combos[i].getAttribute('prp') != this.get('prp_id')) {
					i++;
				}
				if(all_combos[i]) {
					if(this.get('prp_id') == 'table' && this.get('value') == '[VIEW]')
						all_combos[i].setAttribute('value', '[VIEW];');
					else 
						all_combos[i].setAttribute('value', this.get('value'));
					
					all_combos[i].removeAttribute('dirty');
					
					if(!checkIfParentIsDirty(prp_xml))
						parent.getParent('li').removeClass('dim-error');
				}
			});
		}
		tr.inject(tbody);
	}
}

/**
 * Verifica si un elemento tiene propiedades dirty. En caso de que no se le intenta sacar la clase de error
 */
function checkIfParentIsDirty(xml) {
	var prps = xml.childNodes;
	for(var i = 0; i < prps.length; i++) {
		if(prps[i].getAttribute('dirty'))
			return true;
	}
	return false;
}

/**
 * Retorna el xml del diseño de dimensiones.
 */
function getXML() {
	var res = '<?xml version="1.0" encoding="ISO-8859-1"?><dimensions>';
	
	var dimensions = $('dimensionDesignContainer').getElements('.dimension-tree');
	if(dimensions) {
		for(var i = 0; i < dimensions.length; i++) {
			var dim_xml = dimensions[i].getElement('span.selectable').retrieve('prp_xml');
			
			var prps = dim_xml.childNodes;
			res += '<dimension ';
			if(prps) {
				for(var j = 0; j < prps.length; j++) {
					if(prps[j].tagName == 'combo' && prps[j].getAttribute('value') == null && 
							prps[j].childNodes && prps[j].childNodes.length) {
						
						var options = prps[j].childNodes[0].nodeValue.split(',');							
						res += prps[j].getAttribute('prp') + '="' + options[0] + '" ';
					} else {
						res += prps[j].getAttribute('prp') + '="' + (prps[j].getAttribute('value') != null ? prps[j].getAttribute('value') : '') + '" ';
					}
				}
			}
			res += '>';
			
			var hierarchies = dimensions[i].getElements('.hierarchy-tree');
			if(hierarchies) {
				for(var i2 = 0; i2 < hierarchies.length; i2++) {
					var hie_xml = hierarchies[i2].getElement('span.selectable').retrieve('prp_xml');
					
					prps = hie_xml.childNodes;
					res += '<hierarchy ';
					if(prps) {
						for(j = 0; j < prps.length; j++) {
							res += prps[j].getAttribute('prp') + '="' + (prps[j].getAttribute('value') != null ? prps[j].getAttribute('value') : '') + '" '; 
						}
					}
					res += '>';
					
					var levels = hierarchies[i2].getElements('.level-tree');
					if(levels) {
						for(var i3 = 0; i3 < levels.length; i3++) {
							var lvl_xml = levels[i3].getElement('span.selectable').retrieve('prp_xml');
							
							prps = lvl_xml.childNodes;
							res += '<level ';
							if(prps) {
								for(j = 0; j < prps.length; j++) {
									res += prps[j].getAttribute('prp') + '="' + (prps[j].getAttribute('value') != null ? prps[j].getAttribute('value') : '') + '" '; 
								}
							}
							res += '/>';
						}
					}
					res += '</hierarchy>';
				}
			}
			res += '</dimension>';
		}
	}
	return res + '</dimensions>';
}

function testSQLFromDimensions(sql) {
	var dbConId = $('selConn').value; //Conexión seleccionada en este momento
	extra = {'sql':sql, 'dbConId': dbConId, 'onConfirm':false, 'afterAction':''};
	
	var request = new Request({
		method: 'post',			
		data:extra,
		url: CONTEXT + URL_REQUEST_AJAX+'?action=sqlTest&isAjax=true' + TAB_ID_REQUEST,
		onComplete: function(resText, resXml) {
			modalProcessXml(resXml);  
			
		}
	}).send();
}