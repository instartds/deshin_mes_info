package foren.unilite.modules.human.hrt;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.model.LoginVO;
import foren.framework.utils.ConfigUtil;
import foren.framework.utils.FileUtil;
import foren.framework.utils.ObjUtils;
import foren.framework.web.view.FileDownloadInfo;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.base.bcm.Bcm105ukrvModel;
import foren.unilite.modules.base.bpr.Bpr300ukrvModel;
import foren.unilite.utils.ExtFileUtils;

@Service("hrt700ukrService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class Hrt700ukrServiceImpl  extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	/**
	 * 컬럼 조회 (HBS300T)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List selectColumns(Map<String, Object> param) throws Exception {
		return (List)super.commonDao.list("hrt700ukrServiceImpl.selectColumns", param);
	}

	/**Master data 조회
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "human")
	public List<Map> selectList(Map param, LoginVO user) throws Exception {
		List<Map> paymentList = super.commonDao.list("hrt700ukrServiceImpl.checkPayment", param);
		
		
		if( paymentList == null || paymentList.size() == 0 || paymentList.get(0).get("CNT_PAYMENT").toString().equals("0") ){
			throw new UniDirectValidateException("해당월의 급여자료가 없습니다.");
		}
		else {
			List divList = (ArrayList)param.get("DIV_CODE");
			for(Object divCode : divList) {
				
				Map chkParam = new HashMap();

				chkParam.put("S_COMP_CODE", user.getCompCode());
				chkParam.put("DIV_CODE", divCode);
				chkParam.put("PAY_YYYYMM", param.get("PAY_YYYYMM"));
				chkParam.put("amtArray", param.get("amtArray"));
				chkParam.put("S_USER_ID", user.getUserID());
				
				List<Map> pensionList = super.commonDao.list("hrt700ukrServiceImpl.checkPension", chkParam);

				if( pensionList == null || pensionList.size() == 0 || pensionList.get(0).get("CNT_PENSION").toString().equals("0") ) {
					List<Map> newList = super.commonDao.list("hrt700ukrServiceImpl.selectNewList", chkParam);
				}
			}
			
			return super.commonDao.list("hrt700ukrServiceImpl.selectList", param);
		}
	}

	/**Master data 저장로직
	 * @param params
	 * @param user
	 * @param dataMaster
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "human")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		dataMaster.put("S_COMP_CODE", user.getCompCode());
		dataMaster.put("S_USER_ID"	, user.getUserID());
		
		if(paramList != null) {
			List<Map> deleteList = null;
			List<Map> updateList = null;
			
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("deleteList")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}
				if(dataListMap.get("method").equals("updateList")) {
					updateList = (List<Map>)dataListMap.get("data");
				}
			}
			if(deleteList != null) this.deleteList(deleteList, user, dataMaster);
			if(updateList != null) this.updateList(updateList, user, dataMaster);
		}
		paramList.add(0, paramMaster);
		return  paramList;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "human")
	public Integer deleteList(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {
		for(Map param : paramList ) {
			super.commonDao.update("hrt700ukrServiceImpl.deleteList", param);
		}
		return 0;
	} 

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "human")
	public Integer updateList(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {
		List wagesList = (List)paramMaster.get("amtArray");
		for(Map param : paramList ) {
			for(Object wagesCode : wagesList) {
				param.put("WAGES_CODE", wagesCode.toString());
				param.put("AMOUNT_I", param.get("AMT_" + wagesCode.toString()));
				super.commonDao.update("hrt700ukrServiceImpl.updateList", param);
			}
		}
		return 0;
	} 

	/**
	 * 마감여부 조회
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_READ, group = "human" )
	public Map<String, Object> fnGetCloseAll( Map param, LoginVO user ) throws Exception {
		return (Map)super.commonDao.select("hrt700ukrServiceImpl.fnGetCloseAll", param);
    }
    
	/**
	 * 전제마감/마감취소
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "human" )
	public Map<String, Object> fnSetCloseAll( Map param, LoginVO user ) throws Exception {
		super.commonDao.update("hrt700ukrServiceImpl.fnSetCloseAll", param);
		return param;
    }
    
	
	/**
	 * 퇴직급여 엑셀업로드
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public void excelValidate(String jobID, Map param) throws Exception {
		logger.debug("validate: {}", jobID);
		//UPLOAD 전 데이터 존재여부 체크
		List<Map> getData = (List<Map>) super.commonDao.list("hrt700ukrServiceImpl.getData", param);
		
		if(!getData.isEmpty()){
			//excel 파일의 데이터 체크
			for(Map data : getData )  { 
                param.put("ROWNUM", data.get("_EXCEL_ROWNUM"));
				param.put("COMP_CODE", data.get("COMP_CODE"));
				param.put("PERSON_NUMB", data.get("PERSON_NUMB"));
				param.put("RETR_DATE", data.get("RETR_DATE"));
				param.put("RETR_TYPE", data.get("RETR_TYPE"));
				
				//업로드 된 데이터의 사번 등록여부 확인
				String custExistYn =  (String) super.commonDao.select("hrt700ukrServiceImpl.checkPersonNum", param);
				if (custExistYn.equals("N")) {
					param.put("MSG", "사번 [" + data.get("PERSON_NUMB") +"]을 확인하십시오.");
					super.commonDao.update("hrt700ukrServiceImpl.insertErrorMsg", param);
				}
				
				//업로드 된 데이터의 정산일 등록여부 확인
				String retrExistYn =  (String) super.commonDao.select("hrt700ukrServiceImpl.checkRetrDate", param);
				if (retrExistYn.equals("Y")) {
					param.put("MSG", "정산일 [" + data.get("RETR_DATE") +"]이 존재합니다..");
					super.commonDao.update("hrt700ukrServiceImpl.insertErrorMsg", param);
				}
				
			}
		}
	}
}