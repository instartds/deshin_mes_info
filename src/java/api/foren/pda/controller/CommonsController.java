package api.foren.pda.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.lang.ObjectUtils;
import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import api.foren.pda.service.CommonsServiceImpl;
import api.foren.pda.service.ConfigDataServiceImpl;
import api.foren.pda.util.JsonUtils;
import foren.framework.exception.UniDirectException;
import foren.framework.model.LoginVO;
import foren.framework.sec.cipher.seed.EncryptSHA256;
import foren.framework.utils.MessageUtils;
import foren.framework.utils.ObjUtils;
import foren.unilite.modules.com.combo.ComboServiceImpl;
import foren.unilite.modules.com.login.LoginServiceImpl;

@Controller
@RequestMapping("/api-storage/common")
public class CommonsController extends BaseController {

	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@Resource(name = "commonsService")
	private CommonsServiceImpl commonsService;

	@Resource(name = "loginService")
	private LoginServiceImpl loginService;

	@Resource(name = "UniliteComboServiceImpl")
	private ComboServiceImpl comboService;

	@Resource(name = "configDataService")
	private ConfigDataServiceImpl configDataService;

	private EncryptSHA256 enc = new EncryptSHA256();

	/**
	 * 获取所有通用代碼
	 */
	@RequestMapping("/searchAllComboboxList")
	@ResponseBody
	public Map<String, Object> searchAllComboboxList(@RequestBody String json, LoginVO user) throws UniDirectException {
		Map map = JsonUtils.jsonToMap(json);
		Map<String, Object> outMap = new HashMap<>();
		List<Map> comboboxList = commonsService.searchAllComboboxList(map);
		outMap.put("combo", comboboxList);
		outMap.put("config", configDataService.selectConfigDataList(map));
		return success(outMap);
	}

	@RequestMapping("/selectCustomList")
	@ResponseBody
	public Map<String, Object> selectCustomList(@RequestBody String json, LoginVO user) throws UniDirectException {
		Map map = JsonUtils.jsonToMap(json);
		List<Map> comboboxList = commonsService.selectCustomList(map);
		return success(comboboxList);
	}

	@RequestMapping("/selectComboList")
	@ResponseBody
	public Map<String, Object> selectComboList(@RequestBody String json, LoginVO user) throws Exception {
		Map map = JsonUtils.jsonToMap(json);
		Map<String, Object> outMap = new HashMap<>();
		outMap.put("WH_CODE", comboService.getWhList(map));
		return success(outMap);
	}

	@RequestMapping("/selectWhList")
	@ResponseBody
	public Map<String, Object> selectWhList(@RequestBody String json, LoginVO user) throws Exception {
		Map map = JsonUtils.jsonToMap(json);
		Map<String, Object> outMap = new HashMap<>();
		outMap.put("WH_CODE", comboService.getWhList(map));
		return success(outMap);
	}

	@RequestMapping("/selectWsList")
	@ResponseBody
	public Map<String, Object> selectWsList(@RequestBody String json, LoginVO user) throws Exception {
		Map map = JsonUtils.jsonToMap(json);
		Map<String, Object> outMap = new HashMap<>();
		outMap.put("WS_LIST", comboService.getWsList(map));
		return success(outMap);
	}

	@RequestMapping("/selectConfigDataList")
	@ResponseBody
	public Map<String, Object> selectConfigDataList(@RequestBody String json, LoginVO user) throws Exception {
		Map map = JsonUtils.jsonToMap(json);
		return success(configDataService.selectConfigDataList(map));
	}

	/**
	 * save InStorage list
	 */
	@RequestMapping("/saveConfigData")
	@ResponseBody
	public Map<String, Object> saveConfigData(@RequestBody String json, LoginVO user) {
		Map map = JsonUtils.parseJSON2Map(json);
		List<Map> paramList = (List<Map>) map.get("detail");

		try {
			configDataService.saveConfigData(paramList, null, null);
		} catch (Exception e) {
			logger.debug(e.getMessage());
			e.printStackTrace();
			return error(e.getMessage());
		}

		return success("Save successfully!");
	}

	/**
	 * 登录 로그인
	 */
	@RequestMapping("/login")
	@ResponseBody
	public Map<String, Object> loginProcess(@RequestBody String json) throws UniDirectException {

		LoginVO loginVO = null;

		Map param = JsonUtils.jsonToMap(json);

		String language = ObjectUtils.toString(param.get("language"));
		Locale locale = new Locale(language);

		// 查找用户
		List<Map<String, Object>> mapUserList = loginService.selectUserList(param);

		if (mapUserList == null || mapUserList.size() == 0) {
			return error(MessageUtils.getMessage("msg.login.loginFail", locale));
		} else {
			String compCode = mapUserList.get(0).get("COMP_CODE").toString();
			if (param.get("compCode") == null) {
				param.put("compCode", compCode);
			}
			boolean isCaseSensitiveYN = false;
			Map<String, Object> tempMap = new HashMap<>();
			tempMap.put("COMP_CODE", "MASTER");
			Map<?, ?> cdoMap = commonsService.selectCaseSensitiveYN(tempMap);
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
			param.put("userpw", enc.encrypt(ObjUtils.getSafeString(param.get("userpw"))));
			// 校验密码
			String userId = loginService.passwordCheck(param);

			// 중복 로그인 체크
			if (ObjUtils.isEmpty(userId)) {
				return error(MessageUtils.getMessage("msg.login.loginFail", locale));
			}

			loginVO = loginService.getUserInfoByUserID(userId);
		}

		param.put("loginVO", loginVO);
		return success(param);
	}
}
