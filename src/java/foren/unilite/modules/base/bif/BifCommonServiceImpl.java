package foren.unilite.modules.base.bif;

import java.io.InputStream;
import java.io.OutputStream;
import java.io.StringWriter;
import java.nio.charset.Charset;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.crypto.Cipher;
import javax.crypto.spec.SecretKeySpec;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.net.util.Charsets;
import org.apache.http.HttpEntity;
import org.apache.http.NameValuePair;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;
import org.apache.lucene.util.IOUtils;
import org.apache.tomcat.util.codec.binary.Base64;
import org.json.JSONArray;
import org.json.JSONObject;
import org.apache.http.message.BasicNameValuePair;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.BindingResult;
import org.springframework.web.client.RestTemplate;
import org.sqlite.SQLiteConfig.Encoding;

import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.databind.ObjectMapper;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.lib.tree.GenericTreeNode;
import foren.framework.model.LoginVO;
import foren.framework.sec.license.LicenseManager;
import foren.framework.utils.ConfigUtil;
import foren.framework.utils.GStringUtils;
import foren.framework.utils.JndiUtils;
import foren.framework.utils.JsonUtils;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.menu.MenuItemModel;
import foren.unilite.com.menu.MenuNode;
import foren.unilite.com.menu.MenuTree;
import foren.unilite.com.menu.ProgramAuthModel;
import foren.unilite.com.menu.UniModuleModel;
import foren.unilite.com.service.impl.TlabAbstractCommonServiceImpl;
import foren.unilite.com.service.impl.TlabBadgeService;
import foren.unilite.com.service.impl.TlabMenuService;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.com.fileman.FileMnagerService;
import net.sf.json.JSONSerializer;

@Service("bifCommonService")
public class BifCommonServiceImpl extends TlabAbstractCommonServiceImpl {
    private static final Logger logger = LoggerFactory.getLogger(BifCommonServiceImpl.class);
    
    private String UID = "systems";
    private String PWD = "foren862";
    private String COMP_NUMBER = "01064898393";
    private String SMS_URL = "http://biz.moashot.com/EXT/URLASP/mssendUTF.asp";
    private String KAKAOTALK_URL = "https://biz.moashot.com/ext/api/sendTalk.asp";
    private String SENDER_KEY = "2b7178b7aefd7aa64f6c6f8a3d3e0f7cab54bbef";
    private String SYNERGYTAL_URL = "http://210.122.36.253/ezmaru/message";
    
    @Resource( name = "bif100ukrvService" )
	private Bif100ukrvServiceImpl bif100ukrvService;

