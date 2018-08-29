<%@ page import="com.dogma.Parameters"%>
<%@ page import="com.dogma.EnvParameters"%>
<%@page import="com.st.util.labels.LabelManager"%>

<% 

Integer labelSet = Parameters.DEFAULT_LABEL_SET;
Integer langId = Parameters.DEFAULT_LANG;
String styleDirectory = "default";
com.dogma.UserData uData = (com.dogma.UserData)session.getAttribute("sessionAttribute");
if (uData!=null) {
	labelSet = uData.getLabelSetId();
	langId = uData.getLangId();
	styleDirectory = EnvParameters.getEnvParameter(uData.getEnvironmentId(),EnvParameters.ENV_STYLE);
}
%>

<html>
	<head><meta http-equiv="X-UA-Compatible" content="IE=7" />
	<link href="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/css/feedBack.css" rel="styleSheet" type="text/css" media="screen">
	<script language="javascript" src="../scripts/util.js"></script>
	<!--  <script language="javascript" src="test.js" defer="defer"></script> -->
	</head>
<!-- feedback win -->
	<BODY>
	<!----------------------------START TITLE BAR----------------->
	<iframe id="iframeKeepActive" style="display:none"></iframe>
	<div id=divMsg style="height:197px;">
		<table class="tblTitulo">
			<tr>
				<td style="word-wrap: break-word"><%=LabelManager.getName(labelSet,langId,"lblMen")%></td>
			</tr>
		</table>
	
		<!-----------------------------START CONTENT---------------->
		
		<div class="divContent" id="divContent" style="width:340px; height:147px;overflow:auto;">
		<table>
			<tr>
				<td id="preMsg" width="320" style="word-wrap: break-word"></td>
			</tr>
		</table>
		</div>
	
		<!--------START BUTTONBAR------------------------->
		<table id="btnsBar" class="btnsBar">
			<tr>
				<td style="width:100%;"></td>
				<td align="right" style="width:0px">
					<button type="button" id="buttomSbm" accesskey="<%=LabelManager.getAccessKey(labelSet,langId,"btnCer")%>" title="<%=LabelManager.getToolTip(labelSet,langId,"btnCer")%>"><%=LabelManager.getNameWAccess(labelSet,langId,"btnCer")%></button>
				</td>
			</tr>
		</table>
	</div>
	
	<div id="divWait" style="display:none;height:197px;">
		<table class="tblTitulo" height="100%">
			<tr>
				<td vAlign="top">
					<%=LabelManager.getName(labelSet,langId,"lblEspUnMom")%>
					<div id="divTituloWaitStatusMessage" style="display:none"></div>
					<div style="border: thin #FFFFFF solid; width: 200px; display:none" id="divTituloWaitStatusImageContainer"><img id="divTituloWaitStatusImage" src="../images/bar.gif" height="10px" width="0px"></div>
				</td>
			</tr>
		</table>
	</div>
	<!--------END BUTTONBAR------------------------->

	</body>
</html>

<script language="javascript">
document.getElementById("buttomSbm").onclick=function(){
	window.parent.document.getElementById("iframeMessages").hideResultFrame();
 
	try{
		parent.frames['workArea'].document.getElementById("btnLast").disabled = false;
	} catch(e){}
	try{
		parent.frames['workArea'].document.getElementById("btnNext").disabled = false;
	} catch(e){}
	try{
		parent.frames['workArea'].document.getElementById("btnConf").disabled = false;
	} catch(e){}
	 try{
		parent.frames['workArea'].document.getElementById("btnSave").disabled = false;
	} catch(e){}
	try{
		parent.frames['workArea'].document.getElementById("btnFree").disabled = false;
	} catch(e){}
	try{
		parent.frames['workArea'].document.getElementById("btnPrint").disabled = false;
	} catch(e){}
	try{
		parent.frames['workArea'].document.getElementById("btnDelegate").disabled = false;
	} catch(e){}
	try{
		parent.frames['workArea'].document.getElementById("btnElevate").disabled = false;
	} catch(e){}
	
	try {
		doc=parent.frames['workArea'].frames[2].document;
		try{
			doc.getElementById("btnLast").disabled = false;
		} catch(e){}
		try{
			doc.getElementById("btnNext").disabled = false;
		} catch(e){}
		try{
			doc.getElementById("btnConf").disabled = false;
		} catch(e){}
		 try{
			doc.getElementById("btnSave").disabled = false;
		} catch(e){}
		try{
			doc.getElementById("btnFree").disabled = false;
		} catch(e){}
		try{
			doc.getElementById("btnPrint").disabled = false;
		} catch(e){}
		try{
			doc.getElementById("btnDelegate").disabled = false;
		} catch(e){}
		try{
			doc.getElementById("btnElevate").disabled = false;
		} catch(e){}
	} catch(e2) {}
}

