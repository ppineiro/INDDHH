<%@page import="java.io.BufferedWriter"%>
<%@page import="java.io.ByteArrayOutputStream"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="java.io.FileWriter"%>
<%@page import="java.io.PrintWriter"%>
<%@page import="com.dogma.Parameters"%>
<%@page import="com.dogma.busClass.object.Parameter"%>
<%@page import="java.io.File"%>
<%@page import="uy.com.st.ConverterPDF.conf.OpenOfficeManager"%>
<%@page import="java.util.UUID"%>
<%@page import="uy.com.st.adoc.expedientes.caratula.Constantes"%>
<%@page import="uy.com.st.adoc.expedientes.util.Util"%>

<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
String fInput = "";
String s = request.getParameter("countConversions");
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Proof Mass Conversion To PDF</title>
</head>
<body>
	<form action="" method="post">
		cConversions: <input align="left" type="text" name="countConversions"><br>		
		<br>
		<br>
		<input type="submit" value="Convert">
		<br>
		<br>
	</form>
	
	<% 
		try{
			int countConversions = 0;
			if(request != null){
				if(request.getParameter("countConversions") != null && !request.getParameter("countConversions").equals("")){				
					countConversions = Integer.parseInt(request.getParameter("countConversions"));							
				}
			}		
			
			Util oUtil = new Util();
			
			for(int i = 0; i < countConversions; i++){
				Boolean OK = false;
				
				String fOutPut = Parameters.TMP_FILE_STORAGE + "/conversionesdeprueba/" + "conversion"+i+".pdf";
				
				try{
					File inputFile = null;
					File outputFile = null;
					
					fInput = Parameters.TMP_FILE_STORAGE + Constantes.PATH_DESTINO_EXP_GENERADOS_REL + "ArchivoPruebaEntrada" + UUID.randomUUID() + ".txt";
					
					if (!oUtil.existeArchivo(fInput)){
						FileWriter oFW = new FileWriter(fInput);
						BufferedWriter oBW = new BufferedWriter(oFW);
						PrintWriter oPW = new PrintWriter(oBW);
						oPW.print("Archivo de Prueba");
						oPW.close();
					}
					
					out.print(i + " - " + fInput + "<br>");
					
					//convierto cada archivo enviado
					try{
						inputFile = new File(fInput);
						outputFile = new File(fOutPut);
						OpenOfficeManager.convertToPDF(inputFile, outputFile);
						OK= true;
					}catch(Exception e){
						OK = false;
					}
					
				}catch(Exception e){
					e.printStackTrace();
					OK = false;
				}
				
				if(OK){
					out.print(i + " - Se convirtió OK");%><br>
				<%}else{
					%><b><%out.print(i + " - Ha ocurrido un error en la conversion.");%></b><br>
				<%}	
			}
		}catch(Exception e){
			e.printStackTrace();
		}%>
</body>
</html>