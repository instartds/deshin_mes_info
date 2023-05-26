package foren.unilite.modules.accnt.acm;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.GStringUtils;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;



@Service("acm210ukrService")
public class Acm210ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	/**
	 * 부가세 계정코드 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "Accnt")
	public Object getTaxAccnt(Map param) throws Exception {
		return super.commonDao.select("acm210ukrServiceImpl.getTaxAccnt", param);
	}	
	
	/**
	 * 결의전표등록(전표번호별) 이후 전표 조회 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "Accnt")
	public Object getSlipNum(Map param) throws Exception {
		return super.commonDao.select("acm210ukrServiceImpl.getSlipNum", param);
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
	
	// 조회팝업 조회
	@ExtDirectMethod(group = "Accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map> selectSearch(Map param) throws Exception {
		return super.commonDao.list("acm210ukrServiceImpl.selectSearch", param);
	}
	
	// masterGrid1 조회
	@ExtDirectMethod(group = "Accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map> selectList(Map param) throws Exception {
		return super.commonDao.list("acm210ukrServiceImpl.selectList", param);
	}

	// apprCardGrid 조회 
	@ExtDirectMethod(group = "Accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map> selectList2(Map param) throws Exception {
		Map<String, Object> rTemp = (Map<String, Object>) super.commonDao.select("acm210ukrServiceImpl.selectFnDate", param);
		String fnDate = ObjUtils.getSafeString(rTemp.get("FN_DATE"));
		if(ObjUtils.isNotEmpty(fnDate))	{
			fnDate = GStringUtils.left(fnDate, 4) + GStringUtils.right(ObjUtils.getSafeString(param.get("AC_DATE_FR")), 4);
		} else {
			fnDate = ObjUtils.getSafeString(param.get("AC_DATE_FR"));
		}
		param.put("S_DATE", fnDate);
		return super.commonDao.list("acm210ukrServiceImpl.selectList2", param);
	}
	
	// 참조데이터 조회
	@ExtDirectMethod(group = "Accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map> selectApprCardRef(Map param) throws Exception {
		return super.commonDao.list("acm210ukrServiceImpl.selectApprCardRef", param);
	}
	
	// 저장
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "Accnt")
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		
		//로그테이블에서 사용할 Key 생성
		String keyValue = getLogKey();
		Map<String, Object> paramMasterData = (Map<String, Object>) paramMaster.get("data");
		
		//로그테이블에 KEY_VALUE, OPR_FLAG 업데이트
		List<Map> dataList = new ArrayList<Map>();

		Map sParam = new HashMap();
		
		// AutoNum 최대값 조회
		Map autoMap = (Map) super.commonDao.select("acm210ukrServiceImpl.getMaxAutoNum", sParam);
		int i=  Integer.parseInt(autoMap.get("MAX_AUTO_NUM").toString());
		
		// 데이터 갯수만큼 로그테이블에 저장
		if(paramList != null)	{
			for(Map param: paramList) {
				dataList = (List<Map>)param.get("data");
				for(Map paramData: dataList) {
					paramData.put("KEY_VALUE", keyValue);		
					paramData.put("AUTO_NUM", i);
					
					log.debug(paramData.values());
					
					super.commonDao.update("acm210ukrServiceImpl.insertLog", paramData);	
					i++;
				}
			}
		}

		//Stored Procedure 실행
		sParam.put("CompCode", user.getCompCode());
		sParam.put("KeyValue", keyValue);
		sParam.put("CallPath", "");
		sParam.put("UserID", user.getUserID());
		sParam.put("UserLang", user.getLanguage());
		
		// 데이터 삭제 후 저장
		super.commonDao.queryForObject("acm210ukrServiceImpl.spAccntDeleteAcSlip", sParam);
		super.commonDao.queryForObject("acm210ukrServiceImpl.spAccntInsertAcSlip", sParam);
		
		String ErrorDesc = ObjUtils.getSafeString(sParam.get("ErrorDesc"));

		if(ObjUtils.isNotEmpty(ErrorDesc))	{
			throw new  UniDirectValidateException(this.getMessage(ErrorDesc, user));
		}
		
		// 저장 후 
		String rtnFlag = "S";
		paramMasterData.put("AC_DATE", ObjUtils.getSafeString(paramMasterData.get("AC_DATE")));
		paramMasterData.put("SLIP_NUM", ObjUtils.getSafeString(paramMasterData.get("SLIP_NUM")));
		paramMasterData.put("S_COMP_CODE", user.getCompCode());
		
		List<Map> chkData = super.commonDao.list("acm210ukrServiceImpl.getChkData", paramMasterData);
		if(chkData.size() < 1) rtnFlag = "D"; //삭제일경우
		
		paramMasterData.put("FLAG", rtnFlag);
		
		paramList.add(0, paramMaster);
		return paramList;
	}
}