    /**
     * 테스트 전송
     * 발신자와 수신자, 메세지를 임의로 정하여 테스트
     * @param params
     * @param user
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod(group = "base")
    public Object sendTest(Map<String, Object> params, LoginVO user) throws Exception {
    	Map rMap = new HashMap();
    	
    	String pgmId = ObjUtils.getSafeString(params.get("PGM_ID"));
    	int seq = ObjUtils.parseInt(params.get("SEQ"));
    	String data = ObjUtils.getSafeString(params.get("data"));
    	Map<String, Object> dataParam = (Map<String, Object>)JsonUtils.fromJsonStr(data);
    	Map<String, Object>  pgmMessage = new HashMap();
    	pgmMessage.put("MESSAGE_SUBJECT", params.get("MESSAGE_SUBJECT"));
    	pgmMessage.put("MESSAGE", params.get("MESSAGE"));
    	pgmMessage.put("TEMPLATE_CODE", params.get("TEMPLATE_CODE"));
    	
    	String message = this.makeMessage(dataParam, ObjUtils.getSafeString(pgmMessage.get("MESSAGE")));
    	pgmMessage.put("MESSAGE", message);
    	
    	
    	List<Map<String, Object>> receivers = new ArrayList<>();
    	Map<String, Object> receiver = new HashMap();
    	
    	
    	String sendType = ObjUtils.getSafeString(params.get("SEND_TYPE"));
    	if("S".equals(sendType)) {				// 시너지톡
        	receiver.put("RECEIVE_ID",params.get("RECEIVE_ID"));
        	receiver.put("SENDER_ID",params.get("SENDER_ID"));
        	receivers.add(receiver);
    		rMap = (Map) this.sendSynergyTalk(pgmMessage, pgmId,  seq,  null, receivers, params, user);
    	} else if("K".equals(sendType))	{		//카카오톡
        	receiver.put("MOBILE",params.get("MOBILE"));		//"01054823801"
        	receiver.put("KAKAOTALK_ID",params.get("KAKAOTALK_ID"));
        	receivers.add(receiver);
    		rMap = (Map) this.sendKakaoTalk(pgmMessage, pgmId,  seq,  null, receivers, null, params, user);
    	} else {		
    		receiver.put("MOBILE",params.get("MOBILE"));//문자
    		receivers.add(receiver);
    		rMap = (Map) this.sendSMS(pgmMessage, pgmId,  seq,  null, receivers, null, params, user);
    	}
    	return rMap;
    	
    }
    
    /**
     * 발신/수신자 테스트 전송
     * 저장된 메세지와 발신자,수신자를 테세트
     * @param params  메세지의 파라메터 매핑 JSON
     * @param user
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod(group = "base")
    public Object sendUsersTest(Map<String, Object> params,  LoginVO user) throws Exception {
    	Map rMap = new HashMap();
    	
    	String pgmId = ObjUtils.getSafeString(params.get("PGM_ID"));
    	int seq = ObjUtils.parseInt(params.get("SEQ"));
    	String divCode = ObjUtils.getSafeString(params.get("DIV_CODE"));
    	
    	String data = ObjUtils.getSafeString(params.get("data"));
    	Map<String, Object> dataParam = (Map<String, Object>)JsonUtils.fromJsonStr(data);
    	
    	rMap = (Map) this.sendMessages(dataParam, pgmId, seq, divCode, null, user);
    	
    	return rMap;
    	
    }
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod(group = "base")
    /**
     * 메신저 메세지 보내기
     * @param params 메세지에 변수와 변수값
     * @param pgmId  메세지 프로그램 ID
     * @param seq    메세지 순번
     * @param startTime 문자전송, 카카오톡 알림톡의 전송시간(YYMMDDhhmmss) 
     * @param user 
     * @return
     * @throws Exception
     */
    public Object sendMessages(Map<String, Object> params, String pgmId, int seq, String divCode, String startTime, LoginVO user) throws Exception {
    	Map rMap = new HashMap();
    	
    	//메세지데이터 조회
    	Map  sParam = new HashMap();
    	sParam.put("S_COMP_CODE", user.getCompCode());
    	sParam.put("PGM_ID", pgmId);
    	sParam.put("SEQ", seq);
    	if(ObjUtils.isNotEmpty(divCode))	{
    		sParam.put("DIV_CODE", divCode);
    	}
    	List<Map<String, Object>>  pgmMessages = this.sendMessageList(sParam);
    	Map<String, Object>  pgmMessage = null;
    	if(pgmMessages == null || pgmMessages.size() != 1)	{
    		throw new  UniDirectValidateException("해당 프로그램에 등록된 메세지가 없습니다.");
    	} else {
    		pgmMessage = pgmMessages.get(0);
    	}
    	
    	String message = this.makeMessage(params, ObjUtils.getSafeString(pgmMessage.get("MESSAGE")));
    	pgmMessage.put("MESSAGE", message);
    	
    	//알림수신자 조회
    	
    	List<Map<String, Object>> receiver = this.sendUserList(sParam);
    	
    	//메세지 전송
    	String sendType = ObjUtils.getSafeString(pgmMessage.get("SEND_TYPE"));
    	if("S".equals(sendType)) {				// 시너지톡
    		rMap = (Map) this.sendSynergyTalk(pgmMessage, pgmId,  seq,  divCode, receiver, params, user);
    	} else if("K".equals(sendType))	{		//카카오톡
    		rMap = (Map) this.sendKakaoTalk(pgmMessage, pgmId,  seq,  divCode, receiver, startTime, params, user);
    	} else {								//문자
    		rMap = (Map) this.sendSMS(pgmMessage, pgmId,  seq,  divCode, receiver, startTime , params, user);
    	}
 
    	
    	return rMap;
    	
    }
    
