package foren.unilite.modules.base.bcm;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.codehaus.jackson.JsonGenerationException;
import org.codehaus.jackson.map.JsonMappingException;
import org.codehaus.jackson.map.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.validation.BindingResult;

import api.rest.utils.HttpClientUtils;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.exception.BaseException;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.utils.UniliteUtil;
import foren.unilite.com.validator.UniDirectValidateException;
import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;

@Service( "bcm105ukrvService" )
public class Bcm105ukrvServiceImpl extends TlabAbstractServiceImpl {
    private final Logger          logger     = LoggerFactory.getLogger(this.getClass());
    private HttpClientUtils       httpclient = new HttpClientUtils();
    
    @Resource( name = "bcm100ukrvService" )
    private Bcm100ukrvServiceImpl bcm100ukrvService;
    
    /**
     * 거래처 입력 전 체크
     * 
     * @param paramList
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "bcm" )
    public Map getCount( List<Map> paramList, LoginVO user ) throws Exception {
        //return  super.commonDao.list("popupServiceImpl.creditCard2", param);
        
        Map COUNT = new HashMap();
        
        for (Map param : paramList) {
            if (!param.get("USE_YN").equals("NOT USE")) {
                //사업자 번호 "-" 제거
                if (param.get("COMPANY_NUM") != null) param.put("COMPANY_NUM", param.get("COMPANY_NUM").toString().replace("-", ""));
                
                //	            //주민등록 번호 암호화 
                //	            String topNum = (String) param.get("TOP_NUM").toString().replace("-", "");
                //	            if (ObjUtils.isNotEmpty(topNum)) {
                //	                topNum = seed.encryto(topNum);
                //	                param.put("TOP_NUM",  topNum);
                //	            }
                COUNT = (Map)super.commonDao.select("bcm105ukrvServiceImpl.getCount", param);
            }
        }
        return COUNT;
    };
    
    /**
     * 거래처 조회
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_BUFFERED, group = "bcm" )
    public Map<String, Object> selectList( Map param ) throws Exception {
        if (param.get("COMPANY_NUM") != null) param.put("COMPANY_NUM", ObjUtils.getSafeString(param.get("COMPANY_NUM")).replaceAll("\\-", ""));
        
        Map<String, Object> rMap = new HashMap();
        Map<String, Object> rTotal = new HashMap();
        List<Map<String, Object>> rList = new ArrayList();
        if (ObjUtils.parseBoolean(param.get("Init"), false)) {
            Map<String, Object> tmp = new HashMap<String, Object>();
            tmp.put("Init", true);
            rList.add(tmp);
            rTotal.put("TOTAL", 0);
        } else {
            rList = (List)super.commonDao.list("bcm105ukrvServiceImpl.getDataList", param);
            rTotal = (Map<String, Object>)super.commonDao.select("bcm105ukrvServiceImpl.getDataListSummary", param);
        }
        rMap.put("data", rList);
        rMap.put("total", rTotal.get("TOTAL"));
        //return rList;
        return rMap;
    }
    
    /**
     * Excel 다운로드를 위해.
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings( "rawtypes" )
    public List selectExcelList( Map param ) throws Exception {
        return (List)super.commonDao.list("bcm105ukrvServiceImpl.getDataList", param);
    }
    
    @ExtDirectMethod( value = ExtDirectMethodType.FORM_POST, group = "base" )
    public ExtDirectFormPostResult saveAll( Bcm105ukrvModel paramMaster, LoginVO user, BindingResult result ) throws Exception {
        
        List<Map> insertList = new ArrayList<Map>();
        List<Map> updateList = new ArrayList<Map>();
        List<Map> deleteList = new ArrayList<Map>();
        
        Map param = new HashMap();
        
        param.put("CUSTOM_CODE", paramMaster.getCUSTOM_CODE());    		//거래처코드' 		,type:'string'	, isPk:true, pkGen:'user'},
        param.put("CUSTOM_TYPE", paramMaster.getCUSTOM_TYPE());    		//구분' 			,type:'string'	,comboType:'AU',comboCode:'B015' ,allowBlank: false, defaultValue:'1'},
        param.put("CUSTOM_NAME", paramMaster.getCUSTOM_NAME());    		//거래처명' 		,type:'string'	,allowBlank:false},
        param.put("CUSTOM_NAME1", paramMaster.getCUSTOM_NAME1());    		//거래처명1' 		,type:'string'	},
        param.put("CUSTOM_NAME2", paramMaster.getCUSTOM_NAME2());    		//거래처명2' 		,type:'string'	},
        param.put("CUSTOM_FULL_NAME", paramMaster.getCUSTOM_FULL_NAME());    	//거래처명(전명)' 	,type:'string'	,allowBlank:false},
        param.put("NATION_CODE", paramMaster.getNATION_CODE());    		//국가코드' 		,type:'string'	,comboType:'AU',comboCode:'B012'},
        if (paramMaster.getCOMPANY_NUM() != null) {
            param.put("COMPANY_NUM", ObjUtils.getSafeString(paramMaster.getCOMPANY_NUM()).replaceAll("\\-", ""));
        }        //사업자번호'        ,type:'string'  },
        //param.put("COMPANY_NUM",paramMaster.getCOMPANY_NUM());    		//사업자번호' 		,type:'string'	},
        if (paramMaster.getTOP_NUM() != null) {
            param.put("TOP_NUM", ObjUtils.getSafeString(paramMaster.getTOP_NUM()).replaceAll("\\-", ""));
        }       //'주민번호'        ,type:'string'  },
        param.put("SERVANT_COMPANY_NUM", paramMaster.getSERVANT_COMPANY_NUM());    			//'종사업자번호' 			,type:'string'	},
        //param.put("TOP_NUM",paramMaster.getTOP_NUM());    			//'주민번호' 		,type:'string'	},
        param.put("TOP_NAME", paramMaster.getTOP_NAME());    			//'대표자' 			,type:'string'	},
        param.put("BUSINESS_TYPE", paramMaster.getBUSINESS_TYPE());    		//법인/구분' 		,type:'string'	,comboType:'AU',comboCode:'B016'},
        param.put("USE_YN", paramMaster.getUSE_YN());    			//'사용유무' 		,type:'string'	,comboType:'AU',comboCode:'B010', defaultValue:'Y'},
        param.put("COMP_TYPE", paramMaster.getCOMP_TYPE());    			//업태' 			,type:'string'	},
        param.put("COMP_CLASS", paramMaster.getCOMP_CLASS());    		//업종' 			,type:'string'	},
        param.put("AGENT_TYPE", paramMaster.getAGENT_TYPE());    		//거래처분류' 		,type:'string'	,comboType:'AU',comboCode:'B055' ,allowBlank: false, defaultValue:'1'},
        param.put("AGENT_TYPE2", paramMaster.getAGENT_TYPE2());    		//거래처분류2' 		,type:'string'	},
        param.put("AGENT_TYPE3", paramMaster.getAGENT_TYPE3());    		//거래처분류3' 		,type:'string'	},
        param.put("AREA_TYPE", paramMaster.getAREA_TYPE());    			//지역' 			,type:'string'	,comboType:'AU',comboCode:'B056'},
        param.put("ZIP_CODE", paramMaster.getZIP_CODE());    			//'우편번호' 		,type:'string'	},
        param.put("ADDR1", paramMaster.getADDR1());    				//'주소1' 			,type:'string'	},
        param.put("ADDR2", paramMaster.getADDR2());    				//'주소2' 			,type:'string'	},					
        param.put("TELEPHON", paramMaster.getTELEPHON());    			//'연락처' 			,type:'string'	},
        param.put("FAX_NUM", paramMaster.getFAX_NUM());    			//'FAX번호' 		,type:'string'	},
        param.put("HTTP_ADDR", paramMaster.getHTTP_ADDR());    			//홈페이지' 		,type:'string'	},  
        param.put("MAIL_ID", paramMaster.getHTTP_ADDR());    			//'E-mail' 			,type:'string'	},
        param.put("WON_CALC_BAS", paramMaster.getWON_CALC_BAS());    		//원미만계산' 		,type:'string'	,comboType:'AU',comboCode:'B017'},
        param.put("START_DATE", paramMaster.getSTART_DATE());    		//거래시작일' 		,type:'uniDate'	,allowBlank: false, defaultValue:UniDate.today()},
        param.put("STOP_DATE", paramMaster.getSTOP_DATE());    			//거래중단일' 		,type:'uniDate'	},
        param.put("TO_ADDRESS", paramMaster.getTO_ADDRESS());    		//송신주소' 		,type:'string'	},
        param.put("TAX_CALC_TYPE", paramMaster.getTAX_CALC_TYPE());    		//세액계산법' 		,type:'string'	,comboType:'AU',comboCode:'B051', defaultValue:'1'},
        param.put("RECEIPT_DAY", paramMaster.getRECEIPT_DAY());    		//결제기간' 		,type:'string'	,comboType:'AU',comboCode:'B034'},
        param.put("MONEY_UNIT", paramMaster.getMONEY_UNIT());    		//기준화폐' 		,type:'string'	, comboType:'AU',comboCode:'B004'},
        param.put("TAX_TYPE", paramMaster.getTAX_TYPE());    			//'세액포함여부' 	,type:'string'	, comboType:'AU',comboCode:'B030', defaultValue:'1'},
        param.put("BILL_TYPE", paramMaster.getBILL_TYPE());    			//계산서유형' 		,type:'string'	, comboType:'AU',comboCode:'A022'},
        param.put("SET_METH", paramMaster.getSET_METH());    			//'결제방법' 		,type:'string'	, comboType:'AU',comboCode:'B038'},
        param.put("VAT_RATE", paramMaster.getVAT_RATE());    			//'세율' 			,type:'uniFC'	,defaultValue:0},
        param.put("TRANS_CLOSE_DAY", paramMaster.getTRANS_CLOSE_DAY());    	//마감종류' 		,type:'string'	, comboType:'AU',comboCode:'B033'},
        param.put("COLLECT_DAY", paramMaster.getCOLLECT_DAY());    		//수금일'  			,type:'integer' ,defaultValue:1, minValue:1},                  
        param.put("CREDIT_YN", paramMaster.getCREDIT_YN());    			//여신적용여부' 	,type:'string'	, comboType:'AU',comboCode:'B010'},
        param.put("TOT_CREDIT_AMT", paramMaster.getTOT_CREDIT_AMT());    	//여신(담보)액' 	,type:'uniPrice'	},
        param.put("CREDIT_AMT", paramMaster.getCREDIT_AMT());    		//신용여신액' 		,type:'uniPrice'	},
        param.put("CREDIT_YMD", paramMaster.getCREDIT_YMD());    		//신용여신만료일' 	,type:'uniDate'	},
        param.put("COLLECT_CARE", paramMaster.getCOLLECT_CARE());    		//미수관리방법' 	,type:'string'	, comboType:'AU',comboCode:'B057', defaultValue:'1'},
        param.put("BUSI_PRSN", paramMaster.getBUSI_PRSN());    			//주담당자' 		,type:'string'	, comboType:'AU',comboCode:'S010'},
        param.put("CAL_TYPE", paramMaster.getCAL_TYPE());    			//'카렌더타입' 		,type:'string'	, comboType:'AU',comboCode:'B062'},
        param.put("REMARK", paramMaster.getREMARK());    			//'비고' 			,type:'string'	},
        param.put("MANAGE_CUSTOM", paramMaster.getMANAGE_CUSTOM());    		//집계거래처' 		,type:'string'	},					
        param.put("MCUSTOM_NAME", paramMaster.getMCUSTOM_NAME());    		//집계거래처명' 	,type:'string'	},
        param.put("COLLECTOR_CP", paramMaster.getCOLLECTOR_CP());    		//수금거래처' 		,type:'string'	},					
        param.put("COLLECTOR_CP_NAME", paramMaster.getCOLLECTOR_CP_NAME());    	//수금거래처명' 	,type:'string'	},					
        param.put("BANK_CODE", paramMaster.getBANK_CODE());    			//금융기관' 		,type:'string'	},
        param.put("BANK_NAME", paramMaster.getBANK_NAME());    			//금융기관명' 		,type:'string'	},
        param.put("BANKBOOK_NUM", paramMaster.getBANKBOOK_NUM());    		//계좌번호' 		,type:'string'	},
        param.put("BANKBOOK_NAME", paramMaster.getBANKBOOK_NAME());    		//예금주' 			,type:'string'	},
        param.put("CUST_CHK", paramMaster.getCUST_CHK());    			//'거래처변경여부' 	,type:'string'	},
        param.put("SSN_CHK", paramMaster.getSSN_CHK());    			//'주민번호변경여부',type:'string'	},
        param.put("PURCHASE_BANK", paramMaster.getPURCHASE_BANK());    		//구매카드은행' 	,type:'string'	},
        param.put("PURBANKNAME", paramMaster.getPURBANKNAME());    		//구매카드은행명' 	,type:'string'	},
        param.put("BILL_PRSN", paramMaster.getBILL_PRSN());    			//전자문서담당자' 	,type:'string'	},
        if (paramMaster.getHAND_PHON() != null) {
            param.put("HAND_PHON", ObjUtils.getSafeString(paramMaster.getHAND_PHON()).replaceAll("\\-", ""));
        }
        //param.put("HAND_PHON",paramMaster.getHAND_PHON());    			//핸드폰번호' 		,type:'string'	},
        param.put("BILL_MAIL_ID", paramMaster.getBILL_MAIL_ID());    		//전자문서E-mail'	,type:'string'	},
        param.put("BILL_PRSN2", paramMaster.getBILL_PRSN2());    		//전자문서담당자2' 	,type:'string'	},
        param.put("HAND_PHON2", paramMaster.getHAND_PHON2());    		//핸드폰번호2' 		,type:'string'	},
        param.put("BILL_MAIL_ID2", paramMaster.getBILL_MAIL_ID2());    		//전자문서E-mail2'	,type:'string'	},
        param.put("BILL_MEM_TYPE", paramMaster.getBILL_MEM_TYPE());    		//전자세금계산서' 	,type:'string'	},
        param.put("ADDR_TYPE", paramMaster.getADDR_TYPE());    			//신/구주소 구분' 	,type:'string'	, comboType:'AU',comboCode:'B232'},
        param.put("COMP_CODE", user.getCompCode());    			//COMP_CODE' 		,type:'string'	, defaultValue: UserInfo.compCode},
        param.put("CHANNEL", paramMaster.getCHANNEL());    			//'CHANNEL' 		,type:'string'	},
        param.put("BILL_CUSTOM", paramMaster.getBILL_CUSTOM());    		//계산서거래처코드'	,type:'string'	},
        param.put("BILL_CUSTOM_NAME", paramMaster.getBILL_CUSTOM_NAME());    	//계산서거래처' 	,type:'string'	},
        param.put("CREDIT_OVER_YN", paramMaster.getCREDIT_OVER_YN());    	//CREDIT_OVER_YN' 	,type:'string'	},
        param.put("Flag", paramMaster.getFlag());    				//Flag' 			,type:'string'	},    
        param.put("DEPT_CODE", paramMaster.getDEPT_CODE());    			//관련부서' 		,type:'string'	},    
        param.put("DEPT_NAME", paramMaster.getDEPT_NAME());    			//관련부서명' 		,type:'string'	},
        param.put("BILL_PUBLISH_TYPE", paramMaster.getBILL_PUBLISH_TYPE());
        param.put("R_PAYMENT_YN", paramMaster.getR_PAYMENT_YN());
        param.put("S_USER_ID", user.getUserID());
        param.put("S_COMP_CODE", user.getCompCode());
        
        if ("D".equals(paramMaster.getFlag())) {
            deleteList.add(param);
        } else if ("U".equals(paramMaster.getFlag())) {
            updateList.add(param);
        } else {
            insertList.add(param);
        }
        
        ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);
        
        if (deleteList.size() > 0) bcm100ukrvService.deleteDetail(deleteList, user);
        if (insertList.size() > 0) {
            insertList = this.insertDetail(insertList, user);
            if (insertList != null && insertList.size() > 0) {
                extResult.addResultProperty("CUSTOM_CODE", ObjUtils.getSafeString(insertList.get(0).get("CUSTOM_CODE")));
            }
        }
        if (updateList.size() > 0) bcm100ukrvService.updateDetail(updateList, user);
        
        return extResult;
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
            List<Map<String, Object>> rsInfoList = (List<Map<String, Object>>)super.commonDao.list("bcm100ukrvServiceImpl.insertQuery01", uMap);
            
            for (Map param : paramList) {
                
                String sOrgCompCode = param.get("COMP_CODE").toString();
                
                for (Map rsInfo : rsInfoList) {
                    Map compCodeMap = new HashMap();
                    compCodeMap.put("S_COMP_CODE", user.getCompCode());
                    if (ObjUtils.isEmpty(param.get("CUSTOM_CODE")) && !param.get("CUSTOM_TYPE").equals("4")) {    //일반 거래처 채번
                        List<Map> customCode = (List<Map>)super.commonDao.list("bcm100ukrvServiceImpl.getAutoCustomCode", compCodeMap);
                        param.put("CUSTOM_CODE", customCode.get(0).get("CUSTOM_CODE"));
                    } else {  //금융 채번
                        List<Map> customCode = (List<Map>)super.commonDao.list("bcm100ukrvServiceImpl.getAutoFinanceCustomCode", compCodeMap);
                        param.put("CUSTOM_CODE", customCode.get(0).get("CUSTOM_CODE"));
                    }
                    
                    param.put("START_DATE", UniliteUtil.chgDateFormat(param.get("START_DATE")));
                    param.put("STOP_DATE", UniliteUtil.chgDateFormat(param.get("STOP_DATE")));
                    param.put("CREDIT_YMD", UniliteUtil.chgDateFormat(param.get("CREDIT_YMD")));
                    if (param.get("ZIP_CODE") != null) {
                        param.put("ZIP_CODE", param.get("ZIP_CODE").toString().replace("-", ""));
                    }
                    
                    if (param.get("TOP_NUM") != null) param.put("TOP_NUM", param.get("TOP_NUM").toString().replace("-", ""));
                    if (param.get("COMPANY_NUM") != null) param.put("COMPANY_NUM", param.get("COMPANY_NUM").toString().replace("-", ""));
                    
                    //사업자 번호 없을시는 인터페이스 탈 필요 없음.. 따라서 법인/개인: 기타개인 , 구분: 금융 일시 인터페이스 안탐..
                    if (!ObjUtils.isEmpty(param.get("COMPANY_NUM"))) {
                        String masterId = confirm200t(param);
                        param.put("MASTER_CUST_CODE", masterId);
                    }
                    logger.info("param :: {}", param);
                    
                    r = super.commonDao.update("bcm105ukrvServiceImpl.insertMulti", param);
                    if ("Y".equals(sDemo)) {
                        if (!license) {
                            Map<String, Object> customCnt = (Map<String, Object>)super.commonDao.select("bcm100ukrvServiceImpl.insertQuery01", param);
                            if (Integer.parseInt(customCnt.get("CNT").toString()) > 100) {
                                throw new UniDirectValidateException(this.getMessage("52104", user));
                            }
                        }
                    }
                    
                }
                //          param.put("COMP_CODE", sOrgCompCode);
                //          param.put("CUSTOM_NAME1", param.get("CUSTOM_NAME") + "-CHANGE ON SERVER");
                
            }
            
        } catch (BaseException be) {
            throw new Exception(be.getMessage());
        } catch (Exception e) {
            logger.debug(e.toString());
            throw new UniDirectValidateException(this.getMessage("2627", user));
        }
        
        return paramList;
    }
    
    /**
     * 인터페이스 실행
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public String confirm200t( Map param ) throws BaseException, Exception {
        // 토큰 / Target URL 경로
        List rtnList = super.commonDao.list("bcm105ukrvServiceImpl.getItisIssuUrl", null);
        
        String activeUrl = (String)( (Map)rtnList.get(0) ).get("CODE_NAME");
        String standbyUrl = (String)( (Map)rtnList.get(1) ).get("CODE_NAME");
        String mastId = "";
        
        CloseableHttpClient client = HttpClients.createDefault();
        Map subMap = new HashMap();
        
        try {
            if (rtnList.size() == 2) {
                
                subMap.put("INF_ID", (String)param.get("COMP_CODE") + "FAB" + (String)param.get("CUSTOM_CODE"));
                subMap.put("COMP_CODE", param.get("COMP_CODE"));
                subMap.put("APP_ID", "FAB");
                
                subMap.put("CUSTOM_ID", param.get("CUSTOM_CODE"));
                subMap.put("CUSTOM_NAME", param.get("CUSTOM_NAME"));
                subMap.put("COMPANY_NUM", param.get("COMPANY_NUM"));
                subMap.put("TOP_NAME", param.get("TOP_NAME"));
                subMap.put("CUSTOM_TEL", param.get("TELEPHON"));
                subMap.put("ADDR_TYPE", param.get("ADDR_TYPE"));
                subMap.put("ZIP_CODE", param.get("ZIP_CODE"));
                subMap.put("ADDR1", param.get("ADDR1"));
                subMap.put("ADDR2", param.get("ADDR2"));
                subMap.put("HTTP_ADDR", param.get("HTTP_ADDR"));
                subMap.put("BAD_YN", "N");
                
                subMap.put("USE_YN", "Y");
                subMap.put("STATUS", "I");
                
                String mstrStr = mapToJson(subMap);
                
                StringBuffer sb1 = new StringBuffer();
                
                sb1.append("{\"data\":");
                sb1.append(mstrStr);
                sb1.append("}");
                
                logger.info("보낸 data :: {}", sb1.toString());
                
                String responseString = httpclient.post(activeUrl, standbyUrl, sb1.toString(), "application/json", "UTF-8", 1000, 1000);
                logger.debug("responseString :: {}", responseString);
                JSONObject jsonObj = JSONObject.fromObject(JSONSerializer.toJSON(responseString));
                if (( (String)jsonObj.get("status") ).equals("0")) {
                    logger.debug("responseString :: {}", responseString);
                    Map dataMap = new HashMap();
                    dataMap = (Map)jsonObj.get("data");
                    
                    mastId = ( (String)dataMap.get("MASTER_CUST_CODE") );
                } else {
                    throw new Exception((String)jsonObj.get("message"));
                }
                
                /*
                 * HttpPost httpPost = new HttpPost(activeUrl); // HttpPost(testUrl); httpPost.addHeader("content-type", "application/json"); StringEntity userEntity = new StringEntity(sb1.toString(), "UTF-8"); httpPost.setEntity(userEntity); logger.info("request line :: {}", httpPost.getRequestLine()); HttpResponse httpResponse = client.execute(httpPost); HttpEntity entity = httpResponse.getEntity(); if (entity != null) { String responseString = EntityUtils.toString(entity); JSONObject jsonObj = JSONObject.fromObject(JSONSerializer.toJSON(responseString)); if (( (String)jsonObj.get("status") ).equals("0")) { logger.info("responseString :: {}", responseString); mastId = ( (String)jsonObj.get("message") ); } else { throw new Exception((String)jsonObj.get("message")); } }
                 */
            } else {
                throw new BaseException("거래처확인에 필요한 정보가 셋팅되지 않았습니다.\n관리자에게 문의하여 주십시오.");
            }
        } catch (BaseException be) {
            be.printStackTrace();
            throw new Exception(be.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            throw new Exception(e.getMessage());
        } finally {
            try {
                if (client != null) client.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        
        return mastId;
    }
    
    /**
     * Map 타입 -> Json 타입으로 변환
     * 
     * @param map
     * @param indent Json 문자열 정렬여부
     * @return
     */
    @SuppressWarnings( "rawtypes" )
    public String mapToJson( Map map ) {
        StringBuffer sb = new StringBuffer();
        ObjectMapper objMapper = new ObjectMapper();
        
        try {
            sb.append(objMapper.writeValueAsString(map));
        } catch (JsonGenerationException e) {
            logger.error(e.getMessage());
            return "";
        } catch (JsonMappingException e) {
            logger.error(e.getMessage());
            return "";
        } catch (IOException e) {
            logger.error(e.getMessage());
            return "";
        }
        
        return sb.toString();
    }
    
}
