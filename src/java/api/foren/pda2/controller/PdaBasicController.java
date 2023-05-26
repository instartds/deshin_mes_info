package api.foren.pda2.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import api.foren.pda2.common.ApiResult;
import api.foren.pda2.common.ApiResultUtil;
import api.foren.pda2.dto.ConfigDTO;
import api.foren.pda2.model.LoginForm;
import api.foren.pda2.service.PdaBasicServiceImpl;
import foren.framework.model.LoginVO;
import foren.framework.sec.cipher.seed.EncryptSHA256;
import foren.framework.utils.MessageUtils;
import foren.framework.utils.ObjUtils;
import foren.unilite.modules.com.login.LoginServiceImpl;

@Controller
@RequestMapping("/api/pda/basic")
public class PdaBasicController {

	private static final Logger logger = LoggerFactory.getLogger(PdaBasicController.class);

	@Resource(name = "pdaBasicService")
	private PdaBasicServiceImpl pdaBasicService;

	@Resource(name = "loginService")
	private LoginServiceImpl loginService;

	@RequestMapping(value = "/login", method = RequestMethod.POST)
	@ResponseBody
	public ApiResult login(@RequestBody LoginForm loginForm) throws Exception {
		logger.debug("params >>>>>> {}", loginForm.toString());

		LoginVO loginVO = null;

		Locale locale = new Locale("zh");

		Map<String, Object> param = new HashMap<>();
		param.put("userid", loginForm.getUserId());
		param.put("userpw", loginForm.getUserPw());

		// 유저정보 찾기
		List<Map<String, Object>> mapUserList = loginService.selectUserList(param);

		if (mapUserList == null || mapUserList.size() == 0) {
			return ApiResult.fail(MessageUtils.getMessage("msg.login.loginFail", locale));
		} else {
			String compCode = mapUserList.get(0).get("COMP_CODE").toString();
			if (param.get("compCode") == null) {
				param.put("compCode", compCode);
			}
			boolean isCaseSensitiveYN = false;
			Map<String, Object> tempMap = new HashMap<>();
			tempMap.put("COMP_CODE", "MASTER");
			Map cdoMap = pdaBasicService.selectCaseSensitiveYN(tempMap);
			if (!ObjUtils.isEmpty(cdoMap)) {
				if (cdoMap.get("REF_CODE1").equals("Y")) {
					isCaseSensitiveYN = true;
				} else {
					isCaseSensitiveYN = false;
				}
			}
			logger.debug("isCaseSensitiveYN = {}", isCaseSensitiveYN);
			if (!isCaseSensitiveYN) {
				param.put("userpw", StringUtils.upperCase(ObjUtils.getSafeString(param.get("userpw"))));
			}
			param.put("userpw_uni", param.get("userpw"));
			param.put("userpw", new EncryptSHA256().encrypt(ObjUtils.getSafeString(param.get("userpw"))));
			// 비밀번호 확인
			String userId = loginService.passwordCheck(param);

			// 중복 로그인 체크
			if (ObjUtils.isEmpty(userId)) {
				return ApiResult.fail(MessageUtils.getMessage("msg.login.loginFail", locale));
			}

			loginVO = loginService.getUserInfoByUserID(userId);
		}
		return ApiResult.success(loginVO);
	}

	@RequestMapping(value = "/stockItem", method = RequestMethod.GET)
	@ResponseBody
	public ApiResult getItemByCode(@RequestParam("compCode") String compCode, @RequestParam("divCode") String divCode,
			@RequestParam(value = "itemCode") String itemCode,
			@RequestParam(value = "whCode", required = false) String whCode,
			@RequestParam(value = "whCellCode", required = false) String whCellCode,
			@RequestParam(value = "lotNo") String lotNo) throws Exception {

		logger.debug("params >>>>>> compCode: {}, divCode: {}, itemCode: {}, whCode: {}, whCellCode:{}, lotNo:{}",
				compCode, divCode, itemCode, whCode, whCellCode, lotNo);

		Map<String, Object> params = new HashMap<>();
		params.put("COMP_CODE", compCode);
		params.put("DIV_CODE", divCode);
		params.put("ITEM_CODE", itemCode);
		params.put("WH_CODE", whCode);
		params.put("WH_CELL_CODE", whCellCode);
		params.put("LOT_NO", lotNo);

		Map<String, Object> item = pdaBasicService.getStockItem(params);
		if (ObjUtils.isEmpty(item)) {
			if (ObjUtils.isEmpty(whCellCode)) {
				return ApiResult
						.fail("품목정보 (창고:" + whCode + ", 품목:" + itemCode + ", lotNo: " + lotNo + ")  가 존재하지 않습니다.");
			}
			return ApiResult.fail("품목정보 (창고:" + whCode + ", Cell: " + whCellCode + ", 품목:" + itemCode + ", lotNo: "
					+ lotNo + ")  가 존재하지 않습니다.");
		}
		return ApiResult.success(item);
	}

