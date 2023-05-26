package foren.unilite.modules.com.common;

import java.nio.charset.Charset;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.crypto.Cipher;
import javax.crypto.spec.SecretKeySpec;

import org.codehaus.jackson.map.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.mail.MailSender;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.BindingResult;
import org.springframework.web.client.RestTemplate;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

import org.apache.tomcat.util.codec.binary.Base64;

@Service("synergyTalkService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class SynergyTalkServiceImpl  extends TlabAbstractServiceImpl {

	 private final Logger logger = LoggerFactory.getLogger(this.getClass());


//		시너지톡 전송
	//
//		호출url : http://210.122.36.151/ezmaru/message
	//
//		{
//			accesskey=keyValue, 							/* accesskey */
//			options={
//						immediatelyYn=Y,					/* 즉시전송여부 무조건 Y로 셋팅 */
//						inflowType=WEEK_REPORT_SEND_MSG, 	/*시너지톡 전송구분 : 필수*/
//						inflowIdtId=68152,				 	/*시너지톡 전송구분 식별값 : 필수아님*/
//						resendYn=N							/*재전송여부 무조건 N로 셋팅 */
//			},
//			messages={
//						asAdmin=Y,							/* 무조건 Y로 셋팅 */
//						dmlContentHtml=<div style='border:1px solid #ddd;padding:10px;'><strong>Processing</strong><br>[2020-09-23] <br>테스트 등록 합니다....<br></div>, /* 메세지내용 */
//						dmlUid=sjp,							/* 보내는사람 loginId */
//						apiInfoData={type=notice},			/* type=notice 로 셋팅 */
//						dmlTitle=제목을 등록합니다.,				/* 메세지제목 */
//						ruidList=kwpark,					/* 받는사람 loginId */
//						notiApi=Y							/* notiApi=Y 로 셋팅 */
//			}
//		}

		@ExtDirectMethod(group = "base")
		public Map<String, Object> synergyTalkSendTest(String keyValue) throws Exception {
			Map<String, Object> resMap = null;
			Map<String,Object> msgLogMap = new HashMap<String, Object>(); //메세지 로그 맵
			String senderId		     = "";
			String receiveId         = "";
			String messageSubject    = "";
			String messageText       = "";




			//받아온 로그키에 해당하는 값을 메세지 로그 테이블에서 불러와서 맵에 담아서 처리함
			msgLogMap.put("KEY_VALUE", keyValue);
			msgLogMap = (Map<String, Object>) super.commonDao.queryForObject("synergyTalkServiceImpl.messageLogInfo", msgLogMap);
			if(ObjUtils.isNotEmpty(msgLogMap)){
				senderId 		= (String) msgLogMap.get("SENDER_ID");
				receiveId		= (String) msgLogMap.get("RECEIVE_ID");
				messageSubject  = (String) msgLogMap.get("MESSAGE_SUBJECT");
				messageText     = (String) msgLogMap.get("MESSAGE_TEXT");
			}
			//쪽지 발송 API Request Body 내용
			Map<String,Object> requestMap = new HashMap<>();

			//accesskey 셋팅
			requestMap.put("accesskey", encryptEcb("orgidencryptcode", "SYNERGY"));
			
			SimpleDateFormat format1 = new SimpleDateFormat ( "yyyy년 MM월dd일 HH시mm분");
	    	Date time = new Date();
	    	String time1 = format1.format(time);
	    	
			Map<String, Object> msgParamMap = new HashMap<String, Object>();
//			msgParamMap.put("asAdmin"		, "Y");					// Y 셋팅		전달,답장, 첨부파일 기능을 사용하기 위해 주석처리함
			msgParamMap.put("notiApi"		, "Y");					// Y 셋팅

			msgParamMap.put("dmlUid"		, senderId);//"insect0323");			//발송자
			msgParamMap.put("ruidList"		, receiveId);//"bhyoon");			//수신자 (구분자 ',')
			msgParamMap.put("dmlTitle"		, messageSubject + " ("+time1+")");		//메세지 제목
			msgParamMap.put("dmlContentHtml", messageText);			//메세지 내용 (html 사용가능, 이미지,link 등..)

//			전달,답장, 첨부파일 기능을 사용하기 위해 주석처리함
//			Map<String,Object> apiInfoDataMap = new HashMap<>();
//			apiInfoDataMap.put("type", "notice");
//			msgParamMap.put("apiInfoData", apiInfoDataMap);		//type=notice 로 셋팅

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

			ObjectMapper mapper = new ObjectMapper();
			HttpEntity<String> entity = new HttpEntity<String>(mapper.writeValueAsString(requestMap),headers);
			//resMap = restTemplate.postForObject("http://210.122.36.151/ezmaru/message", entity, Map.class);
			resMap = restTemplate.postForObject("http://210.122.36.253/ezmaru/message", entity, Map.class);		//	2021.04.16 PASS 그룹웨어 시스템 자바 등 프레임워크 버전 업과 더불어 시너지톡 API 서버 이전으로 인해 IP 변경됨.

			return resMap;
		}

		public static String encryptEcb(String sKey, String sText) throws Exception {
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

	  @ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	  public String syTalkMessageMake(Map<String, Object> params, String keyValue, LoginVO user) throws Exception {

		  //메세지 메인 정보를 가져오기 위한  맵 선언
			Map<String, Object> msgMap = new HashMap<String, Object>();
			String msgText = "";
		  //메세지 정보 가져오는 쿼리
			msgMap = (Map<String, Object>) super.commonDao.queryForObject("synergyTalkServiceImpl.programMessageMainInfo", params);
			if(ObjUtils.isNotEmpty(msgMap)){
				msgMap.put("USER_ID", user.getUserID());
				msgMap.put("COMP_CODE", user.getCompCode());
				msgText = (String) msgMap.get("MESSAGE");
				//화면에서 넘긴 dataMaster맵의 KEY값과 메세지 내용의 키값과 같은 값을 찾아 메세지를 완성시킨다.
				for(int i = 1; i <= (int) msgMap.get("PARAM_CNT"); i++){
					for( String key: params.keySet()){
						if(msgText.indexOf("{") != -1 && msgText.indexOf("}") != -1){
							if(key.equals(msgText.substring(msgText.indexOf("{") + 1, msgText.indexOf("}")))){
								msgText = msgText.replaceAll("\\" + msgText.substring(msgText.indexOf("{"), msgText.indexOf("}")+1), (String) params.get(key));
								logger.debug("[[msgText]]" + msgText);
							}
						}

					}
				}
				msgMap.put("KEY_VALUE",keyValue);
				msgMap.put("MESSAGE_TEXT", msgText);
				super.commonDao.insert("synergyTalkServiceImpl.insertMessageLog", msgMap);
			}

			return msgText;
	  }


}
