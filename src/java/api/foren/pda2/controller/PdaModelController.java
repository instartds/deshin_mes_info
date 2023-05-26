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
import api.foren.pda2.service.PdaModelServiceImpl;

@Controller
@RequestMapping("/api/pda/model")
public class PdaModelController {

	private static final Logger logger = LoggerFactory.getLogger(PdaModelController.class);

	@Resource(name = "pdaModelService")
	private PdaModelServiceImpl pdaModelService;

	@RequestMapping(value = "/search", method = RequestMethod.GET)
	@ResponseBody
	public ApiResult search(@RequestParam("compCode") String compCode, @RequestParam("divCode") String divCode,
			@RequestParam("equCode") String equCode) {

		logger.debug("params >>>>>> compCode: {}, divCode: {}, equCode: {}", compCode, divCode, equCode);

		Map<String, Object> params = new HashMap<>();
		params.put("COMP_CODE", compCode);
		params.put("DIV_CODE", divCode);
		params.put("EQU_CODE", equCode);

		Map model = pdaModelService.searchModel(params);

		if (model == null) {
			return ApiResult.fail("data is not found");
		}
		return ApiResult.success(model);
	}

	@RequestMapping(value = "/searchItem", method = RequestMethod.GET)
	@ResponseBody
	public ApiResult searchItem(@RequestParam("compCode") String compCode, @RequestParam("divCode") String divCode,
			@RequestParam("txtSearch") String txtSearch) {

		Map<String, Object> params = new HashMap<>();
		params.put("COMP_CODE", compCode);
		params.put("DIV_CODE", divCode);
		params.put("TXT_SEARCH", txtSearch);

		List<Map<String, Object>> modelList = pdaModelService.searchModelItems(params);
		if (modelList == null || modelList.size() < 1) {
			return ApiResult.fail("data is not found");
		}
		return ApiResult.success(modelList);
	}
}
