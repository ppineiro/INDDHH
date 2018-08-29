<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%><!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd"><%@page import="java.io.FileNotFoundException"%><%@page import="java.io.IOException"%><%@page import="java.io.File"%><%@page import="java.io.BufferedReader"%><%@page import="java.io.FileReader"%><%@page import="java.io.FileWriter"%><%@page import="java.io.ByteArrayOutputStream"%><%@page import="java.io.PrintStream"%><%@page import="com.dogma.Configuration"%><html><head><meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1"><% 

	String esperado = "çáéíóàèòì&&";
	StringBuffer sb = new StringBuffer();
	
	String fileName = Configuration.TMP_FILE_STORAGE + "/encoding.txt";
	String newFileName = Configuration.TMP_FILE_STORAGE + "/newFile.txt";
	boolean encontro = true;
	boolean isOk = false;
	boolean genero = false;
	ByteArrayOutputStream bout = new java.io.ByteArrayOutputStream(); 
	try {
		File file = new File(fileName);
		BufferedReader br = new BufferedReader(new FileReader(file));
		String line = null;
		while ((line = br.readLine()) != null) {
			sb.append(line); 
		}
		isOk = esperado.equals(sb.toString());
		FileWriter newFile = new FileWriter(newFileName, false);
		newFile.write(sb.toString());
		genero = true;
		newFile.close();
		br.close();
		
		
		
	} catch (FileNotFoundException fnfe){
		encontro = false;
		fnfe.printStackTrace(new PrintStream(bout));
    } catch (IOException ioe){
		ioe.printStackTrace(new PrintStream(bout));
    	//System.out.println("Error during the read of "+ fileName);
    }
%><title>Insert title here</title></head><body><% 
	if ( !encontro) {	
		%>Error.File not found in <%= fileName %>.<br><pre><%= bout.toString()%></pre><%
	} else {
		%>Ok. File exist in <%= fileName %>.<br><%
	}
	if (isOk) {
		%>OK. File correct read.<br><%
	} else {
		%>ERROR. Content in the file wasn't the expected one.<br>
		Read: <%= sb.toString()%>. <br> Wait: <%= esperado %>. <br><%
	}
	if (genero) {
		%>OK. File generated in <%= newFileName%>.<br><%
	} else {
		%>ERROR. File <%= newFileName%> not generated.<br><%
	}
	%>
	
	Encoding of the Operation System: <%= System.getProperty("file.encoding") %>.
	
	
</body></html>