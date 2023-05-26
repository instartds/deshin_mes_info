package foren.unilite.modules.accnt.agj;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.BindingResult;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.accnt.agj.Agj400ukrModel;
import foren.unilite.modules.base.bdc.Bdc100ukrvService;
import foren.unilite.modules.z_mit.S_sas200ukrv_mitModel;

@Service("agj400ukrService")
public class Agj400ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@Resource(name = "bdc100ukrvService")
	private Bdc100ukrvService bdc100ukrvService;
	
	@ExtDirectMethod(group = "Accnt", value = ExtDirectMethodType.FORM_LOAD)
	public Map selectMaster(Map param) throws Exception {
		return (Map) super.commonDao.select("agj400ukrServiceImpl.selectMaster", param);
	}
	/**
	 *  조회 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "Accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectDetail(Map param) throws Exception {
		return (List) super.commonDao.list("agj400ukrServiceImpl.selectList", param);
	}
	
	
	@ExtDirectMethod(group = "Accnt")
	public Map selectCheck1(Map param) throws Exception {
		return (Map) super.commonDao.select("agj400ukrServiceImpl.selectCheck1", param);
	}
	
	@ExtDirectMethod(group = "Accnt")
	public Map selectCheck3(Map param) throws Exception {
		return (Map) super.commonDao.select("agj400ukrServiceImpl.selectCheck1", param);
	}
	
	@ExtDirectMethod(group = "Accnt")
	public Map selectMakeSale(Map param) throws Exception {
		return (Map) super.commonDao.select("agj400ukrServiceImpl.selectMakeSale", param);
	}
	
	@ExtDirectMethod(group = "Accnt")
	public Map selectCustBankInfo(Map param) throws Exception {
		return (Map) super.commonDao.select("agj400ukrServiceImpl.selectCustBankInfo", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_POST, group = "accnt")
	public ExtDirectFormPostResult syncMaster(Agj400ukrModel param, LoginVO user, BindingResult result) throws Exception {

		
		param.setS_COMP_CODE(user.getCompCode());
		param.setS_USER_ID(user.getUserID());
		//파일 번호 생성/ fid 수정
		if(param.getADD_FID() != null ||  param.getDEL_FID() != null)	{
			this.syncFileList(param, user);
		}
		if(ObjUtils.isEmpty(param.getPAY_DRAFT_NO()))	{
			Map param2 = new HashMap();
			param2.put("S_COMP_CODE", user.getCompCode());
			param2.put("DIV_CODE", param.getDIV_CODE());
	
			String payDragtNo = (String) super.commonDao.select("agj400ukrServiceImpl.getDraftNo", param2);
			
			param.setPAY_DRAFT_NO(payDragtNo);
	
			super.commonDao.insert("agj400ukrServiceImpl.insertMaster", param);
		} else {
			super.commonDao.insert("agj400ukrServiceImpl.updateMaster", param);
		}
		
		ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);

		return extResult;
	}
	
	/**
	 * 저장
	 * @param paramList	리스트의 create, update, destroy 오퍼레이션별 정보
	 * @param paramMaster 폼(마스터 정보)의 기본 정보
	 * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "accnt")
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {	

		//2.지출결의등록마스터 로그테이블에 KEY_VALUE, OPR_FLAG 업데이트
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		
		String payDragtNo = "";
		dataMaster.put("S_COMP_CODE", user.getCompCode());
		if(ObjUtils.isEmpty(dataMaster.get("PAY_DRAFT_NO")))	{
			Map param2 = new HashMap();
			param2.put("S_COMP_CODE", user.getCompCode());
			param2.put("DIV_CODE", dataMaster.get("DIV_CODE"));
			param2.put("DEPT_CODE", dataMaster.get("DEPT_CODE"));
	
			if(dataMaster.get("ADD_FID") != null ||  dataMaster.get("DEL_FID") != null)	{
				Agj400ukrModel dataMasterModel = new Agj400ukrModel();
				dataMasterModel.setFILE_NUM(ObjUtils.getSafeString(dataMaster.get("FILE_NUM")));
				dataMasterModel.setADD_FID(ObjUtils.getSafeString(dataMaster.get("ADD_FID")));
				dataMasterModel.setDEL_FID(ObjUtils.getSafeString(dataMaster.get("DEL_FID")));
				this.syncFileList(dataMasterModel, user);
				dataMaster.put("FILE_NUM", dataMasterModel.getFILE_NUM());
			}
			
			Map payDragtNoMap = (Map) super.commonDao.select("agj400ukrServiceImpl.getDraftNo", param2);
			if(payDragtNoMap == null ) { 
				throw new  UniDirectValidateException("지출결의번호 생성하지 못했습니다. 관리자에게 문의하세요.");
			} else  if(ObjUtils.isNotEmpty( payDragtNoMap.get("ERR_DEPT_ENGCD"))) {
				throw new  UniDirectValidateException(ObjUtils.getSafeString(payDragtNoMap.get("ERR_DEPT_ENGCD")));
			}
		    payDragtNo = ObjUtils.getSafeString(payDragtNoMap.get("PAY_DRAFT_NO"));
			dataMaster.put("PAY_DRAFT_NO", payDragtNo);
	
			super.commonDao.insert("agj400ukrServiceImpl.insertMaster", dataMaster);
		} else {
			payDragtNo = ObjUtils.getSafeString(dataMaster.get("PAY_DRAFT_NO"));
			super.commonDao.insert("agj400ukrServiceImpl.updateMaster", dataMaster);
		}
		//3.지출결의등록디테일 로그테이블에 KEY_VALUE, OPR_FLAG 업데이트
		List<Map> dataList = new ArrayList<Map>();
		List<List<Map>> resultList = new ArrayList<List<Map>>();
		if(paramList != null)	{
			for(Map param: paramList) {
				dataList = (List<Map>)param.get("data");
	
				if(param.get("method").equals("deleteDetail")) {
					param.put("data", deleteDetail(dataList, user) );	
				} else if(param.get("method").equals("updateDetail")) {
					param.put("data", updateDetail(dataList) );	
				} else if(param.get("method").equals("insertDetail")) {
					param.put("data", insertDetail(dataList, payDragtNo) );	
				} 
			}
		}

		paramList.add(0, paramMaster);
				
		return  paramList;
	}
	@ExtDirectMethod( group = "accnt",value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> insertDetail(List<Map> params, String payDragtNo) throws Exception {
		
		Map seqMap = new HashMap();
		int  seq = 1;
		if(seqMap != null && params.size() > 0)	{
			seqMap = (Map) super.commonDao.select("agj400ukrServiceImpl.getSeq", params.get(0)); 
			seq = ObjUtils.parseInt(seqMap.get("SEQ"));
		}
		for(Map param: params)		{
			param.put("PAY_DRAFT_NO", payDragtNo);
			param.put("SEQ", seq);
			super.commonDao.update("agj400ukrServiceImpl.insertDetail", param);
			seq++;
		}		
		return params;
	}
	@ExtDirectMethod( group = "accnt",value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> updateDetail(List<Map> params) throws Exception {
		for(Map param: params)		{
			super.commonDao.update("agj400ukrServiceImpl.updateDetail", param);
		}		
		return params;
	}
	@ExtDirectMethod( group = "accnt" ,value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> deleteDetail(List<Map> params, LoginVO user) throws Exception {
		Map dataMaster = null;
		if(params != null && params.size() > 0)	{
			dataMaster = (Map) super.commonDao.select("agj400ukrServiceImpl.selectMaster", params.get(0));
			if(ObjUtils.isNotEmpty(dataMaster) )	{
				String confirmYn = ObjUtils.getSafeString(dataMaster.get("CONFIRM_YN"));
				int exNum = ObjUtils.parseInt(dataMaster.get("EX_NUM"), 0);
				if( (ObjUtils.isNotEmpty(confirmYn) && "Y".equals(confirmYn)) ) {
					throw new  UniDirectValidateException("확정된 내용이 있어 삭제할 수 없습니다.");
				}
				if( ObjUtils.isNotEmpty(exNum) && exNum > 0  ) {
					throw new  UniDirectValidateException("생성된 전표가 있어 삭제할 수 없습니다.");
				}
			}
			               
		}
		for(Map param: params)		{
			super.commonDao.update("agj400ukrServiceImpl.deleteDetail", param);
		}		
		//증빙서류삭제
		if(dataMaster != null && ObjUtils.isNotEmpty(dataMaster.get("FILE_NUM")))	{
			dataMaster.put("S_COMP_CODE", user.getCompCode());
			Map checkeAll = (Map)super.commonDao.select("agj400ukrServiceImpl.checkCnt", dataMaster);
			if(checkeAll != null && ObjUtils.parseInt(checkeAll.get("CNT")) == 0 )	{
				this.deleteFileList(dataMaster, user);
			}	
		}
		
		return params;
	}	
	/**
	 * cancSlipStore(자동기표취소 관련)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "accnt")	
	public Map  cancSlip(Map param, LoginVO user) throws Exception {	
		
		String sysDate = (String) super.commonDao.select("agj400ukrServiceImpl.getSysDate", param);
		//Map data = (Map)param.get("data");
		param.put("LANG_TYPE", user.getLanguage());
		param.put("CALL_PATH", "Batch");
		param.put("INPUT_DATE", sysDate );
		super.commonDao.queryForObject("agj400ukrServiceImpl.cancelSlip", param);
		
		if(ObjUtils.isNotEmpty(param.get("ERROR_DESC")))	{
			throw new  UniDirectValidateException(this.getMessage(ObjUtils.getSafeString(param.get("ERROR_DESC")), user));
		}
			
		return param;
	}
	/**
	 * autoSlipStore(지출결의자동기표 관련)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "accnt")
//	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={UniDirectValidateException.class})
	public Map<String, Object>  autoSlip( Map<String, Object> param, LoginVO user) throws Exception {
		
		String sysDate = (String) super.commonDao.select("agj400ukrServiceImpl.getSysDate", param);
		//Map data = (Map)param.get("data");
		param.put("LANG_TYPE", user.getLanguage());
		param.put("CALL_PATH", "Batch");
		param.put("INPUT_DATE", sysDate );
		super.commonDao.queryForObject("agj400ukrServiceImpl.runAutoSlip", param);
		
		if(ObjUtils.isNotEmpty(param.get("ERROR_DESC")))	{
			throw new  UniDirectValidateException(this.getMessage(ObjUtils.getSafeString(param.get("ERROR_DESC")), user));
		}
		return param;
			
	}
	/**
	 * 지출결의서 출력 master
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "Accnt")
	public List<Map<String, Object>> selectPrintMaster(Map param) throws Exception {
		return (List) super.commonDao.list("agj400ukrServiceImpl.selectPrintMaster", param);
	}
	
	/**
	 * 지출결의서 출력 detail
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "Accnt")
	public List<Map<String, Object>> selectPrintDetail(Map param) throws Exception {
		return (List) super.commonDao.list("agj400ukrServiceImpl.selectPrintDetail", param);
	}
	
	private Agj400ukrModel syncFileList(Agj400ukrModel param, LoginVO login) throws Exception {
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
}
