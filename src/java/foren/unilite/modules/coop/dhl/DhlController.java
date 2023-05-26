package foren.unilite.modules.coop.dhl;

import java.io.File;
import java.io.IOException;
import java.io.ObjectOutputStream;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import foren.framework.lib.listop.ListOp;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.framework.model.NavigatorInfo;
import foren.framework.utils.ObjUtils;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.com.code.CodeDetailVO;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.modules.com.combo.ComboServiceImpl;
import foren.unilite.modules.human.HumanUtils;
import net.sf.jasperreports.engine.JRConstants;
import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.JRRuntimeException;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.JasperReport;
import net.sf.jasperreports.engine.util.JRLoader;


@Controller
public class DhlController extends UniliteCommonController {

	public static String path;

	private final Logger	logger		= LoggerFactory.getLogger(this.getClass());

	final static String		JSP_PATH	= "/coop/dhl/";
	public final static String FILE_TYPE_OF_PHOTO = "stempPhoto";
	
	@Resource(name="UniliteComboServiceImpl")
	private ComboServiceImpl comboService;
	
	
	
/**
 * DHL 접수등록
 * @param loginVO
 * @param model
 * @return
 * @throws Exception
 */
	@RequestMapping(value = "/coop/dhl100ukrv.do")
	public String dhl100ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE",loginVO.getCompCode());
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;
		
		int i = 0;
		List<CodeDetailVO> gsLoginUser = codeInfo.getCodeList("YP25", "", false);			
		for(CodeDetailVO map : gsLoginUser)	{	
			if(loginVO.getPersonNumb().equals(map.getRefCode2())){
				model.addAttribute("gsLoginUser", map.getCodeNo());
				i++;
			}			 
		}
		if(i == 0) model.addAttribute("gsLoginUser", "");
		
		 List<CodeDetailVO> cdList = codeInfo.getCodeList("YP22");
		 if(!ObjUtils.isEmpty(cdList))	model.addAttribute("gsReceiptType",ObjUtils.toJsonStr(cdList));	
		
		 List<CodeDetailVO> ReceiptUser = codeInfo.getCodeList("YP25");
		 if(!ObjUtils.isEmpty(ReceiptUser))	model.addAttribute("ReceiptUser",ObjUtils.toJsonStr(ReceiptUser));
		
		return JSP_PATH + "dhl100ukrv";
	}
	
	
	/**
	 * DHL 픽업등록
	 * @param loginVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/coop/dhl200ukrv.do")
	public String dhl200ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE",loginVO.getCompCode());
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;
		
		int i = 0;
		List<CodeDetailVO> gsLoginUser = codeInfo.getCodeList("YP25", "", false);	//자국화폐단위 정보		
		for(CodeDetailVO map : gsLoginUser)	{	
			if(loginVO.getPersonNumb().equals(map.getRefCode2())){
				model.addAttribute("gsLoginUser", map.getCodeNo());
				i++;
			}			 
		}
		if(i == 0) model.addAttribute("gsLoginUser", "");
		
		List<CodeDetailVO> ReceiptUser = codeInfo.getCodeList("YP25");
		 if(!ObjUtils.isEmpty(ReceiptUser))	model.addAttribute("ReceiptUser",ObjUtils.toJsonStr(ReceiptUser));

		return JSP_PATH + "dhl200ukrv";
	}
	
	/**
	 * 픽업현황표조회
	 * @param loginVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
		@RequestMapping(value = "/coop/dhl210skrv.do")
		public String dhl210skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
			final String[] searchFields = {  };
			NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
			LoginVO session = _req.getSession();
			Map<String, Object> param = navigator.getParam();
			String page = _req.getP("page");
			
			param.put("S_COMP_CODE",loginVO.getCompCode());
			CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
			CodeDetailVO cdo = null;
			
			
			
			return JSP_PATH + "dhl210skrv";
		}
		
		/**
		 * DHL 합계표 조회
		 * @param loginVO
		 * @param model
		 * @return
		 * @throws Exception
		 */
			@RequestMapping(value = "/coop/dhl220skrv.do")
			public String dhl220skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
				final String[] searchFields = {  };
				NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
				LoginVO session = _req.getSession();
				Map<String, Object> param = navigator.getParam();
				String page = _req.getP("page");
				
				param.put("S_COMP_CODE",loginVO.getCompCode());
				CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
				CodeDetailVO cdo = null;
				
				
				
				return JSP_PATH + "dhl220skrv";
			}	
	
}

	
	
	
