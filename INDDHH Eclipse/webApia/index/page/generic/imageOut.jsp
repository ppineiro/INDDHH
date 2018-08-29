<%@page import="java.io.*" %><%@page import="javax.imageio.*"%><%@page import="java.awt.*"%><%@page import="java.awt.image.BufferedImage"%><jsp:useBean id="imagePickerBean" scope="session" class="biz.statum.apia.web.bean.generic.ImagesBean"></jsp:useBean><%
Image image;
if("addHF".equals(request.getParameter("action"))){
	image=imagePickerBean.getHFImage(request,response);
}else{
	image=imagePickerBean.getFooteredImage(request,response);
}
if("true".equals(request.getParameter("grayScale"))){
	image=imagePickerBean.convertToGrayscale(((BufferedImage)image));
}
response.setContentType("image/png");
try {
	out.clear(); 
	out = pageContext.pushBody();
	OutputStream os = response.getOutputStream();
	if (image != null){
		BufferedImage buff= new BufferedImage(image.getWidth(null), image.getHeight(null), BufferedImage.TYPE_INT_ARGB);
		Graphics g = buff.createGraphics();
		g.drawImage(image, 0, 0, null);
		ImageIO.write(buff,"png",os);
	}
	os.close();
} catch (IOException e) {
	e.printStackTrace();
}
%>