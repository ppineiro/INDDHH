<%response.setCharacterEncoding(com.dogma.Parameters.APP_ENCODING);
response.setContentType("text/xml");
System.out.println(request.getAttribute("deskModel"));
out.clear();
out.print(request.getAttribute("deskModel"));%>