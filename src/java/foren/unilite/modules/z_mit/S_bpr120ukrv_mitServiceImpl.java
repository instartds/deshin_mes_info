package foren.unilite.modules.z_mit;

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
import foren.unilite.modules.com.tree.UniTreeHelper;
import foren.unilite.modules.com.tree.UniTreeNode;



@Service("s_bpr120ukrv_mitService")
public class S_bpr120ukrv_mitServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	/**
	 * 반제품
	 * 
	 * @param param
	 * @param loginVO
	 * @return
	 * @throws Exception
	 */
	@Transactional(readOnly = true)
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_LOAD, group = "z_mit")
	public Object selectItem1(Map param, LoginVO loginVO) throws Exception {		
		return  super.commonDao.select("s_bpr120ukrv_mitServiceImpl.selectItem1", param);
	}
	

	/**
	 * 원부자재
	 * @param param
	 * @param loginVO
	 * @return
	 * @throws Exception
	 */
	@Transactional(readOnly = true)
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_mit")
	public List<Map<String,Object>> selectItem4(Map param, LoginVO loginVO) throws Exception {		
		return (List<Map<String,Object>>) super.commonDao.list("s_bpr120ukrv_mitServiceImpl.selectItem4", param);
	}
	
	
	/**
	 * 저장
	 * @param paramList	리스트의 create, update, destroy 오퍼레이션별 정보
	 * @param paramMaster 폼(마스터 정보)의 기본 정보
	 * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "z_mit")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {

		if(paramList != null)	{				
			List<Map> insertList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("insertBOM")) {		
					insertList = (List<Map>)dataListMap.get("data");
				} 
			}
			Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
			
			if(insertList != null)	this.insertBOM(insertList, user, dataMaster);
			
		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	}
	
	
	
	/**
	 * BOM 생성
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_mit")
	public List<Map>  insertBOM(List<Map> paramList, LoginVO user, Map<String, Object> dataMaster) throws Exception {	
		for(Map param : paramList) {
			if(!"D".equals(param.get("flag")))	{
				super.commonDao.update("s_bpr120ukrv_mitServiceImpl.insertBOM", param);
			} else {
				super.commonDao.update("s_bpr120ukrv_mitServiceImpl.deleteBOM2", param);
			}
			
		}
		return paramList;
	}	
	
	/**
	 * 품목 비고 수정
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( value = ExtDirectMethodType.FORM_POST, group = "z_mit")
	public ExtDirectFormPostResult updateItem(S_bpr120ukrv_mitModel param, LoginVO user,  BindingResult result) throws Exception {		
		param.setS_COMP_CODE(user.getCompCode());
		param.setS_USER_ID(user.getUserID());
		super.commonDao.update("s_bpr120ukrv_mitServiceImpl.updateItem", param);
		ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);
		return extResult;
	}	
	
	/**
	 * Bom 저장확인
	 * @param param
	 * @param loginVO
	 * @return
	 * @throws Exception
	 */
	@Transactional(readOnly = true)
	@ExtDirectMethod( group = "z_mit")
	public Object selectCheckBom(Map param, LoginVO loginVO) throws Exception {		
		return super.commonDao.select("s_bpr120ukrv_mitServiceImpl.selectCheckBom", param);
	}
	/**
	 * Bom 전체 삭제
	 * @param param
	 * @param loginVO
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "z_mit")
	public Map deleteBom(Map param, LoginVO loginVO) throws Exception {		
		super.commonDao.update("s_bpr120ukrv_mitServiceImpl.deleteBOM", param);
		return param;
	}
	
	@ExtDirectMethod( group = "z_mit")
	public Map selectCheckItem(Map param, LoginVO loginVO) throws Exception {		
		return (Map) super.commonDao.select("s_bpr120ukrv_mitServiceImpl.selectCheckItem", param);
	}
	
	@ExtDirectMethod( group = "z_mit")
	public Map insertNewItem(Map param, LoginVO loginVO) throws Exception {		
		
		Map rMap = (Map) super.commonDao.queryForObject("s_bpr120ukrv_mitServiceImpl.insertNewItem", param);
		if(rMap != null && ObjUtils.isNotEmpty(rMap.get("NEW_ITEM_CODE")))	{
			param.put("ITEM_CODE", rMap.get("NEW_ITEM_CODE"));
		} else {
			throw new  UniDirectValidateException("품목코드를 생성 중 오류가 발생했습니다.");
		}
		return param;
	}
	
}
