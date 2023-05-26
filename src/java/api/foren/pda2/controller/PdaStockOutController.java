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
import api.foren.pda2.dto.StockOutMoveCellDTO;
import api.foren.pda2.dto.StockOutMoveDTO;
import api.foren.pda2.dto.StockOutProductDTO;
import api.foren.pda2.service.PdaStockOutServiceImpl;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;

@Controller
@RequestMapping("/api/pda/outstock")
public class PdaStockOutController {
	private static final Logger logger = LoggerFactory.getLogger(PdaStockOutController.class);

	@Resource(name = "pdaStockOutService")
	private PdaStockOutServiceImpl pdaStockOutService;

	@RequestMapping(value = "/material/manufacture", method = RequestMethod.GET)
	@ResponseBody
	public ApiResult getStockOutManufacture(@RequestParam("compCode") String compCode,
			@RequestParam("divCode") String divCode, @RequestParam("outStockNum") String outStockNum,
			@RequestParam("status") String status) {

		logger.debug("params >>>>>> compCode: {}, divCode: {}, status: {}", compCode, divCode, status);

		Map<String, Object> params = new HashMap<String, Object>();
		params.put("COMP_CODE", compCode);
		params.put("DIV_CODE", divCode);
		params.put("OUTSTOCK_NUM", outStockNum);
		params.put("STATUS", status);

		Map<String, Object> result = pdaStockOutService.selectStockOutManufacture(params);
		if (ObjUtils.isEmpty(result)) {
			return ApiResult.fail("작업지시번호가" + outStockNum + "가 존재하지 않습니다.");
		} else {
			if (ObjUtils.parseDouble(result.get("NOT_OUTSTOCK_Q")) == 0) {
				return ApiResult.fail(outStockNum + "의 작업지시가 완료되었습니다.");
			}
		}

		List<Map<String, Object>> list = pdaStockOutService.getStockOutManufacture(params);

		return ApiResultUtil.result(list);
	}

	@RequestMapping(value = "/material/manufacture", method = RequestMethod.POST)
	@ResponseBody
	public ApiResult saveStockOutMaterial(@RequestBody List<StockOutMaterialDTO> dtos,
			@RequestHeader(value = "userId", required = false) String userId) {

		logger.debug("param: {}", dtos.toString());

		LoginVO user = new LoginVO();
		user.setUserID(userId);
		try {
			pdaStockOutService.saveStockOutManufacture(dtos, user);
		} catch (Exception e) {
			logger.debug(e.getMessage());
			e.printStackTrace();
			return ApiResult.fail(e.getMessage());
		}
		return ApiResult.success();
	}

	@RequestMapping(value = "/product", method = RequestMethod.GET)
	@ResponseBody
	public ApiResult getStockOutProduct(@RequestParam("compCode") String compCode,
			@RequestParam("divCode") String divCode, @RequestParam("outStockNum") String outStockNum,
			@RequestParam("status") String status) {

		logger.debug("params >>>>>> compCode: {}, divCode: {}, status: {}", compCode, divCode, status);

		Map<String, Object> params = new HashMap<String, Object>();
		params.put("COMP_CODE", compCode);
		params.put("DIV_CODE", divCode);
		params.put("OUTSTOCK_NUM", outStockNum);
		params.put("STATUS", status);

		Map<String, Object> result = pdaStockOutService.selectStockOutProduct(params);
		if (ObjUtils.isEmpty(result)) {
			return ApiResult.fail("출하지시번호" + outStockNum + "가 존재하지 않습니다.");
		} else {
			if (ObjUtils.parseDouble(result.get("NOT_OUTSTOCK_Q")) == 0) {
				return ApiResult.fail(outStockNum + "의 출고가 완료되었습니다.");
			}
		}

		List<Map<String, Object>> list = pdaStockOutService.getStockOutProduct(params);

		return ApiResultUtil.result(list);
	}

	@RequestMapping(value = "/product/search", method = RequestMethod.GET)
	@ResponseBody
	public ApiResult getStockOutProductBySearch(@RequestParam("compCode") String compCode,
			@RequestParam("divCode") String divCode, @RequestParam("frDate") String frDate,
			@RequestParam("toDate") String toDate,
			@RequestParam(value = "orderType", required = false) String orderType) {

		logger.debug("params >>>>>> compCode: {}, divCode: {}, frDate: {}, toDate: {}", compCode, divCode, frDate,
				toDate);

		Map<String, Object> params = new HashMap<String, Object>();
		params.put("COMP_CODE", compCode);
		params.put("DIV_CODE", divCode);
		params.put("FR_DATE", frDate);
		params.put("TO_DATE", toDate);
		params.put("ORDER_TYPE", orderType);

		List<Map<String, Object>> list = pdaStockOutService.getStockOutProductBySearch(params);

		return ApiResultUtil.result(list);
	}

