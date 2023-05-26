package test.oracle;

import gudusoft.gsqlparser.EDbVendor;
import gudusoft.gsqlparser.TGSqlParser;
import gudusoft.gsqlparser.pp.para.GFmtOpt;
import gudusoft.gsqlparser.pp.para.GFmtOptFactory;
import gudusoft.gsqlparser.pp.para.styleenums.TCaseOption;
import gudusoft.gsqlparser.pp.para.styleenums.TLinefeedsCommaOption;
import gudusoft.gsqlparser.pp.stmtformatter.FormatterFactory;

/**
 * @Class Name : SqlFormatter.java
 * @Description : !!! Describe Class
 * @author SangJoon Kim
 * @since 2012-12-05
 * @version 1.0
 * @see 
 *
 * @Modification Information
 * <pre>
 *    Date                Changer         Comment
 *  ===========    =========    ===========================
 *  2012-12-05 by SangJoon Kim: initial version
 * </pre>
 */

public class SqlFormatter {
    public static String sqlFormat(String sql, boolean leftComma ) {
        TGSqlParser sqlparser = new TGSqlParser(EDbVendor.dbvoracle);
        sqlparser.sqltext = sql;
        String result;
        int ret = sqlparser.parse();
        if (ret == 0) {
            GFmtOpt option = GFmtOptFactory.newInstance();
            // umcomment next line generate formatted sql in html
            //option.outputFmt =  GOutputFmt.ofhtml;
              option.tabSize = 4;
              option.caseFuncname = TCaseOption.CoUppercase;
              option.caseIdentifier = TCaseOption.CoLowercase;//  TCaseOption.CoNoChange;
              if(leftComma) {
                  option.selectColumnlistComma = TLinefeedsCommaOption.LfBeforeComma;
              } else {
                  option.selectColumnlistComma = TLinefeedsCommaOption.LfAfterComma;
              }
              
               result = FormatterFactory.pp(sqlparser, option);
        } else {
            result ="SQL Formatter >> " + sqlparser.getErrormessage() + "\n Source SQL is " + sql;
        }
        return result;
    }
}
