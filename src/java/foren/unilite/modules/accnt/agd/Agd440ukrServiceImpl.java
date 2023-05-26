package foren.unilite.modules.accnt.agd;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;

@Service("agd440ukrService")
public class Agd440ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	/**
     * 이관: 조인스허브 > 관련사MIS 
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
    public Object  sendToMis(Map spParam, LoginVO user) throws Exception {

        Map errorMap = (Map) super.commonDao.select("agd440ukrServiceImpl.USP_ACCNT_AGD440UKR_MIS_JS", spParam);
//      String errorDesc = (String) errorMap.get("errorDesc");
        if(!ObjUtils.isEmpty(errorMap.get("errorDesc"))){
            String errorDesc = (String) errorMap.get("errorDesc");
            //String[] messsage = errorDesc.split(";");
            //throw new  UniDirectValidateException(this.getMessage(messsage[0], user));
            throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
        }else{
            return true;
        }       
    }
    
    /**
     * 이관취소: 조인스허브 > 관련사MIS 
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
    public Object  cancelToMis(Map spParam, LoginVO user) throws Exception {

        Map errorMap = (Map) super.commonDao.select("agd440ukrServiceImpl.USP_ACCNT_AGD440UKR_MIS_CANCEL_JS", spParam);
//      String errorDesc = (String) errorMap.get("errorDesc");
        if(!ObjUtils.isEmpty(errorMap.get("errorDesc"))){
            String errorDesc = (String) errorMap.get("errorDesc");
            //String[] messsage = errorDesc.split(";");
            //throw new  UniDirectValidateException(this.getMessage(messsage[0], user));
            throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
        }else{
            return true;
        }       
    }
    
    /**
     * 이관: 관련사MIS > 조인스허브 
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
    public Object  sendToHub(Map spParam, LoginVO user) throws Exception {

        Map errorMap = (Map) super.commonDao.select("agd440ukrServiceImpl.USP_ACCNT_AGD440UKR_HUB_JS", spParam);
//      String errorDesc = (String) errorMap.get("errorDesc");
        if(!ObjUtils.isEmpty(errorMap.get("errorDesc"))){
            String errorDesc = (String) errorMap.get("errorDesc");
            //String[] messsage = errorDesc.split(";");
            //throw new  UniDirectValidateException(this.getMessage(messsage[0], user));
            throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
        }else{
            return true;
        }       
    }
    
    /**
     * 이관취소: 관련사MIS > 조인스허브 
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
    public Object  cancelToHub(Map spParam, LoginVO user) throws Exception {

        Map errorMap = (Map) super.commonDao.select("agd440ukrServiceImpl.USP_ACCNT_AGD440UKR_HUB_CANCEL_JS", spParam);
//      String errorDesc = (String) errorMap.get("errorDesc");
        if(!ObjUtils.isEmpty(errorMap.get("errorDesc"))){
            String errorDesc = (String) errorMap.get("errorDesc");
            //String[] messsage = errorDesc.split(";");
            //throw new  UniDirectValidateException(this.getMessage(messsage[0], user));
            throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
        }else{
            return true;
        }       
    }
}
