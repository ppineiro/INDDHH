
<%@page import="com.dogma.Configuration"%>
 <img src="<%=Configuration.ROOT_PATH %>/stickyImg" />
    <form action="<%=Configuration.ROOT_PATH %>/portal/captchas/captchaSubmit.jsp" method="post">
        <input name="answer" />
    </form>