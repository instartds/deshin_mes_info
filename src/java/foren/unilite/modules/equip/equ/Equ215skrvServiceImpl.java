package foren.unilite.modules.equip.equ;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import oracle.sql.CharacterSet;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.model.LoginVO;
import foren.framework.utils.ConfigUtil;
import foren.framework.utils.FileUtil;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
@Service("equ215skrvService")
public class Equ215skrvServiceImpl extends TlabAbstractServiceImpl {

	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	/**
	 * TIA100T form search
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_LOAD, group = "equip")
	public Object selectListForForm(Map param) throws Exception {
		return  super.commonDao.select("equ215skrvServiceImpl.selectListForForm", param);
	}
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "equip")
	public List<Map<String, Object>>  selectOrderNumMasterList(Map param) throws Exception {
		List<Map<String, Object>> selectList =  super.commonDao.list("equ215skrvServiceImpl.selectOrderNumMasterList", param);
		return  selectList;
	}
	/**
	 * TIA110T detail grid search
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "equip")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {
		List<Map<String, Object>> selectList =  super.commonDao.list("equ215skrvServiceImpl.selectList", param);
		return  selectList;
	}

	/**
	 * ref search
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "equip")
	public List<Map<String, Object>>  fnOrderDetail(Map param) throws Exception {
		List<Map<String, Object>> selectList =  super.commonDao.list("equ215skrvServiceImpl.fnOrderDetail", param);
		return  selectList;
	}
	/**
	 * otherRef search
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "equip")
	public List<Map<String, Object>>  fnOfferDetail(Map param) throws Exception {
		List<Map<String, Object>> selectList =  super.commonDao.list("equ215skrvServiceImpl.fnOfferDetail", param);
		return  selectList;
	}
	/**
	 * excel Validate
	 * @param jobID
	 * @param param
	 */
	 public void excelValidate(String jobID, Map param) {
		    logger.debug("validate: {}", jobID);
			//super.commonDao.update("afb100ukrServiceImpl.excelValidate", param);
	}


 	/**
 	 * excel search
 	 * @param param
 	 * @return
 	 * @throws Exception
 	 */
 	@ExtDirectMethod(group = "equip", value = ExtDirectMethodType.STORE_READ)
    public List<Map<String, Object>> selectExcelUploadSheet1(Map param) throws Exception {
        return super.commonDao.list("equ215skrvServiceImpl.selectExcelUploadSheet1", param);
    }
 	/**
 	 * 용      도  :  자사코드 가져오기
 	 * 本公司代码导入
 	 * @param param
 	 * @return
 	 * @throws Exception
 	 */
 	@ExtDirectMethod(group = "equip", value = ExtDirectMethodType.STORE_READ)
    public Object fnGetCompany(Map param, LoginVO loginVO) throws Exception {
 		param.put("MAIN_CODE", "T000");
        return  super.commonDao.select("equ215skrvServiceImpl.fnGetCompany", param);
    }

 	@ExtDirectMethod(group = "equip", value = ExtDirectMethodType.STORE_READ)
    public Object fnGetPrice(Map param, LoginVO loginVO) throws Exception {
        return  super.commonDao.select("equ215skrvServiceImpl.fnGetPrice", param);
    }

 	@ExtDirectMethod(group = "equip", value = ExtDirectMethodType.STORE_READ)
    public Object fnGetInspec(Map param, LoginVO loginVO) throws Exception {
        return  super.commonDao.select("equ215skrvServiceImpl.fnGetInspec", param);
    }

 	@ExtDirectMethod(group = "equip", value = ExtDirectMethodType.STORE_READ)
    public Object fnGetAgreePrsn(Map param, LoginVO loginVO) throws Exception {
        return  super.commonDao.select("equ215skrvServiceImpl.fnGetAgreePrsn", param);
    }

 	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "equip")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
		logger.debug("[saveAll] paramDetail:" + paramList);

		//1.로그테이블에서 사용할 KeyValue 생성
		String keyValue = getLogKey();
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


				param.put("data", super.commonDao.insert("equ215skrvServiceImpl.insertLogDetail", param));

			}
		}

		//4.출하지시저장 Stored Procedure 실행
		Map<String, Object> spParam = new HashMap<String, Object>();

		spParam.put("KeyValue", keyValue);
		spParam.put("LangCode", user.getLanguage());

	    super.commonDao.queryForObject("equ215skrvServiceImpl.spequ211skrv", spParam);

		String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));

		//출하지시 마스터 출하지시 번호 update
//		for(Map param : paramList )	{
		if(!ObjUtils.isEmpty(errorDesc)){

			String[] messsage = errorDesc.split(";");
		    throw new  UniDirectValidateException(this.getMessage(messsage[0], user));
		}
		paramList.add(0, paramMaster);

		return  paramList;
	}

}
