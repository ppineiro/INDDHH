<%@page import="java.util.ArrayList"%>
<%@page import="java.util.HashMap"%>
<%@page import="st.constants.Labels"%>
<%@page import="st.constants.Values"%>
<%@page import="st.stars.Stars"%>
<%@page import="com.dogma.UserData"%>
<%@page import="com.dogma.controller.ThreadData"%>
<%
String param_score		= request.getParameter(Labels.PAR_STARS_SCORE);
String param_titles		= request.getParameter(Labels.PAR_STARS_TITLES);
String param_update		= request.getParameter(Labels.PAR_STARS_UPDATE);
String param_frmName	= request.getParameter(Labels.PAR_STARS_FRM_NAME);
String param_attName	= request.getParameter(Labels.PAR_STARS_ATT_NAME);
String param_tabId		= request.getParameter(Labels.PAR_STARS_TAB_ID);
String param_tokenId	= request.getParameter(Labels.PAR_STARS_TOKEN_ID);
String param_sessionId	= request.getParameter(Labels.PAR_STARS_SESSION_ID);

int score = 0;
if(param_score != null && param_score.length() > 0){
	score = Integer.valueOf(param_score);
}

ArrayList<String> names = new ArrayList<String>();
if(param_titles != null && param_titles.length() > 0){
	if(param_titles.indexOf(Values.STARS_TITLE_SEPARATOR) != -1){
		String[] arrNames = param_titles.split(Values.STARS_TITLE_SEPARATOR);
		for(String name: arrNames){
			if(name != null && name.length() > 0){
				names.add(name);
			}
		}
	}
}

boolean update = false;
if(param_update != null && param_update.length() > 0){
	update = Boolean.valueOf(param_update);
}

String frmName = "";
if(param_frmName != null && param_frmName.length() > 0){
	frmName = param_frmName;
}

String attName = "";
if(param_attName != null && param_attName.length() > 0){
	attName = param_attName;
}

String sessionId = "";
if(param_sessionId != null && param_sessionId.length() > 0){
	sessionId = param_sessionId;
}

String tabId = "";
if (param_tabId != null && param_tabId.length() > 0){
	tabId = param_tabId;
}

String tokenId = "";
if(param_tokenId != null && param_tokenId.length() > 0){
	tokenId = param_tokenId;
}
String TAB_ID_REQUEST = String.format(Values.STARS_FORMAT_TAB_ID_REQUEST, tabId, tokenId, sessionId);

UserData uData = ThreadData.getUserData();


if(update){
	String key = Values.STARS_SCORE_NAME + tabId;
	if(uData.getUserAttributes() == null){
		uData.setUserAttributes(new HashMap<String, Object>());
	}
	uData.getUserAttributes().put(key, param_score);
}else{
	Stars stars = new Stars(names, score);
%>
<html>
<head>
<meta charset="UTF-8">
<title>Rating</title>
<link href="../css/stars/stars.css" rel="stylesheet">
<script>
	var TAB_ID_REQUEST	= "<%=TAB_ID_REQUEST%>";
	var PARAM_UPDATE	= "<%=Labels.PAR_STARS_UPDATE%>";
	var PARAM_SCORE		= "<%=Labels.PAR_STARS_SCORE%>";
	var PARAM_ATTNAME	= "<%=attName%>";
	var PARAM_FRMNAME	= "<%=frmName%>";
	
	//Función que guarda el valor
	function setValue(value) {
		window.parent.ApiaFunctions.getForm(PARAM_FRMNAME).getField(PARAM_ATTNAME).setValue(value);
		
		var xmlhttp;

		if (window.XMLHttpRequest) {
			xmlhttp = new XMLHttpRequest();
		} else {
			xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
		}

		xmlhttp.open("POST", "stars.jsp", true);
		xmlhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
		xmlhttp.send(PARAM_UPDATE + "=true&" + PARAM_SCORE + "=" + value + TAB_ID_REQUEST);
	}
</script>
</head>
<body><%=stars.toString()%></body>
</html>
<% } %>