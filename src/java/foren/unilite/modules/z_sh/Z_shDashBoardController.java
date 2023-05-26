package foren.unilite.modules.z_sh;

import java.io.File;
import java.io.InputStream;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.TimeUnit;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

//import org.apache.kafka.clients.consumer.ConsumerRecord;
//import org.apache.kafka.clients.consumer.ConsumerRecords;
//import org.apache.kafka.clients.consumer.KafkaConsumer;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.jcraft.jsch.Channel;
import com.jcraft.jsch.ChannelExec;
import com.jcraft.jsch.JSch;
import com.jcraft.jsch.Session;

import foren.framework.model.LoginVO;
import foren.framework.utils.ConfigUtil;
import foren.framework.utils.ObjUtils;
import foren.framework.web.view.ViewHelper;

/**
 * kiosk 금형정보,불량정보 
 * @author chaeseongmin
 *
 */
@Controller
@RequestMapping("/z_dsh")
public class Z_shDashBoardController {
	final static String		JSP_PATH	= "/z_dsh/";

	private static final Logger logger = LoggerFactory.getLogger(Z_shDashBoardController.class);
	

	@Resource(name = "s_dsh100ukrv_shService")
	private S_dsh100ukrv_shServiceImpl s_dsh100ukrv_shService;
	
	@RequestMapping(value = "/s_test777.do")
	public String s_test777(ModelMap model, HttpServletRequest request, LoginVO loginVo) throws Exception {

		model.addAttribute("compCode"	, loginVo.getCompCode());
		model.addAttribute("divCode"	, loginVo.getDivCode());
		model.addAttribute("userId"	, loginVo.getUserID());
		
		return JSP_PATH + "s_test777";
	}	
	
	@RequestMapping(value = "/s_test888.do")
	public String s_test888(ModelMap model, HttpServletRequest request, LoginVO loginVo) throws Exception {

		model.addAttribute("compCode"	, loginVo.getCompCode());
		model.addAttribute("divCode"	, loginVo.getDivCode());
		model.addAttribute("userId"	, loginVo.getUserID());
		
		return JSP_PATH + "s_test888";
	}
	
	@RequestMapping(value = "/s_test999.do")
	public String s_test999(ModelMap model, HttpServletRequest request, LoginVO loginVo) throws Exception {

		model.addAttribute("compCode"	, loginVo.getCompCode());
		model.addAttribute("divCode"	, loginVo.getDivCode());
		model.addAttribute("userId"	, loginVo.getUserID());
		
		return JSP_PATH + "s_test999";
	}
	
	
	
	
	@RequestMapping(value = "/s_dsh100ukrv_sh1.do")
	public String s_dsh100ukrv_sh1(ModelMap model, HttpServletRequest request, LoginVO loginVo) throws Exception {

		model.addAttribute("compCode"	, loginVo.getCompCode());
		model.addAttribute("divCode"	, loginVo.getDivCode());
		model.addAttribute("userId"	, loginVo.getUserID());
		
		return JSP_PATH + "s_dsh100ukrv_sh1";
	}
	
