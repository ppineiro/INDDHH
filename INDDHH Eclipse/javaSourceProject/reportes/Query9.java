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

public class Query9 extends QueryAbstractClass {

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
				"(SELECT 'Montevideo' as depto, " + 
				"        (select count(*) " + 
				" " + 
				"        from bus_ent_instance bei " + 
				" " + 
				"        where bei.att_value_10 = '1' " + 
				"            and bei.bus_ent_inst_id_auto in (select bei.bus_ent_inst_id_auto " + 
				" " + 
				"            from bus_ent_inst_attribute ent_att " + 
				"                join attribute att on ent_att.att_id = att.att_id_auto and ent_att.env_id = att.env_id " + 
				"                join bus_ent_instance bei on bei.env_id = ent_att.env_id and bei.bus_ent_inst_id_auto = ent_att.bus_ent_inst_id " + 
				" " + 
				"            where att.att_name = 'INDDHH_OPCIONES_ADMISIBLE_STR' " + 
				"                and bei.bus_ent_id = 1379 and bei.att_value_10 = '1' " + 
				"                and ent_att.ent_inst_att_str_value = '2' " + 
				"                and bei.env_id = 1 and ent_att.env_id = 1) " + 
				" " + 
				"            and bei.bus_ent_id = 1379 " + 
				"            and bei.att_value_6 = '1'  " + 
				"            and bei.env_id = 1 "
				+ "and bei.bus_ent_inst_create_data >= timestamp '" + fechaInicioStr + "' "
				+ "and bei.bus_ent_inst_create_data <= timestamp '" + fechaFinStr + "' " + ") as ctd" + 
				") " + 
				" " + 
				"UNION ALL " + 
				"    (SELECT 'Artigas' as depto, " + 
				"        (select count(*) " + 
				" " + 
				"        from bus_ent_instance bei " + 
				" " + 
				"        where bei.att_value_10 = '1' " + 
				"            and bei.bus_ent_inst_id_auto in (select bei.bus_ent_inst_id_auto " + 
				" " + 
				"            from bus_ent_inst_attribute ent_att " + 
				"                join attribute att on ent_att.att_id = att.att_id_auto and ent_att.env_id = att.env_id " + 
				"                join bus_ent_instance bei on bei.env_id = ent_att.env_id and bei.bus_ent_inst_id_auto = ent_att.bus_ent_inst_id " + 
				" " + 
				"            where att.att_name = 'INDDHH_OPCIONES_ADMISIBLE_STR' " + 
				"                and bei.bus_ent_id = 1379 and bei.att_value_10 = '1' " + 
				"                and ent_att.ent_inst_att_str_value = '2' " + 
				"                and bei.env_id = 1 and ent_att.env_id = 1) " + 
				" " + 
				"            and bei.bus_ent_id = 1379 " + 
				"            and bei.att_value_6 = '2'  " + 
				"            and bei.env_id = 1 "
				+ "and bei.bus_ent_inst_create_data >= timestamp '" + fechaInicioStr + "' "
				+ "and bei.bus_ent_inst_create_data <= timestamp '" + fechaFinStr + "' " + ") as ctd" + 
				") " + 
				" " + 
				"UNION ALL " + 
				"    (SELECT 'Canelones' as depto, " + 
				"        (select count(*) " + 
				" " + 
				"        from bus_ent_instance bei " + 
				" " + 
				"        where bei.att_value_10 = '1' " + 
				"            and bei.bus_ent_inst_id_auto in (select bei.bus_ent_inst_id_auto " + 
				" " + 
				"            from bus_ent_inst_attribute ent_att " + 
				"                join attribute att on ent_att.att_id = att.att_id_auto and ent_att.env_id = att.env_id " + 
				"                join bus_ent_instance bei on bei.env_id = ent_att.env_id and bei.bus_ent_inst_id_auto = ent_att.bus_ent_inst_id " + 
				" " + 
				"            where att.att_name = 'INDDHH_OPCIONES_ADMISIBLE_STR' " + 
				"                and bei.bus_ent_id = 1379 and bei.att_value_10 = '1' " + 
				"                and ent_att.ent_inst_att_str_value = '2' " + 
				"                and bei.env_id = 1 and ent_att.env_id = 1) " + 
				" " + 
				"            and bei.bus_ent_id = 1379 " + 
				"            and bei.att_value_6 = '3'  " + 
				"            and bei.env_id = 1 "
				+ "and bei.bus_ent_inst_create_data >= timestamp '" + fechaInicioStr + "' "
				+ "and bei.bus_ent_inst_create_data <= timestamp '" + fechaFinStr + "' " + ") as ctd" + 
				") " + 
				" " + 
				"UNION ALL " + 
				"    (SELECT 'Cerro Largo' as depto, " + 
				"        (select count(*) " + 
				" " + 
				"        from bus_ent_instance bei " + 
				" " + 
				"        where bei.att_value_10 = '1' " + 
				"            and bei.bus_ent_inst_id_auto in (select bei.bus_ent_inst_id_auto " + 
				" " + 
				"            from bus_ent_inst_attribute ent_att " + 
				"                join attribute att on ent_att.att_id = att.att_id_auto and ent_att.env_id = att.env_id " + 
				"                join bus_ent_instance bei on bei.env_id = ent_att.env_id and bei.bus_ent_inst_id_auto = ent_att.bus_ent_inst_id " + 
				" " + 
				"            where att.att_name = 'INDDHH_OPCIONES_ADMISIBLE_STR' " + 
				"                and bei.bus_ent_id = 1379 and bei.att_value_10 = '1' " + 
				"                and ent_att.ent_inst_att_str_value = '2' " + 
				"                and bei.env_id = 1 and ent_att.env_id = 1) " + 
				" " + 
				"            and bei.bus_ent_id = 1379 " + 
				"            and bei.att_value_6 = '4'  " + 
				"            and bei.env_id = 1 "
				+ "and bei.bus_ent_inst_create_data >= timestamp '" + fechaInicioStr + "' "
				+ "and bei.bus_ent_inst_create_data <= timestamp '" + fechaFinStr + "' " + ") as ctd" + 
				") " + 
				" " + 
				"UNION ALL " + 
				"    (SELECT 'Colonia' as depto, " + 
				"        (select count(*) " + 
				" " + 
				"        from bus_ent_instance bei " + 
				" " + 
				"        where bei.att_value_10 = '1' " + 
				"            and bei.bus_ent_inst_id_auto in (select bei.bus_ent_inst_id_auto " + 
				" " + 
				"            from bus_ent_inst_attribute ent_att " + 
				"                join attribute att on ent_att.att_id = att.att_id_auto and ent_att.env_id = att.env_id " + 
				"                join bus_ent_instance bei on bei.env_id = ent_att.env_id and bei.bus_ent_inst_id_auto = ent_att.bus_ent_inst_id " + 
				" " + 
				"            where att.att_name = 'INDDHH_OPCIONES_ADMISIBLE_STR' " + 
				"                and bei.bus_ent_id = 1379 and bei.att_value_10 = '1' " + 
				"                and ent_att.ent_inst_att_str_value = '2' " + 
				"                and bei.env_id = 1 and ent_att.env_id = 1) " + 
				" " + 
				"            and bei.bus_ent_id = 1379 " + 
				"            and bei.att_value_6 = '5'  " + 
				"            and bei.env_id = 1 "
				+ "and bei.bus_ent_inst_create_data >= timestamp '" + fechaInicioStr + "' "
				+ "and bei.bus_ent_inst_create_data <= timestamp '" + fechaFinStr + "' " + ") as ctd" + 
				") " + 
				" " + 
				"UNION ALL " + 
				"    (SELECT 'Durazno' as depto, " + 
				"        (select count(*) " + 
				" " + 
				"        from bus_ent_instance bei " + 
				" " + 
				"        where bei.att_value_10 = '1' " + 
				"            and bei.bus_ent_inst_id_auto in (select bei.bus_ent_inst_id_auto " + 
				" " + 
				"            from bus_ent_inst_attribute ent_att " + 
				"                join attribute att on ent_att.att_id = att.att_id_auto and ent_att.env_id = att.env_id " + 
				"                join bus_ent_instance bei on bei.env_id = ent_att.env_id and bei.bus_ent_inst_id_auto = ent_att.bus_ent_inst_id " + 
				" " + 
				"            where att.att_name = 'INDDHH_OPCIONES_ADMISIBLE_STR' " + 
				"                and bei.bus_ent_id = 1379 and bei.att_value_10 = '1' " + 
				"                and ent_att.ent_inst_att_str_value = '2' " + 
				"                and bei.env_id = 1 and ent_att.env_id = 1) " + 
				" " + 
				"            and bei.bus_ent_id = 1379 " + 
				"            and bei.att_value_6 = '6'  " + 
				"            and bei.env_id = 1 "
				+ "and bei.bus_ent_inst_create_data >= timestamp '" + fechaInicioStr + "' "
				+ "and bei.bus_ent_inst_create_data <= timestamp '" + fechaFinStr + "' " + ") as ctd" + 
				") " + 
				" " + 
				"UNION ALL " + 
				"    (SELECT 'Flores' as depto, " + 
				"        (select count(*) " + 
				" " + 
				"        from bus_ent_instance bei " + 
				" " + 
				"        where bei.att_value_10 = '1' " + 
				"            and bei.bus_ent_inst_id_auto in (select bei.bus_ent_inst_id_auto " + 
				" " + 
				"            from bus_ent_inst_attribute ent_att " + 
				"                join attribute att on ent_att.att_id = att.att_id_auto and ent_att.env_id = att.env_id " + 
				"                join bus_ent_instance bei on bei.env_id = ent_att.env_id and bei.bus_ent_inst_id_auto = ent_att.bus_ent_inst_id " + 
				" " + 
				"            where att.att_name = 'INDDHH_OPCIONES_ADMISIBLE_STR' " + 
				"                and bei.bus_ent_id = 1379 and bei.att_value_10 = '1' " + 
				"                and ent_att.ent_inst_att_str_value = '2' " + 
				"                and bei.env_id = 1 and ent_att.env_id = 1) " + 
				" " + 
				"            and bei.bus_ent_id = 1379 " + 
				"            and bei.att_value_6 = '7'  " + 
				"            and bei.env_id = 1 "
				+ "and bei.bus_ent_inst_create_data >= timestamp '" + fechaInicioStr + "' "
				+ "and bei.bus_ent_inst_create_data <= timestamp '" + fechaFinStr + "' " + ") as ctd" + 
				") " + 
				" " + 
				"UNION ALL " + 
				"    (SELECT 'Florida' as depto, " + 
				"        (select count(*) " + 
				" " + 
				"        from bus_ent_instance bei " + 
				" " + 
				"        where bei.att_value_10 = '1' " + 
				"            and bei.bus_ent_inst_id_auto in (select bei.bus_ent_inst_id_auto " + 
				" " + 
				"            from bus_ent_inst_attribute ent_att " + 
				"                join attribute att on ent_att.att_id = att.att_id_auto and ent_att.env_id = att.env_id " + 
				"                join bus_ent_instance bei on bei.env_id = ent_att.env_id and bei.bus_ent_inst_id_auto = ent_att.bus_ent_inst_id " + 
				" " + 
				"            where att.att_name = 'INDDHH_OPCIONES_ADMISIBLE_STR' " + 
				"                and bei.bus_ent_id = 1379 and bei.att_value_10 = '1' " + 
				"                and ent_att.ent_inst_att_str_value = '2' " + 
				"                and bei.env_id = 1 and ent_att.env_id = 1) " + 
				" " + 
				"            and bei.bus_ent_id = 1379 " + 
				"            and bei.att_value_6 = '8'  " + 
				"            and bei.env_id = 1 "
				+ "and bei.bus_ent_inst_create_data >= timestamp '" + fechaInicioStr + "' "
				+ "and bei.bus_ent_inst_create_data <= timestamp '" + fechaFinStr + "' " + ") as ctd" + 
				") " + 
				" " + 
				"UNION ALL " + 
				"    (SELECT 'Lavalleja' as depto, " + 
				"        (select count(*) " + 
				" " + 
				"        from bus_ent_instance bei " + 
				" " + 
				"        where bei.att_value_10 = '1' " + 
				"            and bei.bus_ent_inst_id_auto in (select bei.bus_ent_inst_id_auto " + 
				" " + 
				"            from bus_ent_inst_attribute ent_att " + 
				"                join attribute att on ent_att.att_id = att.att_id_auto and ent_att.env_id = att.env_id " + 
				"                join bus_ent_instance bei on bei.env_id = ent_att.env_id and bei.bus_ent_inst_id_auto = ent_att.bus_ent_inst_id " + 
				" " + 
				"            where att.att_name = 'INDDHH_OPCIONES_ADMISIBLE_STR' " + 
				"                and bei.bus_ent_id = 1379 and bei.att_value_10 = '1' " + 
				"                and ent_att.ent_inst_att_str_value = '2' " + 
				"                and bei.env_id = 1 and ent_att.env_id = 1) " + 
				" " + 
				"            and bei.bus_ent_id = 1379 " + 
				"            and bei.att_value_6 = '9'  " + 
				"            and bei.env_id = 1 "
				+ "and bei.bus_ent_inst_create_data >= timestamp '" + fechaInicioStr + "' "
				+ "and bei.bus_ent_inst_create_data <= timestamp '" + fechaFinStr + "' " + ") as ctd" + 
				") " + 
				" " + 
				"UNION ALL " + 
				"    (SELECT 'Maldonado' as depto, " + 
				"        (select count(*) " + 
				" " + 
				"        from bus_ent_instance bei " + 
				" " + 
				"        where bei.att_value_10 = '1' " + 
				"            and bei.bus_ent_inst_id_auto in (select bei.bus_ent_inst_id_auto " + 
				" " + 
				"            from bus_ent_inst_attribute ent_att " + 
				"                join attribute att on ent_att.att_id = att.att_id_auto and ent_att.env_id = att.env_id " + 
				"                join bus_ent_instance bei on bei.env_id = ent_att.env_id and bei.bus_ent_inst_id_auto = ent_att.bus_ent_inst_id " + 
				" " + 
				"            where att.att_name = 'INDDHH_OPCIONES_ADMISIBLE_STR' " + 
				"                and bei.bus_ent_id = 1379 and bei.att_value_10 = '1' " + 
				"                and ent_att.ent_inst_att_str_value = '2' " + 
				"                and bei.env_id = 1 and ent_att.env_id = 1) " + 
				" " + 
				"            and bei.bus_ent_id = 1379 " + 
				"            and bei.att_value_6 = '10'  " + 
				"            and bei.env_id = 1 "
				+ "and bei.bus_ent_inst_create_data >= timestamp '" + fechaInicioStr + "' "
				+ "and bei.bus_ent_inst_create_data <= timestamp '" + fechaFinStr + "' " + ") as ctd" + 
				") " + 
				" " + 
				"UNION ALL " + 
				"    (SELECT 'Paysandú' as depto, " + 
				"        (select count(*) " + 
				" " + 
				"        from bus_ent_instance bei " + 
				" " + 
				"        where bei.att_value_10 = '1' " + 
				"            and bei.bus_ent_inst_id_auto in (select bei.bus_ent_inst_id_auto " + 
				" " + 
				"            from bus_ent_inst_attribute ent_att " + 
				"                join attribute att on ent_att.att_id = att.att_id_auto and ent_att.env_id = att.env_id " + 
				"                join bus_ent_instance bei on bei.env_id = ent_att.env_id and bei.bus_ent_inst_id_auto = ent_att.bus_ent_inst_id " + 
				" " + 
				"            where att.att_name = 'INDDHH_OPCIONES_ADMISIBLE_STR' " + 
				"                and bei.bus_ent_id = 1379 and bei.att_value_10 = '1' " + 
				"                and ent_att.ent_inst_att_str_value = '2' " + 
				"                and bei.env_id = 1 and ent_att.env_id = 1) " + 
				" " + 
				"            and bei.bus_ent_id = 1379 " + 
				"            and bei.att_value_6 = '11'  " + 
				"            and bei.env_id = 1 "
				+ "and bei.bus_ent_inst_create_data >= timestamp '" + fechaInicioStr + "' "
				+ "and bei.bus_ent_inst_create_data <= timestamp '" + fechaFinStr + "' " + ") as ctd" + 
				") " + 
				" " + 
				"UNION ALL " + 
				"    (SELECT 'Río Negro' as depto, " + 
				"        (select count(*) " + 
				" " + 
				"        from bus_ent_instance bei " + 
				" " + 
				"        where bei.att_value_10 = '1' " + 
				"            and bei.bus_ent_inst_id_auto in (select bei.bus_ent_inst_id_auto " + 
				" " + 
				"            from bus_ent_inst_attribute ent_att " + 
				"                join attribute att on ent_att.att_id = att.att_id_auto and ent_att.env_id = att.env_id " + 
				"                join bus_ent_instance bei on bei.env_id = ent_att.env_id and bei.bus_ent_inst_id_auto = ent_att.bus_ent_inst_id " + 
				" " + 
				"            where att.att_name = 'INDDHH_OPCIONES_ADMISIBLE_STR' " + 
				"                and bei.bus_ent_id = 1379 and bei.att_value_10 = '1' " + 
				"                and ent_att.ent_inst_att_str_value = '2' " + 
				"                and bei.env_id = 1 and ent_att.env_id = 1) " + 
				" " + 
				"            and bei.bus_ent_id = 1379 " + 
				"            and bei.att_value_6 = '12'  " + 
				"            and bei.env_id = 1 "
				+ "and bei.bus_ent_inst_create_data >= timestamp '" + fechaInicioStr + "' "
				+ "and bei.bus_ent_inst_create_data <= timestamp '" + fechaFinStr + "' " + ") as ctd" + 
				") " + 
				" " + 
				"UNION ALL " + 
				"    (SELECT 'Rivera' as depto, " + 
				"        (select count(*) " + 
				" " + 
				"        from bus_ent_instance bei " + 
				" " + 
				"        where bei.att_value_10 = '1' " + 
				"            and bei.bus_ent_inst_id_auto in (select bei.bus_ent_inst_id_auto " + 
				" " + 
				"            from bus_ent_inst_attribute ent_att " + 
				"                join attribute att on ent_att.att_id = att.att_id_auto and ent_att.env_id = att.env_id " + 
				"                join bus_ent_instance bei on bei.env_id = ent_att.env_id and bei.bus_ent_inst_id_auto = ent_att.bus_ent_inst_id " + 
				" " + 
				"            where att.att_name = 'INDDHH_OPCIONES_ADMISIBLE_STR' " + 
				"                and bei.bus_ent_id = 1379 and bei.att_value_10 = '1' " + 
				"                and ent_att.ent_inst_att_str_value = '2' " + 
				"                and bei.env_id = 1 and ent_att.env_id = 1) " + 
				" " + 
				"            and bei.bus_ent_id = 1379 " + 
				"            and bei.att_value_6 = '13'  " + 
				"            and bei.env_id = 1 "
				+ "and bei.bus_ent_inst_create_data >= timestamp '" + fechaInicioStr + "' "
				+ "and bei.bus_ent_inst_create_data <= timestamp '" + fechaFinStr + "' " + ") as ctd" + 
				") " + 
				" " + 
				"UNION ALL " + 
				"    (SELECT 'Rocha' as depto, " + 
				"        (select count(*) " + 
				" " + 
				"        from bus_ent_instance bei " + 
				" " + 
				"        where bei.att_value_10 = '1' " + 
				"            and bei.bus_ent_inst_id_auto in (select bei.bus_ent_inst_id_auto " + 
				" " + 
				"            from bus_ent_inst_attribute ent_att " + 
				"                join attribute att on ent_att.att_id = att.att_id_auto and ent_att.env_id = att.env_id " + 
				"                join bus_ent_instance bei on bei.env_id = ent_att.env_id and bei.bus_ent_inst_id_auto = ent_att.bus_ent_inst_id " + 
				" " + 
				"            where att.att_name = 'INDDHH_OPCIONES_ADMISIBLE_STR' " + 
				"                and bei.bus_ent_id = 1379 and bei.att_value_10 = '1' " + 
				"                and ent_att.ent_inst_att_str_value = '2' " + 
				"                and bei.env_id = 1 and ent_att.env_id = 1) " + 
				" " + 
				"            and bei.bus_ent_id = 1379 " + 
				"            and bei.att_value_6 = '14'  " + 
				"            and bei.env_id = 1 "
				+ "and bei.bus_ent_inst_create_data >= timestamp '" + fechaInicioStr + "' "
				+ "and bei.bus_ent_inst_create_data <= timestamp '" + fechaFinStr + "' " + ") as ctd" + 
				") " + 
				" " + 
				"UNION ALL " + 
				"    (SELECT 'Salto' as depto, " + 
				"        (select count(*) " + 
				" " + 
				"        from bus_ent_instance bei " + 
				" " + 
				"        where bei.att_value_10 = '1' " + 
				"            and bei.bus_ent_inst_id_auto in (select bei.bus_ent_inst_id_auto " + 
				" " + 
				"            from bus_ent_inst_attribute ent_att " + 
				"                join attribute att on ent_att.att_id = att.att_id_auto and ent_att.env_id = att.env_id " + 
				"                join bus_ent_instance bei on bei.env_id = ent_att.env_id and bei.bus_ent_inst_id_auto = ent_att.bus_ent_inst_id " + 
				" " + 
				"            where att.att_name = 'INDDHH_OPCIONES_ADMISIBLE_STR' " + 
				"                and bei.bus_ent_id = 1379 and bei.att_value_10 = '1' " + 
				"                and ent_att.ent_inst_att_str_value = '2' " + 
				"                and bei.env_id = 1 and ent_att.env_id = 1) " + 
				" " + 
				"            and bei.bus_ent_id = 1379 " + 
				"            and bei.att_value_6 = '15'  " + 
				"            and bei.env_id = 1 "
				+ "and bei.bus_ent_inst_create_data >= timestamp '" + fechaInicioStr + "' "
				+ "and bei.bus_ent_inst_create_data <= timestamp '" + fechaFinStr + "' " + ") as ctd" + 
				") " + 
				" " + 
				"UNION ALL " + 
				"    (SELECT 'San José' as depto, " + 
				"        (select count(*) " + 
				" " + 
				"        from bus_ent_instance bei " + 
				" " + 
				"        where bei.att_value_10 = '1' " + 
				"            and bei.bus_ent_inst_id_auto in (select bei.bus_ent_inst_id_auto " + 
				" " + 
				"            from bus_ent_inst_attribute ent_att " + 
				"                join attribute att on ent_att.att_id = att.att_id_auto and ent_att.env_id = att.env_id " + 
				"                join bus_ent_instance bei on bei.env_id = ent_att.env_id and bei.bus_ent_inst_id_auto = ent_att.bus_ent_inst_id " + 
				" " + 
				"            where att.att_name = 'INDDHH_OPCIONES_ADMISIBLE_STR' " + 
				"                and bei.bus_ent_id = 1379 and bei.att_value_10 = '1' " + 
				"                and ent_att.ent_inst_att_str_value = '2' " + 
				"                and bei.env_id = 1 and ent_att.env_id = 1) " + 
				" " + 
				"            and bei.bus_ent_id = 1379 " + 
				"            and bei.att_value_6 = '16'  " + 
				"            and bei.env_id = 1 "
				+ "and bei.bus_ent_inst_create_data >= timestamp '" + fechaInicioStr + "' "
				+ "and bei.bus_ent_inst_create_data <= timestamp '" + fechaFinStr + "' " + ") as ctd" + 
				") " + 
				" " + 
				"UNION ALL " + 
				"    (SELECT 'Soriano' as depto, " + 
				"        (select count(*) " + 
				" " + 
				"        from bus_ent_instance bei " + 
				" " + 
				"        where bei.att_value_10 = '1' " + 
				"            and bei.bus_ent_inst_id_auto in (select bei.bus_ent_inst_id_auto " + 
				" " + 
				"            from bus_ent_inst_attribute ent_att " + 
				"                join attribute att on ent_att.att_id = att.att_id_auto and ent_att.env_id = att.env_id " + 
				"                join bus_ent_instance bei on bei.env_id = ent_att.env_id and bei.bus_ent_inst_id_auto = ent_att.bus_ent_inst_id " + 
				" " + 
				"            where att.att_name = 'INDDHH_OPCIONES_ADMISIBLE_STR' " + 
				"                and bei.bus_ent_id = 1379 and bei.att_value_10 = '1' " + 
				"                and ent_att.ent_inst_att_str_value = '2' " + 
				"                and bei.env_id = 1 and ent_att.env_id = 1) " + 
				" " + 
				"            and bei.bus_ent_id = 1379 " + 
				"            and bei.att_value_6 = '17'  " + 
				"            and bei.env_id = 1 "
				+ "and bei.bus_ent_inst_create_data >= timestamp '" + fechaInicioStr + "' "
				+ "and bei.bus_ent_inst_create_data <= timestamp '" + fechaFinStr + "' " + ") as ctd" + 
				") " + 
				" " + 
				"UNION ALL " + 
				"    (SELECT 'Tacuarembó' as depto, " + 
				"        (select count(*) " + 
				" " + 
				"        from bus_ent_instance bei " + 
				" " + 
				"        where bei.att_value_10 = '1' " + 
				"            and bei.bus_ent_inst_id_auto in (select bei.bus_ent_inst_id_auto " + 
				" " + 
				"            from bus_ent_inst_attribute ent_att " + 
				"                join attribute att on ent_att.att_id = att.att_id_auto and ent_att.env_id = att.env_id " + 
				"                join bus_ent_instance bei on bei.env_id = ent_att.env_id and bei.bus_ent_inst_id_auto = ent_att.bus_ent_inst_id " + 
				" " + 
				"            where att.att_name = 'INDDHH_OPCIONES_ADMISIBLE_STR' " + 
				"                and bei.bus_ent_id = 1379 and bei.att_value_10 = '1' " + 
				"                and ent_att.ent_inst_att_str_value = '2' " + 
				"                and bei.env_id = 1 and ent_att.env_id = 1) " + 
				" " + 
				"            and bei.bus_ent_id = 1379 " + 
				"            and bei.att_value_6 = '18'  " + 
				"            and bei.env_id = 1 "
				+ "and bei.bus_ent_inst_create_data >= timestamp '" + fechaInicioStr + "' "
				+ "and bei.bus_ent_inst_create_data <= timestamp '" + fechaFinStr + "' " + ") as ctd" + 
				") " + 
				" " + 
				"UNION ALL " + 
				"    (SELECT 'Treinta y Tres' as depto, " + 
				"        (select count(*) " + 
				" " + 
				"        from bus_ent_instance bei " + 
				" " + 
				"        where bei.att_value_10 = '1' " + 
				"            and bei.bus_ent_inst_id_auto in (select bei.bus_ent_inst_id_auto " + 
				" " + 
				"            from bus_ent_inst_attribute ent_att " + 
				"                join attribute att on ent_att.att_id = att.att_id_auto and ent_att.env_id = att.env_id " + 
				"                join bus_ent_instance bei on bei.env_id = ent_att.env_id and bei.bus_ent_inst_id_auto = ent_att.bus_ent_inst_id " + 
				" " + 
				"            where att.att_name = 'INDDHH_OPCIONES_ADMISIBLE_STR' " + 
				"                and bei.bus_ent_id = 1379 and bei.att_value_10 = '1' " + 
				"                and ent_att.ent_inst_att_str_value = '2' " + 
				"                and bei.env_id = 1 and ent_att.env_id = 1) " + 
				" " + 
				"            and bei.bus_ent_id = 1379 " + 
				"            and bei.att_value_6 = '19'  " + 
				"            and bei.env_id = 1 "
				+ "and bei.bus_ent_inst_create_data >= timestamp '" + fechaInicioStr + "' "
				+ "and bei.bus_ent_inst_create_data <= timestamp '" + fechaFinStr + "' " + ") as ctd" + 
				") " + 
				" " + 
				"UNION ALL " + 
				"    (SELECT 'Total' as depto, " + 
				"        (select count(*) " + 
				" " + 
				"        from bus_ent_inst_attribute ent_att " + 
				"            join attribute att on ent_att.att_id = att.att_id_auto and ent_att.env_id = att.env_id " + 
				"            join bus_ent_instance bei on bei.env_id = ent_att.env_id and bei.bus_ent_inst_id_auto = ent_att.bus_ent_inst_id " + 
				" " + 
				"        where bei.att_value_10 = '1' " + 
				"            and att.att_name = 'INDDHH_OPCIONES_ADMISIBLE_STR' " + 
				"            and bei.bus_ent_id = 1379 " + 
				"            and ent_att.ent_inst_att_str_value = '2' " + 
				"            and bei.env_id = 1 and ent_att.env_id = 1 "
				+ "and bei.bus_ent_inst_create_data >= timestamp '" + fechaInicioStr + "' "
				+ "and bei.bus_ent_inst_create_data <= timestamp '" + fechaFinStr + "' " + ") as ctd" + ")";
			
			ResultSet rs = stmt.executeQuery(query);

			qry.getData().clear();
			
			while (rs.next()) {
				ArrayList row = new ArrayList();
				
				row.add(rs.getString("depto"));
				row.add(rs.getString("ctd"));
				
				qry.getData().addRow(row);
			}			

		} catch (SQLException e1) {
			e1.printStackTrace();
		}

	}

}
