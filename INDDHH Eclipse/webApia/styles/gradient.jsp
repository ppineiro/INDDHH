<%@page import="java.io.*" %><%@page import="java.awt.*"%><%@page import="javax.imageio.*"%><%!
Color getColor(String color){
	String r=color.substring(0,2);
	String g=color.substring(2,4);
	String b=color.substring(4,6);
	return new Color(Integer.parseInt(r,16),Integer.parseInt(g,16),Integer.parseInt(b,16));
}

Graphics2D getGraphics2D(String [] colors,int width, int height,String gradientType,Graphics graphic){
	Graphics2D g= (Graphics2D)graphic;
	for(int i=0;i<colors.length;i++){
		if(i<(colors.length-1)){
			Color colorStart=getColor(colors[i]);
			Color colorEnd=getColor(colors[i+1]);
			if("v".equals(gradientType)){
				GradientPaint paint=new GradientPaint( 0 , ((height/(colors.length-1))*i) , colorStart , 0 ,((height/(colors.length-1))*(i+1)) , colorEnd);
				g.setPaint(paint);
				g.fillRect(0 , ((height/(colors.length-1))*i) , width , ((height/(colors.length-1))*(i+1)) );
			}else{
				GradientPaint paint=new GradientPaint( ((width/(colors.length-1))*i) , 0 , colorStart , ((width/(colors.length-1))*(i+1)) , 0 ,colorEnd);
				g.setPaint(paint);
				g.fillRect( ((width/(colors.length-1))*i) , 0 , ((width/(colors.length-1))*(i+1)) , height );
			}
		}
	}
	return g;
}
%><%
int width=new Integer(request.getParameter("width")).intValue();
int height=new Integer(request.getParameter("height")).intValue();
String colorsStr=request.getParameter("colors");
String [] colors=colorsStr.split(";");
String type=request.getParameter("type");
java.awt.image.BufferedImage buffer = new java.awt.image.BufferedImage(width,height,java.awt.image.BufferedImage.TYPE_INT_RGB);
Graphics graphic = buffer.createGraphics();
Graphics2D g=getGraphics2D(colors,width,height,type,graphic);
response.setContentType("image/png");
out.clear(); 
out = pageContext.pushBody();
OutputStream os = response.getOutputStream();
ImageIO.write(buffer, "png", os);
os.close();
%>