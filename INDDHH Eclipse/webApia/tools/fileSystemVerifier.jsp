<%@ page language="java" %>
<%@ page import="com.dogma.business.querys.*" %>
<%@ page import="com.dogma.business.*" %>
<%@ page import="com.st.db.dataAccess.*" %>
<%@ page import="com.dogma.dataAccess.*" %>
<%@ page import="com.dogma.vo.*" %>
<%@ page import="com.dogma.vo.gen.*" %>
<%@ page import="com.dogma.dao.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="com.dogma.DogmaException"%>

<%! 
String folderName = null;
String fileName = null;
String copyFileName = null;
String content = null;

public String createFolder(String specialChars) {
	StringBuffer buffer = new StringBuffer();
	
	folderName = Configuration.TMP_FILE_STORAGE + File.separator + "fileSystemVerifierTest" + ((specialChars == null)?"":("_" + specialChars));
	buffer.append("Folder name: " + folderName + "<br>");
	
	File aFolder = new File(folderName);
	buffer.append("Create: " + aFolder.mkdirs() + "<br>");

	if (aFolder.exists() && aFolder.isDirectory()) {
		buffer.append("<b>Test OK</b><br>");
	} else {
		buffer.append("<b>Test <font color=\"red\">NOT OK</font></b><br>");
		folderName = null;
	}
	
	return buffer.toString();
}

public String createFile(String specialChars) {
	StringBuffer buffer = new StringBuffer();
	
	if (folderName != null) {
		fileName = folderName + File.separator + "fileSystemVerifierFile" + ((specialChars == null)?"":("_" + specialChars)) + ".txt";
		buffer.append("File name: " + fileName + "<br>");
		
		File aFile = new File(fileName);
		try {
			buffer.append("Create: " + aFile.createNewFile() + "<br>");
		} catch (IOException e) {
			buffer.append("Error while creating: " + e.getMessage() + "<br>");
		}
		
		if (aFile.exists() && aFile.isFile() && aFile.canRead()) {
			buffer.append("<b>Test OK</b><br>");
		} else {
			buffer.append("<b>Test <font color=\"red\">NOT OK</font></b><br>");
			folderName = null;
		}
	}
	
	return buffer.toString();
}

public String appendContent(String specialChars) {
	StringBuffer buffer = new StringBuffer();
	if (folderName != null && fileName != null) {
		content = "Content to write in the file." + ((specialChars == null)?"":("Special chars: " + specialChars));
		buffer.append("Content: " + content + "<br>");
		
		try {
			File aFile = new File(fileName);
			if (aFile.exists() && aFile.canWrite()) {
				FileUtil.appendFile(content,fileName);
				buffer.append("<b>Test OK</b><br>");
			} else if (! aFile.exists()) {
				buffer.append("<b>Test <font color=\"red\">NOT OK</font></b>. Error: file does not exists<br>");
			} else {
				buffer.append("<b>Test <font color=\"red\">NOT OK</font></b>. Error: cant acces<br>");
			}
		} catch (IOException e) {
			buffer.append("<b>Test <font color=\"red\">NOT OK</font></b>. Error: " + e.getMessage() + "<br>");
		}
	}
	
	return buffer.toString();
}

public String readContent() {
	StringBuffer buffer = new StringBuffer();
	
	if (folderName != null && fileName != null && content != null) {
		BufferedReader input = null;
		try {
			input = new BufferedReader( new FileReader(new File(fileName)) );
			String line = input.readLine();
			if (line.indexOf(content) != -1) {
				buffer.append("<b>Test OK</b><br>");
			} else {
				buffer.append("<b>Test <font color=\"red\">NOT OK</font></b>. Error: content not found<br>");
			}
		} catch (FileNotFoundException e) {
			buffer.append("<b>Test <font color=\"red\">NOT OK</font></b>. Error: " + e.getMessage() + "<br>");
			
		} catch (IOException e) {
			buffer.append("<b>Test <font color=\"red\">NOT OK</font></b>. Error: " + e.getMessage() + "<br>");
			
		} finally {
			if (input != null) {
				try {
					input.close();
				} catch (Exception e) {
				}
			}
		}
	}
	
	return buffer.toString();
}

