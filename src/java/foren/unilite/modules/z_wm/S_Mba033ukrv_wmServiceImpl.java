package foren.unilite.modules.z_wm;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.service.impl.TlabCodeService;
import foren.unilite.com.validator.UniDirectValidateException;


@Service("s_mba033ukrv_wmService")
@SuppressWarnings({"rawtypes", "unchecked"})
public class S_Mba033ukrv_wmServiceImpl extends TlabAbstractServiceImpl  {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());


	/**
	 * 구매단가 조회
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sales")
	public List<Map> selectList(Map param, LoginVO user) throws Exception {
		return super.commonDao.list("s_mba033ukrv_wmServiceImpl.selectList", param);
	}

	/**
	 * 구매단가 저장
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		if(paramList != null) {
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;

			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("deleteList")) {
					deleteList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("insertList")) {
					insertList = (List<Map>)dataListMap.get("data");}
				else if(dataListMap.get("method").equals("updateList")) {
					updateList = (List<Map>)dataListMap.get("data");
				}
			}
			if(deleteList != null) this.deleteList(deleteList, user);
			if(insertList != null) this.insertList(insertList, user);
			if(updateList != null) this.updateList(updateList, user);
		}
		paramList.add(0, paramMaster);
		return paramList;
	}

	/**
	 * 구매단가 등록 (insert)
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")
	public Integer insertList(List<Map> paramList,  LoginVO user) throws Exception {
		String errMsg = "";
		try {
			for(Map param :paramList) {
				//신규 등록 전, 기 등록된 데이터와 적용 시작일 비교
				String checkData = (String) super.commonDao.select("s_mba033ukrv_wmServiceImpl.checkData", param);

				if (checkData.equals("N")) {
					super.commonDao.insert("s_mba033ukrv_wmServiceImpl.insertList", param);
				} else {
					errMsg = "(등록된 데이터 보다 적용 시작일이 빠른 데이터는 등록할 수 없습니다. - ITEM_CODE: " + param.get("ITEM_CODE") + ")";
					throw new UniDirectValidateException("");
				}
			}
		} catch(Exception e){
			throw new  UniDirectValidateException("저장 중 오류가 발생했습니다. \n" + errMsg);
		}
		return 0;
	}

	/**
	 * 구매단가 수정 (update)
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")
	public Integer updateList(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param :paramList ) {	
			super.commonDao.update("s_mba033ukrv_wmServiceImpl.updateList", param);
		}
		return 0;
	}

	/**
	 * 구매단가 삭제 (delete)
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")
	public Integer deleteList(List<Map> paramList,  LoginVO user) throws Exception {
		for(Map param :paramList ) {
			try {
				super.commonDao.delete("s_mba033ukrv_wmServiceImpl.deleteList", param);
			}catch(Exception e) {
				throw new  UniDirectValidateException(this.getMessage("547",user));
			}
		}
		return 0;
	}









	/**
	 * 구매단가 엑셀업로드
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public void excelValidate(String jobID, Map param) throws Exception {
		logger.debug("validate: {}", jobID);
		//UPLOAD 전 데이터 존재여부 체크
		List<Map> getData = (List<Map>) super.commonDao.list("s_mba033ukrv_wmServiceImpl.getData", param);

		if(!getData.isEmpty()){
			//excel 파일의 데이터 체크
			for(Map data : getData ) {
				param.put("ROWNUM"		, data.get("_EXCEL_ROWNUM"));
				param.put("COMP_CODE"	, data.get("COMP_CODE"));
				param.put("ITEM_CODE"	, data.get("ITEM_CODE"));
				param.put("CUSTOM_CODE"	, data.get("CUSTOM_CODE"));

				//업로드 된 데이터의 품목코드 기등록여부 확인
				String itemExistYn =  (String) super.commonDao.select("s_mba033ukrv_wmServiceImpl.checkItem", param);
				if (itemExistYn.equals("N")) {
					param.put("MSG", "품목코드 [" + data.get("ITEM_CODE") +"]를 먼저 등록한 후 업로드 해 주세요.");
					super.commonDao.update("s_mba033ukrv_wmServiceImpl.insertErrorMsg", param);
				}
			}
		} 
	}

	@ExtDirectMethod(group = "sbs", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectExcelUploadSheet1(Map param) throws Exception {
		return super.commonDao.list("s_mba033ukrv_wmServiceImpl.selectExcelUploadSheet1", param);
	}









	/**
	 * 구매단가 복사
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")
	public Integer copyItemPrice(Map param,  LoginVO user) throws Exception {
		String errMsg = "";
		try {
//			원본 거래처 데이터 존재 확인
			String checkData = (String) super.commonDao.select("s_mba033ukrv_wmServiceImpl.checkOriData", param);

			if (checkData.equals("Y")) {
				super.commonDao.insert("s_mba033ukrv_wmServiceImpl.copyItemPrice", param);
			} else {
				errMsg = "(원본 거래처의 구매단가 정보가 존재하지 않습니다.)";
				throw new  UniDirectValidateException("");
			}
		} catch(Exception e){
			throw new  UniDirectValidateException("단가복사 중 오류가 발생했습니다. \n" + errMsg);
		}
		return 0;
	}
}