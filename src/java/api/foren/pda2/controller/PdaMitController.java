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

import api.foren.pda2.common.ApiResult;
import api.foren.pda2.common.ApiResultUtil;
import api.foren.pda2.dto.mitDto.Pdp200ukrvDTO;
import api.foren.pda2.dto.mitDto.Pdv100ukrvDTO;
import api.foren.pda2.dto.wmDto.Pdp400ukrvDTO;
import api.foren.pda2.service.PdaMitServiceImpl;
import foren.framework.model.LoginVO;

/**
 * MIT PDA 관련 controller
 * @author chaeseongmin
 *
 */
@Controller
@RequestMapping("/api/pda/mit")
public class PdaMitController {

	private static final Logger logger = LoggerFactory.getLogger(PdaMitController.class);
	

	@Resource(name = "pdaMitService")
	private PdaMitServiceImpl pdaMitService;
	
	/**
	 * 생산실적 불량입력 불량유형 데이터
	 * @param compCode
	 * @param mainCode
	 * @return
	 */
	@RequestMapping(value = "/getBadTypeCodeList", method = RequestMethod.GET)
	@ResponseBody
	public ApiResult getBadTypeCodeList(@RequestParam("compCode") String compCode,@RequestParam("wkordNum") String wkordNum) {

		Map<String, Object> params = new HashMap<>();
		params.put("COMP_CODE", compCode);
		params.put("WKORD_NUM", wkordNum);

		List<Map> list = pdaMitService.getBadTypeCodeList(params);
		return ApiResult.success(list);
	}
	
	/**
	 * 생산실적 불량입력 팝업
	 * @param paramMap
	 * @return
	 */
	@RequestMapping(value = "/searchListPdp200ukrvSub1", method = RequestMethod.GET)
	@ResponseBody
	public ApiResult searchListPdp200ukrvSub1(@RequestParam HashMap<String, Object> paramMap){
		
		Map<String, Object> params = new HashMap<String, Object>(); 
				
		List<Map<String, Object>> data = pdaMitService.searchListPdp200ukrvSub1(paramMap);
		
		return ApiResultUtil.result(data);
	}	
	
	/**
	 * 생산실적 메인조회
	 * @param paramMap
	 * @return
	 */
	@RequestMapping(value = "/searchPdp200ukrvMain", method = RequestMethod.GET)
	@ResponseBody
	public ApiResult searchPdp200ukrvMain(@RequestParam HashMap<String, Object> paramMap){
		
		Map<String, Object> params = new HashMap<String, Object>(); 
				
		Map<String, Object> data = pdaMitService.searchPdp200ukrvMain(paramMap);
		
		return ApiResultUtil.result(data);
	}

	
	/**
	 * 생산실적 저장
	 * @param dtos
	 * @param userId
	 * @return
	 */
	@RequestMapping(value = "/savePdp200ukrv", method = RequestMethod.POST)
	@ResponseBody
	public ApiResult savePdp200ukrv(@RequestBody Pdp200ukrvDTO dtos,
			@RequestHeader(value = "userId", required = false) String userId) {

		LoginVO user = new LoginVO();
		user.setUserID(userId);
		try {
			pdaMitService.savePdp200ukrv(dtos, user);
		} catch (Exception e) {
			logger.debug(e.getMessage());
			e.printStackTrace();
			return ApiResult.fail(e.getMessage());
		}
		return ApiResult.success();
	}
	
	
	
	/**
	 * 자재재고이동 바코드 데이터 
	 * @param paramMap
	 * @return
	 */
	@RequestMapping(value = "/searchPdv102ukrvBarcodeData", method = RequestMethod.GET)
	@ResponseBody
	public ApiResult searchPdv102ukrvBarcodeData(@RequestParam HashMap<String, Object> paramMap){
		Map<String, Object> data = null;
		try {
			data = pdaMitService.searchPdv102ukrvBarcodeData(paramMap);
		} catch (Exception e) {
			logger.debug(e.getMessage());
			e.printStackTrace();
			return ApiResult.fail(e.getMessage());
		}
		return ApiResultUtil.result(data);
	}
	/**
	 * 제품/자재 재고이동 메인조회
	 * @param paramMap
	 * @return
	 */
	@RequestMapping(value = "/searchListPdv100ukrvMain", method = RequestMethod.GET)
	@ResponseBody
	public ApiResult searchListPdv100ukrvMain(@RequestParam HashMap<String, Object> paramMap){
		
		Map<String, Object> params = new HashMap<String, Object>(); 
				
		List<Map<String, Object>> data = pdaMitService.searchListPdv100ukrvMain(paramMap);
		
		return ApiResultUtil.result(data);
	}
	
