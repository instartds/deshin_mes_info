package foren.unilite.modules.z_mit;

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
import foren.framework.utils.ObjUtils;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.service.impl.TlabCodeService;
import foren.unilite.com.validator.UniDirectValidateException;


@Service("s_pmr110ukrv_mitService")
@SuppressWarnings({"rawtypes", "unchecked"})
public class S_pmr110ukrv_mitServiceImpl extends TlabAbstractServiceImpl  {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	
	/**
	 * 생산마감업로드
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_mit")
	public List<Map> selectList(Map param, LoginVO user) throws Exception {
		return  super.commonDao.list("s_pmr110ukrv_mitServiceImpl.selectList", param);
	}
	
	/**
	 * 생산예약작업번호 조회
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_mit")
	public List<Map> selectWorkNum(Map param, LoginVO user) throws Exception {
		return  super.commonDao.list("s_pmr110ukrv_mitServiceImpl.selectWorkNum", param);
	}
	
	/**
	 * 생산마감업로드  저장
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "z_mit")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		
		Map masterData = (Map) paramMaster.get("data");
		if(paramList != null)	{
			List<Map> updateList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("updateList")) {
					updateList = (List<Map>)dataListMap.get("data");
				} 
			}
			if(updateList != null) this.updateList(updateList, masterData,  user);
		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_mit")
	public List<Map> updateList(List<Map> paramList, Map masterData, LoginVO user) throws Exception {	
		if(paramList != null)	{
			 for(Map param :paramList )	{
				super.commonDao.update("s_pmr110ukrv_mitServiceImpl.updateExcel", param);
			 }	
		 	 Map updateData = (Map)super.commonDao.queryForObject("s_pmr110ukrv_mitServiceImpl.updateList", masterData);
		 	 if(updateData != null)	{
		 		 if(ObjUtils.isNotEmpty(updateData.get("ERROR_DESC")))	{
		 			throw new  UniDirectValidateException(this.getMessage(ObjUtils.getSafeString(updateData.get("ERROR_DESC")), user));
		 		 }
		 	 	masterData.put("WKORD_NUM", updateData.get("WKORD_NUM"));
		 	 }
		}
		 return paramList;
	}
	
	@ExtDirectMethod(group = "z_mit", value = ExtDirectMethodType.STORE_READ)
    public List<Map> selectExcelUploadSheet1(Map param) throws Exception {
    	Map<String, Object> paramMap = new HashMap();
    	List<Map> excelUploadMapList = super.commonDao.list("s_pmr110ukrv_mitServiceImpl.selectExcelUploadSheet1", param);

        return excelUploadMapList;
    }

	@ExtDirectMethod(group = "z_mit")
	public void excelValidate(String jobID, Map param) {
		super.commonDao.update("s_pmr110ukrv_mitServiceImpl.excelValidate", param);
	}

	@ExtDirectMethod(group = "z_mit")
	public Map deleteAll(Map param) {
		super.commonDao.update("s_pmr110ukrv_mitServiceImpl.deleteAll", param);
		return param;
	}

}
