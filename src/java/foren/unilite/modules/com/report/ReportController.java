package foren.unilite.modules.com.report;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import foren.framework.context.FwContext;
import foren.framework.lib.fileupload.FileUploadModel;
import foren.framework.lib.listop.ListOp;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.framework.utils.ConfigUtil;
import foren.framework.utils.ObjUtils;
import foren.framework.web.view.FileDownloadInfo;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;

@Controller
public class ReportController extends UniliteCommonController {

    private final Logger logger = LoggerFactory.getLogger(this.getClass());

    /** Jasper Report Image 경로
     *
     **/
    @RequestMapping(value="/report/images/{IMAGE_FILE}")
    public ModelAndView viewImage(@PathVariable("IMAGE_FILE")  String IMAGE_FILE, ModelMap model, HttpServletRequest request)throws Exception{

        File photo = new File( FwContext.getRealPath("/" )+"WEB-INF/report/images/", IMAGE_FILE+".png");
        if(photo == null || !photo.canRead()) {
            String path = request.getServletContext().getRealPath("/resources/images/");
            photo = new File( path, "nameCard.jpg"); // empty gray image 
        }
        return ViewHelper.getImageView(photo);
    }

   /** 
    * OZ Report Viewer
    **/
   @RequestMapping( value = "/report/ozReportView.do", method = {RequestMethod.GET, RequestMethod.POST} )
   public String ozReportView(ModelMap model, HttpServletRequest request)throws Exception{

       return "/com/report/culStatReport";
   }
    
}
