package foren.unilite.modules.human.hbs;

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

@Service("hbs700rkrService")
public class Hbs700rkrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	public final static String FILE_TYPE_OF_PHOTO = "employeePhoto";
	
	/**
	 * 연봉계약 확정 확인관련
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "hbs", value = ExtDirectMethodType.STORE_READ)
    public String checkHbs700t(Map param) throws Exception {

        String reV = "";
        
        reV = "Y";

        try{
    	    List<Map> checkHbs700tList = (List<Map>) super.commonDao.list("hbs700rkrServiceImpl.checkHbs700t", param);
    	     
    	    if(!ObjUtils.isEmpty(checkHbs700tList)){
    	        for(Map checkHbs700t : checkHbs700tList){
    	            if(checkHbs700t.get("DECS_YN").equals("N")){
    	                reV = "N";
    	            }
    	        }
    	    }else{
    	        reV = "N";
    	    }
        
        }catch(Exception e){
            reV = "N";
        }
        return reV;
    }

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hbs")
	public List<Map<String, Object>> selectPrintList(Map param) throws Exception {
		return (List) super.commonDao.list("hbs700rkrServiceImpl.selectPrintList", param);
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hbs")
	public List<Map<String, Object>> selectPrintPromotion(Map param) throws Exception {
		return (List) super.commonDao.list("hbs700rkrServiceImpl.selectPrintPromotion", param);
	}

}