	@RequestMapping(value = "/product", method = RequestMethod.POST)
	@ResponseBody
	public ApiResult saveStockOutProduct(@RequestBody List<StockOutProductDTO> dtos,
			@RequestHeader(value = "userId", required = false) String userId) {

		logger.debug("params >>>>>> {}", dtos.toString());

		LoginVO user = new LoginVO();
		user.setUserID(userId);
		try {
			pdaStockOutService.saveStockOutProduct(dtos, user);
		} catch (Exception e) {
			logger.debug(e.getMessage());
			e.printStackTrace();
			return ApiResult.fail(e.getMessage());
		}
		return ApiResult.success();
	}

	@RequestMapping(value = "/move", method = RequestMethod.GET)
	@ResponseBody
	public ApiResult getStockOutMove(@RequestParam("compCode") String compCode,
			@RequestParam("reqStockNum") String reqStockNum, @RequestParam("divCode") String divCode,
			@RequestParam(value = "gwFlag", required = false) String gwFlag) {

		logger.debug("params >>>>>> compCode: {}, divCode: {}, reqStockNum: {}, gwFlag: {}", compCode, divCode,
				reqStockNum, gwFlag);

		Map<String, Object> params = new HashMap<String, Object>();
		params.put("COMP_CODE", compCode);
		params.put("DIV_CODE", divCode);
		params.put("REQSTOCK_NUM", reqStockNum);
		params.put("GW_FLAG", gwFlag);

		List<Map<String, Object>> list = pdaStockOutService.getStockOutMove(params);

		return ApiResultUtil.result(list);
	}

	@RequestMapping(value = "/move", method = RequestMethod.POST)
	@ResponseBody
	public ApiResult saveStockOutMove(@RequestBody List<StockOutMoveDTO> dtos,
			@RequestHeader(value = "userId", required = false) String userId) {

		logger.debug("params: {}", dtos.toString());

		LoginVO user = new LoginVO();
		user.setUserID(userId);
		try {
			pdaStockOutService.saveStockOutMove(dtos, user);
		} catch (Exception e) {
			logger.debug(e.getMessage());
			e.printStackTrace();
			return ApiResult.fail(e.getMessage());
		}
		return ApiResult.success();
	}

	@RequestMapping(value = "/move/cell", method = RequestMethod.POST)
	@ResponseBody
	public ApiResult saveStockOutMoveCell(@RequestBody List<StockOutMoveCellDTO> dtos,
			@RequestHeader(value = "userId", required = false) String userId) {

		logger.debug("param: {}", dtos.toString());

		LoginVO user = new LoginVO();
		user.setUserID(userId);
		try {
			pdaStockOutService.saveStockOutMoveCell(dtos, user);
		} catch (Exception e) {
			logger.debug(e.getMessage());
			e.printStackTrace();
			return ApiResult.fail(e.getMessage());
		}
		return ApiResult.success();
	}

	@RequestMapping(value = "/material/external", method = RequestMethod.GET)
	@ResponseBody
	public ApiResult findAppointmentReq(@RequestParam("compCode") String compCode,
			@RequestParam("divCode") String divCode, @RequestParam("outStockNum") String outStockNum,
			@RequestParam("status") String status) {

		logger.debug("params >>>>>> compCode: {}, divCode: {}, outStockNum: {}, status: {}", compCode, divCode,
				outStockNum, status);

		Map<String, Object> params = new HashMap<String, Object>();
		params.put("COMP_CODE", compCode);
		params.put("DIV_CODE", divCode);
		params.put("OUTSTOCK_NUM", outStockNum);
		params.put("STATUS", status);

		Map<String, Object> result = pdaStockOutService.selectStockOutExternal(params);
		if (ObjUtils.isEmpty(result)) {
			return ApiResult.fail("요청번호" + outStockNum + "가 존재하지 않습니다.");
		} else {
			if (ObjUtils.parseDouble(result.get("NOT_OUTSTOCK_Q")) == 0) {
				return ApiResult.fail(outStockNum + "의 출고가 완료되었습니다.");
			}
		}

		List<Map<String, Object>> list = pdaStockOutService.getStockOutExternal(params);

		return ApiResultUtil.result(list);
	}

	@RequestMapping(value = "/material/external", method = RequestMethod.POST)
	@ResponseBody
	public ApiResult saveOutProcessingOutstock(@RequestBody List<StockOutMaterialDTO> dtos,
			@RequestHeader(value = "userId", required = false) String userId) {

		logger.debug("param: {}", dtos.toString());

		LoginVO user = new LoginVO();
		user.setUserID(userId);
		try {
			pdaStockOutService.saveStockOutExternal(dtos, user);
		} catch (Exception e) {
			logger.debug(e.getMessage());
			e.printStackTrace();
			return ApiResult.fail(e.getMessage());
		}
		return ApiResult.success();
	}

}
