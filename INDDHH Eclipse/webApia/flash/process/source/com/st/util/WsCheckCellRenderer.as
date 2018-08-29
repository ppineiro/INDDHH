import mx.core.UIComponent;
import mx.controls.CheckBox;

class com.st.util.WsCheckCellRenderer extends UIComponent{

 	var owner; 				// The row that contains this cell
	var listOwner; 			// the List/grid/tree that contains this cell
	var getCellIndex:Function; 	// the function we receive from the list
	var	getDataLabel:Function; 	// the function we receive from the list
	
	var firstSizeCompleted:Boolean;	// for mysterious initialization	
	
	var checkMC;

	function WsCheckCellRenderer(){
	}

	function createChildren(Void) : Void{
		checkMC=createClassObject(CheckBox,"check",0);
		checkMC.addEventListener("click", this);
		checkMC._visible=false;
		firstSizeCompleted = false;
	}

	// note that setSize is implemented by UIComponent and calls size(), after setting
	// __width and __height
	function size(Void) : Void{
		var w = __width;
		var h = __height;
		
		if (checkMC != undefined) {
			//checkMC._x = (w - checkMC._width) / 2;
			checkMC._x =2;
			// Mysterious initialisation
			if (!firstSizeCompleted) {
				checkMC._y = 0;
			}
			firstSizeCompleted = true;
		}
	}

	public function setValue(str:String, item:Object, sel:String){
		if(item){
			checkMC._visible=true;
			checkMC.selected=item[getDataLabel()];
		}else{
			checkMC._visible=false;
		}
	}
	
	public function getValue(){
		return checkMC.selected;
	}

	function getPreferredHeight(Void) : Number{
	 	return owner.__height;
	}
	
	function click(){
		var field=(getDataLabel()=="multivalued")?"uk":"multivalued"
		if(!checkMC.selected){
			listOwner.dataProvider.editField(this.getCellIndex().itemIndex, getDataLabel(), null);
		}else{
			listOwner.dataProvider.editField(this.getCellIndex().itemIndex, field, null);
			listOwner.dataProvider.editField(this.getCellIndex().itemIndex, getDataLabel(), true);
		}
	}

}

