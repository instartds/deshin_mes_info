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

@Service("hpb210ukrService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class Hpb210ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());


	/**
	 * 소득 내역 조회 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hpb")
	public List<Map> selectList(Map param, LoginVO user) throws Exception {
		return super.commonDao.list("hpb210ukrService.selectList", param);
	}

	/**
	 * 소득자코드 중복 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public Map checkExistData(Map param) throws Exception {
		return (Map) super.commonDao.select("hpb210ukrService.checkExistData", param);
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
		if(paramList != null)	{
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
				if ((int)checkData.get("EXIST") > 0) {
					throw new Exception("해당인의 지급일자에 이미 지급내역이 등록되었습니다.");
				} else {
					// 귀속년월의 .을 제거함
					param.put("PAY_YYYYMM", param.get("PAY_YYYYMM").toString().replace(".", ""));
					// 콤보 구분자 제거
					String percentI = ((String) param.get("PERCENT_I")).substring(5);
					param.put("PERCENT_I", percentI);
					
					Map makeSeq = (Map) super.commonDao.select("hpb210ukrService.makeSeq", param);
					param.put("SEQ", makeSeq.get("SEQ"));
					super.commonDao.insert("hpb210ukrService.insertList", param);
				}
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
		 for(Map param :paramList )	{
			// 귀속년월의 .을 제거함 
			param.put("PAY_YYYYMM", param.get("PAY_YYYYMM").toString().replace(".", ""));
			// 콤보 구분자 제거
			String percentI = ((String) param.get("PERCENT_I")).substring(5);
			param.put("PERCENT_I", percentI);

			super.commonDao.update("hpb210ukrService.updateList", param);
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
			super.commonDao.delete("hpb210ukrService.deleteList", param);
		}
		
		return 0;
	}



	/**
	 * 승인 / 미승인
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
					super.commonDao.update("hpb210ukrService.closeY", param);
				}
			} else {											//조회조건 마감여부가 마감일 때, 마감취소 실행
				if("Y".equals(param.get("CLOSE_YN"))) {
					super.commonDao.update("hpb210ukrService.closeN", param);
				}
			}
		}
		return 0;
	}











	/*
	*//**
	 * 선택된 행을 추가함
	 * @param param
	 * @return
	 * @throws Exception
	 *//*
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hpb")
	public List<Map> insertList(List<Map> paramList, LoginVO loginVO) throws Exception {
		
		for(Map param :paramList ) {
			Map checkData = checkExistData(param);
			logger.debug(">>>> " + checkData);
			if ((int)checkData.get("EXIST") > 0) {
				throw new Exception("해당인의 지급일자에 이미 지급내역이 등록되었습니다.");
			} else {
				// 귀속년월의 .을 제거함
				param.put("PAY_YYYYMM", param.get("PAY_YYYYMM").toString().replaceAll(".", ""));
				super.commonDao.insert("hpb210ukrService.insertList", param);
			}
		}
		return paramList;
	}
	
	*//**
	 * 선택된 행을 수정함
	 * @param param
	 * @return
	 * @throws Exception
	 *//*
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hpb")
	public List<Map> updateList(List<Map> paramList) throws Exception {
		for(Map param :paramList ) {
			super.commonDao.update("hpb210ukrService.updateList", param);
		}
		return paramList;
	}

	*//**
	 * 선택된 행을 삭제함
	 * @param param
	 * @return
	 * @throws Exception
	 *//*
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hpb")
	public List<Map> deleteList(List<Map> paramList) throws Exception {
		for(Map param :paramList ) {
			super.commonDao.delete("hpb210ukrService.deleteList", param);
		}
		return paramList;
	}
	
	
	@ExtDirectMethod(group = "hpb")
	public Integer syncAll(Map param) throws Exception {
		logger.debug("syncAll:" + param);
		return 0;
	}*/
}