	@RequestMapping(value = "/s_dsh100ukrv_sh2.do", method = RequestMethod.POST)
	public String s_dsh100ukrv_sh2(ModelMap model, HttpServletRequest request, LoginVO loginVo,
							@RequestParam(value="equipCode") String equipCode,
							@RequestParam(value="equipName") String equipName,
							@RequestParam(value="inspecPrsn") String inspecPrsn,
							@RequestParam(value="inspecPrsnName") String inspecPrsnName
	) throws Exception {

		model.addAttribute("compCode"	, loginVo.getCompCode());
		model.addAttribute("divCode"	, loginVo.getDivCode());
		model.addAttribute("userId"	, loginVo.getUserID());
		String path = ConfigUtil.getUploadBasePath("equip", true);
		
		model.addAttribute("equipImagePath"	, path);

		model.addAttribute("equipCode"	, equipCode);
		model.addAttribute("equipName"	, equipName);
		model.addAttribute("inspecPrsn"	, inspecPrsn);
		model.addAttribute("inspecPrsnName"	,inspecPrsnName);
		
		return JSP_PATH + "s_dsh100ukrv_sh2";
	}
	
	
	/**
	 * 각 호기당 ACT_SHOT_CNT
			,ACT_CYCLE_TIME
	 * @param param
	 * @param loginVo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value= "/getEquipInfo.do")
	@ResponseBody
	public List<Map<String, Object>> getEquipInfo(@RequestParam Map<String, Object> param, LoginVO loginVo) throws Exception{
		param.put("S_COMP_CODE", loginVo.getCompCode());
		param.put("S_DIV_CODE", loginVo.getDivCode());
		List<Map<String, Object>> list = s_dsh100ukrv_shService.getEquipInfo(param);
		return list;
	}
	
	/**
	 * 온,습도 
	 * @param param
	 * @param loginVo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value= "/getTemperature.do")
	@ResponseBody
	public List<Map<String, Object>> getTemperature(@RequestParam Map<String, Object> param, LoginVO loginVo) throws Exception{
		param.put("S_COMP_CODE", loginVo.getCompCode());
		param.put("S_DIV_CODE", loginVo.getDivCode());
		List<Map<String, Object>> list = s_dsh100ukrv_shService.getTemperature(param);
		return list;
	}

	
	/**
	 * 대시보드 운영상태 차트
	 * @param param
	 * @param loginVo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value= "/getOperatingStatus.do")
	@ResponseBody
	public List<Map<String, Object>> getOperatingStatus(@RequestParam Map<String, Object> param, LoginVO loginVo) throws Exception{
		param.put("S_COMP_CODE", loginVo.getCompCode());
		param.put("S_DIV_CODE", loginVo.getDivCode());
		List<Map<String, Object>> list = s_dsh100ukrv_shService.getOperatingStatus(param);
		return list;
	}
	
	/**
	 * 대시보드 그리드 표현 
	 * @param param
	 * @param loginVo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value= "/getOpsearch.do")
	@ResponseBody
	public List<Map<String, Object>> getOpsearch(@RequestParam Map<String, Object> param, LoginVO loginVo) throws Exception{
		param.put("S_COMP_CODE", loginVo.getCompCode());
		param.put("S_DIV_CODE", loginVo.getDivCode());
		List<Map<String, Object>> list = s_dsh100ukrv_shService.getOpsearch(param);
		return list;
	}
	
	/**
	 * 실시간 온도 line 차트 
	 * @param model
	 * @param request
	 * @param loginVo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/s_dsh100ukrv_sh3.do")
	public String s_dsh100ukrv_sh3(ModelMap model, HttpServletRequest request, LoginVO loginVo) throws Exception {

		model.addAttribute("compCode"	, loginVo.getCompCode());
		model.addAttribute("divCode"	, loginVo.getDivCode());
		model.addAttribute("userId"	, loginVo.getUserID());
		
		return JSP_PATH + "s_dsh100ukrv_sh3";
	}
	
	
	
	
	/**
	 * 대시보드 설비정보 세팅
	 * @param param
	 * @param loginVo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value= "/getEquipCodeDashMenu.do")
	@ResponseBody
	public List<Map<String, Object>> getEquipCodeDashMenu(@RequestParam Map<String, Object> param, LoginVO loginVo) throws Exception{
		
		param.put("S_COMP_CODE", loginVo.getCompCode());
		param.put("S_DIV_CODE", loginVo.getDivCode());
		List<Map<String, Object>> list = s_dsh100ukrv_shService.getEquipCodeDashMenu(param);
		return list;
	}
	
	@RequestMapping(value = "/s_dsh100skrv_sh1.do")
	public String s_dsh100skrv_sh1(ModelMap model, HttpServletRequest request, LoginVO loginVo) throws Exception {

		model.addAttribute("compCode"	, loginVo.getCompCode());
		model.addAttribute("divCode"	, loginVo.getDivCode());
		model.addAttribute("userId"	, loginVo.getUserID());
		
		return JSP_PATH + "s_dsh100skrv_sh1";
	}
	
	
	@RequestMapping(value = "/s_dsh100skrv_sh2.do", method = RequestMethod.POST)
	public String s_dsh100skrv_sh2(ModelMap model, HttpServletRequest request, LoginVO loginVo,
			@RequestParam(value="equipCode") String equipCode,
			@RequestParam(value="equipName") String equipName
	) throws Exception {
		String aa = "";

		
		
		
		
		
		model.addAttribute("equipCode"	, equipCode);
		model.addAttribute("equipName"	, equipName);
		
		model.addAttribute("compCode"	, loginVo.getCompCode());
		model.addAttribute("divCode"	, loginVo.getDivCode());
		model.addAttribute("userId"	, loginVo.getUserID());
		
		
		
		
		return JSP_PATH + "s_dsh100skrv_sh2";
	}
	
	
	
	
	/**
	 * 작업자정보 세팅
	 * @param param
	 * @param loginVo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value= "/getInspecPrsn.do")
	@ResponseBody
	public List<Map<String, Object>> getInspecPrsn(@RequestParam Map<String, Object> param, LoginVO loginVo) throws Exception{
		
		param.put("S_COMP_CODE", loginVo.getCompCode());
		param.put("S_DIV_CODE", loginVo.getDivCode());
		List<Map<String, Object>> list = s_dsh100ukrv_shService.getInspecPrsn(param);
		return list;
	}
	
	/**
	 * 설비정보 세팅
	 * @param param
	 * @param loginVo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value= "/getEquipCode.do")
	@ResponseBody
	public List<Map<String, Object>> getEquipCode(@RequestParam Map<String, Object> param, LoginVO loginVo) throws Exception{
		
		param.put("S_COMP_CODE", loginVo.getCompCode());
		param.put("S_DIV_CODE", loginVo.getDivCode());
		List<Map<String, Object>> list = s_dsh100ukrv_shService.getEquipCode(param);
		return list;
	}
	
	/**
	 * 작지데이터 리스트 세팅
	 * @param param
	 * @param loginVo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value= "/getWkordNum2.do")
	@ResponseBody
	public List<Map<String, Object>> getWkordNum2(@RequestParam Map<String, Object> param, LoginVO loginVo) throws Exception{
		param.put("S_COMP_CODE", loginVo.getCompCode());
		param.put("S_DIV_CODE", loginVo.getDivCode());
		List<Map<String, Object>> list = s_dsh100ukrv_shService.getWkordNum2(param);
		return list;
	}
	
	/**
	 * 각 작업지시번호데이터에 해당되는 부품사진정보
	 * @param imageFid
	 * @param fExt
	 * @param model
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/dsh100ukrvPhoto/{imageFid}.{fExt}" )
	public ModelAndView dsh100ukrvPhoto( @PathVariable( "imageFid" ) String imageFid, @PathVariable( "fExt" ) String fExt, ModelMap model, HttpServletRequest request ) throws Exception {
		String path = ConfigUtil.getUploadBasePath("equip", true);
		
		//application id\context id\equip
		logger.debug(" ###################  path :"+path);
		logger.debug(" ###################  file :"+imageFid+"."+fExt);
		File photo =  new File(path, imageFid+"."+fExt);
		if (photo == null || !photo.canRead()) {
			//			String url = "/resources/images/human/noPhoto.png";
			//			return new ModelAndView("redirect:"+url);
			path = request.getServletContext().getRealPath("/resources/images/");
			photo = new File(path, "item_noImage.png");
		}
		
		return ViewHelper.getImageView(photo);
	}
	
	
	
	
	/**
	 * 불량유형 리스트 세팅 
	 * @param param
	 * @param loginVo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value= "/getBadInspecCode.do")
	@ResponseBody
	public List<Map<String, Object>> getBadInspecCode(@RequestParam Map<String, Object> param, LoginVO loginVo) throws Exception{
		param.put("S_COMP_CODE", loginVo.getCompCode());
		param.put("S_DIV_CODE", loginVo.getDivCode());
		List<Map<String, Object>> list = s_dsh100ukrv_shService.getBadInspecCode(param);
		return list;
	}
	
	/**
	 * 해당작업지시에 대한 불량코드별 불량수량 합 세팅
	 * @param param
	 * @param loginVo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value= "/getBadInspecQList.do")
	@ResponseBody
	public List<Map<String, Object>> getBadInspecQList(@RequestParam Map<String, Object> param, LoginVO loginVo) throws Exception{
		param.put("S_COMP_CODE", loginVo.getCompCode());
		param.put("S_DIV_CODE", loginVo.getDivCode());
		List<Map<String, Object>> list = s_dsh100ukrv_shService.getBadInspecQList(param);
		return list;
	}
	
	/**
	 * 각 작지데이터 시작 정보 insert
	 * @param param
	 * @param loginVo
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/startSave.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> startSave(@RequestParam Map<String, Object> param, LoginVO loginVo, Model model) throws Exception {
		param.put("S_COMP_CODE", loginVo.getCompCode());
		param.put("S_DIV_CODE", loginVo.getDivCode());
		param.put("S_USER_ID", loginVo.getUserID());
		
//		시작시 계속 INSERT하기 위해 주석처리
//		Map<String, Object> checkMap = s_dsh100ukrv_shService.getStartInfo(param);
		Map<String, Object> map = new HashMap<String, Object>();
		try{
//			if(checkMap!= null){
//				map.put("status","1");
//				map.put("msg", "이미 시작되었습니다.");
//			}else{
				map = s_dsh100ukrv_shService.startSave(param);
//			}
		}catch(Exception e){
			map = null;
			e.printStackTrace();
		}
		return map;
	}
	
	
	/**
	 * 불량코드별 불량수량 정보 insert
	 * @param param
	 * @param loginVo
	 * @param model
	 * @return
	 * @throws Exception
	 */
		@RequestMapping(value = "/badInspecQSave.do", method = RequestMethod.POST)
		@ResponseBody
		public Map<String, Object> badInspecQSave(@RequestParam Map<String, Object> param, LoginVO loginVo, Model model) throws Exception {
			param.put("S_COMP_CODE", loginVo.getCompCode());
			param.put("S_DIV_CODE", loginVo.getDivCode());
			param.put("S_USER_ID", loginVo.getUserID());
			
			Map<String, Object> map = new HashMap<String, Object>();
			try{
				map = s_dsh100ukrv_shService.badInspecQSave(param);
			}catch(Exception e){
				map = null;
				e.printStackTrace();
			}
			return map;
		}

