package foren.unilite.modules.z_kocis;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;

@Service("s_hum290ukrService_KOCIS")
public class S_Hum290ukrServiceImpl_KOCIS extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	/**
	 * 조회  
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "hum", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList(Map param) throws Exception {

		return super.commonDao.list("s_hum290ukrServiceImpl_KOCIS.selectList", param);
	}
	
    // sync All
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "hum")
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})   
    public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
//        Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
        
        if(paramList != null)   {
//            List<Map> insertList = null;
            List<Map> updateList = null;
            List<Map> deleteList = null;
            for(Map dataListMap: paramList) {
                if(dataListMap.get("method").equals("updateList")) {
                    updateList = (List<Map>)dataListMap.get("data"); 
                } else if(dataListMap.get("method").equals("deleteList")) {
                    deleteList = (List<Map>)dataListMap.get("data");
                }
            }
            //입력
//            if(insertList != null) this.insertList(insertList, user);
            //수정
            if(updateList != null) this.updateList(updateList, user);
            //삭제
            if(deleteList != null) this.deleteList(deleteList, user);
        }
        paramList.add(0, paramMaster);
                
        return  paramList;
    }

    /**
     * 수정
     */
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hum")
    public List<Map> updateList(List<Map> paramList, LoginVO loginVO) throws Exception {

        for(Map param :paramList )  {
//            Map exist = (Map) super.commonDao.select("s_hum290ukrServiceImpl_KOCIS.checkData", param);
            
            String exist = (String) super.commonDao.select("s_hum290ukrServiceImpl_KOCIS.checkData", param);
            
            param.put("EXIST_YN", exist);
            param.put("COMP_CODE",  loginVO.getCompCode());
            param.put("PERSON_NUMB",param.get("PERSON_NUMB"));
            param.put("USER_ID", loginVO.getUserID());
            
            super.commonDao.update("s_hum290ukrServiceImpl_KOCIS.updateList", param);                         
        }
        return paramList;
    }
    
    /**
     * 삭제
     */
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hum")
    public void deleteList(List<Map> paramList, LoginVO loginVO) throws Exception {

        for(Map param :paramList )  {
//             Map err = (Map) super.commonDao.select("s_hum290ukrServiceImpl_KOCIS.checkDelete", param);
//             if(!ObjUtils.isEmpty(err.get("ERROR_DESC"))){
//                String errorDesc = ObjUtils.getSafeString(err.get("ERROR_DESC"));
//                String errorCode = ObjUtils.getSafeString(err.get("ERROR_CODE"));
//                if (ObjUtils.isNotEmpty(errorDesc)) {
//                    String[] messsage = errorDesc.split(",");
//                    throw new  UniDirectValidateException(this.getMessage(errorCode, user) + "\n" + messsage[0] + "\n" + messsage[1]);
//                } else {
//                    throw new  UniDirectValidateException(this.getMessage(errorCode, user));
//                }
//             }
            param.put("COMP_CODE",  loginVO.getCompCode());
            param.put("PERSON_NUMB",param.get("PERSON_NUMB"));
            param.put("USER_ID", loginVO.getUserID());
            
             super.commonDao.delete("s_hum290ukrServiceImpl_KOCIS.deleteList", param);
        }   
        return;
    }    
    
}
