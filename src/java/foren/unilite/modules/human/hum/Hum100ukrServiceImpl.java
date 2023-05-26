package foren.unilite.modules.human.hum;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

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
import foren.unilite.modules.com.fileman.FileMnagerService;
import foren.unilite.utils.AES256DecryptoUtils;
import foren.unilite.utils.AES256EncryptoUtils;

@Service( "hum100ukrService" )
public class Hum100ukrServiceImpl extends TlabAbstractServiceImpl {
    private final Logger       logger             = LoggerFactory.getLogger(this.getClass());
    public final static String FILE_TYPE_OF_PHOTO = "employeePhoto";
    
    @Resource(name = "fileMnagerService")
	private FileMnagerService fileMnagerService;
    
    private AES256EncryptoUtils encrypto = new AES256EncryptoUtils();
	private AES256DecryptoUtils	decrypto = new AES256DecryptoUtils();
    /**
     * 인사자료목록조회
     *
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "hum" )
    public List<Map<String, Object>> selectList( Map param ) throws Exception {
        return super.commonDao.list("hum100ukrServiceImpl.selectList", param);
    }

    /**
     * 인사자료조회-인사기본사항
     *
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( value = ExtDirectMethodType.FORM_LOAD, group = "hum" )
    public Object select( Map param ) throws Exception {
        Map r = (Map)super.commonDao.select("hum100ukrServiceImpl.select", param);
        if (r != null) {
            String postalCode = ObjUtils.getSafeString(r.get("ZIP_CODE"));
            if (postalCode != null && postalCode.length() == 6) {
                r.put("ZIP_CODE", postalCode.substring(0, 3) + "-" + postalCode.substring(3, 6));
            }
            r.put("REPRE_NUM_EXPOS", decrypto.getDecryptWithType(r.get("REPRE_NUM"),param.get("S_COMP_CODE") , "hum100ukr", "A"));	//주민번호 or 외국인번호
            r.put("BANK_ACCOUNT1_EXPOS", decrypto.getDecryptWithType(r.get("BANK_ACCOUNT1"),param.get("S_COMP_CODE") , "hum100ukr", "B"));	//계좌번호
            r.put("BANK_ACCOUNT2_EXPOS", decrypto.getDecryptWithType(r.get("BANK_ACCOUNT2"),param.get("S_COMP_CODE") , "hum100ukr", "B"));	//계좌번호
            r.put("FOREIGN_NUM_EXPOS", decrypto.getDecryptWithType(r.get("FOREIGN_NUM"),param.get("S_COMP_CODE") , "hum100ukr", "A"));	//주민번호 or 외국인번호
            
        }
        return r;
    }

    /**
     * 인사자료입력-주민번호 중복 조회
     *
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( value = ExtDirectMethodType.FORM_LOAD, group = "hum" )
    public Object chkRepreNum( Map param ) throws Exception {
        return super.commonDao.select("hum100ukrServiceImpl.chkRepreNum", param);
    }

    /**
     * 인사자료입력-연금보혐료(TYPE:1), 건강보험료(TYPE:2) 조회
     *
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "hum" )
    public Object getMonthInsurI( Map param ) throws Exception {
        return super.commonDao.select("hum100ukrServiceImpl.getMonthInsurI", param);
    }

    /**
     * 인사자료입력-고용보험료 조회
     *
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "hum" )
    public Object getHireInsurI( Map param ) throws Exception {
        return super.commonDao.select("hum100ukrServiceImpl.getHireInsurI", param);
    }

    /**
     * 대사우 비밀번호 초기화 관련
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "hum" )
    public String updateEssPass( Map param ) throws Exception {
        String reV = "";
        try{
            super.commonDao.update("hum100ukrServiceImpl.updateEssPass", param);
            reV = "Y";
        }catch(Exception e){
            reV = "N";
        }
        return reV;
    }
    
    /**
     * 인사자료입력- 저장
     *
     * @param param
     * @param login
     * @param result
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "Hum", value = ExtDirectMethodType.FORM_POST )
    public ExtDirectFormPostResult saveHum100( Hum100ukrModel param, LoginVO login, BindingResult result ) throws Exception {
        AES256EncryptoUtils encrypto = new AES256EncryptoUtils();
        AES256DecryptoUtils decrypto = new AES256DecryptoUtils();

        param.setS_COMP_CODE(login.getCompCode());
        param.setS_USER_ID(login.getUserID());

        if (param.getREPRE_NUM_EXPOS() != null) {
            String repreNum = ObjUtils.getSafeString(param.getREPRE_NUM_EXPOS()).replace("-", "");
            //update로직에서 암호화 필드가 있을시  decrypt후에 encrypt를 다시 해줘야 중복 암호화가 발생하지 않는다. 단 insert로직은 상관 없음
            param.setREPRE_NUM_EXPOS(encrypto.encryto(decrypto.getDecrypto("1", repreNum)));
        }
        if (param.getZIP_CODE() != null) {
            String zipCode = ObjUtils.getSafeString(param.getZIP_CODE()).replace("-", "");
            param.setZIP_CODE(zipCode);
        }
        if (param.getORI_ZIP_CODE() != null) {
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

        try{// 자동채번 관련
            if(ObjUtils.isEmpty((param.getPERSON_NUMB()))){
                Map checkAutoNumRule = (Map) super.commonDao.select("hum100ukrServiceImpl.checkAutoNumRule", param);

                if(ObjUtils.isEmpty(checkAutoNumRule)){
                    throw new  UniDirectValidateException("운영자 공통코드의 종합코드 H102의 사번자동채번유무 조건을 먼저 확인해 주십시오.");
                }else{
                    String checkSeparator = ""; // 채번구분자
                    String checkYYYY = ""; // 해당자리수에 대한 년
                    String checkMM = ""; // 해당자리수에 대한 월
                    String checkDD = ""; // 해당자리수에 대한 일
                    String checkSeq = ""; // 해당자리수에 대한 순번 관련
                    int checkLength; // 해당 자동채번 총 자리수

                    String tempStr1 = "";
                    String tempStr2 = "";

                    checkSeparator = ObjUtils.getSafeString(checkAutoNumRule.get("CHECK_SEPARATOR"));
                    checkYYYY = ObjUtils.getSafeString(checkAutoNumRule.get("CHECK_YYYY"));
                    checkMM = ObjUtils.getSafeString(checkAutoNumRule.get("CHECK_MM"));
                    checkDD = ObjUtils.getSafeString(checkAutoNumRule.get("CHECK_DD"));
                    checkSeq = ObjUtils.getSafeString(checkAutoNumRule.get("CHECK_SEQ"));
                    checkLength = ObjUtils.parseInt(checkAutoNumRule.get("CHECK_LENGTH"));

                    tempStr1 = checkSeparator + checkYYYY + checkMM + checkDD;

                    Map tempParam = new HashMap();
                    tempParam.put("S_COMP_CODE", login.getCompCode());
                    tempParam.put("TEMP_STR1", tempStr1);

                    Map checkPersonNumb = (Map) super.commonDao.select("hum100ukrServiceImpl.checkPersonNumb", tempParam);
                    if(ObjUtils.isEmpty(checkPersonNumb)){
                        //신규로 번호 채번
                        tempStr2 = tempStr1 + checkSeq;
                        param.setPERSON_NUMB(tempStr2);
                    }else{
                        if(ObjUtils.parseInt(checkPersonNumb.get("LEN_PERSON_NUMB")) == checkLength){
                            //기존번호에서 max +1
                            String autoNumStr1 = ObjUtils.getSafeString(checkPersonNumb.get("MAX_PERSON_NUMB"));
                            int autoNumTemp1 = Integer.parseInt(autoNumStr1.substring(autoNumStr1.length()-checkSeq.length(),autoNumStr1.length()));
                            int autoNumTemp2 = autoNumTemp1 + 1;
                            String autoNumTemp3 = String.format("%0"+ String.valueOf(checkSeq.length()) + "d", autoNumTemp2);
                            String autoNumStr2 = tempStr1 + autoNumTemp3;
                            param.setPERSON_NUMB(autoNumStr2);
                        }else{
                            //신규로 번호 채번
                            tempStr2 = tempStr1 + checkSeq;
                            param.setPERSON_NUMB(tempStr2);
                        }
                    }
                }
            }
        }catch(Exception e){
            throw new  UniDirectValidateException("운영자 공통코드의 종합코드 H102의 사번자동채번유무 조건을 먼저 확인해 주십시오.");
        }
        
        if(ObjUtils.isNotEmpty(param.getPAY_GUBUN())){
	        if(ObjUtils.isEmpty(param.getPAY_GUBUN2()))	{
	        	param.setPAY_GUBUN2("2");
	        }
        }
        
        try{
        	/*HAT300T.DUTY_YYYYMM (근태입력일),HAT500T.DUTY_FR_D (출근일자) < 입력된 입사일 => '경고' 메시지 체크, '먼저 입사일 이전 발생된 근태데이타를 삭제하셔야 합니다.'*/
            String msg = (String)super.commonDao.select("hum100ukrServiceImpl.personalInfoValidate", param);
            
