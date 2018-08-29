<%@ page contentType="text/html; charset=iso-8859-1" language="java"%>
<%@ page import="com.st.db.dataAccess.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@page import="com.st.util.i18n.I18N"%>
<%@page import="java.util.ResourceBundle"%>

<html>
<head>
	<title>Check Field Properties</title>
	<style type="text/css">
		body {
			font-family: verdana;
			font-size: 10px;
		}
		td {
			font-family: verdana;
			font-size: 10px;
		}
		pre {
			font-family: verdana;
			font-size: 10px;
		}
		input {
			font-family: verdana;
			font-size: 10px;
		}
		select {
			font-family: verdana;
			font-size: 10px;
		}
		
		a {
			text-decoration: none;
			color: blue;
		}
	</style>
	<SCRIPT language=JavaScript>
		function confirmacion() {
			var answer;
			answer = confirm('This method will make changes to the data base. Are you sure you want to continue?');
			if(answer == true){
				document.location.href="?action=verifyAndCorrectFieldConfirm";
			}
		}
	</SCRIPT>
</head>
<body>

<%!
protected class ConnectionGetter extends ConnectionDAO {
	public Connection getDBConnection2(DBConnection dbConn) {
		return ConnectionDAO.getDBConnection(dbConn);
	}
}

protected class FldProp {
	public int fld;	public int prp;	public int req;	
	public FldProp(int f, int p, int r) {
		fld = f; prp = p; req = r;
	}	
	@Override
	public String toString() {
		return "(" + fld + "," + prp + "," + req + ")";
	}	
	@Override
	public boolean equals(Object obj) {
		if(obj instanceof FldProp){
			FldProp fp = (FldProp)obj;
			if(fp.fld == fld && fp.prp == prp && fp.req == req)
				return true;
		}
		return false;
	}
}

protected class FrmProp {
	public int fld;	public int prp;	public int req;	
	public FrmProp(int f, int p, int r) {
		fld = f; prp = p; req = r;
	}	
	@Override
	public String toString() {
		return "(" + fld + "," + prp + "," + req + ")";
	}	
	@Override
	public boolean equals(Object obj) {
		if(obj instanceof FrmProp){
			FrmProp fp = (FrmProp)obj;
			if(fp.fld == fld && fp.prp == prp && fp.req == req)
				return true;
		}
		return false;
	}
}

protected class Property {
	public int prp;	public String name;	public String scope; public String type; public int length; public String reg_exp; public String desc;
	public Property(int p, String n, String s, String t, int l, String r, String d) {
		prp = p; name = n; scope = s; type = t; length = l; reg_exp = r; desc = d; 
	}	
	@Override
	public String toString() {
		return "(" + prp + "," + name + "," + scope + "," + type + "," + length + "," + reg_exp + "," + desc + ")";
	}	
	@Override
	public boolean equals(Object obj) {
		if(obj instanceof Property){
			Property p = (Property)obj;
			if(p.prp == prp && p.length == length){
				if((p.name == null && name == null) || ((p.name != null && name != null) && p.name.equals(name))){
					if((p.scope == null && scope == null) || ((p.scope != null && scope != null) && p.scope.equals(scope))){
						if((p.type == null && type == null) || ((p.type != null && type != null) && p.type.equals(type))){
							if((p.reg_exp == null && reg_exp == null) || ((p.reg_exp != null && reg_exp != null) && p.reg_exp.equals(reg_exp))){
								if((p.desc == null && desc == null) || ((p.desc != null && desc != null) && p.desc.equals(desc))){
									return true;
								}
							}
						}
					}
				}
			}				
		}
		return false;
	}
}

protected class Test extends DBAdmin {
	
	private static final String QRY_ALL_FLD_PROP = "SELECT FLD_TYP_ID, PRP_ID, FLD_PRP_REQUIRED FROM FLD_TYP_PROPERTY ORDER BY FLD_TYP_ID, PRP_ID";
	private static final String ADD_FLD_PROP = "INSERT INTO FLD_TYP_PROPERTY(FLD_TYP_ID, PRP_ID, FLD_PRP_REQUIRED) VALUES(?, ?, ?)";
	