	/**
	 * 각 작지데이터의 원료 투입량 update
	 * @param param
	 * @param loginVo
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/itemMtrlSave.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> itemMtrlSave(@RequestParam Map<String, Object> param, LoginVO loginVo, Model model) throws Exception {
		param.put("S_COMP_CODE", loginVo.getCompCode());
		param.put("S_DIV_CODE", loginVo.getDivCode());
		param.put("S_USER_ID", loginVo.getUserID());
		
		Map<String, Object> map = new HashMap<String, Object>();
		try{
			map = s_dsh100ukrv_shService.itemMtrlSave(param);

		}catch(Exception e){
			map = null;
			e.printStackTrace();
		}
		return map;
	}

	
	
	/**
	 * 설비 setup정보
	 * @param param
	 * @param loginVo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value= "/getSetup.do")
	@ResponseBody
	public List<Map<String, Object>> getSetup(@RequestParam Map<String, Object> param, LoginVO loginVo) throws Exception{
		param.put("S_COMP_CODE", loginVo.getCompCode());
		param.put("S_DIV_CODE", loginVo.getDivCode());
		List<Map<String, Object>> list = s_dsh100ukrv_shService.getSetup(param);
		return list;
	}
	
	
	
	
	/**
	 * 사출기 setSetup
	 * @param param
	 * @param loginVo
	 * @return
	 * @throws Exception
	 */
	private int BUFFER_SIZE = 1024;
	
