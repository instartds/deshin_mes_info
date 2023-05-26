package api.foren.pda2.controller;

import java.text.SimpleDateFormat;
import java.util.Date;
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
import api.foren.pda2.dto.StockOutReplaceDTO;
import api.foren.pda2.service.PdaStockServiceImpl;
import foren.framework.utils.ObjUtils;

@Controller
@RequestMapping("/api/pda/stock")
public class PdaStockController {

	private static final Logger logger = LoggerFactory.getLogger(PdaStockController.class);

	@Resource(name = "pdaStockService")
	private PdaStockServiceImpl pdaStockService;

	@RequestMapping(value = "/search", method = RequestMethod.GET)
	@ResponseBody
	public ApiResult searchStockByBarcode(@RequestParam("compCode") String compCode,
			@RequestParam("divCode") String divCode, @RequestParam("itemCode") String itemCode) {

		logger.debug("params >>>>>> compCode: {}, divCode: {}, itemCode: {}", compCode, divCode, itemCode);

		Map<String, Object> params = new HashMap<>();
		params.put("COMP_CODE", compCode);
		params.put("DIV_CODE", divCode);
		params.put("ITEM_CODE", itemCode);
		List<Map<String, Object>> list = pdaStockService.searchStock(params);

		return ApiResult.success(list);
	}

	@RequestMapping(value = "/search/cell", method = RequestMethod.GET)
	@ResponseBody
	public ApiResult searchCellStockByBarcode(@RequestParam("compCode") String compCode,
			@RequestParam("divCode") String divCode, @RequestParam("whCode") String whCode,
			@RequestParam("whCellCode") String whCellCode) {

		logger.debug("params >>>>>> compCode: {}, divCode: {}, whCode: {}, whCellCode: {}", compCode, divCode, whCode,
				whCellCode);

		Map<String, Object> params = new HashMap<>();
		params.put("COMP_CODE", compCode);
		params.put("DIV_CODE", divCode);
		params.put("WH_CODE", whCode);
		params.put("WH_CELL_CODE", whCellCode);
		List<Map<String, Object>> list = pdaStockService.searchCellStock(params);

		return ApiResult.success(list);
	}

	@RequestMapping(value = "/replace", method = RequestMethod.POST)
	@ResponseBody
	public ApiResult saveReplace(@RequestBody StockOutReplaceDTO dto, @RequestHeader("userId") String userId) {

		logger.debug("params >>>>>>  {}", dto.toString());

		Map<String, Object> params = new HashMap<>();
		params.put("CHECK_FLAG", "N");
		params.put("COMP_CODE", dto.getCompCode());
		params.put("INOUT_DATE", dto.getInoutDate());

		params.put("DIV_CODE", dto.getDivCode());
		params.put("WH_CODE", dto.getWhCode());
		params.put("WH_CELL_CODE", dto.getWhCellCode());
		params.put("ITEM_CODE", dto.getItemCode());
		params.put("GOOD_STOCK_Q", dto.getGoodStockQ());
		params.put("BAD_STOCK_Q", dto.getBadStockQ());
		params.put("INOUT_P", dto.getInoutP());
		params.put("INOUT_I", dto.getInoutI());
		params.put("LOT_NO", dto.getLotNo());

		params.put("ITEM_STATUS", "1");

		params.put("ODIV_CODE", "01");
		params.put("OWH_CODE", dto.getoWhCode());
		params.put("OWH_CELL_CODE", dto.getoWhCellCode());
		params.put("OITEM_CODE", dto.getoItemCode());
		params.put("OINOUT_P", dto.getoInoutP());
		params.put("OGOOD_STOCK_Q", dto.getoGoodStockQ());
		params.put("OBAD_STOCK_Q", dto.getoBadStockQ());
		params.put("OINOUT_P", dto.getoInoutP());
		params.put("OINOUT_I", dto.getoInoutI());
		params.put("OLOT_NO", dto.getoLotNo());

		params.put("INOUT_NUM", "");
		params.put("INOUT_SEQ", 0);
		params.put("INOUT_TYPE", "1");
		params.put("S_USER_ID", userId);
		params.put("INOUT_PRSN", dto.getInoutPrsn());

		SimpleDateFormat df = new SimpleDateFormat("yyyyMMdd");
		params.put("MAKE_DATE", df.format(new Date()));
		params.put("MAKE_EXP_DATE", null);

		try {
			Map<String, Object> result = pdaStockService.saveReplace(params);
			String errMsg = "ERROR CODE: " + ObjUtils.getSafeString(result.get("ERROR_CODE")) + "\n"
					+ ObjUtils.getSafeString(result.get("ERROR_DESC"));

			if (ObjUtils.isEmpty(result.get("ERROR_CODE"))) {
				String inoutNum = ObjUtils.getSafeString(result.get("INOUT_NUM"));
				return ApiResult.success(inoutNum);
			} else {
				return ApiResult.fail(errMsg);
			}
		} catch (Exception e) {
			return ApiResult.fail(e.getMessage());
		}
	}
}
