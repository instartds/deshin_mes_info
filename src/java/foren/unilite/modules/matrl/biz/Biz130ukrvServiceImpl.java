package foren.unilite.modules.matrl.biz;

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
import foren.framework.sec.license.LicenseManager;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.utils.UniliteUtil;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.com.fileman.FileMnagerService;

@Service("biz130ukrvService")
public class Biz130ukrvServiceImpl extends TlabAbstractServiceImpl  {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@Resource(name = "fileMnagerService")
	private FileMnagerService fileMnagerService;

	@ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_READ)
	public Object  userWhcode(Map param) throws Exception {
		return  super.commonDao.select("biz130ukrvService.userWhcode", param);
	}

	/**
	 * 조회
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_READ)		// 조회
	public List<Map<String, Object>> selectMaster(Map param) throws Exception {
		return super.commonDao.list("biz130ukrvService.selectMasterList", param);
	}

	@ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_READ)		// 실사등록조회
	public List<Map<String, Object>> selectMaster2(Map param) throws Exception {
		return super.commonDao.list("biz130ukrvService.selectMasterList2", param);
	}

	@ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_READ)		// 실행
	public Object insertMaster(Map param, LoginVO user) throws Exception {
		//super.commonDao.select("biv113ukrvService.WhCodeSet", param);	// 실행할때 창고 검사
		Object r = super.commonDao.queryForObject("biz130ukrvService.insertMasterList", param);
		Map<String, Object>	rMap = (Map<String, Object>) r;
		String errorDesc = ObjUtils.getSafeString(rMap.get("ERROR_CODE"));
		if(! ObjUtils.isEmpty(errorDesc))	{
			throw new UniDirectValidateException(this.getMessage(errorDesc, user));
		}
		//super.commonDao.list("biz130ukrvService.selectMasterList2", param);
		return r;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "stock")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		String cellFlagYN = (String)dataMaster.get("CEll_FLAG_YN");
		if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("deleteDetail")) {
					deleteList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("insertDetail")) {
					insertList = (List<Map>)dataListMap.get("data");
				}
			}
			if(deleteList != null) this.deleteDetail(deleteList, user);
			if(insertList != null) this.insertDetail(insertList, user, cellFlagYN);

		}
		paramList.add(0, paramMaster);

		return  paramList;
	}


	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "stock")		// INSERT
	public Integer  insertDetail(List<Map> paramList, LoginVO user, String cellFlagYN) throws Exception {
		try {
			Map compCodeMap = new HashMap();
			compCodeMap.put("S_COMP_CODE", user.getCompCode());
			List<Map> chkList = (List<Map>) super.commonDao.list("biz130ukrvService.checkCompCode", compCodeMap);
			for(Map param : paramList )	{
				for(Map checkCompCode : chkList) {
					 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
					 param.put("CELL_FLAG_YN", cellFlagYN);
					 super.commonDao.insert("biz130ukrvService.insertDetail", param);
				}
			}
		}catch(Exception e){
			throw new  UniDirectValidateException(this.getMessage("2627", user));
		}

		return 0;
	}


	@ExtDirectMethod(group = "stock", needsModificatinAuth = true)		// DELETE
	public Integer deleteDetail(List<Map> paramList,  LoginVO user) throws Exception {
		Map compCodeMap = new HashMap();
		compCodeMap.put("S_COMP_CODE", user.getCompCode());
		List<Map> chkList = (List) super.commonDao.list("biz130ukrvService.checkCompCode", compCodeMap);
		 for(Map param :paramList )	{
			 for(Map checkCompCode : chkList) {
				 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				 super.commonDao.update("biz130ukrvService.deleteDetail", param);
			 }
		 }
		 return 0;
	}
}
