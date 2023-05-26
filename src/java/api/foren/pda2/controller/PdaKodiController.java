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
import api.foren.pda2.dto.StockOutMaterialDTO;
import api.foren.pda2.dto.kodiDto.Pdm200ukrvDTO;
import api.foren.pda2.dto.kodiDto.Pdp300ukrvDTO;
import api.foren.pda2.service.PdaKodiServiceImpl;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;

/**
 * kodi PDA 관련 controller
 * @author chaeseongmin
 *
 */
@Controller
@RequestMapping("/api/pda/kodi")
public class PdaKodiController {

	private static final Logger logger = LoggerFactory.getLogger(PdaKodiController.class);
	

	@Resource(name = "pdaKodiService")
	private PdaKodiServiceImpl pdaKodiService;
	
/*	
	*//**
	 * 자재입고 거래처 팝업
	 * @param paramMap
	 * @return
	 *//*
	@RequestMapping(value = "/searchListPdm100ukrvSub1", method = RequestMethod.GET)
	@ResponseBody
	public ApiResult searchListSub1(@RequestParam HashMap<String, Object> paramMap){
		
		Map<String, Object> params = new HashMap<String, Object>(); 
				
		List<Map<String, Object>> data = pdaKodiService.searchListPdm100ukrvSub1(paramMap);
		
		return ApiResultUtil.result(data);
	}
	
	*//**
	 * 자재입고 품목 팝업
	 * @param paramMap
	 * @return
	 *//*
	@RequestMapping(value = "/searchListPdm100ukrvSub2", method = RequestMethod.GET)
	@ResponseBody
	public ApiResult searchListSub2(@RequestParam HashMap<String, Object> paramMap){
		
		Map<String, Object> params = new HashMap<String, Object>(); 
				
		List<Map<String, Object>> data = pdaKodiService.searchListPdm100ukrvSub2(paramMap);
		
		return ApiResultUtil.result(data);
	}
	*/
	/**
	 * 생산일지 메인조회
	 * @param paramMap
	 * @return
	 */ 
/*	@RequestMapping(value = "/searchListPdp300ukrvMain", method = RequestMethod.GET)
	@ResponseBody
	public ApiResult searchListPdp300ukrvMain(@RequestParam HashMap<String, Object> paramMap){
		
		Map<String, Object> params = new HashMap<String, Object>(); 
				
		List<Map<String, Object>> data = pdaKodiService.searchListPdp300ukrvMain(paramMap);
		
		return ApiResultUtil.result(data);
	}
	*/
	@RequestMapping(value = "/searchStockQ", method = RequestMethod.GET)
	@ResponseBody
	public ApiResult searchStockQ(@RequestParam HashMap<String, Object> paramMap){
		
		Map<String, Object> params = new HashMap<String, Object>(); 
				
		Map<String, Object> data = pdaKodiService.searchStockQ(paramMap);
		
		if(data == null){
			params.put("STOCK_Q", 0.0);
		}else{
			params.put("STOCK_Q", data.get("STOCK_Q"));
		}
		return ApiResultUtil.result(params);
	}
	
	@RequestMapping(value = "/searchListPdm200ukrvMain", method = RequestMethod.GET)
	@ResponseBody
	public ApiResult searchListPdm200ukrvMain(@RequestParam HashMap<String, Object> paramMap){
	/*public ApiResult searchListPdp300ukrvMain(@RequestParam("compCode") String compCode,
			@RequestParam("divCode") String divCode, @RequestParam("outStockNum") String outStockNum,
			@RequestParam("status") String status) {

		logger.debug("params >>>>>> compCode: {}, divCode: {}, status: {}", compCode, divCode, status);

		Map<String, Object> params = new HashMap<String, Object>();
		params.put("COMP_CODE", compCode);
		params.put("DIV_CODE", divCode);
		params.put("OUTSTOCK_NUM", outStockNum);
		params.put("STATUS", status);*/

		Map<String, Object> dataCheckMap = pdaKodiService.selectWkordCheck(paramMap);
		if (ObjUtils.isEmpty(dataCheckMap)) {
			return ApiResult.fail("작업지시번호" + paramMap.get("WKORD_NUM") + "가 존재하지 않습니다.");
		} else {
			if (ObjUtils.parseDouble(dataCheckMap.get("NOT_OUTSTOCK_Q")) == 0) {
				return ApiResult.fail(paramMap.get("WKORD_NUM") + "의 작업지시가 완료되었습니다.");
			}
		}

		List<Map<String, Object>> list = pdaKodiService.searchListPdm200ukrvMain(paramMap);

		return ApiResultUtil.result(list);
	}
	
	@RequestMapping(value = "/searchListPdp300ukrvMain", method = RequestMethod.GET)
	@ResponseBody
	public ApiResult searchListPdp300ukrvMain(@RequestParam HashMap<String, Object> paramMap){
	/*public ApiResult searchListPdp300ukrvMain(@RequestParam("compCode") String compCode,
			@RequestParam("divCode") String divCode, @RequestParam("outStockNum") String outStockNum,
			@RequestParam("status") String status) {

		logger.debug("params >>>>>> compCode: {}, divCode: {}, status: {}", compCode, divCode, status);

		Map<String, Object> params = new HashMap<String, Object>();
		params.put("COMP_CODE", compCode);
		params.put("DIV_CODE", divCode);
		params.put("OUTSTOCK_NUM", outStockNum);
		params.put("STATUS", status);*/

		Map<String, Object> dataCheckMap = pdaKodiService.selectWkordCheck(paramMap);
		if (ObjUtils.isEmpty(dataCheckMap)) {
			return ApiResult.fail("작업지시번호" + paramMap.get("WKORD_NUM") + "가 존재하지 않습니다.");
		} else {
			if (ObjUtils.parseDouble(dataCheckMap.get("NOT_OUTSTOCK_Q")) == 0) {
				return ApiResult.fail(paramMap.get("WKORD_NUM") + "의 작업지시가 완료되었습니다.");
			}
		}

		List<Map<String, Object>> list = pdaKodiService.searchListPdp300ukrvMain(paramMap);

		return ApiResultUtil.result(list);
	}

	@RequestMapping(value = "/savePdm200ukrv", method = RequestMethod.POST)
	@ResponseBody
	public ApiResult savePdm200ukrv(@RequestBody List<Pdm200ukrvDTO> dtos,
			@RequestHeader(value = "userId", required = false) String userId) {

		logger.debug("param: {}", dtos.toString());

		LoginVO user = new LoginVO();
		user.setUserID(userId);
		try {
			pdaKodiService.savePdm200ukrv(dtos, user);
		} catch (Exception e) {
			logger.debug(e.getMessage());
			e.printStackTrace();
			return ApiResult.fail(e.getMessage());
		}
		return ApiResult.success();
	}
	
	
	@RequestMapping(value = "/savePdp300ukrv", method = RequestMethod.POST)
	@ResponseBody
	public ApiResult savePdp300ukrv(@RequestBody List<Pdp300ukrvDTO> dtos,
			@RequestHeader(value = "userId", required = false) String userId) {

		logger.debug("param: {}", dtos.toString());

		LoginVO user = new LoginVO();
		user.setUserID(userId);
		try {
			pdaKodiService.savePdp300ukrv(dtos, user);
		} catch (Exception e) {
			logger.debug(e.getMessage());
			e.printStackTrace();
			return ApiResult.fail(e.getMessage());
		}
		return ApiResult.success();
	}
	
}
