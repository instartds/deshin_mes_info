package foren.unilite.modules.nbox.approval;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

import foren.framework.lib.listop.ListOp;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.unilite.com.UniliteCommonController;

@Controller
public class NboxDocController extends UniliteCommonController {

	private final Logger	logger		= LoggerFactory.getLogger(this.getClass());
	final static String		JSP_PATH	= "/nbox/approval/";
	
	@Resource(name = "nboxDocCntService")
	private NboxDocCntService nboxDocCntService;
	
	@RequestMapping(value = "/nbox/nboxdocwrite.do")
	public String docwrite(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		Map<String, Object> param = _req.getParameterMap();
		
		Map param1 = new HashMap();
		param1.put("COMP_CODE", loginVO.getCompCode());
		param1.put("PGM_ID", "nboxdocwrite");
		
		String pgmTitle = "";
				
		pgmTitle = nboxDocCntService.getMenuName(param1);
		
		model.addAttribute("PRGID", "nboxdocwrite"); 
		model.addAttribute("PGM_TITLE", pgmTitle);
		model.addAttribute("INTERFACEKEY", param.get("interfaceKey"));
		model.addAttribute("GUBUN", param.get("gubun"));
		
		return JSP_PATH + "nboxDocWrite"; 
	}
	
	@RequestMapping(value = "/nbox/nboxdocdetail.do")
	public String docdetail(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		Map<String, Object> param = _req.getParameterMap();
		
		Map param1 = new HashMap();
		param1.put("COMP_CODE", loginVO.getCompCode());
		param1.put("PGM_ID", "nboxdocdetail");
		
		String pgmTitle = "";
				
		pgmTitle = nboxDocCntService.getMenuName(param1);
		
		model.addAttribute("PRGID", "nboxdocdetail"); 
		model.addAttribute("PGM_TITLE", pgmTitle);
		model.addAttribute("DOCUMENTID", param.get("documentID"));
		model.addAttribute("BOX", param.get("box"));
		model.addAttribute("INTERFACEKEY", param.get("interfaceKey"));
		model.addAttribute("GUBUN", param.get("gubun"));
		
		return JSP_PATH + "nboxDocDetail"; 
	}
	
	@RequestMapping(value = "/nbox/nboxdocform.do")
	public String docform(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		Map<String, Object> param = _req.getParameterMap();
		
		Map param1 = new HashMap();
		param1.put("COMP_CODE", loginVO.getCompCode());
		param1.put("PGM_ID", "nboxdocform");
		
		String pgmTitle = "";
				
		pgmTitle = nboxDocCntService.getMenuName(param1);
		
		model.addAttribute("PRGID", "nboxdocform"); 
		model.addAttribute("PGM_TITLE", pgmTitle);
		
		return JSP_PATH + "nboxDocFormList"; 
	}
	
	@RequestMapping(value = "/nbox/nboxdocformwrite.do")
	public String docformwrite(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		Map<String, Object> param = _req.getParameterMap();
		
		Map param1 = new HashMap();
		param1.put("COMP_CODE", loginVO.getCompCode());
		param1.put("PGM_ID", "nboxdocformwrite");
		
		String pgmTitle = "";
				
		pgmTitle = nboxDocCntService.getMenuName(param1);
		
		model.addAttribute("PRGID", "nboxdocformwrite"); 
		model.addAttribute("PGM_TITLE", pgmTitle);
		model.addAttribute("FORMID", param.get("formID"));
		
		return JSP_PATH + "nboxDocFormWrite"; 
	}
	
	@RequestMapping(value = "/nbox/nboxdocpath.do")
	public String docpath(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		Map<String, Object> param = _req.getParameterMap();
		
		Map param1 = new HashMap();
		param1.put("COMP_CODE", loginVO.getCompCode());
		param1.put("PGM_ID", "nboxdocpath");
		
		String pgmTitle = "";
				
		pgmTitle = nboxDocCntService.getMenuName(param1);

		model.addAttribute("PRGID", "nboxdocpath"); 
		model.addAttribute("PGM_TITLE", pgmTitle);
		
		return JSP_PATH + "nboxDocPath"; 
	}
	
	@RequestMapping(value = "/nbox/getCntAppr.do")
	public String getCntAppr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		Map<String, Object> param = _req.getParameterMap();
		
		//암호화
		String userid = (String) param.get("userid");
		//String userid =  = dcycret("user")
		//String userid = "";
		
		model.addAttribute("USERID", userid);
		
		String cnt = "10"; 
		
		Map param1 = new HashMap();
		param1.put("BOX", "XA003");
		param1.put("COMP_CODE", "MASTER");
		param1.put("USER_ID", userid);
		param1.put("LANG_CODE", "ko");
		param1.put("MENUID", "");
		
