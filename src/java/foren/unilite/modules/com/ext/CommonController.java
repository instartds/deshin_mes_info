package foren.unilite.modules.com.ext;

import java.util.HashMap;

import javax.annotation.Resource;

import org.apache.poi.ss.usermodel.Workbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import foren.framework.model.ExtHtttprequestParam;
import foren.framework.utils.ObjUtils;
import foren.framework.web.jasperreport.JasperFactory;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.com.excel.ExcelUploadService;
import foren.unilite.com.excel.vo.ExcelUploadWorkBookVO;
import foren.unilite.com.service.impl.TlabCodeService;

@Controller
public class CommonController extends UniliteCommonController {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
    @Resource(name = "tlabCodeService")
    private TlabCodeService tlabCodeService;
    

	
	

//	@RequestMapping(value = "/download/downloadJasperSample.do", method = RequestMethod.GET)
//	public ModelAndView pdfSampleDownload() throws Exception {
//		
//		HashMap param = new HashMap();
//		JasperParam jParam = new JasperParam();
//		
//
//		// return ViewHelper.getJasperView("str400rkrv", param);
//		return ViewHelper.getJasperView("hum960rkr", param);
//	}
}
