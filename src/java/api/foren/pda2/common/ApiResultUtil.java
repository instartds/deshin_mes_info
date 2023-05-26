package api.foren.pda2.common;

import foren.framework.utils.ObjUtils;

public class ApiResultUtil {

	private static final String EMPTY_DATA = "data is not found";

	public static ApiResult result(Object data) {
		if (ObjUtils.isEmpty(data)) {
			return ApiResult.fail(EMPTY_DATA);
		} else {
			return ApiResult.success(data);
		}
	}

}
