<%@page import="uy.com.st.adoc.expedientes.solr.Solr"%>
<%@page import="uy.com.st.adoc.expedientes.solr.config.SolrValues"%>
<%
	String query = request.getParameter("q");
	String mode = request.getParameter("m");	
	boolean isOn = true;
	
	if(mode != null){
		if(mode.equals("suggest")){
			String list = "";
			String suggestions = Solr.getSuggestions(query);
			if(suggestions != null && suggestions.length() > 0){
				for(String suggestion: suggestions.split(";")){
					list += String.format(SolrValues.STR_FORMAT_OPTION, suggestion);
				}
			}
			list = String.format(SolrValues.STR_FORMAT_DATALIST, list);
			out.print(list);
		}
		if(mode.equals("query")){
			String start = request.getParameter("s");
			out.print(Solr.globalQuery(query, Integer.valueOf(start)));
		}		
	}
	
	if(mode.equals("ping")){
		isOn = Solr.isSolrOn();
	}
	
	if(!isOn){		
		response.setStatus(1);
	}
%>