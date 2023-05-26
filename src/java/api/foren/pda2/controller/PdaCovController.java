package api.foren.pda2.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import api.foren.pda2.common.ApiResult;
import api.foren.pda2.common.ApiResultUtil;
import api.foren.pda2.dto.WkordDTO;
import api.foren.pda2.dto.covDto.Pdm100ukrvDTO;
import api.foren.pda2.dto.covDto.Pds200ukrvDTO;
import api.foren.pda2.service.PdaCovServiceImpl;

/**
 * cov PDA 관련 controller
 * @author nam
 *
 */
@Controller
@RequestMapping("/api/pda/cov")
public class PdaCovController {

	private static final Logger logger = LoggerFactory.getLogger(PdaCovController.class);


	@Resource(name = "pdaCovService")
	private PdaCovServiceImpl pdaCovService;

	/**
	 * 구매입고
	 * @param paramMap
	 * @return
	 */
	@RequestMapping(value = "/searchListPdm100ukrvMain", method = RequestMethod.GET)
	@ResponseBody
	public ApiResult searchListMain(@RequestParam HashMap<String, Object> paramMap){
		
		Map<String, Object> params = new HashMap<String, Object>(); 
				
		List<Map<String, Object>> data = pdaCovService.searchListPdm100ukrvMain(paramMap);
		
		return ApiResultUtil.result(data);
	}
	
	/**
	 * 구매입고 미입고내역 팝업
	 * @param paramMap
	 * @return
	 */
	@RequestMapping(value = "/searchListPdm100ukrvSub1", method = RequestMethod.GET)
	@ResponseBody
	public ApiResult searchListSub1(@RequestParam HashMap<String, Object> paramMap){
		
		Map<String, Object> params = new HashMap<String, Object>(); 
				
		List<Map<String, Object>> data = pdaCovService.searchListPdm100ukrvSub1(paramMap);
		
		return ApiResultUtil.result(data);
	}
	

	/**
	 * 구매입고저장
	 * @param dtos
	 * @param userId
	 * @return
	 */
	@RequestMapping(value = "/savePdm100ukrv", method = RequestMethod.POST)
	@ResponseBody
	public ApiResult savePdm100ukrv(@RequestBody Pdm100ukrvDTO dtos,
			@RequestHeader(value = "userId", required = false) String userId) {

		logger.debug("param: {}", dtos.toString());

		LoginVO user = new LoginVO();
		user.setUserID(userId);
		try {
			pdaCovService.savePdm100ukrv(dtos, user);
		} catch (Exception e) {
			logger.debug(e.getMessage());
			e.printStackTrace();
			return ApiResult.fail(e.getMessage());
		}
		return ApiResult.success();
	}
	
	
	
	
	/**
	 * 제품출고 조회
	 * @param paramMap
	 * @return
	 */
	@RequestMapping(value = "/searchListPds200ukrvMain", method = RequestMethod.GET)
	@ResponseBody
	public ApiResult searchListPds200ukrvMain(@RequestParam HashMap<String, Object> paramMap){

		List<Map<String, Object>> list = pdaCovService.searchListPds200ukrvMain(paramMap);

		return ApiResultUtil.result(list);
	}
	
	/**
	 * 제품출고 저장
	 * @param dtos
	 * @param userId
	 * @return
	 */
	@RequestMapping(value = "/savePds200ukrv", method = RequestMethod.POST)
	@ResponseBody
	public ApiResult savePds200ukrv(@RequestBody Pds200ukrvDTO dtos,
			@RequestHeader(value = "userId", required = false) String userId) {

		LoginVO user = new LoginVO();
		user.setUserID(userId);
		try {
			pdaCovService.savePds200ukrv(dtos, user);
		} catch (Exception e) {
			logger.debug(e.getMessage());
			e.printStackTrace();
			return ApiResult.fail(e.getMessage());
		}
		return ApiResult.success();
	}	
	
	
	/**
	 * 재고조회
	 * @param paramMap
	 * @return
	 */
	@RequestMapping(value = "/searchListPdv100skrvMain", method = RequestMethod.GET)
	@ResponseBody
	public ApiResult searchListPdv100skrvMain(@RequestParam HashMap<String, Object> paramMap){
		
		Map<String, Object> params = new HashMap<String, Object>(); 
				
		List<Map<String, Object>> data = pdaCovService.searchListPdv100skrvMain(paramMap);
		
		return ApiResultUtil.result(data);
	}
	

	/**
	 * 작업지시서 조회
	 * @param paramMap
	 * @return
	 */
	@RequestMapping(value = "/searchListPdp100skrvMain", method = RequestMethod.GET)
	@ResponseBody
	public ApiResult searchListPdp100skrvMain(@RequestParam HashMap<String, Object> paramMap,
			@RequestHeader(value = "userId", required = false) String userId){

		paramMap.put("S_USER_ID", userId);
				
		List<Map<String, Object>> data = pdaCovService.searchListPdp100skrvMain(paramMap);
		
		return ApiResultUtil.result(data);
	}
}