            if(!ObjUtils.isEmpty(msg))
            {
            	throw new UniDirectValidateException(msg + "\n사번 : " + param.getPERSON_NUMB());
            }	
        }catch(Exception e){
        	throw new UniDirectValidateException(e.getMessage());
        }

        super.commonDao.update("hum100ukrServiceImpl.save", param);
        
        ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);
        
        extResult.addResultProperty("PERSON_NUM", param.getPERSON_NUMB());
        return extResult;
    }

    /**
     * 인사자료입력- 사진업로드
     *
     * @param file1
     * @return
     * @throws IOException
     */

    //public ExtDirectFormPostResult photoUploadFile(@RequestParam("photoFile") MultipartFile file, @RequestParam("PERSON_NUMB") String personNumb)
    //															throws IOException, Exception {
    @ExtDirectMethod( group = "Hum", value = ExtDirectMethodType.FORM_POST )
    public ExtDirectFormPostResult photoUploadFile( @RequestParam( "photoFile" ) MultipartFile file, Hum100ukrModel param, LoginVO login ) throws IOException, Exception {
        String personNumb = param.getPERSON_NUMB();
        ExtDirectFormPostResult resp = new ExtDirectFormPostResult(true);
        if (file != null && !file.isEmpty()) {
            logger.debug("File1 Name : " + file.getName());
            logger.debug("File1 Bytes: " + file.getSize());
            String fileExtension = FileUtil.getExtension(file.getOriginalFilename()).toLowerCase();

            if (!"jpg".equals(fileExtension)) {
                //throw new Exception("jpg 파일로 올려주세요.");
                return ((ExtDirectFormPostResult) new ExtDirectFormPostResult(false));
            }

            String path = ConfigUtil.getUploadBasePath(FILE_TYPE_OF_PHOTO);
            if (file.getSize() > 0) {
                File tmpFile = new File(path + "/" + personNumb + '.' + fileExtension);
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
     * 인사기본자료정보 삭제시 급여, 근태정보 존재 체크
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "human")
    public String personalInfoDelete(Map param, LoginVO login) throws Exception {
        String rtnV = "";
        try{
        	
        	Map checkMap1 = (Map) super.commonDao.select("hum100ukrServiceImpl.personalInfoDeleteCheck", param);
        	
        	if(ObjUtils.isNotEmpty(checkMap1)){
        		//인사기본자료정보 삭제시 급여, 근태정보 존재
        		rtnV = "C";
        	}else{
        		
                // 저장한 파일 삭제
                String fileData = (String)super.commonDao.select("hum100ukrServiceImpl.getDeleteFileList", param);
                if(!ObjUtils.isEmpty(fileData) || !"".equals(fileData)){
                	param.put("DEL_FIDS", fileData);
                    deleteFileInfo(param, login);
                }
                
                //해당 사원 정보들 전부 삭제 
                super.commonDao.delete("hum100ukrServiceImpl.personalInfoDelete", param);
                rtnV = "Y";
        	}
        }catch(Exception e){
        	//에러
        	rtnV = "N";
        }
        
        return rtnV;
    } 
    
    /**
     * 저장되있는 사번코드 체크 로직 
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(group = "human")
    public String personNumbCheck(Map param) throws Exception {
        String rtnV = "";
    	Map checkMap1 = (Map) super.commonDao.select("hum100ukrServiceImpl.personNumbCheck", param);
    	if(ObjUtils.isEmpty(checkMap1)){
    		rtnV = "Y";
    	}else{
            rtnV = "N";
    	}
        return rtnV;
    } 
    /**
     * 인사자료조회-가족사항
     *
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "hum" )
    public List<Map<String, Object>> familyList( Map param ) throws Exception {
    	List<Map<String, Object>> dataList = super.commonDao.list("hum100ukrServiceImpl.familyList", param);
    	
    	for(Map dataMap : dataList){
    		dataMap.put("REPRE_NUM_EXPOS", decrypto.getDecryptWithType(dataMap.get("REPRE_NUM"),param.get("S_COMP_CODE") , "hum100ukr", "A"));
    	}
        return dataList;
    }

    /**
     * 인사자료입력-가족사항 주민번호 중복 조회
     *
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( value = ExtDirectMethodType.FORM_LOAD, group = "hum" )
    public Object chkFamilyRepreNum( Map param ) throws Exception {
        return super.commonDao.select("hum100ukrServiceImpl.chkFamilyRepreNum", param);
    }

    /**
     * 인사자료입력-가족사항 저장
     *
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_SYNCALL, group = "hum" )
    public List<Map> savefamilyAll( List<Map> paramList, Map paramMaster, LoginVO user ) throws Exception {

        List<Map> dataList = new ArrayList<Map>();

        List<Map> insertList = new ArrayList<Map>();
        List<Map> updateList = new ArrayList<Map>();
        List<Map> deleteList = new ArrayList<Map>();

        if (paramList != null) {
            for (Map param : paramList) {
                dataList = (List<Map>)param.get("data");

                if (param.get("method").equals("insertFamilyInfo")) {
                    insertList.addAll((List<Map>)param.get("data"));
                } else if (param.get("method").equals("updateFamilyInfo")) {
                    updateList.addAll((List<Map>)param.get("data"));
                } else if (param.get("method").equals("deleteFamilyInfo")) {
                    deleteList.addAll((List<Map>)param.get("data"));
                }
            }

            deleteFamilyInfo(deleteList);
            insertFamilyInfo(insertList);
            updateFamilyInfo(updateList);
        }

        paramList.add(0, paramMaster);

        return paramList;
    }

    /**
     * 인사자료조회-가족사항 등록
     *
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "hum" )
    public List<Map> insertFamilyInfo( List<Map> paramList ) throws Exception {

        for (Map param : paramList) {
            super.commonDao.insert("hum100ukrServiceImpl.insertFamilyInfo", param);
        }
        return paramList;
    }

    /**
     * 인사자료조회-가족사항 수정
     *
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "hum" )
    public List<Map> updateFamilyInfo( List<Map> paramList ) throws Exception {

        for (Map param : paramList) {
            super.commonDao.update("hum100ukrServiceImpl.updateFamilyInfo", param);
        }
        return paramList;
    }

    /**
     * 인사자료조회-가족사항 삭제
     *
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "hum" )
    public List<Map> deleteFamilyInfo( List<Map> paramList ) throws Exception {

        for (Map param : paramList) {
            super.commonDao.update("hum100ukrServiceImpl.deleteFamilyInfo", param);
        }
        return paramList;
    }

    /**
     * 인사자료조회-신상정보
     *
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( value = ExtDirectMethodType.FORM_LOAD, group = "hum" )
    public Object healthInfo( Map param ) throws Exception {
        return super.commonDao.select("hum100ukrServiceImpl.healthInfo", param);
    }

    /**
     * 인사자료조회-신상정보 저장
     *
     * @param param
     * @param login
     * @param result
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "Hum", value = ExtDirectMethodType.FORM_POST )
    public ExtDirectFormPostResult saveHum710( Hum710ukrModel param, LoginVO login, BindingResult result ) throws Exception {

        param.setS_COMP_CODE(login.getCompCode());
        param.setS_USER_ID(login.getUserID());

        super.commonDao.update("hum100ukrServiceImpl.saveHUM710", param);
        ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);
        extResult.addResultProperty("PERSON_NUM", param.getPERSON_NUMB());
        return extResult;
    }

    /**
     * 인사자료조회-고정지급/공제(고정지급)
     *
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "hum" )
    public List<Map<String, Object>> deductionInfo1( Map param ) throws Exception {
        return (List)super.commonDao.list("hum100ukrServiceImpl.deductionInfo1", param);
    }

    /**
     * 인사자료조회-고정지급/공제(고정지급) 수정
     *
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "hum" )
    public List<Map> saveHPA200( List<Map> paramList ) throws Exception {

        for (Map param : paramList) {
            super.commonDao.update("hum100ukrServiceImpl.saveHPA200", param);
        }
        return paramList;
    }

    /**
     * 인사자료조회-고정지급/공제(고정지급) 삭제
     *
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "hum" )
    public List<Map> deleteHPA200( List<Map> paramList ) throws Exception {

        for (Map param : paramList) {
            super.commonDao.update("hum100ukrServiceImpl.deleteHPA200", param);
        }
        return paramList;
    }

    /**
     * 인사자료조회-고정지급/공제(공제)
     *
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "hum" )
    public List<Map<String, Object>> deductionInfo2( Map param ) throws Exception {
        return (List)super.commonDao.list("hum100ukrServiceImpl.deductionInfo2", param);
    }

    /**
     * 인사자료조회-고정지급/공제(공제) 수정
     *
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "hum" )
    public List<Map> saveHPA500( List<Map> paramList ) throws Exception {

        for (Map param : paramList) {
            super.commonDao.update("hum100ukrServiceImpl.saveHPA500", param);
        }
        return paramList;
    }

    /**
     * 인사자료조회-고정지급/공제(공제) 삭제
     *
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "hum" )
    public List<Map> deleteHPA500( List<Map> paramList ) throws Exception {

        for (Map param : paramList) {
            super.commonDao.update("hum100ukrServiceImpl.deleteHPA500", param);
        }
        return paramList;
    }

    /**
     * 인사자료조회-경력사항
     *
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "hum" )
    public List<Map<String, Object>> careerInfo( Map param ) throws Exception {
        return (List)super.commonDao.list("hum100ukrServiceImpl.careerInfo", param);
    }

    /**
     * 인사자료입력-경력사항 저장
     *
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_SYNCALL, group = "hum" )
    public List<Map> saveCareerAll( List<Map> paramList, Map paramMaster, LoginVO user ) throws Exception {

        List<Map> dataList = new ArrayList<Map>();

        List<Map> insertList = new ArrayList<Map>();
        List<Map> updateList = new ArrayList<Map>();
        List<Map> deleteList = new ArrayList<Map>();

        if (paramList != null) {
            for (Map param : paramList) {
                dataList = (List<Map>)param.get("data");

                if (param.get("method").equals("insertHUM500")) {
                    insertList.addAll((List<Map>)param.get("data"));
                } else if (param.get("method").equals("updateHUM500")) {
                    updateList.addAll((List<Map>)param.get("data"));
                } else if (param.get("method").equals("deleteHUM500")) {
                    deleteList.addAll((List<Map>)param.get("data"));
                }
            }

            deleteHUM500(deleteList, user);
            insertHUM500(insertList, user);
            updateHUM500(updateList);
        }

        paramList.add(0, paramMaster);

        return paramList;
    }

    /**
     * 인사자료조회-경력사항 등록
     *
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "hum" )
    public List<Map> insertHUM500( List<Map> paramList , LoginVO user) throws Exception {

        Map rwpTemp1 = new HashMap();

        for (Map param : paramList) {
            Map calcWorkProd1 = (Map) super.commonDao.select("hum100ukrServiceImpl.calcWorkProd1", param);
            param.put("CALC_WORK_PROD1",calcWorkProd1.get("CALC_WORK_PROD1"));
            Map calcWorkProd2 = (Map) super.commonDao.select("hum100ukrServiceImpl.calcWorkProd2", param);
            param.put("WORK_PROD",calcWorkProd2.get("CALC_WORK_PROD2"));

            super.commonDao.insert("hum100ukrServiceImpl.insertHUM500", param);

            rwpTemp1.put("PERSON_NUMB", param.get("PERSON_NUMB"));
        }

        rwpTemp1.put("S_COMP_CODE", user.getCompCode());
        List<Map> rwpParamList =  super.commonDao.list("hum100ukrServiceImpl.selectHum500t", rwpTemp1);

        int cwptemp1 = 0;
        for (Map rwpTemp2 : rwpParamList) {
            Map calcWorkProd3 = (Map) super.commonDao.select("hum100ukrServiceImpl.calcWorkProd1", rwpTemp2);
            cwptemp1 = cwptemp1 + Integer.parseInt(ObjUtils.getSafeString(calcWorkProd3.get("CALC_WORK_PROD1")));
        }

        Map rwpTemp3 = new HashMap();
        rwpTemp3.put("CALC_WORK_PROD1", cwptemp1);
        Map calcWorkProd4 = (Map) super.commonDao.select("hum100ukrServiceImpl.calcWorkProd2", rwpTemp3);

        Map rwpTemp4 = new HashMap();
        rwpTemp4.put("S_COMP_CODE",user.getCompCode());
        rwpTemp4.put("S_USER_ID",user.getUserID());
        rwpTemp4.put("PERSON_NUMB",rwpTemp1.get("PERSON_NUMB"));
        rwpTemp4.put("REAL_WORK_PROD",calcWorkProd4.get("CALC_WORK_PROD2"));
        super.commonDao.update("hum100ukrServiceImpl.updateRealWorkProd", rwpTemp4);

        return paramList;
    }

    /**
     * 인사자료조회-경력사항 수정
     *
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "hum" )
    public List<Map> updateHUM500( List<Map> paramList ) throws Exception {

        for (Map param : paramList) {
            super.commonDao.update("hum100ukrServiceImpl.updateHUM500", param);
        }
        return paramList;
    }

    /**
     * 인사자료조회-경력사항 삭제
     *
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "hum" )
    public List<Map> deleteHUM500( List<Map> paramList, LoginVO user ) throws Exception {

        Map rwpTemp1 = new HashMap();

        for (Map param : paramList) {
            super.commonDao.update("hum100ukrServiceImpl.deleteHUM500", param);

            rwpTemp1.put("PERSON_NUMB", param.get("PERSON_NUMB"));
        }

        rwpTemp1.put("S_COMP_CODE", user.getCompCode());
        List<Map> rwpParamList =  super.commonDao.list("hum100ukrServiceImpl.selectHum500t", rwpTemp1);

        int cwptemp1 = 0;
        for (Map rwpTemp2 : rwpParamList) {
            Map calcWorkProd3 = (Map) super.commonDao.select("hum100ukrServiceImpl.calcWorkProd1", rwpTemp2);
            cwptemp1 = cwptemp1 + Integer.parseInt(ObjUtils.getSafeString(calcWorkProd3.get("CALC_WORK_PROD1")));
        }

        Map rwpTemp3 = new HashMap();
        rwpTemp3.put("CALC_WORK_PROD1", cwptemp1);
        Map calcWorkProd4 = (Map) super.commonDao.select("hum100ukrServiceImpl.calcWorkProd2", rwpTemp3);

        Map rwpTemp4 = new HashMap();
        rwpTemp4.put("S_COMP_CODE",user.getCompCode());
        rwpTemp4.put("S_USER_ID",user.getUserID());
        rwpTemp4.put("PERSON_NUMB",rwpTemp1.get("PERSON_NUMB"));
        rwpTemp4.put("REAL_WORK_PROD",calcWorkProd4.get("CALC_WORK_PROD2"));
        super.commonDao.update("hum100ukrServiceImpl.updateRealWorkProd", rwpTemp4);

        return paramList;
    }

    /**
     * 인사자료조회-학력사항
     *
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "hum" )
    public List<Map<String, Object>> academicBakground( Map param ) throws Exception {
        return (List)super.commonDao.list("hum100ukrServiceImpl.academicBakground", param);
    }

    /**
     * 인사자료조회-학력사항 등록
     *
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "hum" )
    public List<Map> insertHUM720( List<Map> paramList ) throws Exception {

        for (Map param : paramList) {
            super.commonDao.insert("hum100ukrServiceImpl.insertHUM720", param);
        }
        return paramList;
    }

    /**
     * 인사자료조회-학력사항 수정
     *
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "hum" )
    public List<Map> updateHUM720( List<Map> paramList ) throws Exception {

        for (Map param : paramList) {
            super.commonDao.update("hum100ukrServiceImpl.updateHUM720", param);
        }
        return paramList;
    }

    /**
     * 인사자료조회-학력사항 삭제
     *
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "hum" )
    public List<Map> deleteHUM720( List<Map> paramList ) throws Exception {

        for (Map param : paramList) {
            super.commonDao.update("hum100ukrServiceImpl.deleteHUM720", param);
        }
        return paramList;
    }

    /**
     * 인사자료조회-교육사항
     *
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "hum" )
    public List<Map<String, Object>> educationInfo( Map param ) throws Exception {
        return (List)super.commonDao.list("hum100ukrServiceImpl.educationInfo", param);
    }

    /**
     * 인사자료조회-교육사항 등록
     *
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "hum" )
    public List<Map> insertHUM740( List<Map> paramList ) throws Exception {

        for (Map param : paramList) {
            super.commonDao.insert("hum100ukrServiceImpl.insertHUM740", param);
        }
        return paramList;
    }

    /**
     * 인사자료조회-교육사항 수정
     *
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "hum" )
    public List<Map> updateHUM740( List<Map> paramList ) throws Exception {

        for (Map param : paramList) {
            super.commonDao.update("hum100ukrServiceImpl.updateHUM740", param);
        }
        return paramList;
    }

    /**
     * 인사자료조회-교육사항 삭제
     *
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "hum" )
    public List<Map> deleteHUM740( List<Map> paramList ) throws Exception {

        for (Map param : paramList) {
            super.commonDao.update("hum100ukrServiceImpl.deleteHUM740", param);
        }
        return paramList;
    }

    /**
     * 인사자료조회-자격면허
     *
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "hum" )
    public List<Map<String, Object>> certificateInfo( Map param ) throws Exception {
        return (List)super.commonDao.list("hum100ukrServiceImpl.certificateInfo", param);
    }

    /**
     * 인사자료입력-자격면허 저장
     *
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_SYNCALL, group = "hum" )
    public List<Map> saveCertificateAll( List<Map> paramList, Map paramMaster, LoginVO user ) throws Exception {

        List<Map> dataList = new ArrayList<Map>();

        List<Map> insertList = new ArrayList<Map>();
        List<Map> updateList = new ArrayList<Map>();
        List<Map> deleteList = new ArrayList<Map>();

        if (paramList != null) {
            for (Map param : paramList) {
                dataList = (List<Map>)param.get("data");

                if (param.get("method").equals("insertHUM600")) {
                    insertList.addAll((List<Map>)param.get("data"));
                } else if (param.get("method").equals("updateHUM600")) {
                    updateList.addAll((List<Map>)param.get("data"));
                } else if (param.get("method").equals("deleteHUM600")) {
                    deleteList.addAll((List<Map>)param.get("data"));
                }
            }

            deleteHUM600(deleteList);
            insertHUM600(insertList);
            updateHUM600(updateList);
        }

        paramList.add(0, paramMaster);

        return paramList;
    }

    /**
     * 인사자료조회-자격면허 등록
     *
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "hum" )
    public List<Map> insertHUM600( List<Map> paramList ) throws Exception {

        for (Map param : paramList) {
            super.commonDao.insert("hum100ukrServiceImpl.insertHUM600", param);
        }
        return paramList;
    }

    /**
     * 인사자료조회-자격면허 수정
     *
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "hum" )
    public List<Map> updateHUM600( List<Map> paramList ) throws Exception {

        for (Map param : paramList) {
            super.commonDao.update("hum100ukrServiceImpl.updateHUM600", param);
        }
        return paramList;
    }

    /**
     * 인사자료조회 자격면허 삭제
     *
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "hum" )
    public List<Map> deleteHUM600( List<Map> paramList ) throws Exception {

        for (Map param : paramList) {
            super.commonDao.update("hum100ukrServiceImpl.deleteHUM600", param);
        }
        return paramList;
    }

    /**
     * 인사자료조회-인사변동
     *
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "hum" )
    public List<Map<String, Object>> hrChanges( Map param ) throws Exception {
        return (List)super.commonDao.list("hum100ukrServiceImpl.hrChanges", param);
    }

    /**
     * 인사자료조회-인사변동 등록
     *
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "hum" )
    public List<Map> insertHUM760( List<Map> paramList ) throws Exception {

        for (Map param : paramList) {
            super.commonDao.insert("hum100ukrServiceImpl.saveHRHUM100", param);
            super.commonDao.update("hum100ukrServiceImpl.insertHUM760", param);
        }
        return paramList;
    }

    /**
     * 인사자료조회-인사변동 수정
     *
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "hum" )
    public List<Map> updateHUM760( List<Map> paramList ) throws Exception {

        for (Map param : paramList) {
            super.commonDao.update("hum100ukrServiceImpl.saveHRHUM100", param);
            super.commonDao.update("hum100ukrServiceImpl.updateHUM760", param);
        }
        return paramList;
    }

    /**
     * 인사자료조회 인사변동 삭제
     *
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "hum" )
    public List<Map> deleteHUM760( List<Map> paramList ) throws Exception {

        for (Map param : paramList) {
            super.commonDao.update("hum100ukrServiceImpl.deleteHUM760", param);
        }
        return paramList;
    }

    /**
     * 인사자료조회-고과사항
     *
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "hum" )
    public List<Map<String, Object>> personalRating( Map param ) throws Exception {
        return (List)super.commonDao.list("hum100ukrServiceImpl.personalRating", param);
    }

    /**
     * 인사자료조회-고과사항 등록
     *
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "hum" )
    public List<Map> insertHUM770( List<Map> paramList ) throws Exception {

        for (Map param : paramList) {
            super.commonDao.update("hum100ukrServiceImpl.insertHUM770", param);
        }
        return paramList;
    }

    /**
     * 인사자료조회-고과사항 수정
     *
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "hum" )
    public List<Map> updateHUM770( List<Map> paramList ) throws Exception {

        for (Map param : paramList) {
            super.commonDao.update("hum100ukrServiceImpl.updateHUM770", param);
        }
        return paramList;
    }

    /**
     * 인사자료조회 고과사항 삭제
     *
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "hum" )
    public List<Map> deleteHUM770( List<Map> paramList ) throws Exception {

        for (Map param : paramList) {
            super.commonDao.update("hum100ukrServiceImpl.deleteHUM770", param);
        }
        return paramList;
    }

    /**
     * 인사자료조회-상벌사항
     *
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "hum" )
    public List<Map<String, Object>> disciplinaryInfo( Map param ) throws Exception {
        return (List)super.commonDao.list("hum100ukrServiceImpl.disciplinaryInfo", param);
    }

    /**
     * 인사자료조회-상벌사항 등록
     *
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "hum" )
    public List<Map> insertHUM810( List<Map> paramList ) throws Exception {

        for (Map param : paramList) {
            super.commonDao.update("hum100ukrServiceImpl.insertHUM810", param);
        }
        return paramList;
    }

    /**
     * 인사자료조회-상벌사항 수정
     *
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "hum" )
    public List<Map> updateHUM810( List<Map> paramList ) throws Exception {

        for (Map param : paramList) {
            super.commonDao.update("hum100ukrServiceImpl.updateHUM810", param);
        }
        return paramList;
    }

    /**
     * 인사자료조회 상벌사항 삭제
     *
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "hum" )
    public List<Map> deleteHUM810( List<Map> paramList ) throws Exception {

        for (Map param : paramList) {
            super.commonDao.update("hum100ukrServiceImpl.deleteHUM810", param);
        }
        return paramList;
    }

    /**
     * 인사자료조회-계약사항
     *
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "hum" )
    public List<Map<String, Object>> contractInfo( Map param ) throws Exception {
        return (List)super.commonDao.list("hum100ukrServiceImpl.contractInfo", param);
    }

    /**
     * 인사자료조회-계약사항 등록
     *
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "hum" )
    public List<Map> insertHUM840( List<Map> paramList ) throws Exception {

        for (Map param : paramList) {
            super.commonDao.update("hum100ukrServiceImpl.insertHUM840", param);
        }
        return paramList;
    }

    /**
     * 인사자료조회-계약사항 수정
     *
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "hum" )
    public List<Map> updateHUM840( List<Map> paramList ) throws Exception {

        for (Map param : paramList) {
            super.commonDao.update("hum100ukrServiceImpl.updateHUM840", param);
        }
        return paramList;
    }

    /**
     * 인사자료조회 계약사항 삭제
     *
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "hum" )
    public List<Map> deleteHUM840( List<Map> paramList ) throws Exception {

        for (Map param : paramList) {
            super.commonDao.update("hum100ukrServiceImpl.deleteHUM840", param);
        }
        return paramList;
    }

    /**
     * 인사자료조회-비자여권(여권)
     *
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "hum" )
    public List<Map<String, Object>> passportInfo( Map param ) throws Exception {
        return (List)super.commonDao.list("hum100ukrServiceImpl.passportInfo", param);
    }

    /**
     * 인사자료조회-비자여권(여권) 등록
     *
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "hum" )
    public List<Map> insertHUM730( List<Map> paramList ) throws Exception {

        for (Map param : paramList) {
            super.commonDao.update("hum100ukrServiceImpl.insertHUM730", param);
        }
        return paramList;
    }

    /**
     * 인사자료조회-비자여권(여권) 수정
     *
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "hum" )
    public List<Map> updateHUM730( List<Map> paramList ) throws Exception {

        for (Map param : paramList) {
            super.commonDao.update("hum100ukrServiceImpl.updateHUM730", param);
        }
        return paramList;
    }

    /**
     * 인사자료조회 비자여권(여권) 삭제
     *
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "hum" )
    public List<Map> deleteHUM730( List<Map> paramList ) throws Exception {

        for (Map param : paramList) {
            super.commonDao.update("hum100ukrServiceImpl.deleteHUM730", param);
        }
        return paramList;
    }

    /**
     * 인사자료조회-비자여권(비자)
     *
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "hum" )
    public List<Map<String, Object>> visaInfo( Map param ) throws Exception {
        return (List)super.commonDao.list("hum100ukrServiceImpl.visaInfo", param);
    }

    /**
     * 인사자료조회-비자여권(비자) 등록
     *
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "hum" )
    public List<Map> insertHUM731( List<Map> paramList ) throws Exception {

        for (Map param : paramList) {
            super.commonDao.update("hum100ukrServiceImpl.insertHUM731", param);
        }
        return paramList;
    }

    /**
     * 인사자료조회-비자여권(비자) 수정
     *
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "hum" )
    public List<Map> updateHUM731( List<Map> paramList ) throws Exception {

        for (Map param : paramList) {
            super.commonDao.update("hum100ukrServiceImpl.updateHUM731", param);
        }
        return paramList;
    }

    /**
     * 인사자료조회 비자여권(비자) 삭제
     *
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "hum" )
    public List<Map> deleteHUM731( List<Map> paramList ) throws Exception {

        for (Map param : paramList) {
            super.commonDao.update("hum100ukrServiceImpl.deleteHUM731", param);
        }
        return paramList;
    }

    /**
     * 인사자료조회-해외출장
     *
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "hum" )
    public List<Map<String, Object>> abroadTrip( Map param ) throws Exception {
        return (List)super.commonDao.list("hum100ukrServiceImpl.abroadTrip", param);
    }

    /**
     * 인사자료조회-해외출장 등록
     *
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "hum" )
    public List<Map> insertHUM830( List<Map> paramList ) throws Exception {

        for (Map param : paramList) {
            super.commonDao.update("hum100ukrServiceImpl.insertHUM830", param);
        }
        return paramList;
    }

    /**
     * 인사자료조회-해외출장 수정
     *
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "hum" )
    public List<Map> updateHUM830( List<Map> paramList ) throws Exception {

        for (Map param : paramList) {
            super.commonDao.update("hum100ukrServiceImpl.updateHUM830", param);
        }
        return paramList;
    }

    /**
     * 인사자료조회 해외출장 삭제
     *
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "hum" )
    public List<Map> deleteHUM830( List<Map> paramList ) throws Exception {

        for (Map param : paramList) {
            super.commonDao.update("hum100ukrServiceImpl.deleteHUM830", param);
        }
        return paramList;
    }

    /**
     * 인사자료조회-학자금지원
     *
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "hum" )
    public List<Map<String, Object>> schoolExpence( Map param ) throws Exception {
        return (List)super.commonDao.list("hum100ukrServiceImpl.schoolExpence", param);
    }

    /**
     * 인사자료조회-학자금지원 등록
     *
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "hum" )
    public List<Map> insertHUM820( List<Map> paramList ) throws Exception {

        for (Map param : paramList) {
            super.commonDao.update("hum100ukrServiceImpl.insertHUM820", param);
        }
        return paramList;
    }

    /**
     * 인사자료조회-학자금지원 수정
     *
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "hum" )
    public List<Map> updateHUM820( List<Map> paramList ) throws Exception {

        for (Map param : paramList) {
            super.commonDao.update("hum100ukrServiceImpl.updateHUM820", param);
        }
        return paramList;
    }

    /**
     * 인사자료조회 학자금지원 삭제
     *
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "hum" )
    public List<Map> deleteHUM820( List<Map> paramList ) throws Exception {

        for (Map param : paramList) {
            super.commonDao.update("hum100ukrServiceImpl.deleteHUM820", param);
        }
        return paramList;
    }

    /**
     * 인사자료조회-추천인
     *
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( value = ExtDirectMethodType.FORM_LOAD, group = "hum" )
    public Object recommender( Map param ) throws Exception {
        return super.commonDao.select("hum100ukrServiceImpl.recommender", param);
    }

    /**
     * 인사자료조회-추천인 저장
     *
     * @param param
     * @param login
     * @param result
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "Hum", value = ExtDirectMethodType.FORM_POST )
    public ExtDirectFormPostResult saveHum790( Hum790ukrModel param, LoginVO login, BindingResult result ) throws Exception {

        param.setS_COMP_CODE(login.getCompCode());
        param.setS_USER_ID(login.getUserID());

        if (param.getRECOMMEND1_ZIP_CODE() != null) {
            String zipCode = ObjUtils.getSafeString(param.getRECOMMEND1_ZIP_CODE()).replace("-", "");
            param.setRECOMMEND1_ZIP_CODE(zipCode);
        }
        if (param.getRECOMMEND2_ZIP_CODE() != null) {
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
     *
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( value = ExtDirectMethodType.FORM_LOAD, group = "hum" )
    public Object surety( Map param ) throws Exception {
        return super.commonDao.select("hum100ukrServiceImpl.surety", param);
    }

    /**
     * 인사자료조회-추천인 저장
     *
     * @param param
     * @param login
     * @param result
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "Hum", value = ExtDirectMethodType.FORM_POST )
    public ExtDirectFormPostResult saveHum800( Hum800ukrModel param, LoginVO login, BindingResult result ) throws Exception {

        param.setS_COMP_CODE(login.getCompCode());
        param.setS_USER_ID(login.getUserID());

        if (param.getGUARANTOR1_ZIP_CODE() != null) {
            String zipCode = ObjUtils.getSafeString(param.getGUARANTOR1_ZIP_CODE()).replace("-", "");
            param.setGUARANTOR1_ZIP_CODE(zipCode);
        }
        if (param.getGUARANTOR2_ZIP_CODE() != null) {
            String zipCode = ObjUtils.getSafeString(param.getGUARANTOR2_ZIP_CODE()).replace("-", "");
            param.setGUARANTOR2_ZIP_CODE(zipCode);
        }
        if (param.getGUARANTOR1_RES_NO() != null) {
            String resNo1 = ObjUtils.getSafeString(param.getGUARANTOR1_RES_NO()).replace("-", "");
            param.setGUARANTOR1_RES_NO(resNo1);
        }
        if (param.getGUARANTOR2_RES_NO() != null) {
            String resNo2 = ObjUtils.getSafeString(param.getGUARANTOR2_RES_NO()).replace("-", "");
            param.setGUARANTOR2_RES_NO(resNo2);
        }

        super.commonDao.update("hum100ukrServiceImpl.saveHUM800", param);
        ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);
        extResult.addResultProperty("PERSON_NUM", param.getPERSON_NUMB());
        return extResult;
    }

    @ExtDirectMethod( group = "hum" )
    public List<Map> syncAll(  List<Map> paramList, Map paramMaster, LoginVO user ) throws Exception {
    	List<Map> dataList = new ArrayList<Map>();

        List<Map> insertList = new ArrayList<Map>();
        List<Map> updateList = new ArrayList<Map>();
        List<Map> deleteList = new ArrayList<Map>();

        if (paramList != null) {
            for (Map param : paramList) {
                dataList = (List<Map>)param.get("data");

                if (param.get("method").equals("insertHUM840")) {
                    insertList.addAll((List<Map>)param.get("data"));
                } else if (param.get("method").equals("updateHUM840")) {
                    updateList.addAll((List<Map>)param.get("data"));
                } else if (param.get("method").equals("deleteHUM840")) {
                    deleteList.addAll((List<Map>)param.get("data"));
                }
            }

            deleteHUM840(deleteList);
            insertHUM840(insertList);
            updateHUM840(updateList);
        }

        paramList.add(0, paramMaster);

        return paramList;
    }

    /**
     * 급호봉 코드 정보
     *
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "hum", value = ExtDirectMethodType.STORE_READ )
    public List<Map<String, Object>> fnHum100P2Codes( Map param ) throws Exception {
        return (List<Map<String, Object>>)super.commonDao.list("hum100ukrServiceImpl.fnHum100P2Code", param);
    }

    /**
     * 급호봉조회 popup
     *
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "hum", value = ExtDirectMethodType.STORE_READ )
    public List<Map<String, Object>> fnHum100P2( Map param ) throws Exception {
        List<Map<String, Object>> codeList = (List<Map<String, Object>>)super.commonDao.list("hum100ukrServiceImpl.fnHum100P2Code", param);
        String codeSql = "";
        boolean isFirst = true;
        for (Map<String, Object> codeMap : codeList) {
            String wageCode = ObjUtils.getSafeString(codeMap.get("WAGES_CODE"));
            codeSql = codeSql + ", '" + wageCode + "' AS CODE" + wageCode + " \n";
            if (isFirst) {
                codeSql = codeSql + "  , MAX(CASE WHEN A.WAGES_CODE = '" + wageCode + "'";
                codeSql = codeSql + "                THEN A.WAGES_I";
                codeSql = codeSql + "                ELSE 0";
                codeSql = codeSql + "            END) AS STD100\n";
            } else {
                codeSql = codeSql + "  , MAX(CASE WHEN A.WAGES_CODE = '" + wageCode + "'";
                codeSql = codeSql + "                THEN A.WAGES_I";
                codeSql = codeSql + "                ELSE 0";
                codeSql = codeSql + "            END) AS STD" + wageCode + " \n";
            }
            isFirst = false;

        }
        param.put("CODE_SQL", codeSql);
        return (List)super.commonDao.list("hum100ukrServiceImpl.fnHum100P2", param);
    }
    
    
    
    
    /**
	 * 문서개수
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "hum", value = ExtDirectMethodType.STORE_READ)
	public Object selectDocCnt(Map param) throws Exception {
		
		return super.commonDao.select("hum100ukrServiceImpl.selectDocCnt", param);
	}
	
    /**
	 * 첨부파일 목록 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "hum", value = ExtDirectMethodType.FORM_LOAD)
	public List<Map<String, Object>> getFileList(Map param,  LoginVO login) throws Exception {
		
		param.put("S_COMP_CODE", login.getCompCode());
		
		return super.commonDao.list("hum100ukrServiceImpl.getFileList", param);
	}
	
	/**
	 * 첨부파일 저장
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "hum", value = ExtDirectMethodType.STORE_MODIFY)
	public int insertFileInfo(Map param, LoginVO login) throws Exception {

		int insRtn = 0;  // 실행 완료 row 갯수
		
		logger.debug("param:::"+param);
		logger.debug("param::::"+ ObjUtils.getSafeString(param.get("ADD_FIDS")));
		
		
		fileMnagerService.confirmFile(login, ObjUtils.getSafeString(param.get("ADD_FIDS")));
		String[] fids =  ObjUtils.getSafeString(param.get("ADD_FIDS")).split(",");

		 for(String fid : fids)	{
			 param.put("FID", fid);
			 insRtn += super.commonDao.insert("hum100ukrServiceImpl.insertFileInfo", param);
		 }
		 
		 return insRtn;
	}
	
	/**
	 * 첨부파일 삭제
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "hum", value = ExtDirectMethodType.STORE_MODIFY)
	public void deleteFileInfo(Map param, LoginVO login) throws Exception {
		
		// 선택한 파일 삭제
		fileMnagerService.deleteFile(login, ObjUtils.getSafeString(param.get("DEL_FIDS")));
		String[] fids =  ObjUtils.getSafeString(param.get("DEL_FIDS")).split(",");
		
		// 선택한 파일 정보 삭제
		 for(String fid : fids)	{
			 param.put("FID", fid);
			 super.commonDao.update("hum100ukrServiceImpl.deleteFileInfo", param);
		 }
	}
    
	/**
     * 인사자료조회-발령사항
     *
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "hum" )
    public List<Map<String, Object>> announceInfo( Map param ) throws Exception {
        return (List)super.commonDao.list("hum100ukrServiceImpl.announceInfo", param);
    }
    
    /**
     * 인사자료조회-학력사항
     *
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "hum" )
    public List<Map<String, Object>> academicBackground( Map param ) throws Exception {
        return (List)super.commonDao.list("hum100ukrServiceImpl.academicBackground", param);
    }
}
