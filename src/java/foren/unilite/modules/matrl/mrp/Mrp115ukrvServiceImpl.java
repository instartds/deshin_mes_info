package foren.unilite.modules.matrl.mrp;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

import org.apache.commons.configuration.Configuration;
import org.apache.commons.configuration.XMLConfiguration;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ConfigUtil;
import foren.framework.utils.JndiUtils;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.com.fileman.FileMnagerService;

@Service("Mrp115ukrvService")
public class Mrp115ukrvServiceImpl extends TlabAbstractServiceImpl  {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	private final String contextName = JndiUtils.getEnv("CONTEXT_NAME", "default");
	@ExtDirectMethod( group = "matrl")
	public Map<String, Object>  selectStatus(Map param, LoginVO user) throws Exception { 
    	return (Map<String, Object>) super.commonDao.select("Mrp115ukrvService.selectStatus", param);
	}
	@ExtDirectMethod( group = "matrl")
	public Map<String, Object>  selectLog(Map param, LoginVO user) throws Exception { 
    	return (Map<String, Object>) super.commonDao.select("Mrp115ukrvService.selectLog", param);
	}
	
    @ExtDirectMethod( group = "matrl")      // mrp 전개(실행)
    public Map<String, Object>  spCall(Map param, LoginVO user) throws Exception { 
    	Map<String, Object> r = new HashMap<String, Object>();
    	Map<String, Object> statusMap = selectStatus(param, user);
    	if(statusMap != null)	{
	    	String strStatus = ObjUtils.getSafeString(statusMap.get("STATUS"));
	    	if("Start".equals(strStatus) )	{
	    		r.put("STATUS", strStatus);
	    		return r;
	    	}
    	}
    	try {
    		Configuration batchConf = getBatchConfig("mrp115ukrv", contextName);
    		
    	    if(batchConf != null)	{
    		//String path = "java -classpath "+D:\\Foren\\_DEV\\workspace\\OmegaPlus_MrpBatch\\lib\\sqljdbc4.jar;D:\\Foren\\_DEV\\workspace\\OmegaPlusMrpBatch.jar OmegaPlus.MrpBatch \"MASTER\" \"01\" \"\" \"\" \"\" \"20180101\" \"20180101\" \"20180101\" \"N\" \"Y\" \"Y\" \"Y\" \"Y\" \"Y\" \"Y\" \"unilite5\" 2> D:\\Foren\\_DEV\\workspace\\batchlog.log> D:\\Foren\\_DEV\\workspace\\batchlog.error.log";
    		String keyValue = getLogKey();
    	    String path = "java -classpath "
    	    				+ batchConf.getString("basepath") 
    	    				+ "/"+ batchConf.getString("jarName") +";"
    	    				+ batchConf.getString("classpath") +"  " 
    	    				+ batchConf.getString("applicationName") +" " 
    	    				+ "\""+contextName+"\" "
    	    				+ "\""+keyValue+"\" "												// 0 :log_key
    	    				+ "\""+user.getCompCode()+"\" "										// 1 :법인코드
    	    				+ "\""+ObjUtils.getSafeString(param.get("DIV_CODE"))+"\" "			// 2 :사업장
    	    				+ "\""+ObjUtils.getSafeString(param.get("WORK_SHOP_CODE"))+"\" "	// 3 :작업장
    	    				+ "\""+ObjUtils.getSafeString(param.get("PLAN_PRSN"))+"\" "			// 4 :MRP 담당자
    	    				+ "\""+ObjUtils.getSafeString(param.get("BASE_DATE"))+"\" "			// 5 :기준일자
    	    				+ "\""+ObjUtils.getSafeString(param.get("FIRM_DATE"))+"\" "			// 6 :확정일자
    	    				+ "\""+ObjUtils.getSafeString(param.get("PLAN_DATE"))+"\" "			// 7 :예시일자
    	    				+ "\""+ObjUtils.getSafeString(param.get("PAB_STOCK_YN"))+"\" "		// 8 :가용재고 감안여부
    	    				+ "\""+ObjUtils.getSafeString(param.get("WH_STOCK_YN"))+"\" "		// 9 :현재고 감안여부
    	    				+ "\""+ObjUtils.getSafeString(param.get("SAFETY_STOCK_YN"))+"\" "	// 10 :안전재고 감안여부
    	    				+ "\""+ObjUtils.getSafeString(param.get("INSTOCK_PLAN_YN"))+"\" "	// 11 :입고예정 감안여부
    	    				+ "\""+ObjUtils.getSafeString(param.get("OUTSTOCK_PLAN_YN"))+"\" "	// 12 :출고예정 감안여부
    	    				+ "\""+ObjUtils.getSafeString(param.get("SUB_STOCK_YN"))+"\" "		// 13 :외주재고 감안여부
    	    				+ "\""+ObjUtils.getSafeString(param.get("REL_PLAN_YN"))+"\" "		// 14 :미확정 계획오더 감안여부
    	    				+ "\""+ObjUtils.getSafeString(param.get("OPEN_DEL_YN"))+"\" "		// 15 :미전환 계획오더 삭제여부
    	    				+ "\""+user.getUserID()+"\" ";										// 16 :수정자 사용자 ID
    	    	logger.debug(path);			
	    	    Runtime rn=Runtime.getRuntime();
	    	    Process pr=rn.exec(path);
	    	    r.put("keyValue", keyValue);
    	    } else {
    	    	throw new UniDirectValidateException("Mrp 전개 작업을 실행할 수 없습니다(Configruation 정보 오류) \n 관리자에게 문의하세요");
    	    }
    	} catch(IOException ex) {
    		logger.error(ex.toString());
    		r.put("success", "fail");
    		throw new UniDirectValidateException("Mrp 전개 작업을 실행할 수 없습니다 \n 관리자에게 문의하세요");
    	}
    	return r;
    }      
    
    
}
