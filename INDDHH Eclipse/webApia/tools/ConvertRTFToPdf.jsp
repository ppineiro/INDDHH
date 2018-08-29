<%@page import="com.dogma.Parameters"%>
<%@page import="com.dogma.busClass.object.Parameter"%>
<%@page import="java.io.File"%>
<%@page import="uy.com.st.ConverterPDF.conf.OpenOfficeManager"%>

<%@page import="com.lowagie.text.Document"%>
<%@page import="com.lowagie.text.DocumentException"%>
<%@page import="com.lowagie.text.pdf.PdfWriter"%>

<%@page import="java.io.FileOutputStream"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="java.io.FileNotFoundException"%>
<%@page import="java.io.IOException"%>
<%@page import="com.lowagie.text.rtf.parser.RtfParser"%>




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
		cConversions: <input align="left" type="text" name="countConversions"><br><br>
		fInput: <input align="left" type="text" name="fInput">
		
		<br>
		<br>
		<input type="submit" value="Convert">
		<br>
		<br>
	</form>
	
	<% 
		int countConversions = 0;
		if(request != null){
			if(request.getParameter("countConversions") != null && !request.getParameter("countConversions").equals("")
					&& !request.getParameter("fInput").equals("") && request.getParameter("fInput") != null){
				
				countConversions = Integer.parseInt(request.getParameter("countConversions"));
				fInput = request.getParameter("fInput");
				
			}
		}		
		
		for(int i = 0; i < countConversions; i++){
			Boolean OK = false;
			
			String fOutPut = Parameters.TMP_FILE_STORAGE + "/conversionesdeprueba/" + "conversion"+i+".pdf";
			
			try{
				File inputFile = null;
				File outputFile = null;
				
				//convierto cada archivo enviado
				try{
					inputFile = new File(fInput);
					outputFile = new File(fOutPut);
				
					// create a new document
					Document document = new Document();
				
					try {
					    // create a PDF writer to save the new document to disk
					    PdfWriter writer = PdfWriter.getInstance(document, new FileOutputStream(outputFile));
					    // open the document for modifications
					    document.open();
					    // create a new parser to load the RTF file
					    RtfParser parser = new RtfParser(null);
					    // read the rtf file into a compatible document
					    parser.convertRtfDocument(new FileInputStream(inputFile), document);
					    // save the pdf to disk
					    document.close();
					    System.out.println("Finished");
					} catch (DocumentException e) {
					    e.printStackTrace();
					} catch (FileNotFoundException e) {
					    e.printStackTrace();
					} catch (IOException e) {
					    e.printStackTrace();
					}
					
					OK= true;
				}catch(Exception e){
					e.printStackTrace();
					OK = false;
				}
				//elimino los archivos generados.
				try{
					//outputFile.delete();
				}catch(Exception e){
					e.printStackTrace();
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
		}%>

</body>
</html>