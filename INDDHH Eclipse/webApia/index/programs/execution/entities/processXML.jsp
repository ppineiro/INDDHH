<%@page import="com.dogma.XMLTags"%><%@page import="com.dogma.bean.*"%><%@page import="com.dogma.vo.*"%><%@page import="java.util.*"%><%@page import="com.st.util.StringUtil"%><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.execution.EntInstanceBean"></jsp:useBean><%
	out.clear();
	response.setContentType("text/xml");
	Collection col = dBean.getProcessesForEntity(request,true,false);
	if (dBean != null && !dBean.getHasException()) {
	
		out.print(XMLTags.XML_HEAD);
		out.print(XMLTags.ROWSET_START);

		if (col!=null && col.size()>0) {
			Iterator it = col.iterator();
			ProcessVo proVo = null;
			if (!BusEntityVo.ADMIN_PROCESS.equals(request.getParameter("type"))) {
				out.print(XMLTags.ROW_START);
				out.print(XMLTags.COL_START);out.print(XMLTags.COL_END);
				out.print(XMLTags.COL_START);out.print(XMLTags.COL_END);
				out.print(XMLTags.ROW_END);			
			}
			while (it.hasNext()) {
				proVo = (ProcessVo) it.next();
				out.print(XMLTags.ROW_START);
				//out.print(XMLTags.COL_START);out.print(StringUtil.encodeString(new String[] {proVo.getProId().toString(), proVo.getProVerId().toString()}));out.print(XMLTags.COL_END);
				out.print(XMLTags.COL_START);out.print(proVo.getProId().toString());out.print(XMLTags.COL_END);
				out.print(XMLTags.COL_START);out.print(StringUtil.escapeXML(proVo.getProName()));out.print(XMLTags.COL_END);
				out.print(XMLTags.ROW_END);
			}
		}
		out.print(XMLTags.ROWSET_END);		
	} else {
		out.print(dBean.getMessagesAsXml(request));
		dBean.clearMessages();
	}
%>