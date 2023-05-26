package foren.unilite.modules.accnt.aha;

import java.awt.FileDialog;
import java.awt.Frame;
import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.slf4j.Logger;

import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.BindingResult;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.accnt.atx.Atx305ukrServiceImpl;


@Service("aha990ukrService")
public class Aha990ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@Resource(name="atx305ukrService")
	private Atx305ukrServiceImpl atx305ukrService;
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "accnt")
	public List<Map<String, Object>>  getDivList(Map param) throws Exception {		
		return  super.commonDao.list("atx305ukrServiceImpl.divList", param);
	}
	
	/**
	 * get Default TaxYM
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public Map selectDefaultTaxYM(Map param) throws Exception {
		return (Map) super.commonDao.select("aha990ukrServiceImpl.selectDefaultTaxYM", param);
	}
	
	/**
	 * get TaxYM
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")	
	public Map selectTaxYM(Map param) throws Exception {
		return (Map) super.commonDao.select("aha990ukrServiceImpl.selectTaxYM", param);
	}
	
	/**
	 * 원천징수내역  / 납부세액 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "aha")
	public List<Map<Object, Object>> selectList(Map param) throws Exception {
		if(param.get("STATE_TYPE") == null || param.get("STATE_TYPE").equals("")){			
			param.put("STATE_TYPE", "1");
		} else {
			param.put("STATE_TYPE", "Y");
		}
		
		Map taxYM = selectTaxYM(param);
		param.put("sTaxYM", taxYM.get("sTaxYM"));
		
		return (List) super.commonDao.list("aha990ukrServiceImpl.selectList", param);
	}
	
	/**
	 * 환급액 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "aha")
	public List<Map<String, Object>> selectList2(Map param) throws Exception {
		if(param.get("STATE_TYPE") == null || param.get("STATE_TYPE").equals("")){			
			param.put("STATE_TYPE", "1");
		} else {
			param.put("STATE_TYPE", "Y");
		}
		return (List) super.commonDao.list("aha990ukrServiceImpl.selectList2", param);
	}
	
	/**
	 * 자료를 생성함
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")	
	public List<Map<String, Object>> createData(Map param, LoginVO user) throws Exception {
//		// 통합신고 체크-> '%' 언체크->신고사업장
//		if (param.get("TAX_DIV_CODE") == null || param.get("TAX_DIV_CODE").equals("")) {
//			param.put("TAX_DIV_CODE", param.get("DIV_CODE"));
//		} else {
//			param.put("TAX_DIV_CODE", "%");
//		}
		
		// 연말정산포함여부 포함:Y/포함안함:1
		if (param.get("YEAR_TAX_FLAG") == null || param.get("YEAR_TAX_FLAG").equals("")) {
			param.put("YEAR_TAX_FLAG", "1");
		} else {
			param.put("YEAR_TAX_FLAG", "Y");
		}
		return super.commonDao.list("aha990ukrServiceImpl.createData", param);
	}
	
	/**
	 * 다시 자료를 생성함
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")	
	public List<Map<String, Object>> reCreateData(Map param, LoginVO user) throws Exception {
//		// 통합신고 체크-> '%' 언체크->신고사업장
//		if (param.get("TAX_DIV_CODE") == null || param.get("TAX_DIV_CODE").equals("")) {
//			param.put("TAX_DIV_CODE", param.get("DIV_CODE"));
//		} else {
//			param.put("TAX_DIV_CODE", "%");
//		}
		
		// 연말정산포함여부 포함:Y/포함안함:1
		if (param.get("YEAR_TAX_FLAG") == null || param.get("YEAR_TAX_FLAG").equals("")) {
			param.put("YEAR_TAX_FLAG", "1");
		} else {
			param.put("YEAR_TAX_FLAG", "Y");
		}
		
		String errorDesc ="";
		List<Map> errCheck = super.commonDao.list("aha990ukrServiceImpl.reCreateData", param);
		errorDesc = ObjUtils.getSafeString(errCheck.get(0).get("ERROR_DESC"));
		
		if(!ObjUtils.isEmpty(errorDesc)){
			throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
		}else{
			return super.commonDao.list("aha990ukrServiceImpl.reCreateData", param);
		}
		
	}
	
	
	/**
	 * 파일 생성전 validation 체크
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */	
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public Map<String, Object>  checkProcedureExec(Map spParam, LoginVO user) throws Exception {
				
		Map<String, Object> spResult = new HashMap<String, Object>();
		Map<String, Object> result = new HashMap<String, Object>();
		String errorDesc = "";

		spResult = (Map) super.commonDao.select("aha990ukrServiceImpl.sp_getFileText", spParam);
		errorDesc = (String) spResult.get("ERROR_DESC");
		if(!ObjUtils.isEmpty(errorDesc)){			
			String[] messsage = errorDesc.split(";");
			String errMsg = "";
			if("55208".equals(messsage[0])){
				errMsg = "원친징수이행상황신고서 내역이 없습니다.";
			}else if("55207".equals(messsage[0])){
				errMsg = "원친징수이행상황신고서 HEADER 내역이 없습니다.";
			}else if("55209".equals(messsage[0])){
				errMsg = "원친징수이행상황신고서_부표 내역이 없습니다.";
			}else{
				errMsg = messsage[1];
			}
			
		    throw new  UniDirectValidateException(this.getMessage(messsage[0], user) + "\n" + errMsg);
		}

		result.put("RETURN_VALUE", "1");
		
	    return result;
	}
	
	/**
	 * 파일 생성
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public Map<String, Object> createWithholdingFile(Map spParam, LoginVO user) throws Exception {
		
		Map result = (Map) super.commonDao.select("aha990ukrServiceImpl.sp_getFileText", spParam);		
		String errorDesc = (String) result.get("ERROR_DESC");
		
        //String returnText = (String) result.get("RETURN_TEXT");	
		//System.out.print(returnText);
		
		if(!ObjUtils.isEmpty(errorDesc)){
			String[] messsage = errorDesc.split(";");
		    //errorDesc = this.getMessage(messsage[0], user);
			
			if("55208".equals(messsage[0])){
				errorDesc = "원친징수이행상황신고서 내역이 없습니다.";
			}else if("55207".equals(messsage[0])){
				errorDesc = "원친징수이행상황신고서 HEADER 내역이 없습니다.";
			}else if("55209".equals(messsage[0])){
				errorDesc = "원친징수이행상황신고서_부표 내역이 없습니다.";
			}else{
				errorDesc = messsage[1];
			}
		}else{
			errorDesc = "";			
		}		
		
		result.put("ERROR_DESC", errorDesc);
		
	    return result;
	}
	

	/**
	 * 퇴직소득 전산 매체 신고 파일 생성
	 * @param param
	 * @param loginVO
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")	
	public Map createRetireFile(Map param, LoginVO loginVO) throws Exception {
		String path = "";
		if(param.containsKey("YEAR_TAX_FLAG")){
			if(param.get("YEAR_TAX_FLAG").equals("")){			
				param.put("YEAR_TAX_FLAG", "1");
			}
		}else{
			param.put("YEAR_TAX_FLAG", "1");
		}
				
		logger.debug(">>> "+ param);
		param.put("S_COMP_CODE", loginVO.getCompCode());
		Map result = (Map)super.commonDao.queryForObject("aha990ukrServiceImpl.createFile", param);
		logger.debug(">>> "+ result);
		
		int resultInt = (int) result.get("RETURN_VALUE");
		if (resultInt != -1) {
			String fileName = result.get("FILE_NAME").toString();
			
			List<Map> data =  super.commonDao.list("aha990ukrServiceImpl.loadFileData", param);
			logger.debug(">>> "+ data);
			try {
				  path = file_open(fileName);
				  if (path != ""){
				      BufferedWriter out = new BufferedWriter(new FileWriter(path));
				      for (int i = 0; i < data.size(); i++) {
				    	  out.write(data.get(i).get("DATA").toString()); 
				    	  if (i < data.size() - 1) {
				    		  out.newLine();  
				    	  }
				      }
				      out.close();
				  }else
				  {
					  result.put("RETURN_VALUE", 2);
				  }
			    } catch (IOException e) {
			        logger.error(e + "");
			    }
		}
		return result;
	}
	
	
	public static String file_open(String fileName){
		String path = "";
		Frame f = new Frame("Save as..");
		f.setSize(0,0);
		FileDialog fileOpen = new FileDialog(f, "Save as..", FileDialog.SAVE);
		fileOpen.setFile(fileName);	// 기본 파일명`
		f.setVisible(true);
		f.setVisible(false);
		fileOpen.setVisible(true);
		
		if (fileOpen.getFile()==null)
		{
			path = "";
		}else
		{
			path = fileOpen.getDirectory() + fileOpen.getFile();
		}
		f.dispose();
		return path;
	}
	
	
	// sync All
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "aha")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		if(paramList != null)	{
				List<Map> updateList = null;
				List<Map> deleteList = null;
				for(Map dataListMap: paramList) {
					if(dataListMap.get("method").equals("deleteList")) {
						deleteList = (List<Map>)dataListMap.get("data");
					} else if(dataListMap.get("method").equals("updateList")) {
						updateList = (List<Map>)dataListMap.get("data");	
					} 
				}			
				//수정
				if(updateList != null) {
					//마감여부 체크쿼리 호출
					Object checkCloseYn = super.commonDao.select("aha990ukrServiceImpl.checkCloseYn", dataMaster);
					//마감정보이 되지 않았을 때
					if (ObjUtils.isEmpty(checkCloseYn)) {
						this.updateList(updateList, paramMaster, user);
					
					} else {
						paramList = (List<Map>) checkCloseYn;
					 	return  paramList;
					}
				}
				//삭제
				if(deleteList != null) this.deleteList(deleteList, paramMaster, user);
			}
		 	paramList.add(0, paramMaster);
				
		 	return  paramList;
	}
	
	/**
	 * 수정
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public List<Map> updateList(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		for(Map param :paramList )	{			
			param.put("PAY_YYYYMM", dataMaster.get("TAX_YYYYMM"));
			
			super.commonDao.update("aha990ukrServiceImpl.updateList", param);							
		}
		return paramList;
	}
	
	/**
	 * 삭제
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public void deleteList(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		
		if(dataMaster.get("STATE_TYPE") == null || dataMaster.get("STATE_TYPE").equals("")){			
			dataMaster.put("STATE_TYPE", "1");
		} else {
			dataMaster.put("STATE_TYPE", "Y");
		}
		
		super.commonDao.delete("aha990ukrServiceImpl.deleteList1", dataMaster);
		for(Map param :paramList )	{
			param.put("DIV_CODE", dataMaster.get("DIV_CODE"));
			param.put("TAX_YYYYMM", dataMaster.get("TAX_YYYYMM"));
			param.put("STATE_TYPE", dataMaster.get("STATE_TYPE"));
			
			super.commonDao.delete("aha990ukrServiceImpl.deleteList2", param);

			
		}	
		return;
	}
	
	// sync All2
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "accnt")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll2(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		 if(paramList != null)	{
				List<Map> updateList = null;
				for(Map dataListMap: paramList) {
					if(dataListMap.get("method").equals("updateList2")) {
						updateList = (List<Map>)dataListMap.get("data");	
					} 
				}			
				Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");

				if(updateList != null) this.updateList2(updateList, dataMaster, user);	
			}
		 	paramList.add(0, paramMaster);
				
		 	return  paramList;
	}
	
	/**
	 * 수정
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public List<Map> updateList2(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		for(Map param :paramList )	{			
			param.put("PAY_YYYYMM", paramMaster.get("TAX_YYYYMM"));
			param.put("SECT_CODE", paramMaster.get("DIV_CODE"));
			
			super.commonDao.update("aha990ukrServiceImpl.updateList2", param);							
		}
		return paramList;
	}

	/**
	 * 차수 가져오기
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "accnt")      // 차수 가져오기
    public List<Map<String, Object>>  getOrdNum(Map param) throws Exception {  
        return  super.commonDao.list("aha990ukrServiceImpl.getOrdNum", param);
    }	
	
	/**
     * 원천징수이행 상황 신고서 출력 Excel 미리보기1
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(group = "aha", value = ExtDirectMethodType.STORE_READ)
    public List<Map<Object, Object>> selectExcelView1(Map param) throws Exception {        
        return super.commonDao.list("aha990ukrServiceImpl.selectExcelView1", param);
    }
    
    /**
     * 원천징수이행 상황 신고서 출력 Excel 미리보기2
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(group = "aha", value = ExtDirectMethodType.STORE_READ)
    public List<Map<Object, Object>> selectExcelView2(Map param) throws Exception {        
        return super.commonDao.list("aha990ukrServiceImpl.selectExcelView2", param);
    }
    
    /**
     * 원천징수 이행상황 신고서 대상 count조회
     * 
     * */
    @ExtDirectMethod(group = "aha", value = ExtDirectMethodType.STORE_READ)
    public List<Map<String, Object>> selectExcelCnt(Map param) throws Exception {
        return super.commonDao.list("aha990ukrServiceImpl.selectExcelCnt", param);
    }
}
	