	private static final String QRY_PROP = "SELECT PRP_ID_AUTO, PRP_NAME, PRP_SCOPE, PRP_TYPE, PRP_LENGTH, PRP_REG_EXP, PRP_DESC FROM PROPERTY WHERE PRP_ID_AUTO = ? ORDER BY PRP_ID_AUTO";
	
	private static final String QRY_ALL_PROP = "SELECT PRP_ID_AUTO, PRP_NAME, PRP_SCOPE, PRP_TYPE, PRP_LENGTH, PRP_REG_EXP, PRP_DESC FROM PROPERTY ORDER BY PRP_ID_AUTO";
	private static final String ADD_PROP = "INSERT INTO PROPERTY(PRP_ID_AUTO, PRP_NAME, PRP_SCOPE, PRP_TYPE, PRP_LENGTH, PRP_REG_EXP, PRP_DESC) VALUES(?,?,?,?,?,?,?)";

	private List<FldProp> listFldPropOK = null;
	private List<FrmProp> listFrmPropOK = null;
	private List<Property> listPropOK = null;
	private DBConnection dbConn;
	
	public void loadProperties() {
		listPropOK = new ArrayList<Property>();
		listPropOK.add(new Property(1, "prpSize", "I", "N", 3, null, "Size of an input"));
		listPropOK.add(new Property(2, "prpReadOnly", "I", "S", 5, null, null));
		listPropOK.add(new Property(3, "prpFrmInvisible", "F", "S", 1, null, null));
		listPropOK.add(new Property(4, "prpDisabled", "I", "S", 5, null, null));
		listPropOK.add(new Property(5, "prpFontColor", "I", "S", 10, null, null));
		listPropOK.add(new Property(6, "prpValue", "I", "S", 255, null, null));
		listPropOK.add(new Property(7, "prpRequired", "I", "S", 10, null, null));
		listPropOK.add(new Property(8, "prpColSpan", "I", "N", 2, null, null));
		listPropOK.add(new Property(9, "prpRowSpan", "I", "N", 2, null, null));
		listPropOK.add(new Property(10, "prpModal", "I", "S", 50, null, null));
		listPropOK.add(new Property(11, "prpEntity", "I", "S", 50, null, null));
		listPropOK.add(new Property(12, "prpRows", "I", "N", 2, null, null));
		listPropOK.add(new Property(13, "prpBold", "I", "S", 1, null, null));
		listPropOK.add(new Property(14, "prpUnderlined", "I", "S", 1, null, null));
		listPropOK.add(new Property(15, "prpAlignCenter", "I", "S", 1, null, null));
		listPropOK.add(new Property(16, "prpDefault","I","S",255,null,null));
		listPropOK.add(new Property(17, "prpChecked","I","S",1,null,null));
		listPropOK.add(new Property(18, "prpSorted", "I", "S", 1, null, null));
		listPropOK.add(new Property(19, "prpName", "I", "S", 50, null, null));
		listPropOK.add(new Property(20, "prpPopValue", "I", "S", 50, null, null));
		listPropOK.add(new Property(21, "prpPopText", "I", "S", 50, null, null));
		listPropOK.add(new Property(22, "prpImg", "I", "S", 50, null, null));
		listPropOK.add(new Property(23, "prpGridType", "I", "S", 1, null, null));
		listPropOK.add(new Property(24, "prpColWidth", "I", "S", 4, null, null));
		listPropOK.add(new Property(25, "prpQry", "I", "S", 50, null, null));
		listPropOK.add(new Property(26, "prpEntityBind", "I", "S", 1, null, null));
		listPropOK.add(new Property(27, "prpGridHeight", "I", "N", 4, null, null));
		listPropOK.add(new Property(28, "prpFormHidden","F","S",1,null,null));
		listPropOK.add(new Property(29, "prpFormClosed","F","S",1,null,null));
		listPropOK.add(new Property(30, "prpHideGridButtons","I","S",1,null,null));
		listPropOK.add(new Property(31, "prpVisibilityHidden","I","S",1,null,null));
		listPropOK.add(new Property(32, "prpHideChecks","I","S",1,null,null));
		listPropOK.add(new Property(33, "prpTransient","I","S",1,null,"Determina si el atributo se almacena o no en la base"));
		listPropOK.add(new Property(34, "prpGridTitle", "I", "S", 250, null, "Title of a grid"));
		listPropOK.add(new Property(35, "prpToolTip", "I", "S", 50, null, "ToolTip of an input"));
		listPropOK.add(new Property(36, "prpTab", "F", "S", 1, null, "Is the form a tab delimiter"));
		listPropOK.add(new Property(37, "prpValColor", "I", "S", 8, null, "Value Color"));
		listPropOK.add(new Property(38, "prpEditForm", "I", "S", 50, null, "Formulario que edita la grilla"));
		listPropOK.add(new Property(39, "prpInputAsText", "I", "S", 50, null, "checkbox que indica si el input se ve como un texto en el TD"));
		listPropOK.add(new Property(40, "prpNoPrint", "I", "S", 50, null, ""));
		listPropOK.add(new Property(41, "prpGridAllLinePrint", "I", "S", 50, null, ""));
		listPropOK.add(new Property(42, "prpNoDownload", "I", "S", 1, null, ""));
		listPropOK.add(new Property(43, "prpNoErase", "I", "S", 1, null, ""));
		listPropOK.add(new Property(44, "prpNoLock", "I", "S", 1, null, "Determina si el campo file se podrá bloquear."));
		listPropOK.add(new Property(45, "prpNoHistory", "I", "S", 1, null, "Determina si se podrán ver el historico de el campo file"));
		listPropOK.add(new Property(46, "prpUrl", "I", "S", 255, null, ""));
		listPropOK.add(new Property(47, "prpNoNullValue", "I", "S", 5, null, null));
		listPropOK.add(new Property(48, "prpGrid","C","S",2,null,"Determina si el chart se despliega con grid"));
		listPropOK.add(new Property(49, "prpLegend","C","S",2,null,"Determina si el chart se despliega con leyendas"));
		listPropOK.add(new Property(50, "prpItemValue", "C", "S", 1, null, "Determina si el chart se despliega con item values"));
		listPropOK.add(new Property(51, "prpHideGridOrder", "I", "S", 50, null, ""));
		listPropOK.add(new Property(52, "prpHideGridInsert", "I", "S", 50, null, ""));
		listPropOK.add(new Property(53, "prpFormula", "I", "S", 250, null, ""));
		listPropOK.add(new Property(54, "prpRegExpMessage", "I", "S", 255, null, ""));
		listPropOK.add(new Property(55, "prpPagedGrid","I","S",1,null,null));
		listPropOK.add(new Property(56, "prpPagedGridSize","I","N",3,null,null));
		listPropOK.add(new Property(57, "prpGridAlterLastPage","I","S",1,null,null));
		listPropOK.add(new Property(58, "prpGridNotVerifyReqServer","I","S",1,null,"Flag para determinar si se validan los requeridos en el server"));
		listPropOK.add(new Property(59, "prpNoModify", "I", "S", 1, null, "Determina si el campo file se podrá modificar"));
		listPropOK.add(new Property(60, "prpHideSignIcons", "I", "S", 1, null, "Determina si en el campo file se ven iconos de firma o no"));
		listPropOK.add(new Property(61, "prpMaxRegGrid", "I", "N", 4, null,"Max amount of records a grid can contain"));
		listPropOK.add(new Property(62, "prpPerExtensions", "I", "S", 255, null,"Permited extensions for a file input"));
		listPropOK.add(new Property(63, "prpForbExtensions", "I", "S", 255, null,"Forbidden extensions for a file input"));
		listPropOK.add(new Property(64, "prpDontBreakRadio", "I", "S", 255, null,"Dont break line in radiobuttons"));
		listPropOK.add(new Property(65, "prpGridLabel", "I", "S", 255, null,"Grid column label"));
		listPropOK.add(new Property(66, "prpHideDocPermissions", "I", "S", 255, null,"Grid column label"));
		listPropOK.add(new Property(68, "prpHideGridAdd", "I", "S", 50, null, ""));
		listPropOK.add(new Property(69, "prpHideGridDel", "I", "S", 50, null, ""));
		listPropOK.add(new Property(70, "prpHighlight", "F", "S", 1, null, "Highlight the tab"));

	}
	
