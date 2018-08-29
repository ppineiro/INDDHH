<%
String str = com.dogma.DogmaConstants.APIA_VERSION;
str += "|" + com.dogma.Configuration.DB_IMPLEMENTATION;
str += "|" + com.dogma.Configuration.DB_URL;
str += "|" + com.dogma.Configuration.DB_USR;
str += "|" + com.dogma.Configuration.DB_PWD;
out.print(com.st.util.CryptUtils.encript(str));%>