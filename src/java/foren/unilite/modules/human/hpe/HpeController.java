package foren.unilite.modules.human.hpe;

import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import foren.framework.lib.listop.ListOp;
import foren.framework.logging.InjectLogger;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.framework.model.NavigatorInfo;
import foren.framework.utils.ObjUtils;
import foren.framework.web.view.FileDownloadInfo;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;

@Controller
@SuppressWarnings("unused")
public class HpeController extends UniliteCommonController {
	@InjectLogger
	public static Logger		logger;
	final static String			JSP_PATH= "/human/hpe/";

	@Resource( name = "hpe500ukrService" )
	Hpe500ukrServiceImpl hpe500ukrService;

	@Resource( name = "hpe510ukrService" )
	Hpe510ukrServiceImpl hpe510ukrService;

	/**
	 * 근로소득간이지급명세서(근로소득)
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/human/hpe100ukr.do" )
	public String hpe100ukr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		return JSP_PATH + "hpe100ukr";
	}

	/**
	 * 근로소득간이지급명세서(근로소득)
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/human/hpe200skr.do" )
	public String hpe200skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		return JSP_PATH + "hpe200skr";
	}

	/**
	 * 간이지급명세서(거주자-사업소득) - 월별, 20210805 신규 생성
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/human/hpe210skr.do" )
	public String hpe210skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		return JSP_PATH + "hpe210skr";
	}

	/**
	 * 근로소득간이지급명세서(근로소득)
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/human/hpe300skr.do" )
	public String hpe300skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		return JSP_PATH + "hpe300skr";
	}

	/**
	 * 근로소득간이지급명세서신고자료생성
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/human/hpe500ukr.do" )
	public String hpe500ukr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		return JSP_PATH + "hpe500ukr";
	}

	/**
	 * 근로소득간이지급명세서신고자료생성(신고자료 다운로드)
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/human/hpe500ukrFileDown.do", method = RequestMethod.POST )
	public ModelAndView hpe500ukrFileDown( ExtHtttprequestParam _req) throws Exception {
		Map param = _req.getParameterMap();
		FileDownloadInfo fInfo = null;
		String dataFlag = ObjUtils.getSafeString(param.get("DATA_FLAG"));
		if("1".equals(dataFlag)) {
			fInfo = hpe500ukrService.doBatchWorkPay(param);
		}
		if("2".equals(dataFlag)) {
			fInfo = hpe500ukrService.doBatchBusiPayLiveIn(param);
		}
		if("3".equals(dataFlag)) {
			fInfo = hpe500ukrService.doBatchBusiPayLiveOut(param);
		}
		return ViewHelper.getFileDownloadView(fInfo);
	}

	/**
	 * 근로소득간이지급명세서신고자료생성
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/human/hpe510ukr.do" )
	public String hpe510ukr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		return JSP_PATH + "hpe510ukr";
	}

	/**
	 * 근로소득간이지급명세서신고자료생성(신고자료 다운로드)
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/human/hpe510ukrFileDown.do", method = RequestMethod.POST )
	public ModelAndView hpe510ukrFileDown( @RequestParam Map<String, String> param, LoginVO loginVO) throws Exception {
		FileDownloadInfo fInfo = null;
		String dataFlag = ObjUtils.getSafeString(param.get("DATA_FLAG"));
		param.put("S_COMP_CODE", loginVO.getCompCode()); // session 값 세팅
		
		// 근로소득
		if("1".equals(dataFlag)) {
			fInfo = hpe510ukrService.doBatchWorkPay(param);
		}
		// 거주자의 사업소득
		if("2".equals(dataFlag)) {
			fInfo = hpe510ukrService.doBatchBusiPayLiveIn(param, loginVO);
		}
		// 비거주자의 사업소득
		if("3".equals(dataFlag)) {
			fInfo = hpe510ukrService.doBatchBusiPayLiveOut(param);
		}
		return ViewHelper.getFileDownloadView(fInfo);
	}

	/**
	 * 근로소득간이지급명세서출력
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/human/hpe600rkr.do" )
	public String hpe600rkr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		return JSP_PATH + "hpe600rkr";
	}
}