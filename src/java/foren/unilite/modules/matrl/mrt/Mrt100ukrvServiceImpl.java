package foren.unilite.modules.matrl.mrt;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.exolab.castor.mapping.xml.Param;
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
import foren.unilite.modules.com.fileman.FileMnagerService;

@Service("mrt100ukrvService")
public class Mrt100ukrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	
	/**
	 * 반품등록-> 반품내역 조회 
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return super.commonDao.list("mrt100ukrvServiceImpl.selectList", param);
	}
	
	/**
	 * 
	 * 반품등록-> 반품번호 검색
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectinoutNoMasterList(Map param) throws Exception {
		return super.commonDao.list("mrt100ukrvServiceImpl.selectinoutNoMasterList", param);
	}

	/**
	 * 
	 * 반품등록-> 반품접수 참조
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectReturningReceiptList(Map param) throws Exception {
		return super.commonDao.list("mrt100ukrvServiceImpl.selectReturningReceiptList", param);
	}
	/**
	 * 단가&매입율 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@Transactional(readOnly=true) //, isolation=TransactionDefinition.ISOLATION_READ_UNCOMMITTED) 
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public Object  fnOrderPrice(Map param) throws Exception {	

		return  super.commonDao.select("mrt100ukrvServiceImpl.fnOrderPrice", param);
	}
	
	/**
	 * 판매단가 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@Transactional(readOnly=true) //, isolation=TransactionDefinition.ISOLATION_READ_UNCOMMITTED) 
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public Object  fnSaleBasisP(Map param) throws Exception {	

		return  super.commonDao.select("mrt100ukrvServiceImpl.fnSaleBasisP", param);
	}
	/**
	 * 
	 * userID에 따른 창고 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public Object  userWhcode(Map param) throws Exception {	
		
		return  super.commonDao.select("mrt100ukrvServiceImpl.userWhcode", param);
	}
	
	/**
	 * 
	 * 공급가액,부가세,합계금액관련
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public Object  fnGetCalcTaxAmt(Map param) throws Exception {	
		
		return  super.commonDao.select("mrt100ukrvServiceImpl.fnGetCalcTaxAmt", param);
	}
	
	/**
	 * 
	 * 과세구분
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public Object  taxType(Map param) throws Exception {	
		
		return  super.commonDao.select("mrt100ukrvServiceImpl.taxType", param);
	}
	
	
	/**
	 * 반품등록-> 저장
	 * @param paramList	리스트의 create, update, destroy 오퍼레이션별 정보
	 * @param paramMaster 폼(마스터 정보)의 기본 정보
	 * @param CreateType 
	 * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
		logger.debug("[saveAll] paramDetail:" + paramList);

		//1.로그테이블에서 사용할 KeyValue 생성
		String keyValue = getLogKey();						
		//2.반품등록 로그테이블에 KEY_VALUE, OPR_FLAG 업데이트
		List<Map> dataList = new ArrayList<Map>();
		List<List<Map>> resultList = new ArrayList<List<Map>>();
		
		for(Map paramData: paramList) {			
			
			dataList = (List<Map>) paramData.get("data");
			String oprFlag = "N";
			if(paramData.get("method").equals("insertDetail"))	oprFlag="N";
			if(paramData.get("method").equals("updateDetail"))	oprFlag="U";
			if(paramData.get("method").equals("deleteDetail"))	oprFlag="D";

			for(Map param:  dataList) {
				param.put("KEY_VALUE", keyValue);
				param.put("OPR_FLAG", oprFlag);
				
			//	param.put("UPDATE_DB_USER", 0);
			//	param.put("UPDATE_DB_TIME", 0);
//				param.put("PICK_BOX_QTY", 0);
//				param.put("PICK_EA_QTY", 0);
//				param.put("PICK_STATUS", "");
				param.put("data", super.commonDao.insert("mrt100ukrvServiceImpl.insertLogDetail", param));
				/*if(!ObjUtils.isEmpty(param.get("RETURN_NUM")) && !ObjUtils.isEmpty(param.get("RETURN_SEQ"))) {
					if(param.get("KEY_VALUE") == "N"){
						param.put("data", super.commonDao.insert("mrt100ukrvServiceImpl.updateMRT200T", param));
					}else if(param.get("KEY_VALUE") == "U"){
						param.put("data", super.commonDao.insert("mrt100ukrvServiceImpl.update2MRT200T", param));
					}else if(param.get("KEY_VALUE") == "D"){
						param.put("data", super.commonDao.insert("mrt100ukrvServiceImpl.update3MRT200T", param));
					}
				}*/
			}
		}

		//4.반품등록저장 Stored Procedure 실행
		Map<String, Object> spParam = new HashMap<String, Object>();

		spParam.put("KeyValue", keyValue);
		spParam.put("LangCode", user.getLanguage());
		spParam.put("CreateType", "1");

		super.commonDao.queryForObject("spReturning", spParam);
		
		String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
		

		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
				

		if(!ObjUtils.isEmpty(errorDesc)){
			dataMaster.put("INOUT_NUM", "");
			String[] messsage = errorDesc.split(";");
		    throw new  UniDirectValidateException(this.getMessage(messsage[0], user));
		} else {

			dataMaster.put("INOUT_NUM", ObjUtils.getSafeString(spParam.get("InOutNum")));

			for(Map param: paramList)  {
				dataList = (List<Map>)param.get("data");	
				if(param.get("method").equals("insertDetail")) {
					List<Map> datas = (List<Map>)param.get("data");
					for(Map data: datas){
						data.put("INOUT_NUM", ObjUtils.getSafeString(spParam.get("InOutNum")));
					}
				}
			}		
		}
		
		paramList.add(0, paramMaster);
		
		return  paramList;
	}
	
	/**
	 * Detail 입력
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_MODIFY)
	public void insertDetail(List<Map> paramList, LoginVO user) throws Exception {
		return;
	}

	/**
	 * Detail 수정
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("rawtypes")
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_MODIFY)
	public void updateDetail(List<Map> paramList, LoginVO user) throws Exception {
		return;
	}
	
	/**
	 * Detail 삭제
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_MODIFY)
	public void deleteDetail(List<Map> paramList, LoginVO user) throws Exception {
		return;
	}
}