	@RequestMapping(value= "/setSetup.do")
	@ResponseBody
	public int setSetup(@RequestParam Map<String, Object> param, LoginVO loginVo, HttpServletRequest request ) throws Exception{
		param.put("S_COMP_CODE", loginVo.getCompCode());
		param.put("S_DIV_CODE", loginVo.getDivCode());
		
		
		String pW = "";
		String eM = "";
		
		//비밀번호 확인
		Map<String, Object> checkPWMap = s_dsh100ukrv_shService.getEquipPassword(param);
		if(ObjUtils.isNotEmpty(checkPWMap)){
			pW = ObjUtils.getSafeString(checkPWMap.get("PW"));
		}else{
			return 77;
		}
		if(!param.get("PASSWORD").equals(pW)){
			return 77;
		}
		
		
		//해당 사출기 제조사확인
		Map<String, Object> checkEMMap = s_dsh100ukrv_shService.getEquipManufacturer(param);
		if(ObjUtils.isNotEmpty(checkEMMap)){
			eM = ObjUtils.getSafeString(checkEMMap.get("EM"));
		}else{
			return 99;
		}
		if(!eM.equals("DS")){
			//저장가능한 사출기가 아닐시
			return 99;
		}else{
		
			Map<String, Object> testMap = new HashMap<String, Object>();

//      String host = "192.168.0.230";
//      int    port = 49101;
			String host = "115.95.112.18";
			int port = 9101;
			String username = "innoequip";
			String password = "equip6222";
	      
			System.out.println("==> Connecting to" + host);
			Session session = null;
			Channel channel = null;
	      
			String equipCode = ObjUtils.getSafeString(param.get("EQUIP_CODE"));
			String coreCode = ObjUtils.getSafeString(param.get("CORE_CODE"));
	      
			String rtnV = "";
			String rtnE = "";
	      
	
	      // 2. 세션 객체를 생성한다 (사용자 이름, 접속할 호스트, 포트를 인자로 준다.)
	   //   try {
	          // 1. JSch 객체를 생성한다.
			JSch jsch = new JSch();
			session = jsch.getSession(username, host, port);
	
	          // 3. 패스워드를 설정한다.
	        session.setPassword(password);
	
	          // 4. 세션과 관련된 정보를 설정한다.
	        java.util.Properties config = new java.util.Properties();
	          // 4-1. 호스트 정보를 검사하지 않는다.
	        config.put("StrictHostKeyChecking", "no");
	        session.setConfig(config);
	
	          // 5. 접속한다.
	        session.connect();
	
	          // 6. sftp 채널을 연다.
	        channel = session.openChannel("exec");
	
	          // 8. 채널을 SSH용 채널 객체로 캐스팅한다
	        ChannelExec channelExec = (ChannelExec) channel;
	
	        channelExec.setCommand("python3 mes_get_inj_setup_save.py "+ equipCode+" "+ coreCode);
	          
	          
	       // null이면 입력이 없다는 뜻. System.in 을 지정할 경우 스트림이 안 닫히기 때문에 종료가 안되는 듯.
	        channelExec.setInputStream(null);
	           
	          // 출력 스트림을 명시적으로 받아서 처리할 것이므로 설정하지 않는다.
	          // channel.setOutputStream(System.out);
	          // channel.setErrStream(System.err);
	           
	          // 출력 스트림을 호출하면 출력 스트림을 끝까지 읽고 처리해줘야 함.
	        InputStream inputStream = channelExec.getInputStream(); // <- 일반 출력 스트림
	        final InputStream errStream = channelExec.getErrStream();// <- 일반 에러 스트림
	        byte[] buffer = new byte[BUFFER_SIZE];
	           
	        channelExec.connect();
	           
	        while(true) {
	        	while (inputStream.available() > 0) {
	            	int i = inputStream.read(buffer, 0, BUFFER_SIZE);
            		if (i < 0) {
        				break;
        			}
            		//실행결과(파이썬 파일 리턴값)
            		rtnV = new String(buffer, 0, i);
            		System.out.println(new String(buffer, 0, i));
	        	}
	           
	        	while (errStream.available() > 0) {
        			int i = errStream.read(buffer, 0, BUFFER_SIZE);
        			if (i > 0) {
        				//실행결과(파이썬 파일 실행에러)
        				rtnE = new String(buffer, 0, i);
        				System.err.println(new String(buffer, 0, i));
        			}
	        	}
	           
	        	if (channelExec.isClosed()) {
	        		if (inputStream.available() > 0 || errStream.available() > 0) {
	        			continue;
	        		}
	        		break;
	        	}
	           
	        	TimeUnit.MILLISECONDS.sleep(100);
	        }
	           
	        final int exitStatus = channelExec.getExitStatus();
	        System.out.println("Exit Status : " + exitStatus);

            //  System.err.println(new String(buffer, 0, i));
	        channelExec.disconnect();
	        session.disconnect();
	          
	          
	          

	        System.out.println("rtnV : " + rtnV);
	        System.out.println("rtnE : " + rtnE);
	          
	        return exitStatus;
		}
	          
	          
	       /* //콜백을 받을 준비.
	          StringBuilder outputBuffer = new StringBuilder();
	          InputStream in = channel.getInputStream();
	          ((ChannelExec) channel).setErrStream(System.err);      
	          
	          channelExec.connect();
	          
	          byte[] tmp = new byte[1024];
	          while (true) {
	              while (in.available() > 0) {
	                  int i = in.read(tmp, 0, 1024);
	                  outputBuffer.append(new String(tmp, 0, i));
	                  if (i < 0) break;
	              }
	              if (channel.isClosed()) {
	                  System.out.println("결과");
	                  System.out.println(outputBuffer.toString());
	                  channel.disconnect();
	              }
	          }        

              if (channel.isClosed()) {
                  System.out.println("결과");
                  System.out.println(outputBuffer.toString());
                  channel.disconnect();
              }else{
		     // System.out.println("==> Paramaters " + equipCode + "@@@" + coreCode);
		      
			      testMap.put("EQUIP_CODE", equipCode);
			      testMap.put("CORE_CODE", coreCode);

              }
			  return testMap;
	      } catch (JSchException e) {
	          e.printStackTrace();
	  		  Map<String, Object> testMap2 = null;
	          return testMap2;
	      } finally {
	          if (channel != null) {
	              channel.disconnect();
	          }
	          if (session != null) {
	              session.disconnect();
	          }
	      }*/
  
		
		
		
		//return testMap;
	}
	
	
	