	public void loadFldProps() {
		listFldPropOK = new ArrayList<FldProp>();
		listFldPropOK.add(new FldProp(6,16,0));
		listFldPropOK.add(new FldProp(9,66,0));
		listFldPropOK.add(new FldProp(15,19,0));
		listFldPropOK.add(new FldProp(5,65,0));
		listFldPropOK.add(new FldProp(4,64,0));
		listFldPropOK.add(new FldProp(9,7,0));
		listFldPropOK.add(new FldProp(9,42,0));
		listFldPropOK.add(new FldProp(9,43,0));
		listFldPropOK.add(new FldProp(9,62,0));
		listFldPropOK.add(new FldProp(9,63,0));
		listFldPropOK.add(new FldProp(14,61,0));
		listFldPropOK.add(new FldProp(9,59,0));
		listFldPropOK.add(new FldProp(9,60,0));
		listFldPropOK.add(new FldProp(14,58,0));
		listFldPropOK.add(new FldProp(14,55,0));
		listFldPropOK.add(new FldProp(14,56,0));
		listFldPropOK.add(new FldProp(14,57,0));
		listFldPropOK.add(new FldProp(1,54,0));
		listFldPropOK.add(new FldProp(1,53,0));
		listFldPropOK.add(new FldProp(2,47,0));
		listFldPropOK.add(new FldProp(1,40,0));
		listFldPropOK.add(new FldProp(2,40,0));
		listFldPropOK.add(new FldProp(3,40,0));
		listFldPropOK.add(new FldProp(4,40,0));
		listFldPropOK.add(new FldProp(5,40,0));
		listFldPropOK.add(new FldProp(6,40,0));
		listFldPropOK.add(new FldProp(7,40,0));
		listFldPropOK.add(new FldProp(8,40,0));
		listFldPropOK.add(new FldProp(9,40,0));
		listFldPropOK.add(new FldProp(10,40,0));
		listFldPropOK.add(new FldProp(11,40,0));
		listFldPropOK.add(new FldProp(12,40,0));
		listFldPropOK.add(new FldProp(13,40,0));
		listFldPropOK.add(new FldProp(10,47,0));
		listFldPropOK.add(new FldProp(1,39,0));
		listFldPropOK.add(new FldProp(14,38,0));
		listFldPropOK.add(new FldProp(2,20,0));
		listFldPropOK.add(new FldProp(2,21,0));
		listFldPropOK.add(new FldProp(1, 1, 0));
		listFldPropOK.add(new FldProp(1, 2, 0));
		listFldPropOK.add(new FldProp(1, 4, 0));
		listFldPropOK.add(new FldProp(1, 7, 0));
		listFldPropOK.add(new FldProp(1, 10, 0));
		listFldPropOK.add(new FldProp(1, 16, 0));
		listFldPropOK.add(new FldProp(1, 19, 0));
		listFldPropOK.add(new FldProp(1, 24, 0));
		listFldPropOK.add(new FldProp(2, 1, 0));
		listFldPropOK.add(new FldProp(2, 2, 0));
		listFldPropOK.add(new FldProp(2, 4, 0));
		listFldPropOK.add(new FldProp(2, 7, 0));
		listFldPropOK.add(new FldProp(2, 11, 0));
		listFldPropOK.add(new FldProp(2, 18, 0));
		listFldPropOK.add(new FldProp(2, 19, 0));
		listFldPropOK.add(new FldProp(2, 24, 0));
		listFldPropOK.add(new FldProp(3, 2, 0));
		listFldPropOK.add(new FldProp(3, 4, 0));
		listFldPropOK.add(new FldProp(3, 7, 0));
		listFldPropOK.add(new FldProp(3, 17, 0));
		listFldPropOK.add(new FldProp(3, 19, 0));
		listFldPropOK.add(new FldProp(4, 2, 0));
		listFldPropOK.add(new FldProp(4, 4, 0));
		listFldPropOK.add(new FldProp(4, 7, 0));
		listFldPropOK.add(new FldProp(4, 11, 0));
		listFldPropOK.add(new FldProp(4, 19, 0));
		listFldPropOK.add(new FldProp(5, 6, 0));
		listFldPropOK.add(new FldProp(5, 19, 0));
		listFldPropOK.add(new FldProp(6, 1, 0));
		listFldPropOK.add(new FldProp(6, 2, 0));
		listFldPropOK.add(new FldProp(6, 4, 0));
		listFldPropOK.add(new FldProp(6, 7, 0));
		listFldPropOK.add(new FldProp(6, 12, 0));
		listFldPropOK.add(new FldProp(6, 19, 0));
		listFldPropOK.add(new FldProp(7, 6, 0));
		listFldPropOK.add(new FldProp(7, 13, 0));
		listFldPropOK.add(new FldProp(7, 14, 0));
		listFldPropOK.add(new FldProp(7, 15, 0));
		listFldPropOK.add(new FldProp(7, 19, 0));
		listFldPropOK.add(new FldProp(8, 6, 0));
		listFldPropOK.add(new FldProp(8, 19, 0));
		listFldPropOK.add(new FldProp(9, 19, 0));
		listFldPropOK.add(new FldProp(10, 1, 0));
		listFldPropOK.add(new FldProp(10, 2, 0));
		listFldPropOK.add(new FldProp(10, 4, 0));
		listFldPropOK.add(new FldProp(10, 7, 0));
		listFldPropOK.add(new FldProp(10, 11, 0));
		listFldPropOK.add(new FldProp(10, 12, 0));
		listFldPropOK.add(new FldProp(10, 18, 0));
		listFldPropOK.add(new FldProp(10, 19, 0));
		listFldPropOK.add(new FldProp(11, 19, 0));
		listFldPropOK.add(new FldProp(11, 16, 0));
		listFldPropOK.add(new FldProp(12, 1, 0));
		listFldPropOK.add(new FldProp(12, 2, 0));
		listFldPropOK.add(new FldProp(12, 4, 0));
		listFldPropOK.add(new FldProp(12, 7, 0));
		listFldPropOK.add(new FldProp(12, 19, 0));
		listFldPropOK.add(new FldProp(13, 19, 0));
		listFldPropOK.add(new FldProp(13, 22, 0));
		listFldPropOK.add(new FldProp(14, 2, 0));
		listFldPropOK.add(new FldProp(14, 19, 0));
		listFldPropOK.add(new FldProp(14, 25, 0));
		listFldPropOK.add(new FldProp(14, 27, 0));
		listFldPropOK.add(new FldProp(14, 30, 0));
		listFldPropOK.add(new FldProp(1, 31, 0));
		listFldPropOK.add(new FldProp(2, 31, 0));
		listFldPropOK.add(new FldProp(3, 31, 0));
		listFldPropOK.add(new FldProp(4, 31, 0));
		listFldPropOK.add(new FldProp(5, 31, 0));
		listFldPropOK.add(new FldProp(6, 31, 0));
		listFldPropOK.add(new FldProp(14, 31, 0));
		listFldPropOK.add(new FldProp(14, 32, 0));
		listFldPropOK.add(new FldProp(1, 33, 0));
		listFldPropOK.add(new FldProp(2, 33, 0));
		listFldPropOK.add(new FldProp(3, 33, 0));
		listFldPropOK.add(new FldProp(4, 33, 0));
		listFldPropOK.add(new FldProp(6, 33, 0));
		listFldPropOK.add(new FldProp(10, 33, 0));
		listFldPropOK.add(new FldProp(11, 33, 0));
		listFldPropOK.add(new FldProp(12, 33, 0));
		listFldPropOK.add(new FldProp(3, 24, 0));
		listFldPropOK.add(new FldProp(14,34,0));
		listFldPropOK.add(new FldProp(15,6,0));
		listFldPropOK.add(new FldProp(15,46,0));
		listFldPropOK.add(new FldProp(1,5,0));
		listFldPropOK.add(new FldProp(1,35,0));
		listFldPropOK.add(new FldProp(1,37,0));
		listFldPropOK.add(new FldProp(2,5,0));
		listFldPropOK.add(new FldProp(2,35,0));
		listFldPropOK.add(new FldProp(2,37,0));
		listFldPropOK.add(new FldProp(3,5,0));
		listFldPropOK.add(new FldProp(3,35,0));
		listFldPropOK.add(new FldProp(4,5,0));
		listFldPropOK.add(new FldProp(4,35,0));
		listFldPropOK.add(new FldProp(4,37,0));
		listFldPropOK.add(new FldProp(5,5,0));
		listFldPropOK.add(new FldProp(5,35,0));
		listFldPropOK.add(new FldProp(6,5,0));
		listFldPropOK.add(new FldProp(6,35,0));
		listFldPropOK.add(new FldProp(6,37,0));
		listFldPropOK.add(new FldProp(7,5,0));
		listFldPropOK.add(new FldProp(7,35,0));
		listFldPropOK.add(new FldProp(8,5,0));
		listFldPropOK.add(new FldProp(8,35,0));
		listFldPropOK.add(new FldProp(10,5,0));
		listFldPropOK.add(new FldProp(10,35,0));
		listFldPropOK.add(new FldProp(10,37,0));
		listFldPropOK.add(new FldProp(12,5,0));
		listFldPropOK.add(new FldProp(12,35,0));
		listFldPropOK.add(new FldProp(12,37,0));
		listFldPropOK.add(new FldProp(4,18,0));
		listFldPropOK.add(new FldProp(14,51,0));
		listFldPropOK.add(new FldProp(14,52,0));
		listFldPropOK.add(new FldProp(9,2,0));
		listFldPropOK.add(new FldProp(9,4,0));
		listFldPropOK.add(new FldProp(6,39,0));
		listFldPropOK.add(new FldProp(9,31,0));
		listFldPropOK.add(new FldProp(14,68,0));
		listFldPropOK.add(new FldProp(14,69,0));
		listFldPropOK.add(new FldProp(16,7,0));
		listFldPropOK.add(new FldProp(16,31,0));
		listFldPropOK.add(new FldProp(5,2,0));
		listFldPropOK.add(new FldProp(5,4,0));
	}

