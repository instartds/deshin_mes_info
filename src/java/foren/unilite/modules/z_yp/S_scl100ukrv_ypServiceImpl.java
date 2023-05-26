package foren.unilite.modules.z_yp;

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

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import ch.ralscha.extdirectspring.util.ParametersResolver;
import foren.framework.extjs.UniliteExtjsUtils;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.base.bdc.Bdc100ukrvService;
import foren.unilite.modules.com.fileman.FileMnagerService;
import foren.unilite.modules.sales.SalesCommonServiceImpl;

@Service("s_scl100ukrv_ypService")
@SuppressWarnings({"rawtypes", "unchecked"})
public class S_scl100ukrv_ypServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	

	@Resource(name="salesCommonService")
	private SalesCommonServiceImpl SalesUtil;
	@Resource( name = "bdc100ukrvService" )
	private Bdc100ukrvService bdc100ukrvService;

	/**
	 * 
	 * 클레임정보 팝업 조회(Master)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectClaimNoMasterList(Map param) throws Exception {
		return super.commonDao.list("s_scl100ukrv_ypServiceImpl.selectClaimNoMasterList", param);
	}
	
	/**
	 * 
	 * 클레임정보 팝업 조회(Detail)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectClaimNoDetailList(Map param) throws Exception {
		return super.commonDao.list("s_scl100ukrv_ypServiceImpl.selectClaimNoDetailList", param);
	}


	/**
	 * 
	 * 클레임정보 Detail 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectDetailList(Map param) throws Exception {
		return super.commonDao.list("s_scl100ukrv_ypServiceImpl.selectDetailList", param);
	}
	
	/**
	 * 
	 * 출고참조 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectSaleReferList(Map param) throws Exception {
		return super.commonDao.list("s_scl100ukrv_ypServiceImpl.selectSaleReferList", param);
	}


	/**
	 * 클레임정보 저장
	 * @param paramList	리스트의 create, update, destroy 오퍼레이션별 정보
	 * @param paramMaster 폼(마스터 정보)의 기본 정보
	 * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		//1.CLAIM_NO 없으면 자동 채번 후, SCL100T에 INSERT
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		String claimNo = "";
		String oprFlag = "";
		
		if (ObjUtils.isEmpty(dataMaster.get("CLAIM_NO") )) {
			dataMaster.put("TABLE_NAME", "SCL100T");
			Map<String, Object> autoNum = (Map<String, Object>)super.commonDao.select("s_scl100ukrv_ypServiceImpl.autoNum", dataMaster);
			claimNo = ObjUtils.getSafeString(autoNum.get("CLAIM_NO"));				
			dataMaster.put("CLAIM_NO"	, claimNo);
			dataMaster.put("FILE_NO"	, claimNo);
			super.commonDao.insert("s_scl100ukrv_ypServiceImpl.insertMaster", dataMaster);
		} else {
			claimNo = (String) dataMaster.get("CLAIM_NO");
		}
		
		
		//2.클레임디테일 데이터 INSERT
		List<Map> dataList = new ArrayList<Map>();
//		List<List<Map>> resultList = new ArrayList<List<Map>>();
		if(paramList != null)	{
			for(Map param: paramList) {
				dataList = (List<Map>)param.get("data");
				if(param.get("method").equals("insertDetail")) {
					this.insertDetail(dataList, claimNo, user);
					oprFlag = "N";
				} else if(param.get("method").equals("updateDetail")) {
					this.updateDetail(dataList, user);
					oprFlag = "U";
				} else if(param.get("method").equals("deleteDetail")) {
					this.deleteDetail(dataList, user, dataMaster);
					oprFlag = "D";
				}
			}
		}
		
		//클레임번호 마스터에 SET
		dataMaster.put("CLAIM_NO", ObjUtils.getSafeString(claimNo));
		//클레임번호 그리드에 SET
		for(Map param: paramList) {
			dataList = (List<Map>)param.get("data");	
			if(param.get("method").equals("insertDetail")) {
				List<Map> datas = (List<Map>)param.get("data");
				for(Map data: datas){
					data.put("CLAIM_NO", ObjUtils.getSafeString(claimNo));
				}
			}
		}
		
		// 파일 업로드 관련
		dataMaster.put("S_COMP_CODE", user.getCompCode());
		
		// 첨부파일 입력/삭제
		Map rFileMap = this.syncFileList(dataMaster, user, oprFlag);
		if (!ObjUtils.isEmpty(rFileMap)) {
			dataMaster.put("FILE_NO", ObjUtils.getSafeString(rFileMap.get("DOC_NO")));
		}

		//5.클레임마스터 정보 + 클레임디테일 정보 결과셋 리턴
		//마스터정보가 없을 경우에도 작성
		paramList.add(0, paramMaster);
				
		return  paramList;
	}
	
	/**
	 * 클레임디테일  저장
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> insertDetail(List<Map> params, String claimNo, LoginVO user) throws Exception {
		for(Map param: params)		{
			param.put("CLAIM_NO", claimNo);
			
			super.commonDao.insert("s_scl100ukrv_ypServiceImpl.insertDetail", param);

			param.put("FLAG"		, "N");
			param.put("ERROR_DESC"	, "");
			super.commonDao.update("s_scl100ukrv_ypServiceImpl.SP_Sales_Claim", param);
			String errorDesc = ObjUtils.getSafeString(param.get("ERROR_DESC"));
			if(!ObjUtils.isEmpty(errorDesc)) {
				throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
			} 
		}		
		return params;
	}

	/**
	 * 클레임디테일 수정
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> updateDetail(List<Map> params, LoginVO user) throws Exception {
		for(Map param: params)		{
			super.commonDao.insert("s_scl100ukrv_ypServiceImpl.updateDetail", param);

			param.put("FLAG"		, "U");
			param.put("ERROR_DESC"	, "");
			super.commonDao.update("s_scl100ukrv_ypServiceImpl.SP_Sales_Claim", param);
			String errorDesc = ObjUtils.getSafeString(param.get("ERROR_DESC"));
			if(!ObjUtils.isEmpty(errorDesc)) {
				throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
			} 
		}		
		return params;
	}
	
	
	/**
	 * 클레임디테일 삭제
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_MODIFY)
	public void deleteDetail(List<Map> params, LoginVO user, Map dataMaster) throws Exception {
		Map detailCount = new HashMap();
		for(Map<String, Object> param : params)	{
			param.put("FLAG"		, "D");
			param.put("ERROR_DESC"	, "");
			super.commonDao.update("s_scl100ukrv_ypServiceImpl.SP_Sales_Claim", param);
			String errorDesc = ObjUtils.getSafeString(param.get("ERROR_DESC"));
			if(!ObjUtils.isEmpty(errorDesc)) {
				throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
			} 

			detailCount = (Map) super.commonDao.select("s_scl100ukrv_ypServiceImpl.deleteDetail", param);
		}
		if(detailCount.get("COUNT").equals(0)) {
			super.commonDao.select("s_scl100ukrv_ypServiceImpl.deleteMaster", dataMaster);
		}
	}
	
	
	
	/**
	 * 파일업로드 저장
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	private Map syncFileList( Map dataMaster, LoginVO user, String oprFlag ) throws Exception {
		List<Map> rList = null;
		Map rtn = null;
		if (!ObjUtils.isEmpty(dataMaster.get("ADD_FID")) || !ObjUtils.isEmpty(dataMaster.get("DEL_FID"))) {
			List<Map> paramList = new ArrayList<Map>();
			Map fParam = new HashMap();
			logger.debug("@@@@@@@@@@@@@@@@@@@@@" + dataMaster.get("FILE_NO"));
			fParam.put("DOC_NO"		, dataMaster.get("FILE_NO"));
			fParam.put("FILE_NO"	, dataMaster.get("FILE_NO"));
			fParam.put("ADD_FIDS"	, dataMaster.get("ADD_FID"));
			fParam.put("DEL_FIDS"	, dataMaster.get("DEL_FID"));
			fParam.put("S_COMP_CODE", user.getCompCode());
			fParam.put("S_USER_ID"	, user.getUserID());
			fParam.put("S_DEPT_CODE", user.getDeptCode());
			fParam.put("AUTH_LEVEL"	, user.getAuthorityLevel());
			paramList.add(fParam);
			
			logger.debug("@@@@@@@@@@@@@@@@@@@@@" + dataMaster.get("ADD_FID"));
			
			if ("N".equals(oprFlag)) {
				rList = bdc100ukrvService.insertMulti(paramList, user);
			} else /*if ("U".equals(oprFlag)) */{
				rList = bdc100ukrvService.updateMulti(paramList, user);
			}
		} else {
			List<Map> paramList = new ArrayList<Map>();
			Map fParam = new HashMap();
			fParam.put("DOC_NO"		, dataMaster.get("FILE_NO"));
			fParam.put("S_COMP_CODE", user.getCompCode());
			paramList.add(fParam);
			
			if (ObjUtils.isNotEmpty(dataMaster.get("FILE_NO"))) {	 //확인필요
				if ("D".equals(oprFlag)) {
					rList = bdc100ukrvService.deleteMulti(paramList, user);
				}
			}
		}
		if (!ObjUtils.isEmpty(rList)) rtn = rList.get(0);
		return rtn;
	}
	
	
	/**
	 * 파일업로드 조회
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "sales" )
	public List<Map<String, Object>> getFileList( Map param, LoginVO login ) throws Exception {
		param.put("S_COMP_CODE", login.getCompCode());
		return super.commonDao.list("s_scl100ukrv_ypServiceImpl.getFileList", param);
	}
}
