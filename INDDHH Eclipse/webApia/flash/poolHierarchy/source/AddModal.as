import mx.containers.Window;
import mx.controls.TextInput;
import mx.controls.Button;
import mx.managers.PopUpManager;
import mx.controls.DataGrid;
import mx.controls.gridclasses.DataGridColumn;
import mx.controls.gridclasses.DataGridRow;



class AddModal extends MovieClip {
	
	var NOM_COL_ATRIB:String = "atrib";
	var NOM_COL_VALOR:String = "valor";
	var url:String="";
	var dgDatos:DataGrid;
	var search_txt:TextInput;
	var search_btn:Button;
	var confirm_btn:Button;
	var cancel_btn:Button;
	
	function AddModal(Void) {
		
		if(_global.inApia){
			url="security.GroupHierarchyAction.do?action=xmlPools";			
		}else{
			url="groups.xml";
		}
		var thisModal=this;
		dgDatos.setStyle("alternatingRowColors",[0xFFFFFF,0xEEEEFF]);
		dgDatos.setStyle("fontFamily","Verdana");
		dgDatos.setStyle("fontSize","10");
		
		search_btn.onPress=function(){
			var url=thisModal.url;
			if((_global.inApia==true) && (thisModal.search_txt.text!="")){
				url+="&name="+thisModal.search_txt.text;
			}
			thisModal.loadXML(url);
		}
		
		confirm_btn.onPress=function(){
			var item=thisModal.dgDatos.selectedItem;
			if(item!=undefined){
				thisModal._parent.dispatchEvent({type:"ok",item:item});
			}else{
				mx.controls.Alert.show(_global.mustSelect);
			}
		}
		
		this.cancel_btn.onPress = function() {
			thisModal._parent.dispatchEvent({type:"click"});
		}
		
	}
	
	function onLoad() {
		var column = new DataGridColumn("nombre");
			column.headerText = _global.nameCol;
			column.width = 190;			
		dgDatos.addColumn(column);
		
		column = new DataGridColumn("descripcion");
			column.headerText = _global.descCol;
			column.width = 190;
		dgDatos.addColumn(column);
		confirm_btn.label=_global.confirm;
		cancel_btn.label=_global.cancel;
		_root.block(true);
	}
	
	function loadXML(url:String) { 
		var tmp=this;
		var x = new XML();
			x.ignoreWhite = true;
			x.onLoad = function(success) {
				var x = this;
				//dgDatos.removeAll();
				var myDP:Array = new Array();
				for (var e=0;e < x.firstChild.childNodes.length;e++) {
					var id= x.firstChild.childNodes[e].childNodes[0].firstChild;
					var nombre= x.firstChild.childNodes[e].childNodes[1].firstChild;
					var descripcion= x.firstChild.childNodes[e].childNodes[2].firstChild;
					var allEnvs= x.firstChild.childNodes[e].childNodes[3].firstChild;
					var envCount= x.firstChild.childNodes[e].childNodes[4].firstChild;
					myDP[e] = {id:id, nombre:nombre,descripcion:descripcion,allEnvs:allEnvs,envCount:envCount};					
				}						
				
				tmp.dgDatos.dataProvider = myDP;
				//tmp.showDatos();
			};
			
		x.load(url);
	}
}


