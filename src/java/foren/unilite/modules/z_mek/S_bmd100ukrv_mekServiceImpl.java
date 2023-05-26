package foren.unilite.modules.z_mek;

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
import foren.unilite.modules.com.fileman.FileMnagerService;

@Service("s_bmd100ukrv_mekService")
public class S_bmd100ukrv_mekServiceImpl extends TlabAbstractServiceImpl  {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	private  TlabCodeService tlabCodeService ;
	
	@Resource(name = "fileMnagerService")
	private FileMnagerService fileMnagerService;
	
	/**
	 * 품질검사정보 조회
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "stock")
	public List<Map> selectList(Map param, LoginVO user) throws Exception {
		param.put("COMP_CODE", user.getCompCode());
//		String findType = ObjUtils.getSafeString(param.get("FIND_TYPE"));
//		if(!"".equals(findType))	{
//			Map searchType = (Map) super.commonDao.select("s_bmd100ukrv_mekService.selectSearchType", param); 
//			if(!ObjUtils.isEmpty(searchType)) param.put("FIND_TYPE", searchType.get("REF_CODE1"));
//		}
		return  super.commonDao.list("s_bmd100ukrv_mekService.selectList", param);
	}
	
	/**
	 * 품질검사정보 저장
	 * @param paramList
	 * @param paramMaster
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "stock")
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
			if(insertList != null) this.insertDetail(insertList, user);
			if(updateList != null) this.updateDetail(updateList, user);
		}
		paramList.add(0, paramMaster);
		return  paramList;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "stock")
	public Integer insertDetail(List<Map> paramList, LoginVO user) throws Exception {
		 for(Map param :paramList )	{
			String checkValueName = "";
			List<Map> checkName = (List<Map>)super.commonDao.list("s_bmd100ukrv_mekService.checkUniCode", param);
            if (!checkName.isEmpty()) {
                checkValueName = ObjUtils.getSafeString(checkName.get(0).get("MODEL_UNI_CODE"));
            }
            if (!ObjUtils.isEmpty(checkValueName)) {
                String errMessage = "동일한 모델고유식별코드가 등륵되어 있습니다.\n(모델고유식별코드: " + checkValueName + ")";
                throw new Exception(errMessage);
            }
			super.commonDao.insert("s_bmd100ukrv_mekService.insert", param);
		 }
		 return 0;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "stock")
	public Integer updateDetail(List<Map> paramList, LoginVO user) throws Exception {
		 for(Map param :paramList )	{
			 super.commonDao.update("s_bmd100ukrv_mekService.update", param);
		 }		 
		 return 0;
	} 
	
	@ExtDirectMethod(group = "stock", needsModificatinAuth = true)
	public Integer deleteDetail(List<Map> paramList,  LoginVO user) throws Exception {		
		 for(Map param :paramList )	{
			String checkValueName = "";
			List<Map> checkName = (List<Map>)super.commonDao.list("s_bmd100ukrv_mekService.checkDelete", param);
            if (!checkName.isEmpty()) {
                checkValueName = ObjUtils.getSafeString(checkName.get(0).get("MODEL_UNI_CODE"));
            }
            if (!ObjUtils.isEmpty(checkValueName)) {
                String errMessage = "사용중인 코드는 삭제할 수 없습니다.";
                throw new Exception(errMessage);
            }		
			super.commonDao.delete("s_bmd100ukrv_mekService.delete", param);
		 }
		 return 0;
	}

	
}
