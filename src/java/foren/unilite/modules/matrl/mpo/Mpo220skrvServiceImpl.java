package foren.unilite.modules.matrl.mpo;

import java.io.File;
import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.HashMap;
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
import foren.unilite.com.validator.UniDirectValidateException;

@Service("mpo220skrvService")
public class Mpo220skrvServiceImpl  extends TlabAbstractServiceImpl {

	/**
	 * 팩스 전송 현황 조회
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "mpo")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {
		if(param.get("ORDER_DATE1") != null) {
			param.put("YEAR", param.get("ORDER_DATE1").toString().substring(0, 4));
			param.put("MONTH", param.get("ORDER_DATE1").toString().substring(4, 6));
			param.put("WEEK_DAY", param.get("WEEK_DAY").toString());
		}
		return  super.commonDao.list("mpo220skrvServiceImpl.selectList", param);
	}
	
	private int parseInt(String text) {
		// TODO Auto-generated method stub
		return 0;
	}
	
	/**
	 * 팩스 전송된 pdf파일 삭제
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "mpo")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {		
		
		if(paramList != null)	{
			List<Map> updateList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("updateDetail")) {
					updateList = (List<Map>)dataListMap.get("data");	
				} 
			}
			for(Map param: updateList){
//				super.commonDao.update("bpr101ukrvService.bpr200tUpdateDetail", param);
				String delFile = (String) param.get("TR_DOCNAME");				
				File deleteTarget = new File("C:\\FaxClient\\SendDoc", delFile);
				deleteTarget.delete();
			}
		}
		paramList.add(0, paramMaster);
		return  paramList;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "mpo")		// UPDATE
	public Integer updateDetail(List<Map> updateList, LoginVO user) throws Exception {
		
		return 0;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "mpo")
	public List<Map> insertSend(List<Map> paramList) throws Exception {		
		for(Map param : paramList)	{
			super.commonDao.queryForObject("mpo220skrvServiceImpl.insert", param);
		}
		return  paramList;
	}
}
