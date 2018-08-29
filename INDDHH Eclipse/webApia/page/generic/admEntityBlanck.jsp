<%@ taglib prefix="system"	uri="/WEB-INF/system-tags.tld" %><%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%><!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd"><html lang="<%=biz.statum.apia.web.bean.BasicBeanStatic.getUserDataStatic(request).getLangCode()%>"><head><meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1"><script type="text/javascript" src="<system:util show="context" />/js/mootools-core-1.4.5-full-compat.js"></script><script type="text/javascript" src="<system:util show="context" />/js/mootools-more-1.4.0.1-compat.js"></script><script type="text/javascript">
	if(window.frameElement && window.frameElement.hasClass('modal-content')) {
		var errMsg = '<%= request.getAttribute("errorMsg")%>';
		if (errMsg=='null') errMsg=null;

		window.frameElement.fireEvent('closeModal', [null, errMsg]);
	}
</script></head><body></body></html>