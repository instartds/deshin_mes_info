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
import api.foren.pda2.dto.WkordBadDTO;
import api.foren.pda2.dto.WkordDTO;
import api.foren.pda2.service.PdaProduceServiceImpl;
import foren.framework.model.LoginVO;

@Controller
@RequestMapping("/api/pda/produce")
public class PdaProduceController {

	private static final Logger logger = LoggerFactory.getLogger(PdaProduceController.class);

	@Resource(name = "pdaProduceService")
	private PdaProduceServiceImpl pdaProduceService;

	@RequestMapping(value = "/searchWorkShop", method = RequestMethod.GET)
	@ResponseBody
	public ApiResult searchWorkShop(@RequestParam("compCode") String compCode,
			@RequestParam("divCode") String divCode) {

		logger.debug("params >>>>>> compCode: {}, divCode: {}", compCode, divCode);

		Map<String, Object> params = new HashMap<>();
		params.put("COMP_CODE", compCode);
		params.put("DIV_CODE", divCode);

		List<Map<String, Object>> data = pdaProduceService.searchWorkShop(params);
		return ApiResultUtil.result(data);
	}

	@RequestMapping(value = "/searchWkordList", method = RequestMethod.GET)
	@ResponseBody
	public ApiResult searchWkordList(@RequestHeader("userId") String userId, @RequestParam("compCode") String compCode,
			@RequestParam("divCode") String divCode, @RequestParam("workShopCode") String workShopCode,
			@RequestParam(value = "spec", required = false) String spec,
			@RequestParam(value = "lotNo", required = false) String lotNo) {

		logger.debug("params >>>>>> compCode: {}, divCode: {}, workShopCode: {}, spec: {}, lotNo: {}", compCode,
				divCode, workShopCode, spec, lotNo);

		Map<String, Object> params = new HashMap<>();
		params.put("COMP_CODE", compCode);
		params.put("DIV_CODE", divCode);
		params.put("WORK_SHOP_CODE", workShopCode);
		params.put("USER_ID", userId);
		params.put("SPEC", spec); // 품번
		params.put("LOT_NO", lotNo);

		List<Map<String, Object>> data = pdaProduceService.searchWkordList(params);
		return ApiResultUtil.result(data);
	}

	@RequestMapping(value = "/searchWkord", method = RequestMethod.GET)
	@ResponseBody
	public ApiResult searchWkord(@RequestHeader("userId") String userId, @RequestParam("compCode") String compCode,
			@RequestParam("divCode") String divCode, @RequestParam("workShopCode") String workShopCode,
			@RequestParam(value = "wkordNum") String wkordNum) {

		logger.debug("params >>>>>> compCode: {}, divCode: {}, workShopCode: {}, wkordNum: {}", compCode, divCode,
				workShopCode, wkordNum);

		Map<String, Object> params = new HashMap<>();
		params.put("COMP_CODE", compCode);
		params.put("DIV_CODE", divCode);
		params.put("WORK_SHOP_CODE", workShopCode);
		params.put("USER_ID", userId);
		params.put("WKORD_NUM", wkordNum); // 작업지시번호

		Map<String, Object> data = pdaProduceService.searchWkord(params);
		return ApiResultUtil.result(data);
	}

	@RequestMapping(value = "/searchWkordMgh", method = RequestMethod.GET)
	@ResponseBody
	public ApiResult searchWkordMgh(@RequestHeader("userId") String userId, @RequestParam("compCode") String compCode,
			@RequestParam("divCode") String divCode, @RequestParam("workShopCode") String workShopCode,
			@RequestParam(value = "wkordNum") String wkordNum) {

		logger.debug("params >>>>>> compCode: {}, divCode: {}, workShopCode: {}, wkordNum: {}", compCode, divCode,
				workShopCode, wkordNum);

		Map<String, Object> params = new HashMap<>();
		params.put("COMP_CODE", compCode);
		params.put("DIV_CODE", divCode);
		params.put("WORK_SHOP_CODE", workShopCode);
		params.put("USER_ID", userId);
		params.put("WKORD_NUM", wkordNum); // 작업지시번호

		Map<String, Object> data = pdaProduceService.searchWkordMgh(params);
		return ApiResultUtil.result(data);
	}
	@RequestMapping(value = "/searchWkordMghList", method = RequestMethod.GET)
	@ResponseBody
	public ApiResult searchWkordMghList(@RequestHeader("userId") String userId, @RequestParam("compCode") String compCode,
			@RequestParam("divCode") String divCode, @RequestParam("workShopCode") String workShopCode,
			@RequestParam(value = "spec", required = false) String spec,
			@RequestParam(value = "lotNo", required = false) String lotNo) {

		logger.debug("params >>>>>> compCode: {}, divCode: {}, workShopCode: {}, spec: {}, lotNo: {}", compCode,
				divCode, workShopCode, spec, lotNo);

		Map<String, Object> params = new HashMap<>();
		params.put("COMP_CODE", compCode);
		params.put("DIV_CODE", divCode);
		params.put("WORK_SHOP_CODE", workShopCode);
		params.put("USER_ID", userId);
		params.put("SPEC", spec); // 품번
		params.put("LOT_NO", lotNo);

		List<Map<String, Object>> data = pdaProduceService.searchWkordMghList(params);
		return ApiResultUtil.result(data);
	}
	
	

