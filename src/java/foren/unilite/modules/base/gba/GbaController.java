package foren.unilite.modules.base.gba;


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
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import foren.framework.lib.listop.ListOp;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.framework.model.NavigatorInfo;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.com.code.CodeDetailVO;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.modules.com.combo.ComboServiceImpl;

@Controller
public class GbaController extends UniliteCommonController {

	private final Logger	logger		= LoggerFactory.getLogger(this.getClass());

	final static String		JSP_PATH	= "/base/gba/";
	
	
	@Resource(name="UniliteComboServiceImpl")
	private ComboServiceImpl comboService;
	
	@Resource(name="gbaExcelService")
	private GbaExcelServiceImpl gbaExcelService;

	/**
	 * 예산코드등록
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/base/gba010ukrv.do",method = RequestMethod.GET)
	public String gba010ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
	
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;
		
		return JSP_PATH + "gba010ukrv";
	}
	//gba220skrv的controller
	@RequestMapping(value = "/base/gba220skrv.do",method = RequestMethod.GET)
	public String gba220skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
	
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;
		
		return JSP_PATH + "gba220skrv";
	}
	//gba230skrv的controller
		@RequestMapping(value = "/base/gba230skrv.do",method = RequestMethod.GET)
		public String gba230skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
			
			final String[] searchFields = {  };
			NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
			LoginVO session = _req.getSession();
			Map<String, Object> param = navigator.getParam();
			String page = _req.getP("page");
		
			CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
			CodeDetailVO cdo = null;
			
			return JSP_PATH + "gba230skrv";
		}
		
		@RequestMapping(value = "/base/gba240skrv.do",method = RequestMethod.GET)
		public String gba240skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
			
			final String[] searchFields = {  };
			NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
			LoginVO session = _req.getSession();
			Map<String, Object> param = navigator.getParam();
			String page = _req.getP("page");
		
			CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
			CodeDetailVO cdo = null;
			
			return JSP_PATH + "gba240skrv";
		}
		/**
		 * 프로젝트경비등록
		 * @return
		 * @throws Exception
		 */
		@RequestMapping(value = "/base/gba100ukrv.do",method = RequestMethod.GET)
		public String gba100ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
			
			final String[] searchFields = {  };
			NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
			LoginVO session = _req.getSession();
			Map<String, Object> param = navigator.getParam();
			String page = _req.getP("page");
		
			CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
			CodeDetailVO cdo = null;
			
			return JSP_PATH + "gba100ukrv";
		}
		
		/**
		 * 개발프로젝트 경비등록
		 * @return
		 * @throws Exception
		 */
		@RequestMapping(value = "/base/gba110ukrv.do",method = RequestMethod.GET)
		public String gba110ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
			
			final String[] searchFields = {  };
			NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
			LoginVO session = _req.getSession();
			Map<String, Object> param = navigator.getParam();
			String page = _req.getP("page");
		
			CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
			CodeDetailVO cdo = null;
			
			return JSP_PATH + "gba110ukrv";
		}
		
		/**
		 * 개발프로젝트 경비등록
		 * @return
		 * @throws Exception
		 */
		@RequestMapping(value = "/base/gba200skrv.do",method = RequestMethod.GET)
		public String gba200skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
			
			final String[] searchFields = {  };
			NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
			LoginVO session = _req.getSession();
			Map<String, Object> param = navigator.getParam();
			String page = _req.getP("page");
		
			CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
			CodeDetailVO cdo = null;
			
			return JSP_PATH + "gba200skrv";
		}

		@ResponseBody
		@RequestMapping(value = "/base/gba210skrvExcelDown.do")
		public ModelAndView gba210skrvDownLoadExcel(ExtHtttprequestParam _req, HttpServletResponse response) throws Exception{	
			Map<String, Object> paramMap = _req.getParameterMap();
			Workbook wb = gbaExcelService.makeExcel(paramMap);
	        String title = "프로젝트별 손익예산서";
	        
	        return ViewHelper.getExcelDownloadView(wb, title);
		}
		
	
}
