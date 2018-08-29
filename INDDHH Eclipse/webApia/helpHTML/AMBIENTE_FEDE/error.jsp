<%@page import="com.st.util.labels.LabelManager"%><%@include file="../../../page/includes/startInc.jsp" %><html><head><meta http-equiv="Content-Type" content="text/html; charset=UTF-8"><link href="css/estilo.css" rel="stylesheet" type="text/css"><link href="css/jquery-ui.css" rel="stylesheet" type="text/css"><link rel="stylesheet" href="css/style.css" /><style type="text/css">
    	#errMsg {
    		margin-left: 20px;
    		margin-top: 5px;
    		font-style: italic;
    		font-size: 8.5pt;
    		font-family: Tahoma,Verdana,Arial !important;
    		color: #464646
    	}
    	#errMsg strong {
    		
    	}
    </style></head><body><p id="errMsg"><%=LabelManager.getName(Integer.parseInt(request.getParameter("lblId")), Integer.parseInt(request.getParameter("langId")), "msgNoProCatalogDoc1")%><br/><%=LabelManager.getName(Integer.parseInt(request.getParameter("lblId")), Integer.parseInt(request.getParameter("langId")), "msgNoProCatalogDoc2").replace("<TOK1>", " <strong>helpHTML/" + request.getParameter("envName") + "</strong>")%></p></body></html>