	/**
	 * consume정보
	 * @param param
	 * @param loginVo
	 * @return
	 * @throws Exception
	 */
/*	public static Properties init() {
        Properties props = new Properties();
        props.put("bootstrap.servers", "http://192.168.0.230:31090,http://192.168.0.230:31091,http://192.168.0.230:31092");
        props.put("group.id", "custom_synergy");
        props.put("enable.auto.commit", "true");
        props.put("auto.offset.reset", "latest");
        props.put("key.deserializer", "org.apache.kafka.common.serialization.StringDeserializer");
        props.put("value.deserializer", "org.apache.kafka.common.serialization.StringDeserializer");
        return props;
    }*/
	
/*	
	@RequestMapping(value= "/getConsume.do")
	@ResponseBody
	public Map<String, Object> getConsume(@RequestParam Map<String, Object> param, LoginVO loginVo) throws Exception{

//		String version = System.getProperty("java.version");
//
//		System.out.println("JAVA Version : " + version);
			
		Map<String, Object> map = new HashMap<String, Object>();
		KafkaConsumer<String, String> consumer = new KafkaConsumer<>(init());
		
        try {
            //토픽리스트를 매개변수로 준다. 구독신청을 한다.
            consumer.subscribe(Arrays.asList("alarm-model-result"));
            while (true) {
            	System.out.println("폴링 중1");
            	
              //컨슈머는 토픽에 계속 폴링하고 있어야한다. 아니면 브로커는 컨슈머가 죽었다고 판단하고, 해당 파티션을 다른 컨슈머에게 넘긴다.
        		ConsumerRecords<String, String> records = consumer.poll(Duration.ofMillis(500));

            	System.out.println("폴링 중2");
        		for (ConsumerRecord<String, String> record : records){
        			System.out.println("topic : " + record.topic() + " partition : " + record.partition() + "offset : " + record.offset() + " key : " + record.key() + " value : " + record.value());
//                log.info("Topic: {}, Partition: {}, Offset: {}, Key: {}, Value: {}\n", record.topic(), record.partition(), record.offset(), record.key(), record.value());
        			map.put("TOPIC", record.topic());
                	System.out.println("데이터 전달");
        			
              	}                                                                                                                                                                                                                                                                                                                            
        		if(ObjUtils.isNotEmpty(map.get("TOPIC"))){
        			System.out.println("폴링 중3");
        			consumer.close();
        			break;
        		}
            }
        }catch(Exception e){
			map = null;
			consumer.close();
			e.printStackTrace();
		}finally {

			System.out.println("폴링 중4");
			consumer.close();
	    }


    	
    	return map;

    
	}
	*/
	
/*	
 * 
	public static void execPython(String[] command) throws IOException, InterruptedException {
        CommandLine commandLine = CommandLine.parse(command[0]);
        for (int i = 1, n = command.length; i < n; i++) {
            commandLine.addArgument(command[i]);
        }

        ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
        PumpStreamHandler pumpStreamHandler = new PumpStreamHandler(outputStream);
        DefaultExecutor executor = new DefaultExecutor();
        executor.setStreamHandler(pumpStreamHandler);
        int result = executor.execute(commandLine);
        System.out.println("result: " + result);
        System.out.println("output: " + outputStream.toString());

    }   */
	
	
	
