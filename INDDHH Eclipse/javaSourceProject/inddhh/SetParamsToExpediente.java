package inddhh;

import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.Hashtable;
import java.util.LinkedHashMap;
import java.util.Map;

import com.dogma.Parameters;
import com.dogma.busClass.ApiaAbstractClass;
import com.dogma.busClass.BusClassException;
import com.dogma.busClass.object.Entity;
import com.dogma.busClass.object.Process;
import com.dogma.busClass.object.def.EntityDef;

import ddhh.manejoXML.apiaXml.ApiaHelper;
import ddhh.manejoXML.apiaXml.FileIOHelper;
import ddhh.manejoXML.apiaXml.create.CreateXMLFile;
import ddhh.manejoXML.apiaXml.vo.AttributeVo;
import ddhh.manejoXML.apiaXml.vo.EntityVo;
import ddhh.manejoXML.apiaXml.vo.InformationVo;
import ddhh.manejoXML.apiaXml.vo.ProcessVo;

public class SetParamsToExpediente extends ApiaAbstractClass {

	@Override
	protected void executeClass() throws BusClassException {
		// TODO Auto-generated method stub
		/*
		 * Se deben cargar los siguientes atributos: -
		 * TRM_PARAMETROS_DESDE_DEFINICION_STR con el valor false. -
		 * DEF_TRM_EXPEDIENTE_OFICINA_ORIGEN_STR: oficina que va a recibir el expediente
		 * generado (debe existir en ApiaDocumentum) -
		 * DEF_TRM_EXPEDIENTE_CLASIFICACION_STR: clasificación del expediente -
		 * DEF_TRM_EXPEDIENTE_DOC_FISICA_STR: si contiene documentación fisica ( 1=No,
		 * 2= Si) - DEF_TRM_EXPEDIENTE_CONFIDENCIALIDAD_STR: nivel de confidencialidad
		 * del expedientes - DEF_TRM_EXPEDIENTE_PRIORIDAD_STR: prioridad -
		 * DEF_TRM_EXPEDIENTE_ASUNTO_STR: asunto del expediente -
		 * DEF_TRM_EXPEDIENTE_TIPO_STR: tipo de expediente (debe existir en
		 * ApiaDocumentum) - DEF_TRM_EXPEDIENTE_ADJUNTO_STR: si se envia documento
		 * adjunto del tramite ( 1=No, 2= Si) - DEF_TRM_CONCATENAR_PDF_STR: si se
		 * concatena los pdf del tramtie y se envian al expediente. ( 1=No, 2= Si)
		 */

//		Parámetros principales del expediente
//		*************************************

		int idDefTramite = Integer.valueOf(getCurrentEntity().getAttribute("TRM_COD_TRAMITE_STR").getValueAsString())
				.intValue();

		EntityDef entDefDefTrm = getEntityDef("DEF_TRAMITE");

		Entity entDefTramite = getEntity(entDefDefTrm.getName(), entDefDefTrm.getPrefix(),
				Integer.valueOf(idDefTramite), entDefDefTrm.getPosfix());

		Entity currEnt = this.getCurrentEntity();

//		String paramsDef = this.getParameter("paramsDef").getValueAsString(); // false
//		String ofiOrigen = this.getParameter("ofiOrigen").getValueAsString(); // Equipo de Denuncias: 520
//		String clasif = this.getParameter("clasif").getValueAsString(); // Publico: 1
//		String docFisica = this.getParameter("docFisica").getValueAsString(); // No: 1
//		String confidenc = this.getParameter("confidenc").getValueAsString(); // No: 1
//		String prioridad = this.getParameter("prioridad").getValueAsString(); // Normal: 1
//		String tipo = this.getParameter("tipo").getValueAsString(); // Denuncia: 1

		String paramsDef = currEnt.getAttribute("INDDHH_EXP_PARAMETROS_DESDE_DEFINICION_STR").getValueAsString();
		String ofiOrigen = currEnt.getAttribute("INDDHH_EXP_OFICINA_ORIGEN_STR").getValueAsString();
		String clasif = currEnt.getAttribute("INDDHH_EXP_CLASIFICACION_STR").getValueAsString();
		String docFisica = currEnt.getAttribute("DEF_TRM_EXPEDIENTE_DOC_FISICA_STR").getValueAsString();
		String confidenc = currEnt.getAttribute("INDDHH_EXP_CONFIDENCIALIDAD_STR").getValueAsString();
		String prioridad = currEnt.getAttribute("INDDHH_EXP_PRIORIDAD_STR").getValueAsString();
		String tipo = currEnt.getAttribute("INDDHH_EXP_TIPO_STR").getValueAsString();
		String asunto = currEnt.getAttribute("INDDHH_EXP_ASUNTO_STR").getValueAsString();
		
		entDefTramite.getAttribute("TRM_PARAMETROS_DESDE_DEFINICION_STR").setValue(paramsDef);
		entDefTramite.getAttribute("DEF_TRM_EXPEDIENTE_OFICINA_ORIGEN_STR").setValue(ofiOrigen);
		entDefTramite.getAttribute("DEF_TRM_EXPEDIENTE_CLASIFICACION_STR").setValue(clasif);
		entDefTramite.getAttribute("DEF_TRM_EXPEDIENTE_DOC_FISICA_STR").setValue(docFisica);
		entDefTramite.getAttribute("DEF_TRM_EXPEDIENTE_CONFIDENCIALIDAD_STR").setValue(confidenc);
		entDefTramite.getAttribute("DEF_TRM_EXPEDIENTE_PRIORIDAD_STR").setValue(prioridad);
		entDefTramite.getAttribute("DEF_TRM_EXPEDIENTE_ASUNTO_STR").setValue(asunto);
		entDefTramite.getAttribute("DEF_TRM_EXPEDIENTE_TIPO_STR").setValue(tipo);

		try {
			String proName = "EXPEDIENTE";
			String entName = "EXPEDIENTE";
			String pathConfP = "AtributosEntidad.txt";
			String pathConfE = "AtributosProceso.txt";

			String idTramite = this.getCurrentEntity().getAttribute("TRM_TRAMITE_ID_STR").getValueAsString();

			String nomSalida = "file_generado" + idTramite + ".xml";
			String pathSalida = Parameters.TMP_FILE_STORAGE + File.separator + nomSalida;

			Process p = this.getCurrentProcess();
			LinkedHashMap<String, String> mapAttsIn = null;
			ArrayList<String> mapAttsOut = null;

			mapAttsIn = new LinkedHashMap<String, String>();

//			mapAttsIn.put("INDDHH_EXP_ASUNTO_STR", "false");
//
//			mapAttsIn.put("INDDHH_TIPO_PERSONA_STR", "true");
//			mapAttsIn.put("INDDHH_ATT_DATOS_PERSONALES_DOC_TIPO_STR", "true"); // CI o Pasaporte
//			mapAttsIn.put("INDDHH_ATT_DATOS_PERSONALES_DOC_NUM_STR", "false");
//			mapAttsIn.put("INDDHH_ATT_DATOS_PERSONALES_NOMBRES_STR", "false");
//			mapAttsIn.put("INDDHH_ATT_DATOS_PERSONALES_APELLIDOS_STR", "false");
//			mapAttsIn.put("INDDHH_ATT_DOMICILIO_CALLE_STR", "false");
//			mapAttsIn.put("INDDHH_ATT_DOMICILIO_NUMERO_STR", "false");
//			mapAttsIn.put("INDDHH_ATT_DOMICILIO_LOCALIDAD_STR", "false");
//			mapAttsIn.put("INDDHH_ATT_DOMICILIO_DEPTO_STR", "false");
//			mapAttsIn.put("INDDHH_ATT_DOMICILIO_OTROS_DATOS_STR", "false");
//			mapAttsIn.put("INDDHH_TELEFONO_CONTACTO_STR", "false");
//			mapAttsIn.put("INDDHH_CORREO_CONTACTO_STR", "false");
//
//			mapAttsIn.put("INDDHH_PERSONA_FISICA_FECHA_NACIMIENTO_DTE", "false");
//			mapAttsIn.put("INDDHH_EDAD_NUM", "false");
//			mapAttsIn.put("INDDHH_RESERVA_IDENTIDAD_STR", "false");
//			mapAttsIn.put("INDDHH_NACIONALIDAD_STR", "false");
//			mapAttsIn.put("INDDHH_PERSONA_GENERO_STR", "false");
//			mapAttsIn.put("INDDHH_GRUPO_ETNICO_STR", "false");
//			mapAttsIn.put("INDDHH_VIA_INICIO_STR", "false");
//			mapAttsIn.put("INDDHH_ORG_INCISO_TABLA_STR", "false");
//			mapAttsIn.put("INDDHH_ORG_UNIDAD_EJECUTORA_TABLA_STR", "false");
//			mapAttsIn.put("1", "false");
//
//			mapAttsOut = new ArrayList<String>();
//
//			mapAttsOut.add("EXP_ASUNTO_STR");
//
//			mapAttsOut.add("EXP_TIPO_TITULAR_ENUM"); // Multi (3 Fisica y 5 Juridica)
////			mapAttsOut.add("EXP_SUB_TIPO_TITULAR_ENUM"); //Multi
//			mapAttsOut.add("EXP_TIPO_DOC_STR");
//			mapAttsOut.add("EXP_NRO_DOC_STR");
//			mapAttsOut.add("EXP_NOM_PER_JUR_STR");
//			mapAttsOut.add("EXP_DIRECCION_STR");
//			mapAttsOut.add("EXP_DOMICILIO_CONST_STR");
//			mapAttsOut.add("EXP_TELEFONO_STR");
//			mapAttsOut.add("EXP_EMAIL_STR");
//			mapAttsOut.add("EXP_RAZON_SOCIAL_STR");
//
//			mapAttsOut.add("ATT_DEN_FECHA_NACIMIENTO");
//			mapAttsOut.add("ATT_FE_DEN_EDAD_DENUNCIANTE_STR");
//			mapAttsOut.add("ATT_RESERVA_IDENTIDAD"); // Si-No
//			mapAttsOut.add("ATT_DEN_CIUDADANO"); // Si-No
//			mapAttsOut.add("ATT_DEN_GENERO"); // Multi
//			mapAttsOut.add("ATT_DEN_ETNIA"); // Multi
//			mapAttsOut.add("ATT_DEN_FORMA_PRESENTACION"); // Multi
////			mapAttsOut.add("ATT_DEN_DERECHO_VULNERADO_1");
//			mapAttsOut.add("ATT_FE_INCISO"); // Multi
//			mapAttsOut.add("ATT_DEN_UE_1"); // Multi
//			mapAttsOut.add("ATT_DEN_ADMITE"); // Si-No


			createProcessXML(this, currEnt, p, proName, entName, pathConfP, pathConfE, pathSalida, mapAttsIn,
					mapAttsOut);
			
			this.getCurrentEntity().getAttribute("TRM_XML_FILES_STR").addDocument(pathSalida, nomSalida, "", false);

		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}

	public static void createProcessXML(ApiaAbstractClass aac, Entity currEnt, Process p, String proName,
			String entName, String pathConfP, String pathConfE, String pathSalida,
			LinkedHashMap<String, String> mapAttsIn, ArrayList<String> mapAttsOut)
			throws BusClassException, IOException {

		Entity entIn = p.getEntity();

		EntityVo entidad = new EntityVo();
		entidad.setNombre(entName);

		ArrayList<AttributeVo> atts = generarEstructuraManual(aac, currEnt);
		entidad.setAttributes(atts);

		// nuevo por pedido de coki
		ArrayList<EntityVo> entities = new ArrayList<EntityVo>();
		entities.add(entidad);

		ProcessVo proceso = new ProcessVo();
		proceso.setNombre(proName);
		ArrayList<AttributeVo> attsPro = getProAtts(p, pathConfP);
		proceso.setAttributes(attsPro);
		proceso.setEnt(entidad);

		InformationVo info = new InformationVo();
		ArrayList<ProcessVo> pros = new ArrayList<ProcessVo>();
		pros.add(proceso);

		info.setProcesos(pros);
		// nuevo por pedido de coki
		info.setEntidades(entities);

		CreateXMLFile.createApiaXMLFile(info, pathSalida);

	}

	@SuppressWarnings("rawtypes")
	private static ArrayList<AttributeVo> getProAtts(Process p, String pathConf) throws IOException, BusClassException {
		ArrayList<AttributeVo> atts = new ArrayList<AttributeVo>();

		// Leo el archivo con la configuracion de los nombres de atributos que contienen
		// los valores de las variables
		if (pathConf.isEmpty()) {
			String content = FileIOHelper.readFile(pathConf);

			// Los valores estan separados por un ;
			String[] tokens = content.split(";");
			if (tokens != null && tokens.length > 0) {
				for (String value : tokens) {
					String[] data = value.split("%");

					if (data != null && data.length == 2) {
						String attIn = data[0];
						String attOut = data[1];

						String nomAttIn = "";
						String indexAttIn = "";
						String nomAttOut = "";
						String indexAttOut = "";

						if (attIn.contains("#")) {
							String[] array = attIn.split("#");
							if (array != null && array.length == 2) {
								nomAttIn = array[0];
								indexAttIn = array[1];
							} else if (array != null && array.length == 1) {
								nomAttIn = array[0];
							}
						} else {
							nomAttIn = attIn;
						}

						if (attOut.contains("#")) {
							String[] array = attOut.split("#");
							if (array != null && array.length == 2) {
								nomAttOut = array[0];
								indexAttOut = array[1];
							} else if (array != null && array.length == 1) {
								nomAttOut = array[0];
							}
						} else {
							nomAttOut = attOut;
						}

						if ((indexAttIn.equals("n") && !indexAttOut.equals("n"))
								|| (indexAttOut.equals("n") && !indexAttIn.equals("n"))) {

							throw new BusClassException(
									"Error de sintaxis en los indices de origen y destino: " + value);

						}

						try {
							if (!indexAttOut.equals("n") && !indexAttOut.isEmpty())
								Integer.parseInt(indexAttOut);

							if (!indexAttIn.equals("n") && !indexAttIn.isEmpty())
								Integer.parseInt(indexAttIn);
						} catch (NumberFormatException e) {
							throw new BusClassException(
									"Error de sintaxis en los indices de origen y destino: " + value);
						}

						if (indexAttIn.equals("n")) {
							Collection col = p.getAttribute(nomAttIn).getValues();

							if (col != null) {
								int tam = col.size();

								for (int i = 0; i < tam; i++) {
									AttributeVo atributo = new AttributeVo();
									atributo.setNombre(nomAttOut);
									atributo.setIndex(i);

									String docName = ApiaHelper.getAttributeDocNameValue(p, nomAttIn, i);
									if (docName != null) {
										atributo.setValue(docName);
										atributo.setFile(true);
									} else {
										String valor = p.getAttribute(nomAttIn).getValueAsString(i);
										atributo.setValue(valor);
										atributo.setFile(false);
									}
									if (atributo.getValue() != null && !atributo.getValue().isEmpty())
										atts.add(atributo);
								}

							}

						} else {
							AttributeVo atributo = new AttributeVo();
							atributo.setNombre(nomAttOut);
							if (!indexAttOut.isEmpty())
								atributo.setIndex(Integer.parseInt(indexAttOut));
							else
								atributo.setIndex(0);

							String docName = "";
							if (indexAttIn.isEmpty()) {
								indexAttIn = "-1";
								atributo.setIndex(0);
								docName = ApiaHelper.getAttributeDocNameValue(p, nomAttIn, 0);
							} else {
								docName = ApiaHelper.getAttributeDocNameValue(p, nomAttIn,
										Integer.parseInt(indexAttIn));
							}

							if (docName != null) {
								atributo.setValue(docName);
								atributo.setFile(true);
							} else {
								String valor = null;
								if (indexAttIn.equalsIgnoreCase("-1"))
									valor = p.getAttribute(nomAttIn).getValuesAsString();
								else
									valor = p.getAttribute(nomAttIn).getValueAsString(Integer.parseInt(indexAttIn));

								atributo.setValue(valor);
								atributo.setFile(false);

							}
							if (atributo.getValue() != null && !atributo.getValue().isEmpty())
								atts.add(atributo);
						}
					}
				}
			}

		}

		return atts;
	}

	private static ArrayList<AttributeVo> genearEstructura(ApiaAbstractClass aac, Entity entIn,
			LinkedHashMap<String, String> mapAttsIn, ArrayList<String> mapAttsOut)
			throws IOException, BusClassException {
		ArrayList<AttributeVo> atts = new ArrayList<AttributeVo>();
		Connection conn = aac.getCurrentConnection();
		int envId = aac.getCurrentEnvironmentId();

		int sizeArray = 0;
		for (Object o : mapAttsIn.entrySet()) {
			Map.Entry entry = (Map.Entry) o;
			String nameAtribute = (String) entry.getKey();
			String isMultiValue = (String) entry.getValue();

			if (isMultiValue.equals("true")) {
				int indice = 0;
				if (!entIn.getAttribute(nameAtribute).getValueAsString().isEmpty()) {
					indice = entIn.getAttribute(nameAtribute).getValues().size();
				}

				for (int i = 0; i < indice; i++) {
					AttributeVo attribute = new AttributeVo();
					attribute.setNombre(mapAttsOut.get(sizeArray).toString());
					attribute.setIndex(i);
					attribute.setValue(entIn.getAttribute(nameAtribute).getValueAsString(i));
					attribute.setFile(false);

					if (attribute.getValue() != null && !attribute.getValue().isEmpty())
						atts.add(attribute);
				}

			} else {
				AttributeVo attribute = new AttributeVo();
				attribute.setNombre(mapAttsOut.get(sizeArray).toString());
				attribute.setIndex(0);
				attribute.setValue(entIn.getAttribute(nameAtribute).getValueAsString());
				attribute.setFile(false);

				if (attribute.getValue() != null && !attribute.getValue().isEmpty())
					atts.add(attribute);
			}

			sizeArray++;

		}
		return atts;
	}

	private static ArrayList<AttributeVo> generarEstructuraManual(ApiaAbstractClass aac, Entity currEnt)
			throws IOException, BusClassException {

		ArrayList<AttributeVo> atts = new ArrayList<AttributeVo>();
		ArrayList<String> nombresAttsAD = new ArrayList<>();
		ArrayList<Object> valoresAttsAD = new ArrayList<>();

//		nombresAttsAD.add("EXP_ASUNTO_STR");
		nombresAttsAD.add("EXP_TIPO_TITULAR_ENUM");
		nombresAttsAD.add("EXP_TIPO_DOC_STR");
		nombresAttsAD.add("EXP_NRO_DOC_STR");
		nombresAttsAD.add("EXP_NOM_PER_JUR_STR");
		nombresAttsAD.add("EXP_DIRECCION_STR");
		nombresAttsAD.add("EXP_DOMICILIO_CONST_STR");
		nombresAttsAD.add("EXP_TELEFONO_STR");
		nombresAttsAD.add("EXP_EMAIL_STR");

//		nombresAttsAD.add("ATT_DEN_FECHA_NACIMIENTO");
		nombresAttsAD.add("ATT_FE_DEN_EDAD_DENUNCIANTE_STR");
		nombresAttsAD.add("ATT_RESERVA_IDENTIDAD");
		nombresAttsAD.add("ATT_DEN_CIUDADANO");
		nombresAttsAD.add("ATT_DEN_GENERO");
		nombresAttsAD.add("ATT_DEN_ETNIA");
		nombresAttsAD.add("ATT_DEN_FORMA_PRESENTACION");
//		nombresAttsAD.add("ATT_FE_INCISO");
//		nombresAttsAD.add("ATT_DEN_UE_1");
		nombresAttsAD.add("ATT_DEN_ADMITE");
		nombresAttsAD.add("ATT_DENUNCIA_TEXTO_STR");

//		String asunto = currEnt.getAttribute("EXP_ASUNTO_STR").getValueAsString();
//		valoresAttsAD.add(asunto);
		String tipoTitular = currEnt.getAttribute("INDDHH_TIPO_PERSONA_STR").getValueAsString();
		if (tipoTitular.compareTo("1") == 0) {
			valoresAttsAD.add("3"); // persona fisica
		} else if (tipoTitular.compareTo("3") == 0 || tipoTitular.compareTo("4") == 0
				|| tipoTitular.compareTo("5") == 0) {
			valoresAttsAD.add("5"); // persona juridica
		}
		String tipoDoc = currEnt.getAttribute("INDDHH_ATT_DATOS_PERSONALES_DOC_TIPO_STR").getValueAsString();
		if (tipoDoc.compareTo("1") == 0) {
			valoresAttsAD.add("CI"); // CI
		} else if (tipoDoc.compareTo("2") == 0) {
			valoresAttsAD.add("Pasaporte"); // Pasaporte
		}
		String nroDoc = currEnt.getAttribute("INDDHH_ATT_DATOS_PERSONALES_DOC_NUM_STR").getValueAsString();
		valoresAttsAD.add(nroDoc);
		String nombrePersona = currEnt.getAttribute("INDDHH_ATT_DATOS_PERSONALES_NOMBRES_STR").getValueAsString();
		String apellidoPersona = currEnt.getAttribute("INDDHH_ATT_DATOS_PERSONALES_NOMBRES_STR").getValueAsString();
		String nombreCompleto = nombrePersona + apellidoPersona;
		valoresAttsAD.add(nombreCompleto);

		String calle = currEnt.getAttribute("INDDHH_ATT_DOMICILIO_CALLE_STR").getValueAsString();
		String nro = currEnt.getAttribute("INDDHH_ATT_DOMICILIO_NUMERO_STR").getValueAsString();
		String locSelecId = currEnt.getAttribute("INDDHH_ATT_DOMICILIO_LOCALIDAD_STR").getValueAsString();
		Entity entLoc = aac.getEntity("COD_LOCALIDAD", null, Integer.parseInt(locSelecId), null);
		String localidad = entLoc.getAttribute("LOC_NOMBRE").getValueAsString();
		String deptoSelecId = currEnt.getAttribute("INDDHH_ATT_DOMICILIO_DEPTO_STR").getValueAsString();
		Entity entDepto = aac.getEntity("COD_DEPARTAMENTO", null, Integer.parseInt(deptoSelecId), null);
		String departamento = entLoc.getAttribute("A_CODIGUERA_VALUE").getValueAsString();

		String direccionCompleta = calle + " Nro. " + nro + ", " + localidad + ", " + departamento;
		valoresAttsAD.add(direccionCompleta);
		valoresAttsAD.add(direccionCompleta);

		String telefono = currEnt.getAttribute("INDDHH_TELEFONO_CONTACTO_STR").getValueAsString();
		valoresAttsAD.add(telefono);
		String email = currEnt.getAttribute("INDDHH_CORREO_CONTACTO_STR").getValueAsString();
		valoresAttsAD.add(email);

        SimpleDateFormat objSDF = new SimpleDateFormat("dd/MM/aaaa");
		Date fechaNac = (Date) currEnt.getAttribute("INDDHH_PERSONA_FISICA_FECHA_NACIMIENTO_DTE").getValue();
		valoresAttsAD.add(objSDF.format(fechaNac));
		String edad = String.valueOf(((Double) currEnt.getAttribute("INDDHH_EDAD_NUM").getValue()).intValue()); // Double
		valoresAttsAD.add(edad);
		String reservaId = currEnt.getAttribute("INDDHH_RESERVA_IDENTIDAD_STR").getValueAsString();// No-Si
		if (reservaId.compareTo("1") == 0) {
			valoresAttsAD.add("2");
		} else if (reservaId.compareTo("2") == 0) {
			valoresAttsAD.add("1");
		}
		String esUruguayo = currEnt.getAttribute("INDDHH_NACIONALIDAD_STR").getValueAsString(); // 1-uruguay
		if (esUruguayo.isEmpty() || esUruguayo == null || esUruguayo.compareTo("1") == 0) {
			valoresAttsAD.add("1");
		} else {
			valoresAttsAD.add("2");
		}
		String genero = currEnt.getAttribute("INDDHH_PERSONA_GENERO_STR").getValueAsString();
		if (genero.compareTo("1") == 0 || genero.compareTo("2") == 0) {
			valoresAttsAD.add(genero);
		}
		String grupoEtnico = currEnt.getAttribute("INDDHH_GRUPO_ETNICO_STR").getValueAsString();
		if (grupoEtnico.compareTo("6") != 0) {
			if (grupoEtnico.compareTo("1") == 0) {
				valoresAttsAD.add("2");
			} else if (grupoEtnico.compareTo("2") == 0) {
				valoresAttsAD.add("1");
			} else {
				valoresAttsAD.add(grupoEtnico);
			}
		}
		String viaInicio = currEnt.getAttribute("INDDHH_VIA_INICIO_STR").getValueAsString();
		if (viaInicio.compareTo("1") == 0) {
			valoresAttsAD.add("5");
		} else if (viaInicio.compareTo("2") == 0) {
			valoresAttsAD.add("3");
		} else if (viaInicio.compareTo("3") == 0) {
			valoresAttsAD.add("1");
		}

		String admiteDenuncia = "1"; // Si
		valoresAttsAD.add(admiteDenuncia);
		
		String descrProblema = currEnt.getAttribute("INDDHH_PROBLEMA_PERSONA_STR").getValueAsString();
		valoresAttsAD.add(descrProblema);

		// Atributos simples
		for (int i = 0; i < nombresAttsAD.size(); i++) {
			String nombreAtt = nombresAttsAD.get(i);
			String value = valoresAttsAD.get(i).toString();

			AttributeVo attribute = new AttributeVo();
			attribute.setNombre(nombreAtt);
			attribute.setIndex(0);
			attribute.setValue(value);
			attribute.setFile(false);
			if (attribute.getValue() != null && !attribute.getValue().isEmpty())
				atts.add(attribute);
		}

		// Multivaluados
//		Collection incisos = currEnt.getAttribute("INDDHH_ORG_INCISO_TABLA_STR").getValues();
//		ArrayList incisosArr = new ArrayList(incisos);
//		for (int i = 0; i < incisosArr.size(); i++) {
//			AttributeVo attribute = new AttributeVo();
//			attribute.setNombre("ATT_FE_INCISO");
//			attribute.setIndex(i);
//			attribute.setValue(incisosArr.get(i).toString());
//			attribute.setFile(false);
//			
//			if (attribute.getValue() != null && !attribute.getValue().isEmpty())
//				atts.add(attribute);
//		}
//		Collection unEjecutoras = currEnt.getAttribute("INDDHH_ORG_UNIDAD_EJECUTORA_TABLA_STR").getValues();
//		ArrayList unEjecutorasArr = new ArrayList(unEjecutoras);
//		for (int i = 0; i < unEjecutorasArr.size(); i++) {
//			AttributeVo attribute = new AttributeVo();
//			attribute.setNombre("ATT_DEN_UE_1");
//			attribute.setIndex(i);
//			attribute.setValue(unEjecutorasArr.get(i).toString());
//			attribute.setFile(false);
//			
//			if (attribute.getValue() != null && !attribute.getValue().isEmpty())
//				atts.add(attribute);
//		}

		return atts;
	}

}
