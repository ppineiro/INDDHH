<jsp:useBean id="dBean" scope="session" class="com.dogma.bean.configuration.WsBean"></jsp:useBean><%response.setContentType("text/xml");
out.clear();
out.print(dBean.getWSDL(request.getParameter("wsName"), request));%>