function viewDetails(){
	var modal=window.parent.xShowModalDialog("<%=Parameters.ROOT_PATH%>/frames/viewErrorDetails.jsp", document.getElementById("excStack"), "status:no;resizable:yes;dialogwidth:500;dialogheight:500;zindex:999999999");
	if (window.navigator.appVersion.indexOf("MSIE")>0){
		modal.content.onreadystatechange=function(){
			if(this.readyState=="complete"){
				window.parent.frames[this.name].document.getElementById("divContent").innerHTML="<div style='width:495px;height:100%;overflow:auto'>"+document.getElementById("excStack").value+"</div>";
			}
		}
	}else{
		modal.content.onload=function(){
			window.parent.frames[this.name].document.getElementById("divContent").innerHTML=document.getElementById("excStack").value;
		}
	}
}

function xShowModalDialog( sURL, vArguments, sFeatures ){
	if(sURL==null){
		sURL="";
	}
	if(vArguments==null){
		vArguments="";
	}
	if(sFeatures==null){
		sFeatures="";
	}
    if (sURL==''){ 
        alert ("Invalid URL input."); 
        return false; 
    } 
    if (window.navigator.appVersion.indexOf("MSIE")>0){ 
        return window.showModalDialog ( sURL, vArguments, sFeatures );
    }
	sFeatures = sFeatures.replace(/ /gi,''); 
    aFeatures = sFeatures.split(";"); 
    sWinFeat = "directories=0,menubar=0,titlebar=0,toolbar=0,"; 
    for ( x in aFeatures ){
        aTmp = aFeatures[x].split(":"); 
        sKey = aTmp[0].toLowerCase(); 
        sVal = aTmp[1];
        switch (sKey){ 
            case "dialogheight": 
                sWinFeat += "height="+sVal+","; 
                pHeight = sVal; 
                break; 
            case "dialogwidth": 
                sWinFeat += "width="+sVal+","; 
                pWidth = sVal; 
                break; 
            case "dialogtop": 
                sWinFeat += "screenY="+sVal+","; 
                break; 
            case "dialogleft": 
                sWinFeat += "screenX="+sVal+","; 
                break; 
            case "resizable": 
                sWinFeat += "resizable="+sVal+","; 
                break; 
            case "status": 
                sWinFeat += "status="+sVal+","; 
                break; 
            case "center": 
                if (sVal.toLowerCase() == "yes"){ 
                    //sWinFeat += "screenY="+((screen.availHeight-pHeight)/2)+","; 
                    //sWinFeat += "screenX="+((screen.availWidth-pWidth)/2)+","; 
                }
                break; 
        }
    } 
	sWinFeat=sWinFeat+",modal,dialog,alwaysRaised"
    modalWin=window.open(String(sURL),"",sWinFeat);
	if (vArguments!=null && vArguments!=''){
        modalWin.dialogArguments=vArguments; 
    }
     return modalWin;
} 

</script>
<script language="javascript">
function initFrame(){
	if(element.readyState=="complete"){
/*		FRAME_WIDTH = parseInt(element.currentStyle.width);
		FRAME_HEIGHT = parseInt(element.currentStyle.height);*/
		doCenterFrame();
	}
}

function doCenterFrame(){
	updatePosExpr();

}

function updatePosExpr(){
	iFeedBackFr =window.parent.document.getElementById(window.name);
	if(iFeedBackFr==null || iFeedBackFr==undefined){
		iFeedBackFr =window.parent.document.getElementsByTagName("IFRAME")[1];
	}
	var x=window.parent.innerWidth;
	var y=window.parent.innerHeight;
	var width=window.innerWidth;
	var height=window.innerHeight;
	if(navigator.userAgent.indexOf("MSIE")>0){
		x=window.parent.document.documentElement.clientWidth;
		y=window.parent.document.documentElement.clientHeight;
		width=iFeedBackFr.clientWidth;
		height=iFeedBackFr.clientHeight;
	}
	iFeedBackFr.style.left=((x-width)/2)+"px";
	iFeedBackFr.style.top=((y-height)/2)+"px";
}

