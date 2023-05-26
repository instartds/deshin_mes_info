package foren.unilite.modules.base.bcm;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.utils.UniliteUtil;
import foren.unilite.com.validator.UniDirectValidateException;

@Service( "bcm100ukrvService" )
public class Bcm100ukrvServiceImpl extends TlabAbstractServiceImpl {
    private final Logger logger = LoggerFactory.getLogger(this.getClass());

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
        return super.commonDao.list("bcm100ukrvServiceImpl.getDataList", param);
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
        return super.commonDao.select("bcm100ukrvServiceImpl.insertQuery06", param);
    }
    
    /**
     * 사업자번호 중복 체크
     *
     * @param param
     * @return
     */
    @SuppressWarnings( "rawtypes" )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_READ, group = "bcm" )
    public Object chkCN( Map param ) {
        return super.commonDao.select("bcm100ukrvServiceImpl.companyNumchk", param);
    }

    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_SYNCALL, group = "bcm" )
    public List<Map> saveAll( List<Map> paramList, Map paramMaster, LoginVO user ) throws Exception {
        if (paramList != null) {
            List<Map> insertList = null;
            List<Map> updateList = null;
            List<Map> deleteList = null;
            List<Map> insertSimpleList = null;
            for (Map dataListMap : paramList) {
                if (dataListMap.get("method").equals("deleteDetail")) {
                    deleteList = (List<Map>)dataListMap.get("data");
                } else if (dataListMap.get("method").equals("insertDetail")) {
                    insertList = (List<Map>)dataListMap.get("data");
                } else if (dataListMap.get("method").equals("updateDetail")) {
                    updateList = (List<Map>)dataListMap.get("data");
                }else if (dataListMap.get("method").equals("insertSimple")) {
                	insertSimpleList = (List<Map>)dataListMap.get("data");
                }
            }
            if (deleteList != null) this.deleteDetail(deleteList, user);
            if (insertList != null) this.insertDetail(insertList, user);
            if (updateList != null) this.updateDetail(updateList, user);
            if (insertSimpleList != null) this.insertSimple(insertSimpleList, user);
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
    public List<Map> insertDetail( List<Map> paramList, LoginVO user ) throws Exception {

        int r = 0;

        String sDemo = "N";
        boolean license = UniliteUtil.IsExceedUser("C");
        if (license) sDemo = "Y";

        //공통코드(B107:타법인 복사여부)에 따라 법인정보 조회
        try {
            Map<String, Object> uMap = new HashMap<String, Object>();
            uMap.put("S_COMP_CODE", user.getCompCode());
            List<Map<String, Object>> rsInfoList = (List<Map<String, Object>>)super.commonDao.list("bcm100ukrvServiceImpl.insertQuery01", uMap);

            for (Map param : paramList) {

                String sOrgCompCode = param.get("COMP_CODE").toString();

                for (Map rsInfo : rsInfoList) {
                    Map compCodeMap = new HashMap();
                    compCodeMap.put("S_COMP_CODE", user.getCompCode());
                    if (ObjUtils.isEmpty(param.get("CUSTOM_CODE"))) {
                        List<Map> customCode = (List<Map>)super.commonDao.list("bcm100ukrvServiceImpl.getAutoCustomCode", compCodeMap);
                        param.put("CUSTOM_CODE", customCode.get(0).get("CUSTOM_CODE"));
                    }

                    param.put("START_DATE", UniliteUtil.chgDateFormat(param.get("START_DATE")));
                    param.put("STOP_DATE", UniliteUtil.chgDateFormat(param.get("STOP_DATE")));
                    param.put("CREDIT_YMD", UniliteUtil.chgDateFormat(param.get("CREDIT_YMD")));
                    if (param.get("TOP_NUM") != null) param.put("TOP_NUM", param.get("TOP_NUM").toString().replace("-", ""));
                    if (param.get("COMPANY_NUM") != null) param.put("COMPANY_NUM", param.get("COMPANY_NUM").toString().replace("-", ""));

                    if (param.get("ZIP_CODE") != null) {
                        param.put("ZIP_CODE", param.get("ZIP_CODE").toString().replace("-", ""));
                    }

                    r = super.commonDao.update("bcm100ukrvServiceImpl.insertMulti", param);
                    if ("Y".equals(sDemo)) {
                        if (!license) {
                            Map<String, Object> customCnt = (Map<String, Object>)super.commonDao.select("bcm100ukrvServiceImpl.insertQuery01", param);
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
            List<Map<String, Object>> rsInfoList = (List<Map<String, Object>>)super.commonDao.list("bcm100ukrvServiceImpl.insertQuery01", uMap);

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

                    r = super.commonDao.update("bcm100ukrvServiceImpl.updateMulti", param);

                    if ("Y".equals(sDemo)) {
                        if (!license) {
                            Map<String, Object> customCnt = (Map<String, Object>)super.commonDao.select("bcm100ukrvServiceImpl.insertQuery01", param);
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
        List<Map<String, Object>> rsInfoList = (List<Map<String, Object>>)super.commonDao.list("bcm100ukrvServiceImpl.insertQuery01", uMap);
        for (Map param : paramList) {
            String sOrgCompCode = param.get("COMP_CODE").toString();

            for (Map rsInfo : rsInfoList) {
                try {
                    param.put("COMP_CODE", rsInfo.get("COMP_CODE"));

                    // 회계데이타가 남아 있는 경우 삭제 불가
                    Map<String, Object> rsSheet = (Map<String, Object>)super.commonDao.select("bcm100ukrvServiceImpl.deleteQuery02", param);

                    if (Integer.parseInt(rsSheet.get("CNT").toString()) > 0) {
                        // FIXME Message 처리 547 "Custom Code : " + param.get("CUSTOM_CODE").toString();
                        throw new UniDirectValidateException(this.getMessage("547", user));
                    } else {
                        r = super.commonDao.delete("bcm100ukrvServiceImpl.deleteMulti", param);
                        super.commonDao.delete("bcm100ukrvServiceImpl.deleteBCM120", param);
                        super.commonDao.delete("bcm100ukrvServiceImpl.deleteTradeInfo", param);
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
        return super.commonDao.list("bcm100ukrvServiceImpl.getBCM120List", param);
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
            r = super.commonDao.update("bcm100ukrvServiceImpl.insertBCM120", param);
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
            r = super.commonDao.update("bcm100ukrvServiceImpl.updateBCM120", param);
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
            r = super.commonDao.delete("bcm100ukrvServiceImpl.deleteBCM120", param);
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
                    List<Map> customCode = (List<Map>)super.commonDao.list("bcm100ukrvServiceImpl.getAutoCustomCode", compCodeMap);
                    param.put("CUSTOM_CODE", customCode.get(0).get("CUSTOM_CODE"));
                }

                //            Map result = (Map)super.commonDao.queryForObject("bcm100ukrvServiceImpl.insertSimple", param);
                //            param.put("CUSTOM_CODE", result.get("CUSTOM_CODE"));
                Map result = (Map)super.commonDao.queryForObject("bcm100ukrvServiceImpl.insertSimple2", param);
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
        return super.commonDao.list("bcm100ukrvServiceImpl.getBankBookInfo", param);
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
                super.commonDao.insert("bcm100ukrvServiceImpl.setBankBookInfo", param);
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
            super.commonDao.update("bcm100ukrvServiceImpl.updateBankBookInfo", param);
        }
        return 0;
    }

    /** 삭제 **/
    @SuppressWarnings( { "rawtypes" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "accnt" )
    public Integer deleteList( List<Map> paramList, LoginVO user, Map paramMaster ) throws Exception {
        for (Map param : paramList) {
            try {
                super.commonDao.delete("bcm100ukrvServiceImpl.deleteBankBookInfo", param);

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
        return super.commonDao.list("bcm100ukrvServiceImpl.getSubInfo3", param);
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
                super.commonDao.insert("bcm100ukrvServiceImpl.insertList3", param);
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
            super.commonDao.update("bcm100ukrvServiceImpl.updateList3", param);
        }
        return 0;
    }

    /** 삭제 **/
    @SuppressWarnings( "rawtypes" )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "accnt" )
    public Integer deleteList3( List<Map> paramList, LoginVO user, Map paramMaster ) throws Exception {
        for (Map param : paramList) {
            try {
                super.commonDao.delete("bcm100ukrvServiceImpl.deleteList3", param);

            } catch (Exception e) {
                throw new UniDirectValidateException(this.getMessage("547", user));
            }
        }
        return 0;
    }

}
