
<%@page import="biz.statum.apia.utils.AES"%><%@page import="com.dogma.document.DocumentsUtil"%><%@page import="com.dogma.UserData"%><%@ page import = "com.dogma.vo.*"%><%@ page import	= "com.dogma.bean.*"%><%@ page import	= "com.dogma.util.DownloadUtil"%><%@ page import = "javax.activation.*"%><%@ page import = "java.io.*"%><%@ page import = "java.util.*"%><%	
	out.clear();
	
try{

	String salt = "12345678910111213141516171819200";
	String iv	= "12345678910111213141516171819200";
	String strDocId = request.getParameter("docId");
	String data = AES.decrypt(strDocId, "APIA",salt,iv);
	String[] arr = data.split("-");
	
	long timestamp = Long.valueOf(arr[0]);
	String user = arr[1];
	Integer docId = Integer.valueOf(arr[2]);
	
	UserData uData = new UserData();
	uData.setUserId(user);
	
	ServletOutputStream outs = response.getOutputStream();

	response.setContentType("application/force-download"); 
	
	if(timestamp!=0 && System.currentTimeMillis() > timestamp){ //verificar si paso el tiempo de vida
		response.setHeader("Content-Disposition", "attachment; filename=UnavailableDocument");
	} else {
		DocumentVo docVo = DocumentsUtil.getInstance().getDocumentDownload(new Integer(request.getParameter("envId")), docId, uData);
		if (docVo == null || docVo.getDocName() == null){
			response.setHeader("Content-Disposition", "attachment; filename=ERROR");
		} else {
			String sourceFile = docVo.getTmpFilePath();
			String fileName = docVo.getDocName();
			fileName = fileName.replaceAll(" ","_");
		
			response.setHeader("Content-Disposition", "attachment; filename=" + fileName);
		
// 			try {
			
			FileInputStream in = new FileInputStream(sourceFile);
		
			byte[] buffer = new byte[8 * 1024];
			int count = 0;
			do {
				outs.write(buffer, 0, count);
				count = in.read(buffer, 0, buffer.length);
			} while (count != -1);
		
			in.close();
			outs.close();
		
			//Borramos el documento del dir temporal
			File docFileFrom = new File(sourceFile);
			docFileFrom.delete();
		
// 			} catch (Exception e) {
// 				e.printStackTrace();
// 				response.setHeader("Content-Disposition", "attachment; filename=UnavailableDocument");
// 			}
		}
	}
}catch(Exception e){
	e.printStackTrace();
	response.setHeader("Content-Disposition", "attachment; filename=UnavailableDocument");
}
%>