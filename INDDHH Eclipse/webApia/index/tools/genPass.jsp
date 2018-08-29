(call with <b>URL?pass=<u>password</u></b> for db password)<br>
(call with <b>URL?user=<u>user</u>&pass=<u>password</u></b> for user password)
<br><br>

Pass : <%=request.getParameter("pass")%><br>
Crypt Pass : <%=(request.getParameter("pass") != null)?com.st.util.CryptUtils.encript(request.getParameter("pass")):""%><BR>
Decrypt Pass : <%=(request.getParameter("pass") != null)?com.st.util.CryptUtils.decript(request.getParameter("pass")):""%><BR>

<br><br>

User: <%=request.getParameter("user")%><br>
Password: <%=(request.getParameter("user") != null && request.getParameter("pass") != null)?com.st.util.CryptUtils.makePasswordDigest(request.getParameter("user"), request.getParameter("pass")):""%><br>


