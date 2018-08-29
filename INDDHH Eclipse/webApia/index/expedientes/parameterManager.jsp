<?xml version="1.0" ?>
<%@page import="java.util.*"%>
<%@page import="java.net.*"%>
<%@page import="uy.com.st.adoc.expedientes.conf.*"%>
<html>
    <head>
        <link rel="stylesheet" type="text/css" href="style.css" title="Style"/>
        <title>ApiaDocumentum Parameter Manager</title>   
        <script type="text/javascript">
			function checkForm() {
				var updation = document.getElementById("updationInput").value="update!";
                return true;
            }
 
            
        </script>       
    </head>
    <body>
        <div id="converter-header"><h1>ApiaDocumentum Parameter Manager</h1></div> 
        <form action="" method="post" >    
	     <!--    <-%
	        //update parameters from request into database
			Enumeration parNames = request.getParameterNames();
	        String result = "";
			if("update!".equals(request.getParameter("updation"))){
				try{
					boolean some = false;
					while(parNames.hasMoreElements()){
						String parName = (String)parNames.nextElement();
						if(!"updation".equals(parName)){
							String parValue = request.getParameter(parName);
							ConfigurationManager.updateParameterValue(parName,parValue);
							some = true;
						}
					}
					if(some)result = "Parameters updated successfully!";
				}catch(Exception e){
					result = "Parameter update failed! "+e.getMessage();
				}
				%><b><-%=result%-></b><-%
			} 
			//load parameters from database
			 StringBuffer rows = new StringBuffer();
			 ArrayList<ParameterVo> params = ConfigurationManager.getParameters();
			for(int i = 0; params.size() > i; i++){
				ParameterVo param = params.get(i);
				String row = "<tr><td>"+param.getId()+"</td>"+
				"<td><input type='input' size='85' name='"+param.getId()+"' value='"+param.getValue()+"' width = '500px'/></td></tr>";
				rows.append(row);
			}
			
			%->
                <table class="subform-content">
                	<tr><td><br><input type="hidden" id="updationInput" name="updation"/></td></tr>
					<-%=rows.toString()%->
					<tr><td><br></td></tr>            
                </table> 
			<input type="submit" value="Submit" onclick="return checkForm();"/>-->
			En deshuso. Para administrar los parámetros de ApiaDocumentum debe acceder a la funcionalidad "Parámetros de ApiaDocumentum" en el menú del ambiente donde trabaja.
        </form>
    </body>    
</html>
<%
//	}
%>
