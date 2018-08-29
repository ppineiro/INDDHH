
//****************************************************************************
//	renders a combo or input in a datagrid cell
//
//
//****************************************************************************

import com.st.util.WindowManager;
import mx.core.UIComponent;
import mx.controls.CheckBox;
import mx.controls.TextInput;
import mx.controls.ComboBox;
import mx.controls.Label;
//import mx.controls.*;


class com.st.formDesigner.view.propertyValueCell extends UIComponent{
	
	var check:MovieClip;
	var inputText:MovieClip;
	var modalText:MovieClip;
	
	var combo:ComboBox;
	var comboLabel:Label;
	var modal:MovieClip;
	var alignPicker:MovieClip;

	var src:Number;
	var listOwner : MovieClip; // the reference we receive to the list
	var getCellIndex : Function; // the function we receive from the list
	var	getDataLabel : Function; // the function we receive from the list
	var cellType:Number;
	
	var selectedItem : Object;
  	static var dataProvider;

	
	function propertyValueCell(){
	}

	function createChildren(Void) : Void{
		var tmp=this;
		check = createObject("CheckBox", "check", 1, {styleName:this, owner:this});
		check.addEventListener("click", this);
		
		//---------
		var styleObj : Object = {styleName : this, owner : this}; 
      	inputText = createObject ("TextInput", "InputText", 2, styleObj ); 
      	inputText._visible = false; 
		inputText.addEventListener("change", this);
		//inputText.addEventListener("enter", this);
		//--------
		
		//-----------------------
		//combo
		//-----------------------
		createClassObject( Label, "comboLabel", 3, { styleName:this, owner:this } );
		createClassObject( ComboBox, "combo", 4, { styleName:this, owner:this, selectable:true, editable:false } );
		combo.addEventListener( "change", this );
		//combo.addEventListener( "enter", this );
		//combo.dataProvider = ComboBoxCellRenderer.dataProvider;
		
		propertyValueCell.dataProvider = [ "image400", "imageLogo2", "imageSelected", "logo Vertical", "noImage" ];
		combo.dataProvider = propertyValueCell.dataProvider;
		combo.setStyle( "backgroundColor", getStyle( "selectionColor" ) );

		//-----------------------
		//modal opener
		//-----------------------
		modal=attachMovie("modalShow","mdshow",5,{styleName:this, owner:this});
		modalText=modal.Prop_txt;
		var tmp=this;
		modal.addEventListener( "change", this );
		modal._visible=false;
		size();
		
		//----------------
		//align picker
		//-----------------
		alignPicker=attachMovie("align_picker","apicker",6,{styleName:this, owner:this});
		
	}

	// note that setSize is implemented by UIComponent and calls size(), after setting
	// __width and __height
	function size(Void) : Void{
		trace("size");
		//check
		check.setSize(20, __height);
		check._x = (__width-20)/2;
		//check._y = (__height-16)/2;
		check._y = (__height-10)/2;
		
		//input
		inputText.setSize(120, __height);
		//inputText._x = (__width-130)/2;
		inputText._x = 0;
		inputText._y = (__height-18)/2;
		
		//combo
		combo.setSize(__width-10 , 20 );
		//combo._y -= 1;
		
		//combo label
		comboLabel.setSize(__width, 20 );
		//comboLabel._y -= 1;
	
	}
	
	function refreshCell(){
		inputText._x = 0;
		if(cellType==5){
			modal.Show_btn.icon="color_ico";
		}
	}

