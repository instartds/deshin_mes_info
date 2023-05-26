package test.sql;

import foren.framework.lib.sql.BasicFormatterImpl;

public class SqlParser01 {
	public static void main(String args[]) throws Exception {
		String sql = "		/* extJsStateProviderServiceImpl.chkeckExists */ "
				+ "SELECT count(*) as cnt	FROM BSA420T WHERE COMP_CODE = #S_COMP_CODE# "
				+ "	AND USER_ID = #S_USER_ID# AND PGM_ID = #PGM_ID#";
		String formattedSQL = new BasicFormatterImpl().format(sql);
		out(formattedSQL);
	}
	
	public static void out(String msg) {
		
		
		System.out.println(msg);
	}
}
