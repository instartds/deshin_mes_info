package foren.unilite.modules.openapi.search;


import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


import org.apache.http.client.utils.URIBuilder;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.type.TypeFactory;

import foren.framework.model.ExtHtttprequestParam;
import foren.framework.utils.JsonUtils;
import foren.framework.utils.ObjUtils;
import foren.framework.web.view.ViewHelper;
import foren.framework.web.view.resolver.HTTPResponseUtils;

@Controller
public class NaverRestfullApiController {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	private final String clientId = "wefy2V1XpNOlrvlXkFJz";//애플리케이션 클라이언트 아이디값";
	private final String clientSecret = "aeLlGlp2Qw";//애플리케이션 클라이언트 시크릿값";
	/**
	 * 도서 기본검색
	 * 
	 * 	key string (필수)  이용 등록을 통해 받은 key 스트링을 입력합니다. 
		target string (필수) : book  서비스를 위해서는 무조건 지정해야 합니다. 
		query string (필수)  검색을 원하는 질의, UTF-8 인코딩 입니다. 
		display integer : 기본값 10, 최대 100  검색결과 출력건수를 지정합니다. 최대 100 까지 가능합니다. 
		start  integer : 기본값 1, 최대 1000  검색의 시작위치를 지정할 수 있습니다. 최대 1000 까지 가능합니다 

	 * @param request
	 * @param _req
	 * @param session
	 * @return 검색결과 json
	 * @throws Exception
	 */
	@RequestMapping(value = "/openapi/naver/book/wsSearch.do")
	public ModelAndView searchBook(HttpServletRequest request, ExtHtttprequestParam _req, HttpSession session) throws Exception {
		Map<String, Object> param = _req.getParameterMap();		
		
		String res = this.search(param);
		
        ObjectMapper mapper = new ObjectMapper();
		List<Map> rList = mapper.readValue( res.toString(),
				TypeFactory.defaultInstance().constructCollectionType(List.class,   Map.class));
        return ViewHelper.getJsonView(rList);
        //Map<String, Object> rMap = mapper.readValue(res,   Map.class);
        //return ViewHelper.getJsonView(rMap);
	}
	
	@RequestMapping(value = "/openapi/naver/book/wsSearchAdv.do")
	public ModelAndView searchAdvBook(HttpServletRequest request, ExtHtttprequestParam _req, HttpSession session, HttpServletResponse response) throws Exception {
		Map<String, Object> param = _req.getParameterMap();		
		
		String res = this.search(param);
		
        ObjectMapper mapper = new ObjectMapper();
		/*List<Map> rList = mapper.readValue( res.toString(),
				TypeFactory.defaultInstance().constructCollectionType(List.class,   Map.class));*/
        Map<String, Object> rMap = mapper.readValue(res,   Map.class);
        return ViewHelper.getJsonView(rMap);
		
	}
	
	/**
	 * 도서 상세검색
	 *  
	 *  target  string (필수) : book_adv  상세검색을 위해서는 무조건 지정해야 합니다. 
		query  string (필수)  검색을 원하는 질의, UTF-8 인코딩 입니다. 
		d_titl  string  책 제목에서의 검색을 의미합니다. 
		d_auth  string  저자명에서의 검색을 의미합니다. 
		d_cont  string  목차에서의 검색을 의미합니다. 
		d_isbn  string  isbn에서의 검색을 의미합니다. 
		d_publ  string  출판사에서의 검색을 의미합니다. 
		d_dafr  integer (ex.20000203)  검색을 원하는 책의 출간 범위를 지정합니다. (시작일) 
		d_dato  integer (ex.20000203)  검색을 원하는 책의 출간 범위를 지정합니다. (종료일) 
		d_catg  integer  검색을 원하는 카테고리를 지정합니다.  
		display integer : 기본값 10, 최대 100  검색결과 출력건수를 지정합니다. 최대 100 까지 가능합니다. 
		start  integer : 기본값 1, 최대 1000  검색의 시작위치를 지정할 수 있습니다. 최대 1000 까지 가능합니다. 

	 * @param request
	 * @param _req
	 * @param session
	 * @return 검색결과 json
	 * @throws Exception
	 */
	private String search(Map<String, Object>param) throws Exception	{
		String query = "query="+URLEncoder.encode((String)param.get("query"), "UTF-8");
        boolean isAdvSearch = false;
		if(param.containsKey("d_titl"))	{
			query +="&d_titl="+URLEncoder.encode((String)param.get("d_titl"), "UTF-8");
			isAdvSearch = true;
		}
		if(param.containsKey("d_auth"))	{
			query +="&d_auth="+URLEncoder.encode((String)param.get("d_auth"), "UTF-8");
			isAdvSearch = true;
		}
		if(param.containsKey("d_cont")) {
			query +="&d_cont="+URLEncoder.encode((String)param.get("d_cont"), "UTF-8");
			isAdvSearch = true;
		}
		if(param.containsKey("d_isbn"))	{
			query +="&d_isbn="+URLEncoder.encode((String)param.get("d_isbn"), "UTF-8");
			isAdvSearch = true;
		}
		if(param.containsKey("d_publ"))	{
			query +="&d_publ="+URLEncoder.encode((String)param.get("d_publ"), "UTF-8");
			isAdvSearch = true;
		}
		if(param.containsKey("d_dafr"))
			query +="&d_dafr="+URLEncoder.encode((String)param.get("d_dafr"), "UTF-8");
		if(param.containsKey("d_dato"))
			query +="&d_dato="+URLEncoder.encode((String)param.get("d_dato"), "UTF-8");
		if(param.containsKey("d_catg"))
			query +="&d_catg="+URLEncoder.encode((String)param.get("d_catg"), "UTF-8");
		if(param.containsKey("display"))
			query +="&display="+URLEncoder.encode((String)param.get("display"), "UTF-8");
		if(param.containsKey("start"))
			query +="&start="+URLEncoder.encode((String)param.get("start"), "UTF-8");
		
		String apiURL = "https://openapi.naver.com/v1/search/book?"+ query; // json 결과
		if(isAdvSearch)	{
			apiURL = "https://openapi.naver.com/v1/search/book_adv?"+ query;
		}
        //String apiURL = "https://openapi.naver.com/v1/search/blog.xml?query="+ text; // xml 결과
       
        URL url = new URL(apiURL);
        HttpURLConnection con = (HttpURLConnection)url.openConnection();
        con.setRequestMethod("GET");
        con.setRequestProperty("X-Naver-Client-Id", clientId);
        con.setRequestProperty("X-Naver-Client-Secret", clientSecret);
        //con.setRequestProperty("Content-Type", "application/json;charset=UTF-8");
        int responseCode = con.getResponseCode();
        
        BufferedReader br;
        if(responseCode==200) { // 정상 호출
            br = new BufferedReader(new InputStreamReader(con.getInputStream(),"UTF-8"));
        } else {  // 에러 발생
            throw(new Exception(new BufferedReader(new InputStreamReader(con.getInputStream(),"UTF-8")).toString()));
        }
        String inputLine;
        StringBuffer response = new StringBuffer();
        while ((inputLine = br.readLine()) != null) {
            response.append(inputLine);
        }
        br.close();
        String rtn = new String(response.toString().getBytes("UTF-8"), "UTF-8");  //response.toString();//
        
        return  response.toString();
	}


}