    public String makeMessage(Map<String, Object> data, String message) throws Exception {
    	String rMessage = message;
    	for(Map.Entry<String, Object> entry : data.entrySet())	{
    		String strKey = "{"+entry.getKey()+"}";
    		String sValue = ObjUtils.getSafeString(entry.getValue());
    		if(rMessage.indexOf(entry.getKey()) > -1) {
    			rMessage = GStringUtils.replace(rMessage, strKey, sValue);
    		}
    	}
    	return rMessage;
    }

    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod(group = "base")  
    //pgmMessage, pgmId, receiver, params, user
    public Object  sendSMS( Map<String, Object> pgmMessage, String pgmId, int seq, String divCode, List<Map<String, Object>> receivers, String startTime, Map<String, Object> params, LoginVO user) throws Exception 	{
    	Map sReturn = new HashMap();
    	String strUrl 		= ConfigUtil.getString("common.messengers.sms.url", SMS_URL);
    	String uid  		= ConfigUtil.getString("common.messengers.sms.uid", this.UID);
    	String pwd 			= ConfigUtil.getString("common.messengers.sms.pwd", this.PWD);
    	String fromNumber 	= ConfigUtil.getString("common.messengers.sms.compNumber", this.COMP_NUMBER);
        String toNumbers 	= "";
        String success      = "";
        
    	HttpPost post = new HttpPost(strUrl);
    	post.setHeader("Content-Type", "application/x-www-form-urlencoded;charset=utf-8");
    	
        // add request parameter, form parameters
        List<NameValuePair> urlParameters = new ArrayList<>();
        urlParameters.add(new BasicNameValuePair("uid"			, uid));
        urlParameters.add(new BasicNameValuePair("pwd"			, pwd));  //foren862 MD5 Hash : 1f19ded6402acfa0c496cbb05282951a
        urlParameters.add(new BasicNameValuePair("sendType"		, ObjUtils.getSafeString(pgmMessage.get("SEND_TYPE"), "4")));
        
        if(ObjUtils.isNotEmpty(startTime))	{
        	urlParameters.add(new BasicNameValuePair("startTime",startTime));
        }
        
        if(receivers != null && receivers.size() > 0)	{
        	for(Map<String, Object> receiver : receivers)	{
        		toNumbers += ObjUtils.getSafeString(receiver.get("MOBILE"))+",";
        	}
        	toNumbers = toNumbers.substring(0, toNumbers.length()-1);
        	urlParameters.add(new BasicNameValuePair("toNumber"		, toNumbers));  
        }
        
        urlParameters.add(new BasicNameValuePair("fromNumber"	, fromNumber)); 
        urlParameters.add(new BasicNameValuePair("subId"		, JndiUtils.getEnv("CONTEXT_NAME", "default")  +"|"+pgmId));
        urlParameters.add(new BasicNameValuePair("title"		,  ObjUtils.getSafeString(pgmMessage.get("MESSAGE_SUBJECT"))));
        urlParameters.add(new BasicNameValuePair("contents"		, ObjUtils.getSafeString(pgmMessage.get("MESSAGE"))));
        urlParameters.add(new BasicNameValuePair("nType"		, "0"));
        urlParameters.add(new BasicNameValuePair("returnType"	, "3"));

        post.setEntity(new UrlEncodedFormEntity(urlParameters, "UTF-8"));
       
        try (CloseableHttpClient httpClient = HttpClients.createDefault();
             CloseableHttpResponse response = httpClient.execute(post)) {
        	String responseText = response.toString();
        	logger.debug(response.toString());
        	System.out.println(response.getEntity());
        	HttpEntity entity = response.getEntity();
       	 	String sEntity = EntityUtils.toString(entity);
        	
       	 	if(sEntity.indexOf("SUCCESS") > -1)	{
       	 		success = "Y";
       	 		sReturn.put("success", "Y");
       	 	} else {
       	 		success = "N";
       	 		sReturn.put("success", "N");
       	 	}
         	
        } catch(Exception e)	{
        		sReturn.put("success", "N");
        		sReturn.put("message", e.getMessage());
        		logger.debug(e.toString());
        } finally {
        	this.insertLog(pgmMessage, pgmId, seq, divCode, fromNumber, toNumbers, success, sReturn, user);
        }
        
        return sReturn;
    }
    
