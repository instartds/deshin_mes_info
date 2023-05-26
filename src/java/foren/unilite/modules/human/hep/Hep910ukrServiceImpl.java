package foren.unilite.modules.human.hep;

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
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;

@Service("hep910ukrService")
public class Hep910ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	public final static String FILE_TYPE_OF_PHOTO = "employeePhoto";
	
	/**
	 * BSC평가기준관리조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "hep", value = ExtDirectMethodType.STORE_READ)
    public List<Map<String, Object>> selectList(Map param) throws Exception {
        return super.commonDao.list("hep910ukrServiceImpl.selectList", param);
    }
	


	/**저장**/
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "hep")
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})   
    public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
        
        if(paramList != null)   {
            List<Map> updateList = null;    
           
            for(Map dataListMap: paramList) {
            	
                if(dataListMap.get("method").equals("updateDetail")) {
                    updateList = (List<Map>)dataListMap.get("data");    
                }
            }
            if(updateList != null) this.updateDetail(updateList, user);             
        }
        paramList.add(0, paramMaster);
                
        return  paramList;
    }
    
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hep")
    public void updateDetail(List<Map> paramList, LoginVO user) throws Exception {
        for(Map param :paramList )  {
            
            super.commonDao.update("hep910ukrServiceImpl.updateDetail", param);
        }
         return;
    } 
    
}
