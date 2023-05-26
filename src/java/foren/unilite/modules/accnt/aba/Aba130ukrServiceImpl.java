package foren.unilite.modules.accnt.aba;

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
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;



@Service("aba130ukrService")
public class Aba130ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	

	
	
	/**
	 * 
	 * Master1 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectMasterList1(Map param) throws Exception {
		return super.commonDao.list("aba130ukrService.selectMasterList1", param);
	}

	
	/**
	 * 
	 * Detail 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectDetailList(Map param) throws Exception {
		return super.commonDao.list("aba130ukrService.selectDetailList", param);
	}

	/**
	 * 저장
	 * @param paramList	리스트의 create, update, destroy 오퍼레이션별 정보
	 * @param paramMaster 폼(마스터 정보)의 기본 정보
	 * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "busmaintain")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {

		if(paramList != null)	{
			List<Map> masterDataList = new ArrayList<Map>();
			List<Map> masterDeleteList = null;
			List<Map> detailInsertList = null;
			List<Map> detailUpdateList = null;
			List<Map> detailDeleteList = null;
			Map paramMasterData = null;
			if(paramMaster != null )	{
				paramMasterData = (Map) paramMaster.get("data");
			}
			for(Map dataListMap: paramList) {
				/** Master **************************************************************************************/ 
				// Master data 삭제
				if(dataListMap.get("method").equals("insertMaster") || dataListMap.get("method").equals("updateMaster")|| dataListMap.get("method").equals("deleteMaster")){
					masterDeleteList = (List<Map>)dataListMap.get("data");
				}
				
				// Master Data
				if(dataListMap.get("method").equals("insertMaster") || dataListMap.get("method").equals("updateMaster")) {
					masterDataList.addAll((List<Map>)dataListMap.get("data"));
				
				/** Detail **************************************************************************************/
				// Detail Data
				}else if(dataListMap.get("method").equals("deleteDetail")) {
					detailDeleteList = (List<Map>)dataListMap.get("data");
					
				}else if(dataListMap.get("method").equals("insertDetail")) {
					detailInsertList = (List<Map>)dataListMap.get("data");
					
				} else if(dataListMap.get("method").equals("updateDetail")) {
					detailUpdateList = (List<Map>)dataListMap.get("data");
				}
			}
			// master
			if(masterDeleteList != null) this.deleteMaster(masterDeleteList, user);
			if(masterDataList != null) this.insertMaster(masterDataList, user, paramMasterData);
			
			// detail
			if(detailDeleteList != null) this.deleteDetail(detailDeleteList, user);
			if(detailInsertList != null) this.insertDetail(detailInsertList, user);
			if(detailUpdateList != null) this.updateDetail(detailUpdateList, user);
		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	}
	
	/**
	 * Master 입력
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public Integer  insertMaster(List<Map> paramList, LoginVO user, Map paramMasterData) throws Exception {
		int rtnCnt = 0;
		try {
			boolean autoKindDivi = false;
			if(paramMasterData != null)	{
				// 자동변동표의 경우  집계항목을 KIND_DIVI2로 입력 받음
				String itemsum = ObjUtils.getSafeString(paramMasterData.get("ITEM_SUM") );
				if("35".equals(itemsum) || "36".equals(itemsum))	{
					autoKindDivi = true;
				}
			}
			// Insert Data
			for(Map param : paramList )	{
				if(autoKindDivi) 	{
					param.put("KIND_DIVI", param.get("KIND_DIVI2"));
				}
				rtnCnt += super.commonDao.update("aba130ukrService.insertMaster", param);
			}
			
		}catch(Exception e){
			throw new  UniDirectValidateException(this.getMessage("2627", user));
		}		
		return rtnCnt;
	}	
	
	/**
	 * Master 수정
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public Integer updateMaster(List<Map> paramList, LoginVO user, Map paramMasterData) throws Exception {
		return 0;
	}
	
	/**
	 * Master 삭제
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt", needsModificatinAuth = true)
	public Integer deleteMaster(List<Map> paramList, LoginVO user) throws Exception {
	
		int delCnt = super.commonDao.delete("aba130ukrService.deleteMaster", paramList.get(0));
		return delCnt;
	}
	
	/**
	 * Detail 입력
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public Integer  insertDetail(List<Map> paramList, LoginVO user) throws Exception {
		try {
			for(Map param : paramList )	{
				super.commonDao.update("aba130ukrService.insertDetail", param);
			}
		}catch(Exception e){
			throw new  UniDirectValidateException(this.getMessage("2627", user));
		}		
		return 0;
	}	
	
	/**
	 * Detail 수정
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public Integer updateDetail(List<Map> paramList, LoginVO user) throws Exception {
		 for(Map param :paramList )	{
			 super.commonDao.update("aba130ukrService.updateDetail", param);
		 }		 
		 return 0;
	} 
	
	/**
	 * Detail 삭제
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt", needsModificatinAuth = true)
	public Integer deleteDetail(List<Map> paramList,  LoginVO user) throws Exception {
		 for(Map param :paramList )	{
			 try {
				 super.commonDao.delete("aba130ukrService.deleteDetail", param);
			 }catch(Exception e)	{
	    			throw new  UniDirectValidateException(this.getMessage("547",user));
			 }
		 }
		 return 0;
	}
	
	/**
	 * 양식복사
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public Object insertFormCopy(Map spParam, LoginVO user) throws Exception{
		Map duplCheckMap1 = (Map) super.commonDao.select("aba130ukrService.duplCheck1", spParam);//원본데이터 있는지 유무 체크
		Map duplCheckMap2 = (Map) super.commonDao.select("aba130ukrService.duplCheck2", spParam);//신규에 이미 데이터 있는지중복복사 체크
		if(ObjUtils.parseInt(duplCheckMap1.get("CNT")) < 1){
			throw new UniDirectValidateException("원본 데이터가 없습니다.");
		}else if(ObjUtils.parseInt(duplCheckMap2.get("CNT")) > 0){
			throw new UniDirectValidateException(this.getMessage("55441", user));
		}else{
			super.commonDao.update("aba130ukrService.insertFormCopy1", spParam);
			super.commonDao.update("aba130ukrService.insertFormCopy2", spParam);
			super.commonDao.update("aba130ukrService.insertFormCopy3", spParam);
			return true;
		}
	} 
	
	/**
	 * 집계항목적용
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public Object  insertTotItem(Map spParam, LoginVO user) throws Exception {

		Map errorMap = (Map) super.commonDao.select("aba130ukrService.USP_ACCNT_ABA130UKR", spParam);
//		String errorDesc = (String) errorMap.get("errorDesc");
		if(!ObjUtils.isEmpty(errorMap.get("errorDesc"))){
			String errorDesc = (String) errorMap.get("errorDesc");
			String[] messsage = errorDesc.split(";");
		    throw new  UniDirectValidateException(this.getMessage(messsage[0], user));
		}else{
			return true;
		}		
//		if(errorDesc != null){
//			throw new Exception(errorDesc);			
//		}
	}
	
}
