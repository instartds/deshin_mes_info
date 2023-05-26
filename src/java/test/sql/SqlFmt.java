package test.sql;

import gudusoft.gsqlparser.EDbVendor;
import gudusoft.gsqlparser.TGSqlParser;
import gudusoft.gsqlparser.pp.para.GFmtOpt;
import gudusoft.gsqlparser.pp.para.GFmtOptFactory;
import gudusoft.gsqlparser.pp.para.GOutputFmt;
import gudusoft.gsqlparser.pp.para.styleenums.TAlignStyle;
import gudusoft.gsqlparser.pp.para.styleenums.TCaseOption;
import gudusoft.gsqlparser.pp.para.styleenums.TLinefeedsCommaOption;
import gudusoft.gsqlparser.pp.stmtformatter.FormatterFactory;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

public class SqlFmt {
	
	private  final Set<String> sysCols = new HashSet<String>(Arrays.asList(
			new String[] {"COMP_CODE", "UPDATE_DB_USER", "UPDATE_DB_TIME", "INSERT_DB_USER", "INSERT_DB_TIME"}
		));
	
	public boolean isSysCol(String key) {
		return sysCols.contains(key);
	}
	public String getColumnValue(String field) {
		if 	("COMP_CODE".equals(field)) {
			return "#S_COMP_CODE#";
		} else if 	("UPDATE_DB_USER".equals(field)) {
				return "#S_USER_ID#";
		} else if 	("UPDATE_DB_TIME".equals(field)) {
			return "getDate()";
		} else if 	("INSERT_DB_USER".equals(field)) {
			return "#S_USER_ID#";
		} else if 	("INSERT_DB_TIME".equals(field)) {
			return "getDate()";
		} else {
			return "#" + field +"#";
		}
		 
	}
	
	public List<Map<String, Object>> colSort(List<Map<String, Object>> cols) {
		List<Map<String, Object>> rv = new ArrayList();
		List<Map<String, Object>> rvt = new ArrayList();
		for(Map<String,Object> col : cols) {
	        String columnName = ((String)col.get("name")).toUpperCase();
	        if(isSysCol (columnName) ) {
	        	rv.add(col);
	        } else {
	        	rvt.add(col);
	        }
		}
		rv.addAll(rvt);
		return rv;
	}
	public  String sqlFormat(String sql, boolean leftComma, boolean lHtml) {
        //TGSqlParser sqlparser = new TGSqlParser(EDbVendor.dbvoracle);
        TGSqlParser sqlparser = new TGSqlParser(EDbVendor.dbvmssql);
        sqlparser.sqltext = sql;
        String result;
        int ret = sqlparser.parse();
        if (ret == 0) {
            	GFmtOpt gFmtOpt = GFmtOptFactory.newInstance();
            // umcomment next line generate formatted sql in html
            
            		gFmtOpt.outputFmt =  GOutputFmt.ofSql;
            	if(lHtml) {
            		//option.outputFmt =  GOutputFmt.ofhtml;
            		//gFmtOpt.outputFmt =  GOutputFmt.ofSql;
            	} else {

            		//gFmtOpt.outputFmt =  GOutputFmt.ofSql;
            	}
            	gFmtOpt.tabSize = 4;
            	gFmtOpt.caseFuncname = TCaseOption.CoLowercase;
            	gFmtOpt.caseIdentifier = TCaseOption.CoUppercase;
            	gFmtOpt.selectColumnlistStyle = TAlignStyle.AsStacked;
            	gFmtOpt.insertColumnlistStyle = TAlignStyle.AsStacked;
            	gFmtOpt.defaultCommaOption = TLinefeedsCommaOption.LfbeforeCommaWithSpace;
              /*
              if(leftComma) {
            	  gFmtOpt.selectColumnlistComma = TLinefeedsCommaOption.LfBeforeComma;
            	  gFmtOpt.defaultCommaOption = TLinefeedsCommaOption.LfBeforeComma;
              } else {
            	  gFmtOpt.defaultCommaOption = TLinefeedsCommaOption.LfAfterComma;
              }
              */
               result = FormatterFactory.pp(sqlparser, gFmtOpt);
        } else {
            result ="SQL Formatter >> " + sqlparser.getErrormessage() + "\n Source SQL is " + sql;
        }
        return result;
    }
}
