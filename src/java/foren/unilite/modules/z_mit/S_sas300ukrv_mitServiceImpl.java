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



@Service("s_sas300ukrv_mitService")
public class S_sas300ukrv_mitServiceImpl extends TlabAbstractServiceImpl {
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
		return  super.commonDao.select("s_sas300ukrv_mitServiceImpl.selectMaster", param);
	}
	
	@Transactional(readOnly = true)
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_mit")
	public List<Map<String, Object>> selectDetail(Map param, LoginVO loginVO) throws Exception {		
		return (List) super.commonDao.list("s_sas300ukrv_mitServiceImpl.selectDetail", param);
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
	public ExtDirectFormPostResult syncMaster(S_sas300ukrv_mitModel dataMaster,  LoginVO user,  BindingResult result) throws Exception {
		
		dataMaster.setS_COMP_CODE(user.getCompCode());
		dataMaster.setS_USER_ID(user.getUserID());
		String repairNum = dataMaster.getREPAIR_NUM();
		//수리견적번호 생성
		if(ObjUtils.isEmpty(repairNum))	{
			repairNum = this.selectRepairNum(dataMaster);
			dataMaster.setREPAIR_NUM(repairNum);
		} 
		
		//파일 번호 생성/ fid 수정
		if(dataMaster.getADD_FID() != null ||  dataMaster.getDEL_FID() != null)	{
			dataMaster = this.syncFileList(dataMaster, user);
		}
		if("Y".equals(dataMaster.getINSPEC_FLAG()))	{
			dataMaster.setINSPEC_PRSN( user.getUserID());
		}
		super.commonDao.update("s_sas300ukrv_mitServiceImpl.updateMaster", dataMaster);
		if("Y".equals(dataMaster.getINSPEC_FLAG()))	{
			Map asStatusParam = new HashMap();
			asStatusParam.put("S_COMP_CODE", user.getCompCode());
			asStatusParam.put("S_USER_ID", user.getUserID());
			asStatusParam.put("DIV_CODE", dataMaster.getDIV_CODE());
			asStatusParam.put("AS_STATUS", "40"); 
			asStatusParam.put("RECEIPT_NUM", dataMaster.getRECEIPT_NUM());
			s_sas100ukrv_mitService.updateASStatus(asStatusParam);
		}
		ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);
 		extResult.addResultProperty("REPAIR_NUM", repairNum);
		return extResult;
	}
	
	@ExtDirectMethod(group = "z_mit")
	public Map<String, Object> deleteMaster(Map param, LoginVO user) throws Exception {
		Map<String, Object> repairMaster = (Map<String, Object>) this.selectMaster(param, user);
		
		if(repairMaster != null && ObjUtils.isNotEmpty(repairMaster.get("REPAIR_NUM")))	{
			
			Map<String, Object> checkInoutNum = (Map<String, Object>) super.commonDao.select("s_sas300ukrv_mitServiceImpl.selectCheckInoutNum", param);
			
			if(checkInoutNum != null && ObjUtils.isNotEmpty(checkInoutNum.get("INOUT_NUM")))	{
				throw new  UniDirectValidateException("이후 진행된 내역이 있어서 삭제불가능합니다");
			}
			
			if("30".equals(ObjUtils.getSafeString(repairMaster.get("AS_STATUS"))) )	{
				super.commonDao.delete("s_sas300ukrv_mitServiceImpl.deleteAll", param);
				this.deleteFileList(param, user);
			} else {
				throw new  UniDirectValidateException("이후 진행된 내역이 있어서 삭제불가능합니다");
			}
		} else {
			throw new  UniDirectValidateException(this.getMessage("54400", user));
		}
		
		Map asStatusParam = new HashMap();
		asStatusParam.put("S_COMP_CODE", user.getCompCode());
		asStatusParam.put("S_USER_ID", user.getUserID());
		asStatusParam.put("DIV_CODE", param.get("DIV_CODE"));
		asStatusParam.put("AS_STATUS", "20"); 
		asStatusParam.put("RECEIPT_NUM", param.get("RECEIPT_NUM"));
		s_sas100ukrv_mitService.updateASStatus(asStatusParam);
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
			Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
			if(deleteList != null)	this.deleteDetail(deleteList, user);
			if(insertList != null)	this.insertDetail(insertList, user, dataMaster);
			if(updateList != null)	this.updateDetail(updateList, user, dataMaster);
			
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
	public int selectRepairSeq(Map param) throws Exception {
		int repairSeq = 1;
		Map repairSeqMap =(Map) super.commonDao.select("s_sas300ukrv_mitServiceImpl.selectRepairSeq", param);
		if(repairSeqMap != null)	{
			repairSeq = ObjUtils.parseInt(repairSeqMap.get("REPAIR_SEQ"));
		}
		return 	repairSeq;
	}
	
	/**
	 * 소요부품 입력
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public List<Map>  insertDetail(List<Map> paramList, LoginVO user, Map<String, Object> dataMaster) throws Exception {		
		for(Map param : paramList) {
			int seq = this.selectRepairSeq(param);
			param.put("REPAIR_SEQ", seq);
			param.put("CUSTOM_CODE", dataMaster.get("CUSTOM_CODE"));
			super.commonDao.update("s_sas300ukrv_mitServiceImpl.insertDetail", param);
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
	public List<Map> updateDetail(List<Map> paramList, LoginVO user, Map<String, Object> dataMaster) throws Exception {		
		
		for(Map param :paramList )	{
			
			List<Map<String, Object>> checkInoutNum = this.selectCheckInoutNumDetail(param);
			
			if(checkInoutNum != null && checkInoutNum.size() > 0 && ObjUtils.isNotEmpty(checkInoutNum.get(0).get("INOUT_NUM")))	{
				throw new  UniDirectValidateException("이후 진행된 내역이 있어서 삭제불가능합니다");
			}
			param.put("CUSTOM_CODE", dataMaster.get("CUSTOM_CODE"));
			super.commonDao.update("s_sas300ukrv_mitServiceImpl.updateDetail", param);
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
	public List<Map> deleteDetail(List<Map> paramList, LoginVO user) throws Exception {		

		 for(Map param :paramList )	{
			 List<Map<String, Object>> checkInoutNum = this.selectCheckInoutNumDetail(param);
				
			if(checkInoutNum != null && checkInoutNum.size() > 0 && ObjUtils.isNotEmpty(checkInoutNum.get(0).get("INOUT_NUM")))	{
				throw new  UniDirectValidateException("이후 진행된 내역이 있어서 삭제불가능합니다");
			}
			 super.commonDao.update("s_sas300ukrv_mitServiceImpl.deleteDetail", param);
		 }		 
		 return paramList;
	}	
	@ExtDirectMethod(group = "z_mit")
	public String selectRepairNum(S_sas300ukrv_mitModel param) throws Exception {
		String repairNum = "";
		Map repairNumMap = (Map) super.commonDao.select("s_sas300ukrv_mitServiceImpl.selectRepairNum", param);
		if(ObjUtils.isNotEmpty(repairNumMap.get("EXISTS_REPAIR_NUM")))	{
			throw new  UniDirectValidateException("해당 접수번호는 이미 생성된 수리내용이 있습니다. 조회 후 이용하세요.");
		} else {
			repairNum = ObjUtils.getSafeString(repairNumMap.get("NEW_REPAIR_NUM"));
			
		}
		return 	repairNum;
	}

	/**
	 * 출고여부 체크
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "z_mit")
	public List<Map<String, Object>>  selectCheckInoutNumDetail(Map param) throws Exception {
	   return super.commonDao.list("s_sas300ukrv_mitServiceImpl.selectCheckInoutNumDetail", param);
	}
	
	@ExtDirectMethod(group = "z_mit")
	public List<Map<String, Object>>  selectCheckInoutNum(Map param) throws Exception {
	   return super.commonDao.list("s_sas300ukrv_mitServiceImpl.selectCheckInoutNumDetail", param);
	}
	
	@ExtDirectMethod(group = "z_mit")
	public Map updateMtr200(Map param, LoginVO user) throws Exception {
		List<Map<String, Object>>  dataList =  this.selectDetail(param, user);
		
		if(ObjUtils.isEmpty(dataList))	{
			if("D".equals( ObjUtils.getSafeString(param.get("OPR_FLAG"))))	{
				 throw new  UniDirectValidateException("출고취소 할 데이터가 없습니다.");
			} else {
				throw new  UniDirectValidateException("자재출고 할 데이터가 없습니다.");
			}
		}
		
		String keyValue = this.getLogKey();
		String inoutNum = "";
		int seq = 0;
		for(Map<String, Object> data : dataList) {
			Map<String, Object> param2 = new HashMap<String, Object>();
			
			String oprFalg = "N";
			if(ObjUtils.isNotEmpty((param.get("OPR_FLAG"))))	{
				oprFalg = ObjUtils.getSafeString(param.get("OPR_FLAG"));
			} else if(ObjUtils.isNotEmpty(data.get("INOUT_NUM"))) {
				oprFalg = "U";
			}
			
			if("N".equals(oprFalg))	{
				seq = seq +1;
				data.put("INOUT_SEQ", seq);
			} 
			
			param2.put("KEY_VALUE", keyValue);
			param2.put("OPR_FLAG", oprFalg);
			param2.put("COMP_CODE", user.getCompCode());
			param2.put("INOUT_NUM", data.get("INOUT_NUM"));
			param2.put("INOUT_SEQ", data.get("INOUT_SEQ"));
			param2.put("INOUT_TYPE", "2"); // 출고
			param2.put("DIV_CODE", data.get("DIV_CODE"));
			param2.put("INOUT_METH", "2");
			param2.put("CREATE_LOC", "2");  // 생성경로(B031), 2:자재
			param2.put("INOUT_TYPE_DETAIL", "20");  //  20: AS출고 (수불유형      : (S006, S007, S008, M103, M104))
			param2.put("INOUT_CODE_TYPE", "1");		//  1: 부서(수불처구분    : (B005)  )
			param2.put("INOUT_CODE", user.getDeptCode());
			param2.put("INOUT_CODE_DETAIL", "");
			param2.put("ITEM_CODE", data.get("ITEM_CODE"));
			param2.put("WH_CODE", data.get("WH_CODE"));
			param2.put("WH_CELL_CODE", data.get("WH_CELL_CODE"));
			param2.put("INOUT_Q", data.get("AS_QTY"));
			param2.put("INOUT_P", data.get("AS_PRICE"));
			param2.put("INOUT_I", data.get("AS_AMT"));
			param2.put("MONEY_UNIT", user.getCurrency());
			param2.put("ORDER_NUM", data.get("REPAIR_NUM"));
			param2.put("BASIS_SEQ", data.get("REPAIR_SEQ"));
			param2.put("PROJECT_NO", "");
			param2.put("PJT_CODE", "");
			param2.put("LOT_NO", data.get("LOT_NO"));
			param2.put("REMARK", data.get("AS_REMARK"));
			param2.put("S_USER_ID", user.getUserID());
			
			super.commonDao.insert("s_sas300ukrv_mitServiceImpl.insertLogMaster", param2);
		}
		
		Map<String, Object> spParam = new HashMap<String, Object>();
		spParam.put("KEY_VALUE", keyValue);

        super.commonDao.queryForObject("s_sas300ukrv_mitServiceImpl.spReseving", spParam);
		
        String errorDesc = ObjUtils.getSafeString(spParam.get("ERROR_DESC"));

		if(!ObjUtils.isEmpty(errorDesc)){
            throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
		} else {
			
			for(Map<String, Object> data : dataList) {
				if("D".equals(ObjUtils.getSafeString(param.get("OPR_FLAG"))))	{
					data.put("INOUT_NUM", "");								// 출고취소	
					data.put("INOUT_SEQ", 0);
					data.put("S_USER_ID", user.getUserID());
					data.put("KEY_VALUE", keyValue);
					super.commonDao.update("s_sas300ukrv_mitServiceImpl.updateInoutNum", data);
				} else if(!"D".equals(ObjUtils.getSafeString(param.get("OPR_FLAG")))) {
					data.put("KEY_VALUE", keyValue);
					Map logData = (Map) super.commonDao.select("s_sas300ukrv_mitServiceImpl.selectLogInoutNum", data);
					logData.put("S_USER_ID", user.getUserID());
					super.commonDao.update("s_sas300ukrv_mitServiceImpl.updateInoutNum", logData);
				}
				
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

	private S_sas300ukrv_mitModel syncFileList(S_sas300ukrv_mitModel param, LoginVO login) throws Exception {
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

	/**
	 * 수리완료보고서 출력
	 * @param param
	 * @param loginVO
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_mit")
	public List<Map<String, Object>> selectPrint(Map param, LoginVO loginVO) throws Exception {		
		return (List) super.commonDao.list("s_sas300ukrv_mitServiceImpl.selectPrint", param);
	}

	/**
	 * 자재출고요청서 출력
	 * @param param
	 * @param loginVO
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_mit")
	public List<Map<String, Object>> selectPrintMOutReq(Map param, LoginVO loginVO) throws Exception {		
		return (List) super.commonDao.list("s_sas300ukrv_mitServiceImpl.selectPrintMOutReq", param);
	}
	
}
