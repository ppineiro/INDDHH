package reportes;

import java.rmi.RemoteException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;

import com.dogma.busClass.BusClassException;
import com.dogma.busClass.QueryAbstractClass;
import com.dogma.busClass.object.Query;
import com.dogma.busClass.object.Filter;

public class Query12 extends QueryAbstractClass {

	@Override
	protected void executeQuery(Query qry) throws BusClassException {

		Filter filtroFecha = qry.getFilter("filtroPeriodo");

		Date fechaInicio = (Date) filtroFecha.getValue(0);
		Date fechaFin = (Date) filtroFecha.getValue(1);

		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		String fechaInicioStr = sdf.format(fechaInicio);
		String fechaFinStr = sdf.format(fechaFin);

		try {
			Connection conn = this.getCurrentConnection();
			Statement stmt = conn.createStatement();

			String query =	
					"(select ent_att.ent_inst_att_str_value as org, count(*) as ctd " + 
					" y cantidad que se repite " + 
					" " + 
					"from bus_ent_inst_attribute ent_att " + 
					"  join attribute att on ent_att.att_id = att.att_id_auto and ent_att.env_id = att.env_id " + 
					"  join bus_ent_instance bei on bei.env_id = ent_att.env_id and bei.bus_ent_inst_id_auto = ent_att.bus_ent_inst_id " + 
					" " + 
					"--Denuncia " + 
					"where bei.att_value_10 = '1' " + 
					"  and bei.bus_ent_inst_id_auto in (select bei.bus_ent_inst_id_auto " + 
					" " + 
					"  from bus_ent_inst_attribute ent_att " + 
					"    join attribute att on ent_att.att_id = att.att_id_auto and ent_att.env_id = att.env_id " + 
					"    join bus_ent_instance bei on bei.env_id = ent_att.env_id and bei.bus_ent_inst_id_auto = ent_att.bus_ent_inst_id " + 
					" " + 
					"  where att.att_name = 'INDDHH_OPCIONES_ADMISIBLE_STR' " + 
					"    and bei.bus_ent_id = 1379 and bei.att_value_10 = '1' " + 
					"    and ent_att.ent_inst_att_str_value = '2' " + 
					"    and bei.env_id = 1 and ent_att.env_id = 1) " + 
					" " + 
					"  and att.att_name = 'INDDHH_ORG_INCISO_TABLA_STR'  " + 
					"  and bei.bus_ent_id = 1379 " + 
					"  and bei.env_id = 1 and ent_att.env_id = 1 "
					+ "and bei.bus_ent_inst_create_data >= timestamp '" + fechaInicioStr + "' "
					+ "and bei.bus_ent_inst_create_data <= timestamp '" + fechaFinStr + "' " + ") as ctd" +
					" " + 
					"group by org " + 
					" " + 
					"order by ctd desc " + 
					") " + 
					" " + 
					"UNION ALL " + 
					"(SELECT 'Total de denuncias' as org, " + 
					"  (select count(*) " + 
					" " + 
					"  from bus_ent_inst_attribute ent_att " + 
					"    join attribute att on ent_att.att_id = att.att_id_auto and ent_att.env_id = att.env_id " + 
					"    join bus_ent_instance bei on bei.env_id = ent_att.env_id and bei.bus_ent_inst_id_auto = ent_att.bus_ent_inst_id " + 
					" " + 
					"  where bei.att_value_10 = '1' " + 
					"    and att.att_name = 'INDDHH_OPCIONES_ADMISIBLE_STR' " + 
					"    and bei.bus_ent_id = 1379 " + 
					"    and ent_att.ent_inst_att_str_value = '2' " + 
					"    and bei.env_id = 1 and ent_att.env_id = 1 "
					+ "and bei.bus_ent_inst_create_data >= timestamp '" + fechaInicioStr + "' "
					+ "and bei.bus_ent_inst_create_data <= timestamp '" + fechaFinStr + "' " + ") as ctd" +
					")";
			
			ResultSet rs = stmt.executeQuery(query);

			qry.getData().clear();
			
			while (rs.next()) {
				ArrayList row = new ArrayList();
				
				row.add(rs.getString("org"));
				row.add(rs.getString("ctd"));
				
				qry.getData().addRow(row);
			}			

		} catch (SQLException e1) {
			e1.printStackTrace();
		}

	}

}
