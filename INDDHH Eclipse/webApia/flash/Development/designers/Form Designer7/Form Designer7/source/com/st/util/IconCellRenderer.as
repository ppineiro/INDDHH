//****************************************************************************
// Icon Cell Renderer
// by PhilFlash - http://philflash.inway.fr
//
// version 1.1 : 22 Jan 2004
//   - suppression de la gestion du visible si la taille était trop petite
//   - ajout d'un flag firstSizeCompleted lors du premier affichage
//     pour corriger la position des icones
// version 1.0 : 22 Oct 2003
//   - version initiale
//****************************************************************************

import mx.core.UIComponent

class com.st.util.IconCellRenderer extends UIComponent{

	var icon_mc:MovieClip;

 	var owner; 				// The row that contains this cell
	var listOwner; 			// the List/grid/tree that contains this cell
	var getCellIndex:Function; 	// the function we receive from the list
	var	getDataLabel:Function; 	// the function we receive from the list
	
	var firstSizeCompleted:Boolean;	// for mysterious initialization	

	function IconCellRenderer()
	{
	}

	function createChildren(Void) : Void
	{
		firstSizeCompleted = false;
	}

	// note that setSize is implemented by UIComponent and calls size(), after setting
	// __width and __height
	function size(Void) : Void
	{
		var w = __width;
		var h = __height;
		
		if (icon_mc != undefined) {
			icon_mc._x = (w - icon_mc._width) / 2;
			// Mysterious initialisation
			if (!firstSizeCompleted) {
				icon_mc._y = 0;
			}
			firstSizeCompleted = true;
		}
	}

	function setValue(str:String, item:Object, sel:Boolean) : Void
	{
		var w = __width;
		var h = __height;
		// We're on an empty row
		if (item == undefined) {
			if (icon_mc != undefined) {
				icon_mc.removeMovieClip();
				delete icon_mc;
			}
			return;
		}
		
		
		if (icon_mc != undefined) {
			icon_mc.removeMovieClip();
		}
		// Attention au tri, il faut recalculer l'icone
		var columnIndex = this["columnIndex"]; // private property (no access function)
		var columnName = listOwner.getColumnAt(columnIndex).columnName;
		var iconFunction : Function = listOwner.getColumnAt(columnIndex).iconFunction;
		if (iconFunction != undefined) {
			var icon = iconFunction(item, columnName);
			if (icon!=undefined) {
				icon_mc = createObject(icon, "icon_mc", 20);
				icon_mc._x = (w - icon_mc._width)/2;
				if (!firstSizeCompleted) {
					icon_mc._y = (0 - icon_mc._height) / 2;
				} else {
					icon_mc._y = 0;
				}
			}
		}
	}

	function getPreferredHeight(Void) : Number
	{
	 	return owner.__height;
	}

}

