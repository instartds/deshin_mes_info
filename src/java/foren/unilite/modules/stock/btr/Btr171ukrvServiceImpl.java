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

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;



@Service("btr171ukrvService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class Btr171ukrvServiceImpl extends TlabAbstractServiceImpl {
//	private static final Map  = null;
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	/**
	 * 대체 입/출고 Main
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return super.commonDao.list("btr171ukrvService.selectList", param);
	}


	/**
	 * 품목대체번호 팝업
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectDetailList(Map param) throws Exception {
		return super.commonDao.list("btr171ukrvService.selectDetailList", param);
	}

	/**
	 * 참조 팝업
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectOrderNumMasterList(Map param) throws Exception {
		return super.commonDao.list("btr171ukrvService.selectOrderNumMaster", param);
	}


	/**
	 * biv100t 참조 팝업
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectBiv100tMasterRefer(Map param) throws Exception {
		return super.commonDao.list("btr171ukrvService.selectBiv100tMasterRefer", param);
	}


	/**
	 * 업데이트
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")	  // UPDATE
	public Integer updateDetail(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param :paramList ) {
			super.commonDao.update("btr171ukrvService.updateDetail", param);
		}
		return 0;
	}

	/**
	 * 입력
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "base", needsModificatinAuth = true)		// INSERT
	public Integer insertDetail(List<Map> paramList,  LoginVO user) throws Exception {
		for(Map param :paramList ) {
			super.commonDao.update("btr171ukrvService.insertDetail", param);
		}
		return 0;
	}


	/**
	 * 삭제
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "base", needsModificatinAuth = true)		// DELETE
	public Integer deleteDetail(List<Map> paramList,  LoginVO user) throws Exception {
		for(Map param :paramList ) {
			super.commonDao.update("btr171ukrvService.deleteDetail", param);
		}
		return 0;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
		Map<String, Object> dataMaster	= (Map<String, Object>) paramMaster.get("data");

		List<Map> dataList = new ArrayList<Map>();
		Map selectMap = new HashMap();
		String errMsg = "";
		for(Map paramData: paramList) {
			dataList = (List<Map>) paramData.get("data");
			String oprFlag = "N";
			if(paramData.get("method").equals("insertDetail")) oprFlag="N";
			if(paramData.get("method").equals("updateDetail")) oprFlag="U";
			if(paramData.get("method").equals("deleteDetail")) oprFlag="D";

			for(Map param:  dataList) {
				if(param.get("WORK_TYPE").equals("1")){	 //입고행만 저장..
					param.put("CHECK_FLAG", oprFlag);
					param.put("USER_ID", user.getUserID());
					selectMap	= (Map) super.commonDao.select("btr171ukrvService.updateDetail", param);
					errMsg		= "ERROR CODE: " + ObjUtils.getSafeString(selectMap.get("ERROR_CODE")) + "\n" + ObjUtils.getSafeString(selectMap.get("ERROR_DESC"));

					if(!ObjUtils.isEmpty(selectMap.get("ERROR_CODE"))){
						throw new  UniDirectValidateException(errMsg);

					} else {
						dataMaster.put("INOUT_NUM", selectMap.get("INOUT_NUM").toString());
					}
				}
			}
		}

		paramList.add(0, paramMaster);
		return  paramList;
	}

	public void excelValidate(String jobID, Map param) {
	    logger.debug("validate: {}", jobID);
		super.commonDao.update("btr171ukrvService.excelValidate", param);
	}

	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectExcelist(Map param) {
	    return super.commonDao.list("btr171ukrvService.selectExcelist", param);
	}

}
