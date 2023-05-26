package foren.unilite.modules.accnt.atx;

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
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.extjs.UniliteExtjsUtils;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.base.bdc.Bdc100ukrvService;
import foren.unilite.modules.com.fileman.FileMnagerService;


@Service("atx470ukrService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class Atx470ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	/**
	 * 사업장별 부가가치세 과세표준 및 납부세액(환급세액) 신고명세서
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		if(param.get("RE_REFERENCE").equals("Y")){
			return super.commonDao.list("atx470ukrServiceImpl.selectListSecond", param);
		}else{
			if(super.commonDao.list("atx470ukrServiceImpl.selectListFirst", param).isEmpty()){
				return super.commonDao.list("atx470ukrServiceImpl.selectListSecond", param);
			}else{
				return super.commonDao.list("atx470ukrServiceImpl.selectListFirst", param);
			}
		}
	}

	/**
	 * 재참조버튼 관련 체크
	 * @param param
	 * @return
	 * @throws Exception
	 */
	 
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> dataCheck(Map param) throws Exception {
		return  super.commonDao.list("atx470ukrServiceImpl.selectListFirst", param);
	}



	/**저장**/
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "accnt")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		if(paramList != null) {
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("deleteDetail")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("insertDetail")) {
					insertList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("updateDetail")) {
					updateList = (List<Map>)dataListMap.get("data");
				}
			}
			if(deleteList != null) this.deleteDetail(deleteList, user);
			if(insertList != null) this.insertDetail(insertList, user, paramMaster);
			if(updateList != null) this.updateDetail(updateList, user);
		}
		paramList.add(0, paramMaster);
		return paramList;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public Integer insertDetail(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {
		try {
			Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
			if(dataMaster.get("RE_REFERENCE_SAVE").equals("Y")){
				super.commonDao.delete("atx470ukrServiceImpl.deleteDetailAll", dataMaster);
			}
			for(Map param : paramList ) {
				super.commonDao.update("atx470ukrServiceImpl.insertDetail", param);
			}
		}catch(Exception e){
			throw new  UniDirectValidateException(this.getMessage("2627", user));
		}
		return 0;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public Integer updateDetail(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param : paramList ) {
			super.commonDao.insert("atx470ukrServiceImpl.updateDetail", param);
		}
		return 0;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public Integer deleteDetail(List<Map> paramList,  LoginVO user) throws Exception {
		for(Map param :paramList ) {
			try {
				super.commonDao.delete("atx470ukrServiceImpl.deleteDetail", param);
			}catch(Exception e) {
					throw new  UniDirectValidateException(this.getMessage("547",user));
			}
		}
		return 0;
	}




	/**
	 * CLIP REPORT 출력 관련 로직 추가: 20200624
	 * @param param
	 * @return
	 * @throws Exception
	 */
	 
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectListPrint (Map param, LoginVO user) throws Exception {
		return super.commonDao.list("atx470ukrServiceImpl.selectListPrint", param);
	}

}