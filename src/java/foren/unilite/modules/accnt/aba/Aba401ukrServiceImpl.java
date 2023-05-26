package foren.unilite.modules.accnt.aba;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;
import org.codehaus.jackson.JsonGenerationException;
import org.codehaus.jackson.map.JsonMappingException;
import org.codehaus.jackson.map.ObjectMapper;
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
import foren.unilite.com.validator.UniDirectValidateException;

@Service( "aba401ukrService" )
public class Aba401ukrServiceImpl extends TlabAbstractServiceImpl {
    private final Logger      logger = LoggerFactory.getLogger(this.getClass());
    
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
        return super.commonDao.list("aba401ukrServiceImpl.selectDetailList", param);
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
    @SuppressWarnings( "rawtypes" )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "hum" )
    public Integer insertDetail( List<Map> paramList, LoginVO user ) throws Exception {
//        try {
//            for (Map param : paramList) {
//                logger.info("param :: {}", param);
//                super.commonDao.update("aba401ukrServiceImpl.updateDetail", param);
//            }
//        } catch (Exception e) {
//            throw new UniDirectValidateException(this.getMessage("2627", user));
//        }
        return 0;
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
        for (Map param : paramList) {
        	if(param.get("ORG_USE_YN").equals(false)) {
                Map deletableMap = (Map)super.commonDao.select("aba400ukrServiceImpl.deletableCheck", param);		//수불내역 있는지 확인 있으면 삭제 불가..
                if (ObjUtils.parseInt(deletableMap.get("CNT1")) > 0 || ObjUtils.parseInt(deletableMap.get("CNT2")) > 0 || ObjUtils.parseInt(deletableMap.get("CNT3")) > 0 || ObjUtils.parseInt(deletableMap.get("CNT4")) > 0 || ObjUtils.parseInt(deletableMap.get("CNT5")) > 0 || ObjUtils.parseInt(deletableMap.get("CNT6")) > 0 || ObjUtils.parseInt(deletableMap.get("CNT7")) > 0) {
                    throw new UniDirectValidateException(this.getMessage("55305", user) + "\n계정코드: " + param.get("ACCNT"));
                    
                } else {
                    super.commonDao.delete("aba401ukrServiceImpl.deleteDetail", param);
                }
        		
	        } else {
	            super.commonDao.update("aba401ukrServiceImpl.updateDetail", param);
	        }
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
//        for (Map param : paramList) {
//            
//            Map deletableMap = (Map)super.commonDao.select("aba400ukrServiceImpl.deletableCheck", param);		//수불내역 있는지 확인 있으면 삭제 불가..
//            if (ObjUtils.parseInt(deletableMap.get("CNT1")) > 0 || ObjUtils.parseInt(deletableMap.get("CNT2")) > 0 || ObjUtils.parseInt(deletableMap.get("CNT3")) > 0 || ObjUtils.parseInt(deletableMap.get("CNT4")) > 0 || ObjUtils.parseInt(deletableMap.get("CNT5")) > 0 || ObjUtils.parseInt(deletableMap.get("CNT6")) > 0 || ObjUtils.parseInt(deletableMap.get("CNT7")) > 0) {
//                throw new UniDirectValidateException(this.getMessage("55305", user) + "\n계정코드: " + param.get("ACCNT"));
//            } else {
//                super.commonDao.delete("aba401ukrServiceImpl.deleteDetail", param);
//            }
//        }
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
