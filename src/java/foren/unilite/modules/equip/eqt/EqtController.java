package foren.unilite.modules.equip.eqt;

import java.io.File;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import foren.framework.lib.listop.ListOp;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.framework.model.NavigatorInfo;
import foren.framework.utils.ConfigUtil;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;
@Controller
public class EqtController extends UniliteCommonController{
	 private final Logger         logger   = LoggerFactory.getLogger(this.getClass());

	 final static String          JSP_PATH = "/equip/eqt/";

	 @RequestMapping( value = "/equit/eqt200ukrv.do" )
     public String eqt200ukrv( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {

        return JSP_PATH + "eqt200ukrv";
     }


	 @RequestMapping( value = "/equit/eqt201ukrv.do" )
     public String eqt201ukrv( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {

        return JSP_PATH + "eqt201ukrv";
     }

	 @RequestMapping( value = "/equit/eqt210skrv.do" )
     public String eqt210skrv( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {

        return JSP_PATH + "eqt210skrv";
     }
	 @RequestMapping( value = "/equit/eqt220rkrv.do" )
     public String eqt220rkrv( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {

        return JSP_PATH + "eqt220rkrv";
     }

	 @RequestMapping( value = "/equit/eqt230skrv.do" )
     public String eqt230skrv( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {

        return JSP_PATH + "eqt230skrv";
     }

	 @RequestMapping( value = "/equit/eqt300ukrv.do" )
     public String eqt300ukrv( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {

		 final String[] searchFields = {  };
			NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
			LoginVO session = _req.getSession();
			Map<String, Object> param = navigator.getParam();
			String page = _req.getP("page");

			model.addAttribute("CSS_TYPE", "-large2");  //화면크기조정(POP)


        return JSP_PATH + "eqt300ukrv";
     }
	 @RequestMapping( value = "/equit/eqt310ukrv.do" )
     public String eqt310ukrv( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {

        return JSP_PATH + "eqt310ukrv";
     }

	 @RequestMapping( value = "/equit/eqtPhoto/{imageFid}.{fExt}" )
	    public ModelAndView eqtPhoto( @PathVariable( "imageFid" ) String imageFid, @PathVariable( "fExt" ) String fExt, ModelMap model, HttpServletRequest request ) throws Exception {
		 	String path = ConfigUtil.getUploadBasePath(ConfigUtil.getString("common.upload.equipmentPhoto", "EquipmentPhoto"));
		 	logger.debug(" ###################  path :"+path);
	        logger.debug(" ###################  file :"+imageFid+"."+fExt);
	        File photo =  new File(path, imageFid+"."+fExt);
	        if (photo == null || !photo.canRead()) {
	            //			String url = "/resources/images/human/noPhoto.png";
	            //			return new ModelAndView("redirect:"+url);
	            path = request.getServletContext().getRealPath("/resources/images/");
	            photo = new File(path, "nameCard.jpg");
	        }

	        return ViewHelper.getImageView(photo);
	    }
}
