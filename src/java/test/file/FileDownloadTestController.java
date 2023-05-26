package test.file;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import foren.framework.model.ExtHtttprequestParam;
import foren.framework.web.view.FileDownloadInfo;
import foren.framework.web.view.ViewHelper;

@Controller
public class FileDownloadTestController {

	@RequestMapping(value = "/test/file/down.do", method = RequestMethod.GET)
    public ModelAndView downloadFile(
    		@RequestParam(value="path") 	String path, 
    		@RequestParam(value="file") String fileName) throws Exception {

		FileDownloadInfo fdi = new FileDownloadInfo(path, fileName);
		//fdi.setOriginalFileName("echoExcel.xls");
		//fdi.setContentType("application/octet-stream");
		fdi.setContentType("application/vnd.ms-excel");
		
		
        return ViewHelper.getFileDownloadView(fdi);
    }
}
