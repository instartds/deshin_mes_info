package foren.unilite.modules.z_wm;

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
import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.service.impl.TlabCodeService;
import foren.unilite.com.tags.ComboItemModel;
import foren.unilite.com.validator.UniDirectValidateException;


@Service("s_pmp110ukrv_wmService")
@SuppressWarnings({"rawtypes", "unchecked"})
public class S_Pmp110ukrv_wmServiceImpl extends TlabAbstractServiceImpl  {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());



	/**
	 * 20201020 추가: 공정정보 포함한 작업장 콤보데이터 가져오는 로직
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<ComboItemModel> getWorkShopList(Map param) throws Exception {
		return super.commonDao.list("s_pmp110ukrv_wmServiceImpl.getWorkShopList", param);
	}

	/**
	 * 작업지시등록 데이터 조회
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map> selectList(Map param, LoginVO user) throws Exception {
		return super.commonDao.list("s_pmp110ukrv_wmServiceImpl.selectList", param);
	}




	/**
	 * 작업지시등록 저장
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "prodt")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> regiWorkOrder(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		if(paramList != null) {
			List<Map> dataList = new ArrayList<Map>();
			for(Map dataListMap: paramList) {
				dataList = (List<Map>) dataListMap.get("data");
				for(Map param: dataList) {
					//1.로그테이블에서 사용할 KeyValue 생성
					String keyValue = getLogKey();
					param.put("KEY_VALUE", keyValue);
					if(ObjUtils.isEmpty(param.get("WKORD_NUM"))) {
						param.put("OPR_FLAG", "N");
					} else {
						param.put("OPR_FLAG", "D");
					}
					//2.작업지시등록 로그테이블에 KEY_VALUE, OPR_FLAG 업데이트
					param.put("data", super.commonDao.update("s_pmp110ukrv_wmServiceImpl.insertLogDetail", param));

					//3.작업지시등록 SP 호출 (한 건씩 sp 실행)
					Map<String, Object> spParam = new HashMap<String, Object>();
					spParam.put("KeyValue", keyValue);
					super.commonDao.queryForObject("s_pmp110ukrv_wmServiceImpl.USP_PRODT_Pmp100ukr_WM", spParam);
					String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));

					if(!ObjUtils.isEmpty(errorDesc)){
						throw new UniDirectValidateException(this.getMessage(errorDesc, user));
					}
				}
			}
		}
		paramList.add(0, paramMaster);
		return paramList;
	}

	/**
	 * 작업지시등록 등록 (insert)
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")
	public Integer insertLogTable(List<Map> paramList,  LoginVO user) throws Exception {
		return 0;
	}
}