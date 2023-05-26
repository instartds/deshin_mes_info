package foren.unilite.modules.nbox.myinfo;

import java.io.File;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import foren.framework.utils.ConfigUtil;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;


@Controller
public class NboxUserSignController extends UniliteCommonController {

	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@Resource(name = "nboxUserSignService")
	private NboxUserSignService nboxUserSignService;

	@RequestMapping(value="/nboxfile/myinfosign/{fid}")
	public ModelAndView view(@PathVariable("fid")  String fid, ModelMap model, HttpServletRequest request)throws Exception{
		logger.debug("myinfosign.fid : {}", fid);
		
		File photo ;
		String filePath = request.getServletContext().getRealPath(ConfigUtil.getString("nbox.image.sign"));
		logger.debug("myinfosign.filePath : {}", filePath);
		switch(fid){
			case "X0005":
				photo = new File(filePath, "UnConfirm.gif");
				break;
			case "X0006":
				photo = new File(filePath, "Return.gif");
				break;
			case "X0007":
				photo = new File(filePath, "NoSign.gif");
				break;
			case "X0008":
				photo = new File(filePath, "Expense.gif");
				break;
			case "X0009":
				photo = new File(filePath, "ace3_logo.jpg");
				break;
			case "X0010":
				photo = new File(filePath, "blank.gif");
				break;
				
			default:
				photo = nboxUserSignService.getUserSignImage(fid);
				break;
		}

		if(photo == null || !photo.canRead()) {
			photo = new File(filePath, "blank.gif");
		}

		logger.debug("fid :{}, File = {} ", fid, photo.toPath());
		return ViewHelper.getImageView(photo);
	} 
}
