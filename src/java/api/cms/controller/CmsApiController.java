package api.cms.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import api.cms.dto.CAcnutDelngLiatsDTO;
import api.cms.dto.CCprCardCListsDTO;
import api.cms.dto.CCprCardRListsDTO;
import api.cms.dto.CTaxBillMListsDTO;
import api.cms.service.CmsApiServiceImpl;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import foren.framework.model.LoginVO;
import foren.framework.web.view.ViewHelper;
import foren.unilite.modules.com.common.CMSIntfServiceImpl;
import foren.unilite.modules.com.login.LoginServiceImpl;

@Controller
@RequestMapping(value = "/cmsApi")
public class CmsApiController {
	
    @Resource( name = "cmsApiService" )
    private CmsApiServiceImpl cmsApiService;

	@Resource(name="cMSIntfService")
	private CMSIntfServiceImpl cMSIntfService;
	
	@Resource( name = "loginService" )
	private LoginServiceImpl loginService;
	
    /**
     * 계좌거래내역
     * @param dtoList
     * @return
     */
	/*@RequestMapping(value = "/cAcnutDelngLiats", method = RequestMethod.POST)
	public String cAcnutDelngLiatApi(@RequestBody CAcnutDelngLiatsDTO dtoList) {
//		List<Map<String, Object>> dataList = new ArrayList<Map<String, Object>>();
        Map<String,Object> rtnMap = new HashMap<String,Object>();
		try {
			for(CAcnutDelngLiatsDTO dtoMap : dtoList.getData()) {
				cmsApiService.saveCAcnutDelngLiats(dtoMap,"A");
		    }
			cmsApiService.callApiSp("A");
			rtnMap.put("status", "0");
			rtnMap.put("message", "");
		} catch (Exception e) {
            e.printStackTrace();
            rtnMap.put("status", "1");
            rtnMap.put("message", e.getMessage());
		}
		
//		ObjectMapper mapper = new ObjectMapper();
//		String json = "";
//		json = mapper.writeValueAsString(rtnMap);
//		json = mapper.writerWithDefaultPrettyPrinter().writeValueAsString(map); //pretty print
//		JsonObject json = new JsonObject(rtnMap);

//		Gson gson = new Gson();
//		Map<String, Object> jsonObject = gson.fromJson(sb.toString(), new TypeToken<Map<String, Object>>(){}.getType());
		
		ObjectMapper mapper = new ObjectMapper();
		String json = "";
		try {
			json = mapper.writeValueAsString(rtnMap);
			
		} catch (JsonProcessingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		
		return json;
	}
*/	

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	@RequestMapping(value = "/cAcnutDelngLiats", method = RequestMethod.POST)
	public ModelAndView cAcnutDelngLiatApi( @RequestBody CAcnutDelngLiatsDTO dtoList) throws Exception {
//		List<Map<String, Object>> dataList = new ArrayList<Map<String, Object>>();
        Map<String,Object> rtnMap = new HashMap<String,Object>();
		try {
			for(CAcnutDelngLiatsDTO dtoMap : dtoList.getData()) {
				cmsApiService.saveCAcnutDelngLiats(dtoMap,"A");
		    }
			cmsApiService.callApiSp("A");
			rtnMap.put("status", "0");
			rtnMap.put("message", "");
		} catch (Exception e) {
            e.printStackTrace();
            
            cmsApiService.deleteTemp("A");
            rtnMap.put("status", "1");
            rtnMap.put("message", e.getMessage());
		}
		
		return ViewHelper.getJsonView(rtnMap);
	}
	
	
	/**
     * 법인카드승인내역
     * @param dtoList
     * @return
     */
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	@RequestMapping(value = "/cCprCardCLists", method = RequestMethod.POST)
	public ModelAndView cCprCardCListsApi(@RequestBody CCprCardCListsDTO dtoList) throws Exception {
		List<Map<String, Object>> dataList = new ArrayList<Map<String, Object>>();
        Map rtnMsg = new HashMap();
		try {
			for(CCprCardCListsDTO dtoMap : dtoList.getData()) {
				cmsApiService.saveCCprCardCLists(dtoMap,"B");
		    }
			cmsApiService.callApiSp("B");
		    rtnMsg.put("status", "0");
		    rtnMsg.put("message", "");
		} catch (Exception e) {
            e.printStackTrace();
            
            cmsApiService.deleteTemp("B");
            
            rtnMsg.put("status", "1");
            rtnMsg.put("message", e.getMessage());
		}
		return ViewHelper.getJsonView(rtnMsg);
	}
	
	/**
     * 법인카드청구내역
     * @param dtoList
     * @return
     */
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	@RequestMapping(value = "/cCprCardRLists", method = RequestMethod.POST)
	public ModelAndView cCprCardRListsApi(@RequestBody CCprCardRListsDTO dtoList) throws Exception {
		List<Map<String, Object>> dataList = new ArrayList<Map<String, Object>>();
        Map rtnMsg = new HashMap();
		try {
			for(CCprCardRListsDTO dtoMap : dtoList.getData()) {
				cmsApiService.saveCCprCardRLists(dtoMap,"C");
		    }
			cmsApiService.callApiSp("C");
		    rtnMsg.put("status", "0");
		    rtnMsg.put("message", "");
		} catch (Exception e) {
            e.printStackTrace();
            
            cmsApiService.deleteTemp("C");
            rtnMsg.put("status", "1");
            rtnMsg.put("message", e.getMessage());
		}
		return ViewHelper.getJsonView(rtnMsg);
	}
	
	/**
     * 전자세금계산서정보
     * @param dtoList
     * @return
     */
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	@RequestMapping(value = "/cTaxBillMLists", method = RequestMethod.POST)
	public ModelAndView cTaxBillMListsApi(@RequestBody CTaxBillMListsDTO dtoList) throws Exception {
		List<Map<String, Object>> dataList = new ArrayList<Map<String, Object>>();
        Map rtnMsg = new HashMap();
		try {
			for(CTaxBillMListsDTO dtoMap : dtoList.getData()) {
				cmsApiService.saveCTaxBillMLists(dtoMap,"D");
		    }
			cmsApiService.callApiSp("D");
		    rtnMsg.put("status", "0");
		    rtnMsg.put("message", "");
		} catch (Exception e) {
            e.printStackTrace();
            
            cmsApiService.deleteTemp("D");
            rtnMsg.put("status", "1");
            rtnMsg.put("message", e.getMessage());
		}
		return ViewHelper.getJsonView(rtnMsg);
	}

	@RequestMapping(value = "/intfData")
	public ModelAndView intfNewData(@RequestParam(value="compCode", defaultValue="MASTER")	String compCode) throws Exception {
		Map<String, Object> param = new HashMap<>();
		Map rtnMsg = new HashMap();
		
		if(compCode == null || "".equals(compCode)) {
			compCode = "MASTER";
		}
		
		try {
			param.put("S_COMP_CODE", compCode);
			LoginVO loginVo = cMSIntfService.selectCMSIntfLoginInfo(param);
			
			String result = cMSIntfService.getCMSData(param, loginVo);
			
			rtnMsg.put("status", "0");
			rtnMsg.put("message", result);
		}
		catch (Exception e) {
			rtnMsg.put("status", "1");
			rtnMsg.put("message", e.getMessage());
		}
		
		return ViewHelper.getJsonView(rtnMsg);
	}
}