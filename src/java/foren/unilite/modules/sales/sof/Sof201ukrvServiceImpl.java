package foren.unilite.modules.sales.sof;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("sof201ukrvService")
public class Sof201ukrvServiceImpl  extends TlabAbstractServiceImpl {

	/**
	 * 납기일 일괄 변경
	 * 조회
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sales")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {
		return  super.commonDao.list("sof201ukrvServiceImpl.selectList", param);
	}
	
	/*
	 * 납기일 일괄 변경
	 * 수정
	 * */
	 @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "sales" )
	  public List<Map> updateMulti( List<Map> paramList, LoginVO user ) throws Exception {
		 
		 for (Map param : paramList) {
			 super.commonDao.update("sof201ukrvServiceImpl.updateMulti", param);
		 }
	        return  paramList;
	    }
	/*
	 * 수정인지 체크
	 * */ 
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_SYNCALL, group = "sales" )
    @Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
    public List<Map> saveAll( List<Map> paramList, Map paramMaster, LoginVO user ) throws Exception {
        List<Map> dataList = new ArrayList<Map>();
        if (paramList != null) {
            for (Map param : paramList) {
                dataList = (List<Map>)param.get("data");
                
                if (param.get("method").equals("updateMulti")) {
                    param.put("data", updateMulti(dataList, user));
                }
            }
        }
        paramList.add(0, paramMaster);
        return paramList;
    }
}
