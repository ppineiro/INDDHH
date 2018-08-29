<%@page import="com.dogma.Parameters"%><%
response.setContentType("text/xml");

StringBuffer result = new StringBuffer();
result.append("<?xml version=\"1.0\" encoding=\"" + Parameters.APP_ENCODING + "\"?><result>");

String strCookie = request.getParameter("result");
 
int cantCharacters = 4000;
if(strCookie.length() > cantCharacters){
        
	double parts = Math.ceil((float)strCookie.length() / (float)cantCharacters);
	String str = strCookie;
	String tmp;

	result.append("<parts>"+Double.valueOf(parts).intValue()+"</parts>");
	
	//luego se recorren los fragmentos para guardarlos en su indice
	for(int x=0;x<parts;x++) {
		if (str.length() > cantCharacters) {
        	tmp = str.substring(0,cantCharacters);
			str = str.substring(cantCharacters,str.length());
		} else {
			tmp = str;
		}
		result.append("<part>"+tmp+"</part>");
	}
	 
	
} else {
	result.append("<parts>1</parts>");
	result.append("<part>"+strCookie+"</part>");
}


result.append("</result>");

out.clear();
out.write(result.toString());
 %>