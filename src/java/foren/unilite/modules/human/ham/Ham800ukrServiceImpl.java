package foren.unilite.modules.human.ham;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Date;

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


@Service("ham800ukrService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class Ham800ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	/**
	 * 컬럼 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List fnAmtCal(LoginVO loginVO) throws Exception {
		return (List) super.commonDao.list("ham800ukrService.fnAmtCal", loginVO.getCompCode());
	}

	/**
	 * 일용직급여등록 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@Transactional(readOnly = true)
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "ham")
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return (List) super.commonDao.list("ham800ukrService.selectList", param);
	}

	/**
	 * 엑셀의 내용을 읽어옴
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "hum", value = ExtDirectMethodType.STORE_READ)		// 엑셀 업로드
	public List<Map<String, Object>> selectExcelUploadSheet1(Map param) throws Exception {
		return super.commonDao.list("ham800ukrService.selectExcelUploadSheet1", param);
	}

	@ExtDirectMethod(group = "hum", value = ExtDirectMethodType.STORE_READ)		// 엑셀 적용 사번에 해당하는 데이터 포함
	public List<Map<String, Object>> selectExcelUploadApply(Map param) throws Exception {
		return super.commonDao.list("ham800ukrService.selectExcelUploadApply", param);
	}

	public void excelValidate(String jobID, Map param) {						// 엑셀 Validate
		logger.debug("validate: {}", jobID);
		super.commonDao.update("ham800ukrService.excelValidate", param);
	}



	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "ham")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		//1.로그테이블에서 사용할 KeyValue 생성
		String keyValue = getLogKey();

		//2.로그테이블에 KEY_VALUE, OPR_FLAG 업데이트
		List<Map> dataList = new ArrayList<Map>();
		List<List<Map>> resultList = new ArrayList<List<Map>>();
		
		for(Map paramData: paramList) {
			dataList = (List<Map>) paramData.get("data");
			String oprFlag = "N";
			if(paramData.get("method").equals("insertDetail"))	oprFlag="N";
			if(paramData.get("method").equals("updateDetail"))	oprFlag="U";
			if(paramData.get("method").equals("deleteDetail"))	oprFlag="D";

			for(Map param:  dataList) {
				String retrDate = "";
				if(param.get("RETR_DATE") == null){  // 퇴사하지 않은 사람
					retrDate = "00000000";  // 퇴사 하지 않았을 때 00000000 으로 처리
				}
				param.put("KEY_VALUE", keyValue);
				param.put("OPR_FLAG", oprFlag);
				param.put("REPRE_NUM" , ((String) param.get("REPRE_NUM")).replace("-", ""));
				param.put("PAY_YYYYMM" , ((String) param.get("PAY_YYYYMM")).replace(".", ""));
				param.put("BANK_ACCOUNT1", ((String) param.get("BANK_ACCOUNT1")).replace("-", ""));
				param.put("RETR_DATE" , retrDate);

				param.put("data", super.commonDao.insert("ham800ukrService.insertLogMaster", param));
			}
		}
		
		Map<String, Object> spParam = new HashMap<String, Object>(); 

		spParam.put("KeyValue", keyValue);
		spParam.put("updateDbUser", user.getUserID());
		
		super.commonDao.queryForObject("ham800ukrService.ham800Sp", spParam);
		String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));

		if(!ObjUtils.isEmpty(errorDesc)){
			String[] messsage = errorDesc.split(";");
			throw new  UniDirectValidateException(this.getMessage(messsage[0], user));
		}
		paramList.add(0, paramMaster);
		return  paramList;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "ham")		// INSERT
	public Integer  insertDetail(List<Map> paramList, LoginVO user) throws Exception {		
		return 0;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "ham")		// UPDATE
	public Integer updateDetail(List<Map> paramList, LoginVO user) throws Exception {
		return 0;
	}

	@ExtDirectMethod(group = "ham", needsModificatinAuth = true)		// DELETE
	public Integer deleteDetail(List<Map> paramList,  LoginVO user) throws Exception {
		 return 0;
	}



	/**
	 * 마감여부체크
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "ham", value = ExtDirectMethodType.STORE_READ)
	public Object  strsql(Map param, LoginVO loginVO) throws Exception {
		return  super.commonDao.select("ham800ukrService.strsql", param);
	}

	/**
	 * 자동기표 유무 체크
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "ham", value = ExtDirectMethodType.STORE_READ)
	public Object  saveCheck(Map param, LoginVO loginVO) throws Exception {
		return  super.commonDao.select("ham800ukrService.saveCheck", param);
	}

	/**
	 * 간이세율(일용직 근로소득공제 금액)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "ham", value = ExtDirectMethodType.STORE_READ)
	public Object  Ham800Qstd2(Map param, LoginVO loginVO) throws Exception {
		return  super.commonDao.select("ham800ukrService.Ham800Qstd2", param);
	}

	/**
	 * 고용보험료, 사회보험 사업자 부담금, 산재보험금
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "ham", value = ExtDirectMethodType.STORE_READ)
	public Object  Ham800Qstd3(Map param, LoginVO loginVO) throws Exception {
		return  super.commonDao.select("ham800ukrService.Ham800Qstd3", param);
	}

	/**
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "ham", value = ExtDirectMethodType.STORE_READ)
	public Object  Ham800Qstd4(Map param, LoginVO loginVO) throws Exception {
		String price = String.valueOf(param.get("WAGES_AMT"));
		param.put("WAGES_AMT", price);
		param.put("S_COMP_CODE",loginVO.getCompCode());
		return  super.commonDao.select("ham800ukrService.Ham800Qstd4", param);
	}

	public String Ham800Qstd4(Map param) {
		String result = super.commonDao.queryForObject("ham800ukrServiceImpl.Ham800Qstd4", param).toString();
		return result;
	}

	/**
	 * 간이세율(일용직 근로소득공제 금액)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "ham", value = ExtDirectMethodType.STORE_READ)
	public Object  Ham800Qstd5(Map param, LoginVO loginVO) throws Exception {
		return super.commonDao.select("ham800ukrService.Ham800Qstd5", param);
	}



	/**
	 * 일용직급여등록 (ham800ukr) - 일용근로지급명세서(1), 일용근로소득집계표(2) 출력: 20200706 추가
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "ham")
	public List<Map<String, Object>> fnPrintData(Map param) throws Exception {
		return (List) super.commonDao.list("ham800ukrService.fnPrintData", param);
	}
}