		cnt = nboxDocCntService.xa003DocCnt(param1);
		
		model.addAttribute("CNT", cnt);
		
		return JSP_PATH + "getCntAppr"; 
	}
	
	@RequestMapping(value = "/nbox/{box}")
	public String doclist(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model, 
			@PathVariable ("box") String box) throws Exception {
		Map<String, Object> param = _req.getParameterMap();
		String strBox;
		String strPrgId;
		
		if (box.contains("-"))
		{
			strBox = box.split("-")[0];
			strPrgId = box;
		}
		else
		{
			strBox = box;
			strPrgId = box;
		}
		
		Map param1 = new HashMap();
		param1.put("COMP_CODE", loginVO.getCompCode());
		param1.put("PGM_ID", strPrgId);
		logger.debug("\n doclist.param1: {}", param1 );
		
		String pgmTitle = "";
				
		pgmTitle = nboxDocCntService.getMenuName(param1);
		
		model.addAttribute("PRGID", strPrgId);
		model.addAttribute("PGM_TITLE", pgmTitle); 
		model.addAttribute("BOX", strBox.toUpperCase());
		//XA001:임시문서,XA002:기안문서,XA003:미결문서,XA005:예결문서,XA004:기결문서,XA011:반려문서,XA006:참조함,XA007:수신함,XA008:수신함
		//XA009:회사문서함
		
		return JSP_PATH + "nboxDocList";
	}
	
	
	/*
	@RequestMapping(value = "/nbox/nboxdoclistd.do")
	public String doclistd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		Map<String, Object> param = _req.getParameterMap();
		
		model.addAttribute("PRGID", "nboxdoclistd");
		model.addAttribute("BOX", "XA001");//임시문서

		return JSP_PATH + "nboxDocList"; 
	}
	
	@RequestMapping(value = "/nbox/nboxdoclistd.do")
	public String doclistd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		Map<String, Object> param = _req.getParameterMap();
		
		model.addAttribute("PRGID", "nboxdoclistd");
		model.addAttribute("BOX", "XA002");//기안문서

		return JSP_PATH + "nboxDocList"; 
	}
	
	@RequestMapping(value = "/nbox/nboxdoclistb.do")
	public String doclistb(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		Map<String, Object> param = _req.getParameterMap();
		
		model.addAttribute("PRGID", "nboxdoclistb");
		model.addAttribute("BOX", "XA003");//미결문서

		return JSP_PATH + "nboxDocList"; 
	}
	
	@RequestMapping(value = "/nbox/nboxdoclisti.do")
	public String doclisti(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		Map<String, Object> param = _req.getParameterMap();
		
		model.addAttribute("PRGID", "nboxdoclisti");
		model.addAttribute("BOX", "XA005");//예결문서

		return JSP_PATH + "nboxDocList"; 
	}
	
	@RequestMapping(value = "/nbox/nboxdoclistc.do")
	public String doclistc(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		Map<String, Object> param = _req.getParameterMap();
		
		model.addAttribute("PRGID", "nboxdoclistc");
		model.addAttribute("BOX", "XA004");//기결문서

		return JSP_PATH + "nboxDocList"; 
	}
	
	@RequestMapping(value = "/nbox/nboxdoclistr.do")
	public String doclistr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		Map<String, Object> param = _req.getParameterMap();
		
		model.addAttribute("PRGID", "nboxdoclistr");
		model.addAttribute("BOX", "XA011");//반려문서

		return JSP_PATH + "nboxDocList"; 
	}
	
	@RequestMapping(value = "/nbox/nboxdoclistref.do")
	public String doclistref(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		Map<String, Object> param = _req.getParameterMap();
		
		model.addAttribute("PRGID", "nboxdoclistref");
		model.addAttribute("BOX", "XA006");//참조함

		return JSP_PATH + "nboxDocList"; 
	}
	
	@RequestMapping(value = "/nbox/nboxdoclistrcv.do")
	public String doclistrcv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		Map<String, Object> param = _req.getParameterMap();
		
		model.addAttribute("PRGID", "nboxdoclistrcv");
		model.addAttribute("BOX", "XA007");//수신함

		return JSP_PATH + "nboxDocList"; 
	}
	
	@RequestMapping(value = "/nbox/nboxdoclistpub.do")
	public String doclistpub(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		Map<String, Object> param = _req.getParameterMap();
		
		model.addAttribute("PRGID", "nboxdoclistpub");
		model.addAttribute("BOX", "XA008");//수신함

		return JSP_PATH + "nboxDocList"; 
	}
	*/
	
}
	
