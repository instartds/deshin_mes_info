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
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;

@Service("hep920ukrService")
public class Hep920ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	public final static String FILE_TYPE_OF_PHOTO = "employeePhoto";
	
	/**
     * 각 점수생성
     * @param param
     * @return
     * @throws Exception
     */
	@ExtDirectMethod(group = "hep", value = ExtDirectMethodType.STORE_READ)
    public double operSelect(Map param, LoginVO user) throws Exception {
        double reV = 0.00;
                
        try{
            reV = ObjUtils.parseDouble(super.commonDao.select("hep920ukrServiceImpl.operSelect", param));
        
        }catch(Exception e){
            throw new UniDirectValidateException("계산에 실패하였습니다.");
        }
        return reV;
            
    } 
	
	/**
     * 대상자점수생성
     * @param param
     * @return
     * @throws Exception
     */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hep")
    public String beforeSelect(Map param, LoginVO user) throws Exception {
        String reV = "";
                
        reV = "Y";

        try{
            super.commonDao.update("hep920ukrServiceImpl.beforeSelect", param);
        
        }catch(Exception e){
            reV = "N";
        }
        return reV;
            
    } 
	
	
    @ExtDirectMethod(group = "hep", value = ExtDirectMethodType.STORE_READ)
    public List<Map<String, Object>> beforeSelectList(Map param) throws Exception {
        return super.commonDao.list("hep920ukrServiceImpl.beforeSelectList", param);
    }
    
	/**
	 * BSC평가점수관리조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "hep", value = ExtDirectMethodType.STORE_READ)
    public List<Map<String, Object>> selectList(Map param) throws Exception {
        return super.commonDao.list("hep920ukrServiceImpl.selectList", param);
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
            
            super.commonDao.update("hep920ukrServiceImpl.updateDetail", param);
        }
         return;
     }
    
}
