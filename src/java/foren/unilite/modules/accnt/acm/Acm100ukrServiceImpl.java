package foren.unilite.modules.accnt.acm;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.accnt.agj.Agj100ukrServiceImpl;
import foren.unilite.modules.accnt.agj.Agj200ukrServiceImpl;
import foren.unilite.modules.com.common.CMSIntfServiceImpl;



@Service("acm100ukrService")
public class Acm100ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@Resource( name = "agj100ukrService" )
	private Agj100ukrServiceImpl agj100ukrService;
	
	@Resource( name = "agj200ukrService" )
	private Agj200ukrServiceImpl agj200ukrService;	

	@Resource(name="cMSIntfService")
	private CMSIntfServiceImpl cMSIntfService;
	
	/**
	 * 결의전표등록 - 현금계정 가져오기 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "Accnt")
	public Object getCashAccnt(Map param) throws Exception {
		return super.commonDao.select("acm100ukrServiceImpl.getCashAccnt", param);
	}	
	
	/**
	 * 회계전표등록 - 일반전표 목록 조회 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "Accnt")
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return (List) super.commonDao.list("acm100ukrServiceImpl.selectList", param);
	}
	
	/**
	 * 회계전표등록 - 매입매출 목록 조회 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "Accnt")
	public List<Map<String, Object>> selectSalesList(Map param, LoginVO loginVO) throws Exception {
		cMSIntfService.getCMSData(param, loginVO);
		return (List) super.commonDao.list("acm100ukrServiceImpl.selectSalesList", param);
	}
	
	/**
	 * 전표생성
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "accnt" )
	public List<Map<String, Object>> fnGetAutoMethod( Map param ) throws Exception {
		int slipNum = 0;
		if ("Y1".equals(param.get("INPUT_PATH"))) {
			Map slipInfo = (Map)agj100ukrService.getSlipNum(param);
			slipNum = Integer.parseInt(ObjUtils.getSafeString(slipInfo.get("SLIP_NUM")));
		} else {
			Map slipInfo = (Map)agj200ukrService.getSlipNum(param);
			slipNum = Integer.parseInt(ObjUtils.getSafeString(slipInfo.get("SLIP_NUM")));
		}
		List<Map<String, Object>> rList = super.commonDao.list("acm100ukrServiceImpl.fnGetAutoMethod", param);
		for (Map rData : rList) {
			rData.put("SLIP_NUM", slipNum);
		}
		return rList;
	}	
	
	/**
	 * 매핑
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY,  group = "accnt")		// 실행
	public Object fnAcmbankMapping(Map param, LoginVO user) throws Exception {	
		
		Map sParam = new HashMap();		
		
		sParam.put("CompCode", user.getCompCode());
		sParam.put("ApprDateFr", param.get("AP_DATE_FR"));
		sParam.put("ApprDateTo", param.get("AP_DATE_TO"));
		sParam.put("CrdtNum", param.get("CREDIT_NUM"));
		
		super.commonDao.queryForObject("acm100ukrServiceImpl.spAcmBankMapping", sParam);
		
		String ErrorDesc = ObjUtils.getSafeString(sParam.get("ErrorDesc"));	
		
		if(ObjUtils.isNotEmpty(ErrorDesc))	{
			throw new  UniDirectValidateException(this.getMessage(ErrorDesc, user));
		}
		return ErrorDesc;
		
	}    
	
	/**
	 * 회계전표등록 - 전표옵션 조회 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "Accnt")
	public Object selectOption(Map param) throws Exception {
		
		return super.commonDao.select("acm100ukrServiceImpl.selectOption", param);
	}
	
	/**
	 * 회계전표등록 - 전표번호 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "Accnt")
	public Object getSlipNum(Map param) throws Exception {
		
		return super.commonDao.select("acm100ukrServiceImpl.getSlipNum", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "Accnt")
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
	
		
		//로그테이블에서 사용할 Key 생성		
		String keyValue = getLogKey();			
		
		//로그테이블에 KEY_VALUE, OPR_FLAG 업데이트
		List<Map> dataList = new ArrayList<Map>();

		Map sParam = new HashMap();
		
		Map autoMap = (Map) super.commonDao.select("acm100ukrServiceImpl.getMaxAutoNum", sParam);
		int i=  Integer.parseInt(autoMap.get("MAX_AUTO_NUM").toString());
		if(paramList != null)	{
			for(Map param: paramList) {
				dataList = (List<Map>)param.get("data");
				for(Map paramData: dataList) {
					paramData.put("KEY_VALUE", keyValue);		
					paramData.put("AUTO_NUM", i);
					super.commonDao.update("acm100ukrServiceImpl.insertLog", paramData);	
					i++;
				}
				
			}
		}
		
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		dataMaster.put("KEY_VALUE", keyValue);	
		dataMaster.put("S_COMP_CODE", user.getCompCode());
		dataMaster.put("S_USER_ID", user.getUserID());
		logger.debug("test");	
		
		//Stored Procedure 실행
		sParam.put("CompCode", user.getCompCode());
		sParam.put("KeyValue", keyValue);
		sParam.put("UserID", user.getUserID());
		sParam.put("UserLang", user.getLanguage());
		
		super.commonDao.queryForObject("acm100ukrServiceImpl.spAccntAcSlip", sParam);
		
		String ErrorDesc = ObjUtils.getSafeString(sParam.get("ErrorDesc"));

		if(ObjUtils.isNotEmpty(ErrorDesc))	{
			throw new  UniDirectValidateException(this.getMessage(ErrorDesc, user));
		} else {
			
			if(paramList != null)	{
				List<Map> dataList2 = new ArrayList<Map>();
				boolean bDelete = false;
				
				for(Map param: paramList) {
					dataList2 = (List<Map>)param.get("data");
					for(Map paramData: dataList2) {
						Map rMap= (Map) super.commonDao.select("acm100ukrServiceImpl.selectLog", paramData);
						
						paramData.put("OPR_FLAG", "L");
						paramData.put("SLIP_NUM", rMap.get("SLIP_NUM"));
						
						paramData.put("OLD_SLIP_NUM", rMap.get("SLIP_NUM"));
						paramData.put("OLD_AC_DATE", paramData.get("AC_DATE"));
						paramData.put("OLD_SLIP_SEQ", paramData.get("SLIP_SEQ"));
						dataMaster.put("SLIP_NUM",rMap.get("SLIP_NUM"));
						
						if(rMap.get("OPR_FLAG").equals("D")) {
							dataMaster.put("SLIP_YN","N");
						}else{
							dataMaster.put("SLIP_YN","Y");
						}
						
						if(rMap.get("OPR_FLAG").equals("D")) {
							bDelete = true;
						}
					}
				}
				if(bDelete) {
					super.commonDao.update("acm100ukrServiceImpl.updateMasterDelete", dataMaster);
				}
				else {
					super.commonDao.update("acm100ukrServiceImpl.updateMaster", dataMaster);
				}
			}
		}
		
		paramMaster.put("data", dataMaster);
		paramList.add(0, paramMaster);		
		return  paramList;
	}


	@ExtDirectMethod(group = "Accnt", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> insert(List<Map> params) throws Exception {
		return params;
	}
	@ExtDirectMethod(group = "Accnt", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> update(List<Map> params) throws Exception {
		return params;
	}
	@ExtDirectMethod(group = "Accnt", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> delete(List<Map> params) throws Exception {
		return params;
	}
	
	
	/**
	 * 중복 입력자롸 확인
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt")
	public List<Map> selectDuplicate(Map params, LoginVO user) throws Exception {
		List<Map> paramList = (List<Map>) params.get("data");
		List<Map> rList = new ArrayList<Map>();
		for(Map pMap : paramList) {
			if("1".equals(params.get("csSLIP_TYPE"))) {
				pMap.put("S_COMP_CODE", user.getCompCode());
				Map dup = (Map)super.commonDao.select("acm100ukrServiceImpl.selectDuplicate", pMap);
				if(dup != null && ObjUtils.parseInt(dup.get("CNT")) > 0) {
					rList.add(pMap);
				}
			} else {
				pMap.put("S_COMP_CODE", user.getCompCode());
				Map dup = (Map)super.commonDao.select("acm100ukrServiceImpl.selectDuplicate", pMap);
				if(dup != null && ObjUtils.parseInt(dup.get("CNT")) > 0) {
					rList.add(pMap);
				}
			}
		}
		return rList;
	}
}
