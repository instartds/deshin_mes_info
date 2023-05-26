package foren.unilite.modules.z_jw;

import java.awt.FileDialog;
import java.awt.Frame;
import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.extjs.UniliteExtjsUtils;
import foren.framework.model.LoginVO;
import foren.framework.utils.ConfigUtil;
import foren.framework.utils.ObjUtils;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.base.bdc.Bdc100ukrvService;
import foren.unilite.modules.com.fileman.FileMnagerService;



@Service("s_pmp101ukrv_jwService")
@SuppressWarnings({"rawtypes", "unchecked"})
public class S_pmp101ukrv_jwServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	

	
	/**
	 * 생산정보 Detail 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "z_jw", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectDetailList(Map param) throws Exception {
		if(ObjUtils.parseInt(ObjUtils.getSafeString(param.get("WORK_SHOP_CODE")).substring(2, 4)) > 90) {
			return super.commonDao.list("s_pmp101ukrv_jwServiceImpl.selectPMP200", param);
			
		} else {
			return super.commonDao.list("s_pmp101ukrv_jwServiceImpl.selectDetailList", param);
		}
	}

	/**
	 * PMP200T 조회(detailGird2)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "z_jw", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectPMP100T(Map param) throws Exception {
		return super.commonDao.list("s_pmp101ukrv_jwServiceImpl.selectPMP100T", param);
	}
	
	/**
	 * 작업지시 조회 (팝업창)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "z_jw", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectWorkNum(Map param) throws Exception {
		return super.commonDao.list("s_pmp101ukrv_jwServiceImpl.selectWorkNum", param);
	}
	

	@ExtDirectMethod(group = "z_jw", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> printList(Map param) throws Exception {
		return super.commonDao.list("s_pmp101ukrv_jwServiceImpl.printList", param);
	}

	@ExtDirectMethod(group = "z_jw", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> subPrintList(Map param) throws Exception {
		return super.commonDao.list("s_pmp101ukrv_jwServiceImpl.subPrintList", param);
	}
	
	
	
	
	
	
	/**
	 * 자재예약 저장시(PMP300T)
	 * @param paramList	리스트의 create, update, destroy 오퍼레이션별 정보
	 * @param paramMaster 폼(마스터 정보)의 기본 정보
	 * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "z_jw")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList,	Map paramMaster, LoginVO user) throws Exception {
		try {
			Map<String, Object> dataMaster	= (Map<String, Object>) paramMaster.get("data");
			Map<String, Object> spParam		= new HashMap<String, Object>();
			Map outstockNumMap	= new HashMap();
			Map topwkordNumMap	= new HashMap();
			Map wkordNumMap		= new HashMap();
			
			//자제예약량 저장로직 (PMP300T)
			if(paramList != null)	{
				List<Map> insertDetail = null;
				List<Map> updateDetail = null;
				List<Map> deleteDetail = null;
				
				for(Map dataListMap: paramList) {
					if(dataListMap.get("method").equals("insertDetail")) {
						insertDetail = (List<Map>)dataListMap.get("data");
					}else if(dataListMap.get("method").equals("deleteDetail")) {
						deleteDetail = (List<Map>)dataListMap.get("data");
					} else if(dataListMap.get("method").equals("updateDetail")) {
						updateDetail = (List<Map>)dataListMap.get("data");
					} 
				}			
				if(insertDetail != null){
					spParam.put("S_COMP_CODE"	, user.getCompCode());
					spParam.put("DIV_CODE"		, dataMaster.get("DIV_CODE"));
					spParam.put("TABLE"			, "PMP300T");
					spParam.put("PREFIX"		, "P");
					spParam.put("TYPE"			, "1");
					outstockNumMap = (Map<String, Object>)super.commonDao.select("s_pmp101ukrv_jwServiceImpl.selectAutoNum",spParam);
					
					spParam.put("TABLE"			, "PMP100T");
					topwkordNumMap = (Map<String, Object>)super.commonDao.select("s_pmp101ukrv_jwServiceImpl.selectAutoNum",spParam);
					this.insertDetail(insertDetail, user, dataMaster, outstockNumMap, topwkordNumMap);
				}
				if(updateDetail != null) this.updateDetail(updateDetail, user, dataMaster);
				if(deleteDetail != null) this.deleteDetail(deleteDetail, user, dataMaster);
			}
			
			//제품 저장로직 (PMP100T, PMP200T)
			if(dataMaster.get("detailArray") != null){
				List<Map<String, Object>> detailArray = (List) dataMaster.get("detailArray");
				if(detailArray != null && detailArray.size() > 0){
					for (int i = 0; i < detailArray.size(); i++) {
						Map<String, Object> map = detailArray.get(i);
						map.put("S_COMP_CODE"	, user.getCompCode());
						map.put("S_USER_ID"		, user.getUserID());
						
						if("N".equals(map.get("SAVE_FLAG"))) {
							if(i==0) {
								map.put("TOP_WKORD_NUM"	, topwkordNumMap.get("AUTO_NUM"));
								map.put("WKORD_NUM"		, topwkordNumMap.get("AUTO_NUM"));
								
							} else {
								spParam.put("S_COMP_CODE"	, user.getCompCode());
								spParam.put("DIV_CODE"		, dataMaster.get("DIV_CODE"));
								spParam.put("TABLE"			, "PMP100T");
								spParam.put("PREFIX"		, "P");
								spParam.put("TYPE"			, "1");
								wkordNumMap = (Map<String, Object>)super.commonDao.select("s_pmp101ukrv_jwServiceImpl.selectAutoNum",spParam);
								
								map.put("TOP_WKORD_NUM"	, topwkordNumMap.get("AUTO_NUM"));
								map.put("WKORD_NUM"		, wkordNumMap.get("AUTO_NUM"));
							}
							
							super.commonDao.insert("s_pmp101ukrv_jwServiceImpl.insertPMP100",map);
							
						} else if("U".equals(map.get("SAVE_FLAG"))) {
							super.commonDao.update("s_pmp101ukrv_jwServiceImpl.updatePMP100", map);
							
						} else {
							super.commonDao.delete("s_pmp101ukrv_jwServiceImpl.deletePMP100", map);
						}
						
						if("Y".equals(map.get("LINE_END_YN"))){
							Map ErrorMap = (Map) super.commonDao.select("s_pmp101ukrv_jwServiceImpl.SP_PRODT_WorkOrders_JW", map);
							if(!";".equals(ErrorMap.get("ERROR_CODE")) && !"".equals(ErrorMap.get("ERROR_CODE"))){
								throw new Exception(ErrorMap.get("ERROR_DESC")+"");
							}
						}
					}
				}
			}
			dataMaster.put("TOP_WKORD_NUM", topwkordNumMap.get("AUTO_NUM"));
			paramList.add(0, paramMaster);
			
		} catch(Exception e) {
//			throw new  UniDirectValidateException("제품정보 저장 중 오류가 발생했습니다.관리자에게 문의하시기 바랍니다.");
			throw new  UniDirectValidateException(this.getMessage("800005",user));
		}
				
		return	paramList;
	}
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_jw")		// INSERT
	public Integer	insertDetail(List<Map> paramList, LoginVO user, Map paramMaster, Map outstockNumMap, Map topwkordNumMap) throws Exception {
		/* 데이터 insert */
		try {
			for(Map param : paramList )	{
				param.put("OUTSTOCK_NUM"	, outstockNumMap.get("AUTO_NUM"));
				param.put("TOP_WKORD_NUM"	, topwkordNumMap.get("AUTO_NUM"));
				if(ObjUtils.parseInt(ObjUtils.getSafeString(param.get("WORK_SHOP_CODE")).substring(2, 4)) < 90) {
					super.commonDao.insert("s_pmp101ukrv_jwServiceImpl.insertDetail", param);
				}
				
				super.commonDao.insert("s_pmp101ukrv_jwServiceImpl.insertPmp200", param);
			}	
		}catch(Exception e){
			throw new  UniDirectValidateException(this.getMessage("8114", user));
		}
		return 0;
	}	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_jw")		// UPDATE
	public Integer updateDetail(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {
		for(Map param :paramList )	{	
			if(ObjUtils.parseInt(ObjUtils.getSafeString(param.get("WORK_SHOP_CODE")).substring(2, 4)) < 90) {
				super.commonDao.update("s_pmp101ukrv_jwServiceImpl.updateDetail", param);
			}
			
			super.commonDao.update("s_pmp101ukrv_jwServiceImpl.updatePmp200", param);
		}
		return 0;
	} 
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_jw")		// DELETE
	public Integer deleteDetail(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {
		for(Map param :paramList )	{
			try {
				if(ObjUtils.parseInt(ObjUtils.getSafeString(param.get("WORK_SHOP_CODE")).substring(2, 4)) < 90) {
					super.commonDao.update("s_pmp101ukrv_jwServiceImpl.deleteDetail", param);
				}
				
				super.commonDao.update("s_pmp101ukrv_jwServiceImpl.deletePmp200", param);
				 
			}catch(Exception e)	{
				throw new  UniDirectValidateException(this.getMessage("547",user));
			}	
		}
		return 0;
	}








	/**
	 * 작업지시 MASTER 저장2 (PMP100T)
	 * @param paramList	리스트의 create, update, destroy 오퍼레이션별 정보
	 * @param paramMaster 폼(마스터 정보)의 기본 정보
	 * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "z_jw")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll2 (List<Map> paramList,	Map paramMaster, LoginVO user) throws Exception {
		Map<String, Object> dataMaster	= (Map<String, Object>) paramMaster.get("data");
		
		//제품 저장로직 (PMP100T, PMP200T)
		if(paramList != null)	{
			List<Map> insertDetail2 = null;
			List<Map> updateDetail2 = null;
			List<Map> deleteDetail2 = null;
			
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("insertDetail2")) {
					insertDetail2 = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("deleteDetail2")) {
					deleteDetail2 = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("updateDetail2")) {
					updateDetail2 = (List<Map>)dataListMap.get("data");
				} 
			}			
			if(insertDetail2 != null) this.insertDetail2(insertDetail2, user, dataMaster);
			if(updateDetail2 != null) this.updateDetail2(updateDetail2, user, dataMaster);
			if(deleteDetail2 != null) this.deleteDetail2(deleteDetail2, user, dataMaster);
		}
		
		paramList.add(0, paramMaster);
				
		return	paramList;
	}
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_jw")		// INSERT
	public Integer	insertDetail2(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {
		/* 데이터 insert */
		try {
			Map<String, Object> spParam		= new HashMap<String, Object>();
			Map wkordNumMap		= new HashMap();

			for(Map param : paramList )	{
				spParam.put("S_COMP_CODE"	, user.getCompCode());
				spParam.put("DIV_CODE"		, paramMaster.get("DIV_CODE"));
				spParam.put("TABLE"			, "PMP100T");
				spParam.put("PREFIX"		, "P");
				spParam.put("TYPE"			, "1");
				wkordNumMap = (Map<String, Object>)super.commonDao.select("s_pmp101ukrv_jwServiceImpl.selectAutoNum",spParam);
				
				param.put("WKORD_NUM"		, wkordNumMap.get("AUTO_NUM"));
				super.commonDao.insert("s_pmp101ukrv_jwServiceImpl.insertPMP100", param);
			}	
		}catch(Exception e){
			throw new  UniDirectValidateException(this.getMessage("8114", user));
		}
		return 0;
	}	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_jw")		// UPDATE
	public Integer updateDetail2(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {
		 for(Map param :paramList )	{	
			super.commonDao.update("s_pmp101ukrv_jwServiceImpl.updatePMP100", param);
		 }
		return 0;
	} 
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_jw")		// DELETE
	public Integer deleteDetail2(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {
		for(Map param :paramList )	{
			 try {
				super.commonDao.delete("s_pmp101ukrv_jwServiceImpl.deletePMP100", param);
				 
			 }catch(Exception e)	{
	    			throw new  UniDirectValidateException(this.getMessage("547",user));
	    	}	
		}
		return 0;
	}

}
