package api.foren.pda2.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import api.foren.pda2.common.ApiResult;
import api.foren.pda2.common.ApiResultUtil;
import api.foren.pda2.service.PdaCommonServiceImpl;

/**
 * 공통 PDA 관련 controller
 * @author chaeseongmin
 *
 */
@Controller
@RequestMapping("/api/pda/common")
public class PdaCommonController {

	private static final Logger logger = LoggerFactory.getLogger(PdaCommonController.class);
	

	@Resource(name = "pdaCommonService")
	private PdaCommonServiceImpl pdaCommonService;
	
	
	
	/**
	 * bsa100t 공통코드 콤보데이터
	 * @param compCode
	 * @param mainCode
	 * @return
	 */
	@RequestMapping(value = "/getCommonCodeList", method = RequestMethod.GET)
	@ResponseBody
	public ApiResult getCommonCodeList(@RequestParam("compCode") String compCode,@RequestParam("mainCode") String mainCode) {

		Map<String, Object> params = new HashMap<>();
		params.put("COMP_CODE", compCode);
		params.put("MAIN_CODE", mainCode);

		List<Map> list = pdaCommonService.getCommonCodeList(params);
		return ApiResult.success(list);
	}
	
	/**
	 * 창고 콤보데이터
	 * @param compCode
	 * @param divCode
	 * @return
	 */
	@RequestMapping(value = "/searchWhCode", method = RequestMethod.GET)
	@ResponseBody
	public ApiResult getPdaPgmInfoList(@RequestParam("compCode") String compCode,@RequestParam("divCode") String divCode) {

		Map<String, Object> params = new HashMap<>();
		params.put("COMP_CODE", compCode);
		params.put("DIV_CODE", divCode);

		List<Map> list = pdaCommonService.getWhcodeList(params);
		return ApiResult.success(list);
	}
	
	/**
	 * 작업장 콤보데이터
	 * @param compCode
	 * @param divCode
	 * @return
	 */
	@RequestMapping(value = "/searchWorkShop", method = RequestMethod.GET)
	@ResponseBody
	public ApiResult searchWorkShop(@RequestParam("compCode") String compCode,
			@RequestParam("divCode") String divCode) {

		logger.debug("params >>>>>> compCode: {}, divCode: {}", compCode, divCode);

		Map<String, Object> params = new HashMap<>();
		params.put("COMP_CODE", compCode);
		params.put("DIV_CODE", divCode);

		List<Map<String, Object>> data = pdaCommonService.searchWorkShop(params);
		return ApiResultUtil.result(data);
	}
	
	/**
	 * 재고량 조회
	 * @param paramMap
	 * @return
	 */
	@RequestMapping(value = "/searchStockQ", method = RequestMethod.GET)
	@ResponseBody
	public ApiResult searchStockQ(@RequestParam HashMap<String, Object> paramMap){
		
		Map<String, Object> params = new HashMap<String, Object>(); 
				
		Map<String, Object> data = pdaCommonService.searchStockQ(paramMap);
		
		if(data == null){
			params.put("STOCK_Q", 0.0);
		}else{
			params.put("STOCK_Q", data.get("STOCK_Q"));
		}
		return ApiResultUtil.result(params);
	}
}
