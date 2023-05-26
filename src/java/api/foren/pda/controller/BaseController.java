package api.foren.pda.controller;

import java.util.HashMap;
import java.util.Map;

import foren.unilite.com.UniliteCommonController;

public class BaseController extends UniliteCommonController {

	public Map<String, Object> success(Object data) {
		Map<String, Object> result = new HashMap<String, Object>();
		result.put("status", "SUCCESS");
		result.put("data", data);
		return result;
	}

	public Map<String, Object> error(Object msg) {
		Map<String, Object> result = new HashMap<String, Object>();
		result.put("status", "ERROR");
		result.put("msg", msg);
		return result;
	}
}
