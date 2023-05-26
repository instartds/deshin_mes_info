package foren.unilite.modules.z_yp;

import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.model.LoginVO;
import foren.framework.utils.ConfigUtil;
import foren.framework.utils.FileUtil;
import foren.framework.utils.ObjUtils;
import foren.framework.web.view.FileDownloadInfo;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.utils.UniliteUtil;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.com.fileman.FileMnagerService;
import foren.unilite.modules.z_kocis.S_Ass900ukrModel_KOCIS;
import foren.unilite.utils.ExtFileUtils;



@Service( "s_bcm100ukrv_ypService" )
@SuppressWarnings( { "unchecked", "rawtypes" } )
public class S_bcm100ukrv_ypServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@Resource( name = "fileMnagerService" )
	private FileMnagerService fileMnagerService;
	public final static String FILE_TYPE_OF_PHOTO = "z_yp";
	public final static String FILE_TYPE_OF_PHOTO2 = "z_yp/farmHouse";
	
	
	
	/**
	 * 거래처 조회
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_READ, group = "bcm" )
	public List<Map<String, Object>> selectList( Map param ) throws Exception {
		if (param.get("COMPANY_NUM") != null) param.put("COMPANY_NUM", ObjUtils.getSafeString(param.get("COMPANY_NUM")).replaceAll("\\-", ""));
		return super.commonDao.list("s_bcm100ukrv_ypServiceImpl.getDataList", param);
	}
	
	/**
	 * 거래처코드 중복 체크
	 * 
	 * @param param
	 * @return
	 */
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_READ, group = "bcm" )
	public Object chkPK( Map param ) {
		return super.commonDao.select("s_bcm100ukrv_ypServiceImpl.insertQuery06", param);
	}
	
	/**
	 * 채널코드 중복 체크
	 * 
	 * @param param
	 * @return
	 */
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_READ, group = "bcm" )
	public Object checkCh( Map param ) {
		return super.commonDao.select("s_bcm100ukrv_ypServiceImpl.checkCh", param);
	}
	
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_SYNCALL, group = "bcm" )
	public List<Map> saveAll( List<Map> paramList, Map paramMaster, LoginVO user ) throws Exception {
		if (paramList != null) {
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for (Map dataListMap : paramList) {
				if (dataListMap.get("method").equals("deleteDetail")) {
					deleteList = (List<Map>)dataListMap.get("data");
				} else if (dataListMap.get("method").equals("insertDetail")) {
					insertList = (List<Map>)dataListMap.get("data");
				} else if (dataListMap.get("method").equals("updateDetail")) {
					updateList = (List<Map>)dataListMap.get("data");
				}
			}
			if (deleteList != null) this.deleteDetail(deleteList, user);
			if (insertList != null) this.insertDetail(insertList, user);
			if (updateList != null) this.updateDetail(updateList, user);
		}
		paramList.add(0, paramMaster);
		
		return paramList;
	}
	
	/**
	 * 거래처 입력
	 * 
	 * @param paramList
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "bcm" )
	public List<Map> insertDetail( List<Map> paramList, LoginVO user ) throws Exception {
		
		int r = 0;
		
		String sDemo = "N";
		boolean license = UniliteUtil.IsExceedUser("C");
		if (license) sDemo = "Y";
		
		//공통코드(B107:타법인 복사여부)에 따라 법인정보 조회
		try {
			Map<String, Object> uMap = new HashMap<String, Object>();
			uMap.put("S_COMP_CODE", user.getCompCode());
			List<Map<String, Object>> rsInfoList = (List<Map<String, Object>>)super.commonDao.list("s_bcm100ukrv_ypServiceImpl.insertQuery01", uMap);
			
			for (Map param : paramList) {
				
				String sOrgCompCode = param.get("COMP_CODE").toString();
				
				for (Map rsInfo : rsInfoList) {
					Map compCodeMap = new HashMap();
					compCodeMap.put("S_COMP_CODE", user.getCompCode());
					compCodeMap.put("AGENT_TYPE", param.get("AGENT_TYPE"));
					if (ObjUtils.isEmpty(param.get("CUSTOM_CODE")) || (!ObjUtils.isEmpty(param.get("CUSTOM_CODE")) && param.get("CUSTOM_CODE").equals("자동채번"))) {
						List<Map> customCode = (List<Map>)super.commonDao.list("s_bcm100ukrv_ypServiceImpl.getAutoCustomCode", compCodeMap);
						param.put("CUSTOM_CODE", customCode.get(0).get("CUSTOM_CODE"));
					}
					
					param.put("START_DATE"	, UniliteUtil.chgDateFormat(param.get("START_DATE")));
					param.put("STOP_DATE"	, UniliteUtil.chgDateFormat(param.get("STOP_DATE")));
					param.put("CREDIT_YMD"	, UniliteUtil.chgDateFormat(param.get("CREDIT_YMD")));
					if (param.get("TOP_NUM") != null) param.put("TOP_NUM", param.get("TOP_NUM").toString().replace("-", ""));
					if (param.get("COMPANY_NUM") != null) param.put("COMPANY_NUM", param.get("COMPANY_NUM").toString().replace("-", ""));
					
					if (param.get("ZIP_CODE") != null) {
						param.put("ZIP_CODE", param.get("ZIP_CODE").toString().replace("-", ""));
					}
					
					if ("1".equals(param.get("CUSTOM_TYPE")) || "2".equals(param.get("CUSTOM_TYPE"))) {
						if (ObjUtils.isEmpty(param.get("CHANNEL"))) {
							String newCh = (String) super.commonDao.select("s_bcm100ukrv_ypServiceImpl.createCH", compCodeMap);
							param.put("CHANNEL", newCh);	
						}
					}
					
					r = super.commonDao.update("s_bcm100ukrv_ypServiceImpl.insertMulti", param);
					if ("Y".equals(sDemo)) {
						if (!license) {
							Map<String, Object> customCnt = (Map<String, Object>)super.commonDao.select("s_bcm100ukrv_ypServiceImpl.insertQuery01", param);
							if (Integer.parseInt(customCnt.get("CNT").toString()) > 100) {
								throw new UniDirectValidateException(this.getMessage("52104", user));
							}
						}
					}
					
				}
				//			param.put("COMP_CODE", sOrgCompCode);
				//			param.put("CUSTOM_NAME1", param.get("CUSTOM_NAME") + "-CHANGE ON SERVER");
				
			}
		} catch (Exception e) {
			logger.debug(e.toString());
			throw new UniDirectValidateException(this.getMessage("2627", user));
		}
		
		return paramList;
	}
	
	/**
	 * 거래처 수정
	 * 
	 * @param paramList
	 * @param loginVO
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "bcm" )
	public List<Map> updateDetail( List<Map> paramList, LoginVO user ) throws Exception {
		int r = 0;
		
		String sDemo = "N";
		boolean license = UniliteUtil.IsExceedUser("C");
		if (license) sDemo = "Y";
		try {
			//공통코드(B107:타법인 복사여부)에 따라 법인정보 조회
			Map<String, Object> uMap = new HashMap<String, Object>();
			uMap.put("S_COMP_CODE", user.getCompCode());
			List<Map<String, Object>> rsInfoList = (List<Map<String, Object>>)super.commonDao.list("s_bcm100ukrv_ypServiceImpl.insertQuery01", uMap);
			
			for (Map param : paramList) {
				
				String sOrgCompCode = param.get("COMP_CODE").toString();
				
				for (Map rsInfo : rsInfoList) {
					param.put("START_DATE", UniliteUtil.chgDateFormat(param.get("START_DATE")));
					param.put("STOP_DATE", UniliteUtil.chgDateFormat(param.get("STOP_DATE")));
					param.put("CREDIT_YMD", UniliteUtil.chgDateFormat(param.get("CREDIT_YMD")));
					if (param.get("TOP_NUM") != null) param.put("TOP_NUM", param.get("TOP_NUM").toString().replace("-", ""));
					if (param.get("COMPANY_NUM") != null) param.put("COMPANY_NUM", param.get("COMPANY_NUM").toString().replace("-", ""));
					
					if (!sOrgCompCode.equals(rsInfo.get("COMP_CODE"))) {
						param.put("COMP_CODE", rsInfo.get("COMP_CODE"));
					}
					if (param.get("ZIP_CODE") != null) {
						param.put("ZIP_CODE", param.get("ZIP_CODE").toString().replace("-", ""));
					}
					
					if ("1".equals(param.get("CUSTOM_TYPE")) || "2".equals(param.get("CUSTOM_TYPE"))) {
						if (ObjUtils.isEmpty(param.get("CHANNEL"))) {
							String newCh = (String) super.commonDao.select("s_bcm100ukrv_ypServiceImpl.createCH", uMap);
							param.put("CHANNEL", newCh);	
						}
					}
					if (!"1".equals(param.get("CUSTOM_TYPE")) && !"2".equals(param.get("CUSTOM_TYPE"))) {
						if (ObjUtils.isNotEmpty(param.get("CHANNEL"))) {
							param.put("CHANNEL", "");	
						}
					}
					
					r = super.commonDao.update("s_bcm100ukrv_ypServiceImpl.updateMulti", param);
					
					if ("Y".equals(sDemo)) {
						if (!license) {
							Map<String, Object> customCnt = (Map<String, Object>)super.commonDao.select("s_bcm100ukrv_ypServiceImpl.insertQuery01", param);
							if (Integer.parseInt(customCnt.get("CNT").toString()) > 100) {
								// FIXME Message 처리 52104
								throw new UniDirectValidateException(this.getMessage("52104", user));
							}
						}
					}
					param.put("COMP_CODE", sOrgCompCode);
				}
				
			}
		} catch (Exception e) {
			logger.debug(e.getMessage());
			throw new UniDirectValidateException(this.getMessage("0", user));
		}
		return paramList;
	}
	
	/**
	 * 거래처 삭제
	 * 
	 * @param paramList
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "bcm" )
	public List<Map> deleteDetail( List<Map> paramList, LoginVO user ) throws Exception {
		int r = 0;
		
		String sDemo = "N";
		boolean license = UniliteUtil.IsExceedUser("C");
		if (license) sDemo = "Y";
		
		//공통코드(B107:타법인 복사여부)에 따라 법인정보 조회
		Map<String, Object> uMap = new HashMap<String, Object>();
		uMap.put("S_COMP_CODE", user.getCompCode());
		List<Map<String, Object>> rsInfoList = (List<Map<String, Object>>)super.commonDao.list("s_bcm100ukrv_ypServiceImpl.insertQuery01", uMap);
		for (Map param : paramList) {
			String sOrgCompCode = param.get("COMP_CODE").toString();
			
			for (Map rsInfo : rsInfoList) {
				try {
					param.put("COMP_CODE", rsInfo.get("COMP_CODE"));
					
					// 회계데이타가 남아 있는 경우 삭제 불가
					Map<String, Object> rsSheet = (Map<String, Object>)super.commonDao.select("s_bcm100ukrv_ypServiceImpl.deleteQuery02", param);
					
					if (Integer.parseInt(rsSheet.get("CNT").toString()) > 0) {
						// FIXME Message 처리 547 "Custom Code : " + param.get("CUSTOM_CODE").toString();
						throw new UniDirectValidateException(this.getMessage("547", user));
					} else {
						r = super.commonDao.delete("s_bcm100ukrv_ypServiceImpl.deleteMulti", param);
						super.commonDao.delete("s_bcm100ukrv_ypServiceImpl.deleteBCM120", param);
					}
					param.put("COMP_CODE", sOrgCompCode);
				} catch (Exception e) {
					throw new UniDirectValidateException(this.getMessage("547", "Custom Code : " + param.get("CUSTOM_CODE")));
				}
			}
			
		}
		
		return paramList;
	}
	
	@ExtDirectMethod( group = "bcm" )
	public Integer syncAll( Map param ) throws Exception {
		logger.debug("syncAll:" + param);
		return 0;
	}
	
	/**
	 * 거래처 전자문서정보 조회
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_READ, group = "bcm" )
	public List<Map<String, Object>> getBCM120List( Map param ) throws Exception {
		return super.commonDao.list("s_bcm100ukrv_ypServiceImpl.getBCM120List", param);
	}
	
	/**
	 * 거래처 전자문서정보 입력
	 * 
	 * @param paramList
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "bcm" )
	public List<Map> insertBCM120( List<Map> paramList ) throws Exception {
		int r = 0;
		//공통코드(B107:타법인 복사여부)에 따라 법인정보 조회
		for (Map param : paramList) {
			r = super.commonDao.update("s_bcm100ukrv_ypServiceImpl.insertBCM120", param);
		}
		return paramList;
	}
	
	/**
	 * 거래처 전자문서정보 수정
	 * 
	 * @param paramList
	 * @param loginVO
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "bcm" )
	public List<Map> updateBCM120( List<Map> paramList, LoginVO loginVO ) throws Exception {
		int r = 0;
		for (Map param : paramList) {
			r = super.commonDao.update("s_bcm100ukrv_ypServiceImpl.updateBCM120", param);
		}
		return paramList;
	}
	
	/**
	 * 거래처 전자문서정보 삭제
	 * 
	 * @param paramList
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "bcm" )
	public List<Map> deleteBCM120( List<Map> paramList ) throws Exception {
		int r = 0;
		for (Map param : paramList) {
			r = super.commonDao.delete("s_bcm100ukrv_ypServiceImpl.deleteBCM120", param);
		}
		return paramList;
	}
	
	/**
	 * 거래처 빠른등록
	 * 
	 * @param paramList
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "bcm" )
	public List<Map> insertSimple( List<Map> paramList, LoginVO user ) throws Exception {
		try {
			for (Map param : paramList) {
				Map compCodeMap = new HashMap();
				compCodeMap.put("S_COMP_CODE", user.getCompCode());
				if (ObjUtils.isEmpty(param.get("CUSTOM_CODE"))) {
					List<Map> customCode = (List<Map>)super.commonDao.list("s_bcm100ukrv_ypServiceImpl.getAutoCustomCode", compCodeMap);
					param.put("CUSTOM_CODE", customCode.get(0).get("CUSTOM_CODE"));
				}
				
				//			Map result = (Map)super.commonDao.queryForObject("s_bcm100ukrv_ypServiceImpl.insertSimple", param);
				//			param.put("CUSTOM_CODE", result.get("CUSTOM_CODE"));
				Map result = (Map)super.commonDao.queryForObject("s_bcm100ukrv_ypServiceImpl.insertSimple2", param);
			}
		} catch (Exception e) {
			throw new UniDirectValidateException(this.getMessage("2627", user));
		}
		return paramList;
	}
	
	
	
	/* 계좌정보 */
	/** 조회 **/
	@ExtDirectMethod( group = "z_yp", value = ExtDirectMethodType.STORE_READ )
	public List<Map<String, Object>> getBankBookInfo( Map param ) throws Exception {
		return super.commonDao.list("s_bcm100ukrv_ypServiceImpl.getBankBookInfo", param);
	}
	
	/** 저장 **/
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_SYNCALL, group = "z_yp" )
	@Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
	public List<Map> saveAll2( List<Map> paramList, Map paramMaster, LoginVO user ) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>)paramMaster.get("data");
		
		if (paramList != null) {
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			
			for (Map dataListMap : paramList) {
				if (dataListMap.get("method").equals("insertList")) {
					insertList = (List<Map>)dataListMap.get("data");
				} else if (dataListMap.get("method").equals("updateList")) {
					updateList = (List<Map>)dataListMap.get("data");
				} else if (dataListMap.get("method").equals("deleteList")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}
			}
			if (deleteList != null) this.deleteList(deleteList, user, dataMaster);
			if (insertList != null) this.insertList(insertList, user, dataMaster);
			if (updateList != null) this.updateList(updateList, user, dataMaster);
		}
		paramList.add(0, paramMaster);
		
		return paramList;
	}
	
	/** 추가 **/
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "z_yp" )
	public Integer insertList( List<Map> paramList, LoginVO user, Map paramMaster ) throws Exception {
		/* 데이터 insert */
		try {
			for (Map param : paramList) {
				super.commonDao.insert("s_bcm100ukrv_ypServiceImpl.setBankBookInfo", param);
			}
		} catch (Exception e) {
			throw new UniDirectValidateException(this.getMessage("8114", user));
		}
		
		return 0;
	}
	
	/** 수정 **/
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "z_yp" )
	public Integer updateList( List<Map> paramList, LoginVO user, Map paramMaster ) throws Exception {
		for (Map param : paramList) {
			super.commonDao.update("s_bcm100ukrv_ypServiceImpl.updateBankBookInfo", param);
		}
		return 0;
	}
	
	/** 삭제 **/
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "z_yp" )
	public Integer deleteList( List<Map> paramList, LoginVO user, Map paramMaster ) throws Exception {
		for (Map param : paramList) {
			try {
				super.commonDao.delete("s_bcm100ukrv_ypServiceImpl.deleteBankBookInfo", param);
				
			} catch (Exception e) {
				throw new UniDirectValidateException(this.getMessage("547", user));
			}
		}
		return 0;
	}
	
	
	
	/* 전자문서정보 */
	/** 조회 **/
	@ExtDirectMethod( group = "z_yp", value = ExtDirectMethodType.STORE_READ )
	public List<Map<String, Object>> getSubInfo3( Map param ) throws Exception {
		return super.commonDao.list("s_bcm100ukrv_ypServiceImpl.getSubInfo3", param);
	}
	
	/** 저장 **/
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_SYNCALL, group = "z_yp" )
	@Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
	public List<Map> saveAll3( List<Map> paramList, Map paramMaster, LoginVO user ) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>)paramMaster.get("data");
		
		if (paramList != null) {
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			
			for (Map dataListMap : paramList) {
				if (dataListMap.get("method").equals("insertList3")) {
					insertList = (List<Map>)dataListMap.get("data");
				} else if (dataListMap.get("method").equals("updateList3")) {
					updateList = (List<Map>)dataListMap.get("data");
				} else if (dataListMap.get("method").equals("deleteList3")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}
			}
			if (deleteList != null) this.deleteList3(deleteList, user, dataMaster);
			if (insertList != null) this.insertList3(insertList, user, dataMaster);
			if (updateList != null) this.updateList3(updateList, user, dataMaster);
		}
		paramList.add(0, paramMaster);
		
		return paramList;
	}
	
	/** 추가 **/
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "z_yp" )
	public Integer insertList3( List<Map> paramList, LoginVO user, Map paramMaster ) throws Exception {
		/* 데이터 insert */
		try {
			for (Map param : paramList) {
				super.commonDao.insert("s_bcm100ukrv_ypServiceImpl.insertList3", param);
			}
		} catch (Exception e) {
			throw new UniDirectValidateException(this.getMessage("8114", user));
		}
		
		return 0;
	}
	
	/** 수정 **/
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "z_yp" )
	public Integer updateList3( List<Map> paramList, LoginVO user, Map paramMaster ) throws Exception {
		for (Map param : paramList) {
			super.commonDao.update("s_bcm100ukrv_ypServiceImpl.updateList3", param);
		}
		return 0;
	}
	
	/** 삭제 **/
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "z_yp" )
	public Integer deleteList3( List<Map> paramList, LoginVO user, Map paramMaster ) throws Exception {
		for (Map param : paramList) {
			try {
				super.commonDao.delete("s_bcm100ukrv_ypServiceImpl.deleteList3", param);
				
			} catch (Exception e) {
				throw new UniDirectValidateException(this.getMessage("547", user));
			}
		}
		return 0;
	}


	
	
	
	
	
	/* 인증서정보 */
	
	/** 조회 **/
	@ExtDirectMethod( group = "z_yp", value = ExtDirectMethodType.STORE_READ )
	public List<Map<String, Object>> getCertInfo( Map param ) throws Exception {
		return super.commonDao.list("s_bcm100ukrv_ypServiceImpl.getCertInfo", param);
	}
	
	/** 저장 **/
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_SYNCALL, group = "z_yp" )
	@Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
	public List<Map> saveAll4( List<Map> paramList, Map paramMaster, LoginVO user ) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>)paramMaster.get("data");
		
		if (paramList != null) {
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			
			for (Map dataListMap : paramList) {
				if (dataListMap.get("method").equals("certInfoInsert")) {
					insertList = (List<Map>)dataListMap.get("data");
				} else if (dataListMap.get("method").equals("certInfoUpdate")) {
					updateList = (List<Map>)dataListMap.get("data");
				} else if (dataListMap.get("method").equals("certInfoDelete")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}
			}
			if (deleteList != null) this.certInfoDelete(deleteList, user, dataMaster);
			if (insertList != null) this.certInfoInsert(insertList, user, dataMaster);
			if (updateList != null) this.certInfoUpdate(updateList, user, dataMaster);
		}
		paramList.add(0, paramMaster);
		
		return paramList;
	}
	
	/** 추가 **/
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "z_yp" )
	public Integer certInfoInsert( List<Map> paramList, LoginVO user, Map paramMaster ) throws Exception {
		/* 데이터 insert */
		try {
			for (Map param : paramList) {
				super.commonDao.insert("s_bcm100ukrv_ypServiceImpl.certInfoInsert", param);
			}
		} catch (Exception e) {
			throw new UniDirectValidateException(this.getMessage("8114", user));
		}
		
		return 0;
	}
	
	/** 수정 **/
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "z_yp" )
	public Integer certInfoUpdate( List<Map> paramList, LoginVO user, Map paramMaster ) throws Exception {
		for (Map param : paramList) {
			super.commonDao.update("s_bcm100ukrv_ypServiceImpl.certInfoUpdate", param);
		}
		return 0;
	}
	
	/** 삭제 **/
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "z_yp" )
	public Integer certInfoDelete( List<Map> paramList, LoginVO user, Map paramMaster ) throws Exception {
		for (Map param : paramList) {
			try {
				super.commonDao.delete("s_bcm100ukrv_ypServiceImpl.certInfoDelete", param);
                ExtFileUtils.delFile(param.get("FILE_PATH") + "/" + param.get("FILE_ID") + '.' + param.get("FILE_EXT"));
				
			} catch (Exception e) {
				throw new UniDirectValidateException(this.getMessage("547", user));
			}
		}
		return 0;
	}
	
	
    /**
     * 농가이력 재배품목1
     * 
     */	
    /** 조회 **/
    @ExtDirectMethod( group = "z_yp", value = ExtDirectMethodType.STORE_READ )
    public List<Map<String, Object>> getGrowthList1( Map param ) throws Exception {
        return super.commonDao.list("s_bcm100ukrv_ypServiceImpl.getGrowthList1", param);
    }
    
    /** 저장 **/
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_SYNCALL, group = "z_yp" )
    @Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
    public List<Map> saveAll5( List<Map> paramList, Map paramMaster, LoginVO user ) throws Exception {
        Map<String, Object> dataMaster = (Map<String, Object>)paramMaster.get("data");
        
        if (paramList != null) {
            List<Map> insertList = null;
            List<Map> updateList = null;
            List<Map> deleteList = null;
            
            for (Map dataListMap : paramList) {
                if (dataListMap.get("method").equals("growthInsertList1")) {
                    insertList = (List<Map>)dataListMap.get("data");
                } else if (dataListMap.get("method").equals("growthUpdateList1")) {
                    updateList = (List<Map>)dataListMap.get("data");
                } else if (dataListMap.get("method").equals("growthDeleteList1")) {
                    deleteList = (List<Map>)dataListMap.get("data");
                }
            }
            if (deleteList != null) this.growthDeleteList1(deleteList, user, dataMaster);
            if (insertList != null) this.growthInsertList1(insertList, user, dataMaster);
            if (updateList != null) this.growthUpdateList1(updateList, user, dataMaster);
        }
        paramList.add(0, paramMaster);
        
        return paramList;
    }
    
    /** 추가 **/
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "z_yp" )
    public Integer growthInsertList1( List<Map> paramList, LoginVO user, Map paramMaster ) throws Exception {
        /* 데이터 insert */
        try {
            for (Map param : paramList) {
                super.commonDao.insert("s_bcm100ukrv_ypServiceImpl.growthInsertList1", param);
            }
        } catch (Exception e) {
            throw new UniDirectValidateException(this.getMessage("8114", user));
        }
        
        return 0;
    }
    
    /** 수정 **/
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "z_yp" )
    public Integer growthUpdateList1( List<Map> paramList, LoginVO user, Map paramMaster ) throws Exception {
        for (Map param : paramList) {
            super.commonDao.update("s_bcm100ukrv_ypServiceImpl.growthUpdateList1", param);
        }
        return 0;
    }
    
    /** 삭제 **/
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "z_yp" )
    public Integer growthDeleteList1( List<Map> paramList, LoginVO user, Map paramMaster ) throws Exception {
        for (Map param : paramList) {
            try {
                super.commonDao.delete("s_bcm100ukrv_ypServiceImpl.growthDeleteList1", param);
                
            } catch (Exception e) {
                throw new UniDirectValidateException(this.getMessage("547", user));
            }
        }
        return 0;
    }
    
    /**
     * 농가이력 재배품목2
     * 
     */ 
    /** 조회 **/
    @ExtDirectMethod( group = "z_yp", value = ExtDirectMethodType.STORE_READ )
    public List<Map<String, Object>> getGrowthList2( Map param ) throws Exception {
        return super.commonDao.list("s_bcm100ukrv_ypServiceImpl.getGrowthList2", param);
    }
    
    /** 저장 **/
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_SYNCALL, group = "z_yp" )
    @Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
    public List<Map> saveAll6( List<Map> paramList, Map paramMaster, LoginVO user ) throws Exception {
        Map<String, Object> dataMaster = (Map<String, Object>)paramMaster.get("data");
        
        if (paramList != null) {
            List<Map> insertList = null;
            List<Map> updateList = null;
            List<Map> deleteList = null;
            
            for (Map dataListMap : paramList) {
                if (dataListMap.get("method").equals("growthInsertList2")) {
                    insertList = (List<Map>)dataListMap.get("data");
                } else if (dataListMap.get("method").equals("growthUpdateList2")) {
                    updateList = (List<Map>)dataListMap.get("data");
                } else if (dataListMap.get("method").equals("growthDeleteList2")) {
                    deleteList = (List<Map>)dataListMap.get("data");
                }
            }
            if (deleteList != null) this.growthDeleteList2(deleteList, user, dataMaster);
            if (insertList != null) this.growthInsertList2(insertList, user, dataMaster);
            if (updateList != null) this.growthUpdateList2(updateList, user, dataMaster);
        }
        paramList.add(0, paramMaster);
        
        return paramList;
    }
    
    /** 추가 **/
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "z_yp" )
    public Integer growthInsertList2( List<Map> paramList, LoginVO user, Map paramMaster ) throws Exception {
        /* 데이터 insert */
        try {
            for (Map param : paramList) {
                super.commonDao.insert("s_bcm100ukrv_ypServiceImpl.growthInsertList2", param);
            }
        } catch (Exception e) {
            throw new UniDirectValidateException(this.getMessage("8114", user));
        }
        
        return 0;
    }
    
    /** 수정 **/
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "z_yp" )
    public Integer growthUpdateList2( List<Map> paramList, LoginVO user, Map paramMaster ) throws Exception {
        for (Map param : paramList) {
            super.commonDao.update("s_bcm100ukrv_ypServiceImpl.growthUpdateList2", param);
        }
        return 0;
    }
    
    /** 삭제 **/
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "z_yp" )
    public Integer growthDeleteList2( List<Map> paramList, LoginVO user, Map paramMaster ) throws Exception {
        for (Map param : paramList) {
            try {
                super.commonDao.delete("s_bcm100ukrv_ypServiceImpl.growthDeleteList2", param);
                
            } catch (Exception e) {
                throw new UniDirectValidateException(this.getMessage("547", user));
            }
        }
        return 0;
    }
    
    /**
     * 교육참석현황
     * 
     */ 
    /** 조회 **/
    @ExtDirectMethod( group = "z_yp", value = ExtDirectMethodType.STORE_READ )
    public List<Map<String, Object>> getEduList( Map param ) throws Exception {
        return super.commonDao.list("s_bcm100ukrv_ypServiceImpl.getEduList", param);
    }
    
    /** 저장 **/
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_SYNCALL, group = "z_yp" )
    @Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
    public List<Map> saveAll7( List<Map> paramList, Map paramMaster, LoginVO user ) throws Exception {
        Map<String, Object> dataMaster = (Map<String, Object>)paramMaster.get("data");
        
        if (paramList != null) {
            List<Map> insertList = null;
            List<Map> updateList = null;
            List<Map> deleteList = null;
            
            for (Map dataListMap : paramList) {
                if (dataListMap.get("method").equals("eduInsertList")) {
                    insertList = (List<Map>)dataListMap.get("data");
                } else if (dataListMap.get("method").equals("eduUpdateList")) {
                    updateList = (List<Map>)dataListMap.get("data");
                } else if (dataListMap.get("method").equals("eduDeleteList")) {
                    deleteList = (List<Map>)dataListMap.get("data");
                }
            }
            if (deleteList != null) this.eduDeleteList(deleteList, user, dataMaster);
            if (insertList != null) this.eduInsertList(insertList, user, dataMaster);
            if (updateList != null) this.eduUpdateList(updateList, user, dataMaster);
        }
        paramList.add(0, paramMaster);
        
        return paramList;
    }
    
    /** 추가 **/
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "z_yp" )
    public Integer eduInsertList( List<Map> paramList, LoginVO user, Map paramMaster ) throws Exception {
        /* 데이터 insert */
        try {
            for (Map param : paramList) {
                super.commonDao.insert("s_bcm100ukrv_ypServiceImpl.eduInsertList", param);
            }
        } catch (Exception e) {
            throw new UniDirectValidateException(this.getMessage("8114", user));
        }
        
        return 0;
    }
    
    /** 수정 **/
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "z_yp" )
    public Integer eduUpdateList( List<Map> paramList, LoginVO user, Map paramMaster ) throws Exception {
        for (Map param : paramList) {
            super.commonDao.update("s_bcm100ukrv_ypServiceImpl.eduUpdateList", param);
        }
        return 0;
    }
    
    /** 삭제 **/
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "z_yp" )
    public Integer eduDeleteList( List<Map> paramList, LoginVO user, Map paramMaster ) throws Exception {
        for (Map param : paramList) {
            try {
                super.commonDao.delete("s_bcm100ukrv_ypServiceImpl.eduDeleteList", param);
            } catch (Exception e) {
                throw new UniDirectValidateException(this.getMessage("547", user));
            }
        }
        return 0;
    }
    
	/**
	 * 거래처등록(양평) -  거래처 인증서 업로드
	 * 
	 * @param file1
	 * @return
	 * @throws IOException
	 */
	@ExtDirectMethod( group = "z_yp", value = ExtDirectMethodType.FORM_POST )
	public ExtDirectFormPostResult photoUploadFile( @RequestParam( "photoFile" ) MultipartFile file, S_bcm100ukrv_ypModel param, LoginVO user ) throws IOException, Exception {

		String keyValue	= getLogKey(); 
		String certNo	= param.getCERT_NO();
		
		if (file != null && !file.isEmpty()) {
			logger.debug("File1 Name : " + file.getName());
			logger.debug("File1 Bytes: " + file.getSize());
			String fileExtension = FileUtil.getExtension(file.getOriginalFilename()).toLowerCase();
			
			//화면단에서 체크하도록 수정
//			if (!"jpg".equals(fileExtension)) {
//				throw new UniDirectValidateException("jpg 파일로 올려주세요.");
//			}
			
			String path = ConfigUtil.getUploadBasePath(FILE_TYPE_OF_PHOTO);
			if (file.getSize() > 0) {
				File tmpFile = new File(path);
				//폴더가 존재하지 않을 경우, 폴더 생성
				if(!tmpFile.exists()) {
					tmpFile.mkdirs();
				}
				tmpFile = new File(path + "/" + keyValue + '.' + fileExtension);
				file.transferTo(tmpFile);
				
				Map<String, Object> spParam = new HashMap<String, Object>();
				spParam.put("S_COMP_CODE"	, user.getCompCode()	);
				spParam.put("S_USER_ID"		, user.getUserID()		);
				spParam.put("CUSTOM_CODE"	, param.getCUSTOM_CODE());
				spParam.put("TYPE"			, param.getTYPE()		);
				spParam.put("CERT_NO"		, certNo				);

				spParam.put("CERT_FILE"		, file.getOriginalFilename());			//ORIGINAL_FILE_NAME  
				spParam.put("FILE_ID"		, keyValue					);			//FID
				spParam.put("MIME_TYPE"		, file.getContentType()		);			//MIME_TYPE
				spParam.put("FILE_EXT"		, fileExtension				);
				spParam.put("FILE_SIZE"		, file.getSize()			);
				spParam.put("FILE_PATH"		, path						);

				logger.debug("CERT_FILE : " + spParam.get("CERT_FILE"));
				logger.debug("CERT_NO 	: " + spParam.get("CERT_NO"));
				super.commonDao.update("s_bcm100ukrv_ypServiceImpl.photoModified", spParam);
			}
			
		} else {
			throw new UniDirectValidateException("등록할 사진을 선택해 주세요");
		}
		ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(true);
		return extResult;
	}
	
	/**
     * 거래처등록(양평) -  농가이력 사진 업로드
     * 
     * @param file1
     * @return
     * @throws IOException
     */
    @ExtDirectMethod( group = "z_yp", value = ExtDirectMethodType.FORM_POST )
    public ExtDirectFormPostResult farmHousePhotoUploadFile( @RequestParam( "photoFile" ) MultipartFile file, S_bcm100ukrv_ypModel param, LoginVO user ) throws IOException, Exception {

        String keyValue = getLogKey(); 
        String certNo   = param.getCERT_NO();
        
        if (file != null) {
            logger.debug("File1 Name : " + file.getName());
            logger.debug("File1 Bytes: " + file.getSize());
            String fileExtension = FileUtil.getExtension(file.getOriginalFilename()).toLowerCase();
            
            //화면단에서 체크하도록 수정
//          if (!"jpg".equals(fileExtension)) {
//              throw new UniDirectValidateException("jpg 파일로 올려주세요.");
//          }
            
            String path = ConfigUtil.getUploadBasePath(FILE_TYPE_OF_PHOTO2);
            if (file.getSize() > 0) {
                File tmpFile = new File(path);
                //폴더가 존재하지 않을 경우, 폴더 생성
                if(!tmpFile.exists()) {
                    tmpFile.mkdirs();
                }
                File pngType = new File(path + "/" + param.getCUSTOM_CODE() + ".png");
                File jpgType = new File(path + "/" + param.getCUSTOM_CODE() + ".jpg");
                File bmpType = new File(path + "/" + param.getCUSTOM_CODE() + ".bmp");
                
                if(pngType.exists()){
                    pngType.delete();
                }else if(jpgType.exists()){
                    jpgType.delete();
                }else if(bmpType.exists()){
                    bmpType.delete();
                }
                tmpFile = new File(path + "/" + param.getCUSTOM_CODE() + '.' + fileExtension);
                file.transferTo(tmpFile);
                
                Map<String, Object> params = new HashMap<String, Object>();
                params.put("CUSTOM_CODE", param.getCUSTOM_CODE());
                params.put("S_COMP_CODE", user.getCompCode());
                params.put("S_USER_ID", user.getUserID());
                
                super.commonDao.update("s_bcm100ukrv_ypServiceImpl.farmHousePhotoModified", params);
            }
            
        } else {
            throw new UniDirectValidateException("등록할 사진을 선택해 주세요");
        }
        ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(true);
        return extResult;
    }
	
	
	/**
	 * 거래처 인증서 다운로드
	 */
	public FileDownloadInfo getFileInfo( LoginVO user, String fid ) throws Exception {
//		String filePath = ConfigUtil.getString("common.upload.temp");
		Map<String, Object> param = new HashMap<String, Object>();
		FileDownloadInfo rv = null;;
		param.put("fid", fid);
		
		Map rec = (Map)super.commonDao.select("s_bcm100ukrv_ypServiceImpl.selectFileInfo", param);
		if (rec != null) {
			//업로드 한 파일 확장자 확인하여 해당 확장자 검색
			String oriFileName	= (String)rec.get("ORIGINAL_FILE_NAME");			//등록된 원래 파일명
			int fileExtension	= oriFileName.lastIndexOf( "." );
			String fileExt		= oriFileName.substring( fileExtension + 1 );		//확장자
			
			rv = new FileDownloadInfo((String)rec.get("PATH"), fid + "." + fileExt);
			rv.setOriginalFileName(oriFileName);
			rv.setContentType((String)rec.get("MIME_TYPE"));
			
			logger.info("FileDownLoad >> {}", user.getUserID() + ", fid : " + fid + ", Filename:" + rec.get("ORIGINAL_FILE_NAME"));
		}
		return rv;
	}
}
