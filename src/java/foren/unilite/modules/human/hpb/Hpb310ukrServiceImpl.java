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
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;

@Service("hpb310ukrService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class Hpb310ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	/**
	 * 소득 내역 조회  
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "hpb")
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return (List) super.commonDao.list("hpb310ukrService.selectList", param);
	}

	/**
	 * 소득자코드 중복 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public Map checkExistData(Map param) throws Exception {
		return  (Map) super.commonDao.select("hpb310ukrService.checkExistData", param);
	}

	/**
	 * 신규등록시 기발행내역 체크
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public Map fnHpb310nSet(Map param) throws Exception {
		return  (Map) super.commonDao.select("hpb310ukrService.fnHpb310nSet", param);
	}

	/**
	 * HBS130T에서 조회용 귀속년월을 가져오기
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@Transactional(readOnly = true)
	@ExtDirectMethod(group = "hpb", value = ExtDirectMethodType.STORE_MODIFY)
	public Map fnHpb310nChkQ(Map param) throws Exception {
		return  (Map) super.commonDao.select("hpb310ukrService.fnHpb310nChkQ", param);
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
				} else if(dataListMap.get("method").equals("insertDetail")) {
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
		return  paramList;
	}

	/**
	 * 선택된 행을 추가함
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hpb")		// INSERT
	public Integer  insertDetail(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param :paramList ) {
			// 귀속년월의 .을 제거함
			param.put("PAY_YYYYMM", param.get("PAY_YYYYMM").toString().replace(".", ""));
			Map check = fnHpb310nSet(param);

//			if (ObjUtils.parseInt(check.get("EXIST")) > 0) {
//				throw new  UniDirectValidateException(this.getMessage("55205", user)); // 해당인의 지급일자에 이미 지급내역이 등록되었습니다
//			}else{
				//try {
					Map makeSeq = (Map) super.commonDao.select("hpb310ukrService.makeSeq", param);
					param.put("SEQ", makeSeq.get("SEQ"));
					super.commonDao.insert("hpb310ukrService.insertList", param);
				//}
				//catch(Exception e){
				//	throw new  UniDirectValidateException(this.getMessage("2627", user));
				//}
//			}
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
			super.commonDao.update("hpb310ukrService.updateList", param);
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
	public Integer deleteDetail(List<Map> paramList,  LoginVO user) throws Exception {
		for(Map param :paramList ) {
			// 귀속년월의 .을 제거함
			param.put("PAY_YYYYMM", param.get("PAY_YYYYMM").toString().replace(".", ""));
			super.commonDao.delete("hpb310ukrService.deleteList", param);
		}
		return 0;
	}




	/**
	 * 승인 / 미승인 - 20210610 추가
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
					super.commonDao.update("hpb310ukrService.closeY", param);
				}
			} else {											//조회조건 마감여부가 마감일 때, 마감취소 실행
				if("Y".equals(param.get("CLOSE_YN"))) {
					super.commonDao.update("hpb310ukrService.closeN", param);
				}
			}
		}
		return 0;
	}
}