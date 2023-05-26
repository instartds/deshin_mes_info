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
@Service("equ211skrvService")
public class Equ211skrvServiceImpl extends TlabAbstractServiceImpl {

	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	/**
	 * TIA100T form search
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_LOAD, group = "equip")
	public Object selectListForForm(Map param) throws Exception {
		return  super.commonDao.select("equ211skrvServiceImpl.selectListForForm", param);
	}
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "equip")
	public List<Map<String, Object>>  selectOrderNumMasterList(Map param) throws Exception {
		List<Map<String, Object>> selectList =  super.commonDao.list("equ211skrvServiceImpl.selectOrderNumMasterList", param);
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
		List<Map<String, Object>> selectList =  super.commonDao.list("equ211skrvServiceImpl.selectList", param);
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
		List<Map<String, Object>> selectList =  super.commonDao.list("equ211skrvServiceImpl.fnOrderDetail", param);
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
		List<Map<String, Object>> selectList =  super.commonDao.list("equ211skrvServiceImpl.fnOfferDetail", param);
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
        return super.commonDao.list("equ211skrvServiceImpl.selectExcelUploadSheet1", param);
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
        return  super.commonDao.select("equ211skrvServiceImpl.fnGetCompany", param);
    }

 	@ExtDirectMethod(group = "equip", value = ExtDirectMethodType.STORE_READ)
    public Object fnGetPrice(Map param, LoginVO loginVO) throws Exception {
        return  super.commonDao.select("equ211skrvServiceImpl.fnGetPrice", param);
    }

 	@ExtDirectMethod(group = "equip", value = ExtDirectMethodType.STORE_READ)
    public Object fnGetInspec(Map param, LoginVO loginVO) throws Exception {
        return  super.commonDao.select("equ211skrvServiceImpl.fnGetInspec", param);
    }

 	@ExtDirectMethod(group = "equip", value = ExtDirectMethodType.STORE_READ)
    public Object fnGetAgreePrsn(Map param, LoginVO loginVO) throws Exception {
        return  super.commonDao.select("equ211skrvServiceImpl.fnGetAgreePrsn", param);
    }

// 	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "trade")
//	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
//	public List<Map> saveAll(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
//		logger.debug("[saveAll] paramDetail:" + paramList);
//
//		//1.로그테이블에서 사용할 KeyValue 생성
//		String keyValue = getLogKey();
//
//		//2.출하지시 로그테이블에 KEY_VALUE, OPR_FLAG 업데이트
//		List<Map> dataList = new ArrayList<Map>();
//		List<List<Map>> resultList = new ArrayList<List<Map>>();
//
//		for(Map paramData: paramList) {
//
//			dataList = (List<Map>) paramData.get("data");
//			String oprFlag = "N";
////				if(paramData.get("method").equals("insertDetail"))	oprFlag="N";
//			if(paramData.get("method").equals("updateList"))	oprFlag="U";
////				if(paramData.get("method").equals("deleteDetail"))	oprFlag="D";
//
//			for(Map<String, Object> param:  dataList) {
//				param.put("KEY_VALUE", keyValue);
//				param.put("OPR_FLAG", oprFlag);
//				param.put("data", super.commonDao.insert("equ211skrvServiceImpl.insertLogMaster", param));
//			}
//		}
//
//		//4.출하지시저장 Stored Procedure 실행
//		Map<String, Object> spParam = new HashMap<String, Object>();
//
//		spParam.put("KEY_VALUE", keyValue);
//		spParam.put("LANG_CODE", user.getLanguage());
//		spParam.put("ERROR_DESC","");
//
//		super.commonDao.queryForObject("spMap300ukrv", spParam);
//
//		String errorDesc = ObjUtils.getSafeString(spParam.get("ERROR_DESC"));
//
//		if(!ObjUtils.isEmpty(errorDesc)){
//			String[] messsage = errorDesc.split(";");
//		    throw new  UniDirectValidateException(this.getMessage(messsage[0], user));
//		} else {
//		}
//
//		paramList.add(0, paramMaster);
//
//		return  paramList;
//	}
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


				param.put("data", super.commonDao.insert("equ211skrvServiceImpl.insertLogDetail", param));

			}
		}

		//4.출하지시저장 Stored Procedure 실행
		Map<String, Object> spParam = new HashMap<String, Object>();

		spParam.put("KeyValue", keyValue);
		spParam.put("LangCode", user.getLanguage());

	    super.commonDao.queryForObject("equ211skrvServiceImpl.spequ211skrv", spParam);

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

	/**
	 * 수주 Detail 입력
	 */
	@ExtDirectMethod(group = "equip", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> insertDetail(List<Map> params, LoginVO user) throws Exception {
		for(Map param: params)		{
			super.commonDao.insert("mms510ukrvServiceImpl.insertDetail", param);
		}

		return params;
	}

	/**
	 * 수주 Detail 수정
	 */
	@SuppressWarnings("rawtypes")
	@ExtDirectMethod(group = "equip", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> updateDetail(List<Map> params, LoginVO user) throws Exception {
		for(Map param: params)		{
			super.commonDao.insert("mms510ukrvServiceImpl.updateDetail", param);
		}
		return params;
	}

	/**
	 * 수주 Detail 삭제
	 */
	@ExtDirectMethod(group = "equip", value = ExtDirectMethodType.STORE_MODIFY)
	public void deleteDetail(List<Map> params, LoginVO user) throws Exception {
		for(Map<String, Object> param : params)	{
			super.commonDao.delete("mms510ukrvServiceImpl.deleteDetail", param);
		}
		super.commonDao.delete("mms510ukrvServiceImpl.checkDeleteAllDetail", params.get(0));
	}

	@ExtDirectMethod( group = "equip", value = ExtDirectMethodType.FORM_POST )
    public ExtDirectFormPostResult uploadPhoto( @RequestParam( "fileUpload" ) MultipartFile file, Equ200ukvrModel param, LoginVO login ) throws IOException, Exception {

        if (file != null && !file.isEmpty()) {
            logger.debug("File1 Name : " + file.getName());
            logger.debug("File1 Bytes: " + file.getSize());
            String fileExtension = FileUtil.getExtension(file.getOriginalFilename()).toLowerCase();

            if (!"jpg".equals(fileExtension) && !"png".equals(fileExtension) && !"bmp".equals(fileExtension)) {
                throw new UniDirectValidateException(new String("jpg, png, bmp 파일로 올려주세요."));
            }

            String path = ConfigUtil.getUploadBasePath(ConfigUtil.getString("common.upload.equipmentPhoto", "/EquipmentPhoto/"));
            logger.debug("################### fileUpload path : "+path);
            if (file.getSize() > 0) {
            	File dir = new File(path);
            	if(!dir.exists()) {
            		dir.mkdir();
            	}
            	String fileName =   login.getCompCode()+param.getDIV_CODE()+param.getEQU_CODE() + '.' + fileExtension;

                File tmpFile = new File(path + "/"+fileName);
                file.transferTo(tmpFile);

                param.setFILE_NAME(fileName);
                param.setS_COMP_CODE(login.getCompCode());
                param.setS_USER_ID(login.getUserID());
                param.setFILE_TYPE(fileExtension);
                super.commonDao.update("equ211skrvServiceImpl.updatePhoto", param);
            }
        }
        ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(true);
        return extResult;

    }
}
