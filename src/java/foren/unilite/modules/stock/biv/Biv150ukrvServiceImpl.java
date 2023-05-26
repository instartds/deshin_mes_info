package foren.unilite.modules.stock.biv;

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

@Service("Biv150ukrvService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class Biv150ukrvServiceImpl extends TlabAbstractServiceImpl  {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@Resource(name = "fileMnagerService")
	private FileMnagerService fileMnagerService;


	@ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_READ)
	public Object  YyyymmSet(Map param) throws Exception {
		return  super.commonDao.select("Biv150ukrvService.Yyyymm", param);	// 자동 날짜 지정
	}

	@ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_READ)
	public List<Map>  selectMaster(Map param) throws Exception {
		if(param.get("COUNT_DATE") != null ) param.put("COUNT_DATE", ObjUtils.getSafeString( param.get("COUNT_DATE")).replaceAll("\\.", ""));
		return  super.commonDao.list("Biv150ukrvService.selectList", param);	// 실행하기 전 조회
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY,group = "stock")			// 실행
	public Object excuteStockAdjust(Map param, LoginVO user) throws Exception {			// SP 로 실행
		//Object r = super.commonDao.queryForObject("Biv150ukrvService.execStockAdjust", param);
		super.commonDao.queryForObject("Biv150ukrvService.execStockAdjust", param);
		String errorDesc = ObjUtils.getSafeString(param.get("ErrorDesc"));
		if(!ObjUtils.isEmpty(errorDesc)) {
			throw new	UniDirectValidateException(this.getMessage(errorDesc, user));
		}
	//		if(rMap!= null && !"".equals(rMap.get("ERROR_CODE")))	{
	//			throw new Exception(errorDesc);
	//			String[] sErr = rMap.get("ERROR_CODE").toString().split(";");
	//			throw new UniDirectValidateException(this.getMessage(sErr[0], user));
	//		}

		return param;
	}






//사용 안 함
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "stock")		// 실행
	public Object insertMaster(Map param, LoginVO user) throws Exception {			// SQL 로 실행
		Object r = super.commonDao.queryForObject("Biv150ukrvService.insertDetail", param);
		Map<String, Object>	rMap = (Map<String, Object>) r;
		if(!"".equals(rMap.get("ERROR_CODE")))	{
			String[] sErr = rMap.get("ERROR_CODE").toString().split(";");
			throw new UniDirectValidateException(this.getMessage(sErr[0], user));
		}
		return r;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "stock")		// 취소
	public Object deleteMaster(Map param, LoginVO user) throws Exception {
		Object r = super.commonDao.queryForObject("Biv150ukrvService.deleteDetail", param);
		Map<String, Object>	rMap = (Map<String, Object>) r;
		if(!"".equals(rMap.get("ERROR_CODE")))	{
			String[] sErr = rMap.get("ERROR_CODE").toString().split(";");
			throw new UniDirectValidateException(this.getMessage(sErr[0], user));
		}
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
			List<Map> chkList = (List<Map>) super.commonDao.list("Biv150ukrvService.checkCompCode", compCodeMap);
			for(Map param : paramList )	{
				for(Map checkCompCode : chkList) {
					 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
					 param.put("CELL_FLAG_YN", cellFlagYN);
					 super.commonDao.insert("Biv150ukrvService.insertDetail", param);
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
		List<Map> chkList = (List) super.commonDao.list("Biv150ukrvService.checkCompCode", compCodeMap);
		 for(Map param :paramList )	{
			 for(Map checkCompCode : chkList) {
				 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				 super.commonDao.update("Biv150ukrvService.deleteDetail", param);
			 }
		 }
		 return 0;
	}
}
