<%@ page language="java" %>
<%@ page import="com.dogma.business.querys.*" %>
<%@ page import="com.dogma.business.*" %>
<%@ page import="com.st.db.dataAccess.*" %>
<%@ page import="com.dogma.dataAccess.*" %>
<%@ page import="com.dogma.vo.*" %>
<%@ page import="com.dogma.vo.gen.*" %>
<%@ page import="com.dogma.dao.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="com.dogma.DogmaException"%>

<%! 
protected class Test extends ConnectionDAO {
	public Connection getDBConnection2(DBConnection dbConn) {
		return ConnectionDAO.getDBConnection(dbConn);
	}

	public void updateDB(Connection con, String envId,String objId,String type) throws Exception{
		try{
			String table = "";
			String column = "";
			if("processes".equals(type)){table = "pro_document"; column = "pro_id";}
			if("tasks".equals(type)){table = "tsk_document"; column = "tsk_id";}
			if("entities".equals(type)){table = "bus_ent_document"; column = "bus_ent_id";}
			if("forms".equals(type)){table = "frm_document"; column = "frm_id";}
			if("proInstances".equals(type)){table = "pro_inst_document"; column = "pro_inst_id";}
			if("entInstaces".equals(type)){table = "bus_ent_inst_document"; column = "bus_ent_inst_id";}
			PreparedStatement ps = StatementFactory.getStatement(con,"select doc_id from " + table + " where env_id = ? and " + column + " =? ",StatementFactory.DEBUG);
	     	ps.setInt(1,Integer.parseInt(envId));
	     	ps.setInt(2,Integer.parseInt(objId));
			ResultSet rs = ps.executeQuery();
			Collection col = new ArrayList();
			while(rs.next()){
				col.add(new Integer(rs.getInt("doc_id")));
			}
			rs.close();
			ps.close();
			
			Iterator it = col.iterator();
			while(it.hasNext()){
				String path = "";
				Integer id = (Integer)it.next();
				PreparedStatement ps2 = StatementFactory.getStatement(con,"select doc_path from document where env_id = ? and doc_id_auto=?",StatementFactory.DEBUG);
		     	ps2.setInt(1,Integer.parseInt(envId));	     	
		     	ps2.setInt(2,id.intValue());	     			     	
				ResultSet rs2 = ps2.executeQuery();
				if(rs2.next()){
					path = rs2.getString("doc_path");
				}
				rs2.close();
				ps2.close();
				
				
				
				PreparedStatement ps3 = StatementFactory.getStatement(con,"update document set doc_path = ? where env_id = ? and doc_id_auto=?",StatementFactory.DEBUG);
				String newPath = path.substring(0,path.indexOf(envId+"-"+objId)) + String.valueOf(Integer.parseInt(objId)/Parameters.MAX_FILES_PER_DIRECTORY) + File.separator+ path.substring(path.indexOf(envId+"-"+objId),path.length());
			
		     	ps3.setString(1,newPath);
		     	ps3.setInt(2,Integer.parseInt(envId));	     	
		     	ps3.setInt(3,id.intValue());	     			     	
				boolean b = ps3.execute();
				ps3.close();
			
			}
			
		} catch(Exception e){
			e.printStackTrace();
			throw e;
		}
	}
}


%>

<%@page import="com.dogma.Parameters"%>


<%@page import="com.st.util.FileUtil"%>
<html>

PATCH de documentos "El flaco"®... <br>

Se actualizaron los documentos del storage: <%= Parameters.DOCUMENT_STORAGE %><br>

<%
 
	DBConnection dbConn = null;
	Test test = new Test();
	Connection con = null;
	try {
		dbConn = DogmaDBManager.getConnection();
		File mainStorage = new File(Parameters.DOCUMENT_STORAGE);
	
		String[] storageContent = mainStorage.list();
		
		File current = null;
		//recorrer el contenido del document storage
		for(int i=0;i<storageContent.length;i++){
			current = new File(Parameters.DOCUMENT_STORAGE+File.separator+storageContent[i]);
			//Si es una carpeta se analiza el contenido
			if(current.isDirectory()){
				File dir = new File(current.getAbsolutePath());
				String[] subFolders = current.list();
				//para cada archivo de la carpeta
				for(int h=0;h<subFolders.length;h++){
					//si es una carpeta de las antiguas (env_id-obj_id) se procesa
					if(subFolders[h].indexOf("-")>-1){
						//obtener el object id
						String objId = subFolders[h].substring(subFolders[h].indexOf("-")+1);
						String envId = subFolders[h].substring(0,subFolders[h].indexOf("-"));
						File fChilds = new File(Parameters.DOCUMENT_STORAGE+File.separator+storageContent[i]+File.separator+subFolders[h]);
						String[] childs = fChilds.list();
						//-actualizo todos los hijos del objeto en la base
						con =  test.getDBConnection2(dbConn);
						test.updateDB(con,envId,objId,storageContent[i]);
						boolean todoOk = true;
						for(int j=0;j<childs.length;j++){
							//-se mueve cada documento del objeto
							String ori = Parameters.DOCUMENT_STORAGE+File.separator+storageContent[i]+File.separator+subFolders[h]+File.separator+childs[j];
							String dest = Parameters.DOCUMENT_STORAGE+File.separator+storageContent[i]+File.separator+(Integer.parseInt(objId)/Parameters.MAX_FILES_PER_DIRECTORY)+File.separator+subFolders[h]+File.separator+childs[j];					
							try{
								//-se crea la carpeta primero
								File f = new File(Parameters.DOCUMENT_STORAGE+File.separator+storageContent[i]+File.separator+(Integer.parseInt(objId)/Parameters.MAX_FILES_PER_DIRECTORY)+File.separator+subFolders[h]);
								f.mkdirs();
								//-mover los archivos
								FileUtil.moveFile(ori,dest);
							} catch(Exception e){
								//si da error se deshacen los cambios en la base para ese objeto y se sale del for
								e.printStackTrace();
								dbConn.rollback();
								todoOk = false;
								break;
							}
						}
						//si todo esta bien se hace commit. si salio del for por el break, el rollback ya fue hecho
						dbConn.commit();
						
						//-delete folder si todo esta bien
						if(todoOk){
							File toDelete = new File(Parameters.DOCUMENT_STORAGE+File.separator+storageContent[i]+File.separator+subFolders[h]);
							toDelete.delete();
						}
						
					}
				}
				
			}
		}
	}catch (Exception e) {
		e.printStackTrace();
		dbConn.rollback();
	} finally {
		try {
			con.close();
			dbConn.close();
		} catch (Exception ignore) {}
	}
%>

</html>
