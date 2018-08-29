<%
} catch (Exception e) {
	out.clear();
	com.dogma.bean.DogmaAbstractBean.logError(request, e);
	out.print("*-- ERROR : " + e.getMessage() + " --*");
}
%>
