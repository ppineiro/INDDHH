import mx.containers.Window;
import mx.controls.TextInput;
import mx.controls.Button;
import mx.managers.PopUpManager;
import mx.controls.DataGrid;
import mx.controls.gridclasses.DataGridColumn;
import mx.controls.gridclasses.DataGridRow;



class UsersModal extends MovieClip {
	
	var NOM_COL_ATRIB:String = "atrib";
	var NOM_COL_VALOR:String = "valor";
	var urlUsers:String="";
	var urlAmbiances:String="";
	var dgDatosA:DataGrid;
	var dgDatosU:DataGrid;
	var idA:Number=0;
	function UsersModal(Void) {

		var thisModal=this;
		dgDatosA.setStyle("alternatingRowColors",[0xFFFFFF,0xEEEEFF]);
		dgDatosA.setStyle("fontFamily","Verdana");
		dgDatosA.setStyle("fontSize","10");
		dgDatosU.setStyle("alternatingRowColors",[0xFFFFFF,0xEEEEFF]);
		dgDatosU.setStyle("fontFamily","Verdana");
		dgDatosU.setStyle("fontSize","10");
	}
	
	function onLoad() {
		var thisModal=this;
		idA=this._parent.idA;
		if(_global.inApia){
			urlUsers="security.GroupHierarchyAction.do?action=xmlPoolUsers&poolId="+idA+"&envId=";
			urlAmbiances="security.GroupHierarchyAction.do?action=xmlPoolEnvs&poolId="+idA;
		}else{
			urlUsers="users.xml";
			urlAmbiances="ambiances.xml";
		}
		
		var column = new DataGridColumn("ambiances");
			column.headerText = _global.ambCol;
			column.width = 190;			
		dgDatosA.addColumn(column);

		var column = new DataGridColumn("id");
			column.headerText = _global.idCol;
			column.width = 190;			
		dgDatosU.addColumn(column);

		var column = new DataGridColumn("users");
			column.headerText = _global.usrCol;
			column.width = 190;			
		dgDatosU.addColumn(column);

		startAmbiances();
		var listener:Object=new Object();
		listener.change=function(){
			var itemSel=thisModal.dgDatosA.selectedItem;
			thisModal.loadUsers(itemSel.id);
		}
		dgDatosA.addEventListener("change",listener);
		_root.block(true);
	}
	
	function startAmbiances() { 
		var tmp=this;
		var x = new XML();
			x.ignoreWhite = true;
			x.onLoad = function(success) {
				var x = this;
				//dgDatos.removeAll();
				var myDP:Array = new Array();
				for (var e=0;e < x.firstChild.childNodes.length;e++) {
					var id= x.firstChild.childNodes[e].childNodes[0].childNodes[0];
					var ambiances= x.firstChild.childNodes[e].childNodes[1].firstChild;
					myDP[e] = {ambiances:ambiances,id:id};
				}						
				
				tmp.dgDatosA.dataProvider = myDP;
				//tmp.showDatos();
			};
			
		x.load(urlAmbiances);
	}
	
	function loadUsers(id:String) { 
		var tmp=this;
		var x = new XML();
			x.ignoreWhite = true;
			x.onLoad = function(success) {
				var x = this;
				//dgDatos.removeAll();
				var myDP:Array = new Array();
				for (var e=0;e < x.firstChild.childNodes.length;e++) {
					var id= x.firstChild.childNodes[e].childNodes[0].childNodes[0];
					var users= x.firstChild.childNodes[e].childNodes[1].childNodes[0];
					myDP[e] = {id:id,users:users};
				}						
				
				tmp.dgDatosU.dataProvider = myDP;
				//tmp.showDatos();
			};
		var url=urlUsers;
		if(_global.inApia){
			url=url+id;			
		}
		x.load(url);
	}	
}


