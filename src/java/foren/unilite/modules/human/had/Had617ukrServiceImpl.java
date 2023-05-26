package foren.unilite.modules.human.had;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.StringReader;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.apache.commons.fileupload.DiskFileUpload;
import org.apache.commons.io.FileUtils;
import org.apache.commons.lang.StringUtils;
import org.codehaus.jackson.map.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Service;
import org.springframework.validation.BindingResult;
import org.springframework.validation.ObjectError;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.w3c.dom.Attr;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;

import com.dreamsecurity.exception.DVException;
import com.dreamsecurity.verify.DSTSPDFSig;
import com.epapyrus.api.ExportCustomFile;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.model.LoginVO;
import foren.framework.utils.ConfigUtil;
import foren.framework.utils.FileUtil;
import foren.framework.utils.GStringUtils;
import foren.framework.utils.MessageUtils;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.human.HumanCommonServiceImpl;


@Service("had617ukrService")
public class Had617ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@Resource( name = "humanCommonService" )
    private HumanCommonServiceImpl humanCommonService;
	private Map<String, String> taxGubunCode = null;
	/**
	 * 폼데이터  조회(정산항목)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "human")
	public List<Map<String, Object>> selectFormHad600(Map param, LoginVO user) throws Exception {
		List<Map<String, Object>> rv = null;		
		rv = (List) super.commonDao.list("had617ukrServiceImpl.selectFormHad600", param);
		return rv;
	}
		
	/**
	 * 폼데이터  조회(입력항목)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "human")
	public List<Map<String, Object>> selectFormHad400(Map param) throws Exception {
		List<Map<String, Object>> rv = (List)super.commonDao.list("had617ukrServiceImpl.selectFormHad400", param);
		return rv;
	}
	
	@ExtDirectMethod(group = "human")
	public Map<String, Object> selectPrev(Map param) throws Exception {
		Map<String, Object> rv = (Map)super.commonDao.select("had617ukrServiceImpl.selectPrevious", param);
		return rv;
	}
	
	@ExtDirectMethod(group = "human")
	public Map<String, Object> selectNext(Map param) throws Exception {
		Map<String, Object> rv = (Map)super.commonDao.select("had617ukrServiceImpl.selectNext", param);
		return rv;
	}
	
	
	/**
	 * 수정권한 여부 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "human")
	public Object selectAuth(Map param) throws Exception {
		return super.commonDao.select("had617ukrServiceImpl.selectAuth", param);
	}
	
	/**
	 * 기타수당내역 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "human")
	public List<Map<String, Object>> selectList02(Map param) throws Exception {
		return (List) super.commonDao.list("had617ukrServiceImpl.selectList02", param);
	}
	
	/**
	 * 상여내역 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "human")
	public List<Map<String, Object>> selectList03(Map param) throws Exception {
		return (List) super.commonDao.list("had617ukrServiceImpl.selectList03", param);
	}
	
	/**
	 * 년월차내역 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "human")
	public List<Map<String, Object>> selectList04(Map param) throws Exception {
		return (List) super.commonDao.list("had617ukrServiceImpl.selectList04", param);
	}
	
	/**
	 * 년월차내역 추가
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "human")
	public List<Map> insertList04(List<Map> paramList, LoginVO loginVO) throws Exception {

		for(Map param : paramList ) {
			param.put("BONUS_YYYYMM", param.get("BONUS_YYYYMM").toString().replace(".", ""));
			super.commonDao.insert("had617ukrServiceImpl.insertList04", param);
		}
		return paramList;
	}
	
	/**
	 * 선택된 행을 수정함(년월차 내역)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "human")
	public List<Map> updateList04(List<Map> paramList) throws Exception {
		for(Map param :paramList ) {
			super.commonDao.update("had617ukrServiceImpl.updateList04", param);
		}
		return paramList;
	}
	
	/**
	 * 산정내역(임원) 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "human")
	public List<Map<String, Object>> selectList05(Map param) throws Exception {
		return (List) super.commonDao.list("had617ukrServiceImpl.selectList05", param);
	}
	
	/**
	 * 중간정산 내역 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "human")
	public List<Map<String, Object>> selectList06(Map param) throws Exception {
		return (List) super.commonDao.list("had617ukrServiceImpl.selectList06", param);
	}
	
	/**
	 * 지급총액계산
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> fnSuppTotI(Map param) throws Exception {
		return (Map) super.commonDao.select("had617ukrServiceImpl.fnSuppTotI", param);
	}
	
	@ExtDirectMethod(group = "human")
	public Integer  syncAll(Map param) throws Exception {
		logger.debug("syncAll:" + param);
		return  0;
	}
	
	/**
	 * 집계자료 가져오기
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "human")
	public List<Map> selectSummaryData(Map param, LoginVO user) throws Exception {
		boolean chk = humanCommonService.fnCloseYn("Y", ObjUtils.getSafeString(param.get("YEAR_YYYY")),  user);
		Map chkTaxRate  = (Map) super.commonDao.select("had617ukrServiceImpl.checkTaxRate", param);
		if(ObjUtils.isEmpty(chkTaxRate))	{
			String msg = "54205;";
			throw new  UniDirectValidateException(this.getMessage(ObjUtils.getSafeString(msg), user));
		}
		Map checkTaxDedRate  = (Map) super.commonDao.select("had617ukrServiceImpl.checkTaxDedRate", param);
		if(ObjUtils.isEmpty(chkTaxRate))	{
			String msg = "54250;";
			throw new  UniDirectValidateException(this.getMessage(ObjUtils.getSafeString(msg), user));
		}
		return	(List<Map>)super.commonDao.list("had617ukrServiceImpl.selectSummaryData", param);
		
	}
	
	/**
	 * 집계자료 일괄적용 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "human")
	public void batchSummaryData(Map param) throws Exception {
		super.commonDao.update("had617ukrServiceImpl.batchSummaryData", param);
		
	}
	
	/**
	 * 정산 세액 계산 가져오기
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "human")
	public List<Map> selectCalculateTax(Map param, LoginVO user) throws Exception {
		boolean chk = humanCommonService.fnCloseYn("Y", ObjUtils.getSafeString(param.get("YEAR_YYYY")),  user);
		Map chkTaxRate  = (Map) super.commonDao.select("had617ukrServiceImpl.checkTaxRate", param);
		if(ObjUtils.isEmpty(chkTaxRate))	{
			String msg = "54205;";
			throw new  UniDirectValidateException(this.getMessage(ObjUtils.getSafeString(msg), user));
		}
		Map checkTaxDedRate  = (Map) super.commonDao.select("had617ukrServiceImpl.checkTaxDedRate", param);
		if(ObjUtils.isEmpty(chkTaxRate))	{
			String msg = "54250;";
			throw new  UniDirectValidateException(this.getMessage(ObjUtils.getSafeString(msg), user));
		}
		return	(List<Map>)super.commonDao.list("had617ukrServiceImpl.selectCalculateTax", param);
		
	}
	
	/**
	 * 정산 세액  일괄적용 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "human")
	public void batchCalculateTax(Map param) throws Exception {
		super.commonDao.update("had617ukrServiceImpl.batchCalculateTax", param);
		
	}
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "human")
	public List<Map> save400All(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {	
		if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("insert400")) {		
					insertList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("update400")) {
					updateList = (List<Map>)dataListMap.get("data");	
				} 
			}			
			if(insertList != null) this.insert400(insertList);
			if(updateList != null) this.update400(updateList);				
		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	}
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "human")
	List<Map> insert400(List<Map> paramList)	{
		for(Map param : paramList)	{			
			param.put("FORE_SINGLE_YN"		, this.getCheckboxValueYN(param.get("FORE_SINGLE_YN"),"FORE_SINGLE_YN") );
			param.put("FOREIGN_DISPATCH_YN"	, this.getCheckboxValueYN(param.get("FOREIGN_DISPATCH_YN"),"FOREIGN_DISPATCH_YN") );
			param.put("HOUSEHOLDER_YN"		, this.getCheckboxValueYN(param.get("HOUSEHOLDER_YN"),"HOUSEHOLDER_YN") );
			
			logger.debug(">>>>>>>>>>>>>    HOUSEHOLDER_YN :  "+param.get("HOUSEHOLDER_YN"));
			param.put("HALFWAY_TYPE"		, this.getCheckboxValueYN(param.get("HALFWAY_TYPE"),"HALFWAY_TYPE") );
			param.put("COMP_PREMINUM"		, this.getCheckboxValueYN(param.get("COMP_PREMINUM"),"COMP_PREMINUM") );
			
			super.commonDao.update("had617ukrServiceImpl.save400", param);
			param.put("FORE_SINGLE_YN"		, this.getCheckboxValueTF(param.get("FORE_SINGLE_YN"),"FORE_SINGLE_YN") );
			param.put("FOREIGN_DISPATCH_YN"	, this.getCheckboxValueTF(param.get("FOREIGN_DISPATCH_YN"),"FOREIGN_DISPATCH_YN") );
			param.put("HOUSEHOLDER_YN"		, this.getCheckboxValueTF(param.get("HOUSEHOLDER_YN"),"HOUSEHOLDER_YN") );
			param.put("HALFWAY_TYPE"		, this.getCheckboxValueTF(param.get("HALFWAY_TYPE"),"HALFWAY_TYPE") );
			param.put("COMP_PREMINUM"		, this.getCheckboxValueTF(param.get("COMP_PREMINUM"),"COMP_PREMINUM") );
			logger.debug("<<<<<<<<<<<<<<<<<<<<<<    HOUSEHOLDER_YN :  "+param.get("HOUSEHOLDER_YN"));
			
			
		}
		return paramList;
	}
	

	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "human")
	List<Map> update400(List<Map> paramList)	{
		for(Map param : paramList)	{
			param.put("FORE_SINGLE_YN"		, this.getCheckboxValueYN(param.get("FORE_SINGLE_YN"),"FORE_SINGLE_YN") );
			param.put("FOREIGN_DISPATCH_YN"	, this.getCheckboxValueYN(param.get("FOREIGN_DISPATCH_YN"),"FOREIGN_DISPATCH_YN") );
			param.put("HOUSEHOLDER_YN"		, this.getCheckboxValueYN(param.get("HOUSEHOLDER_YN"),"HOUSEHOLDER_YN") );
			param.put("HALFWAY_TYPE"		, this.getCheckboxValueYN(param.get("HALFWAY_TYPE"),"HALFWAY_TYPE") );
			param.put("COMP_PREMINUM"		, this.getCheckboxValueYN(param.get("COMP_PREMINUM"),"COMP_PREMINUM") );
			logger.debug(">>>>>>>>>>>>>    HOUSEHOLDER_YN :  "+param.get("HOUSEHOLDER_YN"));
			super.commonDao.update("had617ukrServiceImpl.save400", param);
			param.put("FORE_SINGLE_YN"		, this.getCheckboxValueTF(param.get("FORE_SINGLE_YN"),"FORE_SINGLE_YN") );
			param.put("FOREIGN_DISPATCH_YN"	, this.getCheckboxValueTF(param.get("FOREIGN_DISPATCH_YN"),"FOREIGN_DISPATCH_YN") );
			param.put("HOUSEHOLDER_YN"		, this.getCheckboxValueTF(param.get("HOUSEHOLDER_YN"),"HOUSEHOLDER_YN") );
			param.put("HALFWAY_TYPE"		, this.getCheckboxValueTF(param.get("HALFWAY_TYPE"),"HALFWAY_TYPE") );
			param.put("COMP_PREMINUM"		, this.getCheckboxValueTF(param.get("COMP_PREMINUM"),"COMP_PREMINUM") );
			logger.debug("<<<<<<<<<<<<<<<<<<<<<<    HOUSEHOLDER_YN :  "+param.get("HOUSEHOLDER_YN"));
		}
		return paramList;
	}
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "human")
	public List<Map> save600All(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {	
		if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("insert600")) {		
					insertList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("update600")) {
					updateList = (List<Map>)dataListMap.get("data");	
				} 
			}			
			if(insertList != null) this.insert600(insertList);
			if(updateList != null) this.update600(updateList);			
			
			//기부금 조정,연금저축소득공제금액 업데이트, 비과세소득금액 생성
			if(insertList != null) this.update600_2(insertList);
			if(updateList != null) this.update600_2(updateList);	
		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "human")
	List<Map> update600_2(List<Map> paramList)	{
		for(Map param : paramList)	{
			super.commonDao.update("had617ukrServiceImpl.save600_2", param);
		}
		return paramList;
	}
	
	/**
	 * 기부금만 update ( 정산세액계산하기 저장 내역이 없는 경우)
	 * @param paramList
	 * @return
	 */
	@ExtDirectMethod( group = "human")
	int update600_3(Map<String, Object> param)	{
		super.commonDao.update("had617ukrServiceImpl.save600_2", param);
		return 0;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "human")
	List<Map> insert600(List<Map> paramList)	{
		for(Map param : paramList)	{
			if (param.get("RETR_DATE")==null) {
				param.put("RETR_DATE", "00000000");
			}
			param.put("FORE_SINGLE_YN"		, this.getCheckboxValueYN(param.get("FORE_SINGLE_YN"),"FORE_SINGLE_YN") );
			param.put("FOREIGN_DISPATCH_YN"	, this.getCheckboxValueYN(param.get("FOREIGN_DISPATCH_YN"),"FOREIGN_DISPATCH_YN") );
			param.put("HOUSEHOLDER_YN"		, this.getCheckboxValueYN(param.get("HOUSEHOLDER_YN"),"HOUSEHOLDER_YN") );
			param.put("HALFWAY_TYPE"		, this.getCheckboxValueYN(param.get("HALFWAY_TYPE"),"HALFWAY_TYPE") );
			param.put("COMP_PREMINUM"		, this.getCheckboxValueYN(param.get("COMP_PREMINUM"),"COMP_PREMINUM") );
			
			super.commonDao.update("had617ukrServiceImpl.save600", param);
			param.put("FORE_SINGLE_YN"		, this.getCheckboxValueTF(param.get("FORE_SINGLE_YN"),"FORE_SINGLE_YN") );
			param.put("FOREIGN_DISPATCH_YN"	, this.getCheckboxValueTF(param.get("FOREIGN_DISPATCH_YN"),"FOREIGN_DISPATCH_YN") );
			param.put("HOUSEHOLDER_YN"		, this.getCheckboxValueTF(param.get("HOUSEHOLDER_YN"),"HOUSEHOLDER_YN") );
			param.put("HALFWAY_TYPE"		, this.getCheckboxValueTF(param.get("HALFWAY_TYPE"),"HALFWAY_TYPE") );
			param.put("COMP_PREMINUM"		, this.getCheckboxValueTF(param.get("COMP_PREMINUM"),"COMP_PREMINUM") );
		}
		return paramList;
	}
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "human")
	List<Map> update600(List<Map> paramList)	{
		for(Map param : paramList)	{
			if (param.get("RETR_DATE")==null) {
				param.put("RETR_DATE", "00000000");
			}
			param.put("FORE_SINGLE_YN"		, this.getCheckboxValueYN(param.get("FORE_SINGLE_YN"),"FORE_SINGLE_YN") );
			param.put("FOREIGN_DISPATCH_YN"	, this.getCheckboxValueYN(param.get("FOREIGN_DISPATCH_YN"),"FOREIGN_DISPATCH_YN") );
			param.put("HOUSEHOLDER_YN"		, this.getCheckboxValueYN(param.get("HOUSEHOLDER_YN"),"HOUSEHOLDER_YN") );
			param.put("HALFWAY_TYPE"		, this.getCheckboxValueYN(param.get("HALFWAY_TYPE"),"HALFWAY_TYPE") );
			param.put("COMP_PREMINUM"		, this.getCheckboxValueYN(param.get("COMP_PREMINUM"),"COMP_PREMINUM") );
			
			super.commonDao.update("had617ukrServiceImpl.save600", param);
			param.put("FORE_SINGLE_YN"		, this.getCheckboxValueTF(param.get("FORE_SINGLE_YN"),"FORE_SINGLE_YN") );
			param.put("FOREIGN_DISPATCH_YN"	, this.getCheckboxValueTF(param.get("FOREIGN_DISPATCH_YN"),"FOREIGN_DISPATCH_YN") );
			param.put("HOUSEHOLDER_YN"		, this.getCheckboxValueTF(param.get("HOUSEHOLDER_YN"),"HOUSEHOLDER_YN") );
			param.put("HALFWAY_TYPE"		, this.getCheckboxValueTF(param.get("HALFWAY_TYPE"),"HALFWAY_TYPE") );
			param.put("COMP_PREMINUM"		, this.getCheckboxValueTF(param.get("COMP_PREMINUM"),"COMP_PREMINUM") );
		}
		return paramList;
	}
	
	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.FORM_LOAD)
	public Object selectNap(Map param) throws Exception {
		return super.commonDao.select("had617ukrServiceImpl.selectNap", param);		
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_POST, group = "human")
	public ExtDirectFormPostResult napSyncMaster(Had617ukrNapModel param,  LoginVO user, BindingResult result) throws Exception {
		param.setS_COMP_CODE(user.getCompCode());
		param.setS_USER_ID(user.getUserID());
	
		super.commonDao.update("had617ukrServiceImpl.updateNap", param);
		ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);		
		return extResult;
	}
	
	@ExtDirectMethod(group = "human")
	public Map<String, Object> napDeleteAll(Map<String, Object> param) throws Exception {
		super.commonDao.update("had617ukrServiceImpl.deleteNap", param);
		return param;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "human")
	public List<Map<String, Object>> selectFamliy(Map param, LoginVO user) throws Exception {
		List<Map<String, Object>> rv = null;		
		rv = (List) super.commonDao.list("had617ukrServiceImpl.selectFamliy", param);
		return rv;
	}
	
	
	/**
	 * 의료비 추가 update
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "human")
	public Map<String, Object> updateMedI(Map<String, Object> param) throws Exception {
		super.commonDao.update("had617ukrServiceImpl.updateMedI", param);
		return param;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_LOAD, group = "human")
	public Object selectPDFSummary(Map param, LoginVO user) throws Exception {	
		return super.commonDao.select("had617ukrServiceImpl.selectPDFSummary", param);
	}	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "human")
	public List<Map<String, Object>> selectPdfList(Map param) throws Exception {	
		return super.commonDao.list("had617ukrServiceImpl.selectPdfList", param);
	}
	
	@ExtDirectMethod(group = "human")
	public Map spYearTaxPdf(Map sParam, LoginVO user) throws Exception {

		super.commonDao.queryForObject("had617ukrServiceImpl.sp2017YearTaxPDF", sParam);
		
		String errorDesc = ObjUtils.getSafeString(sParam.get("ErrorDesc"));
		
		if(ObjUtils.isNotEmpty(errorDesc))	{
			throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
		} 
		
		return  sParam;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "human")
	public List<Map> saveAllPdf(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		
		
		if(paramList != null)	{
			List<Map<String, Object>> updateList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("updatePdf")) {
					updateList = (List<Map<String, Object>>)dataListMap.get("data");	
				} 
			}	
			if(updateList != null) this.updatePdf(updateList);				
		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "human")
	public List<Map<String, Object>>  updatePdf(List<Map<String, Object>> paramList) throws Exception {
		
		for(Map param :paramList ) {
			if("true".equals(ObjUtils.getSafeString(param.get("TARGET_YN"))))	{
				param.put("TARGET_YN", "Y");
			} else {
				param.put("TARGET_YN", "N");
			}
			super.commonDao.update("had617ukrServiceImpl.updatePdf", param);
			
			if("Y".equals(param.get("TARGET_YN")))	{
				param.put("TARGET_YN", "true");
			} else {
				param.put("TARGET_YN", "false");
			}
		}
		return paramList;
	}
	/**
	 * PDF Upload
	 * @param file
	 * @param param
	 * @param login
	 * @return
	 * @throws IOException
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Human" , value = ExtDirectMethodType.FORM_POST)
    public ExtDirectFormPostResult pdfUploadFile( @RequestParam( "pdfFile" ) MultipartFile file, HadPdfModel param, LoginVO login, BindingResult result ) throws IOException, Exception {
        String personNumb = param.getPERSON_NUMB();
        String year = param.getYEAR_YYYY();
        String p_pwd = "";
        param.setFILE_NAME(file.getOriginalFilename());
        param.setS_COMP_CODE(login.getCompCode());
        param.setS_USER_ID(login.getUserID());
        param.setORG_FILE_NAME(file.getOriginalFilename());
      
        //String filename = param.getFILE_NAME();
        
       
        
        if (file != null && !file.isEmpty()) {
            logger.debug("File1 Name : " + file.getName());
            logger.debug("File1 Bytes: " + file.getSize());
            String fileExtension = FileUtil.getExtension(file.getOriginalFilename()).toLowerCase();
            
            if (!"pdf".equals(fileExtension)) {
            	String message = "pdf 파일로 올려주세요.";
            	logger.error(message);
            	result.addError(new ObjectError("errors",new String(message.getBytes("UTF-8"), "euc-kr" )));
				return new ExtDirectFormPostResult( result, true);
            }
            
            byte[] pdfBytes = file.getBytes();
            boolean isSuccess = false;
            /* [Step1] 전자문서 위변조 검증  */
            try
            {
            	// 진본성 검증 초기화  
            	DSTSPDFSig dstsPdfsig = new DSTSPDFSig();
                dstsPdfsig.init(pdfBytes);
                dstsPdfsig.tokenParse();
               //  전자문서 검증  
                isSuccess = dstsPdfsig.tokenVerify();
                if( isSuccess ){ 
                	logger.info("<!-- 검증 완료(진본) -->");
                }else {
                	String msg = dstsPdfsig.getTstVerifyFailInfo();
                	logger.error(msg);
                	result.addError(new ObjectError("errors",msg));
    				return new ExtDirectFormPostResult( result, false);
                }
            // 기타 검증결과는 Exception을 발생 시킴
            }catch (DVException ex) { 
            	logger.error("[Step1] 위변조 검증 실패( code : " + ex.getLastError() + ")");
            	logger.error("[Step1] 위변조 검증 실패( message : " + ex.getMessage() + ")");
            	//throw new UniDirectValidateException("[Step1] 위변조 검증 실패( code : " + ex.getLastError() + ")");
            	
            	String message = MessageUtils.getMessage("omegaplus.msg.had617pdf01", Locale.KOREA);//"[Step1] 위변조 검증 실패( message : " + ex.getMessage() + ")";
            	result.addError(new ObjectError("errors",message));
				return new ExtDirectFormPostResult( result, true);
            }
            
            String path = ConfigUtil.getUploadBasePath("/taxYear/");
            if (file.getSize() > 0) {
            	File directory1 = new File(path);
            	if(!directory1.exists())	{
            		directory1.mkdir();
            	}
            	path = path+"/"+param.getYEAR_YYYY()+"/";
            	File directory2 = new File(path);
            	if(!directory2.exists())	{
            		directory2.mkdir();
            	}
            	
            	 
            	ExportCustomFile pdf = new ExportCustomFile();
            	// 데이터 추출 
            	byte[] buf = pdf.NTS_GetFileBufEx(pdfBytes, p_pwd, "XML", false );
				int v_ret = pdf.NTS_GetLastError();
				
	            if ( v_ret == 1 ) {
	            	//File xmlFile = new File(path+"/"+param.getPERSON_NUMB()+".xml");
	            	String strXml = new String( buf, "UTF-8" );
	            	
	            	Path xmlFile = Paths.get(path+"/"+param.getPERSON_NUMB()+".xml");
	            	Files.write(xmlFile, buf);
	            }else if(v_ret == 0) { 
	            	
	            	String message = new String(MessageUtils.getMessage("omegaplus.msg.had617pdf03", Locale.KOREA).getBytes(), "UTF-8");//"<!-- 연말정산간소화 표준 전자문서가 아닙니다. -->";
	            	logger.error(message);
					result.addError(new ObjectError("errors",message ));
					return new ExtDirectFormPostResult( result, true);
	            }else if(v_ret == -1) { 
	            	
	            	String message = MessageUtils.getMessage("omegaplus.msg.had617pdf04", Locale.KOREA);//"<!-- 비밀번호가 맞지 않습니다. -->";
	            	logger.error(message);
	            	result.addError(new ObjectError("errors",message ));
					return new ExtDirectFormPostResult( result, true);
	            }else if(v_ret == -2) { 
	            	String message = MessageUtils.getMessage("omegaplus.msg.had617pdf05", Locale.KOREA);//"<!-- PDF문서가 아니거나 손상된 문서입니다. -->";
	            	logger.error(message);
					result.addError(new ObjectError("errors",message ));
					return new ExtDirectFormPostResult( result, true);
	            }else{ 
	            	String message = MessageUtils.getMessage("omegaplus.msg.had617pdf06", Locale.KOREA);//"<!-- 데이터 추출에 실패하였습니다. -->";
	            	logger.error(message);
					result.addError(new ObjectError("errors",message ));
					return new ExtDirectFormPostResult( result, true);
	            }
            }
        }
        ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);
        return extResult;
	}
	
	@ExtDirectMethod( group = "Human")
    public Object pdfRead( Map param, LoginVO login) throws IOException, Exception {
        String personNumb = ObjUtils.getSafeString(param.get("PERSON_NUMB"));
        String year = ObjUtils.getSafeString(param.get("YEAR_YYYY")); 
        String p_pwd = "";
        param.put("FILE_NAME", ConfigUtil.getUploadBasePath("/taxYear/"+param.get("YEAR_YYYY"))+"/" + personNumb + ".xml");
       
        //String filename = param.getFILE_NAME();
        
        Path path = Paths.get(ConfigUtil.getUploadBasePath("/taxYear/"+param.get("YEAR_YYYY"))+"/" + personNumb + ".xml");
        
        if (path != null ) {
            
            byte[] buf = Files.readAllBytes(path);
        
        	String strXml = new String( buf, "UTF-8" );
        	logger.debug(strXml);
        	List<Map<String, Object>>  formList = this.parseXML(strXml);
        	
        	// log
        	StringBuffer sb = new StringBuffer();
        	ObjectMapper objMapper = new ObjectMapper();
        	sb.append(objMapper.writeValueAsString(formList));
			logger.debug(" JSON : "+sb);
			
			for(Map<String, Object> form : formList)	{
				this.saveDataList(ObjUtils.getSafeString(form.get("form_cd")), form, param);
			}
			
			
			List<Map<String, Object>> checkFamily = super.commonDao.list("had617ukrServiceImpl.checkFamily", param);
			if(checkFamily != null && checkFamily.size() > 0)	{
				String dName = "";
				for(Map<String, Object> family : checkFamily)	{
					if(dName.length()!=0)  dName += ",";
					dName += family.get("D_NAME");
				}
				String message = MessageUtils.getMessage("omegaplus.msg.had617pdf02", Locale.KOREA)+"("+dName+")";//"등록된 부양가족과 PDF상의 부양가족이 맞지 않습니다.\n 부양가족을 먼저 확인하여 주십시오.("+dName+")";
				logger.error(message);
				throw new UniDirectValidateException(message);
			} 
			
			
        }
        return param;
        
    }
	/*
	@ExtDirectMethod( group = "Human", value = ExtDirectMethodType.FORM_POST )
    public ExtDirectFormPostResult pdfUploadFileX( @RequestParam( "pdfFile" ) MultipartFile file, HadPdfModel param, LoginVO login, BindingResult result ) throws IOException, Exception {
        String personNumb = param.getPERSON_NUMB();
        String year = param.getYEAR_YYYY();
        String p_pwd = "";
        param.setFILE_NAME(file.getOriginalFilename());
        param.setS_COMP_CODE(login.getCompCode());
        param.setS_USER_ID(login.getUserID());
        //String filename = param.getFILE_NAME();
        
       
        
        if (file != null && !file.isEmpty()) {
            logger.debug("File1 Name : " + file.getName());
            logger.debug("File1 Bytes: " + file.getSize());
            String fileExtension = FileUtil.getExtension(file.getOriginalFilename()).toLowerCase();
            
            if (!"pdf".equals(fileExtension)) {
            	String message = "pdf 파일로 올려주세요.";
            	logger.error(message);
            	result.addError(new ObjectError("errors",new String(message.getBytes("UTF-8"), "euc-kr" )));
				return new ExtDirectFormPostResult( result, false);
            }
            
            String path = ConfigUtil.getUploadBasePath("");
            if (file.getSize() > 0) {
                //File tmpFile = new File(path + "/" + year +"_"+ personNumb + '.' + fileExtension);
                //file.transferTo(tmpFile);
                
                byte[] pdfBytes = file.getBytes();
                boolean isSuccess = false;
                /* [Step1] 전자문서 위변조 검증  
                try
                {
                	 진본성 검증 초기화  
                	DSTSPDFSig dstsPdfsig = new DSTSPDFSig();
	                dstsPdfsig.init(pdfBytes);
	                dstsPdfsig.tokenParse();
	                 전자문서 검증  isSuccess = dstsPdfsig.tokenVerify();
	                if( isSuccess ){ 
	                	logger.info("<!-- 검증 완료(진본) -->");
	                }else {
	                	String msg = dstsPdfsig.getTstVerifyFailInfo();
	                	logger.error(msg);
	                	result.addError(new ObjectError("errors",msg));
	    				return new ExtDirectFormPostResult( result, false);
	                }
                // 기타 검증결과는 Exception을 발생 시킴
                }catch (DVException ex) { 
                	logger.error("[Step1] 위변조 검증 실패( code : " + ex.getLastError() + ")");
                	logger.error("[Step1] 위변조 검증 실패( message : " + ex.getMessage() + ")");
                	//throw new UniDirectValidateException("[Step1] 위변조 검증 실패( code : " + ex.getLastError() + ")");
                	
                	String message = MessageUtils.getMessage("omegaplus.msg.had617pdf01", Locale.KOREA);//"[Step1] 위변조 검증 실패( message : " + ex.getMessage() + ")";
                	result.addError(new ObjectError("errors",message));
					return new ExtDirectFormPostResult( result, true);
                }
                
                
            	ExportCustomFile pdf = new ExportCustomFile();
            	// 데이터 추출 
            	byte[] buf = pdf.NTS_GetFileBufEx(pdfBytes, p_pwd, "XML", false );
				int v_ret = pdf.NTS_GetLastError();
				
	            if ( v_ret == 1 ) {
	            	File xmlFile = new File(path+"/taxEndYea/"+param.getPERSON_NUMB()+".xml");
	            	
	            	String strXml = new String( buf, "UTF-8" );
	            	List<Map<String, Object>>  formList = this.parseXML(strXml);
	            	
	            	// log
	            	StringBuffer sb = new StringBuffer();
	            	ObjectMapper objMapper = new ObjectMapper();
	            	sb.append(objMapper.writeValueAsString(formList));
					logger.debug(" JSON : "+sb);
					
					for(Map<String, Object> form : formList)	{
						this.saveDataList(ObjUtils.getSafeString(form.get("form_cd")), form, param);
					}
					
					try{
						List<Map<String, Object>> checkFamily = super.commonDao.list("had617ukrServiceImpl.checkFamily", param);
						if(checkFamily != null && checkFamily.size() > 0)	{
							String dName = "";
							for(Map<String, Object> family : checkFamily)	{
								if(dName.length()!=0)  dName += ",";
								dName += family.get("D_NAME");
							}
							String message = MessageUtils.getMessage("omegaplus.msg.had617pdf02", Locale.KOREA)+"("+dName+")";//"등록된 부양가족과 PDF상의 부양가족이 맞지 않습니다.\n 부양가족을 먼저 확인하여 주십시오.("+dName+")";
							logger.error(message);
							result.addError(new ObjectError("errors",message));
							//super.commonDao.rollback();
							if(1==1) throw new Exception(message);
							return new ExtDirectFormPostResult( result, false);
						} 
					}catch(Exception e)	{
						logger.error(MessageUtils.getMessage("omegaplus.msg.had617pdf02", Locale.KOREA));
						logger.error(e.toString());
					}
					
	            }else if(v_ret == 0) { 
	            	
	            	String message = MessageUtils.getMessage("omegaplus.msg.had617pdf03", Locale.KOREA);//"<!-- 연말정산간소화 표준 전자문서가 아닙니다. -->";
	            	logger.error(message);
					result.addError(new ObjectError("errors",message ));
					return new ExtDirectFormPostResult( result, true);
	            }else if(v_ret == -1) { 
	            	
	            	String message = MessageUtils.getMessage("omegaplus.msg.had617pdf04", Locale.KOREA);//"<!-- 비밀번호가 맞지 않습니다. -->";
	            	logger.error(message);
	            	result.addError(new ObjectError("errors",message ));
					return new ExtDirectFormPostResult( result, true);
	            }else if(v_ret == -2) { 
	            	String message = MessageUtils.getMessage("omegaplus.msg.had617pdf05", Locale.KOREA);//"<!-- PDF문서가 아니거나 손상된 문서입니다. -->";
	            	logger.error(message);
					result.addError(new ObjectError("errors",message ));
					return new ExtDirectFormPostResult( result, true);
	            }else{ 
	            	String message = MessageUtils.getMessage("omegaplus.msg.had617pdf06", Locale.KOREA);//"<!-- 데이터 추출에 실패하였습니다. -->";
	            	logger.error(message);
					result.addError(new ObjectError("errors",message ));
					return new ExtDirectFormPostResult( result, true);
	            }
            }
            
        }
        ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);
        return extResult;
        
    }*/
	
	/**
	 * pdf -> xml 변환 후 parsing
	 * @param xmlRecords
	 * @return
	 * @throws Exception
	 */
	private List<Map<String, Object>> parseXML(String xmlRecords) throws Exception {

		List<Map<String, Object>> tagList = new ArrayList();
		
		DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
		DocumentBuilder db = dbf.newDocumentBuilder();
		InputSource is = new InputSource();
		
		Map formCodeMap = this.getFormCode();
		
		is.setCharacterStream(new StringReader(xmlRecords));

		Document doc = db.parse(is);
		NodeList xmlRoot = doc.getElementsByTagName("yesone");
		Element formItem = (Element) xmlRoot.item(0);
		NodeList nodes = formItem.getElementsByTagName("form");
		
		
		if(nodes != null)	{
			//form
			for (int j = 0; j < nodes.getLength(); j++) {
				Element form = (Element) nodes.item(j);
				Map<String, Object> tempForm = new HashMap<String, Object>();
				tempForm.put("key", "form");
				
				NamedNodeMap nnm = form.getAttributes();
				// node에 속성이 있을경우 속성값을 추출한다.
				if (nnm != null) {
					for (int i = 0; i < nnm.getLength(); i++) {
						Attr nsAttr = (Attr) nnm.item(i);

						String attrName = nsAttr.getName();
						String attrValue = nsAttr.getValue();

						tempForm.put(attrName, attrValue);
						//logger.debug(">>>>>>>>>   attrName : "+attrName + " / attrValue : "+attrValue);
					}
				}
				//man
				if(form.hasChildNodes())	{
					NodeList nl = form.getChildNodes();
					
					for(int nI = 0 ; nI < nl.getLength() ; nI++)	{
						Node n = nl.item(nI);
						//logger.debug(" n.getNodeName() : "+n.getNodeName());
						tempForm.put(n.getNodeName(), this.childrenNode(form.getElementsByTagName(n.getNodeName())));
					}
				}
				tagList.add(tempForm);
			}
			
		}
		return tagList;
	} 
	
	/**
	 * XML 하위 node parsing
	 * @param nodes
	 * @return
	 * @throws Exception
	 */
	private List childrenNode(NodeList nodes) throws Exception {
		List tagList = new ArrayList();
		//logger.debug(">>>>>>>>>   parse childrenNode : ");
		for (int j = 0; j < nodes.getLength(); j++) {
			Element e = (Element) nodes.item(j);
			Map<String, Object> tempMap = new HashMap<String, Object>();
			tempMap.put("key", e.getTagName());
			if(!"".equals(e.getTextContent().trim()))	{
				tempMap.put("value", e.getTextContent().trim());
			}
			
			//logger.debug(">>>>>>>>>   key : "+e.getTagName() + " / value : "+e.getTextContent().trim());
			NamedNodeMap nnm = e.getAttributes();
			if (nnm != null) {
				for (int i = 0; i < nnm.getLength(); i++) {
					Attr nsAttr = (Attr) nnm.item(i);

					String attrName = nsAttr.getName();
					String attrValue = nsAttr.getValue();

					tempMap.put(attrName, attrValue);
					//logger.debug(">>>>>>>>>   attrName : "+attrName + " / attrValue : "+attrValue);
				}
			}
			if(e.hasChildNodes())	{
				NodeList nl = e.getChildNodes();
				for(int nI = 0 ; nI < nl.getLength() ; nI++)	{
					Node n = nl.item(nI);
					//logger.debug(" n.getNodeName() : "+n.getNodeName());
					tempMap.put(n.getNodeName(), this.childrenNode(e.getElementsByTagName(n.getNodeName())));
				}
				
			}
			tagList.add(tempMap);
		}
		return tagList;
	}
	
	/**
	 * pdf 데이타 저장
	 * @param formCd
	 * @param form
	 * @param params
	 * @throws Exception
	 */
	private void saveDataList(String formCd, Map<String, Object> form, Map params) throws Exception	{
        	if("O101M".equals(formCd) || "P101M".equals(formCd) ||"P102M".equals(formCd) )	{ //"건강보험료" , "국민연금보험료"
        		return;
        	}
        	
			Map<String, Object> dataMap = new HashMap<String, Object>();
			
			if(this.taxGubunCode ==  null)	{
				this.taxGubunCode = this.getFormCode();
			}
			dataMap.put("S_COMP_CODE"	, params.get("S_COMP_CODE"));
			dataMap.put("S_USER_ID"		, params.get("S_USER_ID"));
			dataMap.put("YEAR_YYYY"		, params.get("YEAR_YYYY"));
			dataMap.put("PERSON_NUMB"	, params.get("PERSON_NUMB"));
			dataMap.put("NAME"			, params.get("NAME"));
			dataMap.put("PDF_FILE"		, params.get("ORG_FILE_NAME"));
			
			if("G206M".equals(formCd))	{
				formCd = "G206Y";
			}
			dataMap.put("GUBUN_CODE", formCd);
			dataMap.put("GUBUN_NAME", this.taxGubunCode.get(formCd));
			
			//man Tag List
			List<Map<String, Object>> men = (List<Map<String, Object>>) form.get("man");
			for(Map<String, Object> man : men)	{
				dataMap.put("D_REPRE_NUM", man.get("resid"));
				dataMap.put("D_NAME", man.get("name"));
				super.commonDao.delete("had617ukrServiceImpl.deletePDF", dataMap);
				
				//data Tag List
				List<Map<String, Object>> dataList = (List<Map<String, Object>>) man.get("data");
				if(dataList != null)	{
					for(Map<String, Object> data : dataList)	{
						//교육비
						if("C102Y".equals(formCd))	{	
							dataMap.put("EDU_TYPE"	, data.get("edu_tp"));
							dataMap.put("EDU_CL"	, data.get("edu_cl"));
						}else {
							dataMap.put("EDU_TYPE"	, "");
							dataMap.put("EDU_CL"	, "");
						}
						//주택마련저축
						if("J301Y".equals(formCd))	{	
							dataMap.put("SAVING_GUBUN"	, this.getTextValue(data, "saving_gubn"));
							dataMap.put("SUM_AMT"		, this.getTextValue(data, "sum"));
						}else {
							dataMap.put("SAVING_GUBUN", "");
							dataMap.put("SUM_AMT", 0);
						}
						//장기주택저당차입금 이자상환액
						if("J203Y".equals(formCd))	{	
							dataMap.put("J203Y_START_DT"		, this.getTextValue(data, "start_dt"));
							dataMap.put("J203Y_REPAY_YEARS"		, ObjUtils.parseInt(this.getTextValue(data, "repay_years"),0));
							dataMap.put("J203Y_FIXED_RATE_DEBT"	, ObjUtils.parseInt(this.getTextValue(data, "fixed_rate_debt"),0));
							dataMap.put("J203Y_NOT_DEFER_DEBT"	, ObjUtils.parseInt(this.getTextValue(data, "not_defer_debt"),0));
							dataMap.put("J203Y_DDCT"			, ObjUtils.parseInt(this.getTextValue(data, "sum"),0));
						} else {
							dataMap.put("J203Y_START_DT"		, "");
							dataMap.put("J203Y_REPAY_YEARS"		, 0);
							dataMap.put("J203Y_FIXED_RATE_DEBT"	, 0);
							dataMap.put("J203Y_NOT_DEFER_DEBT"	, 0);
							dataMap.put("J203Y_DDCT"			, 0);
						}
						//퇴직연금
						if("F102Y".equals(formCd))	{	
							dataMap.put("PENSION_CD"		, this.getTextValue(data, "pension_cd"));
						}else {
							dataMap.put("PENSION_CD"		, "");
						}
						//저축등
						if( "D101Y".equals(formCd) || 
							"E102Y".equals(formCd) || 
							"F102Y".equals(formCd) || 
							"J301Y".equals(formCd) || 
							"N101Y".equals(formCd) 
						  )	{	
							dataMap.put("COM_CD"		, this.getTextValue(data, "com_cd"));
						} else {
							dataMap.put("COM_CD"		, "");
						}
						//기부금
						if("L102Y".equals(formCd))	{	
							dataMap.put("DONATION_CD"		, data.get("donation_cd"));
							dataMap.put("SBDY_APLN_SUM"		, ObjUtils.parseInt(this.getTextValue(data, "sbdy_apln_sum"),0));
							dataMap.put("CONB_SUM"			, ObjUtils.parseInt(this.getTextValue(data, "conb_sum"),0));
						}else {
							dataMap.put("DONATION_CD"		, "");
							dataMap.put("SBDY_APLN_SUM"		, 0);
							dataMap.put("CONB_SUM"			, 0);
						}
						//소기업소상공인 공제부금
						if("K101M".equals(formCd))	{	
							dataMap.put("START_DT"		, this.getTextValue(data, "start_dt"));
							dataMap.put("END_DT"		, this.getTextValue(data, "end_dt"));
						} else {
							dataMap.put("START_DT"		, "00000000");
							dataMap.put("END_DT"		, "00000000");
						}
						//신용카드, 현금영수증, 직불카드
						if("G".equals(GStringUtils.left(formCd,1)))	{	
							dataMap.put("USE_PLACE_CD"		, data.get("use_place_cd"));
						} else {
							dataMap.put("USE_PLACE_CD"		, "");
						}
						dataMap.put("FTYR_TMONEY_TOT_AMT"	, 0);
						dataMap.put("FTYR_MARKET_TOT_AMT"	, 0);
						dataMap.put("FTYR_TOT_AMT"			, 0);
						
						dataMap.put("PRE_TMONEY_TOT_AMT"	, 0);
						dataMap.put("PRE_MARKET_TOT_AMT"	, 0);
						dataMap.put("PRE_TOT_AMT"			, 0);
						
						dataMap.put("G_FIRST_YEAR_TOT_AMT"	, 0);
						dataMap.put("G_SECOND_YEAR_TOT_AMT"	, 0);
						
						dataMap.put("TRADE_NM"				, ObjUtils.nvl(data.get("trade_nm"),""));
						dataMap.put("BUSI_NO"				, ObjUtils.nvl(data.get("busnid"),""));
						dataMap.put("DATA_CD"				, ObjUtils.nvl(data.get("dat_cd"),""));
						dataMap.put("ACC_NO"				, ObjUtils.nvl(data.get("acc_no"),""));
						
						//장기집합투자증권저축
						if("N101Y".equals(formCd))	{	
							dataMap.put("ACC_NO"			, ObjUtils.nvl(data.get("secu_no"),""));
						}
						//연금저축(E102Y), 퇴직연금(F102Y)
						if( "E102Y".equals(formCd) || "F102Y".equals(formCd) )	{	
							dataMap.put("USE_AMT"		, this.getTextValue(data, "ddct_bs_ass_amt"));
						} else {
							dataMap.put("USE_AMT"		,this.getTextValue(data, "sum"));
						}
						
						super.commonDao.insert("had617ukrServiceImpl.applyPDF", dataMap);
					}
				}

			}
			
	}
	
	private Object getTextValue(Map<String, Object> tmp, String nName) throws Exception {
		Object r = null;
		List<Map<String, Object>> tmpList = (List<Map<String, Object>>) tmp.get(nName);
		if(tmpList != null && tmpList.size() > 0){
			r = tmpList.get(0).get("value");
		}
		return r;
	}
	
	/**
	 * pdf 구분 코드
	 * @return
	 * @throws Exception
	 */
	private Map getFormCode() throws Exception	{
		Map formCodeMap = new HashMap();
		formCodeMap.put("A102Y"		,"보험");
		formCodeMap.put("B101Y"		,"의료비");
		formCodeMap.put("C102Y"		,"교육비(유초중교,대학,기타)");
		formCodeMap.put("C101Y"		,"교육비");
		formCodeMap.put("G102Y"		,"신용카드");
		formCodeMap.put("G103Y"		,"신용카드");
		formCodeMap.put("G104Y"		,"신용카드");
		formCodeMap.put("G106Y"		,"신용카드");

		formCodeMap.put("G203M"		,"현금영수증");
		formCodeMap.put("G204Y"		,"현금영수증");
		formCodeMap.put("G204M"		,"현금영수증");
		formCodeMap.put("G205Y"		,"현금영수증");
		formCodeMap.put("G205M"		,"현금영수증");
		formCodeMap.put("G206Y"		,"현금영수증");
		formCodeMap.put("G206M"		,"현금영수증");

		formCodeMap.put("G302Y"		,"직불카드");
		formCodeMap.put("G303Y"		,"직불카드");
		formCodeMap.put("G304Y"		,"직불카드");
		formCodeMap.put("G306Y"		,"직불카드");
		
		formCodeMap.put("L101Y"		,"기부금");
		formCodeMap.put("L102Y"		,"기부금");
		
		formCodeMap.put("C202Y"		,"직업훈련비");
		formCodeMap.put("C301Y"		,"교복구입비");
		formCodeMap.put("C401Y"		,"교육비(학자금대출)");
		formCodeMap.put("D101Y"		,"개인연금저축");
		formCodeMap.put("E102Y"		,"연금저축");
		formCodeMap.put("F102Y"		,"퇴직연금");
		formCodeMap.put("J101Y"		,"주택임차차임금 원리금상환액");
		formCodeMap.put("J203Y"		,"장기주택저당차입금 이자상환액");
		formCodeMap.put("J301Y"		,"주택마련저축");
		formCodeMap.put("J401Y"		,"목돈안드는전세이자상환액");
		formCodeMap.put("K101M"		,"소기업소상공인 공제부금");
		formCodeMap.put("M101Y"		,"장기주식형저축");
		formCodeMap.put("N101Y"		,"장기집합투자증권저축");
		
		formCodeMap.put("O101M"		,"건강보험료");
		formCodeMap.put("P101M"		,"국민연금보험료");
		formCodeMap.put("P102M"		,"국민연금보험료");
		
		return formCodeMap;
	}
		
	/**
	 * 체크박스  
	 * @param obj
	 * @return Y or N 
	 */
	private String getCheckboxValueYN(Object obj, String fieldName)	{
		String rValue = "N";
		if("HOUSEHOLDER_YN".equals(fieldName))	{
			if("true".equals(ObjUtils.getSafeString(obj).toLowerCase()))	{
				rValue = "1";
			}else {
				rValue = "2";
			}
		}else if("COMP_PREMINUM".equals(fieldName))	{
			if("true".equals(ObjUtils.getSafeString(obj).toLowerCase()))	{
				rValue = "1";
			}else {
				rValue = "0";
			}
		}else if("true".equals(ObjUtils.getSafeString(obj).toLowerCase()))	{
			rValue = "Y";
		}
		return rValue;
	}
	
	private String getCheckboxValueTF(Object obj, String fieldName)	{
		String rValue = "false";
		if("HOUSEHOLDER_YN".equals(fieldName))	{
			if("1".equals(ObjUtils.getSafeString(obj).toLowerCase()))	{
				rValue = "true";
			}else {
				rValue = "false";
			}
		}else if("COMP_PREMINUM".equals(fieldName))	{
			if("1".equals(ObjUtils.getSafeString(obj).toLowerCase()))	{
				rValue = "true";
			}else {
				rValue = "false";
			}
		}else if("Y".equals(ObjUtils.getSafeString(obj).toLowerCase()))	{
			rValue = "true";
		}
		return rValue;
	}
}
	
