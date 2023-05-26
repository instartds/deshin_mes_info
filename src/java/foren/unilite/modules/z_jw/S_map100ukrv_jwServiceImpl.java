package foren.unilite.modules.z_jw;

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
import foren.unilite.modules.com.fileman.FileMnagerService;

@Service("s_map100ukrv_jwService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class S_map100ukrv_jwServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	
	
	
	/**
	 * 계산서 유형 선택 시 VAT_RATE 가져오는 로직
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
    public List<Map<String, Object>> selectRefCode2(Map param) throws Exception {
        return super.commonDao.list("s_map100ukrv_jwServiceImpl.selectRefCode2", param);
    }
	
	/**
     * 입고등록->지금결의등록(링크 데이터)
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
    public List<Map<String, Object>> selectMms510ukrv(Map param) throws Exception {
        return super.commonDao.list("s_map100ukrv_jwServiceImpl.selectMms510ukrv", param);
    }
    
	/**
	 * 지급결의등록->매입내역조회 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.FORM_LOAD)
	public Object selectForm(Map param) throws Exception {
		return super.commonDao.select("s_map100ukrv_jwServiceImpl.selectForm", param);
	}//form
	
	/**
	 * 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return super.commonDao.list("s_map100ukrv_jwServiceImpl.selectList", param);
	}//grid
	
	/**
	 * 지급결의등록->지급결의내역검색
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectOrderNumMasterList(Map param) throws Exception {
		return super.commonDao.list("s_map100ukrv_jwServiceImpl.selectOrderNumMasterList", param);
	}

	/**
	 * 지급결의등록->입고내역참조
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectreceiveHistoryList(Map param) throws Exception {
		return super.commonDao.list("s_map100ukrv_jwServiceImpl.selectreceiveHistoryList", param);
	}

	/**
	 * 신고사업장
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public Object  billDivCode(Map param) throws Exception {	
		return  super.commonDao.select("s_map100ukrv_jwServiceImpl.billDivCode", param);
	}



	/**
	 * 지급결의등록-> 저장
	 * @param paramList	리스트의 create, update, destroy 오퍼레이션별 정보
	 * @param paramMaster 폼(마스터 정보)의 기본 정보
	 * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "matrl")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
		logger.debug("[saveAll] paramDetail:" + paramList);

		//1.로그테이블에서 사용할 KeyValue 생성
		String keyValue = getLogKey();						
		
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");

		dataMaster.put("KEY_VALUE", keyValue);
		dataMaster.put("COMP_CODE", user.getCompCode());

		if (ObjUtils.isEmpty(dataMaster.get("CHANGE_BASIS_NUM") )) {
			dataMaster.put("OPR_FLAG", "N");
		} else {
			dataMaster.put("OPR_FLAG", "U");
		}

		
		if (!ObjUtils.isEmpty(dataMaster.get("CREDIT_NUMBER")) && ObjUtils.isEmpty(dataMaster.get("CRDT_NUM"))) {
			dataMaster.put("CREDIT_NUM", dataMaster.get("CREDIT_NUMBER"));
		} else if (ObjUtils.isEmpty(dataMaster.get("CREDIT_NUMBER")) && !ObjUtils.isEmpty(dataMaster.get("CRDT_NUM"))) {
			dataMaster.put("CREDIT_NUM", dataMaster.get("CRDT_NUM"));
		}

		super.commonDao.insert("s_map100ukrv_jwServiceImpl.insertLogForm", dataMaster);
		
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
				param.put("data", super.commonDao.insert("s_map100ukrv_jwServiceImpl.insertLogMaster", param));
			//	param.put("data", super.commonDao.update("s_map100ukrv_jwServiceImpl.insertLogForm", param));
			}
		}

		//4.지급결의등록저장 Stored Procedure 실행
		Map<String, Object> spParam = new HashMap<String, Object>();

		spParam.put("KeyValue", keyValue);
		spParam.put("LangCode", user.getLanguage());

//		super.commonDao.queryForObject("spBuy", spParam);
		super.commonDao.queryForObject("s_map100ukrv_jwServiceImpl.spBuy", spParam);
		
		String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
		
		//출하지시 마스터 출하지시 번호 update
//		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
				
		if(!ObjUtils.isEmpty(errorDesc)){
			dataMaster.put("BILL_NUM", "");
			dataMaster.put("CHANGE_BASIS_NUM", "");
			String[] messsage = errorDesc.split(";");
		    throw new  UniDirectValidateException(this.getMessage(messsage[0], user));
		} else {
			dataMaster.put("BILL_NUM", ObjUtils.getSafeString(spParam.get("BILL_NUM")));
			dataMaster.put("CHANGE_BASIS_NUM", ObjUtils.getSafeString(spParam.get("CHANGE_BASIS_NUM")));
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
