package foren.unilite.modules.prodt.ppl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.logging.InjectLogger;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;

import org.apache.commons.exec.CommandLine;
import org.apache.commons.exec.DefaultExecutor;
import org.apache.commons.exec.PumpStreamHandler;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;


@Service("ppl310ukrvService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class Ppl310ukrvServiceImpl extends TlabAbstractServiceImpl {
	@InjectLogger
	public static Logger logger;


	
	/**
	 * 품목 CAPA 등록여부 체크
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_READ)
	public Map<String, Object> capaChk(Map param) throws Exception {
		return (Map<String, Object>) super.commonDao.select("ppl310ukrvServiceImpl.capaChk", param);
	}
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")
	public String capaAutoSave(Map param, LoginVO user) throws Exception {
		String rtnV = "";
		try {
			super.commonDao.update("ppl310ukrvServiceImpl.capaAutoSave", param);
			rtnV = "Y";
		}catch(Exception e) {
			throw new UniDirectValidateException("생성 에러");
		}
		
		return rtnV;
	}
	
	
	
	/**
	 * 조회
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return super.commonDao.list("ppl310ukrvServiceImpl.selectList", param);
	}

	/**
	 * 수주정보검색 조회(Detail)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectOrderNumDetailList(Map param) throws Exception {
		return super.commonDao.list("ppl310ukrvServiceImpl.selectOrderNumDetail", param);
	}





	/**
	 * 저장
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "prodt")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		if(paramList != null) {
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("deleteList")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("insertList")) {
					insertList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("updateList")) {
					updateList = (List<Map>)dataListMap.get("data");	
				} 
			}
			if(insertList != null) this.insertList(insertList, user, dataMaster);
			if(deleteList != null) this.deleteList(deleteList, user);
			if(updateList != null) this.updateList(updateList, user);
		}
		paramList.add(0, paramMaster);
		return paramList;
	}


	/**
	 * 입력
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")
	public Integer insertList(List<Map> paramList, LoginVO user, Map dataMaster) throws Exception {
		try {
			int seq = 0;
			for(Map param : paramList) {
				if(ObjUtils.isEmpty(param.get("ORDER_NUM"))) {
					seq = seq + 1;
					param.put("PLAN_DATE"	, dataMaster.get("OPTION_DATE"));
					param.put("PLAN_SEQ"	, seq);
				}
				super.commonDao.update("ppl310ukrvServiceImpl.insertList", param);
			}
		}catch(Exception e){
			throw new UniDirectValidateException(this.getMessage("2627", user));		//중복되는 자료가 입력 되었습니다.
		}
		return 0;
	}	

	/**
	 * 수정
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")
	public Integer updateList(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param : paramList) {
			super.commonDao.update("ppl310ukrvServiceImpl.updateList", param);
		}
		return 0;
	}

	/**
	 * 삭제
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "prodt", needsModificatinAuth = true)
	public Integer deleteList(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param : paramList) {
			try {
				super.commonDao.delete("ppl310ukrvServiceImpl.deleteList", param);
			}catch(Exception e) {
				throw new UniDirectValidateException(this.getMessage("55523",user));//삭제할 수 없습니다.
			}
		}
		return 0;
	}
}