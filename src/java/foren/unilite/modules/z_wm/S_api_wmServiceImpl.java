package foren.unilite.modules.z_wm;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.Map.Entry;

import javax.annotation.Resource;

import org.json.JSONArray;
import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.stereotype.Service;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;
import org.apache.commons.lang.StringUtils;
import org.apache.http.Consts;
import org.apache.http.Header;
import org.apache.http.HttpEntity;
import org.apache.http.HttpRequest;
import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.ResponseHandler;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.client.methods.HttpPut;
import org.apache.http.entity.ByteArrayEntity;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.protocol.HttpContext;
import org.apache.http.util.EntityUtils;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.type.TypeFactory;
import com.google.gson.Gson;

import foren.framework.model.LoginVO;
import foren.framework.utils.JsonUtils;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;

import org.apache.commons.httpclient.*;

import com.fasterxml.jackson.databind.*;


@Service("s_api_wmService")
@SuppressWarnings({"rawtypes", "unchecked", "static-access"})
public class S_api_wmServiceImpl extends TlabAbstractServiceImpl {
	private final Logger		logger		= LoggerFactory.getLogger(this.getClass());
	private static final String	X_API_KEY	= "eKXnc1U5qX4xqV1gF8mzb2aQTJi3Zcpg9GmVPPdX";//X-API-KEY
	private static final String	API_E_MAIL	= "bonoyahana@hanmail.net";
	private static final String	API_PW		= "Wwc1818!!";

	@Resource(name="s_sof103ukrv_wmService")
	private S_Sof103ukrv_wmServiceImpl s_sof103ukrv_wmService;



	/**
	 * playauto API 데이터 가져오는 로직
	 * @param url
	 * @param params
	 * @param user
	 * @return
	 * @throws Exception
	 */
	public Map requestApiData(String url, Map<String,Object> params, LoginVO user) throws Exception {
		Map rMap					= new HashMap();
		Map token					= this.getToken(user);			//Token 발급로직 호출
		CloseableHttpClient client	= HttpClients.createDefault();
		HttpPost httpPost			= new HttpPost(url);
//		if(ObjUtils.isNotEmpty(token.get("SDATE"))) {				//20210319 주석: 화면에서 가져오는 로직으로 변경
//			params.put("sdate", token.get("SDATE"));
//		}

		httpPost.setHeader("Content-type"	, "application/json;charset=UTF-8");
		httpPost.setHeader("X-API-KEY"		, this.X_API_KEY);
		httpPost.setHeader("Authorization"	, "Token " + token.get("TOKEN"));

		Gson gson				= new Gson();
		String json				= gson.toJson(params);
		StringEntity entity1	= new StringEntity(json, "UTF-8");
		httpPost.setEntity(entity1);
		HttpResponse response	= client.execute(httpPost);
		HttpEntity entity		= response.getEntity();
		String resText			= EntityUtils.toString(entity, StandardCharsets.UTF_8);
		ObjectMapper mapper		= new ObjectMapper();
		rMap					= mapper.readValue(resText, Map.class);

		if(rMap != null) {
			if(ObjUtils.isNotEmpty(rMap.get("error")) && rMap.get("error").getClass().getName() == "java.lang.String") {
				throw new UniDirectValidateException(ObjUtils.getSafeString("토큰이 만료되었습니다." + "\n" + "공통코드(ZM10)에서 토큰값을 삭제하신 후 다시 진행하세요." + "\n" + "(error: " + rMap.get("error") + ")"));
			} else {
				Map error = (Map) rMap.get("error");
				if(ObjUtils.isNotEmpty(error)) {
					Map errorMap = mapper.readValue(resText, Map.class);
					if(errorMap != null) {
						Map errorDetail = (Map) errorMap.get("error");
						if(errorDetail != null) {
							throw new UniDirectValidateException("Error Code : "+ errorDetail.get("error_code")+" \n message : "+errorDetail.get("message"));
						} else {
							throw new UniDirectValidateException("API 인터페이스에 오류가 있습니다.");
						}
					} else {
						throw new UniDirectValidateException("API 인터페이스에 오류가 있습니다.");
					}
				}
			}
		}
		return rMap;
	}






