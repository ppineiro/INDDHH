function setMaxLength(input){
	var maxLength=input.maxlength;
	input.actualValue=input.value;
	/*input.onkeypress=function(){
		if(this.value.length > (parseInt(this.getAttribute("maxlength"))-1)){
			//event.returnValue = false;
			var sizedValue=this.value.substring(0,(parseInt(this.getAttribute("maxlength"))));
			this.actualValue=sizedValue;
			//maxLength = parseInt(maxLength);
			this.update();
		}
	}*/
	input.onkeyup=function(){
		var maxLength = parseInt(this.getAttribute("maxlength"));
		if(this.value.length > maxLength){
		   this.value = this.value.substring(0,maxLength);  
		}
	}
	input.update=function(){
		this.value=this.actualValue;
	}
}

function unsetMaxLength(input){
	delete(input.onkeyup);
	delete(input.update)
}