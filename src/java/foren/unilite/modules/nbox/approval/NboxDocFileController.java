package foren.unilite.modules.nbox.approval;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import foren.framework.lib.fileupload.FileUploadModel;
import foren.framework.lib.listop.ListOp;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.framework.web.view.FileDownloadInfo;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;

@Controller
public class NboxDocFileController extends UniliteCommonController {

	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@Resource(name = "nboxDocFileService")
	private NboxDocFileService nboxDocFileService;

	@RequestMapping(value = "/nboxfile/docupload.do")
	public ModelAndView upload(ExtHtttprequestParam _req, ListOp listOp, ModelMap model, LoginVO user) throws Exception {

		List<FileUploadModel> files = _req.getAllFiles();
		Map<String,Object> rv = new HashMap<String,Object>();
		rv.put("jsonrpc", "2.0");
		rv.put("result", "");
		rv.put("success", Boolean.TRUE);
		try{
//			String filePath = ConfigUtil.getString("common.upload.temp");
			if(!ObjUtils.isEmpty(files)) {
				for(FileUploadModel file : files) {
					rv.put("fid", nboxDocFileService.insertFile(user, file));
				}
			}
		} catch (Exception e) {
			logger.error(e.getMessage());
			rv.put("success", Boolean.FALSE);
		}

		return ViewHelper.getJsonView(rv);
	}
		
    @RequestMapping(value="/nboxfile/docview/{fid}")
    public ModelAndView inlineViewer(@PathVariable("fid")  String fid,  LoginVO user) throws Exception {
        logger.debug("inlineViewer fid:{}", fid);
        FileDownloadInfo fdi = nboxDocFileService.getFileInfo(user, fid);
        if(fdi != null) {
            fdi.setInLineYn(true );
        }
        return ViewHelper.getFileDownloadView(fdi);
    }
    
    @RequestMapping(value="/nboxfile/docdownload/{fid}")
    public ModelAndView downloader(@PathVariable("fid")  String fid, LoginVO user) throws Exception {
        logger.debug("inlineViewer fid:{}", fid);
        FileDownloadInfo fdi = nboxDocFileService.getFileInfo(user, fid);
        if(fdi != null) {
            fdi.setInLineYn(true); // false 하면 다운로드로만 처리되나 이게 편할것 같음.
        }
        return ViewHelper.getFileDownloadView(fdi);
    }    
}