	/**
	 * 토큰 존재여부 확인하여 없으면 createNewToken 호출하여 생성
	 * @param user
	 * @return
	 * @throws Exception
	 */
	public Map getToken(LoginVO user) throws Exception {
		Map token		= new HashMap();
		Map newToken	= new HashMap();
		Map tokenParam	= new HashMap();
		tokenParam.put("S_COMP_CODE", user.getCompCode());
		tokenParam.put("S_USER_ID"	, user.getUserID());

		token = this.checkToken(tokenParam, user);								//공통코드에 유효한 토큰 존재여부 확인
		if(ObjUtils.isEmpty(token) || ObjUtils.isEmpty(token.get("TOKEN"))) {
			newToken.put("TOKEN", this.createNewToken(user));					//발급된 유효한 토큰이 없을 경우, 신규 토큰 발급
			return newToken;
		} else {
			return token;
		}
	}

	/**
	 * 토큰 존재여부 / 시작일자 체크
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	private Map checkToken(Map param, LoginVO user) throws Exception {
		return (Map) super.commonDao.select("s_api_wmServiceImpl.checkToken", param);
	}

	/**
	 * 발급된 유효한 토큰이 없을 경우, 토큰 값 가져오는 로직
	 * @param user
	 * @return
	 * @throws Exception
	 */
	private String createNewToken(LoginVO user) throws Exception {
		String token				= "";
		CloseableHttpClient client	= HttpClients.createDefault();
		HttpPost httpPost			= new HttpPost("https://openapi.playauto.io/api/auth");

		httpPost.setHeader("Accept"			, "application/json");
		httpPost.setHeader("Content-type"	, "application/json");
		httpPost.setHeader("X-API-KEY"		, this.X_API_KEY);
		
		Map<String,Object> params = new HashMap<>();
		params.put("email"		, this.API_E_MAIL);
		params.put("password"	, this.API_PW);

		List<NameValuePair> formParams = new ArrayList<NameValuePair>();
		for (Map.Entry<String,Object> param : params.entrySet()) {
			formParams.add(new BasicNameValuePair(param.getKey(), ObjUtils.getSafeString(param.getValue())));
		}
		Gson gson				= new Gson();
		String json				= gson.toJson(params);
		StringEntity entity1	= new StringEntity(json, "UTF-8");
		httpPost.setEntity(entity1);

		HttpResponse response	= client.execute(httpPost);
		HttpEntity entity		= response.getEntity();
		String resText			= EntityUtils.toString(entity, StandardCharsets.UTF_8);

		ObjectMapper mapper	= new ObjectMapper();
		List<Map> rList		= mapper.readValue(resText, TypeFactory.defaultInstance().constructCollectionType(List.class, Map.class));
		if(rList != null && rList.size() > 0) {
			token = ObjUtils.getSafeString(rList.get(0).get("token"));
			if(ObjUtils.isNotEmpty(token)) {
				Map tokenParam = new HashMap();
				tokenParam.put("TOKEN"		, token);
				tokenParam.put("S_COMP_CODE", user.getCompCode());
				tokenParam.put("S_USER_ID"	, user.getUserID());
				this.updateToken(tokenParam, user);
			} else {
				Map errorMap = mapper.readValue( resText ,Map.class);
				if(errorMap != null) {
					Map errorDetail = (Map) errorMap.get("error");
					if(errorDetail != null) {
						throw new UniDirectValidateException("Error Code : "+ errorDetail.get("error_code")+" \n message : "+errorDetail.get("message"));
					} else {
						throw new UniDirectValidateException("API 토큰이 발행되지 않았습니다.");
					}
				} else {
					throw new UniDirectValidateException("API 토큰이 발행되지 않았습니다.");
				}
			}
		} else {
			throw new UniDirectValidateException("API 토큰이 발행되지 않았습니다.");
		}
		return token;
	}

	/**
	 * 토큰 값 공통코드에 UPDATE
	 * @param paramList
	 * @param user
	 * @param paramMaster
	 * @return
	 * @throws Exception
	 */
	private void updateToken(Map param, LoginVO user) throws Exception {
		super.commonDao.update("s_api_wmServiceImpl.updateToken", param);
		return;
	}





