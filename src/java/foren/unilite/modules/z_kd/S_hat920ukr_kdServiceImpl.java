package foren.unilite.modules.z_kd;

import java.util.ArrayList;
import java.util.Calendar;
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

@Service("s_hat920ukr_kdService")
@SuppressWarnings({"rawtypes", "unchecked"})
public class S_hat920ukr_kdServiceImpl extends TlabAbstractServiceImpl	{
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@Resource(name = "fileMnagerService")
	private FileMnagerService fileMnagerService;

	/**
	 * 조회
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hum")
	public List<Map> selectList(Map param, LoginVO user) throws Exception {
		String keyValue = getLogKey();
		Map<String, Object> spParam = new HashMap<String, Object>();
		spParam.put("comp_code" ,user.getCompCode());
		spParam.put("duty_date" ,param.get("DUTY_YYYYMMDD"));
		spParam.put("user_id" ,user.getUserID());
		spParam.put("KeyValue", keyValue);
		spParam.put("LangCode", user.getLanguage());

		super.commonDao.queryForObject("s_hat920ukr_kdService.spReceiving", spParam);

		  String ErrorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));

		  if(!ObjUtils.isEmpty(ErrorDesc)){
			   String[] messsage = ErrorDesc.split(";");
			   throw new  UniDirectValidateException(this.getMessage(messsage[0], user));
		  }
		List<Map> resultList = super.commonDao.list("s_hat920ukr_kdService.select", param);

		return resultList;
	}




	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "hum")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {

		if(paramList != null)	{
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
			if(insertList != null) this.insertDetail(insertList, user);
			if(updateList != null) this.updateDetail(updateList, user);
		}
		paramList.add(0, paramMaster);

		return	paramList;
	}


	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hum")		// INSERT
	public Integer	insertDetail(List<Map> paramList, LoginVO user) throws Exception {
		try {
			Map compCodeMap = new HashMap();
			compCodeMap.put("S_COMP_CODE", user.getCompCode());
			for(Map param : paramList )	{
				 super.commonDao.update("s_hat920ukr_kdService.insertDetail", param);
			}
		}catch(Exception e){
			throw new	UniDirectValidateException(this.getMessage("2627", user));
		}

		return 0;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hum")		// UPDATE
	public Integer updateDetail(List<Map> paramList, LoginVO user) throws Exception {
		Map compCodeMap = new HashMap();
		compCodeMap.put("S_COMP_CODE", user.getCompCode());
		 for(Map param :paramList )	{
			 super.commonDao.update("s_hat920ukr_kdService.updateDetail", param);
		 }
		 return 0;
	}


	@ExtDirectMethod(group = "hum", needsModificatinAuth = true)		// DELETE
	public Integer deleteDetail(List<Map> paramList,	LoginVO user) throws Exception {
		Map compCodeMap = new HashMap();
		compCodeMap.put("S_COMP_CODE", user.getCompCode());
		 for(Map param :paramList )	{
			 super.commonDao.update("s_hat920ukr_kdService.deleteDetail", param);
		 }
		 return 0;
	}

	@ExtDirectMethod(group = "hum", needsModificatinAuth = true)
	 public List<Map<String, Object>> selectMealPersonId(Map param) throws Exception {
        return super.commonDao.list("s_hat920ukr_kdService.selectMealPersonId", param);
     }

}