	public void loadFldPropsFormProperties() throws Exception{		
		ResourceBundle resourceBundle = ResourceBundle.getBundle("properties.checkFieldProperties");
		listFldPropOK = new ArrayList<FldProp>();
		int cant = Integer.parseInt(resourceBundle.getString("cant"));
		for(int i = 1; i <= cant; i++) {
			String read = resourceBundle.getString(""+i);
			String[] vals = read.split(",");
			if(vals.length != 3)			
				throw new Exception("Incorrect format of .properties file.");
			try {
				listFldPropOK.add(new FldProp(Integer.parseInt(vals[0]), Integer.parseInt(vals[1]), Integer.parseInt(vals[2])));
			} catch (Exception e) {
				throw new Exception("Incorrect value (" + vals[0] + "," + vals[1] + "," + vals[2] + ") in .properties file for property " + i);
			}
		}		
	}

	private Connection getConnection() throws Exception {
		DBManager manager = (DBManager) managersMap.get("DOGMA_MANAGER");		
		dbConn = manager.getConnection(null,null,null,0,0,0,0);
		ConnectionGetter conGetter = new ConnectionGetter();
		return conGetter.getDBConnection2(dbConn);
	}
	
	private void closeConnection() throws com.dogma.DogmaException{		
		if(dbConn != null)			
			dbConn.close();					
	}
		
