package foren.unilite.modules.zDevelopPractice;

import java.io.DataOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.lang.reflect.Field;
import java.net.Socket;
import java.nio.charset.Charset;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.util.ExtDirectSpringUtil;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.type.TypeFactory;

import foren.framework.lib.listop.ListOp;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.framework.model.NavigatorInfo;
import foren.framework.utils.ConfigUtil;
import foren.framework.utils.ObjUtils;
import foren.framework.web.support.CustomHandlerMethodArgumentResolver;
import foren.framework.web.view.FileDownloadInfo;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.com.code.CodeDetailVO;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.com.tags.ComboItemModel;
import foren.unilite.modules.com.barcodePrint.BarcodePrintUtils;
import foren.unilite.modules.com.combo.ComboServiceImpl;
import foren.unilite.modules.com.tree.UniTreeNode;

import java.sql.Connection;


@Controller
public class zDevelopPracticeController extends UniliteCommonController {
	private final Logger	logger		= LoggerFactory.getLogger(this.getClass());
	final static String		JSP_PATH	= "/zdeveloppractice/";

	@Resource(name="UniliteComboServiceImpl")
	private ComboServiceImpl comboService;

	/**
	 * 개발연습1(조회/출력)
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/zdeveloppractice/practice1.do")
	public String practice1(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();
		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));

		return JSP_PATH + "practice1";
	}
	

	/**
	 * 개발연습2(폼/그리드 저장) - 20210416
	 * @param loginVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/zdeveloppractice/practice2.do", method = RequestMethod.GET )
	public String practice2( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		cdo = codeInfo.getCodeInfo("B084", "D");
		if (!ObjUtils.isEmpty(cdo)) model.addAttribute("gsCellCodeYN", cdo.getRefCode1());

		cdo = codeInfo.getCodeInfo("B259", "1");	//사이트 구분 운영코드
		if(ObjUtils.isNotEmpty(cdo)){
			if(ObjUtils.isNotEmpty(cdo.getCodeName())){
				model.addAttribute("gsSiteCode", cdo.getCodeName().toUpperCase());
			}else{
				model.addAttribute("gsSiteCode", "STANDARD");
			}
		}else {
				model.addAttribute("gsSiteCode", "STANDARD");
		}
		return JSP_PATH + "practice2";
	}
	
	/**
	 * 개발연습3
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/zdeveloppractice/practice3.do")
	public String practice3skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();
		param.put("S_COMP_CODE",loginVO.getCompCode());

		return JSP_PATH + "practice3";
	}


	/**
	 * 개발연습4(사용자정보등록) - 20210413
	 * @param loginVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/zdeveloppractice/practice4.do", method = RequestMethod.GET)
	public String practice4( LoginVO loginVO, ModelMap model) throws Exception {
		CodeDetailVO cdo = null;
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		cdo = codeInfo.getCodeInfo("B265", "Y");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsSyTalkYn",cdo.getRefCode1());	//LOT관리기준 설정				RefCode1값을 gsSyTalkYn에 넣음
		return JSP_PATH + "practice4";
	}

	
	/**
	 * 개발연습6(창고정보 등록) - 20210414
	 * @param loginVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/zdeveloppractice/practice6.do", method = RequestMethod.GET)
	public String practice6( LoginVO loginVO, ModelMap model) throws Exception {
		CodeDetailVO cdo = null;
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		cdo = codeInfo.getCodeInfo("B265", "Y");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsSyTalkYn",cdo.getRefCode1());	//LOT관리기준 설정
		return JSP_PATH + "practice6";
	}
	
	
	
	/**
	 * 개발연습5(창고정보그리드 저장) - 20210419
	 * @param loginVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/zdeveloppractice/practice5.do", method = RequestMethod.GET )
	public String practice5( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		return JSP_PATH + "practice5";
	}
	
	
	/**
	 * 개발연습7(매입단가등록) - 20210422
	 */
	@RequestMapping(value = "/zdeveloppractice/practice7.do")
	public String mba033ukrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;		
		
		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
		
		List<CodeDetailVO> gsMoneyUnit = codeInfo.getCodeList("B004", "", false);
		for(CodeDetailVO map : gsMoneyUnit) {
			if("Y".equals(map.getRefCode1()))   {								//RefCode1값을 찾아서 gsMoneyUnit에 넘김
				model.addAttribute("gsMoneyUnit", map.getCodeNo());
			}
		}
		return JSP_PATH + "practice7";
	}
	
	/**
	 * 개발연습8
	 * @param loginVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/zdeveloppractice/practice8.do")
	public String practice8skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();
		param.put("S_COMP_CODE",loginVO.getCompCode());

		return JSP_PATH + "practice8";
	}
	
	
	/**
	 * 개발연습8
	 * @param loginVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/zdeveloppractice/practice9.do")
	public String practice9skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();
		param.put("S_COMP_CODE",loginVO.getCompCode());

		return JSP_PATH + "practice9";
	}
}