    /**
     * @return
     * @throws Exception
     */
    public Object  sendKakaoTalk( Map<String, Object> pgmMessage, String pgmId, int seq, String divCode, List<Map<String, Object>> receivers, String startTime, Map<String, Object> params, LoginVO user) throws Exception 	{
    	Map sReturn = new HashMap();
    	String strUrl 		= ConfigUtil.getString("common.messengers.kakaoTalk.url", KAKAOTALK_URL);
    	String uid  		= ConfigUtil.getString("common.messengers.kakaoTalk.uid", this.UID);
    	String pwd 			= ConfigUtil.getString("common.messengers.kakaoTalk.pwd", this.PWD);
    	String fromNumber 	= ConfigUtil.getString("common.messengers.kakaoTalk.compNumber", this.COMP_NUMBER);
    	String senderKey    = ConfigUtil.getString("common.messengers.kakaoTalk.senderKey", this.SENDER_KEY);
    	String success      = "";
    	String senderKIDs   = "";
    	
    	HttpPost post = new HttpPost(strUrl);
    	post.setHeader("Accept", "application/json");
    	post.setHeader("Content-Type", "application/json");
    	
        JSONObject pJson = new JSONObject();
        pJson.put("uid"				, uid);
        pJson.put("pwd"				, pwd);
        pJson.put("commType"		, "0");
        pJson.put("nType"			, "0");
        pJson.put("returnType"		, "4");
        pJson.put("fromNumber"		, fromNumber);
        pJson.put("senderKey"		, senderKey);
        pJson.put("template_code"	, ObjUtils.getSafeString(pgmMessage.get("TEMPLATE_CODE")));
        pJson.put("subId"			,  JndiUtils.getEnv("CONTEXT_NAME", "default") +"|"+pgmId);
        pJson.put("title"			,  ObjUtils.getSafeString(pgmMessage.get("MESSAGE_SUBJECT")));
        if(ObjUtils.isNotEmpty(startTime))	{
        	pJson.put("startTime",startTime);
        }
        JSONArray jsonArray = new JSONArray();
        for(Map receiver : receivers)	{
	        JSONObject paramJson = new JSONObject();
	        String senderKID = ObjUtils.getSafeString(receiver.get("MOBILE"));
	        if(ObjUtils.isNotEmpty(receiver.get("KAKAOTALK_ID")))	{
	        	senderKID = ObjUtils.getSafeString(receiver.get("KAKAOTALK_ID"));
	        }
	        senderKIDs += senderKID+",";   // 로그 저장용
	        paramJson.put("toNumber", senderKID); // paramJson.put("toNumber", senderKID);
	        paramJson.put("text"	, ObjUtils.getSafeString(pgmMessage.get("MESSAGE")));
	        jsonArray.put(paramJson);
	        
        }
        senderKIDs = senderKIDs.substring(0, senderKIDs.length()-1);
        pJson.put("messages"	, jsonArray);
        post.setEntity(new StringEntity(pJson.toString(),"UTF-8"));
        
        try (CloseableHttpClient httpClient = HttpClients.createDefault();
            CloseableHttpResponse response = httpClient.execute(post)) {
       	 	logger.debug(response.toString());
       	 	HttpEntity entity = response.getEntity();
       	 	String sEntity = EntityUtils.toString(entity);
       	    ObjectMapper mapper = new ObjectMapper();
         	sReturn = mapper.readValue(sEntity, Map.class);
         	success = "Y";	
         	if(!"200".equals(ObjUtils.getSafeString(sReturn.get("code"))))	{
         		success = "N";
         	}
         	for(Map sender : receivers) {
         		//this.insertLog(pgmMessage, sReturn, ObjUtils.getSafeString(sender.get("ID")), success, user);
         	}
         	sReturn.put("success", success);
       } catch(Exception e)	{
       	  	logger.error(e.toString());
       	  	sReturn.put("success", "N");
       	  	sReturn.put("message", e.getMessage());
       } finally {
       		this.insertLog(pgmMessage, pgmId, seq, divCode, fromNumber, senderKIDs, success, sReturn, user);
       }
       
        return sReturn;
    }
    
