package foren.unilite.modules.accnt.atx;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.validation.BindingResult;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.model.LoginVO;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("atx540ukrService")
public class Atx540ukrServiceImpl extends TlabAbstractServiceImpl {

	/**
	 * 사업장현황명세서 - FREE FORM DATA
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_LOAD, group = "accnt")
	public Object selectFormData(Map param) throws Exception {	
		
		return super.commonDao.select("atx540ukrServiceImpl.selectFormData", param);
	}

	/**
	 * 사업장현황명세서 - 공통코드에서 예정/확정 구분 쿼리
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectSubList(Map param) throws Exception {
		
		return super.commonDao.list("atx540ukrServiceImpl.selectSubList", param);
	}
	
	/**저장**/
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_POST, group = "accnt")
	public ExtDirectFormPostResult saveFormData(Atx540ukrModel dataMaster, LoginVO user, BindingResult result) throws Exception {

		dataMaster.setS_USER_ID(user.getUserID());
		dataMaster.setS_COMP_CODE(user.getCompCode());
		
		if(dataMaster.getSAVE_FLAG().equals("N")){
			super.commonDao.update("atx540ukrServiceImpl.insert", dataMaster);
		}else if(dataMaster.getSAVE_FLAG().equals("U")){
			super.commonDao.update("atx540ukrServiceImpl.update", dataMaster);
		}else if(dataMaster.getSAVE_FLAG().equals("D")){
			super.commonDao.update("atx540ukrServiceImpl.delete", dataMaster);
		}
		ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);

		return extResult;
	}
	
}
