

import mx.controls.List;
import mx.controls.TextInput;
import mx.controls.Button;
import mx.controls.DataGrid;
import mx.controls.gridclasses.DataGridColumn;
import mx.controls.gridclasses.DataGridRow;
import mx.managers.PopUpManager;
import mx.containers.Window;

import com.st.util.WindowManager;
import com.qlod.LoaderClass;

import com.st.util.ToolTipClass;


class com.st.process.view.dialogs.PoolModal extends MovieClip{
	
	var xmlLoad_lc:MovieClip;
		
	var XML_POOLS:String;
	var pool_txt:TextInput;
	var findPool_btn:Button
	var pool_list:List;
	var pool_dg:DataGrid
	var delPool_btn:Button;
	var addPool_btn:Button;
	var confirm_btn:Button;
	var cancel_btn:Button;
	var cnd_btn:Button;
	
	var addNewPool_btn:Button;
	
	var pool_array:Array;
	var oLoader:LoaderClass;
	
	private var toolTip:com.st.util.ToolTipClass;
	var t;

	function PoolModal(Void){
		toolTip = new com.st.util.ToolTipClass(_root);
		XML_POOLS = _global.XML_POOLS_URL;
		mx.events.EventDispatcher.initialize(this);
		var thisModal = this;
		oLoader = new LoaderClass();

		pool_array = thisModal._parent.pool_array;
		
		this.confirm_btn.onPress = function() {
			var pool_dg = thisModal.pool_dg;
			var p_Array:Array = thisModal.getDataFromGrid(pool_dg);
			thisModal._parent.dispatchEvent({type:"ok",pools:p_Array});
	
		};
		
		this.cancel_btn.onPress = function() {
			thisModal._parent.dispatchEvent({type:"click"});
		};
		
		this.addPool_btn.onPress = function(){
			var pool_list = thisModal.pool_list;
			var pool_dg = thisModal.pool_dg;
			
			if(thisModal.checkRepeat(pool_list,pool_dg)){
				pool_dg.dataProvider.addItemAt(0, {pool_id:pool_list.selectedItem.data,
												 condition:null,
												 conditionDoc:null,
												 pool_name:pool_list.selectedItem.label});
			}
			
		};
		this.delPool_btn.onPress = function(){
			var selIndex = thisModal.pool_dg.selectedIndex;
			if(selIndex!=null){
				thisModal.removeFromGrid(thisModal.pool_dg,selIndex);
			}
		};
		
		this.findPool_btn.onPress = function(){
			thisModal.getPoolsXML(thisModal.pool_list,thisModal.pool_txt);
		};
		
		//ADD CONDITION
		this.cnd_btn.onPress = function(){
			var x=this._x;
			var y=this._y;
			var selectedIndex = thisModal.pool_dg.getSelectedIndex();
			if(selectedIndex!=null){
				//----------------------------------
				//SHOW CONDITION MODAL
				//----------------------------------
				var itemSelected = thisModal.pool_dg.getItemAt(selectedIndex);
				var cndText:String = itemSelected.condition;
				var cndDocText:String = itemSelected.conditionDoc;
				
				var configOBj = new Object();
					configOBj.closeButton = true;
					configOBj.contentPath = "ConditionModal";
					configOBj.title = _global.labelVars.lbl_ConditionModalTitle.toUpperCase();
					configOBj._width = 460;
					configOBj._height = 290;
					configOBj.conditionValue = cndText;
					configOBj.conditionDocValue = cndDocText;
				
				var objEvt = new Object();
					objEvt.ok = function(evt:Object){
						itemSelected.condition = evt.conditionValue;
						itemSelected.conditionDoc = evt.conditionDocValue;
						//hack to redraw icon cell!!!!
						thisModal.pool_dg.dataProvider = thisModal.pool_dg.dataProvider;
						popUp.deletePopUp();
					}
					objEvt.click = function(evt:Object):Void{
						trace("CANCEL CONDITION MODAL")
						popUp.deletePopUp();
					}
				
				var popUp = WindowManager.popUp(configOBj,this);
					popUp.addEventListener("ok", objEvt);
					popUp.addEventListener("click", objEvt);
				
				/*	OLD POPUP METHOD
				var _mWidth = 460;
				var _mHeight = 290;
				var _mX = Math.floor((Stage.width - _mWidth)/2);
				var _mY = Math.floor((Stage.height - _mHeight)/2);
				
				var itemSelected = thisModal.pool_dg.getItemAt(selectedIndex);
				var cndText:String = itemSelected.condition;
				
				var cndDialog = PopUpManager.createPopUp(this,Window,true,{closeButton:true,
						contentPath:"ConditionModal",
						conditionValue:cndText,
						title:_global.labelVars.lbl_ConditionModalTitle.toUpperCase(),
						_width:_mWidth, _height:_mHeight, _x:_mX, _y:_mY, fontSize:10});
				
				var windowListener = new Object();
					windowListener.click =function(evt){
						cndDialog.deletePopUp();
					}
					windowListener.ok =function(evt){
						itemSelected.condition = evt.conditionValue;
						cndDialog.deletePopUp();
						//hack to redraw icon cell!!!!
						thisModal.pool_dg.dataProvider = thisModal.pool_dg.dataProvider;
						//---------------------------
					}
				
				cndDialog.addEventListener("click",windowListener);
				cndDialog.addEventListener("ok",windowListener);
				*/
			}
			this._x=x;
			this._y=y;
				
		};
		
		this.addNewPool_btn.onPress = function(){
			var x = new XML();
			x.ignoreWhite = true;
			var tmp=thisModal;
			x.onLoad=function(){
				tmp.getPoolsXML(tmp.pool_list,tmp.pool_txt);
			}
			var name=thisModal.pool_txt.text;
			if(name!=""){
				var url=_global.PROCESS_ACTION+"addNewGroup";
				x.load(url+"&name="+name);
			}
		}
		
	};
	
	
	function onLoad(){
		xmlLoad_lc._visible=false;
		xmlLoad_lc.message=_global.labelVars.lbl_Loader;
		var thisModal = this;
		
		//SET BTN LABELS
		confirm_btn.label = _global.labelVars.lbl_btnConfirm;
		cancel_btn.label = _global.labelVars.lblbtnCancel;
		
		
		//RENDER COLUMNS
		var column = new DataGridColumn("cndIcon");
			column.headerText = "";
			column.width = 30;
			column.cellRenderer = "IconCellRenderer";
			column["iconFunction"] = getIcon;
		pool_dg.addColumn(column);
		
		var column = new DataGridColumn("pool_name");
			column.headerText = "Name";
			column.width = 220;
		pool_dg.addColumn(column);
		
	
		//INIT GRID
		var pool_DP = new Array();
		for(var d=0; d < pool_array.length; d++){
			pool_DP.addItem({pool_id:pool_array[d].pool_id,
							 condition:pool_array[d].condition,
							 conditionDoc:pool_array[d].conditionDoc,
							pool_name:pool_array[d].pool_name});
		}
		pool_dg.dataProvider = pool_DP;
		
		var tmp=this;
		var listener:Object=new Object();
		listener.itemRollOver=function(eventObj){
			var index:Number=eventObj.index;
			var dp=eventObj.target.dataProvider;
			var aux=dp.getItemAt(index);
			tmp.showToolTip(aux.pool_name);
		}
		listener.itemRollOut=function(eventObj){
			tmp.hideToolTip();
		}
		var list_listener:Object=new Object();
		list_listener.itemRollOver=function(eventObj){
			var index:Number=eventObj.index;
			var dp=eventObj.target.dataProvider;
			var aux=dp.getItemAt(index);
			tmp.showToolTip(aux.label);
		}
		list_listener.itemRollOut=function(eventObj){
			tmp.hideToolTip();
		}
				
		pool_dg.addEventListener("itemRollOver",listener);
		pool_dg.addEventListener("itemRollOut",listener);
		pool_list.addEventListener("itemRollOver",list_listener);
		pool_list.addEventListener("itemRollOut",list_listener);
		
	};
	
