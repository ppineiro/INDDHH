<%@include file="../includes/startInc.jsp" %><html><head><%@include file="../includes/headInclude.jsp" %><link href="<system:util show="context" />/css/<system:util show="currentStyle" />/generalAdm.css" rel="stylesheet" type="text/css"><script type="text/javascript" src="<system:util show="context" />/page/modals/jpivotViewFilters.js"></script></head><script type="text/javascript">
	/*
	var forObj; //busclass, query
	var id;
	var parValues;
	var forZone = false;
	*/
	var VIEW_ID = <%=request.getParameter("viewId")%>;
	var USER_ID = "<%=request.getParameter("userId")%>";
	
	function initPage() {
		$('btnTest').addEvent('click', btnTest_click);
		
		//Load filters
		new Request({
			method: 'POST',
			url: CONTEXT + "/Views?action=loadViewFilter&viewId=" + VIEW_ID,
			onComplete: function(resText, resXml) {
				if(resText != "") {
					if (window.ActiveXObject){
	                  var doc=new ActiveXObject('Microsoft.XMLDOM');
	                  doc.async='false';
	                  doc.loadXML(resText);
	                } else {
	                  var parser=new DOMParser();
	                  var doc=parser.parseFromString(resText,'text/xml');
	                }
					if(doc && doc.childNodes)
						doc = doc.childNodes[0];
					if(doc && doc.childNodes) {
						if(doc.childNodes[0] && doc.childNodes[0].textContent && doc.childNodes[0].textContent != "null") {
							//Cargar clase
							$('inpCla').set('value', doc.childNodes[0].textContent);
						}
						if(doc.childNodes[1] && doc.childNodes[1].textContent && doc.childNodes[1].textContent != "null") {
							//Cargar parametro 1
							$('inpPar1').set('value', doc.childNodes[1].textContent);
						}
						if(doc.childNodes[2] && doc.childNodes[2].textContent && doc.childNodes[2].textContent != "null") {
							//Cargar parametro 2
							$('inpPar2').set('value', doc.childNodes[2].textContent);
						}
					}
				}
			}
		}).send();
		
	}

	function btnTest_click() {
		var vars = "&after=afterTest&className=" + $('inpCla').get('value') + "&viewId="+VIEW_ID;		
		new Request({
			method: 'POST',
			url: CONTEXT + "/Views?action=testViewFilterClass" + vars,
			onComplete: function(resText, resXml) {
				//showMessage(resText); No bloquea el modal
				alert(resText);
			}
		}).send();
		
	}
	
	
	var returnValue = null;
	
	
	function getModalReturnValue() {
		var claName = document.getElementById("inpCla").value;
		
		if(claName) {
			var res = "";
			var vars = "&resultType=dontShow&after=afterTest&className=" + $('inpCla').get('value') + "&viewId="+VIEW_ID;		
			new Request({
				method: 'POST',
				url: CONTEXT + "/Views?action=testViewFilterClass" + vars,
				onComplete: function(resText, resXml) {
					res = resText;
				},
				async: false
			}).send();
			
			if(res == "OK")
				return [document.getElementById("inpCla").value, document.getElementById("inpPar1").value, document.getElementById("inpPar2").value];
			else
				alert(res);
		} else {
			return [document.getElementById("inpCla").value, document.getElementById("inpPar1").value, document.getElementById("inpPar2").value];
		}
		
		return null;
	}

</script><body style="padding-left: 10px; padding-right: 10px;"><div id="exec-blocker"></div><div class="body" id="bodyDiv"><form id="frmData"><div class="fieldGroup"><div class="title"><system:label show="text" label="titVwFilter" /></div><div class="field fieldHalf" ><label title="<system:label show="tooltip" label="lblCla" />"><system:label show="text" label="lblCla" />:</label><input type="text" name="inpCla" id="inpCla" value="" /></div><br/><div class="field" style="width: 96px;"><div id="btnTest" class="button" title="<system:label show="tooltip" label="btnTest" />"><system:label show="text" label="btnTest" /></div></div><br/><br/><div class="field"><label title="<system:label show="tooltip" label="lblPar1" />"><system:label show="text" label="lblPar1" />:</label><input type="text" name="inpPar1" id="inpPar1" value="" /></div><br/><div class="field"><label title="<system:label show="tooltip" label="lblPar2" />"><system:label show="text" label="lblPar2" />:</label><input type="text" name="inpPar2" id="inpPar2" value="" /></div></div></form></div></body>

