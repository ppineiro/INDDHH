<%response.setCharacterEncoding(com.dogma.Parameters.APP_ENCODING);%>
<%@page import="com.dogma.Parameters"%>
<%@page import="com.dogma.EnvParameters"%>
<%@page import="com.dogma.controller.ThreadData"%>
<%@page import="com.dogma.UserData"%>
<%@page import="com.dogma.Configuration"%>
<%@page import="java.util.Hashtable"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>


<%
response.setHeader("Pragma","no-cache");
response.setHeader("Cache-Control","no-store");
response.setDateHeader("Expires",-1); 

UserData uData = ThreadData.getUserData();
try {
	if (uData!=null) {
		if ((uData.getUserAttributes() != null) && (uData.getUserAttributes().size()>0)) {
			if (uData.getUserAttributes().get("MSG_ERROR") != null) {
				Hashtable<String, String> htError  = (Hashtable<String, String>) uData.getUserAttributes().get("MSG_ERROR");
				if (!htError.get("FRM").equals("") && !htError.get("ATT").equals("") && !htError.get("MSG").equals("")){
					out.clear();
					out.print("OK;" + htError.get("FRM") + ";" + htError.get("ATT") + ";" + htError.get("MSG"));					
				}				
				
				if (!htError.get("DTE").equals("")){
					
					
					 try {
						Date dAct = new Date();
						SimpleDateFormat format = new SimpleDateFormat("dd-M-yyyy hh:mm:ss");
							
						Date dMsg = format.parse(htError.get("DTE"));						
						long seconds = (dAct.getTime()-dMsg.getTime())/1000;
						
						if(seconds>15){
							htError.put("FRM", "");
							htError.put("ATT", "");
							htError.put("MSG", "");
							uData.getUserAttributes().put("MSG_ERROR", htError);
						}
					} catch (Exception e) {													 
					}
					

				}				
			}
		}
	}
} catch (Exception e) {	
}
%>