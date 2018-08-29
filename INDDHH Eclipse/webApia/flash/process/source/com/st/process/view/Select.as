

class com.st.process.view.Select{
	
	private static var currentSelected:Array; 
	
	public function Select(Void){
		currentSelected = new Array();
	};
	
	public function addElement(id:Number){
		currentSelected.push(id);
	};
	public function getElement():Number{
		return currentSelected[0];
	};
	public function clearElements(){
		currentSelected = new Array();
	};
	
};