<%@page import="javax.imageio.ImageIO"%><%@page import="java.awt.Graphics2D"%><%@page import="java.awt.image.BufferedImage"%><%@page import="java.awt.Image"%><%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%><%@page import="org.jfree.chart.JFreeChart"%>.
<%
if(request.getHeader("User-Agent").indexOf("Firefox")<0){
	response.setHeader("Pragma","public no-cache");
}else{	
	response.setHeader("Pragma","no-cache");
}
response.setHeader("Cache-Control","no-store");
response.setDateHeader("Expires",-1); 
response.setContentType("image/jpeg");
out.clear();//no colocar enters ni nada antes del tag system:edit, sino no es tomado bien el xml !!!!

JFreeChart chart = (JFreeChart) request.getAttribute("jfreeChart");
int w = 450;
int h = 300;
Image img = chart.createBufferedImage(w,h);

BufferedImage bi = new BufferedImage(w, h, BufferedImage.TYPE_INT_RGB);
Graphics2D g2d = bi.createGraphics();
g2d.drawImage(img, 0, 0, w, h, null);

java.io.OutputStream outb=response.getOutputStream();
ImageIO.write( bi, "jpg", outb);
outb.close();
%>