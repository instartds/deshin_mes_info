package foren.unilite.modules.accnt.aba;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;

import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.codehaus.jackson.JsonGenerationException;
import org.codehaus.jackson.map.JsonMappingException;
import org.codehaus.jackson.map.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import api.rest.utils.HttpClientUtils;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.exception.BaseException;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.service.impl.TlabBadgeService;
import foren.unilite.com.validator.UniDirectValidateException;

@Service( "aba400ukrService" )
public class Aba400ukrServiceImpl extends TlabAbstractServiceImpl {
	
	// 20210302 뱃지 기능 추가
	@Resource(name="tlabBadgeService")
	private TlabBadgeService tlabBadgeService;
	
    private final Logger logger = LoggerFactory.getLogger(this.getClass());
    private HttpClientUtils httpclient = new HttpClientUtils();
    
    
    /**
     * Detail 조회
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( group = "hum", value = ExtDirectMethodType.STORE_READ )
    public List<Map<String, Object>> selectDetailList( Map param ) throws Exception {
        return super.commonDao.list("aba400ukrServiceImpl.selectDetailList", param);
    }
    
    /**
     * 저장
     * 
     * @param paramList 리스트의 create, update, destroy 오퍼레이션별 정보
     * @param paramMaster 폼(마스터 정보)의 기본 정보
     * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_SYNCALL, group = "hum" )
    @Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
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
     * Detail 입력
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "hum" )
    public Integer insertDetail( List<Map> paramList, LoginVO user ) throws  Exception {
        try {
        	String oprFlag = "";
            for (Map param : paramList) {
            	oprFlag = "N";
            	param.put("OPR_FLAG"		, oprFlag);

                super.commonDao.update("aba400ukrServiceImpl.insertDetail", param);
        		// 알람뱃지 추가
        		super.commonDao.update("aba400ukrServiceImpl.updateAlert", param);                
            }
        } catch (Exception e) {
            throw new UniDirectValidateException(this.getMessage("2627", user));
        }
        return 0;
    }
    
    /**
     * 인터페이스 실행
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public String confirm500t( Map param ) throws BaseException, Exception {
        // 토큰 / Target URL 경로
        List rtnList = super.commonDao.list("aba400ukrServiceImpl.getItisIssuUrl", null);
        
        String activeUrl = (String)( (Map)rtnList.get(0) ).get("CODE_NAME");
        String standbyUrl = (String)( (Map)rtnList.get(1) ).get("CODE_NAME");
        String mastId = "";
        
        CloseableHttpClient client = HttpClients.createDefault();
        Map subMap = new HashMap();
        
        try {
            if (rtnList.size() == 2) {
                
                subMap.put("INF_ID", (String)param.get("COMP_CODE") + "FAB" + (String)param.get("ACCNT_CD"));
                subMap.put("COMP_CODE", param.get("COMP_CODE"));
                subMap.put("APP_ID", "FAB");
                subMap.put("ACC_CODE", param.get("ACCNT_CD"));
                subMap.put("ACC_NAME", param.get("ACCNT_NAME"));
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
                    
                    mastId = ( (String)dataMap.get("MASTER_ACC_CODE") ); 
                } else {
                    throw new Exception((String)jsonObj.get("message"));
                }
                
/*
                HttpPost httpPost = new HttpPost(activeUrl); // HttpPost(testUrl);
                httpPost.addHeader("content-type", "application/json");
                StringEntity userEntity = new StringEntity(sb1.toString(), "UTF-8");
                httpPost.setEntity(userEntity);
                
                logger.info("request line :: {}", httpPost.getRequestLine());
                HttpResponse httpResponse = client.execute(httpPost);
                HttpEntity entity = httpResponse.getEntity();
                
                if (entity != null) {
                    String responseString = EntityUtils.toString(entity);
                    JSONObject jsonObj = JSONObject.fromObject(JSONSerializer.toJSON(responseString));
                    if (( (String)jsonObj.get("status") ).equals("0")) {
                        logger.info("responseString :: {}", responseString);
                        mastId = ( (String)jsonObj.get("message") );
                    } else {
                        throw new Exception((String)jsonObj.get("message"));
                    }
                }
  */              
            } else {
                throw new BaseException("계정확인에 필요한 정보가 셋팅되지 않았습니다.\n관리자에게 문의하여 주십시오.");
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
     * Detail 수정
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "hum" )
    public Integer updateDetail( List<Map> paramList, LoginVO user ) throws Exception {
    	String oprFlag = "";
        for (Map param : paramList) {
        	oprFlag = "U";
        	param.put("OPR_FLAG"		, oprFlag);
            super.commonDao.update("aba400ukrServiceImpl.updateDetail", param);
            
    		// 알람뱃지 추가
    		super.commonDao.update("aba400ukrServiceImpl.updateAlert", param);             
        }
        return 0;
    }
    
    /**
     * Detail 삭제
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes" } )
    @ExtDirectMethod( group = "hum", needsModificatinAuth = true )
    public Integer deleteDetail( List<Map> paramList, LoginVO user ) throws Exception {        	
    	String oprFlag = "";
        for (Map param : paramList) {
        	oprFlag = "D";
        	param.put("OPR_FLAG"		, oprFlag);        	
            
            Map deletableMap = (Map)super.commonDao.select("aba400ukrServiceImpl.deletableCheck", param);		//수불내역 있는지 확인 있으면 삭제 불가..
            if (ObjUtils.parseInt(deletableMap.get("CNT1")) > 0 || ObjUtils.parseInt(deletableMap.get("CNT2")) > 0 || ObjUtils.parseInt(deletableMap.get("CNT3")) > 0 || ObjUtils.parseInt(deletableMap.get("CNT4")) > 0 || ObjUtils.parseInt(deletableMap.get("CNT5")) > 0 || ObjUtils.parseInt(deletableMap.get("CNT6")) > 0 || ObjUtils.parseInt(deletableMap.get("CNT7")) > 0) {
                throw new UniDirectValidateException(this.getMessage("55305", user) + "\n계정코드: " + param.get("ACCNT"));
            } else {
                super.commonDao.delete("aba400ukrServiceImpl.deleteDetail", param);
        		// 알람뱃지 추가
        		super.commonDao.update("aba400ukrServiceImpl.updateAlert", param);                
            }
        }
        return 0;
    }
    
    /**
     * List 타입 -> Json 타입으로 변환
     * 
     * @param list
     * @param indent Json 문자열 정렬여부
     * @return
     */
    @SuppressWarnings( "rawtypes" )
    public String listToJson( List list ) {
        StringBuffer sb = new StringBuffer();
        ObjectMapper objMapper = new ObjectMapper();
        
        try {
            sb.append(objMapper.writeValueAsString(list));
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
