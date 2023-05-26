package foren.unilite.modules.z_mit;

import java.io.File;
import java.io.FileInputStream;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.poi.ss.usermodel.FormulaEvaluator;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ConfigUtil;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.service.impl.TlabCodeService;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.com.fileman.FileMnagerService;
import foren.unilite.utils.AES256DecryptoUtils;
import foren.unilite.utils.AES256EncryptoUtils;

@Service("s_bpr130ukrv_mitService")
@SuppressWarnings({"rawtypes", "unchecked"})
public class S_Bpr130ukrv_mitServiceImpl extends TlabAbstractServiceImpl  {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	private  TlabCodeService tlabCodeService ;

	@Resource(name = "fileMnagerService")
	private FileMnagerService fileMnagerService;

	@Resource( name = "externalDAO_MIT" )
    protected ExternalDAO_MIT externalDAO;

	/**
	 * 본사 품목 마스터정보 엑셀업로드
	 * @param jobID
	 * @param param
	 */
	public void excelValidate ( String jobID, Map param ) throws Exception {
		//업로드 된 데이터 가져오기
		List<Map> getData = (List<Map>)super.commonDao.list("s_bpr130ukrv_mitServiceImpl.getData", param);

		for(Map data : getData ) {
			//임시 테이블에 데이저 저장 시, 데이터/오류발생여부 체크
			super.commonDao.select("s_bpr130ukrv_mitServiceImpl.beforeExcelCheck-1", data);
		};
	}

	@ExtDirectMethod(group = "base", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectExcelUploadSheet(Map param) throws Exception {
		return super.commonDao.list("s_bpr130ukrv_mitServiceImpl.selectExcelUploadSheet", param);
	}

	/**
	 * 본사 data insert
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "base", value = ExtDirectMethodType.STORE_READ )
	public int insertUploadSheet( Map param, LoginVO user ) throws Exception {
		Map errorMap1		= null;
		Map errorMap2		= null;

		String errorDesc1	= "";
		String errorDesc2	= "";

		//업로드 된 데이터 가져오기
		List<Map> getData = (List<Map>)super.commonDao.list("s_bpr130ukrv_mitServiceImpl.getData", param);

		if (!getData.isEmpty()) {

			try {
				errorMap1 = (Map) super.commonDao.select("s_bpr130ukrv_mitServiceImpl.excelValidate-1", param);
				errorMap2 = (Map) super.commonDao.select("s_bpr130ukrv_mitServiceImpl.excelValidate-2", param);

			} catch (Exception e) {
//				throw new  UniDirectValidateException(this.getMessage("데이터 업로드 중 오류가 발생했습니다. \n관리자에게 문의하시기 바랍니다.", user));
				param.put("ROWNUM"	, getData.size());
				param.put("MSG", "데이터 업로드 중 오류가 발생했습니다. \n관리자에게 문의하시기 바랍니다.");
				super.commonDao.update("s_bpr130ukrv_mitServiceImpl.insertErrorMsg", param);
			}
		}
		if(ObjUtils.isNotEmpty(errorMap1)) {
			errorDesc1 = (String) errorMap1.get("ERROR_DESC");
			throw new  UniDirectValidateException(this.getMessage(errorDesc1, user));
		} 
		if(ObjUtils.isNotEmpty(errorMap2)) {
			errorDesc2 = (String) errorMap2.get("ERROR_DESC");
			throw new  UniDirectValidateException(this.getMessage(errorDesc2, user));
		}
		//대리정 데이터 입력
		
		List<Map<String, Object>> agentList = (List<Map<String, Object>>)super.commonDao.list("s_bpr130ukrv_mitServiceImpl.agentList", param);
		if(agentList != null && getData != null)	{
			//대리점 목록
			for(Map<String, Object> agent : agentList)	{
				//업로드데이터 로그테이블 입력
				for(Map<String, Object> insertParam : getData)	{
					StringBuilder errorMessage = new StringBuilder("");
					insertParam.put("S_COMP_CODE", agent.get("AGENT_COMP_CODE"));
					insertParam.put("S_USER_ID"		, user.getUserID());
					int r = externalDAO.update("s_bpr130ukrv_mitServiceImpl.insertExcels_bpr130ukrv_mitupload", insertParam , errorMessage);
					if(ObjUtils.isNotEmpty(errorMessage))	{
			    		throw new	UniDirectValidateException(errorMessage.toString());
			    	}
				}
				//업로드데이터 입력
				Map<String, Object> agentParam = new HashMap();
				
				agentParam.put("S_COMP_CODE"	, agent.get("AGENT_COMP_CODE"));
				agentParam.put("DIV_CODE"		, agent.get("AGENT_DIV_CODE"));
				agentParam.put("_EXCEL_JOBID"	, param.get("_EXCEL_JOBID"));
				agentParam.put("S_USER_ID"		, user.getUserID());
				
				
				StringBuilder errorMessage = new StringBuilder("");
				errorMap1 = (Map<String, Object>) externalDAO.select("s_bpr130ukrv_mitServiceImpl.excelValidate-1", agentParam , errorMessage);
				//외부 db SQL Exception 체크
				if(ObjUtils.isNotEmpty(errorMessage))	{
			    	throw new	UniDirectValidateException(errorMessage.toString());
		    	}
				errorMap2 = (Map<String, Object>) externalDAO.select("s_bpr130ukrv_mitServiceImpl.excelValidate-2", agentParam , errorMessage);
				//외부 db SQL Exception 체크
				if(ObjUtils.isNotEmpty(errorMessage))	{
			    	throw new	UniDirectValidateException(errorMessage.toString());
		    	}
				if(ObjUtils.isNotEmpty(errorMap1)) {
					errorDesc1 = (String) errorMap1.get("ERROR_DESC");
					if(ObjUtils.isNotEmpty(errorDesc1))	{
						throw new  UniDirectValidateException(this.getMessage(errorDesc1, user));
					} 
				}
				if(ObjUtils.isNotEmpty(errorMap2)) {
					errorDesc2 = (String) errorMap2.get("ERROR_DESC");
					if(ObjUtils.isNotEmpty(errorDesc2))	{
						throw new  UniDirectValidateException(this.getMessage(errorDesc2, user));
					} 
				} 
				
				
			}
		}
		return 1;		//Empty map return
	}

	/**
	 * 본사 에러 메세지 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "base", value = ExtDirectMethodType.STORE_READ )
	public Object getErrMsg( Map param, LoginVO user ) throws Exception {
		return super.commonDao.select("s_bpr130ukrv_mitServiceImpl.getErrMsg", param);
	}

}