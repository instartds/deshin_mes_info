package foren.unilite.modules.z_tw;

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
import foren.unilite.modules.crm.cmd.Cmd100ukrvModel;
import foren.unilite.modules.sales.SalesCommonServiceImpl;

@Service("s_srq100ukrv_twService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class S_Srq100ukrv_twServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	
	
	@Resource(name="salesCommonService")
	private SalesCommonServiceImpl SalesUtil;

	/**
	 * 출하지시정보검색 조회(Master)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectOrderNumMasterList(Map param) throws Exception {
		return super.commonDao.list("s_srq100ukrv_twServiceImpl.selectOrderNumMaster", param);
	}


	/**
	 * 참조 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectReferList(Map param) throws Exception {
		return super.commonDao.list("s_srq100ukrv_twServiceImpl.selectReferList", param);
	}


	/**
	 * 출하지시정보  조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return super.commonDao.list("s_srq100ukrv_twServiceImpl.selectList", param);
	}


	/**
	 * 출하지시정보검색 조회(Detail)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectOrderNumDetailList(Map param) throws Exception {
		return super.commonDao.list("s_srq100ukrv_twServiceImpl.selectOrderNumDetail", param);
	}


	/**
	 * 출하지시이력 참조 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectRefList(Map param) throws Exception {
		return super.commonDao.list("s_srq100ukrv_twServiceImpl.selectRefList", param);
	}



	/**
	 * 출하지시정보 저장
	 * @param paramList	리스트의 create, update, destroy 오퍼레이션별 정보
	 * @param paramMaster 폼(마스터 정보)의 기본 정보
	 * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
		logger.debug("[saveAll] paramDetail:" + paramList);
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");

		//1.로그테이블에서 사용할 KeyValue 생성
		String keyValue = getLogKey();

		//2.출하지시 로그테이블에 KEY_VALUE, OPR_FLAG 업데이트
		List<Map> dataList = new ArrayList<Map>();

		for(Map paramData: paramList) {
			dataList				= (List<Map>) paramData.get("data");
			String oprFlag			= "N";
			Map newIssueReqNum		= new HashMap();
			if(paramData.get("method").equals("insertDetail"))	oprFlag="N";
			if(paramData.get("method").equals("updateDetail"))	oprFlag="U";
			if(paramData.get("method").equals("deleteDetail"))	oprFlag="D";

			//출하지시정보 등록 전, 재고이동요청정보 생성을 위해 채번먼저 진행
			if (ObjUtils.isEmpty(dataMaster.get("ISSUE_REQ_NUM"))) {
				newIssueReqNum = (Map<String, Object>) super.commonDao.select("s_srq100ukrv_twServiceImpl.getIssueReqNum", dataMaster);
			}
			for(Map param: dataList) {
				param.put("KEY_VALUE"			, keyValue);
				param.put("OPR_FLAG"			, oprFlag);
				param.put("PICK_BOX_QTY"		, 0);
				param.put("PICK_EA_QTY"			, 0);
				param.put("PICK_STATUS"			, "");
				if (ObjUtils.isEmpty(dataMaster.get("ISSUE_REQ_NUM"))) {
					param.put("ISSUE_REQ_NUM"	, newIssueReqNum.get("ISSUE_REQ_NUM"));
				}
				param.put("data"				, super.commonDao.insert("s_srq100ukrv_twServiceImpl.insertLogDetail", param));
				//출하지시정보 등록 전, 재고이동요청정보 생성
				super.commonDao.insert("s_srq100ukrv_twServiceImpl.insertStockMove", param);
			}
		}

		//4.출하지시정보 등록 전, 재고이동요청정보 생성
		Map<String, Object> tempParam = new HashMap<String, Object>();
		tempParam.put("KeyValue", keyValue);

		super.commonDao.queryForObject("s_srq100ukrv_twServiceImpl.spSalesShipment", tempParam);
		String stockMoveError = ObjUtils.getSafeString(tempParam.get("ErrorDesc"));

		if(!stockMoveError.isEmpty()){
			String[] messsage = stockMoveError.split(";");
			throw new  UniDirectValidateException(this.getMessage(messsage[0], user)+ (messsage.length>1? messsage[1]:""));
		}

		//4.출하지시저장 Stored Procedure 실행
		Map<String, Object> spParam = new HashMap<String, Object>();
		spParam.put("KeyValue", keyValue);
		spParam.put("LangCode", user.getLanguage());

		super.commonDao.queryForObject("s_srq100ukrv_twServiceImpl.spSalesShipment1", spParam); //SERVER START ERROR : spSalesShipment -> spSalesShipment1 
		String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
		//출하지시 마스터 출하지시 번호 update

		if(!errorDesc.isEmpty()){
			dataMaster.put("ISSUE_REQ_NUM", "");
			String[] messsage = errorDesc.split(";");
			throw new  UniDirectValidateException(this.getMessage(messsage[0], user)+ (messsage.length>1?messsage[1]:""));
		} else {
			dataMaster.put("ISSUE_REQ_NUM", ObjUtils.getSafeString(spParam.get("IssueReqNum")));
		}
		paramList.add(0, paramMaster);
		return paramList;
	}

	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> insertDetail(List<Map> params, LoginVO user) throws Exception {
		return null;
	}

	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> updateDetail(List<Map> params, LoginVO user) throws Exception {
		return null;
	}

	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> deleteDetail(List<Map> params, LoginVO user) throws Exception {
		return null;
	}
}