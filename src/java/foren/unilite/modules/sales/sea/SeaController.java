package foren.unilite.modules.sales.sea;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import foren.framework.lib.listop.ListOp;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.framework.model.NavigatorInfo;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.com.code.CodeDetailVO;
import foren.unilite.com.code.CodeInfo;

@Controller
public class SeaController extends UniliteCommonController {
	private final Logger	logger		= LoggerFactory.getLogger(this.getClass());
	final static String		JSP_PATH	= "/sales/sea/";


	/**
	 * 견적의뢰등록 (sea100ukrv) - 20210628 신규 생성
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/sales/sea100ukrv.do", method = RequestMethod.GET)
	public String sea100ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
//		final String[] searchFields	= {  };
//		NavigatorInfo navigator		= new NavigatorInfo(_req, listOp, searchFields);
//		Map<String, Object> param	= navigator.getParam();
//		LoginVO session				= _req.getSession();
//		String page					= _req.getP("page");
		CodeInfo codeInfo			= this.tlabCodeService.getCodeInfo(loginVO.getCompCode());

		List<CodeDetailVO> gsUseApprovalYn = codeInfo.getCodeList("SE10", "", false);	//견적승인사용여부
		for(CodeDetailVO map : gsUseApprovalYn) {
			if("Y".equals(map.getRefCode1())) {
				model.addAttribute("gsUseApprovalYn", map.getCodeNo());
			}
		}
		return JSP_PATH + "sea100ukrv";
	}


	/**
	 * 견적공수등록 (sea200ukrv) - 20210701 신규 생성
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/sales/sea200ukrv.do", method = RequestMethod.GET)
	public String sea200ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
//		final String[] searchFields	= {  };
//		NavigatorInfo navigator		= new NavigatorInfo(_req, listOp, searchFields);
//		Map<String, Object> param	= navigator.getParam();
//		LoginVO session				= _req.getSession();
//		String page					= _req.getP("page");
		CodeInfo codeInfo			= this.tlabCodeService.getCodeInfo(loginVO.getCompCode());

		List<CodeDetailVO> gsUseApprovalYn = codeInfo.getCodeList("SE10", "", false);	//견적승인사용여부
		for(CodeDetailVO map : gsUseApprovalYn) {
			if("Y".equals(map.getRefCode1())) {
				model.addAttribute("gsUseApprovalYn", map.getCodeNo());
			}
		}
		return JSP_PATH + "sea200ukrv";
	}


	/**
	 * 견적원가계산 (sea210ukrv) - 20210707 신규 생성
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/sales/sea210ukrv.do", method = RequestMethod.GET)
	public String sea210ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
//		final String[] searchFields	= {  };
//		NavigatorInfo navigator		= new NavigatorInfo(_req, listOp, searchFields);
//		Map<String, Object> param	= navigator.getParam();
//		LoginVO session				= _req.getSession();
//		String page					= _req.getP("page");
		CodeInfo codeInfo			= this.tlabCodeService.getCodeInfo(loginVO.getCompCode());

		List<CodeDetailVO> gsUseApprovalYn = codeInfo.getCodeList("SE10", "", false);	//견적승인사용여부
		for(CodeDetailVO map : gsUseApprovalYn) {
			if("Y".equals(map.getRefCode1())) {
				model.addAttribute("gsUseApprovalYn", map.getCodeNo());
			}
		}
		return JSP_PATH + "sea210ukrv";
	}
	
	
	/**
	 * 견적집계표 (sea300skrv)
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/sales/sea300skrv.do", method = RequestMethod.GET)
	public String sea300skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {

		CodeInfo codeInfo			= this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		List<CodeDetailVO> gsUseApprovalYn = codeInfo.getCodeList("SE10", "", false);	//견적승인사용여부
		
		for(CodeDetailVO map : gsUseApprovalYn) {
			if("Y".equals(map.getRefCode1())) {
				model.addAttribute("gsUseApprovalYn", map.getCodeNo());
			}
		}
		return JSP_PATH + "sea300skrv";
	}
	
	/**
	 * 견적현황조회 (sea100skrv)
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/sales/sea100skrv.do", method = RequestMethod.GET)
	public String sea100skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {

		return JSP_PATH + "sea100skrv";
	}
}