	private void addMessage(StringBuffer buffer, String msg) {
		buffer.append(System.currentTimeMillis() + ": " + msg + "<br>");
	}
	
	private void addError(StringBuffer buffer, String msg) {
		this.addMessage(buffer,"<font color='red'>[ERROR]</font> " + msg);
	}
	
	private void addWarning(StringBuffer buffer, String msg) {
		this.addMessage(buffer,"<font color='orange'>[WARNING]</font> " + msg);
	}

	private void addFldPropToDb(FldProp fp, StringBuffer b, Connection conn) {
		this.addMessage(b, "adding " + fp.toString());
		PreparedStatement statement = null;
		try {
			statement = conn.prepareStatement(ADD_FLD_PROP);
			statement.setInt(1, fp.fld);
			statement.setInt(2, fp.prp);
			statement.setInt(3, fp.req);
			statement.executeUpdate();		
			conn.commit();
		} catch(Throwable e) {
			this.addError(b,e.getMessage());
		} finally {
			try {
				statement.close();
			} catch (SQLException sqle){
				sqle.printStackTrace();		
			}
		}
	} 
	
	private Property existsProperty(Property p, StringBuffer b, Connection conn) {
		PreparedStatement statement = null;
		try {
			statement = conn.prepareStatement(QRY_PROP);
			statement.setInt(1, p.prp);			
			ResultSet resultSet = statement.executeQuery();		
			if(resultSet.next()) {
				return new Property(resultSet.getInt(1), resultSet.getString(2), resultSet.getString(3), resultSet.getString(4), resultSet.getInt(5), resultSet.getString(6), resultSet.getString(7));
			} else {
				return null;
			}
		} catch (SQLException sqle){
			sqle.printStackTrace();					
		}catch(Throwable e) {
			this.addError(b,e.getMessage());
		} finally {
			try {
				statement.close();
			} catch (SQLException sqle){
				sqle.printStackTrace();		
			}
		}
		return null;
	}
	
