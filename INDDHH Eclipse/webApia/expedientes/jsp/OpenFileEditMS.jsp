<%@page import="uy.com.st.webdav.ActionController"%>
<%@page import="java.util.ArrayList"%>
<!DOCTYPE html>

<html lang="en" xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta charset="utf-8" />
	<title></title>
	<script type="text/javascript" src="ITHitWebDAVClient.js" ></script>
</head>

<body>
	<script type="text/javascript">
		function edit(nameFile) {
			
			var sDocumentUrl = "http://localhost:8880/Apia/WebDav/Archivo4.docx"; // this must be full path
			/*var oNs = ITHit.WebDAV.Client.DocManager;
			if (oNs.IsMicrosoftOfficeDocument(sDocumentUrl)) {
			    oNs.MicrosoftOfficeEditDocument(sDocumentUrl, protocolInstallCallback);            
			} else {
			    oNs.DavProtocolEditDocument(sDocumentUrl, null, protocolInstallCallback);
			}*/
			
			//ITHit.WebDAV.Client.DocManager.EditDocument("http://localhost:8980/ApiaPrueba3104/tools/BorradorSistemaConMuchosNombres.docx", "/", protocolInstallCallback);
			var sDocumentUrlBase = "http://localhost:8880/Apia/WebDav/";
			ITHit.WebDAV.Client.DocManager.EditDocument(sDocumentUrlBase + nameFile, "/", protocolInstallCallback);
			//ITHit.WebDAV.Client.DocManager.DavProtocolEditDocument(sDocumentUrlBase + nameFile, "/", protocolInstallCallback);
		}
		
		// Called if protocol handler is not installed
		function protocolInstallCallback(message) {
			var installerFilePath = "http://localhost:8880/Apia/tools/Plugins/" + ITHit.WebDAV.Client.DocManager.GetInstallFileName();
			if (confirm("This action requires a protocol installation. Select OK to download the protocol installer.")){
				window.open(installerFilePath);
			}
		}
	</script>
	<%
		ActionController.setPathFolderBase("C:/Users/erodriguez/Desktop/WebDev/CarpetaEjemplo");
		ActionController actionController = new ActionController();
		ArrayList<ArrayList<String>> result = actionController.getLstFilesFolder(ActionController.getPathFolderBase());
		for(ArrayList<String> docIter : result){
	%>
		<%=docIter.get(0)%>&nbsp;<input type="button" value="Edit Document" onclick="edit('<%=docIter.get(0)%>')" /> </br>
			
	<%}
		//http://localhost:8880/Apia/WebDav/2013-1-1-1000001/documentoPrueba.docx
		String test = "2013-1-1-1000001/documentoPrueba.docx";
	%>&nbsp;<input type="button" value="Edit Document" onclick="edit('<%=test%>')" /> </br>
</body>
</html>