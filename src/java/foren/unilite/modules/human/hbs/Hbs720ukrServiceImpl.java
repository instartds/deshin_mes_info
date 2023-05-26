package foren.unilite.modules.human.hbs;

//import java.util.ArrayList;
//import java.util.HashMap;
import java.util.List;
import java.util.Map;

//import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
//import org.springframework.validation.BindingResult;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
//import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
//import foren.framework.extjs.UniliteExtjsUtils;
import foren.framework.model.LoginVO;
//import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
//import foren.unilite.modules.base.bdc.Bdc100ukrvService;
//import foren.unilite.modules.com.fileman.FileMnagerService;



@Service("hbs720ukrService")
public class Hbs720ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	
	
	
	/**
	 * Master 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "hbs", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectMasterList(Map param) throws Exception {
		return super.commonDao.list("hbs720ukrServiceImpl.selectMasterList", param);
	}	

	
	/**
	 * Master 수정
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "hbs", value = ExtDirectMethodType.STORE_MODIFY )
	public Integer updateMaster(List<Map> paramList, LoginVO user) throws Exception {		
		 for(Map param :paramList )	{
			 super.commonDao.update("hbs720ukrServiceImpl.updateMaster", param);
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
	@ExtDirectMethod(group = "hbs", value = ExtDirectMethodType.STORE_SYNCALL )
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {

		if(paramList != null)	{
			List<Map> masterUpdateList = null;
			List<Map> detailUpdateList = null;
			
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("updateMaster")) {
					masterUpdateList = (List<Map>)dataListMap.get("data");				
				} else if(dataListMap.get("method").equals("updateDetail")) {
					detailUpdateList = (List<Map>)dataListMap.get("data");	
				}
			}		
			if(masterUpdateList != null) this.updateMaster(masterUpdateList, user);
		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	}
	
	
//	/**
//	 * 1.대상자 생성
//	 * @param param
//	 * @return
//	 * @throws Exception
//	 */
//    @ExtDirectMethod(group = "hbs", value = ExtDirectMethodType.STORE_READ)
//    public int createBaseData(Map param, LoginVO user) throws Exception {
//    	
//        
//        try {
//        	super.commonDao.update("hbs720ukrServiceImpl.createBaseData", param);
//		}catch(Exception e){
//			throw new  UniDirectValidateException(this.getMessage("2627", user));
//		}		
//		return 0;
//        
//    }
//	
//    
//    /**
//     * 2.평균호봉습급액계산
//     * @param param
//     * @return
//     * @throws Exception
//     */
//    @ExtDirectMethod(group = "hbs", value = ExtDirectMethodType.STORE_READ)
//	public List<Map<String, Object>> calcAvg(Map param) throws Exception {
//		return super.commonDao.list("hbs720ukrServiceImpl.calcAvg", param);
//	}
//    
//    
//    /**
//     * 2-1.평균호봉승급액 반영
//     * @param param
//     * @return
//     * @throws Exception
//     */
//    @ExtDirectMethod(group = "hum", value = ExtDirectMethodType.STORE_MODIFY )
//    public int commitAvrgAmt(Map param, LoginVO user) throws Exception {
//    	
//    	
//    	try {
//    		super.commonDao.update("hbs720ukrServiceImpl.commitAvrgAmt", param);
//    	}catch(Exception e){
//    		throw new  UniDirectValidateException(this.getMessage("2627", user));
//    	}		
//    	return 0;
//    }
//	
//    
//	/**
//	 * 3.가율계산 - 재원산출
//	 * @param param
//	 * @return
//	 * @throws Exception
//	 */
//	@ExtDirectMethod(group = "hbs", value = ExtDirectMethodType.STORE_READ)
//	public List<Map<String, Object>> selectSorc(Map param) throws Exception {
//		return super.commonDao.list("hbs720ukrServiceImpl.selectSorc", param);
//	}
//    
//	
//    /**
//	 * 3.가율계산 - 가율 확정
//	 * @param param
//	 * @return
//	 * @throws Exception
//	 */
//    @ExtDirectMethod(group = "hum", value = ExtDirectMethodType.STORE_MODIFY )
//    public int commitMeritsRate(Map param, LoginVO user) throws Exception {
//    	
//        try {
//        	super.commonDao.update("hbs720ukrServiceImpl.commitMeritsRate", param);
//		}catch(Exception e){
//			throw new  UniDirectValidateException(this.getMessage("2627", user));
//		}		
//		return 0;
//    }
//    
//    
//    /**
//	 * 4.상세금액계산
//	 * @param param
//	 * @return
//	 * @throws Exception
//	 */
//    @ExtDirectMethod(group = "hum", value = ExtDirectMethodType.STORE_MODIFY )
//    public int calcAmt(Map param, LoginVO user) throws Exception {
//    	
//    	try {
//    		super.commonDao.update("hbs720ukrServiceImpl.calcAmt", param);
//    	}catch(Exception e){
//    		throw new  UniDirectValidateException(this.getMessage("2627", user));
//    	}		
//    	return 0;
//    }
}
