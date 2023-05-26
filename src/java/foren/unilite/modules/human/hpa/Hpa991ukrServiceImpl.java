package foren.unilite.modules.human.hpa;

import java.awt.FileDialog;
import java.awt.Frame;
import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;

import org.slf4j.Logger;

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


@Service("hpa991ukrService")
public class Hpa991ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
		
	
	/**
	 * 퇴직소득 전산 매체 신고 파일 생성
	 * @param param
	 * @param loginVO
	 * @return
	 * @throws Exception
	 */
	/*public Map createRetireFile(Map param, LoginVO loginVO) throws Exception {
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
		Map result = (Map)super.commonDao.queryForObject("hpa991ukrServiceImpl.createFile", param);
		logger.debug(">>> "+ result);
		
		int resultInt = (int) result.get("RETURN_VALUE");
		if (resultInt != -1) {
			String fileName = result.get("FILE_NAME").toString();
			
			List<Map> data =  super.commonDao.list("hpa991ukrServiceImpl.loadFileData", param);
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
	}*/
	
	
	
	/**
	 * 파일 생성전 validation 체크
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */	
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public Map checkProcedureExec(Map spParam, LoginVO user) throws Exception {
		
		String path = "";
		
		Map<String, Object> spResult = new HashMap<String, Object>();
		Map<String, Object> result = new HashMap<String, Object>();
		String errorDesc = "";
				
		spResult = (Map) super.commonDao.select("hpa991ukrServiceImpl.sp_getFileText", spParam);
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
		
		Map result = (Map) super.commonDao.select("hpa991ukrServiceImpl.sp_getFileText", spParam);		
		String errorDesc = (String) result.get("ERROR_DESC");
		
		if(!ObjUtils.isEmpty(errorDesc)){
			String[] messsage = errorDesc.split(";");

			
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
	@ExtDirectMethod(group = "hpa")
	public Integer syncAll(Map param) throws Exception {
		logger.debug("syncAll:" + param);
		return 0;
	}
}
	
