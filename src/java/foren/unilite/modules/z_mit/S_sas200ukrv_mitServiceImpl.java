package foren.unilite.modules.z_mit;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.BindingResult;

import com.google.gson.Gson;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.lib.tree.GenericTreeDataMap;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.base.bdc.Bdc100ukrvService;
import foren.unilite.modules.com.tree.UniTreeHelper;
import foren.unilite.modules.com.tree.UniTreeNode;



@Service("s_sas200ukrv_mitService")
public class S_sas200ukrv_mitServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@Resource(name = "bdc100ukrvService")
	private Bdc100ukrvService bdc100ukrvService;
	
	@Resource(name = "s_sas100ukrv_mitService")
	private S_sas100ukrv_mitServiceImpl s_sas100ukrv_mitService;
	/**
	 * 마스터폼조회
	 * 
	 * @param param
	 * @param loginVO
	 * @return
	 * @throws Exception
	 */
	@Transactional(readOnly = true)
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_LOAD, group = "z_mit")
	public Object selectMaster(Map param, LoginVO loginVO) throws Exception {		
		return  super.commonDao.select("s_sas200ukrv_mitServiceImpl.selectMaster", param);
	}
	
	@Transactional(readOnly = true)
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_mit")
	public List<Map<String, Object>> selectDetail(Map param, LoginVO loginVO) throws Exception {		
		return (List) super.commonDao.list("s_sas200ukrv_mitServiceImpl.selectDetail", param);
	}
	
	/**
	 * 저장
	 * @param paramList	리스트의 create, update, destroy 오퍼레이션별 정보
	 * @param paramMaster 폼(마스터 정보)의 기본 정보
	 * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_POST, group = "z_mit")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public ExtDirectFormPostResult syncMaster(S_sas200ukrv_mitModel dataMaster,  LoginVO user,  BindingResult result) throws Exception {
		
		dataMaster.setS_COMP_CODE(user.getCompCode());
		dataMaster.setS_USER_ID(user.getUserID());
		
		String quotNum = dataMaster.getQUOT_NUM();
		//수리견적번호 생성
		if(ObjUtils.isEmpty(quotNum))	{
			quotNum = this.selectQuotNum(dataMaster);
			dataMaster.setQUOT_NUM(quotNum);
		} 
		
		//파일 번호 생성/ fid 수정
		if(dataMaster.getADD_FID() != null ||  dataMaster.getDEL_FID() != null)	{
			dataMaster = this.syncFileList(dataMaster, user);
		}
		
		super.commonDao.update("s_sas200ukrv_mitServiceImpl.updateMaster", dataMaster);
		
		if(ObjUtils.isNotEmpty(dataMaster.getRECEIPT_NUM()))	{
			
			Map param = new HashMap();
			param.put("S_COMP_CODE", dataMaster.getS_COMP_CODE());
			param.put("S_USER_ID", user.getUserID());
			param.put("DIV_CODE", dataMaster.getDIV_CODE());
			param.put("RECEIPT_NUM", dataMaster.getRECEIPT_NUM());
			param.put("AS_STATUS", "20");  // 견적
			
			Map receiptData = (Map) super.commonDao.select("s_sas100ukrv_mitServiceImpl.selectMaster", param);
			if("10".equals(receiptData.get("AS_STATUS")))	{
				s_sas100ukrv_mitService.updateASStatus(param);
			}
		}
		ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);
 		extResult.addResultProperty("QUOT_NUM", quotNum);
		return extResult;
	}
	
	@ExtDirectMethod(group = "z_mit")
	public Map<String, Object> deleteMaster(Map param, LoginVO user) throws Exception {
		Map<String, Object> quotMaster = (Map<String, Object>) this.selectMaster(param, user);
		if(quotMaster != null && ObjUtils.isNotEmpty(quotMaster.get("QUOT_NUM")))	{
			if("20".equals(ObjUtils.getSafeString(quotMaster.get("AS_STATUS"))) )	{
				super.commonDao.delete("s_sas200ukrv_mitServiceImpl.deleteAll", param);
				this.deleteFileList(param, user);
				// 전체 삭제 후 상태 update
				Map asStatusParam = new HashMap();
				asStatusParam.put("S_COMP_CODE", user.getCompCode());
				asStatusParam.put("S_USER_ID", user.getUserID());
				asStatusParam.put("DIV_CODE", param.get("DIV_CODE"));
				asStatusParam.put("AS_STATUS", "10");
				asStatusParam.put("RECEIPT_NUM", quotMaster.get("RECEIPT_NUM"));
				s_sas100ukrv_mitService.updateASStatus(asStatusParam);
			} else {
				throw new  UniDirectValidateException("이후 진행된 내역이 있어서 삭제불가능합니다");
			}
		} else {
			throw new  UniDirectValidateException(this.getMessage("54400", user));
		}
		
		Map rMap = new HashMap();
		rMap.put("success", "true");
		return rMap;
	}	
	
	
	/**
	 * 저장
	 * @param paramList	리스트의 create, update, destroy 오퍼레이션별 정보
	 * @param paramMaster 폼(마스터 정보)의 기본 정보
	 * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "z_mit")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		
		Map<String, Object> paramMasterData = (Map<String, Object>) paramMaster.get("data");
		
		S_sas200ukrv_mitModel masterModel = new S_sas200ukrv_mitModel();
		masterModel.setS_COMP_CODE(user.getCompCode());
		masterModel.setDIV_CODE(ObjUtils.getSafeString(paramMasterData.get("DIV_CODE")));
		masterModel.setQUOT_NUM(ObjUtils.getSafeString(paramMasterData.get("QUOT_NUM")));
		masterModel.setQUOT_DATE(ObjUtils.getSafeString(paramMasterData.get("QUOT_DATE")));
		masterModel.setQUOT_PRSN(ObjUtils.getSafeString(paramMasterData.get("QUOT_PRSN")));
		masterModel.setREPAIR_RANK(ObjUtils.getSafeString(paramMasterData.get("REPAIR_RANK")));
		masterModel.setCOST_YN(ObjUtils.getSafeString(paramMasterData.get("COST_YN")));
		masterModel.setBAD_REMARK(ObjUtils.getSafeString(paramMasterData.get("BAD_REMARK")));
		masterModel.setREMARK(ObjUtils.getSafeString(paramMasterData.get("REMARK")));
		masterModel.setRECEIPT_NUM(ObjUtils.getSafeString(paramMasterData.get("RECEIPT_NUM")));
		masterModel.setFILE_NUM(ObjUtils.getSafeString(paramMasterData.get("FILE_NUM")));
		masterModel.setS_USER_ID(user.getUserID());
		
		if(ObjUtils.isEmpty(masterModel.getQUOT_NUM()))	{
			String quotNum = this.selectQuotNum(masterModel);
			masterModel.setQUOT_NUM(quotNum);
			paramMasterData.put("QUOT_NUM", quotNum);
		}
		
	    super.commonDao.update("s_sas200ukrv_mitServiceImpl.updateMaster", masterModel);
	    
	    if(ObjUtils.isNotEmpty(masterModel.getRECEIPT_NUM()))	{
			Map param = new HashMap();
			param.put("S_COMP_CODE", masterModel.getS_COMP_CODE());
			param.put("S_USER_ID", user.getUserID());
			param.put("DIV_CODE", masterModel.getDIV_CODE());
			param.put("RECEIPT_NUM", masterModel.getRECEIPT_NUM());
			param.put("AS_STATUS", "20");  // 견적
			
			Map receiptData = (Map) super.commonDao.select("s_sas100ukrv_mitServiceImpl.selectMaster", param);
			if("10".equals(receiptData.get("AS_STATUS")))	{
				s_sas100ukrv_mitService.updateASStatus(param);
			}
		}
	     
		if(paramList != null)	{				
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("deleteDetail")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("insertDetail")) {		
					insertList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("updateDetail")) {
					updateList = (List<Map>)dataListMap.get("data");	
				}
			}
			
			if(deleteList != null)	this.deleteDetail(deleteList, user, paramMasterData);
			if(insertList != null)	this.insertDetail(insertList, user, paramMasterData);
			if(updateList != null)	this.updateDetail(updateList, user, paramMasterData);
			
		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	}
	
	/**
	 * 견적소모품 순번
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "z_mit")
	public int selectQuotSeq(Map param) throws Exception {
		int quotSeq = 1;
		Map quotSeqMap =(Map) super.commonDao.select("s_sas200ukrv_mitServiceImpl.selectQuotSeq", param);
		if(quotSeqMap != null)	{
			quotSeq = ObjUtils.parseInt(quotSeqMap.get("QUOT_SEQ"));
		}
		return 	quotSeq;
	}
	
	/**
	 * 소요부품 입력
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_mit")
	public List<Map>  insertDetail(List<Map> paramList, LoginVO user, Map<String, Object> paramMasterData) throws Exception {		
		for(Map param : paramList) {
			if(ObjUtils.isEmpty(param.get("QUOT_NUM")))	{
				param.put("QUOT_NUM", paramMasterData.get("QUOT_NUM"));
			}
			int seq = this.selectQuotSeq(param);
			param.put("QUOT_SEQ", seq);
			super.commonDao.update("s_sas200ukrv_mitServiceImpl.insertDetail", param);
		}
		return paramList;
	}	
	
	/**
	 * 소요부품 수정
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_mit")
	public List<Map> updateDetail(List<Map> paramList, LoginVO user, Map<String, Object> paramMasterData) throws Exception {		
		 for(Map param :paramList )	{
			if(ObjUtils.isEmpty(param.get("QUOT_NUM")))	{
					param.put("QUOT_NUM", paramMasterData.get("QUOT_NUM"));
			}
			super.commonDao.update("s_sas200ukrv_mitServiceImpl.updateDetail", param);
		 }		 
		 return paramList;
	}
	/**
	 * 소요부품 삭제
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_mit")
	public List<Map> deleteDetail(List<Map> paramList, LoginVO user, Map<String, Object> paramMasterData) throws Exception {		
		 for(Map param :paramList )	{
			 if(ObjUtils.isEmpty(param.get("QUOT_NUM")))	{
				param.put("QUOT_NUM", paramMasterData.get("QUOT_NUM"));
			 }
			 super.commonDao.update("s_sas200ukrv_mitServiceImpl.deleteDetail", param);
		 }		 
		 return paramList;
	}	
	@ExtDirectMethod(group = "z_mit")
	public String selectQuotNum(S_sas200ukrv_mitModel param) throws Exception {
		String quotNum = "";
		quotNum =(String) super.commonDao.select("s_sas200ukrv_mitServiceImpl.selectQuotNum", param);
		return 	quotNum;
	}

	private S_sas200ukrv_mitModel syncFileList(S_sas200ukrv_mitModel param, LoginVO login) throws Exception {
        List<Map> rList = null;
        Map rtn = null;
        if(!ObjUtils.isEmpty(param.getADD_FID()) || !ObjUtils.isEmpty(param.getDEL_FID()))  {
            
            List<Map> paramList = new ArrayList<Map>();
            Map fParam = new HashMap();
            fParam.put("DOC_NO", param.getFILE_NUM());
            fParam.put("ADD_FIDS", param.getADD_FID());
            fParam.put("DEL_FIDS", param.getDEL_FID());
            fParam.put("S_COMP_CODE", login.getCompCode());
            fParam.put("S_USER_ID", login.getUserID());
            fParam.put("S_DEPT_CODE", login.getDeptCode());
            fParam.put("AUTH_LEVEL", login.getAuthorityLevel());
            paramList.add(fParam);
            
            if(ObjUtils.isEmpty(param.getFILE_NUM()))    {
                rList = bdc100ukrvService.insertMulti(paramList, login);
                for(Map rMap : rList) {
                	param.setFILE_NUM(ObjUtils.getSafeString(rMap.get("DOC_NO")));
                }
            }else {
                rList = bdc100ukrvService.updateMulti(paramList, login);
            }
        }
        
        return param;
    }
	
	private Map deleteFileList(Map param, LoginVO login) throws Exception {
        List<Map> rList = null;
        Map rtn = null;
        if(!ObjUtils.isEmpty(param.get("FILE_NUM")) )  {
            
            List<Map> paramList = new ArrayList<Map>();
            Map fParam = new HashMap();
            fParam.put("DOC_NO", param.get("FILE_NUM"));
            fParam.put("S_COMP_CODE", login.getCompCode());
            fParam.put("S_USER_ID", login.getUserID());
            fParam.put("S_DEPT_CODE", login.getDeptCode());
            fParam.put("AUTH_LEVEL", login.getAuthorityLevel());
            paramList.add(fParam);
            
            bdc100ukrvService.deleteMulti(paramList, login);
            
        }
        
        return param;
    }
	
	/**
	 * 견적서 출력
	 * @param param
	 * @param loginVO
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_mit")
	public List<Map<String, Object>> selectPrint(Map param, LoginVO loginVO) throws Exception {		
		return (List) super.commonDao.list("s_sas200ukrv_mitServiceImpl.selectPrint", param);
	}
	
}
