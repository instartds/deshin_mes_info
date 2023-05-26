package foren.unilite.modules.human.hum;

import java.io.File;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.model.LoginVO;
import foren.framework.utils.ConfigUtil;
import foren.framework.utils.ObjUtils;
import foren.framework.utils.FileUtil;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.modules.com.fileman.FileMnagerService;
import foren.unilite.com.validator.UniDirectValidateException;

@Service("hum105ukrService")
public class hum105ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	public final static String FILE_TYPE_OF_PHOTO = "employeePhoto";
	
	/**
	 * 인사자료목록조회  
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "hum")
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		
		return (List) super.commonDao.list("hum105ukrServiceImpl.selectList", param);
	}
	
	/**
	 * 인사자료조회-인사기본사항
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_LOAD, group = "hum")
	public Object select(Map param) throws Exception {		
		Map r = (Map)super.commonDao.select("hum105ukrServiceImpl.select", param);
		
		if(r != null)	{
			String repre_num = ObjUtils.getSafeString(r.get("REPRE_NUM"));
			if(repre_num != null && repre_num.length()==13)	{
				r.put("REPRE_NUM",repre_num.substring(0, 6)+"-"+repre_num.substring(6, 13));
			}
			
			/*String postalCode = ObjUtils.getSafeString(r.get("ZIP_CODE"));
			if(postalCode != null && postalCode.length()==6)	{
				r.put("ZIP_CODE",postalCode.substring(0, 3)+"-"+postalCode.substring(3, 6));
			}*/
		}
		return  r;
	}
	
	/**
	 * 인사자료입력-주민번호 중복 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_LOAD, group = "hum")
	public Object  chkRepreNum(Map param) throws Exception {		
		return  super.commonDao.select("hum105ukrServiceImpl.chkRepreNum", param);
	}
	
	/**
	 * 인사자료입력-연금보혐료(TYPE:1), 건강보험료(TYPE:2) 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "hum")
	public Object  getMonthInsurI(Map param) throws Exception {		
		return  super.commonDao.select("hum105ukrServiceImpl.getMonthInsurI", param);
	}
	
	/**
	 * 인사자료입력-고용보험료 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "hum")
	public Object  getHireInsurI(Map param) throws Exception {		
		return  super.commonDao.select("hum105ukrServiceImpl.getHireInsurI", param);
	}
	
	/**
	 * 인사자료입력- 저장
	 * @param param
	 * @param login
	 * @param result
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "Hum", value = ExtDirectMethodType.FORM_POST)
	public ExtDirectFormPostResult saveHum100(hum105ukrModel param, LoginVO login,  BindingResult result) throws Exception {
		
		param.setS_COMP_CODE(login.getCompCode());
		param.setS_USER_ID(login.getUserID());
		
		if(param.getREPRE_NUM() != null)		{
			String repreNum = ObjUtils.getSafeString(param.getREPRE_NUM()).replace("-", "");
			param.setREPRE_NUM(repreNum);
		}
		if(param.getZIP_CODE() != null)		{
			String zipCode = ObjUtils.getSafeString(param.getZIP_CODE()).replace("-", "");
			param.setZIP_CODE(zipCode);
		}
		if(param.getORI_ZIP_CODE() != null)		{
			String oriZipCode = ObjUtils.getSafeString(param.getORI_ZIP_CODE()).replace("-", "");
			param.setORI_ZIP_CODE(oriZipCode);
		}
		
		if(ObjUtils.isNotEmpty(param.getPERSONALINFO())){
	        if(ObjUtils.getSafeString(param.getPERSONALINFO()).equals("Y")){
		        if (ObjUtils.isEmpty(param.getRETR_DATE())) {
		            param.setRETR_DATE("00000000");
		        }
	        }
        }
		
		super.commonDao.update("hum105ukrServiceImpl.save", param);
		ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);
		extResult.addResultProperty("PERSON_NUM", param.getPERSON_NUMB());
		
		return extResult;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hum")
    public String personalInfoDelete(Map param, LoginVO login) throws Exception {
        String rtnV = "";
        try{
        	
        	Map checkMap1 = (Map) super.commonDao.select("hum105ukrServiceImpl.personalInfoDeleteCheck", param);
        	
        	if(ObjUtils.isNotEmpty(checkMap1)){
        		//인사기본자료정보 삭제시 급여, 근태정보 존재
        		rtnV = "C";
        	}else{        		

                //해당 사원 정보들 전부 삭제 
                super.commonDao.delete("hum105ukrServiceImpl.personalInfoDelete", param);
                rtnV = "Y";
        	}
        }catch(Exception e){
        	//에러
        	rtnV = "N";
        }
        
        return rtnV;
    } 	
	
	/**
	 *  인사자료입력- 사진업로드
	 * @param file1
	 * @return
	 * @throws IOException
	 */
	
	//public ExtDirectFormPostResult photoUploadFile(@RequestParam("photoFile") MultipartFile file, @RequestParam("PERSON_NUMB") String personNumb) 
	//															throws IOException, Exception {
	@ExtDirectMethod(group = "Hum", value = ExtDirectMethodType.FORM_POST)
	public ExtDirectFormPostResult photoUploadFile(@RequestParam("photoFile") MultipartFile file, hum105ukrModel param, LoginVO login) throws IOException, Exception {
		String personNumb = param.getPERSON_NUMB();
		ExtDirectFormPostResult resp = new ExtDirectFormPostResult(true);
		if (file != null && !file.isEmpty()) {
			logger.debug("File1 Name : " + file.getName());
			logger.debug("File1 Bytes: " + file.getSize());
			String fileExtension =FileUtil.getExtension(file.getOriginalFilename()).toLowerCase();
			
			if(!"jpg".equals(fileExtension))	{
				throw new  UniDirectValidateException("jpg 파일로 올려주세요.");
			}
			
			String path = ConfigUtil.getUploadBasePath(FILE_TYPE_OF_PHOTO);
			if (file.getSize() > 0){
				File tmpFile = new File( path + "/"  + personNumb+'.' + fileExtension);
				file.transferTo(tmpFile);
				param.setS_COMP_CODE(login.getCompCode());
				param.setS_USER_ID(login.getUserID());
				
				super.commonDao.update("hum105ukrServiceImpl.photoModified", param);
			}
			
		}
		ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(true);
		//extResult.addResultProperty("PERSON_NUM", param.getPERSON_NUMB());
		return extResult;
		
	}
	
	/**
	 * 인사자료조회-가족사항
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "hum")
	public List<Map<String, Object>> familyList(Map param) throws Exception {		
		return (List) super.commonDao.list("hum105ukrServiceImpl.familyList", param);
	}
	
	/**
	 * 인사자료입력-가족사항 주민번호 중복 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_LOAD, group = "hum")
	public Object  chkFamilyRepreNum(Map param) throws Exception {		
		return  super.commonDao.select("hum105ukrServiceImpl.chkFamilyRepreNum", param);
	}
	
	/**
	 * 인사자료입력-가족사항 저장
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "hum")
	public List<Map> savefamilyAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		
		List<Map> dataList = new ArrayList<Map>();

		List<Map> insertList = new ArrayList<Map>();
		List<Map> updateList = new ArrayList<Map>();
		List<Map> deleteList = new ArrayList<Map>();
		
		if(paramList != null)	{
			for(Map param: paramList) {
				dataList = (List<Map>)param.get("data");
				
				if(param.get("method").equals("insertFamilyInfo")) {
					insertList.addAll((List<Map>)param.get("data"));	
				} else if(param.get("method").equals("updateFamilyInfo")) {
					updateList.addAll((List<Map>)param.get("data"));	
				} else if(param.get("method").equals("deleteFamilyInfo")) {
					deleteList.addAll((List<Map>)param.get("data"));	
				}
			}
			
			deleteFamilyInfo(deleteList);
			insertFamilyInfo(insertList);
			updateFamilyInfo(updateList);
		}
		
		paramList.add(0, paramMaster);
				
		return  paramList;
	}
	
	
	/**
	 * 인사자료조회-가족사항 등록
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hum")
	public List<Map>  insertFamilyInfo(List<Map> paramList) throws Exception {
		
		for(Map param :paramList )	{
			super.commonDao.insert("hum105ukrServiceImpl.insertFamilyInfo", param);		
		}
		return  paramList;
	}
	/**
	 * 인사자료조회-가족사항 수정
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hum")
	public List<Map>  updateFamilyInfo(List<Map> paramList) throws Exception {
		
		for(Map param :paramList )	{
			super.commonDao.update("hum105ukrServiceImpl.updateFamilyInfo", param);		
		}
		return  paramList;
	}
	/**
	 * 인사자료조회-가족사항 삭제
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hum")
	public List<Map>  deleteFamilyInfo(List<Map> paramList) throws Exception {
		
		for(Map param :paramList )	{
			super.commonDao.update("hum105ukrServiceImpl.deleteFamilyInfo", param);		
		}
		return  paramList;
	}
	/**
	 * 인사자료조회-신상정보
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_LOAD, group = "hum")
	public Object healthInfo(Map param) throws Exception {		
		return  super.commonDao.select("hum105ukrServiceImpl.healthInfo", param);
	}
	
	/**
	 *  인사자료조회-신상정보 저장
	 * @param param
	 * @param login
	 * @param result
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "Hum", value = ExtDirectMethodType.FORM_POST)
	public ExtDirectFormPostResult saveHum710(Hum710ukrModel param, LoginVO login,  BindingResult result) throws Exception {
		
		param.setS_COMP_CODE(login.getCompCode());
		param.setS_USER_ID(login.getUserID());
		
		super.commonDao.update("hum105ukrServiceImpl.saveHUM710", param);
		ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);
		extResult.addResultProperty("PERSON_NUM", param.getPERSON_NUMB());
		return extResult;
	}
	
	/**
	 * 인사자료조회-고정지급/공제(고정지급)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "hum")
	public List<Map<String, Object>> deductionInfo1(Map param) throws Exception {		
		return  (List) super.commonDao.list("hum105ukrServiceImpl.deductionInfo1", param);
	}
	
	/**
	 * 인사자료조회-고정지급/공제(고정지급) 수정
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hum")
	public List<Map>  saveHPA200(List<Map> paramList) throws Exception {
		
		for(Map param :paramList )	{
			super.commonDao.update("hum105ukrServiceImpl.saveHPA200", param);		
		}
		return  paramList;
	}
	/**
	 * 인사자료조회-고정지급/공제(고정지급) 삭제
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hum")
	public List<Map>  deleteHPA200(List<Map> paramList) throws Exception {
		
		for(Map param :paramList )	{
			super.commonDao.update("hum105ukrServiceImpl.deleteHPA200", param);		
		}
		return  paramList;
	}
	
	/**
	 * 인사자료조회-고정지급/공제(공제)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "hum")
	public List<Map<String, Object>> deductionInfo2(Map param) throws Exception {		
		return  (List) super.commonDao.list("hum105ukrServiceImpl.deductionInfo2", param);
	}
	
	/**
	 * 인사자료조회-고정지급/공제(공제) 수정
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hum")
	public List<Map>  saveHPA500(List<Map> paramList) throws Exception {
		
		for(Map param :paramList )	{
			super.commonDao.update("hum105ukrServiceImpl.saveHPA500", param);		
		}
		return  paramList;
	}
	/**
	 * 인사자료조회-고정지급/공제(공제) 삭제
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hum")
	public List<Map>  deleteHPA500(List<Map> paramList) throws Exception {
		
		for(Map param :paramList )	{
			super.commonDao.update("hum105ukrServiceImpl.deleteHPA500", param);		
		}
		return  paramList;
	}
	/**
	 *  인사자료조회-경력사항
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "hum")
	public List<Map<String, Object>> careerInfo(Map param) throws Exception {		
		return  (List) super.commonDao.list("hum105ukrServiceImpl.careerInfo", param);
	}
	
	/**
	 * 인사자료입력-경력사항 저장
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "hum")
	public List<Map> saveCareerAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		
		List<Map> dataList = new ArrayList<Map>();

		List<Map> insertList = new ArrayList<Map>();
		List<Map> updateList = new ArrayList<Map>();
		List<Map> deleteList = new ArrayList<Map>();
		
		if(paramList != null)	{
			for(Map param: paramList) {
				dataList = (List<Map>)param.get("data");
				
				if(param.get("method").equals("insertHUM500")) {
					insertList.addAll((List<Map>)param.get("data"));	
				} else if(param.get("method").equals("updateHUM500")) {
					updateList.addAll((List<Map>)param.get("data"));	
				} else if(param.get("method").equals("deleteHUM500")) {
					deleteList.addAll((List<Map>)param.get("data"));	
				}
			}
			
			deleteHUM500(deleteList);
			insertHUM500(insertList);
			updateHUM500(updateList);
		}
		
		paramList.add(0, paramMaster);
				
		return  paramList;
	}
	
	/**
	 * 인사자료조회-경력사항 등록
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hum")
	public List<Map>  insertHUM500(List<Map> paramList) throws Exception {
		
		for(Map param :paramList )	{
			super.commonDao.insert("hum105ukrServiceImpl.insertHUM500", param);		
		}
		return  paramList;
	}
	/**
	 * 인사자료조회-경력사항 수정
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hum")
	public List<Map>  updateHUM500(List<Map> paramList) throws Exception {
		
		for(Map param :paramList )	{
			super.commonDao.update("hum105ukrServiceImpl.updateHUM500", param);		
		}
		return  paramList;
	}
	/**
	 * 인사자료조회-경력사항 삭제
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hum")
	public List<Map>  deleteHUM500(List<Map> paramList) throws Exception {
		
		for(Map param :paramList )	{
			super.commonDao.update("hum105ukrServiceImpl.deleteHUM500", param);		
		}
		return  paramList;
	}
	
	/**
	 *  인사자료조회-학력사항
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "hum")
	public List<Map<String, Object>> academicBakground(Map param) throws Exception {		
		return  (List) super.commonDao.list("hum105ukrServiceImpl.academicBakground", param);
	}
	
	/**
	 * 인사자료조회-학력사항 등록
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hum")
	public List<Map>  insertHUM720(List<Map> paramList) throws Exception {
		
		for(Map param :paramList )	{
			super.commonDao.insert("hum105ukrServiceImpl.insertHUM720", param);		
		}
		return  paramList;
	}
	/**
	 * 인사자료조회-학력사항 수정
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hum")
	public List<Map>  updateHUM720(List<Map> paramList) throws Exception {
		
		for(Map param :paramList )	{
			super.commonDao.update("hum105ukrServiceImpl.updateHUM720", param);		
		}
		return  paramList;
	}
	/**
	 * 인사자료조회-학력사항 삭제
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hum")
	public List<Map>  deleteHUM720(List<Map> paramList) throws Exception {
		
		for(Map param :paramList )	{
			super.commonDao.update("hum105ukrServiceImpl.deleteHUM720", param);		
		}
		return  paramList;
	}
	
	/**
	 *  인사자료조회-교육사항
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "hum")
	public List<Map<String, Object>> educationInfo(Map param) throws Exception {		
		return  (List) super.commonDao.list("hum105ukrServiceImpl.educationInfo", param);
	}
	
	/**
	 * 인사자료조회-교육사항 등록
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hum")
	public List<Map>  insertHUM740(List<Map> paramList) throws Exception {
		
		for(Map param :paramList )	{
			super.commonDao.insert("hum105ukrServiceImpl.insertHUM740", param);		
		}
		return  paramList;
	}
	/**
	 * 인사자료조회-교육사항 수정
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hum")
	public List<Map>  updateHUM740(List<Map> paramList) throws Exception {
		
		for(Map param :paramList )	{
			super.commonDao.update("hum105ukrServiceImpl.updateHUM740", param);		
		}
		return  paramList;
	}
	/**
	 * 인사자료조회-교육사항 삭제
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hum")
	public List<Map>  deleteHUM740(List<Map> paramList) throws Exception {
		
		for(Map param :paramList )	{
			super.commonDao.update("hum105ukrServiceImpl.deleteHUM740", param);		
		}
		return  paramList;
	}
	
	/**
	 *  인사자료조회-자격면허
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "hum")
	public List<Map<String, Object>> certificateInfo(Map param) throws Exception {		
		return  (List) super.commonDao.list("hum105ukrServiceImpl.certificateInfo", param);
	}
	
	/**
	 * 인사자료입력-자격면허 저장
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "hum")
	public List<Map> saveCertificateAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		
		List<Map> dataList = new ArrayList<Map>();

		List<Map> insertList = new ArrayList<Map>();
		List<Map> updateList = new ArrayList<Map>();
		List<Map> deleteList = new ArrayList<Map>();
		
		if(paramList != null)	{
			for(Map param: paramList) {
				dataList = (List<Map>)param.get("data");
				
				if(param.get("method").equals("insertHUM600")) {
					insertList.addAll((List<Map>)param.get("data"));	
				} else if(param.get("method").equals("updateHUM600")) {
					updateList.addAll((List<Map>)param.get("data"));	
				} else if(param.get("method").equals("deleteHUM600")) {
					deleteList.addAll((List<Map>)param.get("data"));	
				}
			}
			
			deleteHUM600(deleteList);
			insertHUM600(insertList);
			updateHUM600(updateList);
		}
		
		paramList.add(0, paramMaster);
				
		return  paramList;
	}
	
	/**
	 * 인사자료조회-자격면허 등록
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hum")
	public List<Map>  insertHUM600(List<Map> paramList) throws Exception {
		
		for(Map param :paramList )	{
			super.commonDao.insert("hum105ukrServiceImpl.insertHUM600", param);		
		}
		return  paramList;
	}
	/**
	 * 인사자료조회-자격면허 수정
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hum")
	public List<Map>  updateHUM600(List<Map> paramList) throws Exception {
		
		for(Map param :paramList )	{
			super.commonDao.update("hum105ukrServiceImpl.updateHUM600", param);		
		}
		return  paramList;
	}
	/**
	 * 인사자료조회 자격면허 삭제
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hum")
	public List<Map>  deleteHUM600(List<Map> paramList) throws Exception {
		
		for(Map param :paramList )	{
			super.commonDao.update("hum105ukrServiceImpl.deleteHUM600", param);		
		}
		return  paramList;
	}
	
	/**
	 *  인사자료조회-인사변동
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "hum")
	public List<Map<String, Object>> hrChanges(Map param) throws Exception {		
		return  (List) super.commonDao.list("hum105ukrServiceImpl.hrChanges", param);
	}
	
	/**
	 * 인사자료조회-인사변동 등록
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hum")
	public List<Map>  insertHUM760(List<Map> paramList) throws Exception {
		
		for(Map param :paramList )	{
			super.commonDao.insert("hum105ukrServiceImpl.saveHRHUM100", param);	
			super.commonDao.update("hum105ukrServiceImpl.insertHUM760", param);		
		}
		return  paramList;
	}
	/**
	 * 인사자료조회-인사변동 수정
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hum")
	public List<Map>  updateHUM760(List<Map> paramList) throws Exception {
		
		for(Map param :paramList )	{
			super.commonDao.update("hum105ukrServiceImpl.saveHRHUM100", param);	
			super.commonDao.update("hum105ukrServiceImpl.updateHUM760", param);		
		}
		return  paramList;
	}
	/**
	 * 인사자료조회 인사변동 삭제
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hum")
	public List<Map>  deleteHUM760(List<Map> paramList) throws Exception {
		
		for(Map param :paramList )	{
			super.commonDao.update("hum105ukrServiceImpl.deleteHUM760", param);		
		}
		return  paramList;
	}
	
	/**
	 *  인사자료조회-고과사항
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "hum")
	public List<Map<String, Object>> personalRating(Map param) throws Exception {		
		return  (List) super.commonDao.list("hum105ukrServiceImpl.personalRating", param);
	}
	
	/**
	 * 인사자료조회-고과사항 등록
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hum")
	public List<Map>  insertHUM770(List<Map> paramList) throws Exception {
		
		for(Map param :paramList )	{
			super.commonDao.update("hum105ukrServiceImpl.insertHUM770", param);		
		}
		return  paramList;
	}
	/**
	 * 인사자료조회-고과사항 수정
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hum")
	public List<Map>  updateHUM770(List<Map> paramList) throws Exception {
		
		for(Map param :paramList )	{
			super.commonDao.update("hum105ukrServiceImpl.updateHUM770", param);		
		}
		return  paramList;
	}
	/**
	 * 인사자료조회 고과사항 삭제
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hum")
	public List<Map>  deleteHUM770(List<Map> paramList) throws Exception {
		
		for(Map param :paramList )	{
			super.commonDao.update("hum105ukrServiceImpl.deleteHUM770", param);		
		}
		return  paramList;
	}
	
	/**
	 *  인사자료조회-상벌사항
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "hum")
	public List<Map<String, Object>> disciplinaryInfo(Map param) throws Exception {		
		return  (List) super.commonDao.list("hum105ukrServiceImpl.disciplinaryInfo", param);
	}
	
	/**
	 * 인사자료조회-상벌사항 등록
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hum")
	public List<Map>  insertHUM810(List<Map> paramList) throws Exception {
		
		for(Map param :paramList )	{
			super.commonDao.update("hum105ukrServiceImpl.insertHUM810", param);		
		}
		return  paramList;
	}
	/**
	 * 인사자료조회-상벌사항 수정
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hum")
	public List<Map>  updateHUM810(List<Map> paramList) throws Exception {
		
		for(Map param :paramList )	{
			super.commonDao.update("hum105ukrServiceImpl.updateHUM810", param);		
		}
		return  paramList;
	}
	/**
	 * 인사자료조회 상벌사항 삭제
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hum")
	public List<Map>  deleteHUM810(List<Map> paramList) throws Exception {
		
		for(Map param :paramList )	{
			super.commonDao.update("hum105ukrServiceImpl.deleteHUM810", param);		
		}
		return  paramList;
	}
	
	/**
	 *  인사자료조회-계약사항
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "hum")
	public List<Map<String, Object>> contractInfo(Map param) throws Exception {		
		return  (List) super.commonDao.list("hum105ukrServiceImpl.contractInfo", param);
	}
	
	/**
	 * 인사자료조회-계약사항 등록
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hum")
	public List<Map>  insertHUM840(List<Map> paramList) throws Exception {
		
		for(Map param :paramList )	{
			super.commonDao.update("hum105ukrServiceImpl.insertHUM840", param);		
		}
		return  paramList;
	}
	/**
	 * 인사자료조회-계약사항 수정
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hum")
	public List<Map>  updateHUM840(List<Map> paramList) throws Exception {
		
		for(Map param :paramList )	{
			super.commonDao.update("hum105ukrServiceImpl.updateHUM840", param);		
		}
		return  paramList;
	}
	/**
	 * 인사자료조회 계약사항 삭제
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hum")
	public List<Map>  deleteHUM840(List<Map> paramList) throws Exception {
		
		for(Map param :paramList )	{
			super.commonDao.update("hum105ukrServiceImpl.deleteHUM840", param);		
		}
		return  paramList;
	}
	
	/**
	 *  인사자료조회-비자여권(여권)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "hum")
	public List<Map<String, Object>> passportInfo(Map param) throws Exception {		
		return  (List) super.commonDao.list("hum105ukrServiceImpl.passportInfo", param);
	}
	
	/**
	 * 인사자료조회-비자여권(여권) 등록
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hum")
	public List<Map>  insertHUM730(List<Map> paramList) throws Exception {
		
		for(Map param :paramList )	{
			super.commonDao.update("hum105ukrServiceImpl.insertHUM730", param);		
		}
		return  paramList;
	}
	/**
	 * 인사자료조회-비자여권(여권) 수정
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hum")
	public List<Map>  updateHUM730(List<Map> paramList) throws Exception {
		
		for(Map param :paramList )	{
			super.commonDao.update("hum105ukrServiceImpl.updateHUM730", param);		
		}
		return  paramList;
	}
	/**
	 * 인사자료조회 비자여권(여권) 삭제
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hum")
	public List<Map>  deleteHUM730(List<Map> paramList) throws Exception {
		
		for(Map param :paramList )	{
			super.commonDao.update("hum105ukrServiceImpl.deleteHUM730", param);		
		}
		return  paramList;
	}
	
	/**
	 *  인사자료조회-비자여권(비자)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "hum")
	public List<Map<String, Object>> visaInfo(Map param) throws Exception {		
		return  (List) super.commonDao.list("hum105ukrServiceImpl.visaInfo", param);
	}
	
	/**
	 * 인사자료조회-비자여권(비자) 등록
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hum")
	public List<Map>  insertHUM731(List<Map> paramList) throws Exception {
		
		for(Map param :paramList )	{
			super.commonDao.update("hum105ukrServiceImpl.insertHUM731", param);		
		}
		return  paramList;
	}
	/**
	 * 인사자료조회-비자여권(비자) 수정
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hum")
	public List<Map>  updateHUM731(List<Map> paramList) throws Exception {
		
		for(Map param :paramList )	{
			super.commonDao.update("hum105ukrServiceImpl.updateHUM731", param);		
		}
		return  paramList;
	}
	/**
	 * 인사자료조회 비자여권(비자) 삭제
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hum")
	public List<Map>  deleteHUM731(List<Map> paramList) throws Exception {
		
		for(Map param :paramList )	{
			super.commonDao.update("hum105ukrServiceImpl.deleteHUM731", param);		
		}
		return  paramList;
	}
	
	/**
	 *  인사자료조회-해외출장
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "hum")
	public List<Map<String, Object>> abroadTrip(Map param) throws Exception {		
		return  (List) super.commonDao.list("hum105ukrServiceImpl.abroadTrip", param);
	}
	
	/**
	 * 인사자료조회-해외출장 등록
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hum")
	public List<Map>  insertHUM830(List<Map> paramList) throws Exception {
		
		for(Map param :paramList )	{
			super.commonDao.update("hum105ukrServiceImpl.insertHUM830", param);		
		}
		return  paramList;
	}
	/**
	 * 인사자료조회-해외출장 수정
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hum")
	public List<Map>  updateHUM830(List<Map> paramList) throws Exception {
		
		for(Map param :paramList )	{
			super.commonDao.update("hum105ukrServiceImpl.updateHUM830", param);		
		}
		return  paramList;
	}
	/**
	 * 인사자료조회 해외출장 삭제
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hum")
	public List<Map>  deleteHUM830(List<Map> paramList) throws Exception {
		
		for(Map param :paramList )	{
			super.commonDao.update("hum105ukrServiceImpl.deleteHUM830", param);		
		}
		return  paramList;
	}
	
	/**
	 *  인사자료조회-학자금지원
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "hum")
	public List<Map<String, Object>> schoolExpence(Map param) throws Exception {		
		return  (List) super.commonDao.list("hum105ukrServiceImpl.schoolExpence", param);
	}
	
	/**
	 * 인사자료조회-학자금지원 등록
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hum")
	public List<Map>  insertHUM820(List<Map> paramList) throws Exception {
		
		for(Map param :paramList )	{
			super.commonDao.update("hum105ukrServiceImpl.insertHUM820", param);		
		}
		return  paramList;
	}
	/**
	 * 인사자료조회-학자금지원 수정
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hum")
	public List<Map>  updateHUM820(List<Map> paramList) throws Exception {
		
		for(Map param :paramList )	{
			super.commonDao.update("hum105ukrServiceImpl.updateHUM820", param);		
		}
		return  paramList;
	}
	/**
	 * 인사자료조회 학자금지원 삭제
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hum")
	public List<Map>  deleteHUM820(List<Map> paramList) throws Exception {
		
		for(Map param :paramList )	{
			super.commonDao.update("hum105ukrServiceImpl.deleteHUM820", param);		
		}
		return  paramList;
	}
	/**
	 * 인사자료조회-추천인
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_LOAD, group = "hum")
	public Object recommender(Map param) throws Exception {		
		return  super.commonDao.select("hum105ukrServiceImpl.recommender", param);
	}
	
	/**
	 *  인사자료조회-추천인 저장
	 * @param param
	 * @param login
	 * @param result
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "Hum", value = ExtDirectMethodType.FORM_POST)
	public ExtDirectFormPostResult saveHum790(Hum790ukrModel param, LoginVO login,  BindingResult result) throws Exception {
		
		param.setS_COMP_CODE(login.getCompCode());
		param.setS_USER_ID(login.getUserID());
		
		if(param.getRECOMMEND1_ZIP_CODE() != null)		{
			String zipCode = ObjUtils.getSafeString(param.getRECOMMEND1_ZIP_CODE()).replace("-", "");
			param.setRECOMMEND1_ZIP_CODE(zipCode);
		}
		if(param.getRECOMMEND2_ZIP_CODE() != null)		{
			String zipCode = ObjUtils.getSafeString(param.getRECOMMEND2_ZIP_CODE()).replace("-", "");
			param.setRECOMMEND2_ZIP_CODE(zipCode);
		}
		super.commonDao.update("hum105ukrServiceImpl.saveHUM790", param);
		ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);
		extResult.addResultProperty("PERSON_NUM", param.getPERSON_NUMB());
		return extResult;
	}
	
	/**
	 * 인사자료조회-추천인
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_LOAD, group = "hum")
	public Object surety(Map param) throws Exception {		
		return  super.commonDao.select("hum105ukrServiceImpl.surety", param);
	}
	
	/**
	 *  인사자료조회-추천인 저장
	 * @param param
	 * @param login
	 * @param result
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "Hum", value = ExtDirectMethodType.FORM_POST)
	public ExtDirectFormPostResult saveHum800(Hum800ukrModel param, LoginVO login,  BindingResult result) throws Exception {
		
		param.setS_COMP_CODE(login.getCompCode());
		param.setS_USER_ID(login.getUserID());
		
		if(param.getGUARANTOR1_ZIP_CODE() != null)		{
			String zipCode = ObjUtils.getSafeString(param.getGUARANTOR1_ZIP_CODE()).replace("-", "");
			param.setGUARANTOR1_ZIP_CODE(zipCode);
		}
		if(param.getGUARANTOR2_ZIP_CODE() != null)		{
			String zipCode = ObjUtils.getSafeString(param.getGUARANTOR2_ZIP_CODE()).replace("-", "");
			param.setGUARANTOR2_ZIP_CODE(zipCode);
		}
		if(param.getGUARANTOR1_RES_NO() != null)		{
			String resNo1 = ObjUtils.getSafeString(param.getGUARANTOR1_RES_NO()).replace("-", "");
			param.setGUARANTOR1_RES_NO(resNo1);
		}
		if(param.getGUARANTOR2_RES_NO() != null)		{
			String resNo2 = ObjUtils.getSafeString(param.getGUARANTOR2_RES_NO()).replace("-", "");
			param.setGUARANTOR2_RES_NO(resNo2);
		}
		
		super.commonDao.update("hum105ukrServiceImpl.saveHUM800", param);
		ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);
		extResult.addResultProperty("PERSON_NUM", param.getPERSON_NUMB());
		return extResult;
	}
	
	
	@ExtDirectMethod(group = "hum")
	public Integer  syncAll(Map param) throws Exception {
		logger.debug("syncAll:" + param);
		return  0;
	}
	
	/**
	 * 급호봉 코드 정보
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "hum" , value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> fnHum100P2Codes(Map param) throws Exception {
		return (List<Map<String, Object>>) super.commonDao.list("hum105ukrServiceImpl.fnHum100P2Code", param);
	}
	
	/**
	 * 급호봉조회 popup
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "hum" , value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> fnHum100P2(Map param) throws Exception {
		List<Map<String, Object>>  codeList =  (List<Map<String, Object>>) super.commonDao.list("hum105ukrServiceImpl.fnHum100P2Code", param);
		String codeSql = "";
		boolean isFirst = true;
		for(Map<String, Object> codeMap : codeList)	{
			String wageCode = ObjUtils.getSafeString(codeMap.get("WAGES_CODE"));
			codeSql = codeSql+", '"+wageCode+"' AS CODE"+wageCode+" \n";
			if(isFirst)	{
				codeSql = codeSql+"  , MAX(CASE WHEN A.WAGES_CODE = '" + wageCode +"'";
				codeSql = codeSql+"                THEN A.WAGES_I";
				codeSql = codeSql+"                ELSE 0";
				codeSql = codeSql+"            END) AS STD100\n";
			}else {
				codeSql = codeSql+"  , MAX(CASE WHEN A.WAGES_CODE = '" + wageCode +"'";
				codeSql = codeSql+"                THEN A.WAGES_I";
				codeSql = codeSql+"                ELSE 0";
				codeSql = codeSql+"            END) AS STD"+wageCode+" \n";
			}
			isFirst= false;
			
		}
		param.put("CODE_SQL", codeSql);
		return (List) super.commonDao.list("hum105ukrServiceImpl.fnHum100P2", param);
	}
}