public String copyfile(String specialChars) {
	StringBuffer buffer = new StringBuffer();
	
	if (folderName != null && fileName != null && content != null) {
		copyFileName = folderName + File.separator + "copy_fileSystemVerifierFile" + ((specialChars == null)?"":("_" + specialChars)) + ".txt";
		buffer.append("File name: " + copyFileName + "<br>");
		
		BufferedReader input = null;
		
		try {
			FileUtil.copyFile(fileName,copyFileName, false);
			buffer.append("Copy done<br>");
			
			buffer.append("Reading content<br>");
			input = new BufferedReader( new FileReader(new File(copyFileName)) );
			String line = input.readLine();
			if (line.indexOf(content) != -1) {
				buffer.append("<b>Test OK</b><br>");
			} else {
				buffer.append("<b>Test <font color=\"red\">NOT OK</font></b>. Error: content not found<br>");
			}
		} catch (FileNotFoundException e) {
			buffer.append("<b>Test <font color=\"red\">NOT OK</font></b>. Error: " + e.getMessage() + "<br>");

		} catch (IOException e) {
			buffer.append("<b>Test <font color=\"red\">NOT OK</font></b>. Error: " + e.getMessage() + "<br>");
			
		} finally {
			if (input != null) {
				try {
					input.close();
				} catch (Exception e) {
				}
			}
		}
	}
	
	return buffer.toString();
}

public String deleteFile() {
	StringBuffer buffer = new StringBuffer();
	
	if (copyFileName != null) {
		buffer.append("Delete file: " + copyFileName + "<br>");
		File aFile = new File(copyFileName);
		
		if (aFile.exists()) {
			buffer.append("Deleted: " + aFile.delete() + "<br>");
			
			if (! aFile.exists()) {
				buffer.append("<b>Test OK</b><br>");
			} else {
				buffer.append("<b>Test <font color=\"red\">NOT OK</font></b>. Error: file exists<br>");
			}
		} else {
			buffer.append("<b>Test <font color=\"red\">NOT OK</font></b>. Error: file does not exists<br>");
		}
	}
	
	if (fileName != null) {
		buffer.append("Delete file: " + fileName + "<br>");
		File aFile = new File(fileName);

		if (aFile.exists()) {
			buffer.append("Deleted: " + aFile.delete() + "<br>");
			
			if (! aFile.exists()) {
				buffer.append("<b>Test OK</b><br>");
			} else {
				buffer.append("<b>Test <font color=\"red\">NOT OK</font></b>. Error: file exists<br>");
			}
		} else {
			buffer.append("<b>Test <font color=\"red\">NOT OK</font></b>. Error: file does not exists<br>");
		}
	}
	
	return buffer.toString();
}

public String deleteFolder() {
	StringBuffer buffer = new StringBuffer();
	
	if (folderName != null) {
		buffer.append("Delete file: " + folderName + "<br>");
		File aFolder = new File(folderName);

		if (aFolder.exists()) {
			buffer.append("Deleted: " + aFolder.delete() + "<br>");
			
			if (! aFolder.exists()) {
				buffer.append("<b>Test OK</b><br>");
			} else {
				buffer.append("<b>Test <font color=\"red\">NOT OK</font></b>. Error: folder exists<br>");
			}
		} else {
			buffer.append("<b>Test <font color=\"red\">NOT OK</font></b>. Error: folder does not exists<br>");
		}
	}
	
	return buffer.toString();
}

%>

<%@page import="com.dogma.Parameters"%>

<%@page import="com.st.util.FileUtil"%>
<%@page import="com.dogma.Configuration"%>
<html>
<head>
</head>
<body>
Verificación de datos "El flaco"®... (powered by Pf)<br>
Storage: <%= Parameters.TMP_FILE_STORAGE %><br>
Use: ...?chars=.... to test special chars<br>

<%
String chars = request.getParameter("chars");
if (chars != null && chars.length() == 0) chars = null; %>
<b>Tests</b><hr>

<b>Create folder</b>:<br><%= this.createFolder(chars) %><br>
<b>Create file</b>:<br><%= this.createFile(chars) %><br>
<b>Append content</b>:<br><%= this.appendContent(chars) %><br>
<b>Read content</b>:<br><%= this.readContent() %><br>
<b>Copy file</b>:<br><%= this.copyfile(chars) %><br>
<b>Delete file</b>:<br><%= this.deleteFile() %><br>
<b>Delete folder</b>:<br><%= this.deleteFolder() %><br>
	
</body>
</html>
