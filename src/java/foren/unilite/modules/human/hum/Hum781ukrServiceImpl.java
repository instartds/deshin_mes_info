package foren.unilite.modules.human.hum;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.BindingResult;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.extjs.UniliteExtjsUtils;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.base.bdc.Bdc100ukrvService;
import foren.unilite.modules.com.fileman.FileMnagerService;



@Service("hum781ukrService")
public class Hum781ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	
	
	/**
	 * Master 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "hum", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectMasterList(Map param) throws Exception {
		return super.commonDao.list("hum781ukrServiceImpl.selectMasterList", param);
	}	
	
	
	/**
	 * Detail 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "hum", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectDetailList(Map param) throws Exception {
		return super.commonDao.list("hum781ukrServiceImpl.selectDetailList", param);
	}	
			
	
	/**
	 * Master 수정
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "hum", value = ExtDirectMethodType.STORE_MODIFY )
	public Integer updateMaster(List<Map> paramList, LoginVO user) throws Exception {		
		 for(Map param :paramList )	{
			 super.commonDao.update("hum781ukrServiceImpl.updateMaster", param);
		 }		 
		 return 0;
	}

	
	/**
	 * Detail 수정
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "hum", value = ExtDirectMethodType.STORE_MODIFY )
	public Integer updateDetail(List<Map> paramList, LoginVO user) throws Exception {		
		 for(Map param :paramList )	{
			 super.commonDao.update("hum781ukrServiceImpl.updateDetail", param);
		 }		 
		 return 0;
	}
	

	/**
	 * 저장
	 * @param paramList	리스트의 create, update, destroy 오퍼레이션별 정보
	 * @param paramMaster 폼(마스터 정보)의 기본 정보
	 * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "hum", value = ExtDirectMethodType.STORE_SYNCALL )
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {

		if(paramList != null)	{
			List<Map> masterUpdateList = null;
//			List<Map> detailInsertList = null;
			List<Map> detailUpdateList = null;
//			List<Map> detailDeleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("updateMaster")) {
					masterUpdateList = (List<Map>)dataListMap.get("data");				
				} else if(dataListMap.get("method").equals("updateDetail")) {
					detailUpdateList = (List<Map>)dataListMap.get("data");	
				}
			}		
			if(masterUpdateList != null) this.updateMaster(masterUpdateList, user);
			if(detailUpdateList != null) this.updateDetail(detailUpdateList, user);				
		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	}
	
	
	/**
	 * 평가지급율관리 재원산출
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "hum", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectSorc(Map param) throws Exception {
		return super.commonDao.list("hum781ukrServiceImpl.selectSorc", param);
	}	
	

	
	/**
	 * 대상자 생성
	 * @param param
	 * @return
	 * @throws Exception
	 */
    @ExtDirectMethod(group = "hum", value = ExtDirectMethodType.STORE_READ)
    public int createBaseData(Map param, LoginVO user) throws Exception {
    	
        
        try {
        	super.commonDao.update("hum781ukrServiceImpl.createBaseData", param);
		}catch(Exception e){
			throw new  UniDirectValidateException(this.getMessage("2627", user));
		}		
		return 0;
        
        
    }
	
    /**
	 * 지급율 확정
	 * @param param
	 * @return
	 * @throws Exception
	 */
    @ExtDirectMethod(group = "hum", value = ExtDirectMethodType.STORE_READ)
    public int commitMeritsRate(Map param, LoginVO user) throws Exception {
    	
        
        try {
        	super.commonDao.update("hum781ukrServiceImpl.commitMeritsRate", param);
		}catch(Exception e){
			throw new  UniDirectValidateException(this.getMessage("2627", user));
		}		
		return 0;
    }
	
    
    /**
	 * 공제금액계산
	 * @param param
	 * @return
	 * @throws Exception
	 */
    @ExtDirectMethod(group = "hum",  value = ExtDirectMethodType.STORE_READ)
    public int calcTaxAmt(Map param, LoginVO user) throws Exception {
    	
        
        try {
        	super.commonDao.update("hum781ukrServiceImpl.calcTaxAmt", param);
		}catch(Exception e){
			throw new  UniDirectValidateException(this.getMessage("2627", user));
		}		
		return 0;
        
        
    }
    
    
    /**
	 * 급여반영
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "hum", value = ExtDirectMethodType.STORE_MODIFY)
    public int insertSalary(Map param, LoginVO user) throws Exception {
        
        try {
        	super.commonDao.update("hum781ukrServiceImpl.insertSalary", param);
		}catch(Exception e){
			throw new  UniDirectValidateException(this.getMessage("2627", user));
		}		
		return 0;
        
    }
	
	
}
