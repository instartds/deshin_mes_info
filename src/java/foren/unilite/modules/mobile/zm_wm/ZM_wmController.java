package foren.unilite.modules.mobile.zm_wm;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.codehaus.jackson.map.ObjectMapper;
import org.codehaus.jackson.type.TypeReference;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.framework.web.view.ViewHelper;
import api.foren.pda2.common.ApiResult;
import api.foren.pda2.common.ApiResultUtil;
import api.foren.pda2.dto.WkordDTO;
import api.foren.pda2.dto.hspDto.Pdm100ukrvDTO;
import api.foren.pda2.dto.hspDto.Pdm101ukrvDTO;
import api.foren.pda2.dto.hspDto.Pdp100ukrvDTO;
import api.foren.pda2.dto.hspDto.Pdp200ukrvDTO;
import api.foren.pda2.dto.hspDto.Pds200ukrvDTO;
import api.foren.pda2.dto.hspDto.Pds200ukrvSub1DTO;
import api.foren.pda2.dto.hspDto.Pdv200ukrvDTO;
import api.foren.pda2.dto.kodiDto.Pdm200ukrvDTO;
import api.foren.pda2.service.PdaHspServiceImpl;
import api.foren.pda2.service.PdaWmServiceImpl;

/**
 * Wm PDA 관련 controller
 * @author chaeseongmin
 *
 */
@Controller
@RequestMapping("/zm_wm")
public class ZM_wmController {
	final static String		JSP_PATH	= "/zm_wm/";

	private static final Logger logger = LoggerFactory.getLogger(ZM_wmController.class);
	

	@Resource(name = "pdaWmService")
	private PdaWmServiceImpl pdaWmService;

	
	/**
	 * 생산실적
	 * @param model
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/sm_pdp100ukrv_wm.do")
	public String s_pdp100ukrv_wm(ModelMap model, HttpServletRequest request, LoginVO loginVo) throws Exception {

		model.addAttribute("compCode"	, loginVo.getCompCode());
		model.addAttribute("divCode"	, loginVo.getDivCode());
		model.addAttribute("userId"	, loginVo.getUserID());
		return JSP_PATH + "sm_pdp100ukrv_wm";
	}
	
	@RequestMapping(value = "/s_pdp100ukrv_wm_search.do", method = RequestMethod.POST)
	public ModelAndView s_pdp100ukrv_wm_search(ExtHtttprequestParam _req, HttpSession session) throws Exception {
		Map<String, Object> param = _req.getParameterMap();
		List<Map<String, Object>> results = new ArrayList();
		 
        results = pdaWmService.s_pdp100ukrv_wm_search(param);
        return ViewHelper.getJsonView(results);
	}
	
	@RequestMapping(value = "/s_pdp100ukrv_wm_save.do", method = RequestMethod.POST)
	@ResponseBody
	public ApiResult s_pdp100ukrv_wm_save(@RequestParam Map<String, Object> map) {

		try {
	        ObjectMapper objectMapper = new ObjectMapper();
			ObjectMapper mapper = new ObjectMapper();
			String jsonStr = (String) map.get("data");
            List<Map> paramList = objectMapper.readValue(jsonStr, new TypeReference<List<Map<String, Object>>>() {});
            
			pdaWmService.s_pdp100ukrv_wm_save(paramList);
		} catch (Exception e) {
			logger.debug(e.getMessage());
			e.printStackTrace();
			return ApiResult.fail(e.getMessage());
		}
		return ApiResult.success();
	}
	
}