	@RequestMapping(value = "/searchBadList", method = RequestMethod.GET)
	@ResponseBody
	public ApiResult searchBadList(@RequestParam("compCode") String compCode, @RequestParam("divCode") String divCode,
			@RequestParam("wkordNum") String wkordNum, @RequestParam("workShopCode") String workShopCode) {

		logger.debug("params >>>>>> compCode: {}, divCode: {}, workShopCode: {}, wkordNum: {}", compCode, divCode,
				workShopCode, wkordNum);

		Map<String, Object> params = new HashMap<>();
		params.put("COMP_CODE", compCode);
		params.put("DIV_CODE", divCode);
		params.put("WKORD_NUM", wkordNum);
		params.put("WORK_SHOP_CODE", workShopCode);

		List<Map<String, Object>> data = pdaProduceService.searchBadList(params);
		return ApiResultUtil.result(data);
	}

	@RequestMapping(value = "/saveWkord", method = RequestMethod.POST)
	@ResponseBody
	public ApiResult saveWkord(@RequestBody WkordDTO wkord,
			@RequestHeader(value = "userId", required = false) String userId) {

		logger.debug("params >>>>>> {}", wkord.toString());

		LoginVO user = new LoginVO();
		user.setUserID(userId);
		try {
			String prodtNum = pdaProduceService.getProdtNum(wkord.getCompCode(), wkord.getDivCode());
			wkord.setProdtNum(prodtNum);
			pdaProduceService.saveWkord(wkord, user);
			if("mgh".equalsIgnoreCase(wkord.getBizType())){
				pdaProduceService.mghPmrLink(wkord, user);
			}
			
			return ApiResult.success(prodtNum);
		} catch (Exception e) {
			e.printStackTrace();
			return ApiResult.fail(e.getMessage());
		}
	}

//	@RequestMapping(value = "/mghPmrLink", method = RequestMethod.POST)
//	@ResponseBody
//	public ApiResult mghPmrLink(@RequestBody WkordDTO wkord,
//			@RequestHeader(value = "userId", required = false) String userId) {
//
//		logger.debug("params >>>>>> {}", wkord.toString());
//
//		LoginVO user = new LoginVO();
//		user.setUserID(userId);
//		try {
////			String prodtNum = pdaProduceService.getProdtNum(wkord.getCompCode(), wkord.getDivCode());
////			wkord.setProdtNum(prodtNum);
//			pdaProduceService.mghPmrLink(wkord, user);
//			return ApiResult.success(wkord.getWkordNum());
//		} catch (Exception e) {
//			e.printStackTrace();
//			return ApiResult.fail(e.getMessage());
//		}
//	}
	@RequestMapping(value = "/saveBadList", method = RequestMethod.POST)
	@ResponseBody
	public ApiResult saveBadList(@RequestBody List<WkordBadDTO> badList,
			@RequestHeader(value = "userId", required = false) String userId) {
		LoginVO user = new LoginVO();
		user.setUserID(userId);
		try {
			pdaProduceService.saveBadList(badList, user);
		} catch (Exception e) {
			e.printStackTrace();
			return ApiResult.fail(e.getMessage());
		}
		return ApiResult.success();
	}

	@RequestMapping(value = "/deleteBadList", method = RequestMethod.POST)
	@ResponseBody
	public ApiResult deleteBadList(@RequestBody List<WkordBadDTO> badList,
			@RequestHeader(value = "userId", required = false) String userId) {
		LoginVO user = new LoginVO();
		user.setUserID(userId);
		try {
			pdaProduceService.deleteBadList(badList, user);
		} catch (Exception e) {
			e.printStackTrace();
			return ApiResult.fail(e.getMessage());
		}
		return ApiResult.success();
	}

	
	/**
	 * smartFinder MES로 보내기위한 데이터
	 * @param compCode
	 * @param divCode
	 * @param wkordNum
	 * @param workShopCode
	 * @return
	 */
	@RequestMapping(value = "/searchWkordData", method = RequestMethod.GET)
	@ResponseBody
	public ApiResult searchWkordData(
			@RequestHeader("userId") String userId,
			@RequestParam("compCode") String compCode, @RequestParam("wkordNum") String wkordNum
	) {

		Map<String, Object> params = new HashMap<>();
		params.put("COMP_CODE", compCode);
		params.put("WKORD_NUM", wkordNum);

		List<Map<String, Object>> data = pdaProduceService.searchWkordData(params);
		return ApiResultUtil.result(data);
	}
	
	
}