	/**
	 * playauto 배송정보 업데이트 api 호출 - 20201221 공통 api service로 이동
	 * @param params
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "z_wm")
	public String updateAPITrsIvoiceNum(Map<String,Object> params, LoginVO user) throws Exception {
		CloseableHttpClient client		= HttpClients.createDefault();
		String url						= "https://openapi.playauto.io/api/order/setInvoice";	//주문 - 배송정보 업데이트 api
		HttpPut httpPut					= new HttpPut(url);
		Map token						= this.getToken(user);									//Token 발급로직 호출
		//20201223 추가: 택배사 코드 가져오는 로직 추가
		/////////////////////////////////////////////////////보류 진행 시 주석해제
//		String carNo					= (String) super.commonDao.select("s_api_wmServiceImpl.getCarNo", params);

		//header 데이터 생성
		httpPut.setHeader("Content-type"	, "application/json");
		httpPut.setHeader("X-API-KEY"		, this.X_API_KEY);
		httpPut.setHeader("Authorization"	, "Token " + token.get("TOKEN"));

		//필요한 파라미터 생성
		Map<String,Object> orderMap		= new HashMap();				//호출 시 넘길 최종 parameter
		ArrayList updateList			= new ArrayList();				//orders LIST
		Map<String,Object> updateParam	= new HashMap();				//orders LIST 안에 들어갈 param

		//orders LIST 안에 들어갈 데이터 생성 / liset에 add
		updateParam.put("bundle_no"		, params.get("BUNDLE_NO"));
		updateParam.put("carr_no"		, "4");						//params.get("SENDER_CODE") - 대한통운(4)
		updateParam.put("invoice_no"	, params.get("INVOICE_NUM"));
		updateList.add(updateParam);

		//최종 parameter에 data put
		orderMap.put("orders"			, updateList);
		orderMap.put("overwrite"		, true);		//이미 송장번호가 입력되어있는 주문일경우 신규정보로 덮어쓸지 여부, 20210226 수정: true
		orderMap.put("change_complete"	, false);		//송장번호와 택배사가 정상 반영된경우 변경할 주문상태 (true:출고완료, false:운송장출력)

		//API 호출 시 사용할 parameter로 변환
		StringEntity entity1 = new StringEntity(JsonUtils.toJsonStr(orderMap).toString(), "UTF-8");
		httpPut.setEntity(entity1);

		//api 호출 / 메시지 처리
		String responseBody = client.execute(httpPut, responseHandler);
		return responseBody;
	}

	/**
	 * playauto 배송정보 업데이트 api 호출 후, 결과값 처리: 20201222 추가
	 */
	ResponseHandler<String> responseHandler = new ResponseHandler<String>() {
		@Override
		public String handleResponse(HttpResponse httpResponse) throws ClientProtocolException, IOException {
			HttpEntity entity1		= httpResponse.getEntity();
			String resText			= EntityUtils.toString(entity1, StandardCharsets.UTF_8);
			ArrayList<Map> result	= (ArrayList) JsonUtils.fromJsonStr(resText);
			String err_msg			= "";
			if("실패".equals(result.get(0).get("result"))) {
				err_msg = result.get(0).get("error_code") + ": " + result.get(0).get("message");
			}
			/* Get status code */
			int httpResponseCode = httpResponse.getStatusLine().getStatusCode();
			System.out.println("Response code: " + httpResponseCode);
			if(httpResponseCode >= 200 && httpResponseCode < 300) {
				if(ObjUtils.isEmpty(err_msg)) {
					return "0";
				} else {
					return err_msg;
				}
			} else {
				return resText;
			}
		}
	};