	function showToolTip(p_txt:String){
		toolTip.setText(p_txt + " ");
	}
		
	function hideToolTip(){
		toolTip.clearText();
	}

	
	function getIcon(itemObj:Object, columnName:String){
		if (itemObj.condition!=null && itemObj.condition!=undefined && itemObj.condition!=""){ 
			return "groupConditionIcon";
		}else{
			return;
		}
	};
	
	
	function getPoolsXML(objList:List,objText:TextInput){
		var tmp=this;
		var x = new XML();
			x.ignoreWhite = true;
		var loaderListener = new Object();
			loaderListener.onLoadStart = function(){};
			loaderListener.onLoadProgress = function(loaderObj){};
			loaderListener.onTimeout = function(loaderObj){};
			loaderListener.onLoadComplete = function(success,loaderObj){
				//trace("onLoadComplete" + loaderObj.getTargetObj().toString());
				var x = loaderObj.getTargetObj();
				if(_global.isXMLexception(x)==true){
				}else{
				
					objList.removeAll();
					for (var e=0;e < x.firstChild.childNodes.length;e++) {
						var col_id = x.firstChild.childNodes[e].childNodes[0].firstChild.nodeValue;
						var col_name = x.firstChild.childNodes[e].childNodes[1].firstChild.nodeValue;
						
						objList.addItem(col_name,col_id);
					}
				}
			tmp.xmlLoad_lc._visible=false;
			};
			
		var auxURL:String; 
		if(_global.DEBUG_IN_IDE){
			auxURL = XML_POOLS;
		}else{
			auxURL = XML_POOLS + "&name=" + pool_txt.text;
		}
		xmlLoad_lc._visible=true;
		oLoader.load(x,auxURL,loaderListener);
	};
	
	function removeFromGrid(oDg:DataGrid,oRowSelected:Number){
		oDg.dataProvider.removeItemAt(oRowSelected);
	};
	
	function checkRepeat(objList:List,objGrid:DataGrid){
		if(objList.selectedItem){
			var isRepeated = false;
			for(var w=0; w < objGrid.dataProvider.length; w++){
				if(objList.selectedItem.data == objGrid.dataProvider[w].pool_id){
					isRepeated = true;
					return false;
				}
			}
			if(isRepeated==false){
				return true;
			}
		}
	};
	
	function getDataFromGrid(objGrid:DataGrid){
		var obj_Array = new Array();
		for(var x=0; x < objGrid.dataProvider.length; x++)	{
			var p_data = new Object();
				p_data.pool_id = objGrid.dataProvider[x].pool_id;
				p_data.condition = objGrid.dataProvider[x].condition;
				p_data.conditionDoc = objGrid.dataProvider[x].conditionDoc;
				p_data.pool_name = objGrid.dataProvider[x].pool_name;
			obj_Array.push(p_data);
		}
		return obj_Array;
	};
	
}