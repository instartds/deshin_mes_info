package foren.unilite.modules.z_kocis;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.BindingResult;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;


@Service("s_hpa340ukrService_KOCIS")
@SuppressWarnings("rawtypes")
public class S_Hpa340ukrServiceImpl_KOCIS extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	/* 급여계산 SP 호출  
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hpa")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public Object spCalcPay(Map param, LoginVO user) throws Exception {
		//super.commonDao.queryForObject("s_hpa340ukrServiceImpl_KOCIS.spCalcPay", param);
		String sRtn = null;
	    String RECORD_CNT = (String)super.commonDao.queryForObject("s_hpa340ukrServiceImpl_KOCIS.getRecordCnt", param);
	    logger.info("RECORD_CNT :; " + RECORD_CNT);
	    
	    if(RECORD_CNT.equals("0")) {
	        int deleteCnt01 = super.commonDao.delete("s_hpa340ukrServiceImpl_KOCIS.deleteHPA300T", param);
	        logger.info("deleteCnt01 :; " + deleteCnt01);
	        
	        int insertCnt01 = super.commonDao.insert("s_hpa340ukrServiceImpl_KOCIS.insertHPA300T", param);
            logger.info("insertCnt01 :; " + insertCnt01);
	        
            int deleteCnt02 = super.commonDao.delete("s_hpa340ukrServiceImpl_KOCIS.deleteHPA400T", param);
            logger.info("deleteCnt02 :; " + deleteCnt02);
	        
            int insertCnt02 = super.commonDao.insert("s_hpa340ukrServiceImpl_KOCIS.insertHPA400T", param);
            logger.info("insertCnt02 :; " + insertCnt02); 
	        
            int deleteCnt03 = super.commonDao.delete("s_hpa340ukrServiceImpl_KOCIS.deleteHPA600T", param);
            logger.info("deleteCnt03 :; " + deleteCnt03);
            
            int insertCnt03 = super.commonDao.insert("s_hpa340ukrServiceImpl_KOCIS.insertHPA600T", param);
            logger.info("insertCnt03 :; " + insertCnt03);
            
            sRtn = "ok";
	    } else {
	        sRtn = "이미 마감된 자료입니다.";
	    }
	    
return sRtn;
	}
	
	
	
}