	@RequestMapping(value = "/s_dsh100ukrv_sh.do")
	public String s_dsh100ukrv_sh(ModelMap model, HttpServletRequest request, LoginVO loginVo) throws Exception {

		model.addAttribute("compCode"	, loginVo.getCompCode());
		model.addAttribute("divCode"	, loginVo.getDivCode());
		model.addAttribute("userId"	, loginVo.getUserID());
		return JSP_PATH + "s_dsh100ukrv_sh";
	}
	

	
	@RequestMapping(value= "/getWkordNum.do")
	@ResponseBody
	public List<Map<String, Object>> getWkordNum(@RequestParam Map<String, Object> param, LoginVO loginVo) throws Exception{
		param.put("S_COMP_CODE", loginVo.getCompCode());
		param.put("S_DIV_CODE", loginVo.getDivCode());
		List<Map<String, Object>> list = s_dsh100ukrv_shService.getWkordNum(param);
		return list;
	}
	
	@RequestMapping(value= "/getWkordNumInfo.do")
	@ResponseBody
	public Map<String, Object> getWkordNumInfo(@RequestParam Map<String, Object> param, LoginVO loginVo) throws Exception{
		param.put("S_COMP_CODE", loginVo.getCompCode());
		param.put("S_DIV_CODE", loginVo.getDivCode());
		Map<String, Object> map = s_dsh100ukrv_shService.getWkordNumInfo(param);
		return map;
	}
	
	
	
	
	
	
	
	
}
