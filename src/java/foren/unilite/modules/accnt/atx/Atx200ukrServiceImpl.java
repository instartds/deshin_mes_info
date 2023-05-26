package foren.unilite.modules.accnt.atx;

import java.io.File;
import java.io.FileOutputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.poi.util.SystemOutLogger;
import org.slf4j.Logger;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.type.TypeFactory;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.logging.InjectLogger;
import foren.framework.model.LoginVO;
import foren.framework.utils.ConfigUtil;
import foren.framework.utils.ObjUtils;
import foren.framework.web.view.FileDownloadInfo;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;

@Service("atx200ukrService")
public class Atx200ukrServiceImpl  extends TlabAbstractServiceImpl {
    @InjectLogger
    public static   Logger  logger  ;// = LoggerFactory.getLogger(this.getClass());

	/**
	 * 전산매체작성(세금계산서합계표)	-	표지탭 폼 조회
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
    @ExtDirectMethod(value = ExtDirectMethodType.FORM_LOAD, group = "accnt")
	public Object	selectList1(Map param) throws Exception {
		return  super.commonDao.select("atx200ukrServiceImpl.selectList1", param);
	}
	
	/**
	 * 전산매체작성(세금계산서합계표)	-	매출탭 그리드 조회
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "accnt")
	public List<Map<String, Object>>  selectList2(Map param) throws Exception {		
		return  super.commonDao.list("atx200ukrServiceImpl.selectList2", param);
	}
	
	/**
	 * 전산매체작성(세금계산서합계표)	-	매출합계 폼 조회
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_LOAD, group = "accnt")
	public Object	selectList3(Map param) throws Exception {		
		return  super.commonDao.select("atx200ukrServiceImpl.selectList3", param);
	}
	
	/**
	 * 전산매체작성(세금계산서합계표)	-	매입 그리드 조회
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "accnt")
	public List<Map<String, Object>>  selectList4(Map param) throws Exception {
		return  super.commonDao.list("atx200ukrServiceImpl.selectList4", param);
	}
	
	/**
	 * 전산매체작성(세금계산서합계표)	-	매입합계 폼 조회
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_LOAD, group = "accnt")
	public Object	selectList5(Map param) throws Exception {
		return  super.commonDao.select("atx200ukrServiceImpl.selectList5", param);
	}
	
	/**
	 * 파일 생성전 validation 체크
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public Map<String, Object>  fnGetFileCheck(Map spParam, LoginVO user) throws Exception {
		Map<String, Object>  spResult = new HashMap();
		Map result = new HashMap();
		String errorDesc = "";
		spResult = (Map) super.commonDao.select("atx200ukrServiceImpl.sp_getFileText", spParam);
		errorDesc = (String) spResult.get("ERROR_DESC");
		if(!ObjUtils.isEmpty(errorDesc)){			
			String[] messsage = errorDesc.split(";");
		    throw new  UniDirectValidateException(this.getMessage(messsage[0], user));
		}
		result.put("ERROR_DESC", "success");
		
	    return result;
	}
	/**
	 * 파일 저장
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public Map<String, Object>  fnGetFileText(Map spParam, LoginVO user) throws Exception {
		
		Map result = (Map) super.commonDao.select("atx200ukrServiceImpl.sp_getFileText", spParam);
		String returnText = (String) result.get("RETURN_TEXT");	
		String fileName = (String) result.get("COMPANY_NUM");
		String errorDesc = (String) result.get("ERROR_DESC");
//		System.out.print(returnText);
		if(!ObjUtils.isEmpty(errorDesc)){
			String[] messsage = errorDesc.split(";");
		    errorDesc = this.getMessage(messsage[0], user);
		}else{
			errorDesc = "";			
		}		
		result.put("ERROR_DESC", errorDesc);
		
	    return result;
	}
	
	
}