	private void addPropToDb(Property p, StringBuffer b, Connection conn) {
		Property p2 = existsProperty(p, b, conn);
		if(p2 != null) {
			this.addError(b, p.toString() + " already in database as " + p2.toString());
			return;
		}
		this.addMessage(b, "adding " + p.toString());
		PreparedStatement statement = null;
		try {
			statement = conn.prepareStatement(ADD_PROP);
			statement.setInt(1, p.prp);
			statement.setString(2, p.name);
			statement.setString(3, p.scope);
			statement.setString(4, p.type);
			statement.setInt(5, p.length);
			statement.setString(6, p.reg_exp);
			statement.setString(7, p.desc);
			statement.executeUpdate();		
			conn.commit();			
		} catch (SQLException sqle){
			sqle.printStackTrace();					
		}catch(Throwable e) {
			this.addError(b,e.getMessage());
		} finally {
			try {
				statement.close();
			} catch (SQLException sqle){
				sqle.printStackTrace();		
			}
		}
	} 
	
	public StringBuffer verifyProperties(boolean fix_it, boolean showAll) {
		StringBuffer buffer = new StringBuffer();
		Connection conn = null;
		PreparedStatement statement = null;
		int totalErrors = 0;
		int totalOk = 0;
		try {
			this.addMessage(buffer,"Getting Apia connection...");
			conn = this.getConnection();			
			ResultSet resultSet = null;
			statement = conn.prepareStatement(QRY_ALL_PROP);			
			resultSet = statement.executeQuery();
			List<Property> listP = new ArrayList<Property>();			
			while(resultSet.next()) {
				Property p = new Property(resultSet.getInt(1), resultSet.getString(2), resultSet.getString(3), resultSet.getString(4), resultSet.getInt(5), resultSet.getString(6), resultSet.getString(7)); 
				if(!listPropOK.contains(p)) {
					this.addWarning(buffer, " Property " + p.toString() + " is in db but not in the list of needed properties.");
					totalErrors++;
				} else {
					if(showAll)
						this.addMessage(buffer, p.toString() + " OK." );
					listPropOK.remove(p);
					totalOk++;
				}
			}
			if(listPropOK.size() > 0){
				this.addError(buffer, "Missing properties on db FldTypProperties.");
				for(ListIterator<Property> li = listPropOK.listIterator(); li.hasNext(); ){						
					this.addError(buffer, li.next().toString() + " is missing.");
					totalErrors++;
				}
				if(fix_it) {
					for(ListIterator<Property> li = listPropOK.listIterator(); li.hasNext(); )						
						addPropToDb(li.next(), buffer, conn);
				}
			}
			this.addMessage(buffer,"Total properties error: <b>" + totalErrors + "</b>");
			this.addMessage(buffer,"Total properties OK: <b>" + totalOk + "</b>");
		} catch(Throwable e) {
			this.addError(buffer,e.getMessage());
		} finally {
			try {
				if (conn != null && !conn.isClosed()) {
					this.addMessage(buffer,"Closing connection...");
					conn.close();
					this.closeConnection();
				}
			} catch (SQLException sqle){
				sqle.printStackTrace();					
			} catch (com.dogma.DogmaException e){
				e.printStackTrace();					
			}
		}
		this.addMessage(buffer,"[END]");
		return buffer;
	}
	
