package foren.unilite.modules.equip.esa;

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

import com.google.gson.Gson;

import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.sales.SalesCommonServiceImpl;
@Service("esa100ukrvService")
public class Esa100ukrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	

	@Resource(name="salesCommonService")
	private SalesCommonServiceImpl SalesUtil;
	
	/**
	 * masterForm 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "equip", value = ExtDirectMethodType.FORM_LOAD)
	public Object selectForm(Map param) throws Exception {
		return super.commonDao.select("esa100ukrvServiceImpl.selectMaster", param);
	}
	
	@ExtDirectMethod(group = "equip", value = ExtDirectMethodType.FORM_LOAD)
	public Object checkFinishData(Map param) throws Exception {
		return super.commonDao.select("esa100ukrvServiceImpl.checkFinishData", param);
	}
	
	/**
	 * masterForm 저장
	 * @param dataMaster
	 * @param user
	 * @param result
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_POST, group = "equip")
	public ExtDirectFormPostResult syncForm(Esa100ukrvModel dataMaster,  LoginVO user,  BindingResult result) throws Exception {	
		dataMaster.setS_COMP_CODE(user.getCompCode());
		dataMaster.setS_USER_ID(user.getUserID());
		String FLAG = dataMaster.getFLAG();
		Map map=(Map) super.commonDao.select("esa100ukrvServiceImpl.existMaster", dataMaster);
		
		if(ObjUtils.isEmpty(map)){
			FLAG = "N";
		}else{
			if(FLAG.equals("S")){
				FLAG = "U";
			}else{
				FLAG = "D";
			}
		}
		
		if(FLAG.equals("N")){
			super.commonDao.insert("esa100ukrvServiceImpl.insertMaster", dataMaster);
		}
		if(FLAG.equals("U")){
			super.commonDao.update("esa100ukrvServiceImpl.updateMaster", dataMaster);
		}
		if(FLAG.equals("D")){
			super.commonDao.update("esa100ukrvServiceImpl.deleteMaster", dataMaster);
		}
		
		ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);
		extResult.addResultProperty("resultData", dataMaster);
		return extResult;
	}
	/**
	 * detailGrid 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "equip")
	public List<Map> selectList(Map param) throws Exception{
		return super.commonDao.list("esa100ukrvServiceImpl.selectList", param);
	}
/**
 * master,detail 저장
 * @param paramList
 * @param paramMaster
 * @param user
 * @return
 * @throws Exception
 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "equip")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {

		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");

		Map map=(Map) super.commonDao.select("esa100ukrvServiceImpl.existMaster", dataMaster);
		if(map==null){
			super.commonDao.insert("esa100ukrvServiceImpl.insertMaster", dataMaster);
		}else{
			super.commonDao.update("esa100ukrvServiceImpl.updateMaster", dataMaster);
		}
		
		if(paramList != null)   {
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
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "equip")
    public void insertDetail(List<Map> paramList, LoginVO user) throws Exception {      
        for(Map param : paramList ) {
            super.commonDao.insert("esa100ukrvServiceImpl.insertDetail", param);
        }   
        return;
    }   
    
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "equip")
    public void updateDetail(List<Map> paramList, LoginVO user) throws Exception {
        for(Map param :paramList )  {
            super.commonDao.update("esa100ukrvServiceImpl.updateDetail", param);
        }
         return;
    } 
    
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "equip")
    public void deleteDetail(List<Map> paramList,  LoginVO user) throws Exception {
         for(Map param :paramList ) {
             super.commonDao.delete("esa100ukrvServiceImpl.deleteDetail", param);
         }
         return;
    }
}
