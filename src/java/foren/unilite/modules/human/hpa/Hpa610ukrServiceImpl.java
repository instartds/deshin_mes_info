package foren.unilite.modules.human.hpa;

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


@Service("hpa610ukrService")
public class Hpa610ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	/**
	 * 마스터 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@Transactional(readOnly = true)
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hpa")
	public List<Map<String, Object>> selectHPA400T(Map param) throws Exception {
		return (List) super.commonDao.list("hpa610ukrServiceImpl.selectHPA400T", param);
	}
	
	/**
     * 디테일 조회
     * @param param
     * @return
     * @throws Exception
     */
    @Transactional(readOnly = true)
    @ExtDirectMethod(value = ExtDirectMethodType.FORM_LOAD, group = "hpa")
    public Object selectHPA600T(Map param) throws Exception {
        return super.commonDao.select("hpa610ukrServiceImpl.selectHPA600T", param);
    }
	
	/**저장**/
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "hcn")
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})   
    public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
        
        if(paramList != null)   {
            List<Map> updateList = null;
            for(Map dataListMap: paramList) {
                if(dataListMap.get("method").equals("updateDetail")) {
                    updateList = (List<Map>)dataListMap.get("data");    
                }
            }
            if(updateList != null) this.updateDetail(updateList, user, paramMaster);             
        }
        paramList.add(0, paramMaster);
                
        return  paramList;
    }
    
    /**
	 * 전체마감 정보확인
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "hpa")
	public String closedateconfirm(Map<String, Object> param, LoginVO user) throws Exception {
	    return (String)super.commonDao.select("hpa610ukrServiceImpl.closedateconfirm", param);
	}
	
	/**
	 * 개인마감 정보확인
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "hpa")
	public String closedateconfirm1(Map<String, Object> param, LoginVO user) throws Exception {
		return (String)super.commonDao.select("hpa610ukrServiceImpl.closedateconfirm1", param);
	}
	
    /**
	 * 삭제
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "hpa")
	public void deleteList(Map<String, Object> param, LoginVO user) throws Exception {
	    super.commonDao.delete("hpa610ukrServiceImpl.deleteList", param);
	}
	
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hcn")
    public void updateDetail(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {
        Map<String, Object> dataMaster = (Map<String, Object>)paramMaster.get("data");
        
        for(Map param :paramList )  {
            
            super.commonDao.update("hpa610ukrServiceImpl.updateHPA400T", param);
        }
        super.commonDao.update("hpa610ukrServiceImpl.updateHPA600T", dataMaster);
        return;
    } 
    
}