	@RequestMapping(value = "/baseItem", method = RequestMethod.GET)
	@ResponseBody
	public ApiResult baseItem(@RequestParam HashMap<String, Object> paramMap) throws Exception {

//		logger.debug("params >>>>>> compCode: {}, divCode: {}, itemCode: {}", compCode, divCode, itemCode);
//
		Map<String, Object> params = new HashMap<>();
		params.put("COMP_CODE", paramMap.get("compCode"));
		params.put("DIV_CODE", paramMap.get("divCode"));
		params.put("ITEM_CODE", paramMap.get("itemCode"));
		params.put("LOT_NO", paramMap.get("lotNo"));

		Map<String, Object> item = pdaBasicService.getBaseItem(params);
		if (ObjUtils.isEmpty(item)) {
			return ApiResult.fail("품목정보 (item: " + paramMap.get("itemCode") + ")가  존재하지 않습니다.");
		}
		Double inStockQ = 0.0;
		inStockQ = ObjUtils.parseDouble(item.get("INSTOCK_Q"));
		if(inStockQ == 0){
			return ApiResult.fail("입고 할 수량이 없습니다.");
		}
		return ApiResultUtil.result(item);
	}

	@RequestMapping(value = "/config", method = RequestMethod.GET)
	@ResponseBody
	public ApiResult config(@RequestParam("compCode") String compCode, @RequestParam("divCode") String divCode,
			@RequestParam(value = "dataCode", required = false) String dataCode) throws Exception {

		logger.debug("params >>>>>> compCode: {}, divCode: {}, dataCode: {}", compCode, divCode, dataCode);

		Map<String, Object> params = new HashMap<>();
		params.put("COMP_CODE", compCode);
		params.put("DIV_CODE", divCode);
		params.put("DATA_CODE", dataCode);

		List<Map> list = pdaBasicService.selectConfigList(params);
		return ApiResult.success(list);
	}

	@RequestMapping(value = "/config", method = RequestMethod.POST)
	@ResponseBody
	public ApiResult config(@RequestBody ConfigDTO configDTO) throws Exception {

		logger.debug("params >>>>>> {}", configDTO.toString());

		Map<String, Object> params = new HashMap<>();
		params.put("COMP_CODE", configDTO.getCompCode());
		params.put("DIV_CODE", configDTO.getDivCode());
		params.put("DATA_CODE", configDTO.getDataCode());
		params.put("DATA_VALUE", configDTO.getDataValue());
		params.put("DATA_NAME", configDTO.getDataName());
		params.put("USER_ID", configDTO.getUserInfo().getUserID());

		try {
			pdaBasicService.saveConfig(params);
		} catch (Exception e) {
			logger.debug(e.getMessage());
			e.printStackTrace();
			return ApiResult.fail(e.getMessage());
		}
		return ApiResult.success();
	}

	@RequestMapping(value = "/common", method = RequestMethod.GET)
	@ResponseBody
	public ApiResult getMainCodeInfo(@RequestParam("compCode") String compCode,
			@RequestParam("mainCode") String mainCode,
			@RequestParam(value = "subCode", required = false) String subCode) {

		logger.debug("params >>>>>> compCode: {}, mainCode: {}, subCode: {}", compCode, mainCode, subCode);

		Map<String, Object> params = new HashMap<>();
		params.put("COMP_CODE", compCode);
		params.put("S_COMP_CODE", compCode);
		params.put("MAIN_CODE", mainCode);
		params.put("SUB_CODE", subCode);

		List<Map> list = pdaBasicService.selectCommonInfoList(params);
		return ApiResult.success(list);
	}

	@RequestMapping(value = "/pdaPgmInfoList", method = RequestMethod.GET)
	@ResponseBody
	public ApiResult getPdaPgmInfoList(@RequestParam("compCode") String compCode) {

		Map<String, Object> params = new HashMap<>();
		params.put("COMP_CODE", compCode);

		List<Map> list = pdaBasicService.getPdaPgmInfoList(params);
		return ApiResult.success(list);
	}
	
	@RequestMapping(value = "/searchWhCode", method = RequestMethod.GET)
	@ResponseBody
	public ApiResult getPdaPgmInfoList(@RequestParam("compCode") String compCode,@RequestParam("divCode") String divCode) {

		Map<String, Object> params = new HashMap<>();
		params.put("COMP_CODE", compCode);
		params.put("DIV_CODE", divCode);

		List<Map> list = pdaBasicService.getWhcodeList(params);
		return ApiResult.success(list);
	}
	
}
