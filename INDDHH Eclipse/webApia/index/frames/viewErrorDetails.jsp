<%@page import="biz.statum.apia.web.bean.BasicBeanStatic"%><%@ page import="com.dogma.Parameters"%><%@ page import="com.dogma.EnvParameters"%><%@page import="com.st.util.labels.LabelManager"%><% 

Integer labelSet = Parameters.DEFAULT_LABEL_SET;
Integer langId = Parameters.DEFAULT_LANG;
String styleDirectory = "default";
com.dogma.UserData uData = BasicBeanStatic.getUserDataStatic(request);
if (uData!=null) {
	labelSet = uData.getLabelSetId();
	langId = uData.getLangId();
	styleDirectory = EnvParameters.getEnvParameter(uData.getEnvironmentId(),EnvParameters.ENV_STYLE);
}
%><html><head><link href="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/css/feedBack.css" rel="styleSheet" type="text/css" media="screen"></head><body onLoad="sizeMe()"><!----------------------------START TITLE BAR-----------------><table class="tblTitulo"><tr><td style="word-wrap: break-word"><%=LabelManager.getName(labelSet,langId,"lblMen")%></td></tr></table><div class="divContent" id="divContent" style="height:100px;"><table><tr><td id="preMsg" width="320" style="display:block"></td></tr></table></div><!--------START BUTTONBAR-------------------------><table id="btnsBar" class="btnsBar"><tr><td align="right"><button id="buttonCopy" onclick="copy()" title="Copy text to clipboard">Copy</button><button id="buttomSbm" onclick="window.close()" accesskey="<%=LabelManager.getAccessKey(labelSet,langId,"btnCer")%>" title="<%=LabelManager.getToolTip(labelSet,langId,"btnCer")%>"><%=LabelManager.getNameWAccess(labelSet,langId,"btnCer")%></button></td></tr></table></div></body><script language="javascript">
		document.getElementById("buttomSbm").onclick=function(){
			window.close();
		}
	
		if (document.addEventListener){
		    document.addEventListener('DOMContentLoaded', fnStartDocInit, false);
		}else{
			window.document.onreadystatechange=fnStartDocInit;
		}
		
		function fnStartDocInit(){
			if (document.readyState=='complete'  || (window.navigator.appVersion.indexOf("MSIE")<0)){
				try {
					str = window.dialogArguments;
					document.getElementById("preMsg").innerHTML = str.value;
				} catch (e) {
				}
			}
			if (document.addEventListener){
				document.getElementById("buttonCopy").style.display="none";
			}
		}
	
		function copy() {
			if(window.clipboardData && clipboardData.setData){
		        clipboardData.setData("Text", document.getElementById("divContent").innerText);
		    }else{
		       alert("Internet Explorer required");
		    }
		}
		
		function sizeMe(){
			//divContent display off by default by workarea.css
			document.getElementById("divContent").style.display="block";
			//Button Bar display off by default by workarea.css
			document.getElementById("btnsBar").style.display="block";
			var oBtnBar=document.getElementById("btnsBar");
			var height=window.innerHeight;
			if(navigator.userAgent.indexOf("MSIE")>0){
				height=document.body.clientHeight;
			}
			if (oBtnBar!=null){
				height=((height-(document.getElementById("btnsBar").clientHeight*2))-5);
				document.getElementById("divContent").style.height=height+"px";
			}else{
				document.getElementById("divContent").style.height=(height-29)+"px";
			}
			if(window.navigator.appVersion.indexOf("MSIE")>0){
				document.recalc();
			}
		}
	</script></html>

