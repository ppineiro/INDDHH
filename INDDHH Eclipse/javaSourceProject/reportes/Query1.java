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

public class Query1 extends QueryAbstractClass {

	@Override
	protected void executeQuery(Query qry) throws BusClassException {

		Filter filtroFechaInicio = qry.getFilter("filtroFechaInicio");
		Filter filtroFechaFin = qry.getFilter("filtroFechaFin");

		Date fechaInicio = (Date) filtroFechaInicio.getValue();
		Date fechaFin = (Date) filtroFechaFin.getValue();

		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		String fechaInicioStr = sdf.format(fechaInicio);
		String fechaFinStr = sdf.format(fechaFin);

		try {
			Connection conn = this.getCurrentConnection();
			Statement stmt = conn.createStatement();

			String query = "(SELECT 'No admisible' as tipo_int, count(*) as ctd from bus_ent_instance bei"
					+ " where bei.env_id = 1 " + "and bei.bus_ent_id = 1379 " + "and bei.att_value_10 = '2' "
					+ "and bei.bus_ent_inst_create_data >= timestamp '" + fechaInicioStr + "' "
					+ "and bei.bus_ent_inst_create_data <= timestamp '" + fechaFinStr + "' " + ")";
			ResultSet rs = stmt.executeQuery(query);

			qry.getData().clear();
			ArrayList row = new ArrayList();

			while (rs.next()) {
				row.add(rs.getString("tipo_int"));
				row.add(rs.getString("ctd"));
			}

			qry.getData().addRow(row);

		} catch (SQLException e1) {
			e1.printStackTrace();
		}

	}

}
