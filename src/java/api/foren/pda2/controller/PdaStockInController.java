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
import api.foren.pda2.dto.StockInDTO;
import api.foren.pda2.service.PdaStockInServiceImpl;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;

@Controller
@RequestMapping("/api/pda/instock")
public class PdaStockInController {

	private static final Logger logger = LoggerFactory.getLogger(PdaStockInController.class);

	@Resource(name = "pdaStockInService")
	private PdaStockInServiceImpl pdaStockInService;

	@RequestMapping(value = "/material", method = RequestMethod.POST)
	@ResponseBody
	public ApiResult saveMaterialInstock(@RequestBody StockInDTO dto, @RequestHeader("userId") String userId) {
		logger.debug("params >>>>>> {}", dto.toString());

		LoginVO user = new LoginVO();
		user.setUserID(userId);
		try {
			pdaStockInService.saveStockInMaterial(dto, user);
		} catch (Exception e) {
			logger.debug(e.getMessage());
			e.printStackTrace();
			return ApiResult.fail(e.getMessage());
		}
		return ApiResult.success();
	}

	@RequestMapping(value = "/product", method = RequestMethod.POST)
	@ResponseBody
	public ApiResult saveProductInstock(@RequestBody StockInDTO dto, @RequestHeader("userId") String userId) {
		logger.debug("params >>>>>> {}", dto.toString());

		LoginVO user = new LoginVO();
		user.setUserID(userId);
		try {
			pdaStockInService.saveProductInstock(dto, user);
		} catch (Exception e) {
			logger.debug(e.getMessage());
			e.printStackTrace();
			return ApiResult.fail(e.getMessage());
		}
		return ApiResult.success();
	}
	
	/**
	 * 제품입고 실적검색 팝업
	 * @param paramMap
	 * @return
	 */
	@RequestMapping(value = "/getSearchStockInProductSub1", method = RequestMethod.GET)
	@ResponseBody
	public ApiResult getSearchStockInProductSub1(@RequestParam HashMap<String, Object> paramMap){
		
		Map<String, Object> params = new HashMap<String, Object>(); 
				
		List<Map<String, Object>> data = pdaStockInService.getSearchStockInProductSub1(paramMap);
		
		return ApiResultUtil.result(data);
	}
	
	/**
	 * 제품입고 요청번호 검색
	 * @param paramMap
	 * @return
	 */
	@RequestMapping(value = "/getSearchStockInProductReqNum", method = RequestMethod.GET)
	@ResponseBody
	public ApiResult getSearchStockInProductReqNum(@RequestParam HashMap<String, Object> paramMap){
		
		Map<String, Object> params = new HashMap<String, Object>(); 
				
		List<Map<String, Object>> data = pdaStockInService.getSearchStockInProductReqNum(paramMap);
		
		return ApiResultUtil.result(data);
	}
	

	@RequestMapping(value = "/move", method = RequestMethod.POST)
	@ResponseBody
	public ApiResult saveMoveInstock(@RequestBody StockInDTO dto, @RequestHeader("userId") String userId) {
		logger.debug("params >>>>>> {}", dto.toString());

		LoginVO user = new LoginVO();
		user.setUserID(userId);
		try {
			pdaStockInService.saveMoveInstock(dto, user);
		} catch (Exception e) {
			logger.debug(e.getMessage());
			e.printStackTrace();
			return ApiResult.fail(e.getMessage());
		}
		return ApiResult.success();
	}

	@RequestMapping(value = "/orders", method = RequestMethod.GET)
	@ResponseBody
	public ApiResult searchStockInOrders(@RequestParam("compCode") String compCode,
			@RequestParam("divCode") String divCode, @RequestParam("itemCode") String itemCode,
			@RequestParam("lotNo") String lotNo) {
		logger.debug("params >>>>>> compCode: {}, divCode: {}, lotNo: {}", compCode, divCode, lotNo);

		Map<String, Object> params = new HashMap<>();
		params.put("COMP_CODE", compCode);
		params.put("ITEM_CODE", itemCode);
		params.put("LOT_NO", lotNo);

		Map<String, Object> item = pdaStockInService.getStockInItem(params);

		if (ObjUtils.isEmpty(item)) {
			return ApiResult.fail("조회 정보가 없습니다");
		} else {
			List<Map<String, Object>> list = pdaStockInService.getStockInOrderList(params);
			if (ObjUtils.isEmpty(list)) {
				return ApiResult.fail("발주 정보가 없습니다");
			}
			item.put("orderList", list);
		}

		return ApiResult.success(item);
	}

	@RequestMapping(value = "/listByOrder", method = RequestMethod.GET)
	@ResponseBody
	public ApiResult searchStockInListByOrder(@RequestParam("compCode") String compCode,
			@RequestParam("divCode") String divCode, @RequestParam("itemCode") String itemCode,
			@RequestParam("lotNo") String lotNo, @RequestParam("orderNum") String orderNum,
			@RequestParam("orderSeq") String orderSeq) {
		logger.debug("params >>>>>> compCode: {}, itemCode: {}, lotNo: {}, orderNum: {}, orderSeq: {}", compCode,
				itemCode, lotNo, orderNum, orderSeq);

		Map<String, Object> params = new HashMap<>();
		params.put("COMP_CODE", compCode);
		params.put("DIV_CODE", divCode);
		params.put("ITEM_CODE", itemCode);
		params.put("LOT_NO", lotNo);
		params.put("ORDER_NUM", orderNum);
		params.put("ORDER_SEQ", orderSeq);

		List<Map<String, Object>> list = pdaStockInService.getStockInListByOrder(params);
		if (ObjUtils.isEmpty(list)) {
			return ApiResult.fail("입고 정보가 없습니다");
		}
		return ApiResult.success(list);
	}

	@RequestMapping(value = "/listByItem", method = RequestMethod.GET)
	@ResponseBody
	public ApiResult searchStockInListByItem(@RequestParam("compCode") String compCode,
			@RequestParam("divCode") String divCode, @RequestParam("itemCode") String itemCode,
			@RequestParam("lotNo") String lotNo) {
		logger.debug("params >>>>>> compCode: {}, itemCode: {}, lotNo: {}", compCode, itemCode, lotNo);

		Map<String, Object> params = new HashMap<>();
		params.put("COMP_CODE", compCode);
		params.put("DIV_CODE", divCode);
		params.put("ITEM_CODE", itemCode);
		params.put("LOT_NO", lotNo);

		List<Map<String, Object>> list = pdaStockInService.getStockInListByItem(params);
		if (ObjUtils.isEmpty(list)) {
			return ApiResult.fail("입고 정보가 없습니다");
		}
		return ApiResult.success(list);
	}
}
