package foren.unilite.modules.crm.cmb;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.utils.UniliteUtil;

@Service("cmb200ukrvService")
public class Cmb200ukrvServiceImpl extends TlabAbstractServiceImpl  {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	/**
	 * 영업기회 관리 목록 조회
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "Cmb")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {
		// FIXME 'SORT_STR'처리 CMS300T.SORT_STR
		param.put("SORT_STR", "1");
		return  super.commonDao.list("cmb200ukrvServiceImpl.getDataList", param);
	}
	
	@ExtDirectMethod(group = "Cmb")
	public List<Map<String, Object>>  selectClientList(Map param) throws Exception {
		// FIXME 'SORT_STR'처리 CMS300T.SORT_STR
		param.put("SORT_STR", "1");
		return  super.commonDao.list("cmb200ukrvServiceImpl.getDataClientList", param);
	}
	
	@ExtDirectMethod(group = "Cmb")
	public List<Map>  insertMulti(List<Map> paramList) throws Exception {
		int r = 0;
		Map rs ;
		for(Map param :paramList )	{
			param.put("START_DATE",UniliteUtil.chgDateFormat(param.get("START_DATE")));
			param.put("TARGET_DATE",UniliteUtil.chgDateFormat(param.get("TARGET_DATE")));
			//FIXME allow null 처리 후 delete DVRY_CUST_SEQ=1
			param.put("DVRY_CUST_SEQ", "1");
			param.put("PROCESS_TYPE", "1");
			rs= (Map)super.commonDao.queryForObject("cmb200ukrvServiceImpl.insertMulti", param);
			if(rs.get("PROJECT_NO")!=null)	{
				param.put("PROJECT_NO", rs.get("PROJECT_NO"));
			}
		}
		return  paramList;
	}
	

	
	@ExtDirectMethod(group = "Cmb")
	public List<Map>  updateMulti(List<Map> paramList) throws Exception {		
		int r = 0;
		for(Map param :paramList )	{
			logger.debug(ObjUtils.toJsonStr(param).toString());
			param.put("START_DATE",UniliteUtil.chgDateFormat(param.get("START_DATE")));
			param.put("TARGET_DATE",UniliteUtil.chgDateFormat(param.get("TARGET_DATE")));
			//FIXME allow null 처리 후 delete DVRY_CUST_SEQ=1, PROCESS_TYPE-1
			param.put("DVRY_CUST_SEQ", "1");
			param.put("PROCESS_TYPE", "1");
			r += super.commonDao.update("cmb200ukrvServiceImpl.updateMulti", param);
		}
		return  paramList;
	}
	
	@ExtDirectMethod(group = "Cmb")
	public List<Map>  deleteMulti(List<Map> paramList) throws Exception {
		int r = 0;
		for(Map param :paramList )	{
			r += super.commonDao.delete("cmb200ukrvServiceImpl.deleteMulti", param);
		}
		return  paramList;
	}
	
	/**
	 * @param paramList	리스트의 create, update, destroy 오퍼레이션별 정보
	 * @param paramMap 폼(마스터 정보)의 기본 정보
	 * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "Cmb")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map>  saveAll(List<Map> paramList, Map paramMap) throws Exception {
		logger.debug("[saveAl]l paramList:" + paramList + ", paramMap:" + paramMap);
		
		//1. Master 정보
		Map<String, Object> dataMaster = (Map<String, Object>) paramMap.get("data");
		dataMaster.put("pk", "pk12345");
		
		List<Map> dataList = new ArrayList<Map>();
		List<List<Map>> resultList = new ArrayList<List<Map>>();
		//2. 리스트 정보
		for(Map param : paramList) {
			dataList = (List<Map>)param.get("data");
			
			if(param.get("method").equals("insertMulti")) {			
				param.put("data",  insertMulti(dataList) );
				
			}else if(param.get("method").equals("updateMulti")) {
				param.put("data",  updateMulti(dataList) );
				
			}else if(param.get("method").equals("deleteMulti")) {
				param.put("data",  deleteMulti(dataList) );
			}
		}
		
		paramList.add(0, paramMap);
		
		return  paramList;
	}
	
	
	@ExtDirectMethod(group = "Cmb")
	public List<Map>  syncAll(Map param) throws Exception {
		logger.debug("syncAll:" + param);
		return  null;
	}
	/*
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "Cmb")
	public Integer  syncAll(Map param) throws Exception {
		logger.debug("syncAll:" + param);
		return  0;
	}*/
	
	@ExtDirectMethod(group = "Cmb")
	public List<Map>  insertClients(List<Map> paramList) throws Exception {
		int r = 0;
		
		for(Map param :paramList )	{
			
			r += super.commonDao.update("cmb200ukrvServiceImpl.insertClients", param);
		}
		return  paramList;
	}
	
	@ExtDirectMethod(group = "Cmb")
	public List<Map>  updateClients(List<Map> paramList) throws Exception {
		int r = 0;
		
		for(Map param :paramList )	{
			
			r += super.commonDao.update("cmb200ukrvServiceImpl.updateClients", param);
		}
		return  paramList;
	}
	
	@ExtDirectMethod(group = "Cmb")
	public List<Map>  deleteClients(List<Map> paramList) throws Exception {
		int r = 0;
		
		for(Map param :paramList )	{
			
			r += super.commonDao.delete("cmb200ukrvServiceImpl.deleteClients", param);
		}
		return  paramList;
	}

}
