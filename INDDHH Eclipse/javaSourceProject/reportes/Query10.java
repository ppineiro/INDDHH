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

public class Query10 extends QueryAbstractClass {

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
					"(SELECT 'Acceso a información pública' as derecho, " + 
					"    (select count(*) " + 
					" " + 
					"    from bus_ent_inst_attribute ent_att " + 
					"      join attribute att on ent_att.att_id = att.att_id_auto and ent_att.env_id = att.env_id " + 
					"      join bus_ent_instance bei on bei.env_id = ent_att.env_id and bei.bus_ent_inst_id_auto = ent_att.bus_ent_inst_id " + 
					" " + 
					"    where bei.att_value_10 = '1' " + 
					"      and bei.bus_ent_inst_id_auto in (select bei.bus_ent_inst_id_auto " + 
					" " + 
					"      from bus_ent_inst_attribute ent_att " + 
					"        join attribute att on ent_att.att_id = att.att_id_auto and ent_att.env_id = att.env_id " + 
					"        join bus_ent_instance bei on bei.env_id = ent_att.env_id and bei.bus_ent_inst_id_auto = ent_att.bus_ent_inst_id " + 
					" " + 
					"      where att.att_name = 'INDDHH_OPCIONES_ADMISIBLE_STR' " + 
					"        and bei.bus_ent_id = 1379 and bei.att_value_10 = '1' " + 
					"        and ent_att.ent_inst_att_str_value = '2' " + 
					"        and bei.env_id = 1 and ent_att.env_id = 1) " + 
					" " + 
					"      and att.att_name = 'INDDHH_SELECCIONAR_DERECHO_STR' " + 
					"      and ent_att.att_index_id = 1  " + 
					"      and bei.bus_ent_id = 1379 " + 
					"      and ent_att.ent_inst_att_str_value = 'true' " + 
					"      and bei.env_id = 1 and ent_att.env_id = 1 "
					+ "and bei.bus_ent_inst_create_data >= timestamp '" + fechaInicioStr + "' "
					+ "and bei.bus_ent_inst_create_data <= timestamp '" + fechaFinStr + "' " + ") as ctd" + 
					") " + 
					" " + 
					"UNION ALL " + 
					"  (SELECT 'Alimentación' as derecho, " + 
					"    (select count(*) " + 
					" " + 
					"    from bus_ent_inst_attribute ent_att " + 
					"      join attribute att on ent_att.att_id = att.att_id_auto and ent_att.env_id = att.env_id " + 
					"      join bus_ent_instance bei on bei.env_id = ent_att.env_id and bei.bus_ent_inst_id_auto = ent_att.bus_ent_inst_id " + 
					" " + 
					"    where bei.att_value_10 = '1' " + 
					"      and bei.bus_ent_inst_id_auto in (select bei.bus_ent_inst_id_auto " + 
					" " + 
					"      from bus_ent_inst_attribute ent_att " + 
					"        join attribute att on ent_att.att_id = att.att_id_auto and ent_att.env_id = att.env_id " + 
					"        join bus_ent_instance bei on bei.env_id = ent_att.env_id and bei.bus_ent_inst_id_auto = ent_att.bus_ent_inst_id " + 
					" " + 
					"      where att.att_name = 'INDDHH_OPCIONES_ADMISIBLE_STR' " + 
					"        and bei.bus_ent_id = 1379 and bei.att_value_10 = '1' " + 
					"        and ent_att.ent_inst_att_str_value = '2' " + 
					"        and bei.env_id = 1 and ent_att.env_id = 1) " + 
					" " + 
					"      and att.att_name = 'INDDHH_SELECCIONAR_DERECHO_STR' " + 
					"      and ent_att.att_index_id = 2  " + 
					"      and bei.bus_ent_id = 1379 " + 
					"      and ent_att.ent_inst_att_str_value = 'true' " + 
					"      and bei.env_id = 1 and ent_att.env_id = 1 "
					+ "and bei.bus_ent_inst_create_data >= timestamp '" + fechaInicioStr + "' "
					+ "and bei.bus_ent_inst_create_data <= timestamp '" + fechaFinStr + "' " + ") as ctd" + 
					") " + 
					" " + 
					"UNION ALL " + 
					"  (SELECT 'Ambiente sano' as derecho, " + 
					"    (select count(*) " + 
					" " + 
					"    from bus_ent_inst_attribute ent_att " + 
					"      join attribute att on ent_att.att_id = att.att_id_auto and ent_att.env_id = att.env_id " + 
					"      join bus_ent_instance bei on bei.env_id = ent_att.env_id and bei.bus_ent_inst_id_auto = ent_att.bus_ent_inst_id " + 
					" " + 
					"    where bei.att_value_10 = '1' " + 
					"      and bei.bus_ent_inst_id_auto in (select bei.bus_ent_inst_id_auto " + 
					" " + 
					"      from bus_ent_inst_attribute ent_att " + 
					"        join attribute att on ent_att.att_id = att.att_id_auto and ent_att.env_id = att.env_id " + 
					"        join bus_ent_instance bei on bei.env_id = ent_att.env_id and bei.bus_ent_inst_id_auto = ent_att.bus_ent_inst_id " + 
					" " + 
					"      where att.att_name = 'INDDHH_OPCIONES_ADMISIBLE_STR' " + 
					"        and bei.bus_ent_id = 1379 and bei.att_value_10 = '1' " + 
					"        and ent_att.ent_inst_att_str_value = '2' " + 
					"        and bei.env_id = 1 and ent_att.env_id = 1) " + 
					" " + 
					"      and att.att_name = 'INDDHH_SELECCIONAR_DERECHO_STR' " + 
					"      and ent_att.att_index_id = 3  " + 
					"      and bei.bus_ent_id = 1379 " + 
					"      and ent_att.ent_inst_att_str_value = 'true' " + 
					"      and bei.env_id = 1 and ent_att.env_id = 1 "
					+ "and bei.bus_ent_inst_create_data >= timestamp '" + fechaInicioStr + "' "
					+ "and bei.bus_ent_inst_create_data <= timestamp '" + fechaFinStr + "' " + ") as ctd" + 
					") " + 
					" " + 
					"UNION ALL " + 
					"  (SELECT 'Debido proceso administrativo' as derecho, " + 
					"    (select count(*) " + 
					" " + 
					"    from bus_ent_inst_attribute ent_att " + 
					"      join attribute att on ent_att.att_id = att.att_id_auto and ent_att.env_id = att.env_id " + 
					"      join bus_ent_instance bei on bei.env_id = ent_att.env_id and bei.bus_ent_inst_id_auto = ent_att.bus_ent_inst_id " + 
					" " + 
					"    where bei.att_value_10 = '1' " + 
					"      and bei.bus_ent_inst_id_auto in (select bei.bus_ent_inst_id_auto " + 
					" " + 
					"      from bus_ent_inst_attribute ent_att " + 
					"        join attribute att on ent_att.att_id = att.att_id_auto and ent_att.env_id = att.env_id " + 
					"        join bus_ent_instance bei on bei.env_id = ent_att.env_id and bei.bus_ent_inst_id_auto = ent_att.bus_ent_inst_id " + 
					" " + 
					"      where att.att_name = 'INDDHH_OPCIONES_ADMISIBLE_STR' " + 
					"        and bei.bus_ent_id = 1379 and bei.att_value_10 = '1' " + 
					"        and ent_att.ent_inst_att_str_value = '2' " + 
					"        and bei.env_id = 1 and ent_att.env_id = 1) " + 
					" " + 
					"      and att.att_name = 'INDDHH_SELECCIONAR_DERECHO_STR' " + 
					"      and ent_att.att_index_id = 4  " + 
					"      and bei.bus_ent_id = 1379 " + 
					"      and ent_att.ent_inst_att_str_value = 'true' " + 
					"      and bei.env_id = 1 and ent_att.env_id = 1 "
					+ "and bei.bus_ent_inst_create_data >= timestamp '" + fechaInicioStr + "' "
					+ "and bei.bus_ent_inst_create_data <= timestamp '" + fechaFinStr + "' " + ") as ctd" + 
					") " + 
					" " + 
					"UNION ALL " + 
					"  (SELECT 'Educación' as derecho, " + 
					"    (select count(*) " + 
					" " + 
					"    from bus_ent_inst_attribute ent_att " + 
					"      join attribute att on ent_att.att_id = att.att_id_auto and ent_att.env_id = att.env_id " + 
					"      join bus_ent_instance bei on bei.env_id = ent_att.env_id and bei.bus_ent_inst_id_auto = ent_att.bus_ent_inst_id " + 
					" " + 
					"    where bei.att_value_10 = '1' " + 
					"      and bei.bus_ent_inst_id_auto in (select bei.bus_ent_inst_id_auto " + 
					" " + 
					"      from bus_ent_inst_attribute ent_att " + 
					"        join attribute att on ent_att.att_id = att.att_id_auto and ent_att.env_id = att.env_id " + 
					"        join bus_ent_instance bei on bei.env_id = ent_att.env_id and bei.bus_ent_inst_id_auto = ent_att.bus_ent_inst_id " + 
					" " + 
					"      where att.att_name = 'INDDHH_OPCIONES_ADMISIBLE_STR' " + 
					"        and bei.bus_ent_id = 1379 and bei.att_value_10 = '1' " + 
					"        and ent_att.ent_inst_att_str_value = '2' " + 
					"        and bei.env_id = 1 and ent_att.env_id = 1) " + 
					" " + 
					"      and att.att_name = 'INDDHH_SELECCIONAR_DERECHO_STR' " + 
					"      and ent_att.att_index_id = 5  " + 
					"      and bei.bus_ent_id = 1379 " + 
					"      and ent_att.ent_inst_att_str_value = 'true' " + 
					"      and bei.env_id = 1 and ent_att.env_id = 1 "
					+ "and bei.bus_ent_inst_create_data >= timestamp '" + fechaInicioStr + "' "
					+ "and bei.bus_ent_inst_create_data <= timestamp '" + fechaFinStr + "' " + ") as ctd" + 
					") " + 
					" " + 
					"UNION ALL " + 
					"  (SELECT 'Identidad' as derecho, " + 
					"    (select count(*) " + 
					" " + 
					"    from bus_ent_inst_attribute ent_att " + 
					"      join attribute att on ent_att.att_id = att.att_id_auto and ent_att.env_id = att.env_id " + 
					"      join bus_ent_instance bei on bei.env_id = ent_att.env_id and bei.bus_ent_inst_id_auto = ent_att.bus_ent_inst_id " + 
					" " + 
					"    where bei.att_value_10 = '1' " + 
					"      and bei.bus_ent_inst_id_auto in (select bei.bus_ent_inst_id_auto " + 
					" " + 
					"      from bus_ent_inst_attribute ent_att " + 
					"        join attribute att on ent_att.att_id = att.att_id_auto and ent_att.env_id = att.env_id " + 
					"        join bus_ent_instance bei on bei.env_id = ent_att.env_id and bei.bus_ent_inst_id_auto = ent_att.bus_ent_inst_id " + 
					" " + 
					"      where att.att_name = 'INDDHH_OPCIONES_ADMISIBLE_STR' " + 
					"        and bei.bus_ent_id = 1379 and bei.att_value_10 = '1' " + 
					"        and ent_att.ent_inst_att_str_value = '2' " + 
					"        and bei.env_id = 1 and ent_att.env_id = 1) " + 
					" " + 
					"      and att.att_name = 'INDDHH_SELECCIONAR_DERECHO_STR' " + 
					"      and ent_att.att_index_id = 6  " + 
					"      and bei.bus_ent_id = 1379 " + 
					"      and ent_att.ent_inst_att_str_value = 'true' " + 
					"      and bei.env_id = 1 and ent_att.env_id = 1 "
					+ "and bei.bus_ent_inst_create_data >= timestamp '" + fechaInicioStr + "' "
					+ "and bei.bus_ent_inst_create_data <= timestamp '" + fechaFinStr + "' " + ") as ctd" + 
					") " + 
					" " + 
					"UNION ALL " + 
					"  (SELECT 'Igualdad y no discriminación por edad' as derecho, " + 
					"    (select count(*) " + 
					" " + 
					"    from bus_ent_inst_attribute ent_att " + 
					"      join attribute att on ent_att.att_id = att.att_id_auto and ent_att.env_id = att.env_id " + 
					"      join bus_ent_instance bei on bei.env_id = ent_att.env_id and bei.bus_ent_inst_id_auto = ent_att.bus_ent_inst_id " + 
					" " + 
					"    where bei.att_value_10 = '1' " + 
					"      and bei.bus_ent_inst_id_auto in (select bei.bus_ent_inst_id_auto " + 
					" " + 
					"      from bus_ent_inst_attribute ent_att " + 
					"        join attribute att on ent_att.att_id = att.att_id_auto and ent_att.env_id = att.env_id " + 
					"        join bus_ent_instance bei on bei.env_id = ent_att.env_id and bei.bus_ent_inst_id_auto = ent_att.bus_ent_inst_id " + 
					" " + 
					"      where att.att_name = 'INDDHH_OPCIONES_ADMISIBLE_STR' " + 
					"        and bei.bus_ent_id = 1379 and bei.att_value_10 = '1' " + 
					"        and ent_att.ent_inst_att_str_value = '2' " + 
					"        and bei.env_id = 1 and ent_att.env_id = 1) " + 
					" " + 
					"      and att.att_name = 'INDDHH_SELECCIONAR_DERECHO_STR' " + 
					"      and ent_att.att_index_id = 7  " + 
					"      and bei.bus_ent_id = 1379 " + 
					"      and ent_att.ent_inst_att_str_value = 'true' " + 
					"      and bei.env_id = 1 and ent_att.env_id = 1 "
					+ "and bei.bus_ent_inst_create_data >= timestamp '" + fechaInicioStr + "' "
					+ "and bei.bus_ent_inst_create_data <= timestamp '" + fechaFinStr + "' " + ") as ctd" + 
					") " + 
					" " + 
					"UNION ALL " + 
					"  (SELECT 'Igualdad y no discriminación de género' as derecho, " + 
					"    (select count(*) " + 
					" " + 
					"    from bus_ent_inst_attribute ent_att " + 
					"      join attribute att on ent_att.att_id = att.att_id_auto and ent_att.env_id = att.env_id " + 
					"      join bus_ent_instance bei on bei.env_id = ent_att.env_id and bei.bus_ent_inst_id_auto = ent_att.bus_ent_inst_id " + 
					" " + 
					"    where bei.att_value_10 = '1' " + 
					"      and bei.bus_ent_inst_id_auto in (select bei.bus_ent_inst_id_auto " + 
					" " + 
					"      from bus_ent_inst_attribute ent_att " + 
					"        join attribute att on ent_att.att_id = att.att_id_auto and ent_att.env_id = att.env_id " + 
					"        join bus_ent_instance bei on bei.env_id = ent_att.env_id and bei.bus_ent_inst_id_auto = ent_att.bus_ent_inst_id " + 
					" " + 
					"      where att.att_name = 'INDDHH_OPCIONES_ADMISIBLE_STR' " + 
					"        and bei.bus_ent_id = 1379 and bei.att_value_10 = '1' " + 
					"        and ent_att.ent_inst_att_str_value = '2' " + 
					"        and bei.env_id = 1 and ent_att.env_id = 1) " + 
					" " + 
					"      and att.att_name = 'INDDHH_SELECCIONAR_DERECHO_STR' " + 
					"      and ent_att.att_index_id = 8  " + 
					"      and bei.bus_ent_id = 1379 " + 
					"      and ent_att.ent_inst_att_str_value = 'true' " + 
					"      and bei.env_id = 1 and ent_att.env_id = 1 "
					+ "and bei.bus_ent_inst_create_data >= timestamp '" + fechaInicioStr + "' "
					+ "and bei.bus_ent_inst_create_data <= timestamp '" + fechaFinStr + "' " + ") as ctd" + 
					") " + 
					" " + 
					"UNION ALL " + 
					"  (SELECT 'Igualdad y no discriminación por discapacidad' as derecho, " + 
					"    (select count(*) " + 
					" " + 
					"    from bus_ent_inst_attribute ent_att " + 
					"      join attribute att on ent_att.att_id = att.att_id_auto and ent_att.env_id = att.env_id " + 
					"      join bus_ent_instance bei on bei.env_id = ent_att.env_id and bei.bus_ent_inst_id_auto = ent_att.bus_ent_inst_id " + 
					" " + 
					"    where bei.att_value_10 = '1' " + 
					"      and bei.bus_ent_inst_id_auto in (select bei.bus_ent_inst_id_auto " + 
					" " + 
					"      from bus_ent_inst_attribute ent_att " + 
					"        join attribute att on ent_att.att_id = att.att_id_auto and ent_att.env_id = att.env_id " + 
					"        join bus_ent_instance bei on bei.env_id = ent_att.env_id and bei.bus_ent_inst_id_auto = ent_att.bus_ent_inst_id " + 
					" " + 
					"      where att.att_name = 'INDDHH_OPCIONES_ADMISIBLE_STR' " + 
					"        and bei.bus_ent_id = 1379 and bei.att_value_10 = '1' " + 
					"        and ent_att.ent_inst_att_str_value = '2' " + 
					"        and bei.env_id = 1 and ent_att.env_id = 1) " + 
					" " + 
					"      and att.att_name = 'INDDHH_SELECCIONAR_DERECHO_STR' " + 
					"      and ent_att.att_index_id = 9  " + 
					"      and bei.bus_ent_id = 1379 " + 
					"      and ent_att.ent_inst_att_str_value = 'true' " + 
					"      and bei.env_id = 1 and ent_att.env_id = 1 "
					+ "and bei.bus_ent_inst_create_data >= timestamp '" + fechaInicioStr + "' "
					+ "and bei.bus_ent_inst_create_data <= timestamp '" + fechaFinStr + "' " + ") as ctd" + 
					") " + 
					" " + 
					"UNION ALL " + 
					"  (SELECT 'Igualdad y no discriminación por identidad sexual y orientación sexual' as derecho, " + 
					"    (select count(*) " + 
					" " + 
					"    from bus_ent_inst_attribute ent_att " + 
					"      join attribute att on ent_att.att_id = att.att_id_auto and ent_att.env_id = att.env_id " + 
					"      join bus_ent_instance bei on bei.env_id = ent_att.env_id and bei.bus_ent_inst_id_auto = ent_att.bus_ent_inst_id " + 
					" " + 
					"    where bei.att_value_10 = '1' " + 
					"      and bei.bus_ent_inst_id_auto in (select bei.bus_ent_inst_id_auto " + 
					" " + 
					"      from bus_ent_inst_attribute ent_att " + 
					"        join attribute att on ent_att.att_id = att.att_id_auto and ent_att.env_id = att.env_id " + 
					"        join bus_ent_instance bei on bei.env_id = ent_att.env_id and bei.bus_ent_inst_id_auto = ent_att.bus_ent_inst_id " + 
					" " + 
					"      where att.att_name = 'INDDHH_OPCIONES_ADMISIBLE_STR' " + 
					"        and bei.bus_ent_id = 1379 and bei.att_value_10 = '1' " + 
					"        and ent_att.ent_inst_att_str_value = '2' " + 
					"        and bei.env_id = 1 and ent_att.env_id = 1) " + 
					" " + 
					"      and att.att_name = 'INDDHH_SELECCIONAR_DERECHO_STR' " + 
					"      and ent_att.att_index_id = 10  " + 
					"      and bei.bus_ent_id = 1379 " + 
					"      and ent_att.ent_inst_att_str_value = 'true' " + 
					"      and bei.env_id = 1 and ent_att.env_id = 1 "
					+ "and bei.bus_ent_inst_create_data >= timestamp '" + fechaInicioStr + "' "
					+ "and bei.bus_ent_inst_create_data <= timestamp '" + fechaFinStr + "' " + ") as ctd" + 
					") " + 
					" " + 
					"UNION ALL " + 
					"  (SELECT 'Igualdad y no discriminación por migrante' as derecho, " + 
					"    (select count(*) " + 
					" " + 
					"    from bus_ent_inst_attribute ent_att " + 
					"      join attribute att on ent_att.att_id = att.att_id_auto and ent_att.env_id = att.env_id " + 
					"      join bus_ent_instance bei on bei.env_id = ent_att.env_id and bei.bus_ent_inst_id_auto = ent_att.bus_ent_inst_id " + 
					" " + 
					"    where bei.att_value_10 = '1' " + 
					"      and bei.bus_ent_inst_id_auto in (select bei.bus_ent_inst_id_auto " + 
					" " + 
					"      from bus_ent_inst_attribute ent_att " + 
					"        join attribute att on ent_att.att_id = att.att_id_auto and ent_att.env_id = att.env_id " + 
					"        join bus_ent_instance bei on bei.env_id = ent_att.env_id and bei.bus_ent_inst_id_auto = ent_att.bus_ent_inst_id " + 
					" " + 
					"      where att.att_name = 'INDDHH_OPCIONES_ADMISIBLE_STR' " + 
					"        and bei.bus_ent_id = 1379 and bei.att_value_10 = '1' " + 
					"        and ent_att.ent_inst_att_str_value = '2' " + 
					"        and bei.env_id = 1 and ent_att.env_id = 1) " + 
					" " + 
					"      and att.att_name = 'INDDHH_SELECCIONAR_DERECHO_STR' " + 
					"      and ent_att.att_index_id = 11  " + 
					"      and bei.bus_ent_id = 1379 " + 
					"      and ent_att.ent_inst_att_str_value = 'true' " + 
					"      and bei.env_id = 1 and ent_att.env_id = 1 "
					+ "and bei.bus_ent_inst_create_data >= timestamp '" + fechaInicioStr + "' "
					+ "and bei.bus_ent_inst_create_data <= timestamp '" + fechaFinStr + "' " + ") as ctd" + 
					") " + 
					" " + 
					"UNION ALL " + 
					"  (SELECT 'Igualdad y no discriminación por motivos religiosos' as derecho, " + 
					"    (select count(*) " + 
					" " + 
					"    from bus_ent_inst_attribute ent_att " + 
					"      join attribute att on ent_att.att_id = att.att_id_auto and ent_att.env_id = att.env_id " + 
					"      join bus_ent_instance bei on bei.env_id = ent_att.env_id and bei.bus_ent_inst_id_auto = ent_att.bus_ent_inst_id " + 
					" " + 
					"    where bei.att_value_10 = '1' " + 
					"      and bei.bus_ent_inst_id_auto in (select bei.bus_ent_inst_id_auto " + 
					" " + 
					"      from bus_ent_inst_attribute ent_att " + 
					"        join attribute att on ent_att.att_id = att.att_id_auto and ent_att.env_id = att.env_id " + 
					"        join bus_ent_instance bei on bei.env_id = ent_att.env_id and bei.bus_ent_inst_id_auto = ent_att.bus_ent_inst_id " + 
					" " + 
					"      where att.att_name = 'INDDHH_OPCIONES_ADMISIBLE_STR' " + 
					"        and bei.bus_ent_id = 1379 and bei.att_value_10 = '1' " + 
					"        and ent_att.ent_inst_att_str_value = '2' " + 
					"        and bei.env_id = 1 and ent_att.env_id = 1) " + 
					" " + 
					"      and att.att_name = 'INDDHH_SELECCIONAR_DERECHO_STR' " + 
					"      and ent_att.att_index_id = 12  " + 
					"      and bei.bus_ent_id = 1379 " + 
					"      and ent_att.ent_inst_att_str_value = 'true' " + 
					"      and bei.env_id = 1 and ent_att.env_id = 1 "
					+ "and bei.bus_ent_inst_create_data >= timestamp '" + fechaInicioStr + "' "
					+ "and bei.bus_ent_inst_create_data <= timestamp '" + fechaFinStr + "' " + ") as ctd" + 
					") " + 
					" " + 
					"UNION ALL " + 
					"  (SELECT 'Igualdad y no discriminación por pobreza' as derecho, " + 
					"    (select count(*) " + 
					" " + 
					"    from bus_ent_inst_attribute ent_att " + 
					"      join attribute att on ent_att.att_id = att.att_id_auto and ent_att.env_id = att.env_id " + 
					"      join bus_ent_instance bei on bei.env_id = ent_att.env_id and bei.bus_ent_inst_id_auto = ent_att.bus_ent_inst_id " + 
					" " + 
					"    where bei.att_value_10 = '1' " + 
					"      and bei.bus_ent_inst_id_auto in (select bei.bus_ent_inst_id_auto " + 
					" " + 
					"      from bus_ent_inst_attribute ent_att " + 
					"        join attribute att on ent_att.att_id = att.att_id_auto and ent_att.env_id = att.env_id " + 
					"        join bus_ent_instance bei on bei.env_id = ent_att.env_id and bei.bus_ent_inst_id_auto = ent_att.bus_ent_inst_id " + 
					" " + 
					"      where att.att_name = 'INDDHH_OPCIONES_ADMISIBLE_STR' " + 
					"        and bei.bus_ent_id = 1379 and bei.att_value_10 = '1' " + 
					"        and ent_att.ent_inst_att_str_value = '2' " + 
					"        and bei.env_id = 1 and ent_att.env_id = 1) " + 
					" " + 
					"      and att.att_name = 'INDDHH_SELECCIONAR_DERECHO_STR' " + 
					"      and ent_att.att_index_id = 14  " + 
					"      and bei.bus_ent_id = 1379 " + 
					"      and ent_att.ent_inst_att_str_value = 'true' " + 
					"      and bei.env_id = 1 and ent_att.env_id = 1 "
					+ "and bei.bus_ent_inst_create_data >= timestamp '" + fechaInicioStr + "' "
					+ "and bei.bus_ent_inst_create_data <= timestamp '" + fechaFinStr + "' " + ") as ctd" + 
					") " + 
					" " + 
					"UNION ALL " + 
					"  (SELECT 'Igualdad y no discriminación étnico-racial' as derecho, " + 
					"    (select count(*) " + 
					" " + 
					"    from bus_ent_inst_attribute ent_att " + 
					"      join attribute att on ent_att.att_id = att.att_id_auto and ent_att.env_id = att.env_id " + 
					"      join bus_ent_instance bei on bei.env_id = ent_att.env_id and bei.bus_ent_inst_id_auto = ent_att.bus_ent_inst_id " + 
					" " + 
					"    where bei.att_value_10 = '1' " + 
					"      and bei.bus_ent_inst_id_auto in (select bei.bus_ent_inst_id_auto " + 
					" " + 
					"      from bus_ent_inst_attribute ent_att " + 
					"        join attribute att on ent_att.att_id = att.att_id_auto and ent_att.env_id = att.env_id " + 
					"        join bus_ent_instance bei on bei.env_id = ent_att.env_id and bei.bus_ent_inst_id_auto = ent_att.bus_ent_inst_id " + 
					" " + 
					"      where att.att_name = 'INDDHH_OPCIONES_ADMISIBLE_STR' " + 
					"        and bei.bus_ent_id = 1379 and bei.att_value_10 = '1' " + 
					"        and ent_att.ent_inst_att_str_value = '2' " + 
					"        and bei.env_id = 1 and ent_att.env_id = 1) " + 
					" " + 
					"      and att.att_name = 'INDDHH_SELECCIONAR_DERECHO_STR' " + 
					"      and ent_att.att_index_id = 15  " + 
					"      and bei.bus_ent_id = 1379 " + 
					"      and ent_att.ent_inst_att_str_value = 'true' " + 
					"      and bei.env_id = 1 and ent_att.env_id = 1 "
					+ "and bei.bus_ent_inst_create_data >= timestamp '" + fechaInicioStr + "' "
					+ "and bei.bus_ent_inst_create_data <= timestamp '" + fechaFinStr + "' " + ") as ctd" + 
					") " + 
					" " + 
					"UNION ALL " + 
					"  (SELECT 'Integridad personal (física, psíquica y moral)' as derecho, " + 
					"    (select count(*) " + 
					" " + 
					"    from bus_ent_inst_attribute ent_att " + 
					"      join attribute att on ent_att.att_id = att.att_id_auto and ent_att.env_id = att.env_id " + 
					"      join bus_ent_instance bei on bei.env_id = ent_att.env_id and bei.bus_ent_inst_id_auto = ent_att.bus_ent_inst_id " + 
					" " + 
					"    where bei.att_value_10 = '1' " + 
					"      and bei.bus_ent_inst_id_auto in (select bei.bus_ent_inst_id_auto " + 
					" " + 
					"      from bus_ent_inst_attribute ent_att " + 
					"        join attribute att on ent_att.att_id = att.att_id_auto and ent_att.env_id = att.env_id " + 
					"        join bus_ent_instance bei on bei.env_id = ent_att.env_id and bei.bus_ent_inst_id_auto = ent_att.bus_ent_inst_id " + 
					" " + 
					"      where att.att_name = 'INDDHH_OPCIONES_ADMISIBLE_STR' " + 
					"        and bei.bus_ent_id = 1379 and bei.att_value_10 = '1' " + 
					"        and ent_att.ent_inst_att_str_value = '2' " + 
					"        and bei.env_id = 1 and ent_att.env_id = 1) " + 
					" " + 
					"      and att.att_name = 'INDDHH_SELECCIONAR_DERECHO_STR' " + 
					"      and ent_att.att_index_id = 16  " + 
					"      and bei.bus_ent_id = 1379 " + 
					"      and ent_att.ent_inst_att_str_value = 'true' " + 
					"      and bei.env_id = 1 and ent_att.env_id = 1 "
					+ "and bei.bus_ent_inst_create_data >= timestamp '" + fechaInicioStr + "' "
					+ "and bei.bus_ent_inst_create_data <= timestamp '" + fechaFinStr + "' " + ") as ctd" + 
					") " + 
					" " + 
					"UNION ALL " + 
					"  (SELECT 'Intimidad' as derecho, " + 
					"    (select count(*) " + 
					" " + 
					"    from bus_ent_inst_attribute ent_att " + 
					"      join attribute att on ent_att.att_id = att.att_id_auto and ent_att.env_id = att.env_id " + 
					"      join bus_ent_instance bei on bei.env_id = ent_att.env_id and bei.bus_ent_inst_id_auto = ent_att.bus_ent_inst_id " + 
					" " + 
					"    where bei.att_value_10 = '1' " + 
					"      and bei.bus_ent_inst_id_auto in (select bei.bus_ent_inst_id_auto " + 
					" " + 
					"      from bus_ent_inst_attribute ent_att " + 
					"        join attribute att on ent_att.att_id = att.att_id_auto and ent_att.env_id = att.env_id " + 
					"        join bus_ent_instance bei on bei.env_id = ent_att.env_id and bei.bus_ent_inst_id_auto = ent_att.bus_ent_inst_id " + 
					" " + 
					"      where att.att_name = 'INDDHH_OPCIONES_ADMISIBLE_STR' " + 
					"        and bei.bus_ent_id = 1379 and bei.att_value_10 = '1' " + 
					"        and ent_att.ent_inst_att_str_value = '2' " + 
					"        and bei.env_id = 1 and ent_att.env_id = 1) " + 
					" " + 
					"      and att.att_name = 'INDDHH_SELECCIONAR_DERECHO_STR' " + 
					"      and ent_att.att_index_id = 17  " + 
					"      and bei.bus_ent_id = 1379 " + 
					"      and ent_att.ent_inst_att_str_value = 'true' " + 
					"      and bei.env_id = 1 and ent_att.env_id = 1 "
					+ "and bei.bus_ent_inst_create_data >= timestamp '" + fechaInicioStr + "' "
					+ "and bei.bus_ent_inst_create_data <= timestamp '" + fechaFinStr + "' " + ") as ctd" + 
					") " + 
					" " + 
					"UNION ALL " + 
					"  (SELECT 'Libertad de circulación y residencia' as derecho, " + 
					"    (select count(*) " + 
					" " + 
					"    from bus_ent_inst_attribute ent_att " + 
					"      join attribute att on ent_att.att_id = att.att_id_auto and ent_att.env_id = att.env_id " + 
					"      join bus_ent_instance bei on bei.env_id = ent_att.env_id and bei.bus_ent_inst_id_auto = ent_att.bus_ent_inst_id " + 
					" " + 
					"    where bei.att_value_10 = '1' " + 
					"      and bei.bus_ent_inst_id_auto in (select bei.bus_ent_inst_id_auto " + 
					" " + 
					"      from bus_ent_inst_attribute ent_att " + 
					"        join attribute att on ent_att.att_id = att.att_id_auto and ent_att.env_id = att.env_id " + 
					"        join bus_ent_instance bei on bei.env_id = ent_att.env_id and bei.bus_ent_inst_id_auto = ent_att.bus_ent_inst_id " + 
					" " + 
					"      where att.att_name = 'INDDHH_OPCIONES_ADMISIBLE_STR' " + 
					"        and bei.bus_ent_id = 1379 and bei.att_value_10 = '1' " + 
					"        and ent_att.ent_inst_att_str_value = '2' " + 
					"        and bei.env_id = 1 and ent_att.env_id = 1) " + 
					" " + 
					"      and att.att_name = 'INDDHH_SELECCIONAR_DERECHO_STR' " + 
					"      and ent_att.att_index_id = 18  " + 
					"      and bei.bus_ent_id = 1379 " + 
					"      and ent_att.ent_inst_att_str_value = 'true' " + 
					"      and bei.env_id = 1 and ent_att.env_id = 1 "
					+ "and bei.bus_ent_inst_create_data >= timestamp '" + fechaInicioStr + "' "
					+ "and bei.bus_ent_inst_create_data <= timestamp '" + fechaFinStr + "' " + ") as ctd" + 
					") " + 
					" " + 
					"UNION ALL " + 
					"  (SELECT 'Libertad de conciencia y de religión' as derecho, " + 
					"    (select count(*) " + 
					" " + 
					"    from bus_ent_inst_attribute ent_att " + 
					"      join attribute att on ent_att.att_id = att.att_id_auto and ent_att.env_id = att.env_id " + 
					"      join bus_ent_instance bei on bei.env_id = ent_att.env_id and bei.bus_ent_inst_id_auto = ent_att.bus_ent_inst_id " + 
					" " + 
					"    where bei.att_value_10 = '1' " + 
					"      and bei.bus_ent_inst_id_auto in (select bei.bus_ent_inst_id_auto " + 
					" " + 
					"      from bus_ent_inst_attribute ent_att " + 
					"        join attribute att on ent_att.att_id = att.att_id_auto and ent_att.env_id = att.env_id " + 
					"        join bus_ent_instance bei on bei.env_id = ent_att.env_id and bei.bus_ent_inst_id_auto = ent_att.bus_ent_inst_id " + 
					" " + 
					"      where att.att_name = 'INDDHH_OPCIONES_ADMISIBLE_STR' " + 
					"        and bei.bus_ent_id = 1379 and bei.att_value_10 = '1' " + 
					"        and ent_att.ent_inst_att_str_value = '2' " + 
					"        and bei.env_id = 1 and ent_att.env_id = 1) " + 
					" " + 
					"      and att.att_name = 'INDDHH_SELECCIONAR_DERECHO_STR' " + 
					"      and ent_att.att_index_id = 19  " + 
					"      and bei.bus_ent_id = 1379 " + 
					"      and ent_att.ent_inst_att_str_value = 'true' " + 
					"      and bei.env_id = 1 and ent_att.env_id = 1 "
					+ "and bei.bus_ent_inst_create_data >= timestamp '" + fechaInicioStr + "' "
					+ "and bei.bus_ent_inst_create_data <= timestamp '" + fechaFinStr + "' " + ") as ctd" + 
					") " + 
					" " + 
					"UNION ALL " + 
					"  (SELECT 'Libertad de expresión' as derecho, " + 
					"    (select count(*) " + 
					" " + 
					"    from bus_ent_inst_attribute ent_att " + 
					"      join attribute att on ent_att.att_id = att.att_id_auto and ent_att.env_id = att.env_id " + 
					"      join bus_ent_instance bei on bei.env_id = ent_att.env_id and bei.bus_ent_inst_id_auto = ent_att.bus_ent_inst_id " + 
					" " + 
					"    where bei.att_value_10 = '1' " + 
					"      and bei.bus_ent_inst_id_auto in (select bei.bus_ent_inst_id_auto " + 
					" " + 
					"      from bus_ent_inst_attribute ent_att " + 
					"        join attribute att on ent_att.att_id = att.att_id_auto and ent_att.env_id = att.env_id " + 
					"        join bus_ent_instance bei on bei.env_id = ent_att.env_id and bei.bus_ent_inst_id_auto = ent_att.bus_ent_inst_id " + 
					" " + 
					"      where att.att_name = 'INDDHH_OPCIONES_ADMISIBLE_STR' " + 
					"        and bei.bus_ent_id = 1379 and bei.att_value_10 = '1' " + 
					"        and ent_att.ent_inst_att_str_value = '2' " + 
					"        and bei.env_id = 1 and ent_att.env_id = 1) " + 
					" " + 
					"      and att.att_name = 'INDDHH_SELECCIONAR_DERECHO_STR' " + 
					"      and ent_att.att_index_id = 20  " + 
					"      and bei.bus_ent_id = 1379 " + 
					"      and ent_att.ent_inst_att_str_value = 'true' " + 
					"      and bei.env_id = 1 and ent_att.env_id = 1 "
					+ "and bei.bus_ent_inst_create_data >= timestamp '" + fechaInicioStr + "' "
					+ "and bei.bus_ent_inst_create_data <= timestamp '" + fechaFinStr + "' " + ") as ctd" + 
					") " + 
					" " + 
					"UNION ALL " + 
					"  (SELECT 'Libertad de reunión y asociación' as derecho, " + 
					"    (select count(*) " + 
					" " + 
					"    from bus_ent_inst_attribute ent_att " + 
					"      join attribute att on ent_att.att_id = att.att_id_auto and ent_att.env_id = att.env_id " + 
					"      join bus_ent_instance bei on bei.env_id = ent_att.env_id and bei.bus_ent_inst_id_auto = ent_att.bus_ent_inst_id " + 
					" " + 
					"    where bei.att_value_10 = '1' " + 
					"      and bei.bus_ent_inst_id_auto in (select bei.bus_ent_inst_id_auto " + 
					" " + 
					"      from bus_ent_inst_attribute ent_att " + 
					"        join attribute att on ent_att.att_id = att.att_id_auto and ent_att.env_id = att.env_id " + 
					"        join bus_ent_instance bei on bei.env_id = ent_att.env_id and bei.bus_ent_inst_id_auto = ent_att.bus_ent_inst_id " + 
					" " + 
					"      where att.att_name = 'INDDHH_OPCIONES_ADMISIBLE_STR' " + 
					"        and bei.bus_ent_id = 1379 and bei.att_value_10 = '1' " + 
					"        and ent_att.ent_inst_att_str_value = '2' " + 
					"        and bei.env_id = 1 and ent_att.env_id = 1) " + 
					" " + 
					"      and att.att_name = 'INDDHH_SELECCIONAR_DERECHO_STR' " + 
					"      and ent_att.att_index_id = 21  " + 
					"      and bei.bus_ent_id = 1379 " + 
					"      and ent_att.ent_inst_att_str_value = 'true' " + 
					"      and bei.env_id = 1 and ent_att.env_id = 1 "
					+ "and bei.bus_ent_inst_create_data >= timestamp '" + fechaInicioStr + "' "
					+ "and bei.bus_ent_inst_create_data <= timestamp '" + fechaFinStr + "' " + ") as ctd" + 
					") " + 
					" " + 
					"UNION ALL " + 
					"  (SELECT 'Libertad personal' as derecho, " + 
					"    (select count(*) " + 
					" " + 
					"    from bus_ent_inst_attribute ent_att " + 
					"      join attribute att on ent_att.att_id = att.att_id_auto and ent_att.env_id = att.env_id " + 
					"      join bus_ent_instance bei on bei.env_id = ent_att.env_id and bei.bus_ent_inst_id_auto = ent_att.bus_ent_inst_id " + 
					" " + 
					"    where bei.att_value_10 = '1' " + 
					"      and bei.bus_ent_inst_id_auto in (select bei.bus_ent_inst_id_auto " + 
					" " + 
					"      from bus_ent_inst_attribute ent_att " + 
					"        join attribute att on ent_att.att_id = att.att_id_auto and ent_att.env_id = att.env_id " + 
					"        join bus_ent_instance bei on bei.env_id = ent_att.env_id and bei.bus_ent_inst_id_auto = ent_att.bus_ent_inst_id " + 
					" " + 
					"      where att.att_name = 'INDDHH_OPCIONES_ADMISIBLE_STR' " + 
					"        and bei.bus_ent_id = 1379 and bei.att_value_10 = '1' " + 
					"        and ent_att.ent_inst_att_str_value = '2' " + 
					"        and bei.env_id = 1 and ent_att.env_id = 1) " + 
					" " + 
					"      and att.att_name = 'INDDHH_SELECCIONAR_DERECHO_STR' " + 
					"      and ent_att.att_index_id = 22  " + 
					"      and bei.bus_ent_id = 1379 " + 
					"      and ent_att.ent_inst_att_str_value = 'true' " + 
					"      and bei.env_id = 1 and ent_att.env_id = 1 "
					+ "and bei.bus_ent_inst_create_data >= timestamp '" + fechaInicioStr + "' "
					+ "and bei.bus_ent_inst_create_data <= timestamp '" + fechaFinStr + "' " + ") as ctd" + 
					") " + 
					" " + 
					"UNION ALL " + 
					"  (SELECT 'Participación política' as derecho, " + 
					"    (select count(*) " + 
					" " + 
					"    from bus_ent_inst_attribute ent_att " + 
					"      join attribute att on ent_att.att_id = att.att_id_auto and ent_att.env_id = att.env_id " + 
					"      join bus_ent_instance bei on bei.env_id = ent_att.env_id and bei.bus_ent_inst_id_auto = ent_att.bus_ent_inst_id " + 
					" " + 
					"    where bei.att_value_10 = '1' " + 
					"      and bei.bus_ent_inst_id_auto in (select bei.bus_ent_inst_id_auto " + 
					" " + 
					"      from bus_ent_inst_attribute ent_att " + 
					"        join attribute att on ent_att.att_id = att.att_id_auto and ent_att.env_id = att.env_id " + 
					"        join bus_ent_instance bei on bei.env_id = ent_att.env_id and bei.bus_ent_inst_id_auto = ent_att.bus_ent_inst_id " + 
					" " + 
					"      where att.att_name = 'INDDHH_OPCIONES_ADMISIBLE_STR' " + 
					"        and bei.bus_ent_id = 1379 and bei.att_value_10 = '1' " + 
					"        and ent_att.ent_inst_att_str_value = '2' " + 
					"        and bei.env_id = 1 and ent_att.env_id = 1) " + 
					" " + 
					"      and att.att_name = 'INDDHH_SELECCIONAR_DERECHO_STR' " + 
					"      and ent_att.att_index_id = 23  " + 
					"      and bei.bus_ent_id = 1379 " + 
					"      and ent_att.ent_inst_att_str_value = 'true' " + 
					"      and bei.env_id = 1 and ent_att.env_id = 1 "
					+ "and bei.bus_ent_inst_create_data >= timestamp '" + fechaInicioStr + "' "
					+ "and bei.bus_ent_inst_create_data <= timestamp '" + fechaFinStr + "' " + ") as ctd" + 
					") " + 
					" " + 
					"UNION ALL " + 
					"  (SELECT 'Prestación eficiente de servicios públicos' as derecho, " + 
					"    (select count(*) " + 
					" " + 
					"    from bus_ent_inst_attribute ent_att " + 
					"      join attribute att on ent_att.att_id = att.att_id_auto and ent_att.env_id = att.env_id " + 
					"      join bus_ent_instance bei on bei.env_id = ent_att.env_id and bei.bus_ent_inst_id_auto = ent_att.bus_ent_inst_id " + 
					" " + 
					"    where bei.att_value_10 = '1' " + 
					"      and bei.bus_ent_inst_id_auto in (select bei.bus_ent_inst_id_auto " + 
					" " + 
					"      from bus_ent_inst_attribute ent_att " + 
					"        join attribute att on ent_att.att_id = att.att_id_auto and ent_att.env_id = att.env_id " + 
					"        join bus_ent_instance bei on bei.env_id = ent_att.env_id and bei.bus_ent_inst_id_auto = ent_att.bus_ent_inst_id " + 
					" " + 
					"      where att.att_name = 'INDDHH_OPCIONES_ADMISIBLE_STR' " + 
					"        and bei.bus_ent_id = 1379 and bei.att_value_10 = '1' " + 
					"        and ent_att.ent_inst_att_str_value = '2' " + 
					"        and bei.env_id = 1 and ent_att.env_id = 1) " + 
					" " + 
					"      and att.att_name = 'INDDHH_SELECCIONAR_DERECHO_STR' " + 
					"      and ent_att.att_index_id = 24  " + 
					"      and bei.bus_ent_id = 1379 " + 
					"      and ent_att.ent_inst_att_str_value = 'true' " + 
					"      and bei.env_id = 1 and ent_att.env_id = 1 "
					+ "and bei.bus_ent_inst_create_data >= timestamp '" + fechaInicioStr + "' "
					+ "and bei.bus_ent_inst_create_data <= timestamp '" + fechaFinStr + "' " + ") as ctd" + 
					") " + 
					" " + 
					"UNION ALL " + 
					"  (SELECT 'Propiedad' as derecho, " + 
					"    (select count(*) " + 
					" " + 
					"    from bus_ent_inst_attribute ent_att " + 
					"      join attribute att on ent_att.att_id = att.att_id_auto and ent_att.env_id = att.env_id " + 
					"      join bus_ent_instance bei on bei.env_id = ent_att.env_id and bei.bus_ent_inst_id_auto = ent_att.bus_ent_inst_id " + 
					" " + 
					"    where bei.att_value_10 = '1' " + 
					"      and bei.bus_ent_inst_id_auto in (select bei.bus_ent_inst_id_auto " + 
					" " + 
					"      from bus_ent_inst_attribute ent_att " + 
					"        join attribute att on ent_att.att_id = att.att_id_auto and ent_att.env_id = att.env_id " + 
					"        join bus_ent_instance bei on bei.env_id = ent_att.env_id and bei.bus_ent_inst_id_auto = ent_att.bus_ent_inst_id " + 
					" " + 
					"      where att.att_name = 'INDDHH_OPCIONES_ADMISIBLE_STR' " + 
					"        and bei.bus_ent_id = 1379 and bei.att_value_10 = '1' " + 
					"        and ent_att.ent_inst_att_str_value = '2' " + 
					"        and bei.env_id = 1 and ent_att.env_id = 1) " + 
					" " + 
					"      and att.att_name = 'INDDHH_SELECCIONAR_DERECHO_STR' " + 
					"      and ent_att.att_index_id = 25  " + 
					"      and bei.bus_ent_id = 1379 " + 
					"      and ent_att.ent_inst_att_str_value = 'true' " + 
					"      and bei.env_id = 1 and ent_att.env_id = 1 "
					+ "and bei.bus_ent_inst_create_data >= timestamp '" + fechaInicioStr + "' "
					+ "and bei.bus_ent_inst_create_data <= timestamp '" + fechaFinStr + "' " + ") as ctd" + 
					") " + 
					" " + 
					"UNION ALL " + 
					"  (SELECT 'Proteccion familiar' as derecho, " + 
					"    (select count(*) " + 
					" " + 
					"    from bus_ent_inst_attribute ent_att " + 
					"      join attribute att on ent_att.att_id = att.att_id_auto and ent_att.env_id = att.env_id " + 
					"      join bus_ent_instance bei on bei.env_id = ent_att.env_id and bei.bus_ent_inst_id_auto = ent_att.bus_ent_inst_id " + 
					" " + 
					"    where bei.att_value_10 = '1' " + 
					"      and bei.bus_ent_inst_id_auto in (select bei.bus_ent_inst_id_auto " + 
					" " + 
					"      from bus_ent_inst_attribute ent_att " + 
					"        join attribute att on ent_att.att_id = att.att_id_auto and ent_att.env_id = att.env_id " + 
					"        join bus_ent_instance bei on bei.env_id = ent_att.env_id and bei.bus_ent_inst_id_auto = ent_att.bus_ent_inst_id " + 
					" " + 
					"      where att.att_name = 'INDDHH_OPCIONES_ADMISIBLE_STR' " + 
					"        and bei.bus_ent_id = 1379 and bei.att_value_10 = '1' " + 
					"        and ent_att.ent_inst_att_str_value = '2' " + 
					"        and bei.env_id = 1 and ent_att.env_id = 1) " + 
					" " + 
					"      and att.att_name = 'INDDHH_SELECCIONAR_DERECHO_STR' " + 
					"      and ent_att.att_index_id = 26  " + 
					"      and bei.bus_ent_id = 1379 " + 
					"      and ent_att.ent_inst_att_str_value = 'true' " + 
					"      and bei.env_id = 1 and ent_att.env_id = 1 "
					+ "and bei.bus_ent_inst_create_data >= timestamp '" + fechaInicioStr + "' "
					+ "and bei.bus_ent_inst_create_data <= timestamp '" + fechaFinStr + "' " + ") as ctd" + 
					") " + 
					" " + 
					"UNION ALL " + 
					"  (SELECT 'Protección judicial' as derecho, " + 
					"    (select count(*) " + 
					" " + 
					"    from bus_ent_inst_attribute ent_att " + 
					"      join attribute att on ent_att.att_id = att.att_id_auto and ent_att.env_id = att.env_id " + 
					"      join bus_ent_instance bei on bei.env_id = ent_att.env_id and bei.bus_ent_inst_id_auto = ent_att.bus_ent_inst_id " + 
					" " + 
					"    where bei.att_value_10 = '1' " + 
					"      and bei.bus_ent_inst_id_auto in (select bei.bus_ent_inst_id_auto " + 
					" " + 
					"      from bus_ent_inst_attribute ent_att " + 
					"        join attribute att on ent_att.att_id = att.att_id_auto and ent_att.env_id = att.env_id " + 
					"        join bus_ent_instance bei on bei.env_id = ent_att.env_id and bei.bus_ent_inst_id_auto = ent_att.bus_ent_inst_id " + 
					" " + 
					"      where att.att_name = 'INDDHH_OPCIONES_ADMISIBLE_STR' " + 
					"        and bei.bus_ent_id = 1379 and bei.att_value_10 = '1' " + 
					"        and ent_att.ent_inst_att_str_value = '2' " + 
					"        and bei.env_id = 1 and ent_att.env_id = 1) " + 
					" " + 
					"      and att.att_name = 'INDDHH_SELECCIONAR_DERECHO_STR' " + 
					"      and ent_att.att_index_id = 27  " + 
					"      and bei.bus_ent_id = 1379 " + 
					"      and ent_att.ent_inst_att_str_value = 'true' " + 
					"      and bei.env_id = 1 and ent_att.env_id = 1 "
					+ "and bei.bus_ent_inst_create_data >= timestamp '" + fechaInicioStr + "' "
					+ "and bei.bus_ent_inst_create_data <= timestamp '" + fechaFinStr + "' " + ") as ctd" + 
					") " + 
					" " + 
					"UNION ALL " + 
					"  (SELECT 'Reparación integral por violaciones de los DDHH' as derecho, " + 
					"    (select count(*) " + 
					" " + 
					"    from bus_ent_inst_attribute ent_att " + 
					"      join attribute att on ent_att.att_id = att.att_id_auto and ent_att.env_id = att.env_id " + 
					"      join bus_ent_instance bei on bei.env_id = ent_att.env_id and bei.bus_ent_inst_id_auto = ent_att.bus_ent_inst_id " + 
					" " + 
					"    where bei.att_value_10 = '1' " + 
					"      and bei.bus_ent_inst_id_auto in (select bei.bus_ent_inst_id_auto " + 
					" " + 
					"      from bus_ent_inst_attribute ent_att " + 
					"        join attribute att on ent_att.att_id = att.att_id_auto and ent_att.env_id = att.env_id " + 
					"        join bus_ent_instance bei on bei.env_id = ent_att.env_id and bei.bus_ent_inst_id_auto = ent_att.bus_ent_inst_id " + 
					" " + 
					"      where att.att_name = 'INDDHH_OPCIONES_ADMISIBLE_STR' " + 
					"        and bei.bus_ent_id = 1379 and bei.att_value_10 = '1' " + 
					"        and ent_att.ent_inst_att_str_value = '2' " + 
					"        and bei.env_id = 1 and ent_att.env_id = 1) " + 
					" " + 
					"      and att.att_name = 'INDDHH_SELECCIONAR_DERECHO_STR' " + 
					"      and ent_att.att_index_id = 28  " + 
					"      and bei.bus_ent_id = 1379 " + 
					"      and ent_att.ent_inst_att_str_value = 'true' " + 
					"      and bei.env_id = 1 and ent_att.env_id = 1 "
					+ "and bei.bus_ent_inst_create_data >= timestamp '" + fechaInicioStr + "' "
					+ "and bei.bus_ent_inst_create_data <= timestamp '" + fechaFinStr + "' " + ") as ctd" + 
					") " + 
					" " + 
					"UNION ALL " + 
					"  (SELECT 'Salud' as derecho, " + 
					"    (select count(*) " + 
					" " + 
					"    from bus_ent_inst_attribute ent_att " + 
					"      join attribute att on ent_att.att_id = att.att_id_auto and ent_att.env_id = att.env_id " + 
					"      join bus_ent_instance bei on bei.env_id = ent_att.env_id and bei.bus_ent_inst_id_auto = ent_att.bus_ent_inst_id " + 
					" " + 
					"    where bei.att_value_10 = '1' " + 
					"      and bei.bus_ent_inst_id_auto in (select bei.bus_ent_inst_id_auto " + 
					" " + 
					"      from bus_ent_inst_attribute ent_att " + 
					"        join attribute att on ent_att.att_id = att.att_id_auto and ent_att.env_id = att.env_id " + 
					"        join bus_ent_instance bei on bei.env_id = ent_att.env_id and bei.bus_ent_inst_id_auto = ent_att.bus_ent_inst_id " + 
					" " + 
					"      where att.att_name = 'INDDHH_OPCIONES_ADMISIBLE_STR' " + 
					"        and bei.bus_ent_id = 1379 and bei.att_value_10 = '1' " + 
					"        and ent_att.ent_inst_att_str_value = '2' " + 
					"        and bei.env_id = 1 and ent_att.env_id = 1) " + 
					" " + 
					"      and att.att_name = 'INDDHH_SELECCIONAR_DERECHO_STR' " + 
					"      and ent_att.att_index_id = 29  " + 
					"      and bei.bus_ent_id = 1379 " + 
					"      and ent_att.ent_inst_att_str_value = 'true' " + 
					"      and bei.env_id = 1 and ent_att.env_id = 1 "
					+ "and bei.bus_ent_inst_create_data >= timestamp '" + fechaInicioStr + "' "
					+ "and bei.bus_ent_inst_create_data <= timestamp '" + fechaFinStr + "' " + ") as ctd" + 
					") " + 
					"UNION ALL " + 
					"  (SELECT 'Seguridad social' as derecho, " + 
					"    (select count(*) " + 
					" " + 
					"    from bus_ent_inst_attribute ent_att " + 
					"      join attribute att on ent_att.att_id = att.att_id_auto and ent_att.env_id = att.env_id " + 
					"      join bus_ent_instance bei on bei.env_id = ent_att.env_id and bei.bus_ent_inst_id_auto = ent_att.bus_ent_inst_id " + 
					" " + 
					"    where bei.att_value_10 = '1' " + 
					"      and bei.bus_ent_inst_id_auto in (select bei.bus_ent_inst_id_auto " + 
					" " + 
					"      from bus_ent_inst_attribute ent_att " + 
					"        join attribute att on ent_att.att_id = att.att_id_auto and ent_att.env_id = att.env_id " + 
					"        join bus_ent_instance bei on bei.env_id = ent_att.env_id and bei.bus_ent_inst_id_auto = ent_att.bus_ent_inst_id " + 
					" " + 
					"      where att.att_name = 'INDDHH_OPCIONES_ADMISIBLE_STR' " + 
					"        and bei.bus_ent_id = 1379 and bei.att_value_10 = '1' " + 
					"        and ent_att.ent_inst_att_str_value = '2' " + 
					"        and bei.env_id = 1 and ent_att.env_id = 1) " + 
					" " + 
					"      and att.att_name = 'INDDHH_SELECCIONAR_DERECHO_STR' " + 
					"      and ent_att.att_index_id = 30  " + 
					"      and bei.bus_ent_id = 1379 " + 
					"      and ent_att.ent_inst_att_str_value = 'true' " + 
					"      and bei.env_id = 1 and ent_att.env_id = 1 "
					+ "and bei.bus_ent_inst_create_data >= timestamp '" + fechaInicioStr + "' "
					+ "and bei.bus_ent_inst_create_data <= timestamp '" + fechaFinStr + "' " + ") as ctd" + 
					") " + 
					" " + 
					"UNION ALL " + 
					"  (SELECT 'Trabajo' as derecho, " + 
					"    (select count(*) " + 
					" " + 
					"    from bus_ent_inst_attribute ent_att " + 
					"      join attribute att on ent_att.att_id = att.att_id_auto and ent_att.env_id = att.env_id " + 
					"      join bus_ent_instance bei on bei.env_id = ent_att.env_id and bei.bus_ent_inst_id_auto = ent_att.bus_ent_inst_id " + 
					" " + 
					"    where bei.att_value_10 = '1' " + 
					"      and bei.bus_ent_inst_id_auto in (select bei.bus_ent_inst_id_auto " + 
					" " + 
					"      from bus_ent_inst_attribute ent_att " + 
					"        join attribute att on ent_att.att_id = att.att_id_auto and ent_att.env_id = att.env_id " + 
					"        join bus_ent_instance bei on bei.env_id = ent_att.env_id and bei.bus_ent_inst_id_auto = ent_att.bus_ent_inst_id " + 
					" " + 
					"      where att.att_name = 'INDDHH_OPCIONES_ADMISIBLE_STR' " + 
					"        and bei.bus_ent_id = 1379 and bei.att_value_10 = '1' " + 
					"        and ent_att.ent_inst_att_str_value = '2' " + 
					"        and bei.env_id = 1 and ent_att.env_id = 1) " + 
					" " + 
					"      and att.att_name = 'INDDHH_SELECCIONAR_DERECHO_STR' " + 
					"      and ent_att.att_index_id = 31  " + 
					"      and bei.bus_ent_id = 1379 " + 
					"      and ent_att.ent_inst_att_str_value = 'true' " + 
					"      and bei.env_id = 1 and ent_att.env_id = 1 "
					+ "and bei.bus_ent_inst_create_data >= timestamp '" + fechaInicioStr + "' "
					+ "and bei.bus_ent_inst_create_data <= timestamp '" + fechaFinStr + "' " + ") as ctd" + 
					") " + 
					" " + 
					"UNION ALL " + 
					"  (SELECT 'Vida' as derecho, " + 
					"    (select count(*) " + 
					" " + 
					"    from bus_ent_inst_attribute ent_att " + 
					"      join attribute att on ent_att.att_id = att.att_id_auto and ent_att.env_id = att.env_id " + 
					"      join bus_ent_instance bei on bei.env_id = ent_att.env_id and bei.bus_ent_inst_id_auto = ent_att.bus_ent_inst_id " + 
					" " + 
					"    where bei.att_value_10 = '1' " + 
					"      and bei.bus_ent_inst_id_auto in (select bei.bus_ent_inst_id_auto " + 
					" " + 
					"      from bus_ent_inst_attribute ent_att " + 
					"        join attribute att on ent_att.att_id = att.att_id_auto and ent_att.env_id = att.env_id " + 
					"        join bus_ent_instance bei on bei.env_id = ent_att.env_id and bei.bus_ent_inst_id_auto = ent_att.bus_ent_inst_id " + 
					" " + 
					"      where att.att_name = 'INDDHH_OPCIONES_ADMISIBLE_STR' " + 
					"        and bei.bus_ent_id = 1379 and bei.att_value_10 = '1' " + 
					"        and ent_att.ent_inst_att_str_value = '2' " + 
					"        and bei.env_id = 1 and ent_att.env_id = 1) " + 
					" " + 
					"      and att.att_name = 'INDDHH_SELECCIONAR_DERECHO_STR' " + 
					"      and ent_att.att_index_id = 32  " + 
					"      and bei.bus_ent_id = 1379 " + 
					"      and ent_att.ent_inst_att_str_value = 'true' " + 
					"      and bei.env_id = 1 and ent_att.env_id = 1 "
					+ "and bei.bus_ent_inst_create_data >= timestamp '" + fechaInicioStr + "' "
					+ "and bei.bus_ent_inst_create_data <= timestamp '" + fechaFinStr + "' " + ") as ctd" + 
					") " + 
					" " + 
					"UNION ALL " + 
					"  (SELECT 'Vivienda' as derecho, " + 
					"    (select count(*) " + 
					" " + 
					"    from bus_ent_inst_attribute ent_att " + 
					"      join attribute att on ent_att.att_id = att.att_id_auto and ent_att.env_id = att.env_id " + 
					"      join bus_ent_instance bei on bei.env_id = ent_att.env_id and bei.bus_ent_inst_id_auto = ent_att.bus_ent_inst_id " + 
					" " + 
					"    where bei.att_value_10 = '1' " + 
					"      and bei.bus_ent_inst_id_auto in (select bei.bus_ent_inst_id_auto " + 
					" " + 
					"      from bus_ent_inst_attribute ent_att " + 
					"        join attribute att on ent_att.att_id = att.att_id_auto and ent_att.env_id = att.env_id " + 
					"        join bus_ent_instance bei on bei.env_id = ent_att.env_id and bei.bus_ent_inst_id_auto = ent_att.bus_ent_inst_id " + 
					" " + 
					"      where att.att_name = 'INDDHH_OPCIONES_ADMISIBLE_STR' " + 
					"        and bei.bus_ent_id = 1379 and bei.att_value_10 = '1' " + 
					"        and ent_att.ent_inst_att_str_value = '2' " + 
					"        and bei.env_id = 1 and ent_att.env_id = 1) " + 
					" " + 
					"      and att.att_name = 'INDDHH_SELECCIONAR_DERECHO_STR' " + 
					"      and ent_att.att_index_id = 33  " + 
					"      and bei.bus_ent_id = 1379 " + 
					"      and ent_att.ent_inst_att_str_value = 'true' " + 
					"      and bei.env_id = 1 and ent_att.env_id = 1 "
					+ "and bei.bus_ent_inst_create_data >= timestamp '" + fechaInicioStr + "' "
					+ "and bei.bus_ent_inst_create_data <= timestamp '" + fechaFinStr + "' " + ") as ctd" + 
					") " + 
					" " + 
					"union all " + 
					"  (SELECT 'Total' as derecho, " + 
					"    (select count(*) " + 
					" " + 
					"    from bus_ent_inst_attribute ent_att " + 
					"      join attribute att on ent_att.att_id = att.att_id_auto and ent_att.env_id = att.env_id " + 
					"      join bus_ent_instance bei on bei.env_id = ent_att.env_id and bei.bus_ent_inst_id_auto = ent_att.bus_ent_inst_id " + 
					" " + 
					"    where bei.att_value_10 = '1' " + 
					"      and att.att_name = 'INDDHH_OPCIONES_ADMISIBLE_STR' " + 
					"      and bei.bus_ent_id = 1379 " + 
					"      and ent_att.ent_inst_att_str_value = '2' " + 
					"      and bei.env_id = 1 and ent_att.env_id = 1 "
					+ "and bei.bus_ent_inst_create_data >= timestamp '" + fechaInicioStr + "' "
					+ "and bei.bus_ent_inst_create_data <= timestamp '" + fechaFinStr + "' " + ") as ctd" + 
					")";
			
			ResultSet rs = stmt.executeQuery(query);

			qry.getData().clear();
			
			while (rs.next()) {
				ArrayList row = new ArrayList();
				
				row.add(rs.getString("derecho"));
				row.add(rs.getString("ctd"));
				
				qry.getData().addRow(row);
			}			

		} catch (SQLException e1) {
			e1.printStackTrace();
		}

	}

}
