package foren.unilite.modules.sales.ssa;

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
import foren.framework.extjs.UniliteExtjsUtils;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.base.bdc.Bdc100ukrvService;
import foren.unilite.modules.com.fileman.FileMnagerService;
import foren.unilite.modules.sales.SalesCommonServiceImpl;

@Service("ssa400ukrvService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class Ssa400ukrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@Resource(name="salesCommonService")
	private SalesCommonServiceImpl SalesUtil;


	/**
	 *
	 * 매출정보 Detail 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectDetailList(Map param) throws Exception {
		return super.commonDao.list("ssa400ukrvServiceImpl.selectDetailList", param);
	}

	/**
	 * 마감 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public Object getGetClosingInfo(Map param) throws Exception {
		return super.commonDao.select("ssa400ukrvServiceImpl.getGetClosingInfo", param);
	}






	/**
	 * 매출정보 저장
	 * @param paramList	리스트의 create, update, destroy 오퍼레이션별 정보
	 * @param paramMaster 폼(마스터 정보)의 기본 정보
	 * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		//1.로그테이블에서 사용할 Key 생성
		String keyValue = getLogKey();
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		List<Map> insertDetail = null;
		List<Map> updateDetail = null;
		List<Map> deleteDetail = null;

		//2.매출마스터 / 디테일 로그테이블에 KEY_VALUE, OPR_FLAG 업데이트
		for(Map param: paramList) {
			if(param.get("method").equals("insertDetail")) {
				insertDetail = (List<Map>)param.get("data");
			} else if(param.get("method").equals("updateDetail")) {
				updateDetail = (List<Map>)param.get("data");
			} else if(param.get("method").equals("deleteDetail")) {
				deleteDetail = (List<Map>)param.get("data");
			}
		}
		if(insertDetail != null) this.insertDetail(insertDetail, user, dataMaster);
		if(updateDetail != null) this.updateDetail(updateDetail, user, dataMaster, keyValue);
		if(deleteDetail != null) this.deleteDetail(deleteDetail, user, dataMaster);

		//4.매출저장 Stored Procedure 실행
		Map<String, Object> spParam = new HashMap<String, Object>();

		spParam.put("KeyValue", keyValue);
		spParam.put("LangCode", user.getLanguage());

		super.commonDao.queryForObject("ssa400ukrvServiceImpl.spReceiving", spParam);

		String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));

		if(!ObjUtils.isEmpty(errorDesc)){
			throw new	UniDirectValidateException(this.getMessage(errorDesc, user));
		}

		//5.매출마스터 정보 + 매출디테일 정보 결과셋 리턴
		paramList.add(0, paramMaster);

		return  paramList;
	}


	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_MODIFY)
	public Integer insertDetail(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {
		return 0;
	}

	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_MODIFY)
	public Integer updateDetail(List<Map> paramList, LoginVO user, Map paramMaster, String keyValue) throws Exception {
		for(Map param: paramList)		{
			if(ObjUtils.isNotEmpty(param.get("SAVE_FLAG")) || "Y".equals(paramMaster.get("ENTRY_YN"))) {
				param.put("KEY_VALUE"	, keyValue);
				param.put("VAT_RATE"	, paramMaster.get("VAT_RATE"));
				if(ObjUtils.isEmpty(param.get("SAVE_FLAG")) && "Y".equals(paramMaster.get("ENTRY_YN"))) {
					param.put("SAVE_FLAG", "U");
				}
				super.commonDao.insert("ssa400ukrvServiceImpl.insertLogMaster", param);
				super.commonDao.insert("ssa400ukrvServiceImpl.insertLogDetail", param);
			}
		}
		return 0;
	}

	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_MODIFY)
	public void deleteDetail(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {
	}
}
