package foren.unilite.modules.equip.equ;

import java.io.File;
import java.util.Map;

import javax.annotation.Resource;
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
import foren.framework.utils.ObjUtils;
import foren.framework.web.view.FileDownloadInfo;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.com.code.CodeDetailVO;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.modules.base.bpr.Bpr300ukrvServiceImpl;
import foren.unilite.modules.com.combo.ComboServiceImpl;
@Controller
public class EquController extends UniliteCommonController{
	private final Logger		 logger	= LoggerFactory.getLogger(this.getClass());

	@Resource(name="equ200ukrvService")
	private Equ200ukrvServiceImpl equ200ukrvService;

	@Resource(name="UniliteComboServiceImpl")
	private ComboServiceImpl comboService;

	final static String		  JSP_PATH = "/equip/equ/";

	@RequestMapping(value = "/multiFileUpload.do")
	public String multiFileUpload(ModelMap model, HttpServletRequest request, LoginVO loginVo) throws Exception {

		return JSP_PATH + "multiFileUpload";
	}


	@RequestMapping( value = "/equit/equ210skrv.do" )
	public String equ210skrv( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		cdo = codeInfo.getCodeInfo("B259", "1");
		if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsSiteGubun", cdo.getCodeName());	//사이트구분

		return JSP_PATH + "equ210skrv";
	}

	@RequestMapping( value = "/equit/equ200ukrv.do" )
	public String equ200ukrv( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		cdo = codeInfo.getCodeInfo("B259", "1");	//사이트 구분 운영코드
		 if(ObjUtils.isNotEmpty(cdo)){
			 if(ObjUtils.isNotEmpty(cdo.getCodeName())){
			 	model.addAttribute("gsSiteCode", cdo.getCodeName().toUpperCase());
			 }else{
			 	model.addAttribute("gsSiteCode", "STANDARD");
			 }
		 }else {
				model.addAttribute("gsSiteCode", "STANDARD");
		 }
		return JSP_PATH + "equ200ukrv";
	}

	/**
	 * 장비대장등록 - 장비 관련 파일 다운로드
	 * @param fid
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/fileman/downloadEquInfoImage/{fid}" )
	public ModelAndView downloader( @PathVariable( "fid" ) String fid, LoginVO user ) throws Exception {
		logger.debug("inlineViewer fid:{}", fid);
		FileDownloadInfo fdi = equ200ukrvService.getFileInfo(user, fid);
		if (fdi != null) {
			fdi.setInLineYn(false);
		}
		return ViewHelper.getFileDownloadView(fdi);
	}

	/**
	 * 목형정보등록(equ210ukrv)
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/equit/equ210ukrv.do" )
	public String equ210ukrv( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));

		return JSP_PATH + "equ210ukrv";
	}

	/**
	 * 목형타발이력조회(equ211skrv)
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/equit/equ211skrv.do" )
	public String equ211skrv( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {

		return JSP_PATH + "equ211skrv";
	}

	@RequestMapping( value = "/equit/equ220rkrv.do" )
	public String equ220rkrv( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {

		return JSP_PATH + "equ220rkrv";
	}

	@RequestMapping( value = "/equit/equ230rkrv.do" )
	public String equ230rkrv( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {

		return JSP_PATH + "equ230rkrv";
	}

	@RequestMapping( value = "/equit/equPhoto/{imageFid}.{fExt}" )
	public ModelAndView equPhoto( @PathVariable( "imageFid" ) String imageFid, @PathVariable( "fExt" ) String fExt, ModelMap model, HttpServletRequest request ) throws Exception {
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

	@RequestMapping( value = "/equit/equ250ukrv.do" )
	public String equ250rkrv( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE", loginVO.getCompCode());

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		cdo = codeInfo.getCodeInfo("I811", "1");    //사이트 구분 운영코드
		 if(ObjUtils.isNotEmpty(cdo)){
			 if(ObjUtils.isNotEmpty(cdo.getCodeName())){
				 model.addAttribute("gsCoreUse", cdo.getRefCode1().toUpperCase());
			 }else{
			 	model.addAttribute("gsCoreUse", "N");
			 }
	     }else {
	            model.addAttribute("gsCoreUse", "N");
	     }

		return JSP_PATH + "equ250ukrv";
	}

	/**
	 * 금형별 매출정보조회 (equ260skrv) - 20201103 추가
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/equit/equ260skrv.do" )
	public String equ260skrv( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		return JSP_PATH + "equ260skrv";
	}



    /**
     * 몰드검색

     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/equit/equ270skrv.do")
    public String equ270skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        param.put("S_COMP_CODE",loginVO.getCompCode());

        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;

        return JSP_PATH+"equ270skrv";
    }

   /** 금형대장등록 shin

    * @return
    * @throws Exception
    */
   @RequestMapping(value = "/equit/equ201ukrv.do")
   public String equ201ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
       final String[] searchFields = {  };
       NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
       LoginVO session = _req.getSession();
       Map<String, Object> param = navigator.getParam();
       String page = _req.getP("page");

       param.put("S_COMP_CODE",loginVO.getCompCode());

       CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
       CodeDetailVO cdo = null;

       return JSP_PATH+"equ201ukrv";
   }

   @RequestMapping( value = "/equit/equ201Photo/{imageFid}.{fExt}" )
	public ModelAndView equ201Photo( @PathVariable( "imageFid" ) String imageFid, @PathVariable( "fExt" ) String fExt, ModelMap model, HttpServletRequest request ) throws Exception {
		String path = ConfigUtil.getUploadBasePath("equip", true);

		//application id\context id\equip
		logger.debug(" ###################  path :"+path);
		logger.debug(" ###################  file :"+imageFid+"."+fExt);
		File photo =  new File(path, imageFid+"."+fExt);
		if (photo == null || !photo.canRead()) {
			//			String url = "/resources/images/human/noPhoto.png";
			//			return new ModelAndView("redirect:"+url);
			path = request.getServletContext().getRealPath("/resources/images/");
			photo = new File(path, "noImage.png");
		}

		return ViewHelper.getImageView(photo);
	}

   /** 테스트페이지

    * @return
    * @throws Exception
    */
   @RequestMapping(value = "/equit/equ999ukrv.do")
   public String equ999ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
       final String[] searchFields = {  };
       NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
       LoginVO session = _req.getSession();
       Map<String, Object> param = navigator.getParam();
       String page = _req.getP("page");

       param.put("S_COMP_CODE",loginVO.getCompCode());

       CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
       CodeDetailVO cdo = null;

       return JSP_PATH+"equ999ukrv";
   }

   /** 테스트페이지

    * @return
    * @throws Exception
    */
   @RequestMapping(value = "/equit/equ888ukrv.do")
   public String equ888ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
       final String[] searchFields = {  };
       NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
       LoginVO session = _req.getSession();
       Map<String, Object> param = navigator.getParam();
       String page = _req.getP("page");

       param.put("S_COMP_CODE",loginVO.getCompCode());

       CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
       CodeDetailVO cdo = null;

       return JSP_PATH+"equ888ukrv";
   }

}