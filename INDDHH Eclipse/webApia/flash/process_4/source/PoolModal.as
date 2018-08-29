

import mx.controls.List;
import mx.controls.TextInput;
import mx.controls.Button;
import mx.controls.DataGrid;
import mx.controls.gridclasses.DataGridColumn;
import mx.controls.gridclasses.DataGridRow;
import mx.managers.PopUpManager;
import mx.containers.Window;

import com.qlod.LoaderClass;

class PoolModal extends MovieClip{
	
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
	
	var pool_array:Array;
	var oLoader:LoaderClass;

	function PoolModal(Void){
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
			var selectedIndex = thisModal.pool_dg.getSelectedIndex();
			if(selectedIndex!=null){
				//----------------------------------
				//SHOW CONDITION MODAL
				//----------------------------------
				var itemSelected = thisModal.pool_dg.getItemAt(selectedIndex);
				var cndText:String = itemSelected.condition;
				
				var configOBj = new Object();
					configOBj.closeButton = true;
					configOBj.contentPath = "ConditionModal";
					configOBj.title = _global.labelVars.lbl_ConditionModalTitle.toUpperCase();
					configOBj._width = 460;
					configOBj._height = 290;
					configOBj.conditionValue = cndText;
				
				var objEvt = new Object();
					objEvt.ok = function(evt){
						itemSelected.condition = evt.conditionValue;
						//hack to redraw icon cell!!!!
						thisModal.pool_dg.dataProvider = thisModal.pool_dg.dataProvider;
						popUp.deletePopUp();
					}
				
				var popUp = WindowManager.popUp(configOBj);
					popUp.addEventListener("ok", objEvt);
				
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
				
		};
	};
	
	
	function onLoad(){
		var thisModal = this;
		
		//SET BTN LABELS
		confirm_btn.label = _global.labelVars.lbl_btnConfirm;
		cancel_btn.label = _global.labelVars.lblbtnCancel;
		cnd_btn.label = _global.labelVars.lbl_ConditionModalTitle;
		
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
							pool_name:pool_array[d].pool_name});
		}
		pool_dg.dataProvider = pool_DP;
		
	};
	
	function getIcon(itemObj:Object, columnName:String){
		if (itemObj.condition!=null && itemObj.condition!=undefined && itemObj.condition!=""){ 
			return "groupConditionIcon";
		}else{
			return;
		}
	};
	
	
	function getPoolsXML(objList:List,objText:TextInput){
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
				
			};
			
		var auxURL:String; 
		if(_global.DEBUG_IN_IDE){
			auxURL = XML_POOLS;
		}else{
			auxURL = XML_POOLS + "&name=" + pool_txt.text;
		}
		
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
				p_data.pool_name = objGrid.dataProvider[x].pool_name;
			obj_Array.push(p_data);
		}
		return obj_Array;
	};
	
}