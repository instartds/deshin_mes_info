package foren.unilite.modules.accnt.sf_cms;

import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import foren.framework.lib.listop.ListOp;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.framework.model.NavigatorInfo;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.modules.com.combo.ComboServiceImpl;
import foren.unilite.modules.stock.qba.Qba120ukrvServiceImpl;
/**
 * SMART_FINDER CMS
 * @author chaeseongmin
 *
 */
@Controller
public class Sf_cmsController extends UniliteCommonController {
    
    private final Logger           logger   = LoggerFactory.getLogger(this.getClass());
    
    final static String            JSP_PATH = "/accnt/sf_cms/";

	@Resource(name="sf_cms100skrvService")
	private Sf_cms100skrvServiceImpl sf_cms100skrvService;

	@Resource(name="sf_cms200skrvService")
	private Sf_cms200skrvServiceImpl sf_cms200skrvService;
	
	@Resource(name="sf_cms310skrvService")
	private Sf_cms310skrvServiceImpl sf_cms310skrvService;
	
	@Resource(name="sf_cms320skrvService")
	private Sf_cms320skrvServiceImpl sf_cms320skrvService;
	
    /**
     * 계좌정보관리
     * @param _req
     * @param loginVO
     * @param listOp
     * @param model
     * @return
     * @throws Exception
     */
	@RequestMapping(value = "/accnt/sf_cms100skrv.do")
	public String sf_cms100skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		model.addAttribute("COMBO_BANK_CODE", sf_cms100skrvService.getBankCode(param));
//
//		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
//		param.put("S_COMP_CODE",loginVO.getCompCode());

		return JSP_PATH + "sf_cms100skrv";
	}
	
	
	
    /**
     * 계좌입출금내역
     * @param _req
     * @param loginVO
     * @param listOp
     * @param model
     * @return
     * @throws Exception
     */
	@RequestMapping(value = "/accnt/sf_cms110skrv.do")
	public String sf_cms110skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		model.addAttribute("COMBO_BANK_CODE", sf_cms100skrvService.getBankCode(param));
//
//		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
//		param.put("S_COMP_CODE",loginVO.getCompCode());

		return JSP_PATH + "sf_cms110skrv";
	}

    /**
     * 홈텍스 매입/매출 현황
     * @param _req
     * @param loginVO
     * @param listOp
     * @param model
     * @return
     * @throws Exception
     */
	@RequestMapping(value = "/accnt/sf_cms200skrv.do")
	public String sf_cms200skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
//		model.addAttribute("COMBO_BANK_CODE", sf_cms200skrvService.getBankCode(param));
//
//		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
//		param.put("S_COMP_CODE",loginVO.getCompCode());

		return JSP_PATH + "sf_cms200skrv";
	}
	
	
    /**
     * 이용내역조회
     * @param _req
     * @param loginVO
     * @param listOp
     * @param model
     * @return
     * @throws Exception
     */
	@RequestMapping(value = "/accnt/sf_cms310skrv.do")
	public String sf_cms310skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		model.addAttribute("COMBO_BANK_CODE", sf_cms100skrvService.getBankCode(param));
//
//		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
//		param.put("S_COMP_CODE",loginVO.getCompCode());

		return JSP_PATH + "sf_cms310skrv";
	}
	
	
    /**
     * 청구내역조회
     * @param _req
     * @param loginVO
     * @param listOp
     * @param model
     * @return
     * @throws Exception
     */
	@RequestMapping(value = "/accnt/sf_cms320skrv.do")
	public String sf_cms320skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		model.addAttribute("COMBO_BANK_CODE", sf_cms100skrvService.getBankCode(param));
//
//		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
//		param.put("S_COMP_CODE",loginVO.getCompCode());

		return JSP_PATH + "sf_cms320skrv";
	}
	
    /**
     * 청구내역조회
     * @param _req
     * @param loginVO
     * @param listOp
     * @param model
     * @return
     * @throws Exception
     */
	@RequestMapping(value = "/accnt/sf_cms330skrv.do")
	public String sf_cms330skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		model.addAttribute("COMBO_BANK_CODE", sf_cms100skrvService.getBankCode(param));
//
//		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
//		param.put("S_COMP_CODE",loginVO.getCompCode());

		return JSP_PATH + "sf_cms330skrv";
	}
	
	
    /**
     * 테스트
     * @param _req
     * @param loginVO
     * @param listOp
     * @param model
     * @return
     * @throws Exception
     */
	@RequestMapping(value = "/accnt/sf_tst100skrv.do")
	public String sf_tst100skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
//		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
//		param.put("S_COMP_CODE",loginVO.getCompCode());

		return JSP_PATH + "sf_tst100skrv";
	}
	
}