    public Object sendSynergyTalk(Map<String, Object> pgmMessage, String pgmId, int seq, String divCode, List<Map<String, Object>> receivers, Map<String, Object> params, LoginVO user) throws Exception 	{
    	Map<String, Object> rMap = new HashMap<>(); 
    	
    	String synergTalk_url = ConfigUtil.getString("common.messengers.synergyTalk.url", SYNERGYTAL_URL);
    	String success = "";
    	
		Map<String, Object> requestMap = new HashMap<>();
		
		String senderIds = "";
		String receiveIds = "";
		if(receivers != null && receivers.size() > 0)	{
			for(Map receiver: receivers){
				senderIds = ObjUtils.getSafeString(receiver.get("SENDER_ID"));
				receiveIds = receiveIds + ObjUtils.getSafeString(receiver.get("RECEIVE_ID"))+ ",";
			}
			receiveIds = receiveIds.substring(0, receiveIds.length()-1);
		}
		String title = ObjUtils.getSafeString(pgmMessage.get("MESSAGE_SUBJECT"));
		String message =  ObjUtils.getSafeString(pgmMessage.get("MESSAGE"));
		message = GStringUtils.replace(message, "\n", "<br/>");
    	
		Map<String, Object> msgParamMap = new HashMap<String, Object>();
		msgParamMap.put("asAdmin"		, "Y");					// Y 셋팅
		msgParamMap.put("notiApi"		, "Y");					// Y 셋팅
			
		msgParamMap.put("dmlUid"		, senderIds);			//발송자
		msgParamMap.put("ruidList"		, receiveIds);			//수신자 (구분자 ',')
		msgParamMap.put("dmlTitle"		, title);				//메세지 제목
		msgParamMap.put("dmlContentHtml", message);				//메세지 내용 (html 사용가능, 이미지,link 등..)
		
		Map<String,Object> apiInfoDataMap = new HashMap<>();
		apiInfoDataMap.put("type", "notice");
		msgParamMap.put("apiInfoData", apiInfoDataMap);			//type=notice 로 셋팅

		//전송 메시지부 세팅
		requestMap.put("messages", msgParamMap);

		//옵션파라메터 생성
		Map<String, Object> optParamMap = new HashMap<>();
		optParamMap.put("immediatelyYn", "Y");			//즉시전송여부 Y로 셋팅
		optParamMap.put("inflowType", "OMEGA_PLUS");	//시너지톡 타입구분
		optParamMap.put("inflowIdtId", 1234);			//시너지톡 타입구분별 식별키 (필수값 아님..)
		optParamMap.put("resendYn", "N");				// N 으로 셋팅

		//전송 메시지 옵션부 세팅
		requestMap.put("options", optParamMap);

		RestTemplate restTemplate = new RestTemplate();
		HttpHeaders headers = new HttpHeaders();
		MediaType mediaType = new MediaType("application", "json", Charset.forName("UTF-8"));
		headers.setContentType(mediaType);

		try {
			requestMap.put("accesskey", encryptEcb("orgidencryptcode", "SYNERGY"));
		} catch (Exception e) {
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		
		ObjectMapper mapper = new ObjectMapper();
		org.springframework.http.HttpEntity<String> entity = new org.springframework.http.HttpEntity<String>(
				 mapper.writeValueAsString(requestMap)
				,headers);
		logger.debug(entity.toString());
		try {
			logger.debug("synergTalk_url : "+synergTalk_url);
			restTemplate.postForObject(synergTalk_url, entity, Map.class);		//	2021.04.16 PASS 그룹웨어 시스템 자바 등 프레임워크 버전 업과 더불어 시너지톡 API 서버 이전으로 인해 IP 변경됨.
			success = "Y";
			logger.debug("전송 완료");
    	} catch(Exception e) {
    		success = "N";
    		rMap.put("message", e.getMessage());
    		logger.debug("전송 오류");
    		logger.error(e.getMessage());
			e.printStackTrace();
    	} finally {
    		rMap.put("success", success);
    		this.insertLog(pgmMessage, pgmId, seq, divCode, senderIds, receiveIds, success, rMap, user);
    	}
       
        return rMap;
    }
    
    protected void insertLog(Map<String, Object> pgmMessage, String pgmId, int seq, String divCode, String sender, String receivers, String success, Map<String, Object> result, LoginVO user) throws Exception	{
    	Map logParam = new HashMap();
    	
    	logParam.put("PGM_ID", pgmId);
    	logParam.put("SEQ", seq);
    	logParam.put("DIV_CODE", divCode);
    	logParam.put("SEND_TYPE", pgmMessage.get("SEND_TYPE"));
    	logParam.put("MESSAGE_SUBJECT", pgmMessage.get("MESSAGE_SUBJECT"));
    	logParam.put("MESSAGE", pgmMessage.get("MESSAGE"));
    	logParam.put("SENDER", sender);
    	logParam.put("RECEIVERS", receivers);
    	logParam.put("SUCCESS", success);
    	logParam.put("RESULT_CODE", result.get("code"));
    	logParam.put("RESULT_MESSAGE", result.get("message"));
    	
    	int r = bif100ukrvService.insertLog(logParam, user);
    }
    
    @ExtDirectMethod( group = "base" )
    public List<Map<String, Object>> sendMessageList( Map param ) throws Exception {
        return super.commonDao.list("bif100ukrvServiceImpl.selectList", param);
    }
    
    /**
     * 발신자/수신자 정보
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( group = "base")
    public List<Map<String, Object>> sendUserList( Map param ) throws Exception {
        return super.commonDao.list("bif100ukrvServiceImpl.selectUserList", param);
    }
    
    private static String encryptEcb(String sKey, String sText) throws Exception {
		byte[] key = null;
		byte[] text = null;
		byte[] encrypted = null;

		Date now = new Date();

		SimpleDateFormat sdf = new SimpleDateFormat("hhmmss");
		sText += sdf.format(now);
		try {
			key = sKey.getBytes();

			// UTF-8
			text = sText.getBytes("UTF-8");

			// AES/EBC/PKCS5Padding
			Cipher cipher = Cipher.getInstance("AES/ECB/PKCS5Padding");
			cipher.init(Cipher.ENCRYPT_MODE, new SecretKeySpec(key, "AES"));
			encrypted = cipher.doFinal(text);
		} catch (Exception e) {
			encrypted = null;
			e.printStackTrace();
			//LOGEER.warn("ERROR............................", e);
		}

		String enStr = new String(Base64.encodeBase64(encrypted));
		return enStr;
	}
}
