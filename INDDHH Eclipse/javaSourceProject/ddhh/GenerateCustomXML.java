package ddhh;

import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Hashtable;
import java.util.Map;

import com.dogma.Parameters;
import com.dogma.busClass.ApiaAbstractClass;
import com.dogma.busClass.BusClassException;
import com.dogma.busClass.object.Entity;
import com.dogma.busClass.object.Process;

import ddhh.manejoXML.apiaXml.ApiaHelper;
import ddhh.manejoXML.apiaXml.FileIOHelper;
import ddhh.manejoXML.apiaXml.create.CreateXMLFile;
import ddhh.manejoXML.apiaXml.vo.AttributeVo;
import ddhh.manejoXML.apiaXml.vo.EntityVo;
import ddhh.manejoXML.apiaXml.vo.InformationVo;
import ddhh.manejoXML.apiaXml.vo.ProcessVo;

public class GenerateCustomXML extends ApiaAbstractClass {
	@Override
	protected void executeClass() throws BusClassException {
		try {
			String proName = "EXPEDIENTE";
			String entName = "EXPEDIENTE";
			String pathConfP = "AtributosEntidad.txt";
			String pathConfE = "AtributosProceso.txt";

			String idTramite = this.getCurrentEntity().getAttribute("TRM_TRAMITE_ID_STR").getValueAsString();

			String nomSalida = "file_generado" + idTramite + ".xml";
			String pathSalida = Parameters.TMP_FILE_STORAGE + File.separator + nomSalida;

			Process p = this.getCurrentProcess();
			Hashtable<String, String> mapAttsIn = null;
			ArrayList<String> mapAttsOut = null;

			mapAttsIn = new Hashtable<String, String>();
			mapAttsIn.put("INDDHH_ATT_DATOS_PERSONALES_NOMBRES_STR", "false");
			mapAttsIn.put("INDDHH_ATT_DATOS_PERSONALES_APELLIDOS_STR", "false");
			mapAttsIn.put("ATT_DENUNCIA_ORGANISMO_ACUDIDOS", "true");

			mapAttsOut = new ArrayList<String>();
			mapAttsOut.add("EXP_DENUNCIA_NOMBRE_PERSONA");
			mapAttsOut.add("EXP_DENUNCIA_APELLIDO_PERSONA");
			mapAttsOut.add("EXP_DENUNCIA_ORGANISMO_ACUDIDOS");

			createProcessXML(this, p, proName, entName, pathConfP, pathConfE, pathSalida, mapAttsIn, mapAttsOut);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	public static void createProcessXML(ApiaAbstractClass aac, Process p, String proName, String entName,
			String pathConfP, String pathConfE, String pathSalida, Hashtable<String, String> mapAttsIn,
			ArrayList<String> mapAttsOut) throws BusClassException, IOException {

		Entity entIn = p.getEntity();

		EntityVo entidad = new EntityVo();
		entidad.setNombre(entName);

		ArrayList<AttributeVo> atts = genearEstructura(aac, entIn, mapAttsIn, mapAttsOut);
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
		// Leo el archivo con la configuracion de los nombres de atributos que contienen
		// los valores de las variables
		String content = FileIOHelper.readFile(pathConf);

		ArrayList<AttributeVo> atts = new ArrayList<AttributeVo>();

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

						throw new BusClassException("Error de sintaxis en los indices de origen y destino: " + value);

					}

					try {
						if (!indexAttOut.equals("n") && !indexAttOut.isEmpty())
							Integer.parseInt(indexAttOut);

						if (!indexAttIn.equals("n") && !indexAttIn.isEmpty())
							Integer.parseInt(indexAttIn);
					} catch (NumberFormatException e) {
						throw new BusClassException("Error de sintaxis en los indices de origen y destino: " + value);
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
							docName = ApiaHelper.getAttributeDocNameValue(p, nomAttIn, Integer.parseInt(indexAttIn));
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

		return atts;
	}

	private static ArrayList<AttributeVo> genearEstructura(ApiaAbstractClass aac, Entity entIn,
			Hashtable<String, String> mapAttsIn, ArrayList<String> mapAttsOut) throws IOException, BusClassException {
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

}
