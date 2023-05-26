package foren.unilite.modules.sales.ssa;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.logging.InjectLogger;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;

@Service("ssa120ukrvService")
public class Ssa120ukrvServiceImpl  extends TlabAbstractServiceImpl {
    @InjectLogger
    public static   Logger  logger  ;// = LoggerFactory.getLogger(this.getClass());

	/**
	 * 매출 단가 조회
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sales")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {
		return  super.commonDao.list("ssa120ukrvServiceImpl.selectList", param);
	}
	
	/** 저장 **/
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_SYNCALL, group = "sales" )
    @Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
    public List<Map> saveAll( List<Map> paramList, Map paramMaster, LoginVO user ) throws Exception {
        Map<String, Object> dataMaster = (Map<String, Object>)paramMaster.get("data");
        if (paramList != null) {
            List<Map> insertList = null;
            List<Map> updateList = null;
            List<Map> deleteList = null;
            for (Map dataListMap : paramList) {
                 if (dataListMap.get("method").equals("updateDetail")) {
                    updateList = (List<Map>)dataListMap.get("data");
                }
            }
//            if (deleteList != null) this.growthDeleteList1(deleteList, user, dataMaster);
//            if (insertList != null) this.growthInsertList1(insertList, user, dataMaster);
            if (updateList != null) this.updateDetail(updateList, user, dataMaster);
        }
        paramList.add(0, paramMaster);
        
        return paramList;
    }
    
    /** 수정 **/
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "sales" )
    public Integer updateDetail( List<Map> paramList, LoginVO user, Map paramMaster ) throws Exception {
        for (Map param : paramList) {
            param.put("ORDER_PRICE_YN", paramMaster.get("ORDER_PRICE_YN"));
            Map errorMap = (Map) super.commonDao.select("ssa120ukrvServiceImpl.USP_SALES_SSA120UKR", param);
//          String errorDesc = (String) errorMap.get("errorDesc");
            if(!ObjUtils.isEmpty(errorMap.get("errorDesc"))){
                String errorDesc = (String) errorMap.get("errorDesc");
                String[] messsage = errorDesc.split(";");
                throw new  UniDirectValidateException(this.getMessage(messsage[0], user));
            }else{
                return 0;
            }
        }
        return 0;
    }    
   
}
