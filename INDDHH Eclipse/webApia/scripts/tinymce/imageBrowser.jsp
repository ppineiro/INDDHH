<%@page import="com.dogma.vo.*"%><%@include file="../../../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../../../components/scripts/server/headInclude.jsp" %></head><body><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titImg")%></TD><TD></TD></TR></TABLE><DIV id="divContent" class="divContent"><form id="frmMain" name="frmMain" method="POST" onSubmit="return false"></form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><COL class="col3"><TR><TD></TD><TD align="center" style="width:100%"></TD><TD align="rigth"><button type="button" onclick="btnConf_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnCon")%>" title="<%=LabelManager.getToolTip(labelSet,"btnCon")%>"><%=LabelManager.getNameWAccess(labelSet,"btnCon")%></button><button type="button" onclick="btnExit_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><%@include file="../../../../components/scripts/server/endInc.jsp" %><script language="javascript" type="text/javascript" src="<%=Parameters.ROOT_PATH%>/scripts/tiny_mce/jscripts/tiny_mce/tiny_mce_popup.js"></script><script language="javascript">
function btnExit_click() {
	window.returnValue=null;
	window.close();
}

function btnConf_click(){
alert(123);
	// Here comes a bit of my own code to show you how to transfer your image data into tinyMCE's popup:
	// get the image's URL from own popup
	url = "http://www.notebook.com.uy/images/imagecache/150x150_Toshiba_satellite_U405.jpg";

	win = tinyMCE.getWindowArg("window");
	// win now contains the same reference to tinyMCE's popup as had our callback function earlier.

	// Here comes the actual transfer of your image's url into tinyMCE's dialogue window.
	win.document.getElementById("src").value = url;

	// Make tinyMCE complete the image data fields for width and length.
	win.getImageData();
	self.close();
}
</script>
			