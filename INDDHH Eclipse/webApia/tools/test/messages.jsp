<%
 if (session.getAttribute("[TEST_EXCEPTION]") != null)
	out.print("Y");
  else
  	out.print("N");
  
  java.util.Collection col = (java.util.Collection) session.getAttribute("[TEST_MESSAGE]");
  if (col != null) {
  	int i = 0;
  	for (java.util.Iterator it = col.iterator();it.hasNext();) {
		if (i>0) {
			out.print("<BR>");
		}
  		out.print(it.next());
  		i++;
  	}
  }
  session.removeAttribute("[TEST_EXCEPTION]");
  session.removeAttribute("[TEST_MESSAGE]");
%>