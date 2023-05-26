package foren.unilite.modules.z_kocis;

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


@Service("s_hpa330ukrService_KOCIS")
@SuppressWarnings({"rawtypes", "unchecked"})
public class S_Hpa330ukrServiceImpl_KOCIS extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	/**
	 * 수당 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hpa")
	public List<Map<String, Object>> selectList1(Map param) throws Exception {
		List<Map<String, Object>> rv = (List)super.commonDao.list("s_hpa330ukrServiceImpl_KOCIS.selectList1", param);
		// 급여계산이 안되어 있음 HBS300T에서 보여준다.
		if (rv != null && rv.size() == 0) {
			rv = (List)super.commonDao.list("s_hpa330ukrServiceImpl_KOCIS.selectList1_1", param);
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
		List<Map<String, Object>> rv = (List)super.commonDao.list("s_hpa330ukrServiceImpl_KOCIS.selectList2", param);
		// 급여계산이 안되어 있음 HBS300T에서 보여준다.
		if (rv != null && rv.size() == 0) {
			rv = (List)super.commonDao.list("s_hpa330ukrServiceImpl_KOCIS.selectList2_1", param);
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
		Object rv = super.commonDao.select("s_hpa330ukrServiceImpl_KOCIS.selectList3", param);
		if (rv == null) {
			rv = super.commonDao.select("s_hpa330ukrServiceImpl_KOCIS.getHumanMaster", param);
		}
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
		return (List) super.commonDao.list("s_hpa330ukrServiceImpl_KOCIS.selectList4", param);
	}
	
	/**
	 * Navi button 사용가능 여부 확인
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> checkAvailableNavi(Map param) throws Exception {
		return (List) super.commonDao.list("s_hpa330ukrServiceImpl_KOCIS.getPrNxPersonNumb", param);
	}
	
	/**
	 * 전달 급여 데이터 조회 - 01. 폼 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> selectList1ForCopy(Map param) throws Exception {
		return (List) super.commonDao.list("s_hpa330ukrServiceImpl_KOCIS.seletList1ForCopy", param);
	}
	
	/**
	 * 전달 급여 데이터 조회 - 01. 폼 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> selectList2ForCopy(Map param) throws Exception {
		return (List) super.commonDao.list("s_hpa330ukrServiceImpl_KOCIS.seletList2ForCopy", param);
	}
	
	/**
	 * 전달 급여 데이터 조회 - 01. 폼 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> selectList3ForCopy(Map param) throws Exception {
		return (List) super.commonDao.list("s_hpa330ukrServiceImpl_KOCIS.seletList3ForCopy", param);
	}

	
	
	
	
	
	
	
	/**
	 * 업데이트가 가능한지 확인 마감, 전표
	 * @param param
	 * @return
	 */
	public String checkUpdateAvailable(Map param) {
		String result = super.commonDao.queryForObject("s_hpa330ukrServiceImpl_KOCIS.checkUpdateAvailable", param).toString();
		return result;
	}

	
	/**
	 * 지급 내역 / 공제내역을 삭제함
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hpa")
	public int deleteList1(Map param, LoginVO user) throws Exception {
		 try {
			super.commonDao.delete("s_hpa330ukrServiceImpl_KOCIS.deleteList1", param);
			 
		 }catch(Exception e)	{
    			throw new  UniDirectValidateException(this.getMessage("547",user));
    	}	
		return 0;
	}
	
	
	/**
	 * 지급 내역 등록
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hpa")
	public Integer insertList1(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {
		/* 데이터 insert */
		try {
			for(Map param : paramList )	{
			    param.put("PAY_YYYYMM", ((String) param.get("PAY_YYYYMM")).replace(".", ""));
				super.commonDao.insert("s_hpa330ukrServiceImpl_KOCIS.insertList1", param);
			}	
			
		}catch(Exception e){
			throw new  UniDirectValidateException(this.getMessage("8114", user));
		}
		
		return 0;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "hpa")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll1(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {

		if(paramList != null)	{
			List<Map> insertList = null;

			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("insertList1")) {
					insertList = (List<Map>)dataListMap.get("data");
				}
			}
			if(insertList != null) this.insertList1(insertList, user, paramMaster);
		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	}
	
	/**
	 * 공제 내역 등록
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hpa")
	public Integer insertList2(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {
		/* 데이터 insert */
		try {
			for(Map param : paramList )	{
                param.put("PAY_YYYYMM", ((String) param.get("PAY_YYYYMM")).replace(".", ""));
				super.commonDao.insert("s_hpa330ukrServiceImpl_KOCIS.insertList2", param);
			}	
			
		}catch(Exception e){
			throw new  UniDirectValidateException(this.getMessage("8114", user));
		}
		
		return 0;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "hpa")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll2(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {

		if(paramList != null)	{
			List<Map> insertList = null;

			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("insertList2")) {
					insertList = (List<Map>)dataListMap.get("data");
				}
			}
			if(insertList != null) this.insertList2(insertList, user, paramMaster);
		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	}

	
	/**
	 * 결과폼1 저장
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_POST, group = "hpa")
	public ExtDirectFormPostResult form01Submit(S_Hpa330ukrModel_KOCIS param, LoginVO user, BindingResult result) throws Exception {
		try {
			param.setS_COMP_CODE(user.getCompCode());
			param.setS_USER_ID(user.getUserID());
			super.commonDao.update("s_hpa330ukrServiceImpl_KOCIS.form01update", param);
			ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);

			return extResult;
		}catch(Exception e)	{
 			throw new  UniDirectValidateException(this.getMessage("547",user));
		}				
	}
	
	/**
	 * 결과폼2 저장
	 * @param param
	 * @return
	 * @throws Exception
	 */
/*	@ExtDirectMethod(value = ExtDirectMethodType.FORM_POST, group = "hpa")
	public ExtDirectFormPostResult form02Submit(S_Hpa330ukrModel_KOCIS param, LoginVO user, BindingResult result) throws Exception {
		param.setS_COMP_CODE(user.getCompCode());
		param.setS_USER_ID(user.getUserID());
		param.setDIV_CODE(user.getDivCode());
		param.setPOST_CODE("03");
		logger.debug(param.getDEPT_CODE());
		logger.debug(param.getDEPT_NAME());
		
		super.commonDao.update("s_hpa330ukrServiceImpl_KOCIS.form02update", param);
		ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);
			
		return extResult;
	}*/	
}
