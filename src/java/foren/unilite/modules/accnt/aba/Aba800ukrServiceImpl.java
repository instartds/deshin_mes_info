package foren.unilite.modules.accnt.aba;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.BindingResult;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.extjs.UniliteExtjsUtils;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.base.bdc.Bdc100ukrvService;
import foren.unilite.modules.com.fileman.FileMnagerService;


@Service("aba800ukrService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class Aba800ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());


	/**
	 * 자동분개등록 마스터Grid 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectMasterList(Map param) throws Exception {
		return super.commonDao.list("aba800ukrServiceImpl.selectMasterList", param);
	}

	/**
	 * 자동분개등록 디테일Grid 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectDetailList(Map param) throws Exception {
		return super.commonDao.list("aba800ukrServiceImpl.selectDetailList", param);
	}



	/**
	 * 저장
	 * @param paramList	리스트의 create, update, destroy 오퍼레이션별 정보
	 * @param paramMaster 폼(마스터 정보)의 기본 정보
	 * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "accnt")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		if(paramList != null) {
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
			if(deleteList != null) this.deleteDetail(deleteList, user, paramMaster);
			if(insertList != null) this.insertDetail(insertList, user, paramMaster);
			if(updateList != null) this.updateDetail(updateList, user, paramMaster);
		}
		paramList.add(0, paramMaster);
		return  paramList;
	}

	/**
	 * Detail 입력
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public Integer  insertDetail(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {	
		try {
			Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
			for(Map param : paramList ) {
				if(dataMaster.get("AUTO_CD") == null || "".equals(ObjUtils.getSafeString(dataMaster.get("AUTO_CD")))) {
					param.put("AUTO_GUBUN", dataMaster.get("AUTO_GUBUN"));
					//자동분개 번호 가져오기
					Map autoCdMap = (Map) super.commonDao.select("aba800ukrServiceImpl.maxAutoCd", param);
					String autoCd = ObjUtils.getSafeString(autoCdMap.get("AUTO_CD"));
					param.put("AUTO_CD", autoCd);
					param.put("AUTO_NM", dataMaster.get("AUTO_NM"));

					//신규 등록일시 master도 insert
					dataMaster.put("AUTO_CD", autoCd);
					if(dataMaster.get("AUTO_GUBUN").equals("01")){
						dataMaster.put("AUTO_DATA", dataMaster.get("USER_ID"));
						param.put("AUTO_DATA", dataMaster.get("USER_ID"));
					} else if(dataMaster.get("AUTO_GUBUN").equals("02")){
						dataMaster.put("AUTO_DATA", dataMaster.get("DEPT_CODE"));
						param.put("AUTO_DATA", dataMaster.get("DEPT_CODE"));
					} else if(dataMaster.get("AUTO_GUBUN").equals("03")){
						dataMaster.put("AUTO_DATA", dataMaster.get("DIV_CODE"));
						param.put("AUTO_DATA", dataMaster.get("DIV_CODE"));
					}
					super.commonDao.update("aba800ukrServiceImpl.insertMaster", dataMaster);
				} else {
					param.put("AUTO_CD", dataMaster.get("AUTO_CD"));
					param.put("AUTO_GUBUN", dataMaster.get("AUTO_GUBUN"));
					if(dataMaster.get("AUTO_GUBUN").equals("01")){
						dataMaster.put("AUTO_DATA", dataMaster.get("USER_ID"));
						param.put("AUTO_DATA", dataMaster.get("USER_ID"));
					} else if(dataMaster.get("AUTO_GUBUN").equals("02")){
						dataMaster.put("AUTO_DATA", dataMaster.get("DEPT_CODE"));
						param.put("AUTO_DATA", dataMaster.get("DEPT_CODE"));
					} else if(dataMaster.get("AUTO_GUBUN").equals("03")){
						dataMaster.put("AUTO_DATA", dataMaster.get("DIV_CODE"));
						param.put("AUTO_DATA", dataMaster.get("DIV_CODE"));
					}
					super.commonDao.update("aba800ukrServiceImpl.updateMaster", dataMaster);
				}
				super.commonDao.update("aba800ukrServiceImpl.insertDetail1", param);
			}
		}catch(Exception e){
			logger.error(e.toString());
			e.printStackTrace();
			throw new  UniDirectValidateException(this.getMessage("2627", user));
		}
		return 0;
	}	

	/**
	 * Detail 수정
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public Integer updateDetail(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data"); 
		int i =0;
		for(Map param :paramList ) {
			param.put("AUTO_GUBUN", dataMaster.get("AUTO_GUBUN"));
			if(dataMaster.get("AUTO_GUBUN").equals("01")){
				dataMaster.put("AUTO_DATA", dataMaster.get("USER_ID"));
				param.put("AUTO_DATA", dataMaster.get("USER_ID"));
			} else if(dataMaster.get("AUTO_GUBUN").equals("02")){
				dataMaster.put("AUTO_DATA", dataMaster.get("DEPT_CODE"));
				param.put("AUTO_DATA", dataMaster.get("DEPT_CODE"));
			} else if(dataMaster.get("AUTO_GUBUN").equals("03")){
				dataMaster.put("AUTO_DATA", dataMaster.get("DIV_CODE"));
				param.put("AUTO_DATA", dataMaster.get("DIV_CODE"));
			}
			if(i==0) {
				super.commonDao.update("aba800ukrServiceImpl.updateMaster", dataMaster);
			}
			super.commonDao.update("aba800ukrServiceImpl.updateDetail", param);
			i++;
		}
		return 0;
	} 

	/**
	 * Detail 삭제
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_MODIFY)
	public Integer deleteDetail(List<Map> paramList,  LoginVO user, Map paramMaster) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");  
		for(Map param :paramList ) {
			 try {
				 param.put("AUTO_GUBUN", dataMaster.get("AUTO_GUBUN"));
				 super.commonDao.delete("aba800ukrServiceImpl.deleteDetail", param);
				 
				 Map chkItemMap = (Map) super.commonDao.select("aba800ukrServiceImpl.checkDetailCount", param);
				 if(ObjUtils.parseInt(chkItemMap.get("CNT")) == 0) {
					 super.commonDao.delete("aba800ukrServiceImpl.deleteMaster", param);
				}
			}catch(Exception e) {
				throw new  UniDirectValidateException(this.getMessage("547",user));
			}
		}
		return 0;
	}



	/**
	 * master data 저장
	 * @param paramList
	 * @param paramMaster
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "accnt")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveMasterAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		if(paramList != null) {
			List<Map> updateList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("updateMaster")) {
					updateList = (List<Map>)dataListMap.get("data");
				}
			}
			if(updateList != null) this.updateMaster(updateList, user);
		}
		paramList.add(0, paramMaster);
		return  paramList;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public Integer updateMaster(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param :paramList ) {
			if(param.get("AUTO_GUBUN").equals("01")){
				param.put("AUTO_DATA", param.get("USER_ID"));
			} else if(param.get("AUTO_GUBUN").equals("02")){
				param.put("AUTO_DATA", param.get("DEPT_CODE"));
			} else if(param.get("AUTO_GUBUN").equals("03")){
				param.put("AUTO_DATA", param.get("DIV_CODE"));
			}
			super.commonDao.update("aba800ukrServiceImpl.updateMaster", param);
		}
		return 0;
	} 

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public Integer  insertMaster(List<Map> paramList, LoginVO user) throws Exception {	
		for(Map param : paramList ) {
			if(param.get("AUTO_CD") == null || "".equals(ObjUtils.getSafeString(param.get("AUTO_CD")))) {
				//자동분개 번호 가져오기
				Map autoCdMap = (Map) super.commonDao.select("aba800ukrServiceImpl.maxAutoCd", param);
				String autoCd = ObjUtils.getSafeString(autoCdMap.get("AUTO_CD"));
				param.put("AUTO_CD", autoCd);
			}
			if(param.get("AUTO_GUBUN").equals("01")){
				param.put("AUTO_DATA", param.get("USER_ID"));
			} else if(param.get("AUTO_GUBUN").equals("02")){
				param.put("AUTO_DATA", param.get("DEPT_CODE"));
			} else if(param.get("AUTO_GUBUN").equals("03")){
				param.put("AUTO_DATA", param.get("DIV_CODE"));
			}
			super.commonDao.update("aba800ukrServiceImpl.insertMaster", param);
		}
		return 0;
	}

	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_MODIFY)
	public Integer deleteMaster(List<Map> paramList,  LoginVO user, Map paramMaster) throws Exception {
		for(Map param :paramList ) {
			try {
				Map chkItemMap = (Map) super.commonDao.select("aba800ukrServiceImpl.checkDetailCount", param);
				if(ObjUtils.parseInt(chkItemMap.get("CNT")) == 0) {
					super.commonDao.delete("aba800ukrServiceImpl.deleteMaster", param);
				} else {
					throw new  UniDirectValidateException(this.getMessage("547",user));
				}
			}catch(Exception e) {
				logger.error(e.toString());
				e.printStackTrace();
				throw new  UniDirectValidateException(this.getMessage("547",user));
			}
		}
		return 0;
	}



	/**
	 * 분개구분 시, 저장로직 - 20200813 추가
	 * @param paramList
	 * @param paramMaster
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "aba", value = ExtDirectMethodType.STORE_SYNCALL)
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveNew(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		Map<String, Object> dataMaster	= (Map<String, Object>)paramMaster.get("data");
		List<Map> dataList				= new ArrayList<Map>();
		Map<String, Object> autoCdNew	= new HashMap<String, Object>();

		if(paramList != null) {
			//master data 저장
			if(dataMaster.get("AUTO_GUBUN").equals("01")){
				dataMaster.put("AUTO_DATA", dataMaster.get("USER_ID"));
			} else if(dataMaster.get("AUTO_GUBUN").equals("02")){
				dataMaster.put("AUTO_DATA", dataMaster.get("DEPT_CODE"));
			} else if(dataMaster.get("AUTO_GUBUN").equals("03")){
				dataMaster.put("AUTO_DATA", dataMaster.get("DIV_CODE"));
			}
			autoCdNew = (Map<String, Object>) super.commonDao.select("aba800ukrServiceImpl.insertExtraM", dataMaster);
			//detail data 저장
			for(Map param: paramList) {
				if(param.get("method").equals("insertNew")) {
					dataList = (List<Map>)param.get("data");
					param.put("data", insertNew(dataList, dataMaster, user, autoCdNew));
				}
			}
		}
		paramList.add(0, paramMaster);
		return  paramList;
	}

	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> insertNew(List<Map> paramList, Map paramMaster, LoginVO user, Map autoCdNew) throws Exception {
		for(Map param : paramList) {
			param.put("AUTO_GUBUN"	, paramMaster.get("AUTO_GUBUN"));
			param.put("AUTO_CD"		, autoCdNew.get("AUTO_CD_NEW"));
			param.put("AUTO_DATA"	, paramMaster.get("AUTO_DATA"));
			super.commonDao.update("aba800ukrServiceImpl.insertExtraD", param);
		}
		return paramList;
	}
}