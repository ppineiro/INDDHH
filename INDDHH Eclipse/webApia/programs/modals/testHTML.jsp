<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"><html><head></head><%
if ("true".equals(request.getParameter("isUrl"))){%><body style="background:transparent;" onload="document.location.href='<%=request.getParameter("htmlCode")%>'"></body><%}else{ %><body style="background:transparent;"><%= request.getParameter("htmlCode") %></body><%} %></html>



