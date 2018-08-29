<% response.setCharacterEncoding(com.dogma.Parameters.APP_ENCODING); %>
<%@page import="uy.com.st.adoc.expedientes.helper.HelperFirma"%>
<%@page import="uy.com.st.adoc.expedientes.domain.Firma"%>
<%@page import="com.dogma.Parameters"%>
<%@page import="com.dogma.UserData"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.HashMap"%>
<%@page import="uy.com.st.adoc.expedientes.conf.ConfigurationManager"%>
<%@page import="uy.com.st.adoc.expedientes.conf.ConfigurationApplet"%>
<%@page import="java.net.URLDecoder"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@page import="com.dogma.controller.ThreadData"%>
<%@page import="uy.com.st.adoc.expedientes.generic.ControlSesionesUsuario"%>
<%
	// NO DEJAMOS QUE LA PAGINA SE CACHEE
	response.setHeader("Pragma", "no-cache");
	response.setHeader("Cache-Control", "no-store");
	response.setDateHeader("Expires", -1);
%>
<%
	try {
		UserData uData = ThreadData.getUserData();	
		Boolean deshabilitada = ControlSesionesUsuario.controlarClaseEstaDeshabilitada();
		String usrClave = "";
		String tokenId ="";
		String sessionId ="";
		String strDate = ControlSesionesUsuario.getCurrentTimeStamp();    
	    Date fechaActual = ControlSesionesUsuario.parseCurrentTime_Date(strDate);	
		
	    // DEFINO PARAMETROS PROVENIENTES DEL REQUEST
	    HashMap<String, String> parametros = new HashMap<String, String>();
	    parametros.put("clave", request.getParameter("clave").toString());
	    parametros.put("firma", request.getParameter("firma").toString());
	    parametros.put("id", request.getParameter("id").toString());
	    parametros.put("userId", request.getParameter("userId"));
	    parametros.put("tokenId", request.getParameter("tokenId"));
	    parametros.put("envId", request.getParameter("envId"));
	    parametros.put("pkcs7", request.getParameter("pkcs7").toString());
	    parametros.put("TMP_NRO_DOC_A_FIRMAR_STR", request.getParameter("TMP_NRO_DOC_A_FIRMAR_STR"));
	    parametros.put("ENV_NAME", request.getParameter("ENV_NAME"));
	    parametros.put("VERSION_CARATULA_RELACIONADA", request.getParameter("VERSION_CARATULA_RELACIONADA"));
	    parametros.put("JEFATURA", request.getParameter("JEFATURA"));
	    
		if(!deshabilitada){			
			usrClave = parametros.get("userId");
			tokenId = parametros.get("tokenId");
			sessionId = request.getSession().getId();
			Boolean ok =true;
			
			if(ok){						
				if(uData == null){
					System.out.println("La session es NULA!");
				}else{			
					System.out.println("UsuarioAFirmar: "+ parametros.get("userId"));
					System.out.println("TokenId: "+ parametros.get("tokenId"));	
				}
				
				System.out.println("Entro aqui v2!!");

				String clave = parametros.get("clave");
				
				System.out.println("********************************* 1");
				String firma = parametros.get("firma");
				System.out.println("********************************* 2");
				String nombre = parametros.get("id");

				System.out.println("********************************* 3");
				nombre = URLDecoder.decode(nombre, "iso-8859-1");
				System.out.println("********************************* 4");
				clave = URLDecoder.decode(clave, "iso-8859-1");
				System.out.println("********************************* 5");
				firma = URLDecoder.decode(firma, "iso-8859-1");
				System.out.println("********************************* 6");

				Integer envId = Integer.parseInt(parametros.get("envId"));
				System.out.println("********************************* 7");
				
				String pkcs7 = parametros.get("pkcs7");
				System.out.println("********************************* 8");
				
				String nroDocumento = parametros.get("TMP_NRO_DOC_A_FIRMAR_STR");
				System.out.println("********************************* 9");
				
				String env_name = parametros.get("ENV_NAME");
				System.out.println("********************************* 10");
				
				String versionCaratula = parametros.get("VERSION_CARATULA_RELACIONADA");
				System.out.println("********************************* 11");
				
				if (nroDocumento.contains(";")) {
					System.out.println("********************************* 12");
					String[] nrosExp = null;
					System.out.println("********************************* 13");
					nrosExp = nroDocumento.split(";");
					System.out.println("********************************* 14");
					String[] versionsCaratula = versionCaratula.split(";");
					System.out.println("********************************* 15");
					for (int i = 0; i < nrosExp.length ; i++) {
						if (nombre.contains(nrosExp[i])) {
							String usuario = parametros.get("userId");
							String jefatura = parametros.get("JEFATURA");
							
							System.out.println("EXPEDIENTE: " + nrosExp[i]);
							
							System.out
									.println("*********************************************************");
							System.out
									.println("******************GUARDANDO FIRMA NUEVO******************");
							System.out.println("clave: " + clave);
							System.out.println("firma: " + firma);
							System.out.println("nombre: " + nombre);
							System.out.println("nroDocumento: " + nrosExp[i]);
							System.out.println("usuario: " + usuario);
							System.out.println("pkcs7: " + pkcs7);
							System.out.println("jefatura: " + jefatura);
							System.out
									.println("*********************************************************");

							Firma frm = new Firma();

							char a = (char) Integer.parseInt(ConfigurationApplet.CHAR1);
							char b = (char) Integer.parseInt(ConfigurationApplet.CHAR2);

							String sep1 = ConfigurationApplet.STRING1;
							String sep2 = ConfigurationApplet.STRING2;
							String sep3 = ConfigurationApplet.STRING3;

							String strRes1 = a + "";
							String strRes2 = b + "";
							String strRes3 = ConfigurationApplet.CHAR3;

							clave = clave.replaceAll(sep1, strRes1);
							clave = clave.replaceAll(sep2, strRes2);
							clave = clave.replaceAll(sep3, strRes3);

							firma = firma.replaceAll(sep1, strRes1);
							firma = firma.replaceAll(sep2, strRes2);
							firma = firma.replaceAll(sep3, strRes3);
							
							pkcs7=pkcs7.replace(ConfigurationApplet.STRING1, "");
							pkcs7=pkcs7.replace(ConfigurationApplet.STRING2, "");
							pkcs7=pkcs7.replace(ConfigurationApplet.STRING3, "+");
							
							System.out.println("pkcs7 vers 2: " + pkcs7);
							
							System.out.println("env_id: " + env_name);
							System.out.println("version Caratula: " + Integer.parseInt(versionsCaratula[i]));
							frm.setClavePublica(clave);
							frm.setFirma(firma);
							frm.setEnvName(env_name );
							frm.setVersionCaratula(Integer.parseInt(versionsCaratula[i]));
							
							//por ahora no se usa
							frm.setIdArchivo(0d);
							//por ahora no se usa
							frm.setNombArchivo(nombre);
							frm.setNroDoc(nrosExp[i]);
							frm.setUsuario(usuario);
							frm.setJefatura(jefatura);
							frm.setPkcs7(pkcs7);
							
							HelperFirma hf = new HelperFirma();

							out.clearBuffer();
							out.println("Archivo : " + hf.insertFirma(frm,envId));
						}
					}
				} else {
					
					System.out.println("********************************* 12b");
					String usuario = parametros.get("userId");
					System.out.println("********************************* 12c");
					String jefatura = parametros.get("JEFATURA");

					System.out.println("**********************************************************");
					System.out.println("******************GUARDANDO FIRMA NUEVO*******************");
					System.out.println("clave: " + clave);
					System.out.println("firma: " + firma);
					System.out.println("nombre: " + nombre);
					System.out.println("nroDocumento: " + nroDocumento);
					System.out.println("usuario: " + usuario);
					System.out.println("jefatura: " + jefatura);
					System.out.println("pkcs7: " + pkcs7);
					System.out.println("**********************************************************");

					Firma frm = new Firma();

					char a = (char) Integer.parseInt(ConfigurationApplet.CHAR1);
					char b = (char) Integer.parseInt(ConfigurationApplet.CHAR2);

					String sep1 = ConfigurationApplet.STRING1;
					String sep2 = ConfigurationApplet.STRING2;
					String sep3 = ConfigurationApplet.STRING3;

					String strRes1 = a + "";
					String strRes2 = b + "";
					String strRes3 = ConfigurationApplet.CHAR3;

					clave = clave.replaceAll(sep1, strRes1);
					clave = clave.replaceAll(sep2, strRes2);
					clave = clave.replaceAll(sep3, strRes3);

					firma = firma.replaceAll(sep1, strRes1);
					firma = firma.replaceAll(sep2, strRes2);
					firma = firma.replaceAll(sep3, strRes3);
					
					pkcs7=pkcs7.replace(ConfigurationApplet.STRING1, "");
					pkcs7=pkcs7.replace(ConfigurationApplet.STRING2, "");
					pkcs7=pkcs7.replace(ConfigurationApplet.STRING3, "+");
					
					System.out.println("pkcs7 vers 2: " + pkcs7);
					System.out.println("env_name: " + env_name);
					System.out.println("version Caratula: " + Integer.parseInt(versionCaratula));
					
					frm.setClavePublica(clave);
					frm.setFirma(firma);
					frm.setEnvName(env_name);
					frm.setVersionCaratula( Integer.parseInt(versionCaratula));

					//por ahora no se usa
					frm.setIdArchivo(0d);
					//por ahora no se usa
					frm.setNombArchivo(nombre);
					frm.setNroDoc(nroDocumento);
					frm.setUsuario(usuario);
					frm.setJefatura(jefatura);
					frm.setPkcs7(pkcs7);
					HelperFirma hf = new HelperFirma();

					out.clearBuffer();
					out.println("Archivo : " + hf.insertFirma(frm,envId));
				}
		
				
			}else{
				System.out.println("Existe otra sesi�n activa para el mismo usuario.");
			}
				
			
		}else{
			//Si la clase de control se encuentra deshabilitada hago lo que hacia antes.			
			System.out.println("Entro aqui v2!!");

			String clave = (String) parametros.get("clave");
			
			System.out.println("********************************* 1");
			String firma = parametros.get("firma");
			System.out.println("********************************* 2");
			String nombre = parametros.get("id");

			System.out.println("********************************* 3");
			nombre = URLDecoder.decode(nombre, "iso-8859-1");
			System.out.println("********************************* 4");
			clave = URLDecoder.decode(clave, "iso-8859-1");
			System.out.println("********************************* 5");
			firma = URLDecoder.decode(firma, "iso-8859-1");
			System.out.println("********************************* 6");

			Integer envId = Integer.parseInt(parametros.get("envId"));
			System.out.println("********************************* 7");
			
			String pkcs7 = parametros.get("pkcs7");
			System.out.println("********************************* 8");
			
			String nroDocumento = parametros.get("TMP_NRO_DOC_A_FIRMAR_STR");
			System.out.println("********************************* 9");
			
			String env_name = parametros.get("ENV_NAME");
			System.out.println("********************************* 10");
			
			String versionCaratula = parametros.get("VERSION_CARATULA_RELACIONADA");
			System.out.println("********************************* 11");
			
			if (nroDocumento.contains(";")) {
				System.out.println("********************************* 12");
				String[] nrosExp = null;
				System.out.println("********************************* 13");
				nrosExp = nroDocumento.split(";");
				System.out.println("********************************* 14");
				String[] versionsCaratula = versionCaratula.split(";");
				System.out.println("********************************* 15");
				for (int i = 0; i < nrosExp.length ; i++) {
					if (nombre.contains(nrosExp[i])) {
						String usuario = parametros.get("userId");
						String jefatura = parametros.get("JEFATURA");
						
						System.out.println("EXPEDIENTE: " + nrosExp[i]);
						
						System.out
								.println("*********************************************************");
						System.out
								.println("******************GUARDANDO FIRMA NUEVO******************");
						System.out.println("clave: " + clave);
						System.out.println("firma: " + firma);
						System.out.println("nombre: " + nombre);
						System.out.println("nroDocumento: " + nrosExp[i]);
						System.out.println("usuario: " + usuario);
						System.out.println("pkcs7: " + pkcs7);
						System.out.println("jefatura: " + jefatura);
						System.out
								.println("*********************************************************");

						Firma frm = new Firma();

						char a = (char) Integer.parseInt(ConfigurationApplet.CHAR1);
						char b = (char) Integer.parseInt(ConfigurationApplet.CHAR2);

						String sep1 = ConfigurationApplet.STRING1;
						String sep2 = ConfigurationApplet.STRING2;
						String sep3 = ConfigurationApplet.STRING3;

						String strRes1 = a + "";
						String strRes2 = b + "";
						String strRes3 = ConfigurationApplet.CHAR3;

						clave = clave.replaceAll(sep1, strRes1);
						clave = clave.replaceAll(sep2, strRes2);
						clave = clave.replaceAll(sep3, strRes3);

						firma = firma.replaceAll(sep1, strRes1);
						firma = firma.replaceAll(sep2, strRes2);
						firma = firma.replaceAll(sep3, strRes3);
						
						pkcs7=pkcs7.replace(ConfigurationApplet.STRING1, "");
						pkcs7=pkcs7.replace(ConfigurationApplet.STRING2, "");
						pkcs7=pkcs7.replace(ConfigurationApplet.STRING3, "+");
						
						System.out.println("pkcs7 vers 2: " + pkcs7);
						
						System.out.println("env_id: " + env_name);
						System.out.println("version Caratula: " + Integer.parseInt(versionsCaratula[i]));
						frm.setClavePublica(clave);
						frm.setFirma(firma);
						frm.setEnvName(env_name );
						frm.setVersionCaratula(Integer.parseInt(versionsCaratula[i]));
						
						//por ahora no se usa
						frm.setIdArchivo(0d);
						//por ahora no se usa
						frm.setNombArchivo(nombre);
						frm.setNroDoc(nrosExp[i]);
						frm.setUsuario(usuario);
						frm.setJefatura(jefatura);
						frm.setPkcs7(pkcs7);
						
						HelperFirma hf = new HelperFirma();

						out.clearBuffer();
						out.println("Archivo : " + hf.insertFirma(frm,envId));
					}
				}
			} else {
				System.out.println("********************************* 12b");
				String usuario = parametros.get("userId");
				System.out.println("********************************* 12c");
				String jefatura = parametros.get("JEFATURA");

				System.out.println("**********************************************************");
				System.out.println("******************GUARDANDO FIRMA NUEVO******************");
				System.out.println("clave: " + clave);
				System.out.println("firma: " + firma);
				System.out.println("nombre: " + nombre);
				System.out.println("nroDocumento: " + nroDocumento);
				System.out.println("usuario: " + usuario);
				System.out.println("jefatura: " + jefatura);
				System.out.println("pkcs7: " + pkcs7);
				System.out
						.println("**********************************************************");

				Firma frm = new Firma();

				char a = (char) Integer.parseInt(ConfigurationApplet.CHAR1);
				char b = (char) Integer.parseInt(ConfigurationApplet.CHAR2);

				String sep1 = ConfigurationApplet.STRING1;
				String sep2 = ConfigurationApplet.STRING2;
				String sep3 = ConfigurationApplet.STRING3;

				String strRes1 = a + "";
				String strRes2 = b + "";
				String strRes3 = ConfigurationApplet.CHAR3;

				clave = clave.replaceAll(sep1, strRes1);
				clave = clave.replaceAll(sep2, strRes2);
				clave = clave.replaceAll(sep3, strRes3);

				firma = firma.replaceAll(sep1, strRes1);
				firma = firma.replaceAll(sep2, strRes2);
				firma = firma.replaceAll(sep3, strRes3);
				
				pkcs7=pkcs7.replace(ConfigurationApplet.STRING1, "");
				pkcs7=pkcs7.replace(ConfigurationApplet.STRING2, "");
				pkcs7=pkcs7.replace(ConfigurationApplet.STRING3, "+");
				
				System.out.println("pkcs7 vers 2: " + pkcs7);
				System.out.println("env_name: " + env_name);
				System.out.println("version Caratula: " + Integer.parseInt(versionCaratula));
				
				frm.setClavePublica(clave);
				frm.setFirma(firma);
				frm.setEnvName(env_name);
				frm.setVersionCaratula( Integer.parseInt(versionCaratula));

				//por ahora no se usa
				frm.setIdArchivo(0d);
				//por ahora no se usa
				frm.setNombArchivo(nombre);
				frm.setNroDoc(nroDocumento);
				frm.setUsuario(usuario);
				frm.setJefatura(jefatura);
				frm.setPkcs7(pkcs7);
				HelperFirma hf = new HelperFirma();

				out.clearBuffer();
				out.println("Archivo : " + hf.insertFirma(frm,envId));
			}
		}		
		
	} catch (Exception e) {
		out.print("ERROR en guardarFirma.jsp: " + e.getMessage() + " - " + e.getLocalizedMessage());
	}
%>
