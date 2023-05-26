package foren.unilite.modules.trade.tix;

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


@Service("tix200ukrvService")
public class Tix200ukrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	/**
	 * 연간입퇴사자 목록 조회  
	 * @param param
	 * @return
	 * @throws Exception
	 */
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "tix")
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return (List) super.commonDao.list("tix200ukrvServiceImpl.selectList", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "busmaintain")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
        logger.debug("[saveAll] paramDetail:" + paramList);

        //1.로그테이블에서 사용할 KeyValue 생성
        String keyValue = getLogKey();                      
                
        //2.출하지시 로그테이블에 KEY_VALUE, OPR_FLAG 업데이트
        List<Map> dataList = new ArrayList<Map>();
        List<List<Map>> resultList = new ArrayList<List<Map>>();
        String divCode = "";
        for(Map paramData: paramList) {         
            
            dataList = (List<Map>) paramData.get("data");
            logger.debug("paramData.get('data') : " + dataList);
            String oprFlag = "N";
            if(paramData.get("method").equals("insertDetail"))  oprFlag="N";
            if(paramData.get("method").equals("updateDetail"))  oprFlag="U";
            if(paramData.get("method").equals("deleteDetail"))  oprFlag="D";
            
            for(Map param:  dataList) {
                param.put("KEY_VALUE", keyValue);
                param.put("data", super.commonDao.insert("tix200ukrvServiceImpl.insertLogDetail", param));
                divCode = (String) param.get("DIV_CODE");
            }
        }
        //출고등록 Stored Procedure 실행
        Map<String, Object> spParam = new HashMap<String, Object>();

        spParam.put("KeyValue", keyValue);
        spParam.put("CompCode", user.getCompCode());
        spParam.put("DivCode", divCode);
        spParam.put("UserId", user.getUserID());

        super.commonDao.queryForObject("tix200ukrvServiceImpl.USP_TRADE_Tix200ukr", spParam);
        
        String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
                        
        if(!ObjUtils.isEmpty(errorDesc)){
            String[] messsage = errorDesc.split(";");
            throw new  UniDirectValidateException(this.getMessage(messsage[0], user));
        }
        
        paramList.add(0, paramMaster);      
        return  paramList;
    }
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "tix")
	public List<Map> updateDetail(List<Map> paramList, LoginVO user) throws Exception {		
		return paramList;
	}
	
}
