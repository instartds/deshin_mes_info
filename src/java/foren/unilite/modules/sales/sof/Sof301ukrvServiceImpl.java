package foren.unilite.modules.sales.sof;

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

@Service("sof301ukrvService")
public class Sof301ukrvServiceImpl  extends TlabAbstractServiceImpl {
    private final Logger logger = LoggerFactory.getLogger(this.getClass());
	/**
	 * 수주승인조회(상단) 그리드 조회 목록
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sales")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {
	
		return  super.commonDao.list("sof301ukrvServiceImpl.selectList", param);
	}
	
	/**
	 * 수주승인조회(하단) 그리드 조회 목록
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sales")
	public List<Map<String, Object>>  detailList(Map param) throws Exception {
		return  super.commonDao.list("sof301ukrvServiceImpl.detailList", param);
	}
	
	/**
	 * 수주확정
	 * @param param 검색항목
     * @return
     * @throws Exception
     *  */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})   
    public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception { 
        if(paramList != null)   {
            List<Map> updateList = null;
            for(Map dataListMap: paramList) {
               if(dataListMap.get("method").equals("updateDetail")) {
                    updateList = (List<Map>)dataListMap.get("data");    
                } 
            }           
            if(updateList != null) this.updateDetail(updateList, paramMaster, user);                
        }
        paramList.add(0, paramMaster);
                
        return  paramList;
    }
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")      // UPDATE
    public Integer updateDetail(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
         for(Map param :paramList ) {
             Map errorMap = (Map) super.commonDao.select("sof301ukrvServiceImpl.updateDetail", param);
//           String errorDesc = (String) errorMap.get("errorDesc");
             if(!ObjUtils.isEmpty(errorMap.get("ERROR_DESC"))){
                 String errorDesc = (String) errorMap.get("ERROR_DESC");
                 String[] messsage = errorDesc.split(";");
                 throw new  UniDirectValidateException(this.getMessage(messsage[0], user));
             }
         }         
         return 0;
    } 
	
}
