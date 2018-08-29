<%@page import="com.dogma.Parameters"%><%@page import="com.dogma.XMLTags"%><%@page import="com.dogma.bean.*"%><%@page import="com.dogma.vo.*"%><%@page import="java.util.*"%><%@page import="com.st.util.StringUtil"%><%
response.setHeader("Pragma","no-cache");
response.setHeader("Cache-Control","no-store");
response.setDateHeader("Expires",-1); 
response.setCharacterEncoding(Parameters.APP_ENCODING);
response.setContentType("text/xml");
DocumentBean dBean = ((DogmaAbstractBean) session.getAttribute("dBean")).getDocumentBean(request);
out.clear();
if (dBean != null && !dBean.getHasException()) {
	Collection docs = dBean.getDocuments();
	out.print(XMLTags.XML_HEAD);
	out.print(XMLTags.ROWSET_START);
	if (docs != null) {
		Iterator it = docs.iterator();
		DocumentVo docVo = null;
		while (it.hasNext()) {
			docVo = (DocumentVo) it.next();
			if (docVo.canRead()) {
				boolean othUsrLock = (docVo.getDocLock() != null && !docVo.getDocLock().getUsrLogin().equals(dBean.getUserData().getUserId()));
				out.print(XMLTags.ROW_START);
				out.print(XMLTags.COL_START);out.print(docVo.getDocId().toString());out.print(XMLTags.COL_END);
				out.print(XMLTags.COL_START);
				if (docVo.getDocLock() != null) {
					if (othUsrLock) {
						out.print(docVo.getDocLock().getUsrLogin());
					} else {
						out.print("[true]");
					}
				}
				out.print(XMLTags.COL_END);
				out.print(XMLTags.COL_START);out.print(docVo.canModify() && !othUsrLock);out.print(XMLTags.COL_END);
				out.print(XMLTags.COL_START);out.print(StringUtil.escapeXML(docVo.getDocName()));out.print(XMLTags.COL_END);
				out.print(XMLTags.COL_START);
				if (docVo.getDocSize() != null) {
					out.print(dBean.fmtFileSize(docVo.getDocSize().intValue()));
				}
				out.print(XMLTags.COL_END);
				out.print(XMLTags.COL_START);out.print(StringUtil.escapeXML(docVo.getRegUser()));out.print(XMLTags.COL_END);
				out.print(XMLTags.COL_START);out.print(StringUtil.escapeXML(dBean.fmtDate(docVo.getRegDate())));out.print(XMLTags.COL_END);
				
				out.print(XMLTags.COL_START);out.print(StringUtil.escapeXML(docVo.getDocDesc()));out.print(XMLTags.COL_END);
				
				out.print(XMLTags.ROW_END);
			}
		}
	}
	out.print(XMLTags.ROWSET_END);
} else {
	out.print(dBean.getMessagesAsXml(request));
	dBean.clearMessages();
}
%>