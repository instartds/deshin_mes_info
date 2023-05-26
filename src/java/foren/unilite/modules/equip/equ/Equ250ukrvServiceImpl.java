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

@Service("equ250ukrvServiceImpl")
public class Equ250ukrvServiceImpl extends TlabAbstractServiceImpl {

	/**
	 * 금형품목 조회
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "equip")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {
		List<Map<String, Object>> selectList =  super.commonDao.list("equ250ukrvServiceImpl.selectList", param);
		return  selectList;
	}

	/**
	 * 금형품목 SaveAll
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "equip")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {

		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		
		if(paramList != null)   {
            List<Map> insertList = null;
            List<Map> updateList = null;
            List<Map> deleteList = null;
            for(Map dataListMap: paramList) {
                if(dataListMap.get("method").equals("deleteMaster")) {
                    deleteList = (List<Map>)dataListMap.get("data");
                } else if(dataListMap.get("method").equals("insertMaster")) {
                    insertList = (List<Map>)dataListMap.get("data");
                } else if(dataListMap.get("method").equals("updateMaster")) {
                    updateList = (List<Map>)dataListMap.get("data");    
                }
            }
            if(deleteList != null) this.deleteMaster(deleteList, user);
            if(insertList != null) this.insertMaster(insertList, user);
            if(updateList != null) this.updateMaster(updateList, user);             
        }
        paramList.add(0, paramMaster);
                
        return  paramList;
    }
	
	/**
	 * 금형품목 입력
	 */
	@ExtDirectMethod(group = "equip", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> insertMaster(List<Map> params, LoginVO user) throws Exception {
		for(Map param: params)		{
			super.commonDao.insert("equ250ukrvServiceImpl.insertMaster", param);
		}		
		return params;
	}
	
	/**
	 * 금형품목 수정
	 */
	@ExtDirectMethod(group = "equip", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> updateMaster(List<Map> params, LoginVO user) throws Exception {
		for(Map param: params)		{
			super.commonDao.insert("equ250ukrvServiceImpl.updateMaster", param);
		}		
		return params;
	}
	
	/**
	 * 금형품목 삭제
	 */
	@ExtDirectMethod(group = "equip", value = ExtDirectMethodType.STORE_MODIFY)
	public void deleteMaster(List<Map> params, LoginVO user) throws Exception {
		for(Map<String, Object> param : params)	{
			super.commonDao.delete("equ250ukrvServiceImpl.deleteMaster", param);
		}
//		super.commonDao.delete("mms510ukrvServiceImpl.checkDeleteAllDetail", params.get(0)); 
	}
}
