package foren.unilite.modules.pos.prm;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import foren.framework.lib.listop.ListOp;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.framework.model.NavigatorInfo;
import foren.framework.utils.ConfigUtil;
import foren.framework.utils.ObjUtils;
import foren.framework.web.view.FileDownloadInfo;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.com.code.CodeDetailVO;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.com.tags.ComboItemModel;
import foren.unilite.modules.busoperate.GopCommonServiceImpl;

@Controller
public class PrmController extends UniliteCommonController {

	private final Logger	logger		= LoggerFactory.getLogger(this.getClass());

	final static String		JSP_PATH	= "/pos/prm/";
	
	
	@RequestMapping(value = "/pos/prm100ukrv.do", method = RequestMethod.GET)
	public String gcd100skrv() throws Exception {		
		
		return JSP_PATH + "prm100ukrv";
	}
	
	@RequestMapping(value = "/pos/barcode.do")
	public  ModelAndView barCodeFile( ExtHtttprequestParam _req) throws  Exception {
	     
		 FileDownloadInfo fInfo = new FileDownloadInfo(ConfigUtil.getUploadBasePath("omegapluslabel"), "omegapluslabel.txt");
	     
		 FileOutputStream fos = new FileOutputStream(fInfo.getFile());
		 
		  String data = "8801067397315|20000모나미153스틸볼펜|16000|5";
		  data +="\n";
		  data += "8801237706626|800K칼라3색볼펜0.7/블루|650|3";
		  data +="\n";
		  data += "8802242010487|피에르가르뎅볼펜/PC3402BP||3";
		  data +="\n";
		  data += "0000001008595|몽블랑볼펜/164|470000|2";
		  data +="\n";
		  data += "0000001008094|나전명함볼펜세트||3";
		  data +="\n";
		  data += "9788958327301|집단상담의놀이와프로그램|20000|2";
		  data +="\n";
		  data += "9788918031620|MB리더십의성공조건|13000|2";
		  
		  byte[] bytesArray = data.getBytes();
		  fos.write(bytesArray);
		  fos.flush();
		  
		  fInfo.setStream(fos);
		  
		  return ViewHelper.getFileDownloadView(fInfo);
	  }
	
}
