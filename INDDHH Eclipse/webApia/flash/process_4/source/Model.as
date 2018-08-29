

class Model extends MovieClip {
	
	var elements:Object;
	
	function Model(){
		this.elements = new Object();
	};
	
	function addElement(id){
		if(this.elements[id] == null){
			this.elements[id] = new Object();
			this.elements[id].id = id;
			this.elements[id].vertices = new Object();
			
			return true;
		}else{
			return false;
		}
	};
	
	function removeNode(id) { //ex removeNode(name)
		//removes a node from the graph
		trace("$REMOVING NODE: " + this.elements[id].id);
		delete this.elements[id];
		for (var i in this.elements) {
			//if(this.elements[i].vertices[id]){trace("$REMOVING NODE VERTEX: " + this.elements[i].vertices[id].id)}
			delete this.elements[i].vertices[id];
		}
	};
	
	function getElement(id){
		return this.elements[id].id;
	};
		  
	function addVertex(id_a, id_b) {
		// adds a vertex to the graph
		this.elements[id_a].vertices[id_b] = new Object();
		this.elements[id_a].vertices[id_b].id = id_b;
	}; 
	
	function removeVertex(id_a, id_b) {
		//removes a vertex from the graph
		trace("$REMOVING VERTEX:" + id_a + " / " + id_b);
		delete this.elements[id_a].vertices[id_b];
	};
	
	function getVertex(id_a, id_b) {
		//get the info stored in a particular vertex
		return this.elements[id_a].vertices[id_b].id;
	};
}