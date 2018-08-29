function btnLoadAtt_click(envId) {
	var rets = openModal("/programs/modals/atts.jsp?onlyOne=true",500,300);
	var doAfter=function(rets){
		if (rets != null) {
			for (j = 0; j < rets.length; j++) {
				var ret = rets[j];
				var addRet = true;

				trows=document.getElementById("tskSchAttGrid").rows;
				for (i=1;i<trows.length && addRet;i++) {
					if (trows[i].getElementsByTagName("TD")[0].getElementsByTagName("INPUT")[1].value == ret[0]) {
						addRet = false;
					}
				}
				
				if (addRet){
					var oTd0 = document.createElement("TD"); 
					var oTd1 = document.createElement("TD"); 
					var oTd2 = document.createElement("TD");
					var oTd3 = document.createElement("TD"); 

					oTd0.innerHTML = "<input type='checkbox' name='chkAttSel'><input type='hidden' name='chkAtt'>";
					oTd0.getElementsByTagName("INPUT")[1].value = ret[0];
					oTd0.align="center";
					oTd1.innerHTML = ret[1] + "<input type='hidden' id='attName' name='attName' value='" + ret[1] + "'/>";;//attName
					
					var selectTag = "<select name='selAttType'>";
					
					var optionTag = "<option selected value='" + ATT_TYPE_ENTITY + "'>" + LBL_ATT_TYPE_ENTITY + "</option>";
					selectTag += optionTag;
					optionTag = "<option value='" + ATT_TYPE_PROCESS + "'>" + LBL_ATT_TYPE_PROCESS + "</option>";
					selectTag += optionTag;
					
					selectTag += "</select>";
					
					oTd2.innerHTML = selectTag;
					
					oTd3.innerHTML = "<input type='checkbox' id='chkAttReq' name='chkAttReq' value='" + (trows.length + j) +"' ></input>";
	
					var oTr = document.createElement("TR");
					oTr.appendChild(oTd0);
					oTr.appendChild(oTd1);
					oTr.appendChild(oTd2);
					oTr.appendChild(oTd3);
					document.getElementById("tskSchAttGrid").addRow(oTr);
					document.getElementById("tskSchAttGrid").updateScroll();
				}
			}
		}
	}
	rets.onclose=function(){
		doAfter(rets.returnValue);
	}
}

function btnDel_click(){
	var oRows=document.getElementById("tskSchAttGrid").selectedItems;
	for(var i=(oRows.length-1);(i>=0);i--){
		oRows[i].parentNode.removeChild(oRows[i]);
		document.getElementById("tskSchAttGrid").updateScroll();
		oRows[i].style.height="0px";
	}

}