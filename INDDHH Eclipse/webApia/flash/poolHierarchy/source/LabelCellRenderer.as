import mx.core.UIComponent;
class LabelCellRenderer extends UIComponent {
	var label:MovieClip;
	var valor:String="";
	var estilo:String="";
	var id:String="";
	var listOwner:Object;
	function LabelCellRenderer() {
		/* do nothing */
	}
	function createChildren(Void):Void {
		label = createObject("Label", "label", 1, {styleName:this, owner:this});		
		label.html = true;
		size();
	}
	// setSize is implemented by UIComponent and calls size(), after setting
	// __width and __height
	function size(Void):Void {
		label.setSize(__width, __height);
		// make sure the label field is in the top-left corner 
		// of the row
		label._x = 0;
		label._y = 0;
	}
	function setValue(str:String, item:Object, sel:Boolean):Void {
		fscommand("largalo2",this);
		valor=str;
		id=item.attributes.id;
		estilo=item.attributes.style+"";
		// hide the label if no data to display
		label._visible = (item != undefined);
		// this line actually sets htmlText 

		if(estilo=="B"){
			str="<b>"+str+"</b>";
		}
		
		if(estilo=="I"){
			str="<i>"+str+"</i>";
		}
		label.text = str;
	}
	
	function getPreferredHeight(Void):Number {
		// this is the height with the default font, you might
		// need to adjust this to suit your needs
		return 18;
	}
	
	function getPreferredWidth(Void):Number {
		// default to the width of the listbox
		return __width;
	}
	

}
