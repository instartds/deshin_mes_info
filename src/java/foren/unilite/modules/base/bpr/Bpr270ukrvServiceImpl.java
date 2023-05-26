package foren.unilite.modules.base.bpr;

import java.util.ArrayList;
import java.util.HashMap;
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
import foren.unilite.com.code.CodeInfo;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.service.impl.TlabCodeService;
import foren.unilite.com.validator.UniDirectValidateException;


@Service("bpr270ukrvService")
@SuppressWarnings({"rawtypes", "unchecked"})
public class Bpr270ukrvServiceImpl extends TlabAbstractServiceImpl  {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	
	/**
	 * 품목표준공수 조회
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "base")
	public List<Map> selectList(Map param, LoginVO user) throws Exception {
		return  super.commonDao.list("bpr270ukrvServiceImpl.selectList", param);
	}
	
	
	/**
	 * 품목표준공수 저장
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "base")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		if(paramList != null)	{
			List<Map> updateList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("updateList")) {
					updateList = (List<Map>)dataListMap.get("data");
				} 
			}
			if(updateList != null) this.updateList(updateList, user);
		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")
	public List<Map> updateList(List<Map> paramList, LoginVO user) throws Exception {		
		 for(Map param :paramList )	{
			super.commonDao.update("bpr270ukrvServiceImpl.updateList", param);
		 }		 
		 return paramList;
	}
	
	 @ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	    public List<Map> selectExcelUploadSheet1(Map param) throws Exception {
	    	Map<String, Object> paramMap = new HashMap();
	    	List<Map> excelUploadMapList = super.commonDao.list("bpr270ukrvServiceImpl.selectExcelUploadSheet1", param);

	        return excelUploadMapList;
	    }

		public void excelValidate(String jobID, Map param) {
			super.commonDao.update("bpr270ukrvServiceImpl.excelValidate", param);
		}


}
