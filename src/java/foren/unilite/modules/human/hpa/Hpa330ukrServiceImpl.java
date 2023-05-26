package foren.unilite.modules.human.hpa;

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


@Service("hpa330ukrService")
public class Hpa330ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	/**
	 * 수당 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hpa")
	public List<Map<String, Object>> selectList1(Map param) throws Exception {
		List<Map<String, Object>> rv = (List)super.commonDao.list("hpa330ukrServiceImpl.selectList1", param);
		// 급여계산이 안되어 있음 HBS300T에서 보여준다.
		if (rv != null && rv.size() == 0) {
			rv = (List)super.commonDao.list("hpa330ukrServiceImpl.selectList1_1", param);
		}
		return rv;
	}

	/**
	 * 공제 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hpa")
	public List<Map<String, Object>> selectList2(Map param) throws Exception {
		List<Map<String, Object>> rv = (List)super.commonDao.list("hpa330ukrServiceImpl.selectList2", param);
		// 급여계산이 안되어 있음 HBS300T에서 보여준다.
		if (rv != null && rv.size() == 0) {
			rv = (List)super.commonDao.list("hpa330ukrServiceImpl.selectList2_1", param);
		}
		return rv;
	}

	/**
	 * 추가/데이터 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_LOAD, group = "hpa")
	public Object selectList3(Map param) throws Exception {
		Object rv = super.commonDao.select("hpa330ukrServiceImpl.selectList3", param);
		return rv;
	}
	/**
	 * 추가/데이터 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_LOAD, group = "hpa")
	public Object selectList3_2(Map param) throws Exception {
		Object rv = super.commonDao.select("hpa330ukrServiceImpl.getHumanMaster", param);
		return rv;
	}
	/**
	 * 월근무 현황 조회 (팝업용)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hpa")
	public List<Map<String, Object>>  selectList4(Map param) throws Exception {
		return (List) super.commonDao.list("hpa330ukrServiceImpl.selectList4", param);
	}

	/**
	 * Navi button 사용가능 여부 확인
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "human")
	public List<Map<String, Object>> checkAvailableNavi(Map param) throws Exception {
		return (List) super.commonDao.list("hpa330ukrServiceImpl.getPrNxPersonNumb", param);
	}

	/**
	 * 전달 급여 데이터 조회 - 01. 폼 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> selectList1ForCopy(Map param) throws Exception {
		return (List) super.commonDao.list("hpa330ukrServiceImpl.seletList1ForCopy", param);
	}

	/**
	 * 전달 급여 데이터 조회 - 01. 폼 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> selectList2ForCopy(Map param) throws Exception {
		return (List) super.commonDao.list("hpa330ukrServiceImpl.seletList2ForCopy", param);
	}

	/**
	 * 전달 급여 데이터 조회 - 01. 폼 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> selectList3ForCopy(Map param) throws Exception {
		return (List) super.commonDao.list("hpa330ukrServiceImpl.seletList3ForCopy", param);
	}

	/**
	 * 업데이트가 가능한지 확인 마감, 전표
	 * @param param
	 * @return
	 */
	@ExtDirectMethod(group = "human")
	public String checkUpdateAvailable(Map param) {
		String result = super.commonDao.queryForObject("hpa330ukrServiceImpl.checkUpdateAvailable", param).toString();
		return result;
	}

	/**
	 * 결과폼1 저장
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_POST, group = "hpa")
	public ExtDirectFormPostResult form01Submit(Hpa330ukrModel param, LoginVO loginVO, BindingResult result) throws Exception {
		param.setS_COMP_CODE(loginVO.getCompCode());
		param.setS_USER_ID(loginVO.getUserID());

		logger.debug(param.getDEPT_CODE());
		logger.debug(param.getDEPT_NAME());


		super.commonDao.update("hpa330ukrServiceImpl.form01update", param);
		ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);

		return extResult;
	}

	/**
	 * 결과폼2 저장
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_POST, group = "hpa")
	public ExtDirectFormPostResult form02Submit(Hpa330ukrModel param, LoginVO loginVO, BindingResult result) throws Exception {
		param.setS_COMP_CODE(loginVO.getCompCode());
		param.setS_USER_ID(loginVO.getUserID());
		param.setPOST_CODE("03");
		logger.debug(param.getDEPT_CODE());
		logger.debug(param.getDEPT_NAME());

		super.commonDao.update("hpa330ukrServiceImpl.form02update", param);
		ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);

		return extResult;
	}

	/**
	 * 삭제
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "hpa")
	public void deleteList(Map<String, Object> param, LoginVO user) throws Exception {
		param.put("DELETE_YN", "Y");
		Map ErrMap = (Map) super.commonDao.select("hpa330ukrServiceImpl.payroll", param);

		String errorDesc = ObjUtils.getSafeString(ErrMap.get("ErrorDesc"));
		if(!ObjUtils.isEmpty(errorDesc)){
            throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
		}
	}

	/**
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "hpa")
	public void calPayroll(Map<String, Object> param, LoginVO user) throws Exception {
		param.put("DELETE_YN", "N");
		Map ErrMap = (Map) super.commonDao.select("hpa330ukrServiceImpl.payroll", param);

		String errorDesc = ObjUtils.getSafeString(ErrMap.get("ErrorDesc"));
		if(!ObjUtils.isEmpty(errorDesc)){
            throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
		}
	}
	/**
	 * grid 수정(지급내역)저장
	 * @param paramList	리스트의 create, update, destroy 오퍼레이션별 정보
	 * @param paramMaster 폼(마스터 정보)의 기본 정보
	 * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "hum", value = ExtDirectMethodType.STORE_SYNCALL )
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll(List<Map> paramList, Map<String, Object> paramMaster, LoginVO user) throws Exception {

		if(paramList != null)	{
			List<Map> masterUpdateList = null;
			List<Map> detailUpdateList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("updateList1")) {
					masterUpdateList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("updateList2")) {
					detailUpdateList = (List<Map>)dataListMap.get("data");
				}
			}
			if(masterUpdateList != null) this.updateList1(masterUpdateList, user);
			if(detailUpdateList != null) this.updateList2(detailUpdateList, user);
		}

		// sp 호출
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");

		for(Map.Entry<String, Object> entry : dataMaster.entrySet()) {
    		logger.debug(entry.getKey()+" : "+ entry.getValue());
    	}
		logger.debug("${S_COMP_CODE}  ${PAY_YYYYMM} ${SUPP_DATE} :"+dataMaster.get("S_COMP_CODE")+"/"+dataMaster.get("PAY_YYYYMM")+"/"+dataMaster.get("SUPP_DATE"));
		dataMaster.put("DELETE_YN", "N");
		dataMaster.put("BATCH_YN", "N");

		Map ErrMap = (Map) super.commonDao.select("hpa330ukrServiceImpl.payroll", dataMaster);

		String errorDesc = ObjUtils.getSafeString(ErrMap.get("ErrorDesc"));
		if(!"".equals(errorDesc))	{
			throw new  UniDirectValidateException(errorDesc);
		}

		paramList.add(0, paramMaster);

		return  paramList;
	}



	/**
	 * grid 수정(공제내역)저장
	 * @param paramList	리스트의 create, update, destroy 오퍼레이션별 정보
	 * @param paramMaster 폼(마스터 정보)의 기본 정보
	 * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "hum", value = ExtDirectMethodType.STORE_SYNCALL )
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll2(List<Map> paramList, Map<String, Object> paramMaster, LoginVO user) throws Exception {

		if(paramList != null)	{
			List<Map> masterUpdateList = null;
			List<Map> detailUpdateList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("updateList1")) {
					masterUpdateList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("updateList2")) {
					detailUpdateList = (List<Map>)dataListMap.get("data");
				}
			}
			if(masterUpdateList != null) this.updateList1(masterUpdateList, user);
			if(detailUpdateList != null) this.updateList2(detailUpdateList, user);
		}

		// sp 호출
//		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
//
//		for(Map.Entry<String, Object> entry : dataMaster.entrySet()) {
//    		logger.debug(entry.getKey()+" : "+ entry.getValue());
//    	}
//		logger.debug("${S_COMP_CODE}  ${PAY_YYYYMM} ${SUPP_DATE} :"+dataMaster.get("S_COMP_CODE")+"/"+dataMaster.get("PAY_YYYYMM")+"/"+dataMaster.get("SUPP_DATE"));
//		Map ErrMap = (Map) super.commonDao.select("hpa330ukrServiceImpl.payroll", dataMaster);

//		String errorDesc = ObjUtils.getSafeString(ErrMap.get("ErrorDesc"));
//		if(!"".equals(errorDesc))	{
//			throw new  UniDirectValidateException(errorDesc);
//		}
		paramList.add(0, paramMaster);

		return  paramList;
	}





	/**
	 * grid 수정(지급내역)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "hpa", value = ExtDirectMethodType.STORE_MODIFY )
	public Integer updateList1(List<Map> paramList, LoginVO user) throws Exception {

		 for(Map param :paramList )	{

			 param.put("PAY_YYYYMM", ObjUtils.getSafeString(param.get("PAY_YYYYMM")).replace(".",""));
			 super.commonDao.update("hpa330ukrServiceImpl.updateList1", param);
		 }
		 return 0;
	}

	/**
	 * grid 수정(공제내역)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "hpa", value = ExtDirectMethodType.STORE_MODIFY )
	public Integer updateList2(List<Map> paramList, LoginVO user) throws Exception {

		 Map<String, Object> spParam = new HashMap<String, Object>();
		 int i = 0;

		 for(Map param :paramList )	{

			 i = i +1;

			 if(i==1){
				 spParam.put("S_COMP_CODE", param.get("S_COMP_CODE"));
				 spParam.put("PAY_YYYYMM", ObjUtils.getSafeString(param.get("PAY_YYYYMM")).replace(".",""));
				 spParam.put("SUPP_TYPE", param.get("SUPP_TYPE"));
				 spParam.put("PERSON_NUMB", param.get("PERSON_NUMB"));
			 }

			 param.put("PAY_YYYYMM", ObjUtils.getSafeString(param.get("PAY_YYYYMM")).replace(".",""));

			 super.commonDao.update("hpa330ukrServiceImpl.updateList2", param);

		 }

		 super.commonDao.update("hpa330ukrServiceImpl.updateList3", spParam);

		 return 0;
	}


	@ExtDirectMethod(group = "hpa")
	public void deleteList1(Map param) throws Exception {

		  super.commonDao.update("hpa330ukrServiceImpl.deleteList1", param);

	}

	@ExtDirectMethod(group = "hpa")
	public void deleteList2(Map param) throws Exception {

		  super.commonDao.update("hpa330ukrServiceImpl.deleteList2", param);

	}


	@ExtDirectMethod(group = "hpa")
	public void insertHPA600(Map param) throws Exception {

		  super.commonDao.update("hpa330ukrServiceImpl.insertHPA600", param);

	}

	@ExtDirectMethod(group = "hpa")
	public void Payroll(Map<String, Object> param, LoginVO user) throws Exception {
		param.put("DELETE_YN", "N");
		Map ErrMap = (Map) super.commonDao.select("hpa330ukrServiceImpl.payroll", param);

		String errorDesc = ObjUtils.getSafeString(ErrMap.get("ErrorDesc"));
		if(!ObjUtils.isEmpty(errorDesc)){
            throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
		}
	}

	/**
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "hpa")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public String payClose(Map<String, Object> param, LoginVO user) throws Exception {
		try {
			super.commonDao.insert("hpa330ukrServiceImpl.payClose", param);

		}catch(Exception e){
			throw new  UniDirectValidateException(this.getMessage("0", user));
		}
		return "Y";

		/*String errorDesc = ObjUtils.getSafeString(ErrMap.get("ErrorDesc"));
		if(!ObjUtils.isEmpty(errorDesc)){
            throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
		}*/
	}

	/**
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "hpa")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public String payCloseCancel(Map<String, Object> param, LoginVO user) throws Exception {
		try {
			super.commonDao.delete("hpa330ukrServiceImpl.payCloseCancel", param);
		}catch(Exception e){
			throw new  UniDirectValidateException(this.getMessage("0", user));
		}
		return "Y";

	/*	String errorDesc = ObjUtils.getSafeString(ErrMap.get("ErrorDesc"));
		if(!ObjUtils.isEmpty(errorDesc)){
           throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
		}*/
	}
	/**
	 * 연말정산 분납 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectYearEndList(Map param) throws Exception {
		return (List) super.commonDao.list("hpa330ukrServiceImpl.selectYearEndList", param);
	}
	

}
