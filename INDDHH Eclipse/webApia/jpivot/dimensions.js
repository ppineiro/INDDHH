var dimensionDummy;
var dropAreas=new Array();
function setDimensions(){
	if(MSIE6){return false;}
	var naviAxis=getElementsByClassName("navi-axis");
	/*var drops=[
		function(el){abstractDrop(el,"columns")},
		function(el){abstractDrop(el,"rows")},
		function(el){abstractDrop(el,"filters")}
	];*/
	var drops=["columns","rows","filters"];
	var dropNum=0;
	for(var i=0;i<naviAxis.length;i++){
		//naviAxis[i].doDrop=drops[i];
		if(!naviAxis[i].nextSibling){
			naviAxis[i].setAttribute("where",drops[dropNum]);
			dropAreas.push(naviAxis[i]);
			dropNum++;
		}
	}
	
	var table01=document.getElementById("table01");
	var trs=table01.rows;
	if (trs.length>0){ //Si la vista recuperó datos
		var lastTr=trs[trs.length-1];
		var firstTd=0;
		for(var i=0;i<lastTr.cells.length;i++){
			if(lastTr.cells[i].tagName=="TD"){
				firstTd=i;
				break;
			}
		}
		
		for(var i=0;i<trs.length;i++){
			var tr=trs[i];
			var nextTr=null;
			if(trs[i+1]){
				nextTr=trs[i+1];
			}
			var ths=trs[i].getElementsByTagName("th");
			for(var u=0;u<ths.length;u++){
				if(ths.length!=lastTr.cells.length && ths[u].className!="corner-heading" && trs[i]!=lastTr){
					ths[u].setAttribute("where","columns");
					dropAreas.push(ths[u]);
				}else if(ths.length==lastTr.cells.length || trs[i]==lastTr){
					if(nextTr){
						nextThs=nextTr.getElementsByTagName("th");
						if(nextThs.length<=u){
							ths[u].setAttribute("where","columns");
						}else{
							ths[u].setAttribute("where","rows");
						}
					}else{
						ths[u].setAttribute("where","rows");
					}
					dropAreas.push(ths[u]);
				}
			}
		}
		
		if(document.getElementById("navi01")){
			setDimensionsToTable(document.getElementById("navi01"));
		}
	}else{
		//showMessage("La vista no recuperó ningún dato");
	}
}

function setDimensionsToTable(table){
	var divs=table.getElementsByTagName("DIV");
	for(var i=0;i<divs.length;i++){
		if(divs[i].getElementsByTagName("a")[0]){
			makeUnselectable(divs[i].getElementsByTagName("a")[0]);
			divs[i].getElementsByTagName("a")[0].onmousedown=function(){return false;}
			divs[i].getElementsByTagName("a")[0].style.width="100%";
			divs[i].onmousedown=function(evt){
				evt=getEventSource(evt);
				var el=getEventObject(evt);
				dimensionDummy=document.createElement("DIV");
				dimensionDummy.canDrop=false;
				dimensionDummy.style.position="absolute";
				dimensionDummy.style.display="none";
				dimensionDummy.style.height="20px";
				dimensionDummy.style.width="30px";
				dimensionDummy.style.backgroundImage="url("+URL_ROOT_PATH+"/images/jpivot/cantDrop.png)";
				dimensionDummy.style.backgroundRepeat="no-repeat";
				dimensionDummy.content=this;
				dimensionDummy.innerHTML=this.getElementsByTagName("a")[0].innerHTML;
				dimensionDummy.style.paddingLeft="20px";
				dimensionDummy.style.paddingTop="10px";
				dimensionDummy.style.fontFamily="tahoma";
				dimensionDummy.style.fontSize="10px";
				dimensionDummy.style.whiteSpace="nowrap";
				document.body.appendChild(dimensionDummy);
				document.onmousemove=function(evt){
					dimensionDummy.style.display="block";
					evt=getEventObject(evt);
					var x=getMouseX(evt);
					var y=getMouseY(evt);
					dimensionDummy.style.left=(x+10)+"px";
					dimensionDummy.style.top=y+"px";
					tryDrop(dimensionDummy,{x:x,y:y});
				}
				document.onmouseup=function(evt){
					document.onmouseup=null;
					document.onmousemove=null;
					if(dimensionDummy.canDrop){
						//dimensionDummy.dropArea.doDrop(dimensionDummy);
						abstractDrop(dimensionDummy,dimensionDummy.dropArea.getAttribute("where"));
					}
					dimensionDummy.parentNode.removeChild(dimensionDummy);
					dimensionDummy=null;
				}
			}
			divs[i].style.backgroundColor="white";
		}
	}
}

function tryDrop(div,coords){
	for(var i=0;i<dropAreas.length;i++){
		if(hitTest(dropAreas[i],coords)){
			dimensionDummy.style.backgroundImage="url("+URL_ROOT_PATH+"/images/jpivot/canDrop.png)";
			dimensionDummy.canDrop=true;
			dimensionDummy.dropArea=dropAreas[i];
			return true;
		}
	}
	dimensionDummy.style.backgroundImage="url("+URL_ROOT_PATH+"/images/jpivot/cantDrop.png)";
	dimensionDummy.canDrop=false;
	dimensionDummy.dropArea=null;
	return false;
}

function abstractDrop(el,where){
	el=el.content;
	var toColumn;
	var toRow;
	var toFilter;
	var inputs=el.getElementsByTagName("INPUT");
	for(var i=0;i<inputs.length;i++){
		if(inputs[i].src.indexOf("row.png")>=0){
			toRow=inputs[i];
		}
		if(inputs[i].src.indexOf("column.png")>=0){
			toColumn=inputs[i];
		}
		if(inputs[i].src.indexOf("filter.png")>=0){
			toFilter=inputs[i];
		}
	}
	var name="";
	if(where=="columns" && toColumn){
		name=toColumn.name;
	}
	if(where=="rows" && toRow){
		name=toRow.name;
	}
	if(where=="filters" && toFilter){
		name=toFilter.name;
	}
	if(name==""){
		return false;
	}
	var input1=document.createElement("INPUT");
	var input2=document.createElement("INPUT");
	input1.name=name+".x";
	input2.name=name+".y";
	input1.type="hidden";
	input2.type="hidden";
	input1.value="";
	input2.value="";
	document.getElementById("frmMain").appendChild(input1);
	document.getElementById("frmMain").appendChild(input2);
	document.getElementById("frmMain").submit();
	
}