	/**
	 * 제품/자재 재고이동 log 저장
	 * @param dtos
	 * @param userId
	 * @return
	 */
	@RequestMapping(value = "/savePdv100ukrvLog", method = RequestMethod.POST)
	@ResponseBody
	public ApiResult savePdv100ukrvLog(@RequestBody Pdv100ukrvDTO dtos,
			@RequestHeader(value = "userId", required = false) String userId) {

		LoginVO user = new LoginVO();
		user.setUserID(userId);
		try {
			pdaMitService.savePdv100ukrvLog(dtos, user);
		} catch (Exception e) {
			logger.debug(e.getMessage());
			e.printStackTrace();
			return ApiResult.fail(e.getMessage());
		}
		return ApiResult.success();
	}
	
	/**
	 * 제품/자재 재고이동 메인 저장
	 * @param dtos
	 * @param userId
	 * @return
	 */
	@RequestMapping(value = "/savePdv100ukrvMain", method = RequestMethod.POST)
	@ResponseBody
	public ApiResult savePdv100ukrvMain(@RequestBody Pdv100ukrvDTO dtos,
			@RequestHeader(value = "userId", required = false) String userId) {

		LoginVO user = new LoginVO();
		user.setUserID(userId);
		try {
			pdaMitService.savePdv100ukrvMain(dtos, user);
		} catch (Exception e) {
			logger.debug(e.getMessage());
			e.printStackTrace();
			return ApiResult.fail(e.getMessage());
		}
		return ApiResult.success();
	}

	/**
	 * 생산 재고이동 유형조회
	 * @param paramMap
	 * @return
	 */
	@RequestMapping(value = "/searchListPdv103ukrvType", method = RequestMethod.GET)
	@ResponseBody
	public ApiResult searchListPdv103ukrvType(@RequestParam HashMap<String, Object> paramMap){
		
		Map<String, Object> params = new HashMap<String, Object>(); 
				
		List<Map<String, Object>> data = pdaMitService.searchListPdv103ukrvType(paramMap);
		
		return ApiResultUtil.result(data);
	}
	/**
	 * 생산재고이동 바코드 데이터 
	 * @param paramMap
	 * @return
	 */
	@RequestMapping(value = "/searchPdv103ukrvBarcodeData", method = RequestMethod.GET)
	@ResponseBody
	public ApiResult searchPdv103ukrvBarcodeData(@RequestParam HashMap<String, Object> paramMap){
		Map<String, Object> data = null;
		try {
			data = pdaMitService.searchPdv103ukrvBarcodeData(paramMap);
		} catch (Exception e) {
			logger.debug(e.getMessage());
			e.printStackTrace();
			return ApiResult.fail(e.getMessage());
		}
		return ApiResultUtil.result(data);
	}
	

	/**
	 * 재고이동 조회  
	 * @param paramMap
	 * @return
	 */
	@RequestMapping(value = "/searchListPdv104ukrvMain", method = RequestMethod.GET)
	@ResponseBody
	public ApiResult searchListPdv104ukrvMain(@RequestParam HashMap<String, Object> paramMap){
		//Map<String, Object> data = null;
		List<Map<String, Object>> data = null;
		try {
			data = pdaMitService.searchListPdv104ukrvMain(paramMap);
		} catch (Exception e) {
			logger.debug(e.getMessage());
			e.printStackTrace();
			return ApiResult.fail(e.getMessage());
		}
		return ApiResultUtil.result(data);
	}

	/**
	 * 재고이동 이동번호 검색 팝업   
	 * @param paramMap
	 * @return
	 */
	@RequestMapping(value = "/searchListPdv104ukrvSub1", method = RequestMethod.GET)
	@ResponseBody
	public ApiResult searchListPdv104ukrvSub1(@RequestParam HashMap<String, Object> paramMap){
		//Map<String, Object> data = null;
		List<Map<String, Object>> data = null;
		try {
			data = pdaMitService.searchListPdv104ukrvSub1(paramMap);
		} catch (Exception e) {
			logger.debug(e.getMessage());
			e.printStackTrace();
			return ApiResult.fail(e.getMessage());
		}
		return ApiResultUtil.result(data);
	}

	/**
	 * 이동출고 저장
	 * @param dtos
	 * @param userId
	 * @return
	 */
	@RequestMapping(value = "/savePdv104ukrvMain", method = RequestMethod.POST)
	@ResponseBody
	public ApiResult deletePdv104ukrvMain(@RequestParam HashMap<String, Object> paramMap, @RequestHeader(value = "userId", required = false) String userId){

		LoginVO user = new LoginVO();
		user.setUserID(userId);
		try {
			pdaMitService.savePdv104ukrvMain(paramMap, user);
		} catch (Exception e) {
			logger.debug(e.getMessage());
			e.printStackTrace();
			return ApiResult.fail(e.getMessage());
		}
		return ApiResult.success();
	}
}
