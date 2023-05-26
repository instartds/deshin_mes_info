package foren.unilite.modules.coop.cpa;

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
import net.sf.jasperreports.engine.JRConstants;
import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.JRRuntimeException;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.JasperReport;
import net.sf.jasperreports.engine.util.JRLoader;


@Controller
public class CpaController extends UniliteCommonController {

	public static String path;

	private final Logger	logger		= LoggerFactory.getLogger(this.getClass());

	final static String		JSP_PATH	= "/coop/cpa/";
	public final static String FILE_TYPE_OF_PHOTO = "stampPhoto";
	
	@Resource(name="UniliteComboServiceImpl")
	private ComboServiceImpl comboService;
	
	
	
/**
 * 조합원등록
 * @param loginVO
 * @param model
 * @return
 * @throws Exception
 */
	@RequestMapping(value = "/coop/cpa100ukrv.do")
	public String cpa100ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE",loginVO.getCompCode());

		return JSP_PATH + "cpa100ukrv";
	}
	@RequestMapping(value = "/coop/cpa110skrv.do")
	public String cpa110skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		param.put("S_COMP_CODE",loginVO.getCompCode());

		return JSP_PATH + "cpa110skrv";
	}
	@RequestMapping(value = "/coop/cpa120skrv.do")
	public String cpa120skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE",loginVO.getCompCode());

		return JSP_PATH + "cpa120skrv";
	}
	
	@RequestMapping(value = "/coop/cpa200ukrv.do")
	public String cpa200ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE",loginVO.getCompCode());
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;
		
		List<CodeDetailVO> cdList = codeInfo.getCodeList("YP15");
		if(!ObjUtils.isEmpty(cdList))model.addAttribute("gsReceiptType",ObjUtils.toJsonStr(cdList));	

		return JSP_PATH + "cpa200ukrv";
	}
	
	@RequestMapping(value = "/coop/cpa300ukrv.do")
	public String cpa300ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE",loginVO.getCompCode());
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		return JSP_PATH + "cpa300ukrv";
	}
	
	@RequestMapping(value = "/coop/cpa310ukrv.do")
	public String cpa310ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE",loginVO.getCompCode());
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;
		
		return JSP_PATH + "cpa310ukrv";
	}
	
	
	/*//@RequestMapping(value="/images/")
	public StemPath(HttpServletResponse response, HttpServletRequest request)throws IOException, ServletException{
//		File photo = HumanUtils.getHumanPhoto(personNumb);
//		if(photo == null || !photo.canRead()) {
//			String url = "/resources/images/human/noPhoto.png";
//			return new ModelAndView("redirect:"+url);
//			String path = request.getServletContext().getRealPath("/resources/images/human/");
		String path = request.getServletContext().getRealPath("/WebContent/WEB-INF/report/images");	
//			photo = new File( path, "noPhoto.png");
//		}

	}*/
	/*public void exportPhonebook(Model model, HttpServletResponse response) {
	    try {
	        setResponseHeaderPDF(response);
	        Document document = new Document();
	        ByteArrayOutputStream baosPDF = new ByteArrayOutputStream();
	        PdfWriter pdfWriter = null;
	        pdfWriter = PdfWriter.getInstance(document, baosPDF);
	        PageNumbersEventHelper events = new PageNumbersEventHelper();
	        pdfWriter.setPageEvent(events);
	        document.open();
	        addMetaData(document);
	        addTitlePage(document);
	        String relativeWebPath = "/img/image.png";
	        String absoluteDiskPath = getServletContext().getRealPath(relativeWebPath);
	        Image image1 = Image.getInstance(absoluteDiskPath);
	        document.add(image1);
	        addContent(document);
	        document.close();
	        pdfWriter.close();
	        OutputStream os = response.getOutputStream();
	        baosPDF.writeTo(os);
	        os.flush();
	        os.close();
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	}*/
}

	
	
	
