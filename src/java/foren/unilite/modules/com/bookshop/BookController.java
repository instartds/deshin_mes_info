package foren.unilite.modules.com.bookshop;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.nio.charset.Charset;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.DisposableBean;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.FileCopyUtils;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.method.HandlerMethod;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.method.annotation.RequestMappingHandlerAdapter;
import org.springframework.web.util.WebUtils;

import com.fasterxml.jackson.core.JsonEncoding;
import com.fasterxml.jackson.core.JsonGenerationException;
import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.ibatis.common.jdbc.exception.NestedSQLException;

import ch.ralscha.extdirectspring.bean.BaseResponse;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import ch.ralscha.extdirectspring.bean.ExtDirectResponse;
import ch.ralscha.extdirectspring.controller.Configuration;
import ch.ralscha.extdirectspring.util.ExtDirectSpringUtil;
import ch.ralscha.extdirectspring.util.JsonHandler;
import ch.ralscha.extdirectspring.util.MethodInfo;
import ch.ralscha.extdirectspring.util.MethodInfoCache;
import ch.ralscha.extdirectspring.util.ParametersResolver;
import foren.framework.logging.InjectLogger;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.framework.utils.ConfigUtil;
import foren.framework.utils.HtmlUtils;
import foren.framework.utils.JsonUtils;
import foren.framework.utils.ObjUtils;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.com.code.CodeDetailVO;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.com.constants.Unilite;
import foren.unilite.com.menu.UniModuleModel;
import foren.unilite.com.service.impl.TlabMenuService;
import foren.unilite.modules.base.bpr.Bpr102ukrvServiceImpl;
import foren.unilite.modules.com.combo.ComboServiceImpl;

@Controller
public class BookController extends UniliteCommonController {
	
	@InjectLogger
	public static   Logger	logger	;//	= LoggerFactory.getLogger(this.getClass());

	final static String		JSP_PATH	= "/com/bookshop/";
	
	@Resource(name = "tlabMenuService")
	TlabMenuService tlabMenuService;
	
	@Resource(name = "bookshopService")
	BookshopServiceImpl bookshopService;
	
	
	/**
	 * 도서검색
	 * @param model
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/bookshop/searchBooks.do", method = RequestMethod.GET)
	public String bookSearch(ModelMap model, HttpServletRequest request) throws Exception {
		
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("S_COMP_CODE", "MASTER");
			
		model.put("contextList", getContextListJson());
		model.put("contextName", Unilite.getCurrentContextName(request.getContextPath()));
		//model.addAttribute("gsUserDiv", loginVO.getDivCode());
		model.addAttribute("BOR120", bookshopService.getDivList(param));
		return JSP_PATH + "searchBooks";
	}	
	
	 @RequestMapping(value = "/bookshop/search.do", method = RequestMethod.POST)
	 public ModelAndView search(ExtHtttprequestParam _req, HttpSession session) throws Exception {
		 Map<String, Object> param = _req.getParameterMap();
		 List<Map> results = new ArrayList();
		 	if(ObjUtils.isEmpty(param.get("S_COMP_CODE")))	{
		 		param.put("S_COMP_CODE", "MASTER");
		 	}
	        if(ObjUtils.getSafeString(param.get("BOOK_GUBUN")).equals("R"))	{
	        	results = bookshopService.selectRefList(param);
	        }else {
	        	results = bookshopService.selectList(param);
	        }
	        return ViewHelper.getJsonView(results);
	 }
	 
	 
	 @RequestMapping(value = "/bookshop/searchMenu.do", method = RequestMethod.POST)
	 public ModelAndView searchMenu(ExtHtttprequestParam _req, HttpSession session) throws Exception {
		 Map<String, Object> param = _req.getParameterMap();       
		 Object results = new ArrayList();
		 if(ObjUtils.isEmpty(param.get("S_COMP_CODE")))	{
	 		param.put("S_COMP_CODE", "MASTER");
	 	 }
		 if(ObjUtils.isNotEmpty(param.get("searchStr")))	{
	        results = bookshopService.searchMenu(param);
		 }
	      return ViewHelper.getJsonView(results);
	 }
	 
	 private StringBuffer getContextListJson() {
	
       return JsonUtils.toJsonStr(Unilite.getContextList());
	}
}
