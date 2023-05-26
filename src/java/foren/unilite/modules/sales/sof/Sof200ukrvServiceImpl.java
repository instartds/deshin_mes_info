package foren.unilite.modules.sales.sof;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

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
import foren.unilite.modules.sales.SalesCommonServiceImpl;

@Service("sof200ukrvService")
public class Sof200ukrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	
	
	@Resource(name="salesCommonService")
	private SalesCommonServiceImpl SalesUtil;
	
	/**
	 * 수주마감 그리드 조회(Master)
	 * 订单截止查询
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectDetailList(Map param) throws Exception {
		return super.commonDao.list("sof200ukrvServiceImpl.selectDetailList", param);
	}
	
	/**
	 * 수주마감정보 저장
	 * 最后保存订单信息
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		
		if(paramList != null)  {
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
	
	/**
	 * 수주마감 Detail 수정
	 */
	@SuppressWarnings("rawtypes")
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> updateDetail(List<Map> params, LoginVO user) throws Exception {
		for(Map param: params){
			Map checkExistMap = (Map) super.commonDao.select("sof200ukrvServiceImpl.checkExistOrder", param);
			if(ObjUtils.parseInt(checkExistMap.get("CNT")) > 0){
				super.commonDao.update("sof200ukrvServiceImpl.updateOrderStatus", param);
			}else{
				throw new  UniDirectValidateException(this.getMessage("54622", user));
			}
		}		
		return params;
	}
}