	public String verifyFields(boolean fix_it, boolean showAll) {
		
		StringBuffer buffer = verifyProperties(fix_it, showAll);		
		
		Connection conn = null;
		PreparedStatement statement = null;
		int totalErrors = 0;
		int totalOk = 0;
		try {
			this.addMessage(buffer,"Getting Apia connection...");
			conn = this.getConnection();
			ResultSet resultSet = null;
			statement = conn.prepareStatement(QRY_ALL_FLD_PROP);			
			resultSet = statement.executeQuery();
			List<FldProp> listFP = new ArrayList<FldProp>();			
			while(resultSet.next()) {
				FldProp fp = new FldProp(resultSet.getInt(1), resultSet.getInt(2), resultSet.getInt(3)); 
				if(!listFldPropOK.contains(fp)) {
					this.addError(buffer, " Property " + fp.toString() + " is in db but not in the list of needed properties.");
					totalErrors++;					
				} else {
					if(showAll)
						this.addMessage(buffer, fp.toString() + " OK." );
					listFldPropOK.remove(fp);
					totalOk++;
				}
			}
			if(listFldPropOK.size() > 0){
				this.addError(buffer, "Missing properties on db FldTypProperties.");
				for(ListIterator<FldProp> li = listFldPropOK.listIterator(); li.hasNext(); ) {
					this.addError(buffer, li.next().toString() + " is missing.");
					totalErrors++;
				}
				if(fix_it) {
					for(ListIterator<FldProp> li = listFldPropOK.listIterator(); li.hasNext(); )						
						addFldPropToDb(li.next(), buffer, conn);
				}
			}
			this.addMessage(buffer,"Total fieldProperty error: <b>" + totalErrors + "</b>");
			this.addMessage(buffer,"Total fieldProperty OK: <b>" + totalOk + "</b>");
		} catch(Throwable e) {
			this.addError(buffer,e.getMessage());
		} finally {
			try {
				if (conn != null && !conn.isClosed()) {
					this.addMessage(buffer,"Closing connection...");
					conn.close();
					this.closeConnection();
				}
			} catch (SQLException sqle){
				sqle.printStackTrace();					
			} catch (com.dogma.DogmaException e){
				e.printStackTrace();					
			}
		}
		this.addMessage(buffer,"[END]");
		return buffer.toString();
	}
}
%>
<%
String action = request.getParameter("action");

