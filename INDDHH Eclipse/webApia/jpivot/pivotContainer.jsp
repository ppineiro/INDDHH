<%@include file="../page/includes/startInc.jsp" %><%@page import="com.dogma.Parameters"%><html style="height:100%"><head><%@include file="../page/includes/headInclude.jsp" %><script src="<system:util show="context" />/scripts/common.js" language="Javascript"></script><script src="<system:util show="context" />/scripts/util.js" language="Javascript"></script><link href="<system:util show="context" />/js/progressBars/progressBar.css" rel="stylesheet" type="text/css"><script type="text/javascript" src="<system:util show="context" />/js/progressBars/progressBar.js"></script><script type="text/javascript">
		var pb;
		var mode = "<%=request.getParameter("mode")%>";
		var testFinish=false;
 		function initPage() {
			pb = new ProgressBar('apia.administration.BIAction.run');
			<%if("true".equals(request.getParameter("forceOpen"))) {%>
				$('jpivot-frm').set('src', '<system:util show="context" />/jpivot/schemaLoader.jsp?schemaId=<%=request.getParameter("schemaId")%>&cubeId=<%=request.getParameter("cubeId")%>&viewId=<%=request.getParameter("viewId")%>&entityCube=<%=request.getParameter("entityCube")%>' + TAB_ID_REQUEST);
			<%} else {%>
				testCube(); //Verifica que la vista sea correcta
			<%}%>
			setTimeout(function () {
				if(pb.alive) pb.stop();
				if (testFinish!=true){
					if ("viewer" == mode){ //Si estamos en modo visualizador avisamos que dio time out
						var panel = SYS_PANELS.newPanel([]);
						//panel.header.innerHTML = ''; //title
						panel.content.innerHTML = '<system:label show="text" label="msgMaxWaitTimeExceeded" />'; //msg
						SYS_PANELS.addClose(panel, false, function() {
							getTabContainerController().removeActiveTab();
						});
						SYS_PANELS.adjustVisual();
					}else { //Estamos en modo navegador => Damos oportunidad de seleccionar otra vista para ingresar al cubo
						//Abrir errroBI.jsp
		 				var params = '&schemaId=<%=request.getParameter("schemaId")%>&cubeId=<%=request.getParameter("cubeId")%>&entityCube=<%=request.getParameter("entityCube")%>&processCube=<%=request.getParameter("processCube")%>&viewId=<%=request.getParameter("viewId")%>&envId=<%=request.getParameter("envId")%>&envApiaGenCube=<%=request.getParameter("envApiaGenCube")%>&allEnvApiaGenCube=<%=request.getParameter("allEnvApiaGenCube")%>';
		 				$('jpivot-frm').set('src', '<system:util show="context" />/jpivot/errorBI.jsp?error=24&mode=' + mode + params + TAB_ID_REQUEST);
					}
				}
			}, <%=Parameters.BI_LOAD_MAX_WAIT_TIME%>);
 		}
 		
		function testCube() {
			var params = '&schemaId=<%=request.getParameter("schemaId")%>&cubeId=<%=request.getParameter("cubeId")%>&entityCube=<%=request.getParameter("entityCube")%>&processCube=<%=request.getParameter("processCube")%>&viewId=<%=request.getParameter("viewId")%>&envId=<%=request.getParameter("envId")%>&envApiaGenCube=<%=request.getParameter("envApiaGenCube")%>&allEnvApiaGenCube=<%=request.getParameter("allEnvApiaGenCube")%>';
				
		 	var request = new Request({
				method: 'post',
				url: CONTEXT + '/apia.administration.BIAction.run?action=testCube&isAjax=true' + params + TAB_ID_REQUEST,
				onComplete: function(resText, resXml) { processXMLtestResult(resXml); }
			}).send();
 		}
		
 		/**
 		 * Recibe un xml con el resultado del test
 		 */
 		function processXMLtestResult(responseXML) {
 			testFinish = true;
	 		if(responseXML && responseXML.childNodes && responseXML.childNodes.length) {
 				var response = responseXML.childNodes.length == 1 ? responseXML.childNodes[0] : responseXML.childNodes[1];
 		
 				if(response.tagName == 'result' && response.getAttribute('testresult')) {
		 			var result = Number.from(response.getAttribute('testresult'));
		 			var forceOpen = response.getAttribute("forceOpen"); //in case was a entity cube not updated and user don't want to update now
		 			var mode = response.getAttribute("mode"); //in case was a entity cube not updated and user don't want to update now
		 			if (0 == result || (500 == result && forceOpen=='true')) {
		 				//Abrir schemaLoader.jsp
		 				$('jpivot-frm').set('src', '<system:util show="context" />/jpivot/schemaLoader.jsp?schemaId=<%=request.getParameter("schemaId")%>&cubeId=<%=request.getParameter("cubeId")%>&viewId=<%=request.getParameter("viewId")%>&entityCube=<%=request.getParameter("entityCube")%>' + TAB_ID_REQUEST);
		 			} else if (500 == result) {
		 				//El cubo es de entidad y no esta actualizado
		 				var params = '&schemaId=<%=request.getParameter("schemaId")%>&cubeId=<%=request.getParameter("cubeId")%>&entityCube=<%=request.getParameter("entityCube")%>&processCube=<%=request.getParameter("processCube")%>&viewId=<%=request.getParameter("viewId")%>&envId=<%=request.getParameter("envId")%>&envApiaGenCube=<%=request.getParameter("envApiaGenCube")%>&allEnvApiaGenCube=<%=request.getParameter("allEnvApiaGenCube")%>';
		 				$('jpivot-frm').set('src', '<system:util show="context" />/jpivot/entityCubeReload.jsp?mode=' + mode + params + TAB_ID_REQUEST);
		 			} else { //dio error
		 				//Abrir errroBI.jsp
		 				var params = '&schemaId=<%=request.getParameter("schemaId")%>&cubeId=<%=request.getParameter("cubeId")%>&entityCube=<%=request.getParameter("entityCube")%>&processCube=<%=request.getParameter("processCube")%>&viewId=<%=request.getParameter("viewId")%>&envId=<%=request.getParameter("envId")%>&envApiaGenCube=<%=request.getParameter("envApiaGenCube")%>&allEnvApiaGenCube=<%=request.getParameter("allEnvApiaGenCube")%>';
		 				
		 				$('jpivot-frm').set('src', '<system:util show="context" />/jpivot/errorBI.jsp?error=' + result + '&coco=true&errorMsg=' + response.getAttribute('errorMsg') + '&mode=' + mode + params + TAB_ID_REQUEST);
		 			}
	 			}
	 		}
	 	}
 	</script></head><body style="padding:0px;margin:0px;overflow:hidden;height:100%" scroll="no"><iframe id="jpivot-frm" name="jpivot" frameborder="no" style="position:absolute;top:0px;height:100%;width:100%;" scrolling="no"></iframe></body></html>