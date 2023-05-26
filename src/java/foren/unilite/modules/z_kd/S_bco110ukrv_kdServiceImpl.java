package foren.unilite.modules.z_kd;

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
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.service.impl.TlabMenuService;
import foren.unilite.com.validator.UniDirectValidateException;


@Service("s_bco110ukrv_kdService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class S_bco110ukrv_kdServiceImpl extends TlabAbstractServiceImpl {
	private final Logger	logger	= LoggerFactory.getLogger(this.getClass());

	@Resource(name = "tlabMenuService")
	 TlabMenuService tlabMenuService;


	/** 입력데이타형태입력 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_READ)  /* 조회 */
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return super.commonDao.list("s_bco110ukrv_kdService.selectList", param);
	}

	/** 검색팝업창 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_READ)  /* 검색팝업창 조회 */
	public List<Map<String, Object>> selectReqNumList(Map param) throws Exception {
		return super.commonDao.list("s_bco110ukrv_kdService.selectReqNumList", param);
	}

	/** 품목복사 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_READ)  /* 품목복사 조회 */
	public List<Map<String, Object>> selectPreSeqList(Map param) throws Exception {
		return super.commonDao.list("s_bco110ukrv_kdService.selectPreSeqSelect", param);
	}


	/** 저장
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
		if(paramList != null)  {
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;

			for(Map dataListMap: paramList) {
				logger.debug("[dataListMap]" + dataListMap);
				if(dataListMap.get("method").equals("updateDetail")) {
					updateList = (List<Map>)dataListMap.get("data");
				}
			}
			if(updateList != null) this.updateDetail(updateList, user);
		}
		paramList.add(0, paramMaster);
		return  paramList;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")	  // UPDATE
	public Integer updateDetail(List<Map> paramList, LoginVO user) throws Exception {
		Map<String, Object> Params = new HashMap<String, Object>();
		int chk = 0 ;
		for(Map param :paramList ) {
			logger.debug("[[param]]" + param );
			Params.put("S_COMP_CODE", param.get("COMP_CODE") );
			Params.put("DIV_CODE", param.get("DIV_CODE") );
			if(param.get("QUERY_TYPE").equals("2")){
				Params.put("DIV_CODE", '*' );
			}
			Params.put("TYPE", param.get("TYPE") );
			Params.put("ITEM_CODE", param.get("ITEM_CODE") );
			Params.put("CUSTOM_CODE", param.get("CUSTOM_CODE") );
			Params.put("MONEY_UNIT", param.get("MONEY_UNIT") );
			Params.put("ORDER_UNIT", param.get("ORDER_UNIT") );
			Params.put("APLY_START_DATE", param.get("APLY_START_DATE") );
			//20191227 RENEWAL_YN = "Y"일 때만 bpr400t 체크로직 수행하도록 if 조건 추가
			if(param.get("RENEWAL_YN").equals("Y")) {
				chk = (int) super.commonDao.select("s_bco110ukrv_kdService.selectBpr400t", Params);
				if (chk > 0){
					throw new  UniDirectValidateException("품목" + param.get("ITEM_CODE") + "의 단가가 이미 적용돼 있습니다.");//데이터 존재 하면 저장 취소
				}
			}
			if(param.get("CONFIRM_YN").equals("Y")) {
				logger.debug("[[1]]");
				super.commonDao.update("s_bco110ukrv_kdService.updateDetail1", param);
				super.commonDao.update("s_bco110ukrv_kdService.updateDetail2", param);
				super.commonDao.update("s_bco110ukrv_kdService.insertDetail", param);
			} else if(param.get("CONFIRM_YN").equals("N") && param.get("RENEWAL_YN").equals("N")) {
				//확정, 갱신 둘다 n일 경우는 아무것도 처리하지 않음
				continue;
			} else {
				logger.debug("[[3]]");
				super.commonDao.update("s_bco110ukrv_kdService.updateDetail1", param);
				super.commonDao.update("s_bco110ukrv_kdService.updateDetail2", param);
			}
		}
		return 0;
	}
}