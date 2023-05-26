package foren.unilite.modules.com.common;

import java.lang.reflect.Type;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.codehaus.jackson.map.ObjectMapper;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;

import com.google.common.reflect.TypeToken;
import com.google.gson.Gson;

import foren.framework.model.LoginVO;
import foren.unilite.com.code.CodeDetailVO;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.service.impl.TlabCodeService;
import foren.unilite.modules.com.common.CMS300ukrModel.TransHistory;
import foren.unilite.modules.com.login.LoginServiceImpl;
import foren.unilite.utils.AES256DecryptoUtils;
import foren.unilite.utils.AES256EncryptoUtils;


@Service("cMSIntfService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class CMSIntfServiceImpl extends TlabAbstractServiceImpl {
	
	@Resource(name="tlabCodeService")
	private TlabCodeService tlabCodeService;
	
	@Resource( name = "loginService" )
	private LoginServiceImpl loginService;
	
	private AES256EncryptoUtils encrypto = new AES256EncryptoUtils();
	private AES256DecryptoUtils decrypto = new AES256DecryptoUtils();

	@ExtDirectMethod(group = "common", value = ExtDirectMethodType.STORE_READ)
	public String getCMSData(Map param, LoginVO loginVO) throws Exception {
		
		int rstlSeq = 0;
		Gson gson = new Gson();
		
		Map baseInfo = (Map) super.commonDao.select("cMSIntfServiceImpl.selectBaseInfo", param);
		int maxSeq = (int) super.commonDao.select("cMSIntfServiceImpl.selectMaxSeq", param);
		
		if(baseInfo == null || !baseInfo.containsKey("REF_CODE6") || baseInfo.get("REF_CODE6") == null || baseInfo.get("REF_CODE6").equals("")) {
			throw new Exception("공통코드 등록에서 메인코드[BT02]를 확인하여 주십시오.");
			//return "공통코드 등록에서 메인코드[BT02]를 확인하여 주십시오.";
		}
		
		if(!"Y".equals(baseInfo.get("REF_CODE7").toString())) {
			throw new Exception("공통코드 등록에서 메인코드[BT02]의 [참조코드7]을 확인하여 주십시오.");
			//return "공통코드 등록에서 메인코드[BT02]의 [참조코드7]을 확인하여 주십시오.";
		}
		
		param.put("COMPANY_NO", baseInfo.get("REF_CODE6"));
		param.put("MAX_SEQ", maxSeq);
		
		try {
			this.setSmartFinderInfo(param, loginVO);
		}
		catch (Exception e) {
			throw new Exception(e.getMessage());
		}
		
		// 최신 데이터 조회
		List<Map> getData = (List<Map>) super.commonDao.list("cMSIntfServiceImpl.getCmsDataByCompNo", param);
		
		if(getData.size() < 1) {
			return "연동 할 데이터가 존재하지 않습니다.";
		}
		
		// 값 세팅
		for(int i=0;i<getData.size();i++){
			// 크게 Input, Output, Job, Class, Module을 Map파일로 변환 => Class 명칭때문에 따로 Model로 빼기 어려움 
			Map<String, Object> objMap = new HashMap<String, Object>();
			objMap = (Map<String, Object>) gson.fromJson((String) getData.get(i).get("JSON_DATA"), objMap.getClass());
			
			// Exception 처리
			try{
				// Input, Output String to JSON
				objMap = getMakeCMSData(objMap);
				
				// 데이터 저장
				int savSeq = saveCmsData(objMap, getData.get(i));
				
				// 데이터 저장한 건수 가 있는 경우 추가
				rstlSeq += (savSeq >0) ? 1 : 0;
		
			} catch(Exception e){
				log.debug("========[Job] : " + objMap.get("Job") + " [SEQ] : "+ getData.get(i).get("SEQ") +" [ERROR MESSAGE] : " + e.getMessage());
				e.printStackTrace();
				return "[ ERROR!! ]" + e.getMessage();
			}
		}
		
		// 저장 완료 FLAG 추가
		int compData = super.commonDao.update("cMSIntfServiceImpl.setProcFlagByCompNo", param);
		
		return "[ " + rstlSeq + " ] 건이 저장되었습니다.";
	}
	
	/**
	 * Input, Output String to JSON
	 * @param objMap      : 조회한 데이터
	 * 
	 * @return objMap
	 * @throws Exception
	 */
	private Map<String, Object> getMakeCMSData(Map<String, Object> objMap) throws Exception {
	
		Type type = null;
		Object inputData = null;
		Object outputData = null;
		
		String job = (String)objMap.get("Job");

		String reInputJson = new Gson().toJson(objMap.get("Input"));
		String reOutputJson = new Gson().toJson(objMap.get("Output"));
		
		switch(job){
		case "전자세금계산서통합조회":
			type = new TypeToken<CMS100ukrModel.InputClass>(){}.getType();
			inputData = (reInputJson == "{}") ? reInputJson : new Gson().fromJson(reInputJson, type);
			
			type = new TypeToken<CMS100ukrModel.OutputClass>(){}.getType();
			outputData = (reOutputJson == "{}") ? reOutputJson : new Gson().fromJson(reOutputJson, type);
			break;
			
		case "수시전계좌조회":
			type = new TypeToken<CMS200ukrModel.InputClass>(){}.getType();
			inputData = (reInputJson == "{}") ? reInputJson : new Gson().fromJson(reInputJson, type);
			
			type = new TypeToken<CMS200ukrModel.OutputClass>(){}.getType();
			outputData = (reOutputJson == "{}") ? reOutputJson : new Gson().fromJson(reOutputJson, type);
			break;
			
		case "수시거래내역조회":
			type = new TypeToken<CMS300ukrModel.InputClass>(){}.getType();
			inputData = (reInputJson == "{}") ? reInputJson : new Gson().fromJson(reInputJson, type);
			
			type = new TypeToken<CMS300ukrModel.OutputClass>(){}.getType();
			outputData = (reOutputJson == "{}") ? reOutputJson : new Gson().fromJson(reOutputJson, type);
			break;
			
		case "보유카드조회":
			type = new TypeToken<CMS400ukrModel.InputClass>(){}.getType();
			inputData = (reInputJson == "{}") ? reInputJson : new Gson().fromJson(reInputJson, type);
			
			type = new TypeToken<CMS400ukrModel.OutputClass>(){}.getType();
			outputData = (reOutputJson == "{}") ? reOutputJson : new Gson().fromJson(reOutputJson, type);
			break;
			
		case "승인내역":
			type = new TypeToken<CMS500ukrModel.InputClass>(){}.getType();
			inputData = (reInputJson == "{}") ? reInputJson : new Gson().fromJson(reInputJson, type);
			
			type = new TypeToken<CMS500ukrModel.OutputClass>(){}.getType();
			outputData = (reOutputJson == "{}") ? reOutputJson : new Gson().fromJson(reOutputJson, type);
			break;
			
		case "청구내역":
			type = new TypeToken<CMS600ukrModel.InputClass>(){}.getType();
			inputData = (reInputJson == "{}") ? reInputJson : new Gson().fromJson(reInputJson, type);
			
			type = new TypeToken<CMS600ukrModel.OutputClass>(){}.getType();
			outputData = (reOutputJson == "{}") ? reOutputJson : new Gson().fromJson(reOutputJson, type);
			break;
			
		case "이용한도조회":
			type = new TypeToken<CMS700ukrModel.InputClass>(){}.getType();
			inputData = (reInputJson == "{}") ? reInputJson : new Gson().fromJson(reInputJson, type);
			
			type = new TypeToken<CMS700ukrModel.OutputClass>(){}.getType();
			outputData = (reOutputJson == "{}") ? reOutputJson : new Gson().fromJson(reOutputJson, type);
			break;
			
		default:
			break;
		}
		
		objMap.put("Input", inputData);
		objMap.put("Output", outputData);
		
		return objMap;
	}

	/**
	 * CMS 데이터 저장
	 * @param param      : JSON 데이터
	 * @param selectData : 조회한 데이터
	 * 
	 * @return 저장 완료된 Count
	 */
	public int saveCmsData(Map param, Map selectData){
		
		String job = (String)param.get("Job");
		int rstlSeq = 0;   // 실행한 행 리턴 수
		int arrSeq = 0;    // 데이터 담고 있는 배열 length
		
		ObjectMapper objectMapper = new ObjectMapper();
		Map<String, Object> setData = new HashMap<>(); // 저장할 데이터
		
		// 공통 데이터
		setData.put("COMP_CODE", "MASTER");
		setData.put("COMPANY_NO", selectData.get("COMPANY_NO"));
		
		switch(job){
		case "전자세금계산서통합조회":		
			// Output Data
			CMS100ukrModel.OutputClass output100Data = (CMS100ukrModel.OutputClass) param.get("Output");
			CMS100ukrModel.InputClass input100Data = (CMS100ukrModel.InputClass) param.get("Input");
			
			// 에러
			if(!(output100Data.getErrorCode().equals("00000000") || output100Data.getErrorMessage() == null)) {
				return 0;
			}
			
			arrSeq = output100Data.getResult().get전자세금계산서통합조회().length;
			for(int i=0;i<arrSeq;i++){
				
				setData.put("INPUT", input100Data);
				setData.put("CARD_LIMIT", output100Data.getResult().get전자세금계산서통합조회()[i]);
				if(output100Data.getResult().get전자세금계산서통합조회()[i].get전자세금계산서통합조회_상세조회().length > 0)
					setData.put("CARD_LIMIT_DETAIL", output100Data.getResult().get전자세금계산서통합조회()[i].get전자세금계산서통합조회_상세조회()[0].get전자세금계산서_상세());
				
				// 삭제
				rstlSeq += super.commonDao.update("cMSIntfServiceImpl.deleteElectronicBill", setData);
				// 저장
				rstlSeq += super.commonDao.update("cMSIntfServiceImpl.updateElectronicBill", setData);
			}
			break;
			
		case "수시전계좌조회":
			// Output Data
			CMS200ukrModel.OutputClass output200Data = (CMS200ukrModel.OutputClass) param.get("Output");
			// 에러
			if(!(output200Data.getErrorCode().equals("00000000") || output200Data.getErrorCode().startsWith("4212") || output200Data.getErrorMessage() == null)) {
				return 0;
			}

			arrSeq = output200Data.getResult().get수시전계좌조회().length;
			for(int i=0;i<arrSeq;i++){
				
				setData.put("ACCOUNT", output200Data.getResult().get수시전계좌조회()[i]);
				rstlSeq += super.commonDao.update("cMSIntfServiceImpl.updateAccount", setData);
			}
			
			break;
			
		case "수시거래내역조회":
			// Output Data, Input Data
			CMS300ukrModel.OutputClass output300Data = (CMS300ukrModel.OutputClass) param.get("Output");
			CMS300ukrModel.InputClass input300Data = (CMS300ukrModel.InputClass) param.get("Input");
			// 에러
			if(!(output300Data.getErrorCode().equals("00000000") || output300Data.getErrorMessage() == null)) {
				return 0;
			}

			setData.put("ACNUT_NO", input300Data.get계좌번호());
			setData.put("FROMDATE", input300Data.get조회시작일());
			setData.put("TODATE", input300Data.get조회종료일());
			
			rstlSeq += super.commonDao.update("cMSIntfServiceImpl.deleteTransactionHistory", setData);
			
			TransHistory[] hist = output300Data.getResult().get수시거래내역조회();
			for(int idx = 0; idx < hist.length; idx = idx + 50) {
				ArrayList<TransHistory> sub_data = new ArrayList<TransHistory>();
				
				for (int lLoop = 0; (lLoop < 50 && (idx + lLoop) < hist.length); lLoop++) {
					sub_data.add(hist[idx + lLoop]);
				}
				
				setData.put("ACNUT_NO", input300Data.get계좌번호());
				setData.put("FROMDATE", input300Data.get조회시작일());
				setData.put("TODATE", input300Data.get조회종료일());
				setData.put("HISTORY_DATA", sub_data);
				
				rstlSeq += super.commonDao.update("cMSIntfServiceImpl.updateTransactionHistory", setData);
				
				sub_data = null;
			}
			
			break;
			
		case "보유카드조회":
			// Output Data, Input Data
			CMS400ukrModel.OutputClass output400Data = (CMS400ukrModel.OutputClass) param.get("Output");
			CMS400ukrModel.InputClass input400Data = (CMS400ukrModel.InputClass) param.get("Input");
			// 에러
			if(!(output400Data.getErrorCode().equals("00000000") || output400Data.getErrorMessage() == null)) {
				return 0;
			}

			// 조회구분이 F가 아닌경우 (카드번호 형식이 0000000000000000 아닌경우)
			if(!"F".equals(input400Data.get조회구분())){
				return 0;
			}

			setData.put("CARD_DATA", output400Data.getResult().get보유카드조회());
			
			rstlSeq += super.commonDao.update("cMSIntfServiceImpl.updateCard", setData);
			break;
			
		case "승인내역":
			// Output Data, Input Data
			CMS500ukrModel.OutputClass output500Data = (CMS500ukrModel.OutputClass) param.get("Output");
			CMS500ukrModel.InputClass input500Data = (CMS500ukrModel.InputClass) param.get("Input");
			
			// 에러
			if(!(output500Data.getErrorCode().equals("00000000") || output500Data.getErrorMessage() == null)) {
				return 0;
			}

			setData.put("INPUT_DATA", input500Data);

			// 삭제
			rstlSeq += super.commonDao.update("cMSIntfServiceImpl.deleteCardHistory", setData);
			
			arrSeq = output500Data.getResult().get승인내역조회().length;
			for(int i=0;i<arrSeq;i++){
				
				setData.put("PROV_HIST", output500Data.getResult().get승인내역조회()[i]);
				rstlSeq += super.commonDao.update("cMSIntfServiceImpl.updateCardHistory", setData);
			}

			break;
			
		case "청구내역":
			// Output Data, Input Data
			CMS600ukrModel.OutputClass output600Data = (CMS600ukrModel.OutputClass) param.get("Output");
			CMS600ukrModel.InputClass input600Data = (CMS600ukrModel.InputClass) param.get("Input");
			
			// 에러
			if(!(output600Data.getErrorCode().equals("00000000") || output600Data.getErrorMessage() == null)) {
				return 0;
			}

			// 공통값
			setData.put("SETT_BANK", output600Data.getResult().get결제계좌은행());
			setData.put("SETT_ACNUT", output600Data.getResult().get결제계좌번호());
			setData.put("INPUT_DATA", input600Data);
			
			// 삭제
			rstlSeq += super.commonDao.update("cMSIntfServiceImpl.deleteBillHistory", setData);
			
			arrSeq = output600Data.getResult().get청구내역조회().length;
			for(int i=0;i<arrSeq;i++){
				
				setData.put("BILL_HISTORY", output600Data.getResult().get청구내역조회()[i]);
				// 추가
				rstlSeq += super.commonDao.update("cMSIntfServiceImpl.updateBillHistory", setData);
			}

			break;
			
		case "이용한도조회":
			// Output Data, Input Data
			CMS700ukrModel.OutputClass output700Data = (CMS700ukrModel.OutputClass) param.get("Output");
			
			// 에러
			if(!(output700Data.getErrorCode().equals("00000000") || output700Data.getErrorMessage() == null)) {
				return 0;
			}

			// DATA setting
			setData.put("CARD_LIMIT", output700Data.getResult().get한도조회());
			
			rstlSeq += super.commonDao.update("cMSIntfServiceImpl.updateLmt", setData);
			
			break;
			
		default:
			break;
		}
		
		return rstlSeq;
	}
	
	/**
	 * smartfinder 데이터 이관
	 * @param param
	 * @param loginVO
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "common")
	public int setSmartFinderInfo(Map param, LoginVO loginVO) throws Exception {

		// 접속정보 조회
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		List<CodeDetailVO> formatList = codeInfo.getCodeList("BT02", "", false);
		
		if(formatList != null && formatList.size() > 0) {
			for(CodeDetailVO vo : formatList) {
				vo.setRefCode5(decrypto.decryto(vo.getRefCode5()));
			}
		}
		
		// DB 연결
		Connection connection = CMSDBCon.DBConn(formatList);
		
		if(connection == null) {
			if(formatList != null && formatList.size() > 0) {
				for(CodeDetailVO vo : formatList) {
					vo.setRefCode5(encrypto.encryto(vo.getRefCode5()));
				}
			}
			
			throw new Exception("CMS 데이터베이스 연결에 실패하였습니다.");
			
			//return 0;
		}
		
		Statement stmt = connection.createStatement();
		String query = "SELECT * FROM c_api_coocon_log WHERE COMPANY_NO = '" + param.get("COMPANY_NO") + "' AND SEQ > " + param.get("MAX_SEQ");
		System.out.println(">>>>>>>>QUERY : " + query);
		
		if(formatList != null && formatList.size() > 0) {
			for(CodeDetailVO vo : formatList) {
				vo.setRefCode5(encrypto.encryto(vo.getRefCode5()));
			}
		}
		
		// 조회쿼리
		ResultSet rs = stmt.executeQuery(query);
		
		ResultSetMetaData md = rs.getMetaData();
		int columns = md.getColumnCount();
		
		rs.last();
		if(rs.getRow() < 1) {
			if(rs != null){
				rs.close();
			}
			if(stmt != null) {
				stmt.close();
			}
			if(connection!= null){
				connection.close();
			}
			
			return 0;
		}
		rs.beforeFirst();
		
		List<Map<String, Object>> sfDataList = new ArrayList<Map<String, Object>>();
		
		while(rs.next()){
			// 조회한 데이터 map으로 변환
			HashMap<String,Object> sfData = new HashMap<String, Object>(columns);
			for(int i=1; i<=columns; ++i) {
				sfData.put(md.getColumnName(i), rs.getObject(i));
			}
			sfDataList.add(sfData);
		}
		// DB 커넥션 종료
		if(rs != null){
			rs.close();
		}
		if(stmt != null) {
			stmt.close();
		}
		if(connection!= null){
			connection.close();
		}
		
		int rstlSeq = 0;
		Map<String, Object> setData = new HashMap<String, Object>();
		
		for(int idx = 0, interval = 200; idx < sfDataList.size(); idx = idx + interval) {
			int toIdx = idx + interval;
			
			if(toIdx > sfDataList.size()) {
				toIdx = sfDataList.size();
			}
			
			List<Map<String, Object>> splitDataList = new ArrayList<Map<String, Object>>(sfDataList.subList(idx, toIdx));
			setData.put("SMARTFINDERData", splitDataList);
			
			rstlSeq += super.commonDao.update("cMSIntfServiceImpl.insertCMSData", setData);
		}
		
		return rstlSeq;
	}

	/**
	 * 로그인 정보 강제 생성
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "Accnt")
	public LoginVO selectCMSIntfLoginInfo(Map param) throws Exception {
		Map baseInfo = (Map) super.commonDao.select("cMSIntfServiceImpl.selectBaseInfo", param);
		
		if(baseInfo == null || !baseInfo.containsKey("REF_CODE8") || baseInfo.get("REF_CODE8") == null || baseInfo.get("REF_CODE6").equals("")) {
			throw new Exception("공통코드 등록에서 메인코드[BT02]의 [참조코드8]을 확인하여 주십시오.");
		}
		
		String usn = baseInfo.get("REF_CODE8").toString();
		LoginVO vo = loginService.getUserInfoByUserID(usn);
		
		return vo;
	}
	
}
