package api.foren.pda2.common;

import java.io.Serializable;

public class ApiResult implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	// 성공여부
	private Boolean success;

	private Integer code;

	private String message;

	private Object data;

	private ApiResult(boolean success) {
		this.success = success;
	}

	public static ApiResult success() {
		ApiResult result = new ApiResult(true);
		result.setCode(200);
		result.setMessage("SUCCESS");
		return result;
	}

	public static ApiResult success(Object data) {
		ApiResult result = success();
		result.setData(data);
		return result;
	}

	public static ApiResult success(Object data, String message) {
		ApiResult result = success(data);
		result.setMessage(message);
		return result;
	}

	public static ApiResult fail() {
		ApiResult result = new ApiResult(false);
		result.setCode(-1);
		result.setMessage("UERROR");
		return result;
	}

	public static ApiResult fail(String message) {
		ApiResult result = fail();
		result.setMessage(message);
		return result;
	}

	public static ApiResult fail(Integer code, String message) {
		ApiResult result = fail(message);
		result.setCode(code);
		return result;
	}

	public Boolean getSuccess() {
		return success;
	}

	public void setSuccess(Boolean success) {
		this.success = success;
	}

	public Integer getCode() {
		return code;
	}

	public void setCode(Integer code) {
		this.code = code;
	}

	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}

	public Object getData() {
		return data;
	}

	public void setData(Object data) {
		this.data = data;
	}

}
