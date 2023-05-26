package foren.unilite.modules.crm.cmd;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.validation.BindingResult;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.modules.base.bdc.Bdc100ukrvService;
import foren.unilite.modules.com.fileman.FileMnagerService;

@Service("cmd100ukrvService")
public class Cmd100ukrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger	logger	= LoggerFactory.getLogger(this.getClass());	
	
	@Resource(name = "fileMnagerService")
	private FileMnagerService fileMnagerService;
	@Resource(name = "bdc100ukrvService")
	private Bdc100ukrvService bdc100ukrvService;
	/**
	 * 일일영업활동 목록 조회
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "Cmd")
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return super.commonDao.list("cmd100ukrvServiceImpl.getDataList", param);
	}

	/**
	 * 일일영업활동 조회
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "Cmd", value = ExtDirectMethodType.FORM_LOAD)
	public Object select(Map param) throws Exception {
		return super.commonDao.select("cmd100ukrvServiceImpl.getData", param);
	}


	private String createDocNo(Cmd100ukrvModel param, LoginVO login)	{
		
		return (String) super.commonDao.select("cmd100ukrvServiceImpl.getAutoNumComp", param);
	}


	/**
	 * 일일영업활동 저장
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "Cmd", value = ExtDirectMethodType.FORM_POST)
	public ExtDirectFormPostResult syncAll(Cmd100ukrvModel param, LoginVO login, BindingResult result) throws Exception {

		//ExtDirectFormPostResult result ;
		
		String actionType = param.getACTION_TYPE();
		String docNo = param.getDOC_NO();
		param.setS_COMP_CODE(login.getCompCode());
		param.setS_AUTHORITY_LEVEL(login.getAuthorityLevel());
		param.setS_USER_ID(login.getUserID());
		param.setCREATE_EMP(login.getUserID());
		
		if(ObjUtils.isEmpty(param.getPLAN_GROUP_YN()))	{
			param.setPLAN_GROUP_YN("N");
		}
		if(ObjUtils.isEmpty(param.getPLAN_DATE()))	{
			param.setPLAN_DATE(" ");
		}
		if(ObjUtils.isEmpty(param.getRESULT_DATE()))	{
			param.setRESULT_DATE(" ");
		}
		if(ObjUtils.isEmpty(param.getSALE_STATUS()) ) {
			param.setSALE_STATUS(" ");
		}
		if(ObjUtils.isEmpty(param.getPROJECT_NO())) {
			param.setPROJECT_NO(" ");
		}		
		if (docNo != null && !"".equals(docNo)) {
			
			// 첨부파일 입력/삭제
			Map rFileMap = this.syncFileList(param, login);
			if(!ObjUtils.isEmpty(rFileMap))	{
				
				param.setFILE_NO(ObjUtils.getSafeString( rFileMap.get("DOC_NO")));
			}
			// 데이타 저장
			update(param,login);
			
		}else {
			param.setDOC_NO(createDocNo(param, login));	
			
			if(ObjUtils.isEmpty(param.getSALE_STATUS()) ) {
				param.setSALE_STATUS(" ");
			}
			if(ObjUtils.isEmpty(param.getPROJECT_NO())) {
				param.setPROJECT_NO(" ");
			}
			
			// 첨부파일 등록
			
			Map rFileMap = this.syncFileList(param, login);
			
			if(!ObjUtils.isEmpty(rFileMap))	{
				param.setFILE_NO(ObjUtils.getSafeString( rFileMap.get("DOC_NO")));
			}
			
			insert(param, login);
			
		}
		ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);
		extResult.addResultProperty("DOC_NO", param.getDOC_NO());
		return extResult;
	}
	
	private  Cmd100ukrvModel cleanParam (Cmd100ukrvModel param) {
		if(ObjUtils.isEmpty(param.getRESULT_CLIENT())) {
			param.setRESULT_CLIENT("0");
		}
		if(ObjUtils.isEmpty(param.getRESULT_DATE())) {
			param.setRESULT_DATE(" ");
		}
		if(ObjUtils.isEmpty(param.getCUSTOM_CODE())) {
			param.setCUSTOM_CODE(" ");
		}
		if(ObjUtils.isEmpty(param.getDVRY_CUST_SEQ())) {
			param.setDVRY_CUST_SEQ(" ");
		}
		if(ObjUtils.isEmpty(param.getPROCESS_TYPE())) {
			param.setPROCESS_TYPE(" ");
		}
		if(ObjUtils.isEmpty(param.getPROJECT_NO())) {
			param.setPROJECT_NO(" ");
		}
		if(ObjUtils.isEmpty(param.getSALE_EMP())) {
			param.setSALE_EMP(" ");
		}
		if(ObjUtils.isEmpty(param.getSALE_STATUS())) {
			param.setSALE_STATUS(" ");
		}
		
		
		return param;
	}

	/**
	 * 일일영업활동 등록
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "Cmd")
	public String insert(Cmd100ukrvModel param, LoginVO login) throws Exception {
		Object rv = super.commonDao.queryForObject("cmd100ukrvServiceImpl.insert", param);
		if(!ObjUtils.isEmpty(param.getPROJECT_NO()))	{
			Map SalesProjParam = new HashMap();
			SalesProjParam.put("PROJECT_NO", param.getPROJECT_NO());
			this.updateSalesProjection(SalesProjParam, login);
		}
		return (String)rv;
	}

	/**
	 * 일일영업활동 수정
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "Cmd")
	public int update(Cmd100ukrvModel param,  LoginVO login) throws Exception {
		int rtn = (Integer) super.commonDao.update("cmd100ukrvServiceImpl.update", param);
		//영업기회관리 확률정보 update
		if(!ObjUtils.isEmpty(param.getPROJECT_NO()))	{
			Map SalesProjParam = new HashMap();
			SalesProjParam.put("PROJECT_NO", param.getPROJECT_NO());
			this.updateSalesProjection(SalesProjParam, login);
		}
		return rtn;
	}

	/**
	 * 일일영업활동 삭제
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "Cmd")
	public int deleteOne(Map param,  LoginVO login) throws Exception {
	
		List<Map> paramList = new ArrayList<Map>();
		Map fParam = new HashMap();
		fParam.put("S_COMP_CODE",login.getCompCode());	
		fParam.put("DOC_NO",param.get("FILE_NO"));		
		paramList.add(fParam);
		bdc100ukrvService.deleteMulti(paramList, login);
		int rtn = (Integer) super.commonDao.delete("cmd100ukrvServiceImpl.delete", param);
		//영업기회관리 확률정보 update
		this.updateSalesProjection(param, login);
		return rtn;
	}
	

	private Map syncFileList(Cmd100ukrvModel param, LoginVO login) throws Exception {
		List<Map> rList = null;
		Map rtn = null;
		if(!ObjUtils.isEmpty(param.getADD_FID()) || !ObjUtils.isEmpty(param.getDEL_FID()))	{
			
			List<Map> paramList = new ArrayList<Map>();
			Map fParam = new HashMap();
			logger.debug("@@@@@@@@@@@@@@@@@@@@@"+param.getFILE_NO());
			fParam.put("DOC_NO", param.getFILE_NO());
			fParam.put("DOC_NAME", "[영업일보] "+param.getSUMMARY_STR());
			fParam.put("ADD_FIDS", param.getADD_FID());
			fParam.put("DEL_FIDS", param.getDEL_FID());
			fParam.put("CUSTOM_CODE", param.getCUSTOM_CODE());
			fParam.put("PROJECT_NO", param.getPROJECT_NO());
			fParam.put("S_COMP_CODE", login.getCompCode());
			fParam.put("S_USER_ID", login.getUserID());
			fParam.put("S_DEPT_CODE", login.getDeptCode());
			fParam.put("AUTH_LEVEL", login.getAuthorityLevel());
			paramList.add(fParam);
			if(ObjUtils.isEmpty(param.getFILE_NO()))	{
				rList = bdc100ukrvService.insertMulti(paramList, login);
			}else {
				rList = bdc100ukrvService.updateMulti(paramList, login);
			}

		}
		
		if (!ObjUtils.isEmpty(rList))	rtn = rList.get(0);
		
		return rtn;
	}
	
	private void updateSalesProjection(Map param, LoginVO login)	{
		 param.put("S_COMP_CODE", login.getCompCode());
		 super.commonDao.update("cmd100ukrvServiceImpl.updateSalesProjection", param); 
	}

	
}
