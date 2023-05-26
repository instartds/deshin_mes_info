package foren.unilite.modules.com.scheduler;
import java.net.InetAddress;
import java.nio.charset.Charset;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.crypto.Cipher;
import javax.crypto.spec.SecretKeySpec;
import javax.servlet.ServletContext;

import org.apache.tomcat.util.codec.binary.Base64;
import org.codehaus.jackson.map.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;

import foren.framework.model.LoginVO;
import foren.framework.utils.ConfigUtil;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;


/**
 *  수주미납정보 send
 */ 
@Component
public class ScheduleSof extends TlabAbstractServiceImpl{
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@Resource(name="schedulerService")
	private SchedulerServiceImpl schedulerService;
	
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

	@Autowired
    private ServletContext servletContext;
	
	public void synergyTalkSend()  throws Exception {
		String context = servletContext.getContextPath();
		logger.debug(context);
//		omegaplus.xml
//		<scheduler>
//			<synergyTalkSend>true</synergyTalkSend>
//		</scheduler>		
		String xmlSTSFlag = ConfigUtil.getString("common.scheduler.synergyTalkSend", "false");
		if(xmlSTSFlag.equals("true")){
			if(context.equals("/omegaplusshin")){
				LoginVO user = new LoginVO();
				Map<String, Object> resMap = null;
				Map<String,Object> requestMap = new HashMap<>();
		
				Map<String,Object> param = new HashMap<String, Object>();
				String messages = "";
				//미납현황데이터
				param.put("S_COMP_CODE", user.getCompCode());
				List<Map<String, Object>> mList = schedulerService.selectSof100(param);
				
				//send, receive ID
				param.put("S_COMP_CODE", user.getCompCode());
				List<Map<String, Object>> idList = schedulerService.selectSyTalkId(param);
			
				if(ObjUtils.isNotEmpty(idList) && ObjUtils.isNotEmpty(mList)){
		
					String senderIds = "";
					String receiveIds = "";
					
					for(Map rtnMap: idList){
						senderIds = ObjUtils.getSafeString(rtnMap.get("SENDER_ID"));
						receiveIds = receiveIds + ObjUtils.getSafeString(rtnMap.get("RECEIVE_ID"))+ ",";
					}
					
					//메세지 타이틀 및 메세지 sub 
					Map<String, Object> msObj = schedulerService.selectBif100(param);
					String title = "";
					String s_messages = "";
					if(ObjUtils.isNotEmpty(msObj)){
						title = ObjUtils.getSafeString(msObj.get("MESSAGE_SUBJECT"));
						s_messages = ObjUtils.getSafeString(msObj.get("MESSAGE"));
					}
					
					SimpleDateFormat format1 = new SimpleDateFormat ( "yyyy년 MM월dd일 HH시mm분");
			    	Date time = new Date();
			    	String time1 = format1.format(time);
			    	
			    	title = title + " ("+time1+")";
					
					messages = "<table class='table'><thead><tr class='text-center'><th>수주번호</th><th>거래처</th><th>담당자</th><th>납기일</th></tr></thead><tbody>";
		
					int idx = 0;
					for(Map rtnMap: mList){
						messages += "<tr class='text-center'><td>"+ObjUtils.getSafeString(rtnMap.get("ORDER_NUM"))+"</td><td>"+ObjUtils.getSafeString(rtnMap.get("CUSTOM_NAME"))+"</td><td>"+ObjUtils.getSafeString(rtnMap.get("ORDER_PRSN"))+"</td><td>"+ObjUtils.getSafeString(rtnMap.get("DVRY_DATE"))+"</td></tr>";
						if(idx == mList.size()){
							messages += "</tbody></table>";
						}
						idx++;
					}
					
//					납기도래 수주정보입니다.
//					수주번호	거래처	담당자	납기일
//					2106B630	한국콜마(주)부천지점	김민지	20210811
//					2106B631	한국콜마(주)부천지점	김민지	20210811
//					2107B610	주식회사 에버코스	김민지	20210811
//					2107B714	(주)아모레퍼시픽	전지현	20210811
					messages = "<h3>" + s_messages + "</h3>" + messages;
					
					//accesskey 셋팅
					try {
						requestMap.put("accesskey", encryptEcb("orgidencryptcode", "SYNERGY"));
					} catch (Exception e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
			
					Map<String, Object> msgParamMap = new HashMap<String, Object>();
					msgParamMap.put("asAdmin"		, "Y");					// Y 셋팅
					msgParamMap.put("notiApi"		, "Y");					// Y 셋팅
						
					msgParamMap.put("dmlUid"		, senderIds);//"insect0323");//senderIds);			//발송자
					msgParamMap.put("ruidList"		, receiveIds);//"insect0323,bhyoon");//receiveIds);			//수신자 (구분자 ',')
					msgParamMap.put("dmlTitle"		, title);//title);		//메세지 제목
					msgParamMap.put("dmlContentHtml", messages);//messages);			//메세지 내용 (html 사용가능, 이미지,link 등..)
			
					Map<String,Object> apiInfoDataMap = new HashMap<>();
					apiInfoDataMap.put("type", "notice");
					msgParamMap.put("apiInfoData", apiInfoDataMap);		//type=notice 로 셋팅
			
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
					restTemplate.postForObject("http://210.122.36.253/ezmaru/message", entity, Map.class);		//	2021.04.16 PASS 그룹웨어 시스템 자바 등 프레임워크 버전 업과 더불어 시너지톡 API 서버 이전으로 인해 IP 변경됨.
		
		            logger.debug("전송");
					//resMap = restTemplate.postForObject("http://210.122.36.151/ezmaru/message", entity, Map.class);
	
		        }
			}
		}
	}
// 
//    @Autowired
//    private SchedulerDao schedulerDao;
    //cron 표현식의 몇가지 예)
    // * - 전체 값을 의미
    //("0 0 * * * *") : 매일 매시 정각
    //("*/10 * * * * *") : 0, 10, 20, 30, 40, 50 초
    //("0 0 8-10 * * *") : 매일 8시, 9시, 10시 정각
    //("0 0/30 8-10 * * *") : 매일 8시, 8시 30분, 9시, 9시 30분, 10시
    //("0 0 9-18 * * 1-5") : 매주 월요일부터 금요일의 9시부터 오후 6시까지 매시
	
	//0초 0분 9시  1-5(월~금)에 실행
    @Scheduled(cron = "0 0 9 * * 1-5")
    public void cron1(){
        try {
        	SimpleDateFormat format1 = new SimpleDateFormat ( "yyyy-MM-dd HH:mm:ss" );
//        	SimpleDateFormat format2 = new SimpleDateFormat ( "yyyy년 MM월dd일 HH시mm분ss초");
        	Date time = new Date();
        	String time1 = format1.format(time);
        	synergyTalkSend();
            System.out.println("스케줄러 -"+time1);
            log.info("스케줄러 -"+time1);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}