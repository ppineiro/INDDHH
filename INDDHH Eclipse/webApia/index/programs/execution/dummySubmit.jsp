	<jsp:useBean id="xBean" scope="session" class="com.dogma.bean.ViewEntityFormsBean"></jsp:useBean><%String msg = xBean.getMessagesAsText(request,""); %><body><textarea id="txtMsg"><%=msg%></textarea></body><script language=javascript>
window.onload=function(){
		 if(document.getElementById("txtMsg").value.length==0){ 
			window.parent.frames[0].mdlClose()
		 } else { 
			alert(document.getElementById("txtMsg").value);
		 } 
}
</script>