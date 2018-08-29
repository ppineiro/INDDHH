
class ObjectArray extends Array {     
// adds the item to the array     
	function addItem(p_item:Object):Void {         
		push(p_item);     
	};      
	// finds and replaces oldItem with item in the array     
	function updateItem(p_oldItem:Object,p_item:Object):Void {         
		this[getIndexOf(p_oldItem)] = p_item;     
	};     
	// removes the specified object from the array     
	function deleteItem(p_item:Object):Void {  
		splice(getIndexOf(p_item),1);     
	} ;    
	// finds and returns the index of a specific object:     
	// used internally by deleteItem and updateItem     
	private function getIndexOf(p_item:Object):Number {         
		var i:Number=length;   
		while (i-- > 0) {             
			if (this[i] == p_item) { 
				return i;    
			}         
		}         
		return -1;  
	} ;
}