function getWinCenterWidth(){
	return expr_frame_left;
}

function getWinCenterHeight(){
	return expr_frame_top;
}

function showResultFrame(body){
	//updatePosExpr();
	document.getElementById("divMsg").style.display="none";
	if(document.getElementById("divWait")){
		document.getElementById("divWait").style.display="block";
	}
	oBody = body;
//	disableUi(true, body);
	iFeedBackFr =	window.parent.document.getElementById(window.name);
	if(iFeedBackFr==null || iFeedBackFr==undefined){
		iFeedBackFr =window.parent.document.getElementsByTagName("IFRAME")[1];
	}
	iFeedBackFr.style.display="block";
	iFeedBackFr.document.getElementById("iframeKeepActive").src = "FramesAction.do?action=keepActive";
	updatePosExpr();
}

function showMessage(str, body){
	updatePosExpr();
	//iFeedBackFr = window.document.frames(element.name);
	document.getElementById("preMsg").innerHTML = str;
	document.getElementById("divMsg").style.display="block";
	document.getElementById("divContent").style.display="block";
	document.getElementById("btnsBar").style.display="block";
	document.getElementById("divWait").style.display="none";
	
	document.getElementById("iframeKeepActive").src = "";
	document.getElementById("divTituloWaitStatusMessage").style.display = "none";
	document.getElementById("divTituloWaitStatusImageContainer").style.display = "none";
	
	oBody = body;
	//disableUi(true, body);
	window.parent.document.getElementById(window.name).style.display="block";
}

function getBody(){
	return window.parent.document.getElementById(window.name).oBody;
}

function resizeFrame(iWidth){
	iWidth=iWidth + "px"
	element.style.width=iWidth;
}

function disableUi(bStatus, divContent){
	var oTab,cmbColl;
	var oTabEl = divContent.getElementsByTagName("tabElement");
	
	if (oTabEl[0]!=null){
		 oTab  = oTabEl[0].getSelectedTab();
		 cmbColl = oTab.getElementsByTagName("SELECT");
	}else{
		 cmbColl = divContent.getElementsByTagName("SELECT");
	}
	var colLen = cmbColl.length;
		if(bStatus==true){
				for(var s=0;s<colLen;s++){
					if(cmbColl[s].disabled == false){
						cmbColl[s].disabled = true;
					}else{
						cmbColl[s].setAttribute("attStayDisabled",true);
					}
				}
				var oDisabledSpan = document.createElement("DIV");
					oDisabledSpan.style.width = "100%";
					oDisabledSpan.style.height = "100%";
					oDisabledSpan.style.filter="alpha(opacity:40)";
					oDisabledSpan.style.backgroundColor="#DFDFDF";
					oDisabledSpan.style.position ="absolute";
					oDisabledSpan.style.left = "0px";
					oDisabledSpan.style.top = "0px";
					oDisabledSpan.style.zIndex = "998";
					oDisabledSpan.onclick="alert('hola')";
					oNewSpan = divContent.insertAdjacentElement("afterEnd", oDisabledSpan);
					//oNewSpan.attachEvent("onclick",divContent_onClick);
					
		}else{
					for(var s=0;s<colLen;s++){
						if(cmbColl[s].attStayDisabled != true){
							cmbColl[s].disabled = false;
						}else{
							cmbColl[s].removeAttribute("attStayDisabled");
						}
					}
					//oNewSpan.detachEvent("onclick",divContent_onClick);
					oNewSpan.removeNode(true);
					oNewSpan = "";
		}
}

function divContent_onClick(){
	window.event.cancelBubble=true; 
	window.event.returnValue=false;
}

function disableButtonBar(bStatus){
	btnsBar = window.parent.document.getElementById(window.name).submitWindow.document.getElementById("divContent");
	var btnsColl = btnsBar.getElementsByTagName("BUTTON");
	var btnsCollLen = btnsColl.length;
		if (bStatus==true){
			for(var x=0;x<btnsCollLen;x++){
				if(btnsColl[x].disabled==false){
					btnsColl[x].disabled = true;
				}else{
					btnsColl[x].setAttribute("attStayDisabled",true);
				}
			}
		}else{
			for(var x=0;x<btnsCollLen;x++){
				if(btnsColl[x].attStayDisabled != true){
					btnsColl[x].disabled = false;
				}else{
					btnsColl[x].removeAttribute("attStayDisabled");
				}
			}
		}
}
</script>