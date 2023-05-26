package foren.unilite.modules.human.ham;

import java.io.File;
import java.io.IOException;
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
import foren.framework.utils.FileUtil;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.human.hum.Hum100ukrModel;
import foren.unilite.modules.human.hum.Hum710ukrModel;
import foren.unilite.modules.human.hum.Hum790ukrModel;
import foren.unilite.modules.human.hum.Hum800ukrModel;
import foren.unilite.utils.AES256DecryptoUtils;

@Service("ham100ukrService")
public class Ham100ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	public final static String FILE_TYPE_OF_PHOTO = "employeePhoto";

	private AES256DecryptoUtils	decrypto = new AES256DecryptoUtils();
	
	/**
	 * 인사자료목록조회  
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "hum")
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return (List) super.commonDao.list("ham100ukrServiceImpl.selectList", param);
	}
	
	/**
	 * 인사자료조회-인사기본사항
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_LOAD, group = "hum")
	public Object select(Map param) throws Exception {		
		Map r = (Map)super.commonDao.select("hum100ukrServiceImpl.select", param);
		
		if(r != null)	{
			String repre_num = ObjUtils.getSafeString(r.get("REPRE_NUM"));
			if(repre_num != null && repre_num.length()==13)	{
				r.put("REPRE_NUM",repre_num.substring(0, 6)+"-"+repre_num.substring(6, 13));
			}
			
			String postalCode = ObjUtils.getSafeString(r.get("ZIP_CODE"));
			if(postalCode != null && postalCode.length()==6)	{
				r.put("ZIP_CODE",postalCode.substring(0, 3)+"-"+postalCode.substring(3, 6));
			}
			r.put("REPRE_NUM_EXPOS", decrypto.getDecryptWithType(r.get("REPRE_NUM"),param.get("S_COMP_CODE") , "hum100ukr", "A"));	//주민번호 or 외국인번호
//			r.put("BANK_ACCOUNT1_EXPOS", decrypto.getDecryptWithType(r.get("BANK_ACCOUNT1"),param.get("S_COMP_CODE") , "hum100ukr", "B"));	//계좌번호
//			r.put("BANK_ACCOUNT2_EXPOS", decrypto.getDecryptWithType(r.get("BANK_ACCOUNT2"),param.get("S_COMP_CODE") , "hum100ukr", "B"));	//계좌번호
//			r.put("FOREIGN_NUM_EXPOS", decrypto.getDecryptWithType(r.get("FOREIGN_NUM"),param.get("S_COMP_CODE") , "hum100ukr", "A"));	//주민번호 or 외국인번호
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
		return  super.commonDao.select("hum100ukrServiceImpl.chkRepreNum", param);
	}
	
	/**
	 * 인사자료입력-연금보혐료(TYPE:1), 건강보험료(TYPE:2) 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "hum")
	public Object  getMonthInsurI(Map param) throws Exception {		
		return  super.commonDao.select("hum100ukrServiceImpl.getMonthInsurI", param);
	}
	
	/**
	 * 인사자료입력-고용보험료 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "hum")
	public Object  getHireInsurI(Map param) throws Exception {		
		return  super.commonDao.select("hum100ukrServiceImpl.getHireInsurI", param);
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
	public ExtDirectFormPostResult saveHum100(Hum100ukrModel param, LoginVO login,  BindingResult result) throws Exception {
		
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
		
		
		super.commonDao.update("hum100ukrServiceImpl.save", param);
		ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);
		extResult.addResultProperty("PERSON_NUM", param.getPERSON_NUMB());
		return extResult;
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
	public ExtDirectFormPostResult photoUploadFile(@RequestParam("photoFile") MultipartFile file, Hum100ukrModel param, LoginVO login) throws IOException, Exception {
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
				
				super.commonDao.update("hum100ukrServiceImpl.photoModified", param);
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
		return (List) super.commonDao.list("hum100ukrServiceImpl.familyList", param);
	}
	
	/**
	 * 인사자료입력-가족사항 주민번호 중복 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_LOAD, group = "hum")
	public Object  chkFamilyRepreNum(Map param) throws Exception {		
		return  super.commonDao.select("hum100ukrServiceImpl.chkFamilyRepreNum", param);
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
			super.commonDao.insert("hum100ukrServiceImpl.insertFamilyInfo", param);		
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
			super.commonDao.update("hum100ukrServiceImpl.updateFamilyInfo", param);		
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
			super.commonDao.update("hum100ukrServiceImpl.deleteFamilyInfo", param);		
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
		return  super.commonDao.select("hum100ukrServiceImpl.healthInfo", param);
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
		
		super.commonDao.update("hum100ukrServiceImpl.saveHUM710", param);
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
		return  (List) super.commonDao.list("hum100ukrServiceImpl.deductionInfo1", param);
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
			super.commonDao.update("hum100ukrServiceImpl.saveHPA200", param);		
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
			super.commonDao.update("hum100ukrServiceImpl.deleteHPA200", param);		
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
		return  (List) super.commonDao.list("hum100ukrServiceImpl.deductionInfo2", param);
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
			super.commonDao.update("hum100ukrServiceImpl.saveHPA500", param);		
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
			super.commonDao.update("hum100ukrServiceImpl.deleteHPA500", param);		
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
		return  (List) super.commonDao.list("hum100ukrServiceImpl.careerInfo", param);
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
			super.commonDao.insert("hum100ukrServiceImpl.insertHUM500", param);		
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
			super.commonDao.update("hum100ukrServiceImpl.updateHUM500", param);		
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
			super.commonDao.update("hum100ukrServiceImpl.deleteHUM500", param);		
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
		return  (List) super.commonDao.list("hum100ukrServiceImpl.academicBakground", param);
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
			super.commonDao.insert("hum100ukrServiceImpl.insertHUM720", param);		
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
			super.commonDao.update("hum100ukrServiceImpl.updateHUM720", param);		
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
			super.commonDao.update("hum100ukrServiceImpl.deleteHUM720", param);		
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
		return  (List) super.commonDao.list("hum100ukrServiceImpl.educationInfo", param);
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
			super.commonDao.insert("hum100ukrServiceImpl.insertHUM740", param);		
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
			super.commonDao.update("hum100ukrServiceImpl.updateHUM740", param);		
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
			super.commonDao.update("hum100ukrServiceImpl.deleteHUM740", param);		
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
		return  (List) super.commonDao.list("hum100ukrServiceImpl.certificateInfo", param);
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
			super.commonDao.insert("hum100ukrServiceImpl.insertHUM600", param);		
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
			super.commonDao.update("hum100ukrServiceImpl.updateHUM600", param);		
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
			super.commonDao.update("hum100ukrServiceImpl.deleteHUM600", param);		
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
		return  (List) super.commonDao.list("hum100ukrServiceImpl.hrChanges", param);
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
			super.commonDao.insert("hum100ukrServiceImpl.saveHRHUM100", param);	
			super.commonDao.update("hum100ukrServiceImpl.insertHUM760", param);		
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
			super.commonDao.update("hum100ukrServiceImpl.saveHRHUM100", param);	
			super.commonDao.update("hum100ukrServiceImpl.updateHUM760", param);		
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
			super.commonDao.update("hum100ukrServiceImpl.deleteHUM760", param);		
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
		return  (List) super.commonDao.list("hum100ukrServiceImpl.personalRating", param);
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
			super.commonDao.update("hum100ukrServiceImpl.insertHUM770", param);		
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
			super.commonDao.update("hum100ukrServiceImpl.updateHUM770", param);		
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
			super.commonDao.update("hum100ukrServiceImpl.deleteHUM770", param);		
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
		return  (List) super.commonDao.list("hum100ukrServiceImpl.disciplinaryInfo", param);
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
			super.commonDao.update("hum100ukrServiceImpl.insertHUM810", param);		
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
			super.commonDao.update("hum100ukrServiceImpl.updateHUM810", param);		
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
			super.commonDao.update("hum100ukrServiceImpl.deleteHUM810", param);		
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
		return  (List) super.commonDao.list("hum100ukrServiceImpl.contractInfo", param);
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
			super.commonDao.update("hum100ukrServiceImpl.insertHUM840", param);		
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
			super.commonDao.update("hum100ukrServiceImpl.updateHUM840", param);		
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
			super.commonDao.update("hum100ukrServiceImpl.deleteHUM840", param);		
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
		return  (List) super.commonDao.list("hum100ukrServiceImpl.passportInfo", param);
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
			super.commonDao.update("hum100ukrServiceImpl.insertHUM730", param);		
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
			super.commonDao.update("hum100ukrServiceImpl.updateHUM730", param);		
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
			super.commonDao.update("hum100ukrServiceImpl.deleteHUM730", param);		
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
		return  (List) super.commonDao.list("hum100ukrServiceImpl.visaInfo", param);
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
			super.commonDao.update("hum100ukrServiceImpl.insertHUM731", param);		
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
			super.commonDao.update("hum100ukrServiceImpl.updateHUM731", param);		
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
			super.commonDao.update("hum100ukrServiceImpl.deleteHUM731", param);		
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
		return  (List) super.commonDao.list("hum100ukrServiceImpl.abroadTrip", param);
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
			super.commonDao.update("hum100ukrServiceImpl.insertHUM830", param);		
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
			super.commonDao.update("hum100ukrServiceImpl.updateHUM830", param);		
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
			super.commonDao.update("hum100ukrServiceImpl.deleteHUM830", param);		
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
		return  (List) super.commonDao.list("hum100ukrServiceImpl.schoolExpence", param);
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
			super.commonDao.update("hum100ukrServiceImpl.insertHUM820", param);		
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
			super.commonDao.update("hum100ukrServiceImpl.updateHUM820", param);		
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
			super.commonDao.update("hum100ukrServiceImpl.deleteHUM820", param);		
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
		return  super.commonDao.select("hum100ukrServiceImpl.recommender", param);
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
		super.commonDao.update("hum100ukrServiceImpl.saveHUM790", param);
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
		return  super.commonDao.select("hum100ukrServiceImpl.surety", param);
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
		
		super.commonDao.update("hum100ukrServiceImpl.saveHUM800", param);
		ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);
		extResult.addResultProperty("PERSON_NUM", param.getPERSON_NUMB());
		return extResult;
	}
	
	
	@ExtDirectMethod(group = "hum")
	public Integer  syncAll(Map param) throws Exception {
		logger.debug("syncAll:" + param);
		return  0;
	}
}
