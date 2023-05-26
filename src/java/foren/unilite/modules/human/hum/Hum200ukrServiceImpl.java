package foren.unilite.modules.human.hum;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;

import org.slf4j.Logger;

import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;


@Service("hum200ukrService")
public class Hum200ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ,group = "hum")
	public List<Map> selectList1(Map param, LoginVO loginVO) throws Exception {		
		param.put("S_COMP_CODE", loginVO.getCompCode());
		param.put("USER_ID", loginVO.getUserID());
			
		return (List) super.commonDao.list("hum200ukrServiceImpl.selectList1", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hum")
	public List<Map<String, Object>> selectList2(Map param, LoginVO loginVO) throws Exception {		
		param.put("S_COMP_CODE", loginVO.getCompCode());
		param.put("USER_ID", loginVO.getUserID());		
		String arr[] = param.toString().split(",");		
		for(int i=0;i<arr.length;i++){
			System.out.println(arr[i]);
		}
		return (List) super.commonDao.list("hum200ukrServiceImpl.selectList2", param);		
	}
	
	/* 재참조 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hum")
	public List<Map<String, Object>> fnHum240QStd2(Map param, LoginVO loginVO) throws Exception {		
		param.put("S_COMP_CODE", loginVO.getCompCode());
		param.put("USER_ID", loginVO.getUserID());		
		String arr[] = param.toString().split(",");		
		for(int i=0;i<arr.length;i++){
			System.out.println(arr[i]);
		}
		return (List) super.commonDao.list("hum200ukrServiceImpl.fnHum240QStd2", param);
//		return null;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hum")
	public List<Map> update(List<Map> paramList, LoginVO loginVO) throws Exception {
		for(Map param :paramList )	{			
			param.put("S_COMP_CODE", loginVO.getCompCode());
			param.put("USER_ID", loginVO.getUserID());
			
			String arr[] = param.toString().split(",");
			for(int i=0;i<arr.length;i++){
				System.out.println(arr[i]);
			}			
			super.commonDao.update("hum200ukrServiceImpl.update", param);							
		}
		return paramList;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hum")
	public List<Map> update2(List<Map> paramList, LoginVO loginVO) throws Exception {
		for(Map param :paramList )	{			
			param.put("S_COMP_CODE", loginVO.getCompCode());
			param.put("USER_ID", loginVO.getUserID());
			
			String arr[] = param.toString().split(",");
			for(int i=0;i<arr.length;i++){
				System.out.println(arr[i]);
			}			
			super.commonDao.update("hum200ukrServiceImpl.update2", param);							
		}
		return paramList;
	}

	
	// sync All
	@ExtDirectMethod(group = "hum")
	public Integer syncAll(Map param) throws Exception {
		logger.debug("syncAll:" + param);
		return 0;
	}	
	
}
	
