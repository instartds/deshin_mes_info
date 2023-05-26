package foren.unilite.modules.stock.btr;

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

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.utils.UniliteUtil;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.sales.scn.Scn100ukrvModel;

@Service("btr901ukrvService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class Btr901ukrvServiceImpl  extends TlabAbstractServiceImpl {

	/** 조회팝업 쿼리
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "stock")
	public List<Map<String, Object>> searchPopupList(Map param,LoginVO user) throws Exception {
		return super.commonDao.list("btr901ukrvServiceImpl.searchPopupList", param);
	}

	/** LOT별 재고수량 가져오기
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "stock")
	public List<Map<String, Object>> findLotStockQ(Map param,LoginVO user) throws Exception {
		return super.commonDao.list("btr901ukrvServiceImpl.findLotStockQ", param);
	}

	/** 재고수량 가져오기
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "stock")
	public List<Map<String, Object>> findStockQ(Map param,LoginVO user) throws Exception {
		return super.commonDao.list("btr901ukrvServiceImpl.findStockQ", param);
	}

	/** 자료생성 버튼 로직
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "stock")
	public List<Map<String, Object>> BtnCreateStock(Map param,LoginVO user) throws Exception {
		return super.commonDao.list("btr901ukrvServiceImpl.BtnCreateStock", param);
	}

	/** 데이터 조회
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "stock")
	public List<Map<String, Object>> selectList(Map param, LoginVO user) throws Exception {
		return super.commonDao.list("btr901ukrvServiceImpl.selectList", param);
	}



	/**데이터 저장로직
	 * @param params
	 * @param user
	 * @param dataMaster
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "stock")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		List<Map> dataList = new ArrayList<Map>();
		//1.로그테이블에서 사용할 Key 생성
		String keyValue = getLogKey();

		//2.저장할 masterData 생성 / 로그테이블에 INSERT
		Map<String, Object> mParam = new HashMap<String, Object>();
		mParam.put("COMP_CODE"			, user.getCompCode());
		mParam.put("KEY_VALUE"			, keyValue);
		mParam.put("OPR_FLAG"			, dataMaster.get("OPR_FLAG"));		//상태: jsp에서 설정(MN, MU, MD)
		mParam.put("DIV_CODE"			, dataMaster.get("DIV_CODE"));
		mParam.put("INOUT_NUM"			, dataMaster.get("INOUT_NUM"));
		mParam.put("INOUT_SEQ"			, 1);
		mParam.put("INOUT_TYPE"			, '2');
		mParam.put("INOUT_METH"			, "D");								//수불방법: 분해(B036)
		mParam.put("INOUT_TYPE_DETAIL"	, "D2");							//수불유형: (S006, S007, S008, M103, M104) - 헬스케어만??
		mParam.put("INOUT_CODE_TYPE"	, "2");								//수불처구분: 창고(B005)
		mParam.put("INOUT_CODE"			, dataMaster.get("WH_CODE"));
		mParam.put("WH_CODE"			, dataMaster.get("WH_CODE"));
		mParam.put("WH_CELL_CODE"		, dataMaster.get("WH_CELL_CODE"));	//20210405 추가
		mParam.put("INOUT_DATE"			, dataMaster.get("INOUT_DATE"));
		mParam.put("ITEM_CODE"			, dataMaster.get("ITEM_CODE"));
		mParam.put("ITEM_STATUS"		, dataMaster.get("optConTrol"));
		mParam.put("INOUT_Q"			, dataMaster.get("CHANGESTOCK_Q"));
		mParam.put("INOUT_P"			, 0);
		mParam.put("INOUT_I"			, 0);
		mParam.put("EXPENSE_I"			, 0);
		mParam.put("MONEY_UNIT"			, "KRW");
		mParam.put("INOUT_FOR_P"		, 0);
		mParam.put("INOUT_FOR_O"		, 0);
		mParam.put("EXCHG_RATE_O"		, 1);
		mParam.put("ORDER_TYPE"			, "1");								//수발주구분: 내수(M001)
		mParam.put("ORDER_NUM"			, "");
		mParam.put("ORDER_SEQ"			, 0);
		mParam.put("ACCOUNT_YNC"		, "N");
		mParam.put("CREATE_LOC"			, "4");								//생성경로: 재고(B031)
		mParam.put("ORDER_UNIT_Q"		, dataMaster.get("CHANGESTOCK_Q"));
		mParam.put("ORDER_UNIT_P"		, 0);
		mParam.put("ORDER_UNIT_FOR_P"	, 0);
		mParam.put("LOT_NO"				, dataMaster.get("LOT_NO"));
		mParam.put("S_USER_ID"			, user.getUserID());
		super.commonDao.insert("btr901ukrvServiceImpl.insertMLogTable", mParam);

		//3.저장할 detailData에 KEY_VALUE, OPR_FLAG 업데이트 / 로그테이블에 INSERT
		for(Map paramData: paramList) {
			dataList = (List<Map>) paramData.get("data");
			String oprFlag = "N";
			if(paramData.get("method").equals("insertDetail"))	oprFlag="N";
			if(paramData.get("method").equals("updateDetail"))	oprFlag="U";
			if(paramData.get("method").equals("deleteDetail"))	oprFlag="D";

			for(Map param: dataList) {
				param.put("KEY_VALUE"	, keyValue);
				param.put("ITEM_STATUS"	, dataMaster.get("optConTrol"));
				param.put("OPR_FLAG"	, oprFlag);
				super.commonDao.insert("btr901ukrvServiceImpl.insertDLogTable", param);
			}
		}
		//출고등록 Stored Procedure 실행
		Map<String, Object> spParam = new HashMap<String, Object>();

		spParam.put("KEY_VALUE"			, keyValue);
		spParam.put("COMP_CODE"			, user.getCompCode());
		spParam.put("PRODT_ITEM_CODE"	, dataMaster.get("ITEM_CODE"));
		spParam.put("USER_ID"			, user.getUserID());

		super.commonDao.queryForObject("btr901ukrvServiceImpl.spReceiving", spParam);

		String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));

		if(!ObjUtils.isEmpty(errorDesc)){
			dataMaster.put("INOUT_NUM", "");
			throw new UniDirectValidateException(this.getMessage(errorDesc, user));
		} else {
			dataMaster.put("INOUT_NUM", ObjUtils.getSafeString(spParam.get("INOUT_NUM")));
		}

		paramList.add(0, paramMaster);
		return  paramList;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "stock")
	public Integer insertDetail(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {		
		return 0;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "stock")
	public Integer updateDetail(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {
		return 0;
	} 
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "stock")
	public Integer deleteDetail(List<Map> paramList,  LoginVO user, Map paramMaster) throws Exception {
		return 0;
	}
}