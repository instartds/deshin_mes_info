package foren.unilite.modules.z_sk;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.ss.usermodel.Workbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.google.gson.Gson;

import foren.framework.lib.listop.ListOp;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.framework.model.NavigatorInfo;
import foren.framework.utils.ObjUtils;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.com.code.CodeDetailVO;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.com.tags.ComboItemModel;

@Controller
public class Z_skController extends UniliteCommonController {
	private final Logger	logger		= LoggerFactory.getLogger(this.getClass());
	final static String		JSP_PATH	= "/z_sk/";

	@Resource( name = "s_pmr140rkrv_skService" )
	private S_pmr140rkrv_skServiceImpl S_pmr140rkrv_skService;

	
	@SuppressWarnings( "unused" )
	@RequestMapping( value = "/z_sk/s_pmr140rkrv_sk.do" )
	public String agc170rkr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		return JSP_PATH + "s_pmr140rkrv_sk";
	}

	@RequestMapping(value = "/z_sk/s_pmr140rkrv_skExcelDown.do")
	public ModelAndView hpa990ukrDownLoadExcel(ExtHtttprequestParam _req, HttpServletResponse response, LoginVO login) throws Exception{	
		Map<String, Object> paramMap = _req.getParameterMap();
		String templateType = ObjUtils.getSafeString(paramMap.get("TEMPLATE_TYPE"));
		Workbook wb = null;
		String title = "일일업무보고";
		if("1".equals(templateType))	{
			 wb = S_pmr140rkrv_skService.makeExcel1(paramMap, login);
			 title = "공장업무일지";
		} else {
			wb = S_pmr140rkrv_skService.makeExcel2(paramMap, login);
			 title = "제품원재료수불명세서";
		}
        return ViewHelper.getExcelDownloadView(wb, title);
	}
}