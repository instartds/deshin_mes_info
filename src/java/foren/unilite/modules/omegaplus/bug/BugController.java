package foren.unilite.modules.omegaplus.bug;

import java.io.File;
import java.io.FileOutputStream;
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
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import foren.framework.lib.listop.ListOp;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.framework.model.NavigatorInfo;
import foren.framework.utils.ConfigUtil;
import foren.framework.utils.GStringUtils;
import foren.framework.utils.ObjUtils;
import foren.framework.web.view.FileDownloadInfo;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.com.code.CodeDetailVO;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.base.BaseCommonServiceImpl;
import foren.unilite.modules.com.combo.ComboServiceImpl;
import foren.unilite.modules.omegaplus.settings.Bsa030ukrvServiceImpl;
import foren.unilite.modules.z_yp.S_biv300skrv_ypServiceImpl;


@Controller
@SuppressWarnings({ "rawtypes", "unchecked" })
public class BugController extends UniliteCommonController {
	private final Logger	logger		= LoggerFactory.getLogger(this.getClass());
	final static String		JSP_PATH	= "/omegaplus/bug/";

	@Resource( name = "UniliteComboServiceImpl" )
	private ComboServiceImpl comboService;

	@Resource(name="bug100ukrvService")
	private Bug100ukrvServiceImpl bug100ukrvService;



	/**
	 * 매뉴얼 등록 (bug100ukrv) - 20210520 추가
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/omegaplus/bug100ukrv.do", method = RequestMethod.GET )
	public String bcm100ukrv( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
//		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
//		CodeDetailVO cdo = null;

//		cdo = codeInfo.getCodeInfo("B244", "10");
//		if (!ObjUtils.isEmpty(cdo)) model.addAttribute("gsHiddenField", cdo.getRefCode1());
//		cdo = codeInfo.getCodeInfo("B915", "01");
//		if (!ObjUtils.isEmpty(cdo)) model.addAttribute("gsCompanyNumChk", cdo.getRefCode1());
		return JSP_PATH + "bug100ukrv";
	}
}