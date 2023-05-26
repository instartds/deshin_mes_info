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
import api.foren.pda2.common.ApiResult;
import api.foren.pda2.common.ApiResultUtil;
import api.foren.pda2.dto.wmDto.Pdm300ukrvDTO;
import api.foren.pda2.dto.wmDto.Pdm400ukrvDTO;
import api.foren.pda2.dto.wmDto.Pdp400ukrvDTO;
import api.foren.pda2.dto.wmDto.Pds200ukrvDTO;
import api.foren.pda2.service.PdaWmServiceImpl;

/**
 * worldMemory PDA 관련 controller
 * @author chaeseongmin
 *
 */
@Controller
@RequestMapping("/api/pda/wm")
public class PdaWmController {

	private static final Logger logger = LoggerFactory.getLogger(PdaWmController.class);
	

	@Resource(name = "pdaWmService")
	private PdaWmServiceImpl pdaWmService;
	
	
	
	/**
	 * 접수/도착등록 메인조회
	 * @param paramMap
	 * @return
	 */
	@RequestMapping(value = "/searchListPdm300ukrvMain", method = RequestMethod.GET)
	@ResponseBody
	public ApiResult searchListPdm300ukrvMain(@RequestParam HashMap<String, Object> paramMap){
		
		Map<String, Object> params = new HashMap<String, Object>(); 
				
		List<Map<String, Object>> data = pdaWmService.searchListPdm300ukrvMain(paramMap);
		
		return ApiResultUtil.result(data);
	}
	
	/**
	 * 접수/도착등록 품목 팝업
	 * @param paramMap
	 * @return
	 */
	@RequestMapping(value = "/searchListPdm300ukrvSub1", method = RequestMethod.GET)
	@ResponseBody
	public ApiResult searchListPdm300ukrvSub1(@RequestParam HashMap<String, Object> paramMap){
		
		Map<String, Object> params = new HashMap<String, Object>(); 
				
		List<Map<String, Object>> data = pdaWmService.searchListPdm300ukrvSub1(paramMap);
		
		return ApiResultUtil.result(data);
	}
	
	/**
	 * 접수/도착등록 저장
	 * @param dtos
	 * @param userId
	 * @return
	 */
	@RequestMapping(value = "/savePdm300ukrv", method = RequestMethod.POST)
	@ResponseBody
	public ApiResult savePdm300ukrv(@RequestBody Pdm300ukrvDTO dtos,
			@RequestHeader(value = "userId", required = false) String userId) {

		logger.debug("param: {}", dtos.toString());

		LoginVO user = new LoginVO();
		user.setUserID(userId);
		try {
			pdaWmService.savePdm300ukrv(dtos, user);
		} catch (Exception e) {
			logger.debug(e.getMessage());
			e.printStackTrace();
			return ApiResult.fail(e.getMessage());
		}
		return ApiResult.success();
	}
	
	/**
	 * 제품출고등록 메인조회
	 * @param paramMap
	 * @return
	 */
	@RequestMapping(value = "/searchListPds200ukrvMain", method = RequestMethod.GET)
	@ResponseBody
	public ApiResult searchListPds200ukrvMain(@RequestParam HashMap<String, Object> paramMap){
		
		Map<String, Object> params = new HashMap<String, Object>(); 

		List<Map<String, Object>> data = null;
		try {
			data = pdaWmService.searchListPds200ukrvMain(paramMap);
		} catch (Exception e) {
			logger.debug(e.getMessage());
			e.printStackTrace();
			return ApiResult.fail(e.getMessage());
		}
		return ApiResultUtil.result(data);
	}
	
