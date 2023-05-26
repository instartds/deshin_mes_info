package foren.unilite.modules.matrl.mms;

import java.io.IOException;
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

import com.google.gson.Gson;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.extjs.UniliteExtjsUtils;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.service.impl.TlabBadgeService;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.com.fileman.FileMnagerService;
import foren.unilite.modules.human.hbs.Hbs020ukrModel;

@Service("mms131ukrvService")
public class Mms131ukrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	/**
	 *
	 * 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return super.commonDao.list("mms131ukrvServiceImpl.selectList", param);
	}

	/**
	 * 저장
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "matrl")
	public Map<String, Object> mms131ukrvSave(Map param, LoginVO user) throws Exception {
		String keyValue = getLogKey();
		
		param.put("KEY_VALUE", keyValue);
		param.put("COMP_CODE", user.getCompCode());
		param.put("DIV_CODE", user.getDivCode());
		param.put("USER_ID", user.getUserID());
		
		Map<String, Object> checkMap = (Map<String, Object>) super.commonDao.select("mms131ukrvServiceImpl.selectChk1",param);
		if(ObjUtils.isEmpty(checkMap)){
			throw new UniDirectValidateException("납품번호 확인후 다시 시도 해주세요.");
		}
		Map<String, Object> checkMap2 = (Map<String, Object>) super.commonDao.select("mms131ukrvServiceImpl.selectChk2",param);
		if(ObjUtils.isNotEmpty(checkMap2)){
			throw new UniDirectValidateException("이미 접수등록된 납품번호("+param.get("BARCODE")+")입니다. 관리자에게 문의 해주세요.");
		}
		
		List<Map<String, Object>> selectChk3 = super.commonDao.list("mms131ukrvServiceImpl.selectChk3",param);
		if(ObjUtils.isNotEmpty(selectChk3)){
			for(Map chk3 : selectChk3){
				if(chk3.get("INSPEC_FLAG").equals("N")){
					throw new UniDirectValidateException("검사대상이 아닙니다. 관리자에게 문의 해주세요.");
				}
			}
		}
		
		super.commonDao.insert("mms131ukrvServiceImpl.mms131ukrvSave", param);
		
		//4.접수등록 Stored Procedure 실행
		Map<String, Object> spParam = new HashMap<String, Object>();

		spParam.put("KEY_VALUE", keyValue);

		super.commonDao.queryForObject("mms131ukrvServiceImpl.spUspMatrlMms110ukr", spParam);

		String errorDesc = ObjUtils.getSafeString(spParam.get("ERROR_DESC"));

		//접수등록 마스터 출하지시 번호 update
		Map<String, Object> dataMaster = new HashMap<String, Object>();

		dataMaster.put("V_CUSTOM_CODE", checkMap.get("CUSTOM_CODE"));
		dataMaster.put("V_CUSTOM_NAME", checkMap.get("CUSTOM_NAME"));
		dataMaster.put("V_CNT", checkMap.get("CNT"));
		dataMaster.put("BARCODE", param.get("BARCODE"));
		
		if(!ObjUtils.isEmpty(errorDesc)){
			dataMaster.put("RECEIPT_NUM", "");
//					String[] messsage = errorDesc.split(";");
//					throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
			throw new UniDirectValidateException(this.getMessage(errorDesc, user).substring(this.getMessage(errorDesc, user).indexOf("||")+2));

		   // throw new  UniDirectValidateException(this.getMessage(messsage[0], user));
		} else {

			//마스터에 SET
			dataMaster.put("RECEIPT_NUM", ObjUtils.getSafeString(spParam.get("RECEIPT_NUM")));
			
		}

		return dataMaster;
	}
	

}