	function setValue(str:String, item:Object, sel:String) : Void{
//		trace("largalo "+(str+" "+item+" "+sel));
		inputText._x=5;
		src=item.prp_id;
		cellType=item.cell_type;
		if (item == undefined ){
			modal._visible=false;
			comboLabel._visible = false;
			combo._visible = false;
			inputText._visible = false;
			check._visible = false;
			alignPicker._visible = false;
		  	return;
		}
		//trace(item.prp_type)
		if(item.cell_type==1){								//type = checkbox
			modal._visible=false;
			alignPicker._visible = false;
			check._visible = (item!=undefined);
			var val:Boolean=((item[getDataLabel()]+"")=="true" || (item[getDataLabel()]+"").toUpperCase()=="T");
			check.selected = val;
			
			inputText._visible = false;
			combo._visible = false;
			comboLabel._visible = false;
			
		}else if(item.cell_type==2){						//type = input
			modal._visible=false;
			alignPicker._visible = false;
			inputText._visible = (item!=undefined);
			inputText.maxChars  = item.input_maxlength;
			//trace("STR_LEN :" + str.length)
			inputText.text = str;
			if(item.prp_type=="N"){
				inputText.restrict = "0-9";
			}else{
				inputText.restrict = null;
			}
			check._visible = false;
			combo._visible = false;
			comboLabel._visible = false;

		}else if(item.cell_type==3){						//type = combobox
			modal._visible=false;
			alignPicker._visible = false;
			inputText._visible = false;
			check._visible = false;
			
			if ( sel == "normal" || sel == "highlighted" ){
				comboLabel.text = item[ getDataLabel() ];
				combo._visible = false;
				comboLabel._visible = true;
				
			}else if ( sel == "selected" ){
				selectedItem = item;
			 
				for( var i = 0; i < combo.dataProvider.length; i++ ){
					if( combo.dataProvider[i] == item[ getDataLabel() ] ){
						combo.selectedIndex = i;
						break;
					}
				}
			 	comboLabel._visible = false;
			 	combo._visible = true;
			 	combo.setFocus( false );
			}

		}else if(item.cell_type==4){
			inputText._visible = false;
			alignPicker._visible = false;
			combo._visible = false;
			comboLabel._visible = false;
			check._visible=false;
			modal._visible=true;
			modal.Prop_txt._width=110;
			modal.Prop_txt.text="";
			modal.Prop_txt.text=str;
			modal.Show_btn.icon="search_ico"
			var tmp=this;
			modal.Show_btn.onRelease=function(){
				tmp.showCodeModal(tmp.src,tmp.modal);
			}
		}else if(item.cell_type==5){
			inputText._visible = false;
			alignPicker._visible = false;
			combo._visible = false;
			comboLabel._visible = false;
			check._visible=false;
			modal._visible=true;
			modal.Prop_txt.text="";
			modal.Prop_txt.text=str;
			modal.Show_btn.icon="color_ico";
			modal.Prop_txt._width=70;
			var col:Color=new Color(modal.colorPicked);
			if(modal.Prop_txt.text!=""){
				var colAux="0x"+str.substring(1);
				col.setRGB(colAux);
			}else{
				var colAux="0xFFFFFF";
				col.setRGB(colAux);
			}
			var tmp=this;
			modal.Show_btn.onRelease=function(){
				tmp.showColorModal(tmp.src,tmp.modal);
			}
		}else if(item.cell_type==6){
			alignPicker._visible = true;
			modal._visible=false;
			inputText._visible = false;
			combo._visible = false;
			comboLabel._visible = false;
			check._visible=false;
			inputText.text=str;
			alignPicker["center"].icon="align_center_ico";
			alignPicker["right"].icon="align_right_ico";
			alignPicker["left"].icon="align_left_ico";
			if(str=="center" || str=="right"){
				alignPicker[str].icon="align_"+str+"Sel_ico"
			}else{
				alignPicker["left"].icon="align_leftSel_ico"
			}
		}
		refreshCell();
	}

	function getPreferredHeight(Void) : Number{
		//return 16;
		//if(this.cell_type==3){
			//return 20;
		//}else{
			return 22;
		//}
	}

	function getPreferredWidth(Void) : Number{
		//return 20;
		return 24;
	}

	function click(){
		listOwner.dataProvider.editField(getCellIndex().itemIndex, getDataLabel(), check.selected);
	};
	
	function change(evt){
		if(inputText._visible==true){
			listOwner.dataProvider.editField(getCellIndex().itemIndex, getDataLabel(), inputText.text);
		}else{
			listOwner.dataProvider.editField(getCellIndex().itemIndex, getDataLabel(), this.modal.Prop_txt.text);
		}if(alignPicker._visible==true){
			listOwner.dataProvider.editField(getCellIndex().itemIndex, getDataLabel(), evt.value);
		}
		selectedItem[ getDataLabel() ] = combo.selectedItem;		
	};
	
	function enter(){
		if ( combo.text != undefined && combo.text.length > 0 ){ 
			dataProvider.addItem( combo.text );
			selectedItem[ getDataLabel() ] = combo.text;
			//EventBroadcaster.getInstance().broadcastEvent( "updateItem", selectedItem );
		}
	} 
	
	function showCodeModal(src:String){
		this._parent._parent._parent._parent._parent.showCodeModal(src,modal);		
	}
	function showColorModal(src:String){
		this._parent._parent._parent._parent._parent.showColorModal(src,modal,modal.Prop_txt.text);
	}
}
