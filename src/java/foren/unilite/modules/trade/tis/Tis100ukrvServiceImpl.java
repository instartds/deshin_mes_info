package foren.unilite.modules.trade.tis;

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
import ch.ralscha.extdirectspring.util.ParametersResolver;
import foren.framework.extjs.UniliteExtjsUtils;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.base.bdc.Bdc100ukrvService;
import foren.unilite.modules.com.fileman.FileMnagerService;
import foren.unilite.modules.crm.cmd.Cmd100ukrvModel;
import foren.unilite.modules.sales.SalesCommonServiceImpl;

@Service("tis100ukrvService")
public class Tis100ukrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	

	@Resource(name="salesCommonService")
	private SalesCommonServiceImpl SalesUtil;

	@Resource(name = "fileMnagerService")
	private FileMnagerService fileMnagerService;
	
	/**
     * 
     * 자사 거래처(수출자)
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(group = "trade", value = ExtDirectMethodType.STORE_READ)
    public Map<String, Object> getOwnCustInfo(Map param) throws Exception {
        return (Map<String, Object>) super.commonDao.select("tis100ukrvServiceImpl.getOwnCustInfo", param);
    }
	
	/**
     * 
     * 환율 조회
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(group = "trade", value = ExtDirectMethodType.STORE_READ)
    public List<Map<String, Object>> fnExchgRateO(Map param) throws Exception {
        return super.commonDao.list("tis100ukrvServiceImpl.fnExchgRateO", param);
    }
    
    /**
     * 
     * OFFER관리번호 SET 조회
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(group = "trade", value = ExtDirectMethodType.STORE_READ)
    public List<Map<String, Object>> selectMasterSetList(Map param) throws Exception {
        return super.commonDao.list("tis100ukrvServiceImpl.selectMasterSetList", param);
    }
    
    /**
     * 
     * B/L관리번호 조회
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(group = "trade", value = ExtDirectMethodType.STORE_READ)
    public List<Map<String, Object>> selectBlMasterList(Map param) throws Exception {
        return super.commonDao.list("tis100ukrvServiceImpl.selectBlMasterList", param);
    }

	/**
	 * 선적정보 Master 조회 
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "trade", value = ExtDirectMethodType.FORM_LOAD)
	public Object selectMaster(Map param) throws Exception {
		return super.commonDao.select("tis100ukrvServiceImpl.selectMaster", param);
	}
	
	/**
	 * 
	 * 선적정보 Detail 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "trade", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectDetailList(Map param) throws Exception {
		return super.commonDao.list("tis100ukrvServiceImpl.selectDetailList", param);
	}

	/**
     * 
     * OFFER 참조 조회
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(group = "trade", value = ExtDirectMethodType.STORE_READ)
    public List<Map<String, Object>> selectOfferGridList(Map param) throws Exception {
        return super.commonDao.list("tis100ukrvServiceImpl.selectOfferGridList", param);
    }
    
    /**
     * 
     * OFFER 내역 조회
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(group = "trade", value = ExtDirectMethodType.STORE_READ)
    public List<Map<String, Object>> selectOfferMasterList(Map param) throws Exception {
        return super.commonDao.list("tis100ukrvServiceImpl.selectOfferMasterList", param);
    }
    
	/**
	 * 선적정보 저장
	 * @param paramList	리스트의 create, update, destroy 오퍼레이션별 정보
	 * @param paramMaster 폼(마스터 정보)의 기본 정보
	 * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "trade")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		//logger.debug("[saveAll] paramMaster:" + paramMaster);
		//logger.debug("[saveAll] paramDetail:" + paramList);

		
		//1.로그테이블에서 사용할 Key 생성		
		String keyValue = getLogKey();			

		//2.수입선적마스터 로그테이블에 KEY_VALUE, OPR_FLAG 업데이트
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");

		dataMaster.put("KEY_VALUE", keyValue);
		dataMaster.put("COMP_CODE", user.getCompCode());

		if (ObjUtils.isEmpty(dataMaster.get("BL_SER_NO") )) {
			dataMaster.put("OPR_FLAG", "N");
		} else {
			dataMaster.put("OPR_FLAG", "U");
		}

		super.commonDao.insert("tis100ukrvServiceImpl.insertLogMaster", dataMaster);
		
		//3.수입선적디테일 로그테이블에 KEY_VALUE, OPR_FLAG 업데이트
		List<Map> dataList = new ArrayList<Map>();
		List<List<Map>> resultList = new ArrayList<List<Map>>();
		if(paramList != null)	{
			for(Map param: paramList) {
				dataList = (List<Map>)param.get("data");
	
				if(param.get("method").equals("insertDetail")) {
					param.put("data", insertLogDetails(dataList, keyValue, "N") );	
				} else if(param.get("method").equals("updateDetail")) {
					param.put("data", insertLogDetails(dataList, keyValue, "U") );	
				} else if(param.get("method").equals("deleteDetail")) {
					param.put("data", insertLogDetails(dataList, keyValue, "D") );	
				}
			}
		}

		//4.수입선적저장 Stored Procedure 실행
		Map<String, Object> spParam = new HashMap<String, Object>();

		spParam.put("KeyValue", keyValue);
		spParam.put("LangCode", user.getLanguage());

		super.commonDao.queryForObject("tis100ukrvServiceImpl.USP_TRADE_Tes100ukr", spParam);
		
		String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));

		if(!errorDesc.isEmpty()){
			dataMaster.put("BL_SER_NO", "");
            String[] messsage = errorDesc.split(";");
            throw new  UniDirectValidateException(this.getMessage(messsage[0], user));
		} else {
			//수입선적번호 마스터에 SET
			dataMaster.put("BL_SER_NO", ObjUtils.getSafeString(spParam.get("blSerNO")));
			//수입선적번호 그리드에 SET
			for(Map param: paramList) {
				dataList = (List<Map>)param.get("data");	
				if(param.get("method").equals("insertDetail")) {
					List<Map> datas = (List<Map>)param.get("data");
					for(Map data: datas){
						data.put("BL_SER_NO", ObjUtils.getSafeString(spParam.get("blSerNO")));
					}
				}
			}
		}
		
		//5.수입선적마스터 정보 + 수입선적디테일 정보 결과셋 리턴
		//마스터정보가 없을 경우에도 작성
		paramList.add(0, paramMaster);
				
		return  paramList;
	}
	
	/**
     * 수입선적 Detail 입력
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_MODIFY)
    public List<Map> insertDetail(List<Map> params, LoginVO user) throws Exception {
        return params;
    }
    
    /**
     * 수입선적 Detail 수정
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_MODIFY)
    public List<Map> updateDetail(List<Map> params, LoginVO user) throws Exception {
        return params;
    }
    
    
    @ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_MODIFY)
    public void deleteDetail(List<Map> params, LoginVO user) throws Exception {

    }
    
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_POST, group = "trade")
	public ExtDirectFormPostResult syncForm(Tis100ukrvModel dataMaster,  LoginVO user,  BindingResult result) throws Exception {	
		
		String keyValue = getLogKey();			
		//2.수입선적마스터 로그테이블에 KEY_VALUE, OPR_FLAG 업데이트
		dataMaster.setS_COMP_CODE(user.getCompCode());
		dataMaster.setS_USER_ID(user.getUserID());
		dataMaster.setKEY_VALUE(keyValue);

		if (ObjUtils.isEmpty(dataMaster.getBL_SER_NO() )) {
			dataMaster.setOPR_FLAG("N");
		} else {
			dataMaster.setOPR_FLAG("U");
		}

		super.commonDao.insert("tis100ukrvServiceImpl.insertLogMaster", dataMaster);

		//4.수입선적저장 Stored Procedure 실행
		Map<String, Object> spParam = new HashMap<String, Object>();

		spParam.put("KeyValue", keyValue);
		spParam.put("LangCode", user.getLanguage());

		super.commonDao.queryForObject("tis100ukrvServiceImpl.USP_TRADE_Tes100ukr", spParam);
		
		String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
		ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);
		if(!errorDesc.isEmpty()){
			extResult.addResultProperty("ORDER_NUM", "");
            String[] messsage = errorDesc.split(";");
            throw new  UniDirectValidateException(this.getMessage(messsage[0], user));
		} else {
			extResult.addResultProperty("ORDER_NUM", ObjUtils.getSafeString(spParam.get("OrderNum")));
		}
		
//		dataMaster.setS_COMP_CODE(user.getCompCode());
//		super.commonDao.update("tis100ukrvServiceImpl.updateMasterForm", dataMaster);
//		ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);
		return extResult;
	}

	/**
	 * 수입선적디테일 로그정보 저장
	 */
	public List<Map> insertLogDetails(List<Map> params, String keyValue, String oprFlag) throws Exception {
		for(Map param: params)		{
			param.put("KEY_VALUE", keyValue);
			param.put("OPR_FLAG", oprFlag);
			
			super.commonDao.insert("tis100ukrvServiceImpl.insertLogDetail", param);
		}		

		return params;
	}
	
	/**
	 * 선적정보 삭제
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "trade", value = ExtDirectMethodType.STORE_MODIFY)
	public void deleteMaster(Map param, LoginVO user) throws Exception {
		
		super.commonDao.delete("tis100ukrvServiceImpl.deleteMaster", param);
	}
	
	/**
	 * 첨부파일 목록 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "trade", value = ExtDirectMethodType.FORM_LOAD)
	public List<Map<String, Object>> getFileList(Map param,  LoginVO login) throws Exception {
		param.put("S_COMP_CODE", login.getCompCode());
		return super.commonDao.list("tis100ukrvServiceImpl.getFileList", param);
	}
	@ExtDirectMethod(group = "trade", value = ExtDirectMethodType.STORE_MODIFY)
	public void insertTED120(Map param, LoginVO login) throws Exception {
			logger.debug("param:::"+param);
			logger.debug("param::::"+ ObjUtils.getSafeString(param.get("ADD_FIDS")));
			fileMnagerService.confirmFile(login, ObjUtils.getSafeString(param.get("ADD_FIDS")));
			String[] fids =  ObjUtils.getSafeString(param.get("ADD_FIDS")).split(",");

			 for(String fid : fids)	{
				 param.put("FID", fid);
				 super.commonDao.insert("tis100ukrvServiceImpl.insertTED120", param);
			 }
	}
	@ExtDirectMethod(group = "trade", value = ExtDirectMethodType.STORE_MODIFY)
	public void deleteTED120(Map param, LoginVO login) throws Exception {
			fileMnagerService.deleteFile(login, ObjUtils.getSafeString(param.get("DEL_FIDS")));
			String[] fids =  ObjUtils.getSafeString(param.get("DEL_FIDS")).split(",");
			 for(String fid : fids)	{
				 param.put("FID", fid);
				 super.commonDao.update("tis100ukrvServiceImpl.deleteTED120", param);
			 }
	}
	@ExtDirectMethod(group = "trade", value = ExtDirectMethodType.STORE_READ)
	public Object selectDocCnt(Map param) throws Exception {
		return super.commonDao.select("tis100ukrvServiceImpl.selectDocCnt", param);
	}
}