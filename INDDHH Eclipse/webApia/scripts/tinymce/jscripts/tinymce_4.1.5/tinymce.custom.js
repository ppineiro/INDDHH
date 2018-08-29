/*
 * JS para diseñar componentes personalizados para editor de texto
 */

var addCustomFontSizeSelect = function(ed){
	ed.addButton('custom_fontsizeselect', function() {
		var items = [], defaultFontsizeFormats = '8pt 10pt 12pt 14pt 18pt 24pt 36pt';
		var fontsize_formats = ed.settings.fontsize_formats || defaultFontsizeFormats;

		fontsize_formats.split(' ').each(function(item) {
			var text = item, value = item;
			// Allow text=value font sizes.
			var values = item.split('=');
			if (values.length > 1) {
				text = values[0];
				value = values[1];
			}
			items.push({text: text, value: value});
		});

		return {
			type: 'listbox',
			text: 'Font Sizes',
			tooltip: 'Font Sizes',
			'classes': 'widget btn fixed-width-40', 
			values: items,
			fixedWidth: true,
			onPostRender: createFontSizeListBoxChangeHandler(ed,items),
			onclick: function(e) {
				if (e.control.settings.value) {
					ed.execCommand('FontSize', false, e.control.settings.value);
				}
			}
		};
	});
}


function getElementStyle(rootElm, elm, propName){
	while (elm !== rootElm) {
		if (elm.style[propName]) {
			return elm.style[propName];
		}
		elm = elm.parentNode;
	}
}
function createFontSizeListBoxChangeHandler(editor, items) {
	return function() {
		var self = this;

		editor.on('nodeChange', function(e) {
			if(e.element.nodeName == "#comment") return;
			var value = null, defaultValue = items[0].value;
			var currentSize = getElementStyle(editor.getBody(), e.element, "fontSize");

			items.each(function(item) {
				if (item.value === currentSize) {
					value = currentSize;
				}
			});

			self.value(value);

			if (!value) {
				self.text(defaultValue);
			}
		});
	};
}
