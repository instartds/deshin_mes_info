package foren.unilite.modules.stock.biv;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.configuration.Configuration;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.sec.license.LicenseManager;
import foren.framework.utils.JndiUtils;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.utils.UniliteUtil;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.com.fileman.FileMnagerService;

@Service("biv114ukrvService")
public class Biv114ukrvServiceImpl extends TlabAbstractServiceImpl  {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	private final String contextName = JndiUtils.getEnv("CONTEXT_NAME", "default");
	
	@Resource(name = "fileMnagerService")
	private FileMnagerService fileMnagerService;

	@ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_READ)
	public Object  YyyymmSet(Map param) throws Exception {	
		return  super.commonDao.select("biv114ukrvService.YyyymmSet", param);	// 자동 날짜 지정
	}
	
	@ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_READ)
	public Object  WhCodeSet(Map param) throws Exception {	
		return  super.commonDao.select("biv114ukrvService.WhCodeSet", param);	// 실행할때 창고 검사
	}
	
	@ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_READ)
	public Object  WhCodeCount(Map param) throws Exception {	
		return  super.commonDao.select("biv114ukrvService.WhCodeCount", param);	// 실행할때 창고 recordCount검사
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY,  group = "stock")		// 실행
	public Object insertMaster(Map param, LoginVO user) throws Exception {
		//super.commonDao.select("biv114ukrvService.WhCodeSet", param);	// 실행할때 창고 검사
		Object r = super.commonDao.queryForObject("biv114ukrvService.insertDetail", param);
		Map<String, Object>	rMap = (Map<String, Object>) r;
		if(!"".equals(rMap.get("ERROR_CODE")))	{
			String[] sErr = rMap.get("ERROR_CODE").toString().split(";");
			throw new UniDirectValidateException(this.getMessage(sErr[0], user));
		}
		return r;
	}
	@ExtDirectMethod( group = "stock")
	public Map<String, Object>  selectStatus(Map param, LoginVO user) throws Exception { 
    	return (Map<String, Object>) super.commonDao.select("biv114ukrvService.selectStatus", param);
	}
	
	@ExtDirectMethod( group = "stock")
	public Map<String, Object>  selectLog(Map param, LoginVO user) throws Exception { 
    	return (Map<String, Object>) super.commonDao.select("biv114ukrvService.selectLog", param);
	}
	@ExtDirectMethod( group = "stock")      // mrp 전개(실행)
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
    		Configuration batchConf = getBatchConfig("biv114ukrv", contextName);
    		String keyValue = this.getLogKey();
    	    if(batchConf != null)	{
    		
    	    String path = "java -classpath "
    	    				+ batchConf.getString("basepath") 
    	    				+ "/"+ batchConf.getString("jarName") +";"
    	    				+ batchConf.getString("classpath") +"  " 
    	    				+ batchConf.getString("applicationName") +" " 
    	    				+ "\""+contextName+"\" "										// 0 :contextName
    	    				+ "\""+keyValue+"\" "											// 1 : keyValue
    	    				+ "\""+user.getCompCode()+"\" "									// 2 :법인코드
    	    				+ "\""+ObjUtils.getSafeString(param.get("DIV_CODE"))+"\" "		// 3 :사업장
    	    				+ "\""+ObjUtils.getSafeString(param.get("LAST_YYYYMM"))+"\" "	// 4 :최종마감월
    	    				+ "\""+ObjUtils.getSafeString(param.get("CLOSE_YYYYMM"))+"\" "	// 5 :마감월
    	    				+ "\""+ObjUtils.getSafeString(param.get("BASIS_YYYYMM"))+"\" "	// 6 :기초월
    	    				+ "\""+ObjUtils.getSafeString(param.get("PROCESS_TYPE"))+"\" "	// 7 :처리형태   1: 마감, 2: 취소
    	    				+ "\""+user.getUserID()+"\" ";									// 8 :수정자 사용자 ID
    	    	logger.debug(path);			
	    	    Runtime rn=Runtime.getRuntime();
	    	    Process pr=rn.exec(path);
	    	    r.put("CLOSE_YYYYMM", param.get("CLOSE_YYYYMM"));
    	    } else {
    	    	throw new UniDirectValidateException("월마감 작업을 실행할 수 없습니다(Configruation 정보 오류) \n 관리자에게 문의하세요");
    	    }
    	} catch(IOException ex) {
    		logger.error(ex.toString());
    		r.put("success", "fail");
    		throw new UniDirectValidateException("월마감 작업을 실행할 수 없습니다 \n 관리자에게 문의하세요");
    	}
    	return r;
    }  
}
