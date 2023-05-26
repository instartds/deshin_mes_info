package foren.unilite.modules.template.tpl;

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



@Service("templateService")
public class TemplateServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	@Resource(name = "bdc100ukrvService")
	private Bdc100ukrvService bdc100ukrvService;
	/**
	 * 마스터그리드 조회
	 * 
	 * @param param
	 * @param loginVO
	 * @return
	 * @throws Exception
	 */
	@Transactional(readOnly = true)
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "template")
	public List<Map<String, Object>> selectMaster(Map param, LoginVO loginVO) throws Exception {		
		return (List) super.commonDao.list("templateServiceImpl.selectMaster", param);
	}
	
	/**
	 * 디테일그리드 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "template")
	public List<Map<String, Object>> selectDetail(Map param, LoginVO loginVO) throws Exception {
		return (List) super.commonDao.list("templateServiceImpl.selectDetail", param);
	}
	
	/**
	 * 품목분류(TreeGrid) 조회
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "template")
	public UniTreeNode selectTree(Map param, LoginVO user) throws Exception {
		List<GenericTreeDataMap> treeList = super.commonDao.list("templateServiceImpl.selectTree", param);
		
		GenericTreeDataMap rootData = new GenericTreeDataMap();
		rootData.put("id", "rootData");
		rootData.put("parentId", "root");
		rootData.put("LEVEL_NAME", "분류구성도");
		rootData.put("expanded", "true");
		treeList.add(0, rootData);

		return  UniTreeHelper.makeTreeAndGetRootNode(treeList);
	}
	/**
	 * sub그리드 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "template")
	public List<Map<String, Object>> selectSub(Map param, LoginVO loginVO) throws Exception {
		return (List) super.commonDao.list("templateServiceImpl.selectSub", param);
	}
	/**
	 * 저장
	 * @param paramList	리스트의 create, update, destroy 오퍼레이션별 정보
	 * @param paramMaster 폼(마스터 정보)의 기본 정보
	 * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "template")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {

		if(paramList != null)	{				
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("deleteMaster")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("insertMaster")) {		
					insertList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("updateMaster")) {
					updateList = (List<Map>)dataListMap.get("data");	
				}else if(dataListMap.get("method").equals("deleteDetail")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("insertDetail")) {		
					insertList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("updateDetail")) {
					updateList = (List<Map>)dataListMap.get("data");	
				} 
			}
			if(deleteList != null) this.deleteDetail(deleteList, user);
			if(insertList != null) this.insertDetail(insertList, user);
			if(updateList != null) this.updateDetail(updateList, user);				
		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	}
	
	/**
	 * Master 삭제
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt", needsModificatinAuth = true)
	public Integer deleteMaster(List<Map> paramList,  LoginVO user) throws Exception {
		 for(Map param :paramList )	{
			 try {
				 super.commonDao.delete("templateServiceImpl.deleteMaster", param);
			 }catch(Exception e)	{
	    			throw new  UniDirectValidateException(this.getMessage("547",user));//사용중인 코드는 삭제할 수 없습니다.
			 }
		 }
		 return 0;
	}
	
	/**
	 * Master 입력
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public Integer  insertMaster(List<Map> paramList, LoginVO user) throws Exception {		
		try {
			for(Map param : paramList )	{
				super.commonDao.update("templateServiceImpl.insertMaster", param);
			}
		}catch(Exception e){
			throw new  UniDirectValidateException(this.getMessage("2627", user));//중복되는 자료가 입력 되었습니다.
		}		
		return 0;
	}	
	
	/**
	 * Master 수정
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public Integer updateMaster(List<Map> paramList, LoginVO user) throws Exception {		
		 for(Map param :paramList )	{
			 super.commonDao.update("templateServiceImpl.updateMaster", param);
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
				 super.commonDao.delete("templateServiceImpl.deleteDetail", param);
			 }catch(Exception e)	{
	    			throw new  UniDirectValidateException(this.getMessage("547",user));//사용중인 코드는 삭제할 수 없습니다.
			 }
		 }
		 return 0;
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
				super.commonDao.update("templateServiceImpl.insertDetail", param);
			}
		}catch(Exception e){
			throw new  UniDirectValidateException(this.getMessage("2627", user));//중복되는 자료가 입력 되었습니다.
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
			 super.commonDao.update("templateServiceImpl.updateDetail", param);
		 }		 
		 return 0;
	} 
	
	/**
	 * 파일업로드 조회
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@ExtDirectMethod(group = "template")
	public List<Map<String, Object>> getFileList(Map param,  LoginVO login) throws Exception {
		param.put("S_COMP_CODE", login.getCompCode());
		return super.commonDao.list("templateServiceImpl.getFileList", param);
	}	
	
	/**
	 * 파일업로드 저장
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "template", value = ExtDirectMethodType.FORM_POST)
	public ExtDirectFormPostResult syncAll(Tpl106ukrvModel param, LoginVO login, BindingResult result) throws Exception {

		String docNo = param.getDOC_NO();
		param.setS_COMP_CODE(login.getCompCode());
		if (docNo != null && !"".equals(docNo)) {			
			// 첨부파일 입력/삭제
			Map rFileMap = this.syncFileList(param, login);
			if(!ObjUtils.isEmpty(rFileMap))	{
				
				param.setFILE_NO(ObjUtils.getSafeString( rFileMap.get("DOC_NO")));
			}
			
		}else {
			param.setDOC_NO(createDocNo(param, login));			
			// 첨부파일 등록			
			Map rFileMap = this.syncFileList(param, login);			
			if(!ObjUtils.isEmpty(rFileMap))	{
				param.setFILE_NO(ObjUtils.getSafeString( rFileMap.get("DOC_NO")));
			}			
		}
		ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);
		extResult.addResultProperty("DOC_NO", param.getDOC_NO());
		return extResult;
	}
	private Map syncFileList(Tpl106ukrvModel param, LoginVO login) throws Exception {
		List<Map> rList = null;
		Map rtn = null;
		if(!ObjUtils.isEmpty(param.getADD_FID()) || !ObjUtils.isEmpty(param.getDEL_FID()))	{
			
			List<Map> paramList = new ArrayList<Map>();
			Map fParam = new HashMap();
			logger.debug("@@@@@@@@@@@@@@@@@@@@@"+param.getFILE_NO());
			fParam.put("DOC_NO", param.getFILE_NO());
			fParam.put("ADD_FIDS", param.getADD_FID());
			fParam.put("DEL_FIDS", param.getDEL_FID());
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
	
	
	private String createDocNo(Tpl106ukrvModel param, LoginVO login)	{		//파일번호 자동채번		
		return (String) super.commonDao.select("templateServiceImpl.getAutoNumComp", param);
	}
	
	/**
	 * MasterForm 조회 
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.FORM_LOAD)
	public Object selectForm(Map param) throws Exception {
		return super.commonDao.select("templateServiceImpl.selectForm", param);
	}
	
	/**
	 * MasterForm 저장 
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_POST, group = "sales")
	public ExtDirectFormPostResult syncForm(Tpl100ukrvModel dataMaster,  LoginVO user,  BindingResult result) throws Exception {	
		
		ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);
		Map<String, Object> spParam = new HashMap<String, Object>();		
		spParam.put("SEQ", dataMaster.getSEQ());
		spParam.put("COL1", dataMaster.getCOL1());
		spParam.put("COL2", dataMaster.getCOL2());
		spParam.put("COL3", dataMaster.getCOL3());
		spParam.put("COL4", dataMaster.getCOL4());
		spParam.put("COL5", dataMaster.getCOL5());	
		spParam.put("S_COMP_CODE", user.getCompCode());
		spParam.put("S_USER_ID", user.getUserID());
		
		super.commonDao.update("templateServiceImpl.updateMaster", spParam);	
		return extResult;
	}
	
	/**
     * 
     * 입고 일괄 등록
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(group = "tpl", value = ExtDirectMethodType.STORE_READ)
    public List<Map<String, Object>> selectExcelUploadSheet1(Map param) throws Exception {
        return super.commonDao.list("templateServiceImpl.selectExcelUploadSheet1", param);
    }
    
    /**
     * Excel Validate
     * @param jobID
     * @param param
     */
	public void excelValidate(String jobID, Map param) {
	    logger.debug("validate: {}", jobID);
		super.commonDao.update("templateServiceImplExcelValidate", param);
	}
	
	@ExtDirectMethod(group = "tpl")
	public Object getHtml(Map param) throws Exception {
		return super.commonDao.select("templateServiceImpl.selectTest", param);
	}	
}