	/**
	 * 제품출고등록 저장
	 * @param dtos
	 * @param userId
	 * @return
	 */
	@RequestMapping(value = "/savePds200ukrv", method = RequestMethod.POST)
	@ResponseBody
	public ApiResult savePds200ukrv(@RequestBody Pds200ukrvDTO dtos,
			@RequestHeader(value = "userId", required = false) String userId) {

		logger.debug("param: {}", dtos.toString());

		LoginVO user = new LoginVO();
		user.setUserID(userId);
		try {
			pdaWmService.savePds200ukrv(dtos, user);
		} catch (Exception e) {
			logger.debug(e.getMessage());
			e.printStackTrace();
			return ApiResult.fail(e.getMessage());
		}
		return ApiResult.success();
	}
	
	
	
	/**
	 * 자재출고등록 메인조회
	 * @param paramMap
	 * @return
	 */
	@RequestMapping(value = "/searchListPdm400ukrvMain", method = RequestMethod.GET)
	@ResponseBody
	public ApiResult searchListPdm400ukrvMain(@RequestParam HashMap<String, Object> paramMap){
		
		Map<String, Object> params = new HashMap<String, Object>(); 
		
		List<Map<String, Object>> data = pdaWmService.searchListPdm400ukrvMain(paramMap);
		
		return ApiResultUtil.result(data);
	}
	
	/**
	 * 자재출고등록 품목 정보,그룹 조회
	 * @param paramMap
	 * @return
	 */
	@RequestMapping(value = "/searchListPdm400ukrvSub1", method = RequestMethod.GET)
	@ResponseBody
	public ApiResult searchListPdm400ukrvSub1(@RequestParam HashMap<String, Object> paramMap){
		
		Map<String, Object> params = new HashMap<String, Object>(); 
				
		List<Map<String, Object>> data = pdaWmService.searchListPdm400ukrvSub1(paramMap);
		
		return ApiResultUtil.result(data);
	}
	/**
	 * 자재출고등록 저장
	 * @param dtos
	 * @param userId
	 * @return
	 */
	@RequestMapping(value = "/savePdm400ukrv", method = RequestMethod.POST)
	@ResponseBody
	public ApiResult savePdm400ukrv(@RequestBody Pdm400ukrvDTO dtos,
			@RequestHeader(value = "userId", required = false) String userId) {

		logger.debug("param: {}", dtos.toString());

		LoginVO user = new LoginVO();
		user.setUserID(userId);
		try {
			pdaWmService.savePdm400ukrv(dtos, user);
		} catch (Exception e) {
			logger.debug(e.getMessage());
			e.printStackTrace();
			return ApiResult.fail(e.getMessage());
		}
		return ApiResult.success();
	}

	/**
	 * 출하검사 메인조회
	 * @param paramMap
	 * @return
	 */
	@RequestMapping(value = "/searchListPdp400ukrvMain", method = RequestMethod.GET)
	@ResponseBody
	public ApiResult searchListPdp400ukrvMain(@RequestParam HashMap<String, Object> paramMap){
		
		Map<String, Object> params = new HashMap<String, Object>(); 

		List<Map<String, Object>> data = null;
		try {
			data = pdaWmService.searchListPdp400ukrvMain(paramMap);
		} catch (Exception e) {
			logger.debug(e.getMessage());
			e.printStackTrace();
			return ApiResult.fail(e.getMessage());
		}
		return ApiResultUtil.result(data);
	}
	/**
	 * 출하검사 저장
	 * @param dtos
	 * @param userId
	 * @return
	 */
	@RequestMapping(value = "/savePdp400ukrv", method = RequestMethod.POST)
	@ResponseBody
	public ApiResult savePdp400ukrv(@RequestBody Pdp400ukrvDTO dtos,
			@RequestHeader(value = "userId", required = false) String userId) {

		logger.debug("param: {}", dtos.toString());

		LoginVO user = new LoginVO();
		user.setUserID(userId);
		try {
			pdaWmService.savePdp400ukrv(dtos, user);
		} catch (Exception e) {
			logger.debug(e.getMessage());
			e.printStackTrace();
			return ApiResult.fail(e.getMessage());
		}
		return ApiResult.success();
	}
}
