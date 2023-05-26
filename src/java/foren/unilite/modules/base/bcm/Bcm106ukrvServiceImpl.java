package foren.unilite.modules.base.bcm;

import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.model.LoginVO;
import foren.framework.utils.ConfigUtil;
import foren.framework.utils.FileUtil;
import foren.framework.utils.ObjUtils;
import foren.framework.web.view.FileDownloadInfo;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.utils.UniliteUtil;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.base.bpr.Bpr300ukrvModel;
import foren.unilite.utils.ExtFileUtils;

@Service( "bcm106ukrvService" )
public class Bcm106ukrvServiceImpl extends TlabAbstractServiceImpl {
    private final Logger logger = LoggerFactory.getLogger(this.getClass());
	public final static String FILE_TYPE_OF_PHOTO = "base";

    /**
     * 사업자등록번호 중복 체크
     *
     * @param param
     * @return
     */
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_READ, group = "base" )
    public Object checkCompanyNum( Map param ) {
        return super.commonDao.select("bcm106ukrvServiceImpl.checkCompanyNum", param);
    }

    /**
     * 거래처 조회
     *
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_READ, group = "bcm" )
    public List<Map<String, Object>> selectList( Map param ) throws Exception {
        if (param.get("COMPANY_NUM") != null) param.put("COMPANY_NUM", ObjUtils.getSafeString(param.get("COMPANY_NUM")).replaceAll("\\-", ""));
        return super.commonDao.list("bcm106ukrvServiceImpl.getDataList", param);
    }

    /**
     * 거래처코드 중복 체크
     *
     * @param param
     * @return
     */
    @SuppressWarnings( "rawtypes" )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_READ, group = "bcm" )
    public Object chkPK( Map param ) {
        return super.commonDao.select("bcm106ukrvServiceImpl.insertQuery06", param);
    }

    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_SYNCALL, group = "bcm" )
    public List<Map> saveAll( List<Map> paramList, Map paramMaster, LoginVO user ) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
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
            if (insertList != null) this.insertDetail(insertList, dataMaster, user);
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
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "bcm" )
    public List<Map> insertDetail( List<Map> paramList, Map dataMaster, LoginVO user ) throws Exception {

        int r = 0;

        String sDemo = "N";
        boolean license = UniliteUtil.IsExceedUser("C");
        if (license) sDemo = "Y";

        //공통코드(B107:타법인 복사여부)에 따라 법인정보 조회
        try {
            Map<String, Object> uMap = new HashMap<String, Object>();
            uMap.put("S_COMP_CODE", user.getCompCode());
            List<Map<String, Object>> rsInfoList = (List<Map<String, Object>>)super.commonDao.list("bcm106ukrvServiceImpl.insertQuery01", uMap);
            for (Map param : paramList) {

                String sOrgCompCode = param.get("COMP_CODE").toString();
                for (Map rsInfo : rsInfoList) {
                    Map compCodeMap = new HashMap();
                    compCodeMap.put("S_COMP_CODE"	, user.getCompCode());
                    if (ObjUtils.isEmpty(param.get("CUSTOM_CODE"))) {
                    	if (dataMaster.get("CUSTOM_CODE_YN").equals(true) && ObjUtils.isNotEmpty(dataMaster.get("CUSTOM_CODE_SP"))) {
                            compCodeMap.put("SP_NAME"		, dataMaster.get("CUSTOM_CODE_SP"));
                            //20210224 수정: 월드와이드 메모리의 경우, AGENT_TYPE 대신 CUSTOM_TYPE 사용
                            if("USP_GetAutoCustomCode_WM".equals(dataMaster.get("CUSTOM_CODE_SP"))) {
                                compCodeMap.put("AGENT_TYPE"	, param.get("CUSTOM_TYPE"));
                            } else {
                                compCodeMap.put("AGENT_TYPE"	, param.get("AGENT_TYPE"));
                            }
	                        List<Map> customCode = (List<Map>)super.commonDao.list("bcm106ukrvServiceImpl.getAutoCustomCode_forBaseCode", compCodeMap);
	                        param.put("CUSTOM_CODE", customCode.get(0).get("CUSTOM_CODE"));
                    	} else {
	                        List<Map> customCode = (List<Map>)super.commonDao.list("bcm106ukrvServiceImpl.getAutoCustomCode", compCodeMap);
	                        param.put("CUSTOM_CODE", customCode.get(0).get("CUSTOM_CODE"));
                    	}
                    }

                    param.put("START_DATE", UniliteUtil.chgDateFormat(param.get("START_DATE")));
                    param.put("STOP_DATE", UniliteUtil.chgDateFormat(param.get("STOP_DATE")));
                    param.put("CREDIT_YMD", UniliteUtil.chgDateFormat(param.get("CREDIT_YMD")));
                    if (param.get("TOP_NUM") != null) param.put("TOP_NUM", param.get("TOP_NUM").toString().replace("-", ""));
                    if (param.get("COMPANY_NUM") != null) param.put("COMPANY_NUM", param.get("COMPANY_NUM").toString().replace("-", ""));

                    if (param.get("ZIP_CODE") != null) {
                        param.put("ZIP_CODE", param.get("ZIP_CODE").toString().replace("-", ""));
                    }

                    r = super.commonDao.update("bcm106ukrvServiceImpl.insertMulti", param);
                    	super.commonDao.update("bcm106ukrvServiceImpl.insertTradeInfo", param);


                    if ("Y".equals(sDemo)) {
                        if (!license) {
                            Map<String, Object> customCnt = (Map<String, Object>)super.commonDao.select("bcm106ukrvServiceImpl.insertQuery01", param);
                            if (Integer.parseInt(customCnt.get("CNT").toString()) > 100) {
                                throw new UniDirectValidateException(this.getMessage("52104", user));
                            }
                        }
                    }

                }
                //            param.put("COMP_CODE", sOrgCompCode);
                //            param.put("CUSTOM_NAME1", param.get("CUSTOM_NAME") + "-CHANGE ON SERVER");

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
    @SuppressWarnings( { "rawtypes", "unchecked" } )
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
            List<Map<String, Object>> rsInfoList = (List<Map<String, Object>>)super.commonDao.list("bcm106ukrvServiceImpl.insertQuery01", uMap);
            int tradeChk = 0;
            for (Map param : paramList) {

                String sOrgCompCode = param.get("COMP_CODE").toString();
                tradeChk = (int) super.commonDao.select("bcm106ukrvServiceImpl.getTradeInfoChk", param);
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

                    r = super.commonDao.update("bcm106ukrvServiceImpl.updateMulti", param);
                    if(tradeChk > 0){
                    	super.commonDao.update("bcm106ukrvServiceImpl.updateTradeInfo", param);
                    }else{
                    		super.commonDao.update("bcm106ukrvServiceImpl.insertTradeInfo", param);
                    }
                    if ("Y".equals(sDemo)) {
                        if (!license) {
                            Map<String, Object> customCnt = (Map<String, Object>)super.commonDao.select("bcm106ukrvServiceImpl.insertQuery01", param);
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
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "bcm" )
    public List<Map> deleteDetail( List<Map> paramList, LoginVO user ) throws Exception {
        int r = 0;

        String sDemo = "N";
        boolean license = UniliteUtil.IsExceedUser("C");
        if (license) sDemo = "Y";

        //공통코드(B107:타법인 복사여부)에 따라 법인정보 조회
        Map<String, Object> uMap = new HashMap<String, Object>();
        uMap.put("S_COMP_CODE", user.getCompCode());
        List<Map<String, Object>> rsInfoList = (List<Map<String, Object>>)super.commonDao.list("bcm106ukrvServiceImpl.insertQuery01", uMap);
        for (Map param : paramList) {
            String sOrgCompCode = param.get("COMP_CODE").toString();

            for (Map rsInfo : rsInfoList) {
                try {
                    param.put("COMP_CODE", rsInfo.get("COMP_CODE"));

                    // 회계데이타가 남아 있는 경우 삭제 불가
                    Map<String, Object> rsSheet = (Map<String, Object>)super.commonDao.select("bcm106ukrvServiceImpl.deleteQuery02", param);

                    if (Integer.parseInt(rsSheet.get("CNT").toString()) > 0) {
                        // FIXME Message 처리 547 "Custom Code : " + param.get("CUSTOM_CODE").toString();
                        throw new UniDirectValidateException(this.getMessage("547", user));
                    } else {
                        r = super.commonDao.delete("bcm106ukrvServiceImpl.deleteMulti", param);
                        super.commonDao.delete("bcm106ukrvServiceImpl.deleteBCM120", param);
                        super.commonDao.delete("bcm106ukrvServiceImpl.deleteTradeInfo", param);//무역정보삭제
                    }
                    param.put("COMP_CODE", sOrgCompCode);
                } catch (Exception e) {
                    throw new UniDirectValidateException(this.getMessage("547", "Custom Code : " + param.get("CUSTOM_CODE")));
                }
            }

        }

        return paramList;
    }

    @SuppressWarnings( "rawtypes" )
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
    @SuppressWarnings( { "rawtypes" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_READ, group = "bcm" )
    public List<Map<String, Object>> getBCM120List( Map param ) throws Exception {
        return super.commonDao.list("bcm106ukrvServiceImpl.getBCM120List", param);
    }

    /**
     * 거래처 전자문서정보 입력
     *
     * @param paramList
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "bcm" )
    public List<Map> insertBCM120( List<Map> paramList ) throws Exception {
        int r = 0;
        //공통코드(B107:타법인 복사여부)에 따라 법인정보 조회
        for (Map param : paramList) {
            r = super.commonDao.update("bcm106ukrvServiceImpl.insertBCM120", param);
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
    @SuppressWarnings( { "rawtypes" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "bcm" )
    public List<Map> updateBCM120( List<Map> paramList, LoginVO loginVO ) throws Exception {
        int r = 0;
        for (Map param : paramList) {
            r = super.commonDao.update("bcm106ukrvServiceImpl.updateBCM120", param);
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
    @SuppressWarnings( { "rawtypes" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "bcm" )
    public List<Map> deleteBCM120( List<Map> paramList ) throws Exception {
        int r = 0;
        for (Map param : paramList) {
            r = super.commonDao.delete("bcm106ukrvServiceImpl.deleteBCM120", param);
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
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "bcm" )
    public List<Map> insertSimple( List<Map> paramList, LoginVO user ) throws Exception {
        try {
            for (Map param : paramList) {
                Map compCodeMap = new HashMap();
                compCodeMap.put("S_COMP_CODE", user.getCompCode());
                if (ObjUtils.isEmpty(param.get("CUSTOM_CODE"))) {
                    List<Map> customCode = (List<Map>)super.commonDao.list("bcm106ukrvServiceImpl.getAutoCustomCode", compCodeMap);
                    param.put("CUSTOM_CODE", customCode.get(0).get("CUSTOM_CODE"));
                }

                //            Map result = (Map)super.commonDao.queryForObject("bcm106ukrvServiceImpl.insertSimple", param);
                //            param.put("CUSTOM_CODE", result.get("CUSTOM_CODE"));
                Map result = (Map)super.commonDao.queryForObject("bcm106ukrvServiceImpl.insertSimple2", param);
            }
        } catch (Exception e) {
            throw new UniDirectValidateException(this.getMessage("2627", user));
        }
        return paramList;
    }

    /* 계좌정보 */

    /** 조회 **/
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( group = "accnt", value = ExtDirectMethodType.STORE_READ )
    public List<Map<String, Object>> getBankBookInfo( Map param ) throws Exception {
        return super.commonDao.list("bcm106ukrvServiceImpl.getBankBookInfo", param);
    }

    /** 저장 **/
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_SYNCALL, group = "accnt" )
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
    @SuppressWarnings( { "rawtypes" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "accnt" )
    public Integer insertList( List<Map> paramList, LoginVO user, Map paramMaster ) throws Exception {
        /* 데이터 insert */
        try {
            for (Map param : paramList) {
                super.commonDao.insert("bcm106ukrvServiceImpl.setBankBookInfo", param);
            }
        } catch (Exception e) {
            throw new UniDirectValidateException(this.getMessage("8114", user));
        }

        return 0;
    }

    /** 수정 **/
    @SuppressWarnings( { "rawtypes" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "accnt" )
    public Integer updateList( List<Map> paramList, LoginVO user, Map paramMaster ) throws Exception {
        for (Map param : paramList) {
            super.commonDao.update("bcm106ukrvServiceImpl.updateBankBookInfo", param);
        }
        return 0;
    }

    /** 삭제 **/
    @SuppressWarnings( { "rawtypes" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "accnt" )
    public Integer deleteList( List<Map> paramList, LoginVO user, Map paramMaster ) throws Exception {
        for (Map param : paramList) {
            try {
                super.commonDao.delete("bcm106ukrvServiceImpl.deleteBankBookInfo", param);

            } catch (Exception e) {
                throw new UniDirectValidateException(this.getMessage("547", user));
            }
        }
        return 0;
    }

    /* 전자문서정보 */

    /** 조회 **/
    @SuppressWarnings( { "unchecked", "rawtypes" } )
    @ExtDirectMethod( group = "accnt", value = ExtDirectMethodType.STORE_READ )
    public List<Map<String, Object>> getSubInfo3( Map param ) throws Exception {
        return super.commonDao.list("bcm106ukrvServiceImpl.getSubInfo3", param);
    }

    /** 저장 **/
    @SuppressWarnings( "rawtypes" )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_SYNCALL, group = "accnt" )
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
    @SuppressWarnings( "rawtypes" )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "accnt" )
    public Integer insertList3( List<Map> paramList, LoginVO user, Map paramMaster ) throws Exception {
        /* 데이터 insert */
        try {
            for (Map param : paramList) {
                super.commonDao.insert("bcm106ukrvServiceImpl.insertList3", param);
            }
        } catch (Exception e) {
            throw new UniDirectValidateException(this.getMessage("8114", user));
        }

        return 0;
    }

    /** 수정 **/
    @SuppressWarnings( "rawtypes" )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "accnt" )
    public Integer updateList3( List<Map> paramList, LoginVO user, Map paramMaster ) throws Exception {
        for (Map param : paramList) {
            super.commonDao.update("bcm106ukrvServiceImpl.updateList3", param);
        }
        return 0;
    }

    /** 삭제 **/
    @SuppressWarnings( "rawtypes" )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "accnt" )
    public Integer deleteList3( List<Map> paramList, LoginVO user, Map paramMaster ) throws Exception {
        for (Map param : paramList) {
            try {
                super.commonDao.delete("bcm106ukrvServiceImpl.deleteList3", param);

            } catch (Exception e) {
                throw new UniDirectValidateException(this.getMessage("547", user));
            }
        }
        return 0;
    }

    /**
	 * 구분에 따른 거래처 코드 채번
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "base", value = ExtDirectMethodType.STORE_READ)
	public Object selectAutoCustomCode(Map param) throws Exception {

		return super.commonDao.select("bcm106ukrvServiceImpl.selectAutoCustomCode", param);
	}

	/**
	 * 채번 확정시 채번테이블에 insert 또는 update
	 * @param param
	 * @return
	 * @throws Exception
	 */
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")
    public String saveAutoCustomCode(Map param) throws Exception {

        String rtnV = "";

		super.commonDao.update("bcm106ukrvServiceImpl.SaveAutoCustomCode", param);

        rtnV = "Y";
        return rtnV;
    }








    /**
	 * 품목 관련 파일 업로드
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "base", value = ExtDirectMethodType.STORE_READ )
	public List<Map<String, Object>> getItemInfo( Map param ) throws Exception {
		return super.commonDao.list("bcm106ukrvServiceImpl.getItemInfo", param);
	}

	/** 저장 **/
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_SYNCALL, group = "base" )
	@Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
	public List<Map> saveAll5( List<Map> paramList, Map paramMaster, LoginVO user ) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>)paramMaster.get("data");

		if (paramList != null) {
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;

			for (Map dataListMap : paramList) {
				if (dataListMap.get("method").equals("itemInfoInsert")) {
					insertList = (List<Map>)dataListMap.get("data");
				} else if (dataListMap.get("method").equals("itemInfoUpdate")) {
					updateList = (List<Map>)dataListMap.get("data");
				} else if (dataListMap.get("method").equals("itemInfoDelete")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}
			}
			if (deleteList != null) this.itemInfoDelete(deleteList, user, dataMaster);
			if (insertList != null) this.itemInfoInsert(insertList, user, dataMaster);
			if (updateList != null) this.itemInfoUpdate(updateList, user, dataMaster);
		}
		paramList.add(0, paramMaster);

		return paramList;
	}

	/** 추가 **/
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "base" )
	public Integer itemInfoInsert( List<Map> paramList, LoginVO user, Map paramMaster ) throws Exception {
		/* 데이터 insert */
		try {
			for (Map param : paramList) {
				super.commonDao.insert("bcm106ukrvServiceImpl.itemInfoInsert", param);
			}
		} catch (Exception e) {
			throw new UniDirectValidateException(this.getMessage("8114", user));
		}

		return 0;
	}

	/** 수정 **/
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "base" )
	public Integer itemInfoUpdate( List<Map> paramList, LoginVO user, Map paramMaster ) throws Exception {
		for (Map param : paramList) {
			super.commonDao.update("bcm106ukrvServiceImpl.itemInfoUpdate", param);
		}
		return 0;
	}

	/** 삭제 **/
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "base" )
	public Integer itemInfoDelete( List<Map> paramList, LoginVO user, Map paramMaster ) throws Exception {
		for (Map param : paramList) {
			try {
				super.commonDao.delete("bcm106ukrvServiceImpl.itemInfoDelete", param);
                ExtFileUtils.delFile(param.get("FILE_PATH") + "/" + param.get("FILE_ID") + '.' + param.get("FILE_EXT"));

			} catch (Exception e) {
				throw new UniDirectValidateException(this.getMessage("547", user));
			}
		}
		return 0;
	}




	/**
	 * 품목 관련 파일 업로드
	 *
	 * @param file1
	 * @return
	 * @throws IOException
	 */
	@ExtDirectMethod( group = "base", value = ExtDirectMethodType.FORM_POST )
	public ExtDirectFormPostResult photoUploadFile( @RequestParam( "photoFile" ) MultipartFile file, Bpr300ukrvModel param, LoginVO user ) throws IOException, Exception {
		String keyValue	= getLogKey();
		String manageNo	= param.getMANAGE_NO();

		if (file != null && !file.isEmpty()) {
			logger.debug("File1 Name : " + file.getName());
			logger.debug("File1 Bytes: " + file.getSize());
			String fileExtension = FileUtil.getExtension(file.getOriginalFilename()).toLowerCase();

			//화면단에서 체크하도록 수정
//			if (!"jpg".equals(fileExtension)) {
//				throw new UniDirectValidateException("jpg 파일로 올려주세요.");
//			}

			String path = ConfigUtil.getUploadBasePath(FILE_TYPE_OF_PHOTO, true);
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
				spParam.put("CUSTOM_CODE"		, param.getCUSTOM_CODE()	);
				spParam.put("FILE_TYPE"		, param.getFILE_TYPE()	);
				spParam.put("MANAGE_NO"		, manageNo				);

				spParam.put("CERT_FILE"		, file.getOriginalFilename());			//ORIGINAL_FILE_NAME
				spParam.put("FILE_ID"		, keyValue					);			//FID
				spParam.put("MIME_TYPE"		, file.getContentType()		);			//MIME_TYPE
				spParam.put("FILE_EXT"		, fileExtension				);
				spParam.put("FILE_SIZE"		, file.getSize()			);
				spParam.put("FILE_PATH"		, path						);

				logger.debug("CERT_FILE : " + spParam.get("CERT_FILE"));
				logger.debug("CERT_NO 	: " + spParam.get("CERT_NO"));
				super.commonDao.update("bcm106ukrvServiceImpl.photoModified", spParam);
			}

		} else {
			throw new UniDirectValidateException("등록할 사진을 선택해 주세요");
		}
		ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(true);
		return extResult;
	}


	/**
	 * 품목 관련 파일 다운로드
	 */
	public FileDownloadInfo getFileInfo( LoginVO user, String fid ) throws Exception {
//		String filePath = ConfigUtil.getString("common.upload.temp");
		Map<String, Object> param = new HashMap<String, Object>();
		FileDownloadInfo rv = null;
		param.put("fid", fid);

		Map rec = (Map)super.commonDao.select("bcm106ukrvServiceImpl.selectFileInfo", param);
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

	/**
	 * 품목 관련 파일 다운로드
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "base", value = ExtDirectMethodType.STORE_READ )
	public Object getItemInfoFileDown( Map param ) throws Exception {
		return (Map) super.commonDao.select("bcm106ukrvServiceImpl.getItemInfoFileDown", param);
	}

	 /**
     * 거래처 조회
     *
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_READ, group = "bcm" )
    public Object selectAutoCustomCodeSite( Map param ) throws Exception {

        return super.commonDao.select("bcm106ukrvServiceImpl.selectAutoCustomCodeSite", param);
    }
}
