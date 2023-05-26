package foren.unilite.modules.base.bpr;

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

@Service("bpr130ukrvService")
@SuppressWarnings({"rawtypes", "unchecked"})
public class Bpr130ukrvServiceImpl extends TlabAbstractServiceImpl  {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	private  TlabCodeService tlabCodeService ;

	@Resource(name = "fileMnagerService")
	private FileMnagerService fileMnagerService;

	/**
	 * 거래처 마스터정보 엑셀업로드
	 * @param jobID
	 * @param param
	 */
	public void excelValidate1 ( String jobID, Map param ) throws Exception {

		//임시 테이블에 데이저 저장 시, 오류발생여부 체크
		Object excelCheck = super.commonDao.select("bpr130ukrvServiceImpl.beforeExcelCheck1", param);
	}

	@ExtDirectMethod(group = "base", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectExcelUploadSheet1(Map param) throws Exception {
		return super.commonDao.list("bpr130ukrvServiceImpl.selectExcelUploadSheet1", param);
	}

	/**
	 * data insert
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "base", value = ExtDirectMethodType.STORE_READ )
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Object insertUploadSheet1( Map param, LoginVO user ) throws Exception {
		//주민등록번호 암,복호화
		AES256EncryptoUtils encrypto = new AES256EncryptoUtils();

		//업로드 된 데이터 가져오기
		List<Map> getData = (List<Map>)super.commonDao.list("bpr130ukrvServiceImpl.getData1", param);

		if (!getData.isEmpty()) {
			try {
				//데이터 에러체크 로직
				for (Map data : getData) {
					param.put("ROWNUM"		, data.get("_EXCEL_ROWNUM"));
					param.put("COMPANY_NUM"	, data.get("COMPANY_NUM"));
					String companyNum = (String)data.get("COMPANY_NUM");

					//사업자번호가 주민등록번호일(개인사업자) 경우,
					if (ObjUtils.isNotEmpty(companyNum) && companyNum.length() >= 13) {
						param.put("COMPANY_NUM", encrypto.encryto(companyNum));
						super.commonDao.update("bpr130ukrvServiceImpl.updateTopNum", param);
					}
				}
				//실제 테이블에 UPDATE
				super.commonDao.update("bpr130ukrvServiceImpl.excelValidate1", param);

			} catch (Exception e) {
				param.put("MSG", "데이터 업로드 중 오류가 발생했습니다. \n 관리자에게 문의하시기 바랍니다.");
				super.commonDao.update("bpr130ukrvServiceImpl.insertErrorMsg1", param);
			}
		}
		return 0;
	}

	/**
	 * 에러 메세지 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "base", value = ExtDirectMethodType.STORE_READ )
	public Object getErrMsg1( Map param, LoginVO user ) throws Exception {
		return super.commonDao.select("bpr130ukrvServiceImpl.getErrMsg1", param);
	}




	/**
	 * 품목 마스터정보 엑셀업로드
	 * @param jobID
	 * @param param
	 */
	public void excelValidate2 ( String jobID, Map param ) throws Exception {
		//업로드 된 데이터 가져오기
		List<Map> getData = (List<Map>)super.commonDao.list("bpr130ukrvServiceImpl.getData2", param);

		for(Map data : getData ) {
			//임시 테이블에 데이저 저장 시, 데이터/오류발생여부 체크
			super.commonDao.select("bpr130ukrvServiceImpl.beforeExcelCheck2-1", data);
		};
	}

	@ExtDirectMethod(group = "base", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectExcelUploadSheet2(Map param) throws Exception {
		return super.commonDao.list("bpr130ukrvServiceImpl.selectExcelUploadSheet2", param);
	}

	/**
	 * data insert
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "base", value = ExtDirectMethodType.STORE_READ )
	public int insertUploadSheet2( Map param, LoginVO user ) throws Exception {
		Map errorMap1		= null;
		Map errorMap2		= null;

		String errorDesc1	= "";
		String errorDesc2	= "";

		//업로드 된 데이터 가져오기
		List<Map> getData = (List<Map>)super.commonDao.list("bpr130ukrvServiceImpl.getData2", param);

		if (!getData.isEmpty()) {

			try {
				errorMap1 = (Map) super.commonDao.select("bpr130ukrvServiceImpl.excelValidate2-1", param);
				errorMap2 = (Map) super.commonDao.select("bpr130ukrvServiceImpl.excelValidate2-2", param);

			} catch (Exception e) {
//				throw new  UniDirectValidateException(this.getMessage("데이터 업로드 중 오류가 발생했습니다. \n관리자에게 문의하시기 바랍니다.", user));
				param.put("ROWNUM"	, getData.size());
				param.put("MSG", "데이터 업로드 중 오류가 발생했습니다. \n관리자에게 문의하시기 바랍니다.");
				super.commonDao.update("bpr130ukrvServiceImpl.insertErrorMsg2", param);
			}
		}
		if(ObjUtils.isNotEmpty(errorMap1)) {
			errorDesc1 = (String) errorMap1.get("ERROR_DESC");
			throw new  UniDirectValidateException(this.getMessage(errorDesc1, user));
		} else {
			if(ObjUtils.isNotEmpty(errorMap2)) {
				errorDesc2 = (String) errorMap2.get("ERROR_DESC");
				throw new  UniDirectValidateException(this.getMessage(errorDesc2, user));
			} else {
				return 1;		//Empty map return
			}
		}
	}

	/**
	 * 에러 메세지 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "base", value = ExtDirectMethodType.STORE_READ )
	public Object getErrMsg2( Map param, LoginVO user ) throws Exception {
		return super.commonDao.select("bpr130ukrvServiceImpl.getErrMsg2", param);
	}




	/**
	 * BOM 정보 엑셀업로드
	 * @param jobID
	 * @param param
	 */
	public void excelValidate3 ( String jobID, Map param ) throws Exception {
		//20200320 주석: 루프 돌려서 체크하지 않고 _EXCEL_JOBID로 한번에 체크하도록 변경
		super.commonDao.select("bpr130ukrvServiceImpl.beforeExcelCheck3-1", param);

		//업로드 된 데이터 가져오기
//		List<Map> getData = (List<Map>)super.commonDao.list("bpr130ukrvServiceImpl.getData3", param);
//
//		for(Map data : getData ) {
//			//임시 테이블에 데이저 저장 시, 데이터/오류발생여부 체크
//			super.commonDao.select("bpr130ukrvServiceImpl.beforeExcelCheck3-1", data);
//		};
	}

	@ExtDirectMethod(group = "base", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectExcelUploadSheet3(Map param) throws Exception {
		return super.commonDao.list("bpr130ukrvServiceImpl.selectExcelUploadSheet3", param);
	}

	/**
	 * data insert
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "base", value = ExtDirectMethodType.STORE_READ )
	public int insertUploadSheet3( Map param, LoginVO user ) throws Exception {
		Map errorMap1		= null;
		Map duplicationChk  = null;
		String errorDesc1	= "";

		//업로드 된 데이터 가져오기
		List<Map> getData = (List<Map>)super.commonDao.list("bpr130ukrvServiceImpl.getData3", param);

		if (!getData.isEmpty()) {
			duplicationChk = (Map) super.commonDao.select("bpr130ukrvServiceImpl.excelValidateDuplicationChk", param);
			if ( ObjUtils.isNotEmpty(duplicationChk)){
				throw new  UniDirectValidateException(this.getMessage("모품목" + duplicationChk.get("PROD_ITEM_CODE")+ "가 중복 되었습니다. \n엑셀양식 수정 후 다시 시도해주세요.", user));
			}
			try {
				//20200302 수정: BOM 업로드II로직 추가됨 - BOM 업로드 / BOM 업로드II 구분하여 로직 처리
				if("I".equals(param.get("BOM_FLAG"))) {
					errorMap1 = (Map) super.commonDao.select("bpr130ukrvServiceImpl.excelValidate3-1", param);
				} else if("II".equals(param.get("BOM_FLAG"))) {
					errorMap1 = (Map) super.commonDao.select("bpr130ukrvServiceImpl.excelValidate3-2", param);
				}
			} catch (Exception e) {
//				throw new  UniDirectValidateException(this.getMessage("데이터 업로드 중 오류가 발생했습니다. \n관리자에게 문의하시기 바랍니다.", user));
				param.put("ROWNUM"	, getData.size());
				param.put("MSG", "데이터 업로드 중 오류가 발생했습니다. \n관리자에게 문의하시기 바랍니다.");
				//super.commonDao.update("bpr130ukrvServiceImpl.insertErrorMsg3", param);
				throw new  UniDirectValidateException(this.getMessage("데이터 업로드 중 오류가 발생했습니다. \n관리자에게 문의하시기 바랍니다.", user));
			}
		}
		if(ObjUtils.isNotEmpty(errorMap1)) {
			errorDesc1 = (String) errorMap1.get("ERROR_DESC");
			throw new  UniDirectValidateException(this.getMessage(errorDesc1, user));
		} else {
			return 1;		//Empty map return
		}
	}

	/**
	 * 에러 메세지 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "base", value = ExtDirectMethodType.STORE_READ )
	public Object getErrMsg3( Map param, LoginVO user ) throws Exception {
		return super.commonDao.select("bpr130ukrvServiceImpl.getErrMsg3", param);
	}



	/**
	 * BOM 전체 데이터 엑셀다운로드 로직: 20191217
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "base", value = ExtDirectMethodType.STORE_READ )
	public Workbook makeExcelData( Map param ) throws Exception {
		FileInputStream file = new FileInputStream(new File(ConfigUtil.getUploadBasePath("ExcelFrame") + File.separatorChar + "bpr130ukrv_BOM.xlsx"));

		//Get the workbook instance for XLS file
		Workbook workbook = new XSSFWorkbook(file);
		//Get first sheet from the workbook
		Sheet sheet1 = workbook.getSheetAt(0);
		Row headerRow = null;
		int A = 0;
		int B = 1;
		int C = 2;
		int D = 3;
		int E = 4;
		int F = 5;
		int G = 6;
		int H = 7;
		int I = 8;
		int J = 9;
		int K = 10;
		int L = 11;
		int M = 12;
		int N = 13;
		int O = 14;
		int P = 15;
		int Q = 16;
		int R = 17;
		int S = 18;
		int T = 19;
		int U = 20;
		int V = 21;

		List<Map> list1 = super.commonDao.list("bpr130ukrvServiceImpl.selectBOMList", param);
		for(int i = 0; i < list1.size(); i++) {
			headerRow = sheet1.createRow(2 + i);
			headerRow.createCell(A).setCellValue(ObjUtils.getSafeString(list1.get(i).get("PROD_ITEM_CODE")));
			headerRow.createCell(B).setCellValue(ObjUtils.getSafeString(list1.get(i).get("CHILD_ITEM_CODE")));
			headerRow.createCell(C).setCellValue(ObjUtils.getSafeString(list1.get(i).get("START_DATE")));
			headerRow.createCell(D).setCellValue(ObjUtils.getSafeString(list1.get(i).get("PATH_CODE")));
			headerRow.createCell(E).setCellValue(ObjUtils.getSafeString(list1.get(i).get("SEQ")));
			headerRow.createCell(F).setCellValue(ObjUtils.getSafeString(list1.get(i).get("GRANT_TYPE")));
			headerRow.createCell(G).setCellValue(ObjUtils.getSafeString(list1.get(i).get("UNIT_Q")));
			headerRow.createCell(H).setCellValue(ObjUtils.getSafeString(list1.get(i).get("PROD_UNIT_Q")));
			headerRow.createCell(I).setCellValue(ObjUtils.getSafeString(list1.get(i).get("LOSS_RATE")));
			headerRow.createCell(J).setCellValue(ObjUtils.getSafeString(list1.get(i).get("USE_YN")));
			headerRow.createCell(K).setCellValue(ObjUtils.getSafeString(list1.get(i).get("BOM_YN")));
			headerRow.createCell(L).setCellValue(ObjUtils.getSafeString(list1.get(i).get("UNIT_P1")));
			headerRow.createCell(M).setCellValue(ObjUtils.getSafeString(list1.get(i).get("UNIT_P2")));
			headerRow.createCell(N).setCellValue(ObjUtils.getSafeString(list1.get(i).get("UNIT_P3")));
			headerRow.createCell(O).setCellValue(ObjUtils.getSafeString(list1.get(i).get("MAN_HOUR")));
			headerRow.createCell(P).setCellValue(ObjUtils.getSafeString(list1.get(i).get("SET_QTY")));
			headerRow.createCell(Q).setCellValue(ObjUtils.getSafeString(list1.get(i).get("REMARK")));
			headerRow.createCell(R).setCellValue(ObjUtils.getSafeString(list1.get(i).get("PROC_DRAW")));
			headerRow.createCell(S).setCellValue(ObjUtils.getSafeString(list1.get(i).get("LAB_NO")));
			headerRow.createCell(T).setCellValue(ObjUtils.getSafeString(list1.get(i).get("REQST_ID")));
			headerRow.createCell(U).setCellValue(ObjUtils.getSafeString(list1.get(i).get("SAMPLE_KEY")));
			headerRow.createCell(V).setCellValue(ObjUtils.getSafeString(list1.get(i).get("GROUP_CODE")));
//			oldstring = ObjUtils.getSafeString(list1.get(i).get("PRODT_DATE_PRINT"));
//			Date date = new SimpleDateFormat("yyyy-MM-dd").parse(oldstring);
//			sheet1.getRow(2 + i).getCell(F).setCellValue(date);
//			sheet1.getRow(2 + i).getCell(G).setCellValue(ObjUtils.getSafeString(list1.get(i).get("UPN_CODE")));
		}
		return workbook;
	}
}