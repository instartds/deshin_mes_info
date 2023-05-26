package foren.unilite.modules.human.hpb;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.BindingResult;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.model.LoginVO;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;

@Service("hpb110ukrService")
@SuppressWarnings({ "unchecked", "rawtypes" })
public class Hpb110ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	/**
	 * 세율 구분 거주자/비거주자
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hpb")
	public List<Map<String, Object>> getTaxGubun(Map param, LoginVO user) throws Exception {
		return super.commonDao.list("hpb110ukrService.getTaxGubun", param);
	}

	/**
	 * 소득 내역 조회 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hpb")
	public List<Map> selectDetailList(Map param, LoginVO user) throws Exception {
		return super.commonDao.list("hpb110ukrService.selectList", param);
	}

	/**
	 * 소득자코드 중복 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public Map checkExistData(Map param) throws Exception {
		return (Map) super.commonDao.select("hpb110ukrService.checkExistData", param);
	}



	/**
	 * @param 저장
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "hpb")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		if(paramList != null) {
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("deleteDetail")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("insertDetail")) {
					insertList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("updateDetail")) {
					updateList = (List<Map>)dataListMap.get("data");
				}
			}
			if(deleteList != null) this.deleteDetail(deleteList, user);
			if(insertList != null) this.insertDetail(insertList, user);
			if(updateList != null) this.updateDetail(updateList, user);
		}
		paramList.add(0, paramMaster);
		return paramList;
	}

	/**
	 * 선택된 행을 추가함
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hpb")		// INSERT
	public Integer insertDetail(List<Map> paramList, LoginVO user) throws Exception {
		try {
			for(Map param :paramList ) {
				Map checkData = checkExistData(param);
				logger.debug(">>>> " + checkData);
				//if ((int)checkData.get("EXIST") > 0) {
				//	throw new Exception("해당인의 지급일자에 이미 지급내역이 등록되었습니다.");
				//} else 
				//{
					// 귀속년월의 .을 제거함
					param.put("PAY_YYYYMM", param.get("PAY_YYYYMM").toString().replace(".", ""));
					// 콤보 구분자 제거
					//String percentI = ((String) param.get("PERCENT_I")).substring(5);
					//param.put("PERCENT_I", percentI);
					
					Map makeSeq = (Map) super.commonDao.select("hpb110ukrService.makeSeq", param);
					param.put("SEQ", makeSeq.get("SEQ"));
					super.commonDao.insert("hpb110ukrService.insertList", param);
				//}
			}
		}catch(Exception e){
			throw new UniDirectValidateException(this.getMessage("2627", user));
		}
		return 0;
	}

	/**
	 * 선택된 행을 수정함
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")		// UPDATE
	public Integer updateDetail(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param :paramList ) {
			// 귀속년월의 .을 제거함 
			param.put("PAY_YYYYMM", param.get("PAY_YYYYMM").toString().replace(".", ""));
			// 콤보 구분자 제거
			//String percentI = ((String) param.get("PERCENT_I")).substring(5);
			//param.put("PERCENT_I", percentI);

			super.commonDao.update("hpb110ukrService.updateList", param);
		}
		return 0;
	}

	/**
	 * 선택된 행을 삭제함
	 * @param param
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(group = "hpb", needsModificatinAuth = true)		// DELETE
	public Integer deleteDetail(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param :paramList ) {
			// 귀속년월의 .을 제거함
			param.put("PAY_YYYYMM", param.get("PAY_YYYYMM").toString().replace(".", ""));
			super.commonDao.delete("hpb110ukrService.deleteList", param);
		}
		return 0;
	}



	/**
	 * 엑셀 업로드
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectExcelUploadSheet(Map param) throws Exception {
		return super.commonDao.list("hpb110ukrService.selectExcelUploadSheet", param);
	}

	/**
	 * 퇴직급여 엑셀업로드
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public void excelValidate(String jobID, Map param) throws Exception {
		logger.debug("validate: {}", jobID);
		//UPLOAD 전 데이터 존재여부 체크
		List<Map> getData = (List<Map>) super.commonDao.list("hpb110ukrService.getData", param);
		
		if(!getData.isEmpty()){
			//excel 파일의 데이터 체크
			for(Map data : getData ) {
				param.put("ROWNUM", data.get("_EXCEL_ROWNUM"));
				param.put("COMP_CODE", data.get("COMP_CODE"));
			}
		}
	}



	/**
	 * 승인 / 미승인 - 20210609 추가
	 * @param paramList
	 * @param user
	 * @param paramMaster
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "human")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> runAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		if(paramList != null) {
			List<Map> runClose = null;

			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("runClose")) {
					runClose = (List<Map>)dataListMap.get("data");
				}
			}
			if(runClose != null) this.runClose(runClose, paramMaster, user);
		}
		paramList.add(0, paramMaster);
		return paramList;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "human")
	public Integer runClose(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		for(Map param :paramList) {
			if("N".equals(dataMaster.get("CLOSE_YN"))) {		//조회조건 마감여부가 미마감일 때, 마감로직 실행
				if("N".equals(param.get("CLOSE_YN"))) {
					super.commonDao.update("hpb110ukrService.closeY", param);
				}
			} else {											//조회조건 마감여부가 마감일 때, 마감취소 실행
				if("Y".equals(param.get("CLOSE_YN"))) {
					super.commonDao.update("hpb110ukrService.closeN", param);
				}
			}
		}
		return 0;
	}
}