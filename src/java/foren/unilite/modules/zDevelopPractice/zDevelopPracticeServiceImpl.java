package foren.unilite.modules.zDevelopPractice;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
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

import com.google.gson.Gson;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.lib.tree.GenericTreeDataMap;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.base.bdc.Bdc100ukrvService;
import foren.unilite.modules.com.tree.UniTreeHelper;
import foren.unilite.modules.com.tree.UniTreeNode;
import foren.unilite.modules.sales.scn.Scn100ukrvModel;
import foren.unilite.modules.sales.sof.Sof100ukrvModel;
import foren.unilite.utils.ExtFileUtils;



@Service("zDevelopPracticeService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class zDevelopPracticeServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());


	/**
	 * practice1 조회
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "dev")
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return super.commonDao.list("zDevelopPracticeServiceImpl.selectList", param);
	}

/*------------------------------------------------------------------------------------------*/


	/**
	 * practice2 조회(검색 윈도우) -20210416
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "dev")
	public List<Map<String, Object>> selectWhCodeList(Map param) throws Exception {
		return super.commonDao.list("zDevelopPracticeServiceImpl.selectWhCodeList", param);
	}

	/**
	 * Master data 조회																	- ExtDirectMethodType.FORM_LOAD로 설정하여 조회한 데이터를 생성해놓은 MODEL을 통해 자동으로 넣는다.
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_LOAD, group = "dev")
	public Object selectMaster2(Map param, LoginVO user) throws Exception {
		return super.commonDao.select("zDevelopPracticeServiceImpl.selectMaster2", param);
	}

	/**
	 * practice2 조회(detailGrid) -20210414
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "dev")
	public List<Map<String, Object>> selectList2(Map param) throws Exception {
		return super.commonDao.list("zDevelopPracticeServiceImpl.selectList2", param);
	}

	/**
	 * practice2 저장(panelResult)															- ExtDirectMethodType.FORM_LOAD로 설정하여 practice2Model통해 저장할 데이터를 가져와 저장.
	 * @param dataMaster
	 * @param user
	 * @param result
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_POST, group = "dev")
	public ExtDirectFormPostResult saveMaster2(practice2Model dataMaster, LoginVO user, BindingResult result) throws Exception {
		dataMaster.setS_COMP_CODE(user.getCompCode());									//model에 누락된 데이터는 저장하기 전에 수동으로 설정
		dataMaster.setS_USER_ID(user.getUserID());										//model에 누락된 데이터는 저장하기 전에 수동으로 설정
		super.commonDao.insert("zDevelopPracticeServiceImpl.saveMaster2", dataMaster);
		ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);

		return extResult;
	}


	/**
	 * practice2 저장(masterGrid)
	 * @param paramList
	 * @param paramMaster
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_SYNCALL, group = "dev" )
	@Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
	public List<Map> saveAll2( List<Map> paramList, Map paramMaster, LoginVO user ) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>)paramMaster.get("data");

		if (paramList != null) {
			List<Map> insertDetail2 = null;
			List<Map> updateDetail2 = null;
			List<Map> deleteDetail2 = null;

			for (Map dataListMap : paramList) {
				if (dataListMap.get("method").equals("insertDetail2")) {			//추가
					insertDetail2 = (List<Map>)dataListMap.get("data");
				} else if (dataListMap.get("method").equals("updateDetail2")) {		//수정
					updateDetail2 = (List<Map>)dataListMap.get("data");
				} else if (dataListMap.get("method").equals("deleteDetail2")) {		//삭제
					deleteDetail2 = (List<Map>)dataListMap.get("data");
				}
			}
			if (deleteDetail2 != null) this.deleteDetail2(deleteDetail2, user, dataMaster);			//삭제
			if (insertDetail2 != null) this.insertDetail2(insertDetail2, user, dataMaster);			//추가
			if (updateDetail2 != null) this.updateDetail2(updateDetail2, user, dataMaster);			//수정
		}
		paramList.add(0, paramMaster);
		return paramList;
	}

	/** 추가 **/
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "dev" )
	public Integer insertDetail2( List<Map> paramList, LoginVO user, Map paramMaster ) throws Exception {
		/* 데이터 insert */
		try {
			for (Map param : paramList) {
				super.commonDao.insert("zDevelopPracticeServiceImpl.insertDetail2", param);
			}
		} catch (Exception e) {
			throw new UniDirectValidateException(this.getMessage("8114", user));
		}
		return 0;
	}

	/** 수정 **/
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "dev" )
	public Integer updateDetail2( List<Map> paramList, LoginVO user, Map paramMaster ) throws Exception {
		for (Map param : paramList) {
			super.commonDao.update("zDevelopPracticeServiceImpl.updateDetail2", param);
		}
		return 0;
	}

	/** 삭제 **/
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "dev" )
	public Integer deleteDetail2( List<Map> paramList, LoginVO user, Map paramMaster ) throws Exception {
		for (Map param : paramList) {
			try {
				super.commonDao.delete("zDevelopPracticeServiceImpl.deleteDetail2", param);
			} catch (Exception e) {
				throw new UniDirectValidateException(this.getMessage("547", user));
			}
		}
		return 0;
	}

	/**
	 * 전체삭제
	 * @param paramList
	 * @param user
	 * @param paramMaster
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "dev" )
	public Integer deleteAll2( Map param, LoginVO user ) throws Exception {
		/* 데이터 insert */
		try {
			super.commonDao.insert("zDevelopPracticeServiceImpl.deleteAll2", param);
		} catch (Exception e) {
			throw new UniDirectValidateException("전체삭제 중 오류가 발생했습니다.");
		}
		return 0;
	}

	/*------------------------------------------------------------------------------------------*/


	/**
	 * practice3 조회 -20210408
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "dev")
	public List<Map<String, Object>> selectList3(Map param) throws Exception {
		return super.commonDao.list("zDevelopPracticeServiceImpl.selectList3", param);
	}

	/**
	 * practice3 출력 -20210412
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "mpo")
	public List<Map<String, Object>> print1(Map param) throws Exception {
		return super.commonDao.list("zDevelopPracticeServiceImpl.print1", param);
	}
	
	/**
	 * practice3 출력 -20210412
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "mpo")
	public List<Map<String, Object>> print2(Map param) throws Exception {
		return super.commonDao.list("zDevelopPracticeServiceImpl.print2", param);
	}

	/*------------------------------------------------------------------------------------------*/


	/**
	 * practice4 조회 -20210413
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "dev")
	public List<Map<String, Object>> selectList4(Map param) throws Exception {
		return super.commonDao.list("zDevelopPracticeServiceImpl.selectList4", param);
	}

	/** 저장 **/
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_SYNCALL, group = "dev" )
	@Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
	public List<Map> saveAll4( List<Map> paramList, Map paramMaster, LoginVO user ) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>)paramMaster.get("data");

		if (paramList != null) {
			List<Map> insertDetail4 = null;
			List<Map> updateDetail4 = null;
			List<Map> deleteDetail4 = null;

			for (Map dataListMap : paramList) {
				if (dataListMap.get("method").equals("insertDetail4")) {			//추가
					insertDetail4 = (List<Map>)dataListMap.get("data");
				} else if (dataListMap.get("method").equals("updateDetail4")) {		//수정
					updateDetail4 = (List<Map>)dataListMap.get("data");
				} else if (dataListMap.get("method").equals("deleteDetail4")) {		//삭제
					deleteDetail4 = (List<Map>)dataListMap.get("data");
				}
			}
			if (deleteDetail4 != null) this.deleteDetail4(deleteDetail4, user, dataMaster);			//삭제
			if (insertDetail4 != null) this.insertDetail4(insertDetail4, user, dataMaster);			//추가
			if (updateDetail4 != null) this.updateDetail4(updateDetail4, user, dataMaster);			//수정
		}
		paramList.add(0, paramMaster);
		return paramList;
	}

	/** 추가 **/
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "dev" )
	public Integer insertDetail4( List<Map> paramList, LoginVO user, Map paramMaster ) throws Exception {
		/* 데이터 insert */
		try {
			for (Map param : paramList) {
				super.commonDao.insert("zDevelopPracticeServiceImpl.insertDetail4", param);
			}
		} catch (Exception e) {
			throw new UniDirectValidateException(this.getMessage("8114", user));
		}
		return 0;
	}

	/** 수정 **/
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "dev" )
	public Integer updateDetail4( List<Map> paramList, LoginVO user, Map paramMaster ) throws Exception {
		for (Map param : paramList) {
			super.commonDao.update("zDevelopPracticeServiceImpl.updateDetail4", param);
		}
		return 0;
	}

	/** 삭제 **/
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "dev" )
	public Integer deleteDetail4( List<Map> paramList, LoginVO user, Map paramMaster ) throws Exception {
		for (Map param : paramList) {
			try {
				super.commonDao.delete("zDevelopPracticeServiceImpl.deleteDetail4", param);
			} catch (Exception e) {
				throw new UniDirectValidateException(this.getMessage("547", user));
			}
		}
		return 0;
	}

	/*------------------------------------------------------------------------------------------*/


	/**
	 * practice6 조회 -20210415
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "dev")
	public List<Map<String, Object>> selectList6(Map param) throws Exception {
		return super.commonDao.list("zDevelopPracticeServiceImpl.selectList6", param);
	}

	/** 저장 **/
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_SYNCALL, group = "dev" )
	@Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
	public List<Map> saveAll6( List<Map> paramList, Map paramMaster, LoginVO user ) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>)paramMaster.get("data");

		if (paramList != null) {
			List<Map> insertDetail6 = null;
			List<Map> updateDetail6 = null;
			List<Map> deleteDetail6 = null;

			for (Map dataListMap : paramList) {
				if (dataListMap.get("method").equals("insertDetail6")) {			//추가
					insertDetail6 = (List<Map>)dataListMap.get("data");
				} else if (dataListMap.get("method").equals("updateDetail6")) {		//수정
					updateDetail6 = (List<Map>)dataListMap.get("data");
				} else if (dataListMap.get("method").equals("deleteDetail6")) {		//삭제
					deleteDetail6 = (List<Map>)dataListMap.get("data");
				}
			}
			if (deleteDetail6 != null) this.deleteDetail6(deleteDetail6, user, dataMaster);			//삭제
			if (insertDetail6 != null) this.insertDetail6(insertDetail6, user, dataMaster);			//추가
			if (updateDetail6 != null) this.updateDetail6(updateDetail6, user, dataMaster);			//수정
		}
		paramList.add(0, paramMaster);
		return paramList;
	}

	/** 추가 **/
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "dev" )
	public Integer insertDetail6( List<Map> paramList, LoginVO user, Map paramMaster ) throws Exception {
		/* 데이터 insert */
		try {
			for (Map param : paramList) {
				super.commonDao.insert("zDevelopPracticeServiceImpl.insertDetail6", param);
			}
		} catch (Exception e) {
			throw new UniDirectValidateException(this.getMessage("8114", user));
		}
		return 0;
	}

	/** 수정 **/
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "dev" )
	public Integer updateDetail6( List<Map> paramList, LoginVO user, Map paramMaster ) throws Exception {
		for (Map param : paramList) {
			super.commonDao.update("zDevelopPracticeServiceImpl.updateDetail6", param);
		}
		return 0;
	}

	/** 삭제 **/
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "dev" )
	public Integer deleteDetail6( List<Map> paramList, LoginVO user, Map paramMaster ) throws Exception {
		for (Map param : paramList) {
			try {
				super.commonDao.delete("zDevelopPracticeServiceImpl.deleteDetail6", param);
			} catch (Exception e) {
				throw new UniDirectValidateException(this.getMessage("547", user));
			}
		}
		return 0;
	}
	
	/*------------------------------------------------------------------------------------------*/
	
	/**
	 * practice5 조회(검색 윈도우) -20210419
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "dev")
	public List<Map<String, Object>> selectWhCodeList5(Map param) throws Exception {
		return super.commonDao.list("zDevelopPracticeServiceImpl.selectWhCodeList5", param);
	}

	/**
	 * Master data 조회																	- ExtDirectMethodType.FORM_LOAD로 설정하여 조회한 데이터를 생성해놓은 MODEL을 통해 자동으로 넣는다.
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_LOAD, group = "dev")
	public Object selectMaster5(Map param, LoginVO user) throws Exception {
		return super.commonDao.select("zDevelopPracticeServiceImpl.selectMaster5", param);
	}

	/**
	 * practice5 조회(detailGrid) -20210419
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "dev")
	public List<Map<String, Object>> selectList5(Map param) throws Exception {
		return super.commonDao.list("zDevelopPracticeServiceImpl.selectList5", param);
	}
	
	
	/**
	 * practice5 저장(panelResult)															- ExtDirectMethodType.FORM_LOAD로 설정하여 practice2Model통해 저장할 데이터를 가져와 저장.
	 * @param dataMaster
	 * @param user
	 * @param result
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_POST, group = "dev")
	public ExtDirectFormPostResult saveMaster5(practice2Model dataMaster, LoginVO user, BindingResult result) throws Exception {
		dataMaster.setS_COMP_CODE(user.getCompCode());									//model에 누락된 데이터는 저장하기 전에 수동으로 설정
		dataMaster.setS_USER_ID(user.getUserID());										//model에 누락된 데이터는 저장하기 전에 수동으로 설정
		super.commonDao.insert("zDevelopPracticeServiceImpl.saveMaster5", dataMaster);
		ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);

		return extResult;
	}
	
	
	/**
	 * practice5 저장(masterGrid)
	 * @param paramList
	 * @param paramMaster
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_SYNCALL, group = "dev" )
	@Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
	public List<Map> saveAll5( List<Map> paramList, Map paramMaster, LoginVO user ) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>)paramMaster.get("data");

		if (paramList != null) {
			List<Map> insertDetail5 = null;
			List<Map> updateDetail5 = null;
			List<Map> deleteDetail5 = null;

			for (Map dataListMap : paramList) {
				if (dataListMap.get("method").equals("insertDetail5")) {			//추가
					insertDetail5 = (List<Map>)dataListMap.get("data");
				} else if (dataListMap.get("method").equals("updateDetail5")) {		//수정
					updateDetail5 = (List<Map>)dataListMap.get("data");
				} else if (dataListMap.get("method").equals("deleteDetail5")) {		//삭제
					deleteDetail5 = (List<Map>)dataListMap.get("data");
				}
			}
			if (deleteDetail5 != null) this.deleteDetail5(deleteDetail5, user, dataMaster);			//삭제
			if (insertDetail5 != null) this.insertDetail5(insertDetail5, user, dataMaster);			//추가
			if (updateDetail5 != null) this.updateDetail5(updateDetail5, user, dataMaster);			//수정
		}
		paramList.add(0, paramMaster);
		return paramList;
	}
	
	
	/** 추가 **/
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "dev" )
	public Integer insertDetail5( List<Map> paramList, LoginVO user, Map paramMaster ) throws Exception {
		/* 데이터 insert */
		try {
			for (Map param : paramList) {
				super.commonDao.insert("zDevelopPracticeServiceImpl.insertDetail5", param);
			}
		} catch (Exception e) {
			throw new UniDirectValidateException(this.getMessage("8114", user));
		}
		return 0;
	}

	/** 수정 **/
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "dev" )
	public Integer updateDetail5( List<Map> paramList, LoginVO user, Map paramMaster ) throws Exception {
		for (Map param : paramList) {
			super.commonDao.update("zDevelopPracticeServiceImpl.updateDetail5", param);
		}
		return 0;
	}

	/** 삭제 **/
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "dev" )
	public Integer deleteDetail5( List<Map> paramList, LoginVO user, Map paramMaster ) throws Exception {
		for (Map param : paramList) {
			try {
				super.commonDao.delete("zDevelopPracticeServiceImpl.deleteDetail5", param);
			} catch (Exception e) {
				throw new UniDirectValidateException(this.getMessage("547", user));
			}
		}
		return 0;
	}
	
	
	/**
	 * 전체삭제 -practice5
	 * @param paramList
	 * @param user
	 * @param paramMaster
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "dev" )
	public Integer deleteAll5( Map param, LoginVO user ) throws Exception {
		/* 데이터 insert */
		try {
			super.commonDao.insert("zDevelopPracticeServiceImpl.deleteAll5", param);
		} catch (Exception e) {
			throw new UniDirectValidateException("전체삭제 중 오류가 발생했습니다.");
		}
		return 0;
	}
	
	
	/*-------------------------------------------------------------------------------------------------------------------------------*/
	/**
	 * 매입단가 조회 --20210422
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "dev")
	public List<Map<String, Object>> selectList7(Map param) throws Exception {
		return super.commonDao.list("zDevelopPracticeServiceImpl.selectList7", param);
	}
	
	
	/** 매입단가 저장 --20210423**/
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_SYNCALL, group = "dev" )
	@Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
	public List<Map> saveAll7( List<Map> paramList, Map paramMaster, LoginVO user ) throws Exception {

		if (paramList != null) {
			List<Map> insertList7 = null;
			List<Map> updateList7 = null;
			List<Map> deleteList7 = null;

			for (Map dataListMap : paramList) {
				if (dataListMap.get("method").equals("insertList7")) {			//추가
					insertList7 = (List<Map>)dataListMap.get("data");
					
				} else if (dataListMap.get("method").equals("updateList7")) {		//수정
					updateList7 = (List<Map>)dataListMap.get("data");
					
				} else if (dataListMap.get("method").equals("deleteList7")) {		//삭제
					deleteList7 = (List<Map>)dataListMap.get("data");
				}
			}
			if (deleteList7 != null) this.deleteList7(deleteList7, user);				//삭제
			if (insertList7 != null) this.insertList7(insertList7, user);					//추가
			if (updateList7 != null) this.updateList7(updateList7, user);			//수정
		}
		paramList.add(0, paramMaster);
		return paramList;
	}
	
	/**
	 * 매입단가 등록 --20210423
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "dev")
	public Integer insertList7(List<Map> paramList,  LoginVO user) throws Exception {
		try {
			for (Map param : paramList) {
				super.commonDao.insert("zDevelopPracticeServiceImpl.insertList7", param);
			}
		} catch (Exception e) {
			throw new UniDirectValidateException(this.getMessage("8114", user));
		}
		return 0;
	}
	
	/** 매입단가 수정 --20210423**/
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "dev" )
	public Integer updateList7( List<Map> paramList, LoginVO user) throws Exception {
		for (Map param : paramList) {
			super.commonDao.update("zDevelopPracticeServiceImpl.updateList7", param);
		}
		return 0;
	}
	
	
	
	
	/** 매입단가 삭제 --20210423 **/
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "dev" )
	public Integer deleteList7( List<Map> paramList, LoginVO user) throws Exception {
		for (Map param : paramList) {
			try {
				super.commonDao.delete("zDevelopPracticeServiceImpl.deleteList7", param);
			} catch (Exception e) {
				throw new UniDirectValidateException(this.getMessage("547", user));
			}
		}
		return 0;
	}
	
	
}