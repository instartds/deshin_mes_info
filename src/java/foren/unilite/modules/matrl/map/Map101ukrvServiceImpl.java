package foren.unilite.modules.matrl.map;

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

@Service("map101ukrvService")
public class Map101ukrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	

	/**
	 * 지급결의확정 수불조회 좌
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return super.commonDao.list("map101ukrvServiceImpl.selectList", param);
	}
	
	/**
	 * 지급결의확정 수불조회 우
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList2(Map param) throws Exception {
		return super.commonDao.list("map101ukrvServiceImpl.selectList2", param);
	}
	
	/**
	 * 
	 * 신고사업장
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public Object  billDivCode(Map param) throws Exception {	
		return  super.commonDao.select("map101ukrvServiceImpl.billDivCode", param);
	}
	

	/**
	 * 지급결의확정-> 저장
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

/*		dataMaster.put("KEY_VALUE", keyValue);
		dataMaster.put("COMP_CODE", user.getCompCode());

		if (ObjUtils.isEmpty(dataMaster.get("CHANGE_BASIS_NUM") )) {
			dataMaster.put("OPR_FLAG", "N");
		} else {
			dataMaster.put("OPR_FLAG", "U");
		}

		super.commonDao.insert("map101ukrvServiceImpl.insertLogForm", dataMaster);*/
		
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
				if(param.get("BILL_NUM").equals("")){
					param.put("OPR_FLAG", 'N');
				}else{
					param.put("OPR_FLAG", 'D');
				}
				param.put("DEPT_CODE", dataMaster.get("DEPT_CODE"));					//결의부서
				param.put("DEPT_NAME", dataMaster.get("DEPT_NAME"));					
				param.put("BILL_DIV_CODE", dataMaster.get("BILL_DIV_CODE"));			//신고사업장
				param.put("CHANGE_BASIS_DATE", dataMaster.get("CHANGE_BASIS_DATE"));	//전표일자
//				param.put("BILL_TYPE", dataMaster.get("BILL_TYPE"));					//계산서유형
				param.put("ACCOUNT_TYPE", dataMaster.get("ACCOUNT_TYPE"));				//매입유형
				param.put("ORDER_TYPE", dataMaster.get("ORDER_TYPE"));					//발주형태
				param.put("BILL_SEND_YN", dataMaster.get("BILL_SEND_YN"));				//전자발행여부
			//	param.put("UPDATE_DB_USER", 0);
			//	param.put("UPDATE_DB_TIME", 0);
//				param.put("PICK_BOX_QTY", 0);
//				param.put("PICK_EA_QTY", 0);
//				param.put("PICK_STATUS", "");
				param.put("data", super.commonDao.insert("map101ukrvServiceImpl.insertLogMaster", param));
			//	param.put("data", super.commonDao.update("map101ukrvServiceImpl.insertLogForm", param));
			}
		}

		//4.지급결의확정저장 Stored Procedure 실행
		Map<String, Object> spParam = new HashMap<String, Object>();

		spParam.put("KeyValue", keyValue);
		spParam.put("LangCode", user.getLanguage());

		super.commonDao.queryForObject("spBuyConfirm", spParam);
		
		String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
		
//		if(!ObjUtils.isEmpty(errorDesc)){
//			String[] messsage = errorDesc.split(";");
//		    throw new  UniDirectValidateException(this.getMessage(messsage[0], user));
//		} else {
//			
//		}
		
		if(!ObjUtils.isEmpty(errorDesc)){
			String[] messsage = errorDesc.split(";");
			String A = messsage[0];
			int messLength = messsage.length;
			
			if(messLength > 1){
				String B = messsage[1];
				throw new  UniDirectValidateException(this.getMessage(A, user)+" : " + B);
			}else{
				throw new  UniDirectValidateException(this.getMessage(A, user));
			}
		}else{
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