boolean isVerifiyField	= "verifyField".equals(action);
boolean isVerifiyFieldOnlyErrors	= "verifyFieldOnlyErrors".equals(action);
boolean isVerifiyAndCorrectField	= "verifyAndCorrectField".equals(action);
boolean isVerifiyAndCorrectFieldConfirm	= "verifyAndCorrectFieldConfirm".equals(action);
%>

Options: 
	<%= isVerifiyField?"<b>":"" %> <a href="?action=verifyField" title="Verify">[ Verify Fields ]</a><%= isVerifiyField?"</b>":"" %>
	<%= isVerifiyFieldOnlyErrors?"<b>":"" %> <a href="?action=verifyFieldOnlyErrors" title="Verify only errors">[ Verify Fields only Errors]</a><%= isVerifiyFieldOnlyErrors?"</b>":"" %>
	<%= isVerifiyAndCorrectField?"<b>":"" %> <a href="?action=verifyAndCorrectField" title="Verify and Correct">[ Verify and Correct Fields ]</a><%= isVerifiyAndCorrectField?"</b>":"" %>
	<a href="?" title="Init the screen">[ Init ]</a>
	<br>
<hr>
<div style="overflow: auto; white-space: nowrap; width: 100%; height: 95%"><%
if (action != null) {
	String actionResult = null;
	Test test = new Test();
	try {
		test.loadFldProps();
		test.loadProperties();
		if (isVerifiyField)
			actionResult = test.verifyFields(false, true);
		if (isVerifiyFieldOnlyErrors)
			actionResult = test.verifyFields(false, false);
		if (isVerifiyAndCorrectField){
			%><SCRIPT language=JavaScript>confirmacion();</SCRIPT><%			
		} 
		if(isVerifiyAndCorrectFieldConfirm)
			actionResult = test.verifyFields(true, false);
		if (actionResult != null) out.print(actionResult);
	} catch(Exception e) {
		out.print(e.getMessage());
	}
} %></div>
</body>
</html>