package foren.unilite.modules.z_wm;

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
import foren.unilite.com.code.CodeInfo;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.service.impl.TlabCodeService;
import foren.unilite.com.validator.UniDirectValidateException;


@Service("s_mpp100ukrv_wmService")
@SuppressWarnings({"rawtypes", "unchecked"})
public class S_Mpp100ukrv_wmServiceImpl extends TlabAbstractServiceImpl  {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());


	/**
	 * 분해등록 (WM) 조회
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sales")
	public List<Map> selectList(Map param, LoginVO user) throws Exception {
		return super.commonDao.list("s_mpp100ukrv_wmServiceImpl.selectList", param);
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sales")
	public List<Map> selectList2(Map param, LoginVO user) throws Exception {
		return super.commonDao.list("s_mpp100ukrv_wmServiceImpl.selectList2", param);
	}

	/**
	 * 품목단가 조회
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sales")
	public Map getItemPrice(Map param, LoginVO user) throws Exception {
		return (Map) super.commonDao.select("s_mpp100ukrv_wmServiceImpl.getItemPrice", param);
	}





	/**
	 * 분해등록 (WM) 상태값 저장 (S_MPO020T_WM) - master
	 * @param params
	 * @param user
	 * @param dataMaster
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
//		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");

		if(paramList != null) {
			List<Map> updateDetail = null;

			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("updateDetail")) {
					updateDetail = (List<Map>)dataListMap.get("data");
				}
			}
			if(updateDetail != null) this.updateDetail(updateDetail, user);
		}
		paramList.add(0, paramMaster);
		return  paramList;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")
	public Integer updateDetail(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param :paramList ) {
			super.commonDao.update("s_mpp100ukrv_wmServiceImpl.updateDetail", param);
		}
		return 0;
	} 



	/**
	 * 분해등록 (WM) 분해부품 정보 저장 - detail
	 * @param params
	 * @param user
	 * @param dataMaster
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll2(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");

		if(paramList != null) {
			List<Map> insertDetail2 = null;
			List<Map> updateDetail2 = null;
			List<Map> deleteDetail2 = null;

			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("insertDetail2")) {
					insertDetail2 = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("updateDetail2")) {
					updateDetail2 = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("deleteDetail2")) {
					deleteDetail2 = (List<Map>)dataListMap.get("data");
				}
			}
			if(insertDetail2 != null) this.insertDetail2(insertDetail2, user, dataMaster);
			if(updateDetail2 != null) this.updateDetail2(updateDetail2, user, dataMaster);
			if(deleteDetail2 != null) this.deleteDetail2(deleteDetail2, user, dataMaster);
		}
		paramList.add(0, paramMaster);
		return  paramList;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")
	public Integer insertDetail2(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {
		try {
			String autoNumFlag = "";
			for(Map param : paramList) {
				if (ObjUtils.isNotEmpty(param.get("RECEIPT_NUM"))) {
					autoNumFlag = (String) param.get("RECEIPT_NUM");
				}
			}
			if (ObjUtils.isEmpty(autoNumFlag)) {
				Map receiptNumMap = new HashMap();
				receiptNumMap = (Map<String, Object>) super.commonDao.select("s_mpp100ukrv_wmServiceImpl.getReceiptNum", paramMaster);
				autoNumFlag = (String) receiptNumMap.get("RECEIPT_NUM");
			}
			for(Map param : paramList) {
				param.put("RECEIPT_NUM", autoNumFlag);
				super.commonDao.insert("s_mpp100ukrv_wmServiceImpl.insertDetail2", param);
			}
		}catch(Exception e){
			throw new UniDirectValidateException(this.getMessage("8114", user));
		}
		return 0;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")
	public Integer updateDetail2(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {
		Map receiptNumMap	= new HashMap();
		String err_desc		= "";

		for(Map param :paramList ) {
			receiptNumMap	= (Map<String, Object>) super.commonDao.select("s_mpp100ukrv_wmServiceImpl.getInspectionYn", paramMaster);
			err_desc		= (String) receiptNumMap.get("RECEIPT_NUM");
			if(ObjUtils.isNotEmpty(err_desc)) {
				throw new UniDirectValidateException(this.getMessage(err_desc, user));
			}
			super.commonDao.update("s_mpp100ukrv_wmServiceImpl.updateDetail2", param);
		}
		return 0;
	} 

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")
	public Integer deleteDetail2(List<Map> paramList,  LoginVO user, Map paramMaster) throws Exception {
		Map receiptNumMap	= new HashMap();
		String err_desc		= "";

		for(Map param :paramList ) {
			try {
				receiptNumMap	= (Map<String, Object>) super.commonDao.select("s_mpp100ukrv_wmServiceImpl.getInspectionYn", paramMaster);
				err_desc		= (String) receiptNumMap.get("RECEIPT_NUM");
				if(ObjUtils.isNotEmpty(err_desc)) {
					throw new UniDirectValidateException(this.getMessage(err_desc, user));
				}
				super.commonDao.delete("s_mpp100ukrv_wmServiceImpl.deleteDetail2", param);
			} catch(Exception e) {
				throw new  UniDirectValidateException(this.getMessage("547",user));
			}
		}
		return 0;
	}
}