	/**
	 * playauto 출고지시 api 호출 - 20210108 추가
	 * @param params
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "z_wm")
	public String updateAPIoutStockOrderStatus(Map<String,Object> params, LoginVO user) throws Exception {
		CloseableHttpClient client		= HttpClients.createDefault();
		String url						= (String) params.get("url");
		HttpPut httpPut					= new HttpPut(url);
		Map token						= this.getToken(user);									//Token 발급로직 호출

		//header 데이터 생성
		httpPut.setHeader("Content-type"	, "application/json");
		httpPut.setHeader("X-API-KEY"		, this.X_API_KEY);
		httpPut.setHeader("Authorization"	, "Token " + token.get("TOKEN"));

		//필요한 파라미터 생성
		Map<String,Object> orderMap = new HashMap();				//호출 시 넘길 최종 parameter
		//최종 parameter에 data put
		orderMap.put("bundle_codes"	, params.get("bundle_codes"));
		orderMap.put("auto_bundle"	, params.get("auto_bundle"));

		//API 호출 시 사용할 parameter로 변환
		StringEntity entity1 = new StringEntity(JsonUtils.toJsonStr(orderMap).toString(), "UTF-8");
		httpPut.setEntity(entity1);

		//api 호출 / 메시지 처리
		String responseBody = client.execute(httpPut, responseHandler_outStockOrder);
		return responseBody;
	}

	/**
	 * playauto 출고지시 api 호출 후, 결과값 처리: 20200108 추가
	 */
	ResponseHandler<String> responseHandler_outStockOrder = new ResponseHandler<String>() {
		@Override
		public String handleResponse(HttpResponse httpResponse) throws ClientProtocolException, IOException {
			HttpEntity entity1		= httpResponse.getEntity();
			String resText			= EntityUtils.toString(entity1, StandardCharsets.UTF_8);
			Map result				= (Map) JsonUtils.fromJsonStr(resText);
			Map error				= (Map) result.get("error");
			String err_msg			= "";
			if(ObjUtils.isNotEmpty(error)) {
				Map errorDetail = (Map) error.get("error");
				if(errorDetail != null) {
					err_msg = "Error Code : "+ errorDetail.get("error_code")+" \n message : "+errorDetail.get("message");
				} else {
					err_msg = "API 인터페이스에 오류가 있습니다.";
				}
			}
			/* Get status code */
			int httpResponseCode = httpResponse.getStatusLine().getStatusCode();
			System.out.println("Response code: " + httpResponseCode);
			if(httpResponseCode >= 200 && httpResponseCode < 300) {
				if(ObjUtils.isEmpty(err_msg)) {
					return "0";
				} else {
					return err_msg;
				}
			} else {
				return resText;
			}
		}
	};





















/*	public List<Map> requestApiDataList(String url, Map<String,Object> params, LoginVO user) throws Exception {
		List<Map> rList				= new ArrayList<Map>();
		String token				= this.getToken(user);
		CloseableHttpClient client	= HttpClients.createDefault();
		HttpPost httpPost			= new HttpPost(url);

		httpPost.setHeader("Content-type"	, "application/json;charset=UTF-8");
		httpPost.setHeader("X-API-KEY"		, this.X_API_KEY);
		httpPost.setHeader("Authorization"	, "Token " + token);

		List<NameValuePair> formParams = new ArrayList<NameValuePair>();
		for (Map.Entry<String,Object> param : params.entrySet()) {
			formParams.add(new BasicNameValuePair(param.getKey(), ObjUtils.getSafeString(param.getValue())));
		}
		Gson gson				= new Gson();
		String json				= gson.toJson(params);
		StringEntity entity1	= new StringEntity(json, "UTF-8");
		httpPost.setEntity(entity1);
		HttpResponse response	= client.execute(httpPost);
		HttpEntity entity		= response.getEntity();
		String resText			= EntityUtils.toString(entity, StandardCharsets.UTF_8);
		ObjectMapper mapper		= new ObjectMapper();
		rList					= mapper.readValue(resText, TypeFactory.defaultInstance().constructCollectionType(List.class, Map.class));
		
		if(rList != null && rList.size() > 0 ) {
			Map error = (Map) rList.get(0).get("error");
			if(ObjUtils.isNotEmpty(error)) {
				Map errorMap = mapper.readValue( resText ,Map.class);
				if(errorMap != null) {
					Map errorDetail = (Map) errorMap.get("error");
					if(errorDetail != null) {
						throw new UniDirectValidateException("Error Code : "+ errorDetail.get("error_code")+" \n message : "+errorDetail.get("message"));
					} else {
						throw new UniDirectValidateException("API 인터페이스에 오류가 있습니다.");
					}
				} else {
					throw new UniDirectValidateException("API 인터페이스에 오류가 있습니다.");
				}
			}
		}
		return rList;
	}*/
}