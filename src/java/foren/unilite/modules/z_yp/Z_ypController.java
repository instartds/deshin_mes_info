
package foren.unilite.modules.z_yp;

import java.io.File;
import java.io.FileOutputStream;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.DataFormat;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.type.TypeFactory;
import com.google.gson.Gson;

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
import foren.unilite.com.tags.ComboItemModel;
import foren.unilite.modules.com.combo.ComboServiceImpl;
import foren.unilite.modules.com.fileman.FileMnagerService;
import foren.unilite.modules.human.hat.Hat520skrServiceImpl;
import foren.unilite.utils.AES256DecryptoUtils;
import foren.unilite.modules.sales.SalesCommonServiceImpl;
import foren.unilite.modules.sales.str.Str120ukrvServiceImpl;
import foren.unilite.modules.stock.biv.Biv300skrvServiceImpl;
import foren.unilite.modules.z_yp.S_bcm100ukrv_ypServiceImpl;

@Controller
@SuppressWarnings({"unused", "unchecked", "rawtypes"})
public class Z_ypController extends UniliteCommonController {

	private final Logger	logger		= LoggerFactory.getLogger(this.getClass());
	
	@Resource(name = "salesCommonService")
	private SalesCommonServiceImpl salesCommonService;	// 영업 공통 서비스
	
	@Resource( name = "fileMnagerService" )
	private FileMnagerService fileMnagerService;

	@Resource(name="UniliteComboServiceImpl")
	private ComboServiceImpl comboService;

	@Resource( name = "s_bcm100ukrv_ypService" )
	private S_bcm100ukrv_ypServiceImpl   s_bcm100ukrv_ypService;

    @Resource( name = "hat520skrService" )
    private Hat520skrServiceImpl       hat520skrService;

    @Resource( name = "w_sof100ukrv_ypService" )
    private W_sof100ukrv_ypServiceImpl       w_sof100ukrv_ypService;

    @Resource(name="s_biv300skrv_ypService")
    private S_biv300skrv_ypServiceImpl s_biv300skrv_ypService;


    @Resource(name="s_hpa350ukr_ypService")
    private S_hpa350ukr_ypServiceImpl s_hpa350ukr_ypService;

	@Resource(name="str120ukrvService")
	private Str120ukrvServiceImpl str120ukrvService;

	final static String		JSP_PATH	= "/z_yp/";



	/**
	 * 거래처정보등록(양평)
	 *
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_yp/s_bcm100ukrv_yp.do" )
	public String s_bcm100ukrv_yp(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());

		CodeInfo codeInfo	= this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo	= null;
		cdo					= codeInfo.getCodeInfo("B244", "10");
		if (!ObjUtils.isEmpty(cdo)) model.addAttribute("gsHiddenField", cdo.getRefCode1());

		return JSP_PATH + "s_bcm100ukrv_yp";
	}
	/**
     * 거래처 농가정보 관리
     *
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/z_yp/s_bcm106ukrv_yp.do" )
    public String s_bcm106ukrv_yp(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        return JSP_PATH + "s_bcm106ukrv_yp";
    }

	/**
	 * 거래처정보등록(양평) - 인증서 다운로드
	 * @param fid
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/fileman/downloadCertImage/{fid}" )
	public ModelAndView downloader( @PathVariable( "fid" ) String fid, LoginVO user ) throws Exception {
		logger.debug("inlineViewer fid:{}", fid);
		FileDownloadInfo fdi = s_bcm100ukrv_ypService.getFileInfo(user, fid);
		if (fdi != null) {
			fdi.setInLineYn(false);
		}
		return ViewHelper.getFileDownloadView(fdi);
	}


	/**
     * 농가이력 사진조회
     *
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/uploads/farmHouseImages/{customCode}")
    public ModelAndView viewImage (@PathVariable("customCode")  String customCode, ModelMap model, HttpServletRequest request) throws Exception{

        File photo = Z_ypController.getImage("z_yp/farmHouse", customCode);

        //사진이 읽을 수 없거나 존재하지 않는 경우,
        if(photo == null || !photo.canRead()) {
            //String path = request.getServletContext().getRealPath("/resources/images/human/");
//            String path = request.getServletContext().getRealPath(ConfigUtil.getString("commom.upload.image.no_img"));
            String path = request.getServletContext().getRealPath("/resources/images/human/");
            logger.info("path :: " + path);
            photo = new File( path, "noPhoto.png");
        }

        logger.debug("imageID :{}, File = {} ", customCode, photo.toPath());
        return ViewHelper.getImageView(photo);
    }


    /**
     * ImageID로 img파일 가져 오기
     * @param imageID
     * @return
     */
    public static File getImage(String imagePath, String customCode) {
        String path = ConfigUtil.getUploadBasePath(imagePath);

        File pngType = new File(path + "/" + customCode + ".png");
        File jpgType = new File(path + "/" + customCode + ".jpg");
        File bmpType = new File(path + "/" + customCode + ".bmp");

        if(pngType.exists()){
            File photo = new File(path, customCode+".png");
            return photo;
        }else if(jpgType.exists()){
            File photo = new File(path, customCode+".jpg");
            return photo;
        }else if(bmpType.exists()){
            File photo = new File(path, customCode+".bmp");
            return photo;
        }else{
            return null;
        }
    }



	/**
	 * 거래처 교육 관리
	 *
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_yp/s_bcm105ukrv_yp.do" )
	public String s_bcm105ukrv_yp(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());

		return JSP_PATH + "s_bcm105ukrv_yp";
	}






	/** 품목정보등록(양평)
	 *
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_yp/s_bpr300ukrv_yp.do", method = RequestMethod.GET)
	public String s_bpr300ukrv_yp(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
		//공통코드 (B073: 유효일수) 체크
		model.addAttribute("UseByDate",this.tlabCodeService.getCodeInfo(loginVO.getCompCode()).getCodeInfo("B073", "1").getRefCode1());
		//model.addAttribute("UseByDate",this.tlabCodeService.getCodeInfo(loginVO.getCompCode()).getCodeInfo("B108", "B005").getRefCode3());
		String precision = null;
		String formatWithPrecision = "0,000.";
		//공통코드(B108: 프로그램별 숫자포맷)에 포맷설정 여부 확인
		List<CodeDetailVO> configList = this.tlabCodeService.getCodeInfo(loginVO.getCompCode()).getCodeList("B108", "", false);
		for(CodeDetailVO map : configList)	{
			if("s_bpr300ukrv_yp".equals(map.getRefCode1()))	{
				if("REIM".equals(map.getRefCode2()))	{
					precision = map.getRefCode3();

					int intPrecision = ObjUtils.parseInt(precision);
					for(int i=0; i<intPrecision; i++ )	{
						formatWithPrecision+="0";
					}
					model.addAttribute("REIM_Precision"			, map.getRefCode3());
					model.addAttribute("REIM_PrecisionFormat"	, formatWithPrecision);
				}
			}
		}
		if(precision == null)	{
			model.addAttribute("REIM_Precision", 2);
		}

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;
		cdo = codeInfo.getCodeInfo("B084", "D");	//재고합산유형 : 창고 Cell 합산
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsSumTypeCell",cdo.getRefCode1());
		}else {
			model.addAttribute("gsSumTypeCell", "N");
		}

		return JSP_PATH + "s_bpr300ukrv_yp";
	}






	/**
	 * 매출현황 조회
	 *
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_yp/s_eis000skrv_yp.do" )
	public String s_eis000skrv_yp(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());

		return JSP_PATH + "s_eis000skrv_yp";
	}




	/**
	 * 매입현황 조회
	 *
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_yp/s_eis100skrv_yp.do" )
	public String s_eis100skrv_yp(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());

		return JSP_PATH + "s_eis100skrv_yp";
	}




	/**
	 * 수발주등록현황 조회
	 *
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_yp/s_eis200skrv_yp.do" )
	public String s_eis200skrv_yp(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());

		return JSP_PATH + "s_eis200skrv_yp";
	}




	/**
	 * 판매현황 조회
	 *
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_yp/s_eis300skrv_yp.do" )
	public String s_eis300skrv_yp(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());

		return JSP_PATH + "s_eis300skrv_yp";
	}






	/**
	 * 작업지시 등록(양평)
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_yp/s_pmp110ukrv_yp.do")
	public String s_pmp110ukrv_yp(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
		cdo = codeInfo.getCodeInfo("P005", "2");
		if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsAutoNo", cdo.getRefCode1());	 // 생산자동채번유무

		cdo = codeInfo.getCodeInfo("P000", "3");
		if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsBadInputYN",cdo.getRefCode1());  // 자동입고시 불량입고 반영여부

		cdo = codeInfo.getCodeInfo("P121", "01");
		if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsChildStockPopYN",cdo.getRefCode1());  // 자재부족팝업 호출여부

		int i = 0;
		List<CodeDetailVO> gsBomPathYN = codeInfo.getCodeList("B082", "", false);   // BOM PATH 관리여부
		for(CodeDetailVO map : gsBomPathYN) {
			if("Y".equals(map.getRefCode1())||"y".equals(map.getRefCode1()))	{
				model.addAttribute("gsShowBtnReserveYN", map.getCodeNo());

				i++;  // RecordCount
			}
		}
		if(i == 0) model.addAttribute("gsShowBtnReserveYN", "N");

		cdo = codeInfo.getCodeInfo("B090", "PA");   //							  // LOT 관리기준 설정 재고와 작업지시 LOT 연계여부
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsLotNoInputMethod",cdo.getRefCode1());
			model.addAttribute("gsLotNoEssential",cdo.getRefCode2());
			model.addAttribute("gsEssItemAccount",cdo.getRefCode3());
		}

		cdo = codeInfo.getCodeInfo("P000", "4");
		if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsGoodsInputYN",cdo.getRefCode1());  // 긴급작지시 상품입력 가능여부

		cdo = codeInfo.getCodeInfo("S012", "2");
		if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsAutoType",cdo.getRefCode1());	  //Y:의뢰번호(txtOrderNum) lock,disable

		return JSP_PATH + "s_pmp110ukrv_yp";
	}





	/**
	 * 구매품작업지시 등록(양평)
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_yp/s_pmp111ukrv_yp.do")
	public String s_pmp111ukrv_yp(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());

		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));

		return JSP_PATH + "s_pmp111ukrv_yp";
	}





	/**
	 * 작업지시 등록(LOT분할)(양평)
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_yp/s_pmp112ukrv_yp.do")
	public String s_pmp112ukrv_yp(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
		cdo = codeInfo.getCodeInfo("P005", "2");
		if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsAutoNo", cdo.getRefCode1());	 // 생산자동채번유무

		cdo = codeInfo.getCodeInfo("P000", "3");
		if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsBadInputYN",cdo.getRefCode1());  // 자동입고시 불량입고 반영여부

		cdo = codeInfo.getCodeInfo("P121", "01");
		if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsChildStockPopYN",cdo.getRefCode1());  // 자재부족팝업 호출여부

		int i = 0;
		List<CodeDetailVO> gsBomPathYN = codeInfo.getCodeList("B082", "", false);   // BOM PATH 관리여부
		for(CodeDetailVO map : gsBomPathYN) {
			if("Y".equals(map.getRefCode1())||"y".equals(map.getRefCode1()))	{
				model.addAttribute("gsShowBtnReserveYN", map.getCodeNo());

				i++;  // RecordCount
			}
		}
		if(i == 0) model.addAttribute("gsShowBtnReserveYN", "N");

		cdo = codeInfo.getCodeInfo("B090", "PA");   //							  // LOT 관리기준 설정 재고와 작업지시 LOT 연계여부
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsLotNoInputMethod",cdo.getRefCode1());
			model.addAttribute("gsLotNoEssential",cdo.getRefCode2());
			model.addAttribute("gsEssItemAccount",cdo.getRefCode3());
		}

		cdo = codeInfo.getCodeInfo("P000", "4");
		if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsGoodsInputYN",cdo.getRefCode1());  // 긴급작지시 상품입력 가능여부

		cdo = codeInfo.getCodeInfo("S012", "2");
		if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsAutoType",cdo.getRefCode1());	  //Y:의뢰번호(txtOrderNum) lock,disable

		return JSP_PATH + "s_pmp112ukrv_yp";
	}





	/**
	 * 작업실적 등록 (양평)
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_yp/s_pmr100ukrv_yp.do")
	public String s_pmr100ukrv_yp(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
		model.addAttribute("COMBO_WH_CELL_LIST", comboService.getWhCellList(param));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		cdo = codeInfo.getCodeInfo("B090", "PB");
		if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsManageLotNoYN",cdo.getRefCode1()); // 작업지시와 생산실적LOT 연계여부 설정 값 알기

		cdo = codeInfo.getCodeInfo("P000", "6");
		if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsChkProdtDateYN",cdo.getRefCode1()); // 작업실적 등록시 착수예정일 체크여부

		cdo = codeInfo.getCodeInfo("P100", "1");											  // 생산완료시점 (100%)
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("glEndRate",cdo.getRefCode1());
		}

		cdo = codeInfo.getCodeInfo("B084", "D");											  // 재고대체 합산
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsSumTypeCell",cdo.getRefCode1());
		}else {
			model.addAttribute("gsSumTypeCell", "N");
		}

		List<CodeDetailVO> gsMoldCode = codeInfo.getCodeList("WP01", "", false);			// 작지설비 관리여부
		for(CodeDetailVO map : gsMoldCode) {
			if("Y".equals(map.getRefCode1()))   {
				model.addAttribute("gsMoldCode", map.getCodeNo());
			}
		}

		List<CodeDetailVO> gsEquipCode = codeInfo.getCodeList("WP02", "", false);			// 작지금형 관리여부
		for(CodeDetailVO map : gsEquipCode) {
			if("Y".equals(map.getRefCode1()))   {
				model.addAttribute("gsEquipCode", map.getCodeNo());
			}
		}
		return JSP_PATH + "s_pmr100ukrv_yp";
	}





	/**
	 * 생산수율관리(양평)
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_yp/s_pmr110ukrv_yp.do")
	public String s_pmr110ukrv_yp(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));

		return JSP_PATH + "s_pmr110ukrv_yp";
	}



	/** 클레임등록(양평)
	 *
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_yp/s_scl100ukrv_yp.do")
	public String s_scl100ukrv_yp(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		//창고 콤보 생성
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

		cdo = codeInfo.getCodeInfo("S028", "1");
		if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsVatRate",cdo.getRefCode1());				// 부가세율정보 조회

		return JSP_PATH + "s_scl100ukrv_yp";
	}




	/** 수주등록(주간/일반)(양평)
	 *
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_yp/s_sof100ukrv_yp.do")
	public String s_sof100ukrv_yp(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		cdo = codeInfo.getCodeInfo("S026", "1");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsCreditYn",cdo.getRefCode1());	//Y:여신잔액(txtRemainCredit) visible

		cdo = codeInfo.getCodeInfo("S012", "2");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsAutoType",cdo.getRefCode1());				//Y:수주번호(txtOrderNum) lock,disable

		List<CodeDetailVO> gsMoneyUnit = codeInfo.getCodeList("B004", "", false);
		for(CodeDetailVO map : gsMoneyUnit)	{
			if("Y".equals(map.getRefCode1()))	{
				model.addAttribute("gsMoneyUnit", map.getCodeNo());
			}
		}

		List<CodeDetailVO> gsBalanceOut = codeInfo.getCodeList("WB06", "", false);				 //B/OUT 체크
		for(CodeDetailVO map : gsBalanceOut) {
			if("Y".equals(map.getRefCode1()))   {
				model.addAttribute("gsBalanceOut", map.getCodeNo());
			}
		}

		cdo = codeInfo.getCodeInfo("S028", "1");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsVatRate",cdo.getRefCode1());



		List<CodeDetailVO> gsProdtDtAutoYN = codeInfo.getCodeList("S031", "", false);
		for(CodeDetailVO map : gsProdtDtAutoYN)	{
			if("Y".equals(map.getRefCode1()))	{
				model.addAttribute("gsProdtDtAutoYN", map.getCodeNo());
			}
		}

		List<CodeDetailVO>  gsSaleAutoYN= codeInfo.getCodeList("S035", "", false);
		for(CodeDetailVO map : gsSaleAutoYN)	{
			if("Y".equals(map.getRefCode1()))	{
				model.addAttribute("gsSaleAutoYN", map.getCodeNo());
			}
		}

		cdo = codeInfo.getCodeInfo("S037", "1");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsSof100ukrLink",	cdo.getCodeName());


		cdo = codeInfo.getCodeInfo("S037", "2");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsSrq100UkrLink",	cdo.getCodeName());				//출하지시등록 링크 PGM ID

		cdo = codeInfo.getCodeInfo("S037", "3");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsStr100UkrLink",	cdo.getCodeName());				//출고등록 링크 PGM ID

		cdo = codeInfo.getCodeInfo("S037", "4");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsSsa100UkrLink",	cdo.getCodeName());				//매출등록 링크 PGM ID

		List<CodeDetailVO> gsProcessFlag = codeInfo.getCodeList("BS07", "", false);
		for(CodeDetailVO map : gsProcessFlag)	{
			if("Y".equals(map.getRefCode1()))	{
				model.addAttribute("gsProcessFlag", map.getCodeNo());
			}
		}

		List<CodeDetailVO> gsCondShowFlag = codeInfo.getCodeList("S043", "", false);
		for(CodeDetailVO map : gsCondShowFlag)	{
			if("Y".equals(map.getRefCode1()))	{
				model.addAttribute("gsCondShowFlag", map.getCodeNo());				//Y:수주내역의 할인율,할인율일괄적용,해당행 visible
			}
		}

		List<CodeDetailVO> gsDraftFlag = codeInfo.getCodeList("S044", "", false);
		for(CodeDetailVO map : gsDraftFlag)	{
			if("Y".equals(map.getRefCode1()))	{
				if(map.getCodeNo().equals("1")){
					model.addAttribute("gsDraftFlag", "Y");					//Y:수주승인관련 필드
				}else{
					model.addAttribute("gsDraftFlag", "N");					//N:자동승인관련 필드
				}

			}
		}

		cdo = codeInfo.getCodeInfo("S045", "1");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsApp1AmtInfo",		cdo.getRefCode2());				//수주승인사용일 경우 lblApp1AmtInfo 값 표시

		cdo = codeInfo.getCodeInfo("S045", "2");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsApp2AmtInfo",		cdo.getRefCode2());				//수주승인사용일 경우 lblApp2AmtInfo,lblApp3AmtInfo 값 표시

		cdo = codeInfo.getCodeInfo("S048", "SS");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsTimeYN",			cdo.getRefCode1());

		cdo = codeInfo.getCodeInfo("S061", "1");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsScmUseYN",		cdo.getRefCode1());				//Y:SCM연계탭 enable

		cdo = codeInfo.getCodeInfo("B078", "10");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsPjtCodeYN",		cdo.getRefCode1());				//Y:수주검색팝업에 txtPlanNum enable

		cdo = codeInfo.getCodeInfo("B117", "S");
		if(!ObjUtils.isEmpty(cdo))	{
			model.addAttribute("gsPointYn",			cdo.getRefCode1());				//수주내역 그리드에서 ORDER_VOL_Q,ORDER_WGT_Q 입력값 체크시 사용
			model.addAttribute("gsUnitChack",		cdo.getRefCode2());				//수주내역 그리드에서 ORDER_VOL_Q,ORDER_WGT_Q 입력값 체크시 사용
		}

		cdo = codeInfo.getCodeInfo("S116", "srq101ukrv");
		if(!ObjUtils.isEmpty(cdo))	{
			model.addAttribute("gsPriceGubun",		cdo.getRefCode1());		//수주내역 그리드에서 PRICE_TYPE 디폴트값으로 사용
			model.addAttribute("gsWeight",			cdo.getRefCode2());		//수주내역 그리드에서 WGT_UNIT 디폴트값으로 사용
			model.addAttribute("gsVolume",			cdo.getRefCode3());		//수주내역 그리드에서 VOL_UNIT 디폴트값으로 사용
		}


		List<CodeDetailVO> gsOrderTypeSaleYN = codeInfo.getCodeList("S044", "", false);
		List<Map<String, Object>>  listOrderTypeSaleYN = new ArrayList<Map<String, Object>>();
		for(CodeDetailVO map : gsOrderTypeSaleYN)	{
			Map<String, Object> aMap = new HashMap<String, Object>();
			aMap.put("SUB_CODE", map.getCodeNo());
			aMap.put("CODE_NAME", map.getCodeName());
			aMap.put("REF_CODE1", map.getRefCode1());
			listOrderTypeSaleYN.add(aMap);
		}
		model.addAttribute("gsOrderTypeSaleYN", listOrderTypeSaleYN);

		List<CodeDetailVO> salesPrsn = codeInfo.getCodeList("S010", "", false);
		List<Map> divPrsn = new ArrayList<Map>();
		for(CodeDetailVO map : salesPrsn)	{
				Map rMap = new HashMap();
				rMap.put("value",map.getCodeNo());
				rMap.put("text", map.getCodeName());
				rMap.put("option",map.getRefCode1());
				divPrsn.add(rMap);
		}
		model.addAttribute("divPrsn", divPrsn);

		return JSP_PATH + "s_sof100ukrv_yp";
	}





	/** 수주등록II(주간/일반) (양평)
	 *
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_yp/s_sof101ukrv_yp.do")
	public String s_sof101ukrv_yp(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		cdo = codeInfo.getCodeInfo("S026", "1");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsCreditYn",cdo.getRefCode1());	//Y:여신잔액(txtRemainCredit) visible

		cdo = codeInfo.getCodeInfo("S012", "2");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsAutoType",cdo.getRefCode1());				//Y:수주번호(txtOrderNum) lock,disable

		List<CodeDetailVO> gsMoneyUnit = codeInfo.getCodeList("B004", "", false);
		for(CodeDetailVO map : gsMoneyUnit)	{
			if("Y".equals(map.getRefCode1()))	{
				model.addAttribute("gsMoneyUnit", map.getCodeNo());
			}
		}

		List<CodeDetailVO> gsBalanceOut = codeInfo.getCodeList("WB06", "", false);				 //B/OUT 체크
		for(CodeDetailVO map : gsBalanceOut) {
			if("Y".equals(map.getRefCode1()))   {
				model.addAttribute("gsBalanceOut", map.getCodeNo());
			}
		}

		cdo = codeInfo.getCodeInfo("S028", "1");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsVatRate",cdo.getRefCode1());



		List<CodeDetailVO> gsProdtDtAutoYN = codeInfo.getCodeList("S031", "", false);
		for(CodeDetailVO map : gsProdtDtAutoYN)	{
			if("Y".equals(map.getRefCode1()))	{
				model.addAttribute("gsProdtDtAutoYN", map.getCodeNo());
			}
		}

		List<CodeDetailVO>  gsSaleAutoYN= codeInfo.getCodeList("S035", "", false);
		for(CodeDetailVO map : gsSaleAutoYN)	{
			if("Y".equals(map.getRefCode1()))	{
				model.addAttribute("gsSaleAutoYN", map.getCodeNo());
			}
		}

		cdo = codeInfo.getCodeInfo("S037", "1");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsSof100ukrLink",	cdo.getCodeName());


		cdo = codeInfo.getCodeInfo("S037", "2");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsSrq100UkrLink",	cdo.getCodeName());				//출하지시등록 링크 PGM ID

		cdo = codeInfo.getCodeInfo("S037", "3");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsStr100UkrLink",	cdo.getCodeName());				//출고등록 링크 PGM ID

		cdo = codeInfo.getCodeInfo("S037", "4");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsSsa100UkrLink",	cdo.getCodeName());				//매출등록 링크 PGM ID

		List<CodeDetailVO> gsProcessFlag = codeInfo.getCodeList("BS07", "", false);
		for(CodeDetailVO map : gsProcessFlag)	{
			if("Y".equals(map.getRefCode1()))	{
				model.addAttribute("gsProcessFlag", map.getCodeNo());
			}
		}

		List<CodeDetailVO> gsCondShowFlag = codeInfo.getCodeList("S043", "", false);
		for(CodeDetailVO map : gsCondShowFlag)	{
			if("Y".equals(map.getRefCode1()))	{
				model.addAttribute("gsCondShowFlag", map.getCodeNo());				//Y:수주내역의 할인율,할인율일괄적용,해당행 visible
			}
		}

		List<CodeDetailVO> gsDraftFlag = codeInfo.getCodeList("S044", "", false);
		for(CodeDetailVO map : gsDraftFlag)	{
			if("Y".equals(map.getRefCode1()))	{
				if(map.getCodeNo().equals("1")){
					model.addAttribute("gsDraftFlag", "Y");					//Y:수주승인관련 필드
				}else{
					model.addAttribute("gsDraftFlag", "N");					//N:자동승인관련 필드
				}

			}
		}

		cdo = codeInfo.getCodeInfo("S045", "1");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsApp1AmtInfo",		cdo.getRefCode2());				//수주승인사용일 경우 lblApp1AmtInfo 값 표시

		cdo = codeInfo.getCodeInfo("S045", "2");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsApp2AmtInfo",		cdo.getRefCode2());				//수주승인사용일 경우 lblApp2AmtInfo,lblApp3AmtInfo 값 표시

		cdo = codeInfo.getCodeInfo("S048", "SS");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsTimeYN",			cdo.getRefCode1());

		cdo = codeInfo.getCodeInfo("S061", "1");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsScmUseYN",		cdo.getRefCode1());				//Y:SCM연계탭 enable

		cdo = codeInfo.getCodeInfo("B078", "10");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsPjtCodeYN",		cdo.getRefCode1());				//Y:수주검색팝업에 txtPlanNum enable

		cdo = codeInfo.getCodeInfo("B117", "S");
		if(!ObjUtils.isEmpty(cdo))	{
			model.addAttribute("gsPointYn",			cdo.getRefCode1());				//수주내역 그리드에서 ORDER_VOL_Q,ORDER_WGT_Q 입력값 체크시 사용
			model.addAttribute("gsUnitChack",		cdo.getRefCode2());				//수주내역 그리드에서 ORDER_VOL_Q,ORDER_WGT_Q 입력값 체크시 사용
		}

		cdo = codeInfo.getCodeInfo("S116", "srq101ukrv");
		if(!ObjUtils.isEmpty(cdo))	{
			model.addAttribute("gsPriceGubun",		cdo.getRefCode1());		//수주내역 그리드에서 PRICE_TYPE 디폴트값으로 사용
			model.addAttribute("gsWeight",			cdo.getRefCode2());		//수주내역 그리드에서 WGT_UNIT 디폴트값으로 사용
			model.addAttribute("gsVolume",			cdo.getRefCode3());		//수주내역 그리드에서 VOL_UNIT 디폴트값으로 사용
		}


		List<CodeDetailVO> gsOrderTypeSaleYN = codeInfo.getCodeList("S044", "", false);
		List<Map<String, Object>>  listOrderTypeSaleYN = new ArrayList<Map<String, Object>>();
		for(CodeDetailVO map : gsOrderTypeSaleYN)	{
			Map<String, Object> aMap = new HashMap<String, Object>();
			aMap.put("SUB_CODE", map.getCodeNo());
			aMap.put("CODE_NAME", map.getCodeName());
			aMap.put("REF_CODE1", map.getRefCode1());
			listOrderTypeSaleYN.add(aMap);
		}
		model.addAttribute("gsOrderTypeSaleYN", listOrderTypeSaleYN);

		List<CodeDetailVO> salesPrsn = codeInfo.getCodeList("S010", "", false);
		List<Map> divPrsn = new ArrayList<Map>();
		for(CodeDetailVO map : salesPrsn)	{
				Map rMap = new HashMap();
				rMap.put("value",map.getCodeNo());
				rMap.put("text", map.getCodeName());
				rMap.put("option",map.getRefCode1());
				divPrsn.add(rMap);
		}
		model.addAttribute("divPrsn", divPrsn);

		model.addAttribute("CAL_NO", comboService.getCalNo(param));

		return JSP_PATH + "s_sof101ukrv_yp";
	}
	
	/** 매출현황(오토마트)
    *
    * @param _req
    * @param loginVO
    * @param listOp
    * @param model
    * @return
    * @throws Exception
    */
	@RequestMapping(value = "/z_yp/s_sof100skrv_yp.do")
	public String s_sof100skrv_yp(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		//기본 화폐단위, 환산 화폐단위, 환산 환율 가져오기 위한 로직
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());

		String moneyUnit = "";
		Map<String, Object> exchgRate = new HashMap<String, Object>();

		//기본 화폐단위
		List<CodeDetailVO> gsMoneyUnit = codeInfo.getCodeList("B004", "", false);
		for(CodeDetailVO map : gsMoneyUnit)	{
			if("Y".equals(map.getRefCode1()))	{
				model.addAttribute("gsMoneyUnit", map.getCodeNo());
			}
		}
		//default 환산 화폐단위
		List<CodeDetailVO> gsMoneyUnitRef4 = codeInfo.getCodeList("B004", "", false);
		for(CodeDetailVO map : gsMoneyUnitRef4)	{
			if("Y".equals(map.getRefCode4()))	{
				model.addAttribute("gsMoneyUnitRef4", map.getCodeNo());
				moneyUnit = map.getCodeNo();
			}
		}
		//default 환산 환율
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		Calendar c1 = Calendar.getInstance();
		String strToday = sdf.format(c1.getTime());

		param.put("AC_DATE"		, strToday);
		param.put("MONEY_UNIT"	, moneyUnit);
		exchgRate = (Map<String, Object>) salesCommonService.fnExchgRateO(param);
		model.addAttribute("gsExchangeRate", exchgRate.get("BASE_EXCHG"));

		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));

		return JSP_PATH + "s_sof100skrv_yp";
	}
	
	/** 주간 수주현황 조회(양평)
     *
     * @param _req
     * @param loginVO
     * @param listOp
     * @param model
     * @return
     * @throws Exception
     */
	@RequestMapping(value = "/z_yp/s_sof101skrv_yp.do")
	public String s_sof101skrv_yp(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());

		return JSP_PATH + "s_sof101skrv_yp";
	}




	/** 견적현황조회(양평)
	 *
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_yp/s_spp100skrv_yp.do")
	public String s_spp100skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
		model.addAttribute("TIMESHOW",this.tlabCodeService.getCodeInfo(loginVO.getCompCode()).getCodeInfo("S048", "SR").getRefCode1());

		return JSP_PATH + "s_spp100skrv_yp";
	}


	/** 견적등록(양평)
	 *
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_yp/s_spp100ukrv_yp.do")
	public String s_spp100ukrv_yp(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		cdo = codeInfo.getCodeInfo("S012", "1");
		if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsAutoType", cdo.getRefCode1());				// 자동채번여부(견전번호)

		List<CodeDetailVO> gsMoneyUnit = codeInfo.getCodeList("B004", "", false);
		for(CodeDetailVO map : gsMoneyUnit) {
			if("Y".equals(map.getRefCode1()))   {
				model.addAttribute("gsMoneyUnit", map.getCodeNo());
			}
		}																							// 자국화폐단위정보 조회

		cdo = codeInfo.getCodeInfo("S028", "1");
		if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsVatRate",cdo.getRefCode1());				// 부가세율정보 조회

		cdo = codeInfo.getCodeInfo("S036", "1");
		if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsSof100rkrLink",   cdo.getCodeName());		// 링크프로그램정보(견적서) 조회


		cdo = codeInfo.getCodeInfo("S037", "1");
		if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsSof100ukrLink",   cdo.getCodeName());		// 링크프로그램정보(수주등록) 조회

		return JSP_PATH + "s_spp100ukrv_yp";
	}


	/** 출고등록(개별)(양평)
	 *
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_yp/s_str103ukrv_yp.do")
	public String s_str103ukrv_yp(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
		model.addAttribute("COMBO_WH_CELL_LIST", comboService.getWhCellList(param));

		List<ComboItemModel> whList = comboService.getWhList(param);
		if(!ObjUtils.isEmpty(whList))	model.addAttribute("whList",ObjUtils.toJsonStr(whList));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		cdo = codeInfo.getCodeInfo("S012", "3");	//자동채번여부(출고번호)정보 조회
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsAutoType",cdo.getRefCode1());
		}else {
			model.addAttribute("gsAutoType", "N");
		}

		int i = 0;
		List<CodeDetailVO> gsMoneyUnit = codeInfo.getCodeList("B004", "", false);	//자국화폐단위 정보
		for(CodeDetailVO map : gsMoneyUnit)	{
			if("Y".equals(map.getRefCode1())){
				model.addAttribute("gsMoneyUnit", map.getCodeNo());
				i++;
			}
		}
		if(i == 0) model.addAttribute("gsMoneyUnit", "KRW");

		i = 0;
		List<CodeDetailVO> gsOptDivCode = codeInfo.getCodeList("S029", "", false);	//매출사업장지정정보 조회
		for(CodeDetailVO map : gsOptDivCode)	{
			if("Y".equals(map.getRefCode1())){
				model.addAttribute("gsOptDivCode", map.getCodeNo());
				i++;
			}
		}
		if(i == 0) model.addAttribute("gsOptDivCode", "1");


		cdo = codeInfo.getCodeInfo("S116", "str103ukrv");	//영업 중량및 부피 단위관련 Default 설정
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsPriceGubun",cdo.getRefCode1());
			model.addAttribute("gsWeight",cdo.getRefCode2());
			model.addAttribute("gsVolume",cdo.getRefCode3());
		}else {
			model.addAttribute("gsPriceGubun", "A");
			model.addAttribute("gsWeight", "KG");
			model.addAttribute("gsVolume", "L");
		}

		cdo = codeInfo.getCodeInfo("B090", "SB");	//LOT 연계여부 조회
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsLotNoInputMethod",cdo.getRefCode1());
			model.addAttribute("gsLotNoEssential",cdo.getRefCode2());
			model.addAttribute("gsEssItemAccount",cdo.getRefCode3());
		}

		i = 0;
		List<CodeDetailVO> gsInoutAutoYN = codeInfo.getCodeList("S033", "", false);	//출고등록시 자동매출생성/삭제여부정보 조회
		for(CodeDetailVO map : gsInoutAutoYN)	{
			if("Y".equals(map.getRefCode1()))	{
				model.addAttribute("gsInoutAutoYN", map.getCodeNo());
				if(map.getCodeNo().equals("1")){
					model.addAttribute("gsInoutAutoYN", "Y");
				}else{
					model.addAttribute("gsInoutAutoYN", "N");
				}
				i++;
			}
		}
		if(i == 0) model.addAttribute("gsInoutAutoYN", "Y");

		cdo = codeInfo.getCodeInfo("B022", "1");	//재고상태관리정보 조회
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsInvstatus",cdo.getRefCode1());
		}else {
			model.addAttribute("gsInvstatus", "+");
		}

		cdo = codeInfo.getCodeInfo("B117", "S");	//중량단위 계산시 판매단위수량 소수점 허용여부
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsPointYn",cdo.getRefCode1());
			model.addAttribute("gsUnitChack",cdo.getRefCode2());
		}else {
			model.addAttribute("gsPointYn", "Y");
			model.addAttribute("gsUnitChack", "EA");
		}

		i = 0;
		List<CodeDetailVO> gsCreditYn = codeInfo.getCodeList("S026", "", false);	//여신적용시점정보 조회(1.수주,2.출고,3.매출,4.미적용)
		for(CodeDetailVO map : gsCreditYn)	{
			if("Y".equals(map.getRefCode1()))	{
				model.addAttribute("gsCreditYn", map.getCodeNo());
				if(map.getCodeNo().equals("2")){
					model.addAttribute("gsCreditYn", "Y");
				}else{
					model.addAttribute("gsCreditYn", "N");
				}
				i++;
			}
		}
		if(i == 0) model.addAttribute("gsCreditYn", "N");

		 List<CodeDetailVO> cdList = codeInfo.getCodeList("S007");
			if(!ObjUtils.isEmpty(cdList))	model.addAttribute("grsOutType",ObjUtils.toJsonStr(cdList));

		cdo = codeInfo.getCodeInfo("B084", "D");	//재고합산유형 : 창고 Cell 합산
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsSumTypeCell",cdo.getRefCode1());
		}else {
			model.addAttribute("gsSumTypeCell", "N");
		}

		cdo = codeInfo.getCodeInfo("S112", "30");	//멀티품목팝업시 반품창고 참조방법(1=품목의 주창고, 2=첫번째행의 출고창고)
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsRefWhCode",cdo.getRefCode1());
		}else {
			model.addAttribute("gsRefWhCode", "1");
		}

		cdo = codeInfo.getCodeInfo("S028", "1");	//부가세율정보 조회
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsVatRate",cdo.getRefCode1());
		}else {
			model.addAttribute("gsVatRate", 10);
		}

		cdo = codeInfo.getCodeInfo("S048", "SI");	//시/분/초 필드 처리여부 조회
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsManageTimeYN",cdo.getRefCode1());
		}else {
			model.addAttribute("gsManageTimeYN", "N");
		}
		cdo = codeInfo.getCodeInfo("S120", "1");   //셀 자동LOT 배정여부(Y/N)
        if(!ObjUtils.isEmpty(cdo)){
            model.addAttribute("useLotAssignment",cdo.getRefCode1());
        }else {
            model.addAttribute("useLotAssignment", "N");
        }
		List<CodeDetailVO> salePrsn = codeInfo.getCodeList("S010");
		if(!ObjUtils.isEmpty(salePrsn))	model.addAttribute("salePrsn",ObjUtils.toJsonStr(salePrsn));

		List<CodeDetailVO> inoutPrsn = codeInfo.getCodeList("B024");
		if(!ObjUtils.isEmpty(inoutPrsn))	model.addAttribute("inoutPrsn",ObjUtils.toJsonStr(inoutPrsn));
		return JSP_PATH + "s_str103ukrv_yp";
	}


	/** 출고등록(일괄)(양평)
	 *
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_yp/s_str104ukrv_yp.do")
    public String s_str104ukrv_yp(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        param.put("S_COMP_CODE",loginVO.getCompCode());
        model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
        model.addAttribute("COMBO_WH_CELL_LIST", comboService.getWhCellList(param));

        List<ComboItemModel> whList = comboService.getWhList(param);
        if(!ObjUtils.isEmpty(whList))   model.addAttribute("whList",ObjUtils.toJsonStr(whList));

        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;

        cdo = codeInfo.getCodeInfo("S012", "3");    //자동채번여부(출고번호)정보 조회
        if(!ObjUtils.isEmpty(cdo)){
            model.addAttribute("gsAutoType",cdo.getRefCode1());
        }else {
            model.addAttribute("gsAutoType", "N");
        }

        int i = 0;
        List<CodeDetailVO> gsMoneyUnit = codeInfo.getCodeList("B004", "", false);   //자국화폐단위 정보
        for(CodeDetailVO map : gsMoneyUnit) {
            if("Y".equals(map.getRefCode1())){
                model.addAttribute("gsMoneyUnit", map.getCodeNo());
                i++;
            }
        }
        if(i == 0) model.addAttribute("gsMoneyUnit", "KRW");

        i = 0;
        List<CodeDetailVO> gsOptDivCode = codeInfo.getCodeList("S029", "", false);  //매출사업장지정정보 조회
        for(CodeDetailVO map : gsOptDivCode)    {
            if("Y".equals(map.getRefCode1())){
                model.addAttribute("gsOptDivCode", map.getCodeNo());
                i++;
            }
        }
        if(i == 0) model.addAttribute("gsOptDivCode", "1");


        cdo = codeInfo.getCodeInfo("S116", "str104ukrv");   //영업 중량및 부피 단위관련 Default 설정
        if(!ObjUtils.isEmpty(cdo)){
            model.addAttribute("gsPriceGubun",cdo.getRefCode1());
            model.addAttribute("gsWeight",cdo.getRefCode2());
            model.addAttribute("gsVolume",cdo.getRefCode3());
        }else {
            model.addAttribute("gsPriceGubun", "A");
            model.addAttribute("gsWeight", "KG");
            model.addAttribute("gsVolume", "L");
        }

        cdo = codeInfo.getCodeInfo("B090", "SB");   //LOT 연계여부 조회
        if(!ObjUtils.isEmpty(cdo)){
            model.addAttribute("gsLotNoInputMethod",cdo.getRefCode1());
            model.addAttribute("gsLotNoEssential",cdo.getRefCode2());
            model.addAttribute("gsEssItemAccount",cdo.getRefCode3());
        }

        i = 0;
        List<CodeDetailVO> gsInoutAutoYN = codeInfo.getCodeList("S033", "", false); //출고등록시 자동매출생성/삭제여부정보 조회
        for(CodeDetailVO map : gsInoutAutoYN)   {
            if("Y".equals(map.getRefCode1()))   {
                model.addAttribute("gsInoutAutoYN", map.getCodeNo());
                if(map.getCodeNo().equals("1")){
                    model.addAttribute("gsInoutAutoYN", "Y");
                }else{
                    model.addAttribute("gsInoutAutoYN", "N");
                }
                i++;
            }
        }
        if(i == 0) model.addAttribute("gsInoutAutoYN", "Y");

        cdo = codeInfo.getCodeInfo("B022", "1");    //재고상태관리정보 조회
        if(!ObjUtils.isEmpty(cdo)){
            model.addAttribute("gsInvstatus",cdo.getRefCode1());
        }else {
            model.addAttribute("gsInvstatus", "+");
        }

        cdo = codeInfo.getCodeInfo("B117", "S");    //중량단위 계산시 판매단위수량 소수점 허용여부
        if(!ObjUtils.isEmpty(cdo)){
            model.addAttribute("gsPointYn",cdo.getRefCode1());
            model.addAttribute("gsUnitChack",cdo.getRefCode2());
        }else {
            model.addAttribute("gsPointYn", "Y");
            model.addAttribute("gsUnitChack", "EA");
        }

        i = 0;
        List<CodeDetailVO> gsCreditYn = codeInfo.getCodeList("S026", "", false);    //여신적용시점정보 조회(1.수주,2.출고,3.매출,4.미적용)
        for(CodeDetailVO map : gsCreditYn)  {
            if("Y".equals(map.getRefCode1()))   {
                model.addAttribute("gsCreditYn", map.getCodeNo());
                if(map.getCodeNo().equals("2")){
                    model.addAttribute("gsCreditYn", "Y");
                }else{
                    model.addAttribute("gsCreditYn", "N");
                }
                i++;
            }
        }
        if(i == 0) model.addAttribute("gsCreditYn", "N");

         List<CodeDetailVO> cdList = codeInfo.getCodeList("S007");
            if(!ObjUtils.isEmpty(cdList))   model.addAttribute("grsOutType",ObjUtils.toJsonStr(cdList));

        cdo = codeInfo.getCodeInfo("B084", "D");    //재고합산유형 : 창고 Cell 합산
        if(!ObjUtils.isEmpty(cdo)){
            model.addAttribute("gsSumTypeCell",cdo.getRefCode1());
        }else {
            model.addAttribute("gsSumTypeCell", "N");
        }

        cdo = codeInfo.getCodeInfo("S112", "30");   //멀티품목팝업시 반품창고 참조방법(1=품목의 주창고, 2=첫번째행의 출고창고)
        if(!ObjUtils.isEmpty(cdo)){
            model.addAttribute("gsRefWhCode",cdo.getRefCode1());
        }else {
            model.addAttribute("gsRefWhCode", "1");
        }

        cdo = codeInfo.getCodeInfo("S028", "1");    //부가세율정보 조회
        if(!ObjUtils.isEmpty(cdo)){
            model.addAttribute("gsVatRate",cdo.getRefCode1());
        }else {
            model.addAttribute("gsVatRate", 10);
        }

        cdo = codeInfo.getCodeInfo("S048", "SI");   //시/분/초 필드 처리여부 조회
        if(!ObjUtils.isEmpty(cdo)){
            model.addAttribute("gsManageTimeYN",cdo.getRefCode1());
        }else {
            model.addAttribute("gsManageTimeYN", "N");
        }
        cdo = codeInfo.getCodeInfo("S120", "1");   //셀 자동LOT 배정여부(Y/N)
        if(!ObjUtils.isEmpty(cdo)){
            model.addAttribute("useLotAssignment",cdo.getRefCode1());
        }else {
            model.addAttribute("useLotAssignment", "N");
        }
        List<CodeDetailVO> salePrsn = codeInfo.getCodeList("S010");
        if(!ObjUtils.isEmpty(salePrsn)) model.addAttribute("salePrsn",ObjUtils.toJsonStr(salePrsn));

        List<CodeDetailVO> inoutPrsn = codeInfo.getCodeList("B024");
        if(!ObjUtils.isEmpty(inoutPrsn))    model.addAttribute("inoutPrsn",ObjUtils.toJsonStr(inoutPrsn));
        return JSP_PATH + "s_str104ukrv_yp";
    }














	/** 발주예정정보
     *
     * @param _req
     * @param loginVO
     * @param listOp
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/z_yp/s_mpo105ukrv_yp.do")
    public String s_mpo105ukrv_yp(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        List<CodeDetailVO> gsOrderPlanType = codeInfo.getCodeList("Z007", "", false);
        for(CodeDetailVO map : gsOrderPlanType) {
            if("Y".equals(map.getRefCode1()))   {
                if(map.getCodeNo().equals("1")){
                    model.addAttribute("gsOrderPlanType", "1");                 //1:통합
                }else{
                    model.addAttribute("gsOrderPlanType", "2");                 //2:개별
                }

            }
        }
        return JSP_PATH + "s_mpo105ukrv_yp";
    }

	/** 주간 발주현황 조회(양평)
     *
     * @param _req
     * @param loginVO
     * @param listOp
     * @param model
     * @return
     * @throws Exception
     */
	@RequestMapping(value = "/z_yp/s_mpo131skrv_yp.do")
	public String s_mpo131skrv_yp(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());

		return JSP_PATH + "s_mpo131skrv_yp";
	}

    /** 입고등록
     *
     * @param _req
     * @param loginVO
     * @param listOp
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/z_yp/s_mms510ukrv_yp.do",method = RequestMethod.GET)
    public String s_mms510ukrv_yp(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {

        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        param.put("S_COMP_CODE",loginVO.getCompCode());
        model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
        model.addAttribute("COMBO_WH_CELL_LIST", comboService.getWhCellList(param));

        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;

        List<CodeDetailVO> gsInoutTypeDetail = codeInfo.getCodeList("M103", "", false);     //입고유형
        for(CodeDetailVO map : gsInoutTypeDetail)   {
                model.addAttribute("gsInoutTypeDetail", map.getCodeNo());
        }

        List<CodeDetailVO> gsInOutPrsn = codeInfo.getCodeList("B024", "", false);   //입고담당 정보 조회
        for(CodeDetailVO map : gsInOutPrsn) {

            if(loginVO.getDivCode().equals(map.getRefCode1()))  {
                model.addAttribute("gsInOutPrsn", map.getCodeNo());
            }
        }

        List<CodeDetailVO> cdList = codeInfo.getCodeList("M103");   //기표대상여부관련
        if(!ObjUtils.isEmpty(cdList))   model.addAttribute("gsInTypeAccountYN",ObjUtils.toJsonStr(cdList));


        cdo = codeInfo.getCodeInfo("M102", "1");
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsExcessRate",cdo.getRefCode1());   //과입고허용률\

        cdo = codeInfo.getCodeInfo("B022", "1");
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsInvstatus",cdo.getRefCode1());    //재고상태관리



        List<CodeDetailVO> gsProcessFlag = codeInfo.getCodeList("BS07", "", false);     //처리방법 분류
        for(CodeDetailVO map : gsProcessFlag)   {
            if("Y".equals(map.getRefCode1()))   {
                model.addAttribute("gsProcessFlag", map.getCodeNo());
            }
        }

        List<CodeDetailVO> gsInspecFlag = codeInfo.getCodeList("Q003", "", false);      //검사프로그램사용여부
        for(CodeDetailVO map : gsInspecFlag)    {
            if("Y".equals(map.getRefCode1()))   {
                model.addAttribute("gsInspecFlag", map.getCodeNo());
            }
        }

        cdo = codeInfo.getCodeInfo("M024", "1");
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsMap100UkrLink",   cdo.getCodeName());     //링크프로그램정보(지급결의등록)


        cdo = codeInfo.getCodeInfo("B084", "C");
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsSumTypeLot",cdo.getRefCode1());   //재고합산유형:Lot No. 합산

        cdo = codeInfo.getCodeInfo("B084", "D");
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsSumTypeCell",cdo.getRefCode1());  //재고합산유형:창고 Cell. 합산

        List<CodeDetailVO> gsDefaultMoney = codeInfo.getCodeList("B004", "", false);        //기본 화폐단위
        for(CodeDetailVO map : gsDefaultMoney)  {
            if("Y".equals(map.getRefCode1()))   {
                model.addAttribute("gsDefaultMoney", map.getCodeNo());
            }
        }

        cdo = codeInfo.getCodeInfo("M101", "2");
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsAutoType",cdo.getRefCode1());

        cdo = codeInfo.getCodeInfo("M503", "1");
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsOScmYn",StringUtils.isBlank(cdo.getRefCode1())?"N":cdo.getRefCode1());

        if(StringUtils.isNotBlank(cdo.getRefCode1()) && "Y".equalsIgnoreCase(cdo.getRefCode1())){
            cdo = codeInfo.getCodeInfo("B605", "1");
            if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsDbName",StringUtils.isBlank(cdo.getRefCode3())?null:cdo.getRefCode3()+"..");
        }

        List<CodeDetailVO> gsGwYn = codeInfo.getCodeList("B610", "", false);//그룹웨어 사용여부
        for(CodeDetailVO map : gsGwYn) {
            if("Y".equals(map.getRefCode1()))   {
                model.addAttribute("gsGwYn", map.getCodeNo());
            }
        }

        cdo = codeInfo.getCodeInfo("B090", "OA");
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsLotNoInputMethod",cdo.getRefCode1() == null || "".equals(cdo.getRefCode1())?"N":cdo.getRefCode1());
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsLotNoEssential",cdo.getRefCode2() == null || "".equals(cdo.getRefCode2())?"N":cdo.getRefCode2());
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsEssItemAccount",cdo.getRefCode3() == null || "".equals(cdo.getRefCode3())?"":cdo.getRefCode3());

        return JSP_PATH + "s_mms510ukrv_yp";
    }

    @RequestMapping(value = "/z_yp/s_srq100ukrv_yp.do")
    public String s_srq100ukrv_yp(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;


        cdo = codeInfo.getCodeInfo("S012", "8");
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsAutoType",cdo.getRefCode1());             //Y:수주번호(txtOrderNum) lock,disable

        List<CodeDetailVO> gsMoneyUnit = codeInfo.getCodeList("B004", "", false);
        for(CodeDetailVO map : gsMoneyUnit) {
            if("Y".equals(map.getRefCode1()))   {
                model.addAttribute("gsMoneyUnit", map.getCodeNo());
            }
        }

        cdo = codeInfo.getCodeInfo("S028", "1");
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsVatRate",cdo.getRefCode1());

         List<CodeDetailVO> cdList = codeInfo.getCodeList("S007");
        if(!ObjUtils.isEmpty(cdList))   model.addAttribute("grsOutType",ObjUtils.toJsonStr(cdList));

        cdo = codeInfo.getCodeInfo("S026", "2");
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsCreditYn",cdo.getRefCode1()); //Y:여신잔액(txtRemainCredit) visible

        cdo = codeInfo.getCodeInfo("S036", "2");
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsPrintPgID",cdo.getRefCode1());

        cdo = codeInfo.getCodeInfo("S037", "2");
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsSrq100UkrLink",   cdo.getCodeName());             //출하지시등록 링크 PGM ID

        cdo = codeInfo.getCodeInfo("S037", "3");
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsStr100UkrLink",   cdo.getCodeName());             //출고등록 링크 PGM ID

        cdo = codeInfo.getCodeInfo("S048", "SR");
        if(!ObjUtils.isEmpty(cdo))  {
            model.addAttribute("gsTimeYN1", cdo.getRefCode1());
        }else {
            model.addAttribute("gsTimeYN1", "N");
        }

        cdo = codeInfo.getCodeInfo("S048", "SS");
        if(!ObjUtils.isEmpty(cdo))  {
            model.addAttribute("gsTimeYN2", cdo.getRefCode1());
        }else {
            model.addAttribute("gsTimeYN2", "N");
        }

        cdo = codeInfo.getCodeInfo("S071", "1");
        if(!ObjUtils.isEmpty(cdo))  {
            model.addAttribute("gsScmUseYN", cdo.getRefCode1());
        }else {
            model.addAttribute("gsScmUseYN", "N");
        }

        cdo = codeInfo.getCodeInfo("Z001", "srq101ukrv");
        if(!ObjUtils.isEmpty(cdo))  {
            model.addAttribute("gsBoxQYn", "Y");
            model.addAttribute("gsMiniPackQYn", "Y");
        }else {
            model.addAttribute("gsBoxQYn", "N");
            model.addAttribute("gsMiniPackQYn", "N");
        }

        cdo = codeInfo.getCodeInfo("B117", "S");
        if(!ObjUtils.isEmpty(cdo))  {
            model.addAttribute("gsPointYn", cdo.getRefCode1());
            model.addAttribute("gsUnitChack", cdo.getRefCode2());
        }else {
            model.addAttribute("gsPointYn", "Y");
            model.addAttribute("gsUnitChack", "EA");
        }

        cdo = codeInfo.getCodeInfo("S116", "srq101ukrv");
        if(!ObjUtils.isEmpty(cdo))  {
            model.addAttribute("gsPriceGubun",      cdo.getRefCode1());     //수주내역 그리드에서 PRICE_TYPE 디폴트값으로 사용
            model.addAttribute("gsWeight",          cdo.getRefCode2());     //수주내역 그리드에서 WGT_UNIT 디폴트값으로 사용
            model.addAttribute("gsVolume",          cdo.getRefCode3());     //수주내역 그리드에서 VOL_UNIT 디폴트값으로 사용
        } else {
            model.addAttribute("gsPriceGubun",      "A");       //수주내역 그리드에서 PRICE_TYPE 디폴트값으로 사용
            model.addAttribute("gsWeight",          "KG");      //수주내역 그리드에서 WGT_UNIT 디폴트값으로 사용
            model.addAttribute("gsVolume",          "L");       //수주내역 그리드에서 VOL_UNIT 디폴트값으로 사용
        }

        return JSP_PATH + "s_srq100ukrv_yp";
    }



    @RequestMapping(value = "/z_yp/s_mtr130rkrv_yp.do")
    public String s_mtr130rkrv_yp(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
        model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
        model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
        model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

        return JSP_PATH + "s_mtr130rkrv_yp";
    }

    @RequestMapping(value = "/z_yp/s_bcm107rkrv_yp.do", method = RequestMethod.GET)
    public String bpr101rkrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
        return JSP_PATH + "s_bcm107rkrv_yp";
    }

    @RequestMapping( value = "/z_yp/s_hat200ukr_yp.do" )
    public String s_hat200ukr_yp( LoginVO loginVO, ModelMap model ) throws Exception {
        Gson gson = new Gson();
        String colData = gson.toJson(hat520skrService.selectDutycode(loginVO.getCompCode()));
        model.addAttribute("colData", colData);

        Map map = new HashMap();
        model.addAttribute("COMBO_DEPTS2", comboService.fnGetauthDepts(loginVO,map));//특정부서 콤보

        return JSP_PATH + "s_hat200ukr_yp";
    }

    @RequestMapping(value = "/z_yp/s_mpo200ukrv_yp.do",method = RequestMethod.GET)
    public String s_mpo200ukrv_yp(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {

        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        param.put("S_COMP_CODE",loginVO.getCompCode());
        model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
        model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
        model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
        model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;

        List<CodeDetailVO> gsApproveYN = codeInfo.getCodeList("M008", "", false);       //발주승인 방식
        for(CodeDetailVO map : gsApproveYN) {
            if("Y".equals(map.getRefCode1()) || "y".equals(map.getRefCode1()))  {
                model.addAttribute("gsApproveYN", map.getCodeNo());
            }
        }

        List<CodeDetailVO> gsExchgRegYNList = codeInfo.getCodeList("B081", "", false);       //대체품목 등록여부
        for(CodeDetailVO map : gsExchgRegYNList) {
            if("Y".equals(map.getRefCode1()) || "y".equals(map.getRefCode1()))  {
                model.addAttribute("gsExchgRegYN", map.getCodeNo());
            }else{
                model.addAttribute("gsExchgRegYN", "N");
            }
        }
        int i = 0;
        List<CodeDetailVO> gsOrderPrsnList = codeInfo.getCodeList("M201", "", false);       //구매담당자
        for(CodeDetailVO map : gsOrderPrsnList) {
        	if(ObjUtils.isNotEmpty(map.getRefCode2())) {
	            if(loginVO.getUserID().toUpperCase().equals(map.getRefCode2().toUpperCase()))  {
	                model.addAttribute("gsOrderPrsn", map.getCodeNo());
		            i++;
	            }
        	}
        }
        if(i == 0) model.addAttribute("gsOrderPrsn", "");

        return JSP_PATH + "s_mpo200ukrv_yp";
    }

    @RequestMapping(value = "/z_yp/s_ssa450rkrv_yp.do")
    public String s_ssa450rkrv_yp(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        return JSP_PATH + "s_ssa450rkrv_yp";
    }


    /** 주문등록(주간/일반)(양평) - WEB
     *
     * @param _req
     * @param loginVO
     * @param listOp
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/z_yp/w_sof100ukrv_yp.do")
    public String w_sof100ukrv_yp(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {

        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;

        cdo = codeInfo.getCodeInfo("S026", "1");
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsCreditYn",cdo.getRefCode1()); //Y:여신잔액(txtRemainCredit) visible

        cdo = codeInfo.getCodeInfo("S012", "2");
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsAutoType",cdo.getRefCode1());             //Y:수주번호(txtOrderNum) lock,disable

        List<CodeDetailVO> gsMoneyUnit = codeInfo.getCodeList("B004", "", false);
        for(CodeDetailVO map : gsMoneyUnit) {
            if("Y".equals(map.getRefCode1()))   {
                model.addAttribute("gsMoneyUnit", map.getCodeNo());
            }
        }

        List<CodeDetailVO> gsBalanceOut = codeInfo.getCodeList("WB06", "", false);               //B/OUT 체크
        for(CodeDetailVO map : gsBalanceOut) {
            if("Y".equals(map.getRefCode1()))   {
                model.addAttribute("gsBalanceOut", map.getCodeNo());
            }
        }

        cdo = codeInfo.getCodeInfo("S028", "1");
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsVatRate",cdo.getRefCode1());



        List<CodeDetailVO> gsProdtDtAutoYN = codeInfo.getCodeList("S031", "", false);
        for(CodeDetailVO map : gsProdtDtAutoYN) {
            if("Y".equals(map.getRefCode1()))   {
                model.addAttribute("gsProdtDtAutoYN", map.getCodeNo());
            }
        }

        List<CodeDetailVO>  gsSaleAutoYN= codeInfo.getCodeList("S035", "", false);
        for(CodeDetailVO map : gsSaleAutoYN)    {
            if("Y".equals(map.getRefCode1()))   {
                model.addAttribute("gsSaleAutoYN", map.getCodeNo());
            }
        }

        cdo = codeInfo.getCodeInfo("S037", "1");
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsSof100ukrLink",   cdo.getCodeName());


        cdo = codeInfo.getCodeInfo("S037", "2");
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsSrq100UkrLink",   cdo.getCodeName());             //출하지시등록 링크 PGM ID

        cdo = codeInfo.getCodeInfo("S037", "3");
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsStr100UkrLink",   cdo.getCodeName());             //출고등록 링크 PGM ID

        cdo = codeInfo.getCodeInfo("S037", "4");
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsSsa100UkrLink",   cdo.getCodeName());             //매출등록 링크 PGM ID

        List<CodeDetailVO> gsProcessFlag = codeInfo.getCodeList("BS07", "", false);
        for(CodeDetailVO map : gsProcessFlag)   {
            if("Y".equals(map.getRefCode1()))   {
                model.addAttribute("gsProcessFlag", map.getCodeNo());
            }
        }

        List<CodeDetailVO> gsCondShowFlag = codeInfo.getCodeList("S043", "", false);
        for(CodeDetailVO map : gsCondShowFlag)  {
            if("Y".equals(map.getRefCode1()))   {
                model.addAttribute("gsCondShowFlag", map.getCodeNo());              //Y:수주내역의 할인율,할인율일괄적용,해당행 visible
            }
        }

        List<CodeDetailVO> gsDraftFlag = codeInfo.getCodeList("S044", "", false);
        for(CodeDetailVO map : gsDraftFlag) {
            if("Y".equals(map.getRefCode1()))   {
                if(map.getCodeNo().equals("1")){
                    model.addAttribute("gsDraftFlag", "Y");                 //Y:수주승인관련 필드
                }else{
                    model.addAttribute("gsDraftFlag", "N");                 //N:자동승인관련 필드
                }

            }
        }

        cdo = codeInfo.getCodeInfo("S045", "1");
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsApp1AmtInfo",     cdo.getRefCode2());             //수주승인사용일 경우 lblApp1AmtInfo 값 표시

        cdo = codeInfo.getCodeInfo("S045", "2");
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsApp2AmtInfo",     cdo.getRefCode2());             //수주승인사용일 경우 lblApp2AmtInfo,lblApp3AmtInfo 값 표시

        cdo = codeInfo.getCodeInfo("S048", "SS");
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsTimeYN",          cdo.getRefCode1());

        cdo = codeInfo.getCodeInfo("S061", "1");
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsScmUseYN",        cdo.getRefCode1());             //Y:SCM연계탭 enable

        cdo = codeInfo.getCodeInfo("B078", "10");
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsPjtCodeYN",       cdo.getRefCode1());             //Y:수주검색팝업에 txtPlanNum enable

        cdo = codeInfo.getCodeInfo("B117", "S");
        if(!ObjUtils.isEmpty(cdo))  {
            model.addAttribute("gsPointYn",         cdo.getRefCode1());             //수주내역 그리드에서 ORDER_VOL_Q,ORDER_WGT_Q 입력값 체크시 사용
            model.addAttribute("gsUnitChack",       cdo.getRefCode2());             //수주내역 그리드에서 ORDER_VOL_Q,ORDER_WGT_Q 입력값 체크시 사용
        }

        cdo = codeInfo.getCodeInfo("S116", "srq101ukrv");
        if(!ObjUtils.isEmpty(cdo))  {
            model.addAttribute("gsPriceGubun",      cdo.getRefCode1());     //수주내역 그리드에서 PRICE_TYPE 디폴트값으로 사용
            model.addAttribute("gsWeight",          cdo.getRefCode2());     //수주내역 그리드에서 WGT_UNIT 디폴트값으로 사용
            model.addAttribute("gsVolume",          cdo.getRefCode3());     //수주내역 그리드에서 VOL_UNIT 디폴트값으로 사용
        }


        List<CodeDetailVO> gsOrderTypeSaleYN = codeInfo.getCodeList("S044", "", false);
        List<Map<String, Object>>  listOrderTypeSaleYN = new ArrayList<Map<String, Object>>();
        for(CodeDetailVO map : gsOrderTypeSaleYN)   {
            Map<String, Object> aMap = new HashMap<String, Object>();
            aMap.put("SUB_CODE", map.getCodeNo());
            aMap.put("CODE_NAME", map.getCodeName());
            aMap.put("REF_CODE1", map.getRefCode1());
            listOrderTypeSaleYN.add(aMap);
        }
        model.addAttribute("gsOrderTypeSaleYN", listOrderTypeSaleYN);

        List<CodeDetailVO> salesPrsn = codeInfo.getCodeList("S010", "", false);
        List<Map> divPrsn = new ArrayList<Map>();
        for(CodeDetailVO map : salesPrsn)   {
                Map rMap = new HashMap();
                rMap.put("value",map.getCodeNo());
                rMap.put("text", map.getCodeName());
                rMap.put("option",map.getRefCode1());
                divPrsn.add(rMap);
        }
        model.addAttribute("divPrsn", divPrsn);

        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();

        Map<String, Object> gsCustomCode = w_sof100ukrv_ypService.getCustomCode(param);  //연계시스템 및 품명수정여부, 출력여부, 출력파일명 조회
        if(!ObjUtils.isEmpty(gsCustomCode)){
            model.addAttribute("gsCustomCode",gsCustomCode.get("CUSTOM_CODE"));
            model.addAttribute("gsCustomName",gsCustomCode.get("CUSTOM_NAME"));
            model.addAttribute("gsBusiPrsn",gsCustomCode.get("BUSI_PRSN"));
        }


        return JSP_PATH + "w_sof100ukrv_yp";
    }





    /** 주문등록II(주간/일반) (양평) - WEB
     *
     * @param _req
     * @param loginVO
     * @param listOp
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/z_yp/w_sof101ukrv_yp.do")
    public String w_sof101ukrv_yp(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;

        cdo = codeInfo.getCodeInfo("S026", "1");
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsCreditYn",cdo.getRefCode1()); //Y:여신잔액(txtRemainCredit) visible

        cdo = codeInfo.getCodeInfo("S012", "2");
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsAutoType",cdo.getRefCode1());             //Y:수주번호(txtOrderNum) lock,disable

        List<CodeDetailVO> gsMoneyUnit = codeInfo.getCodeList("B004", "", false);
        for(CodeDetailVO map : gsMoneyUnit) {
            if("Y".equals(map.getRefCode1()))   {
                model.addAttribute("gsMoneyUnit", map.getCodeNo());
            }
        }

        List<CodeDetailVO> gsBalanceOut = codeInfo.getCodeList("WB06", "", false);               //B/OUT 체크
        for(CodeDetailVO map : gsBalanceOut) {
            if("Y".equals(map.getRefCode1()))   {
                model.addAttribute("gsBalanceOut", map.getCodeNo());
            }
        }

        cdo = codeInfo.getCodeInfo("S028", "1");
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsVatRate",cdo.getRefCode1());



        List<CodeDetailVO> gsProdtDtAutoYN = codeInfo.getCodeList("S031", "", false);
        for(CodeDetailVO map : gsProdtDtAutoYN) {
            if("Y".equals(map.getRefCode1()))   {
                model.addAttribute("gsProdtDtAutoYN", map.getCodeNo());
            }
        }

        List<CodeDetailVO>  gsSaleAutoYN= codeInfo.getCodeList("S035", "", false);
        for(CodeDetailVO map : gsSaleAutoYN)    {
            if("Y".equals(map.getRefCode1()))   {
                model.addAttribute("gsSaleAutoYN", map.getCodeNo());
            }
        }

        cdo = codeInfo.getCodeInfo("S037", "1");
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsSof100ukrLink",   cdo.getCodeName());


        cdo = codeInfo.getCodeInfo("S037", "2");
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsSrq100UkrLink",   cdo.getCodeName());             //출하지시등록 링크 PGM ID

        cdo = codeInfo.getCodeInfo("S037", "3");
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsStr100UkrLink",   cdo.getCodeName());             //출고등록 링크 PGM ID

        cdo = codeInfo.getCodeInfo("S037", "4");
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsSsa100UkrLink",   cdo.getCodeName());             //매출등록 링크 PGM ID

        List<CodeDetailVO> gsProcessFlag = codeInfo.getCodeList("BS07", "", false);
        for(CodeDetailVO map : gsProcessFlag)   {
            if("Y".equals(map.getRefCode1()))   {
                model.addAttribute("gsProcessFlag", map.getCodeNo());
            }
        }

        List<CodeDetailVO> gsCondShowFlag = codeInfo.getCodeList("S043", "", false);
        for(CodeDetailVO map : gsCondShowFlag)  {
            if("Y".equals(map.getRefCode1()))   {
                model.addAttribute("gsCondShowFlag", map.getCodeNo());              //Y:수주내역의 할인율,할인율일괄적용,해당행 visible
            }
        }

        List<CodeDetailVO> gsDraftFlag = codeInfo.getCodeList("S044", "", false);
        for(CodeDetailVO map : gsDraftFlag) {
            if("Y".equals(map.getRefCode1()))   {
                if(map.getCodeNo().equals("1")){
                    model.addAttribute("gsDraftFlag", "Y");                 //Y:수주승인관련 필드
                }else{
                    model.addAttribute("gsDraftFlag", "N");                 //N:자동승인관련 필드
                }

            }
        }

        cdo = codeInfo.getCodeInfo("S045", "1");
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsApp1AmtInfo",     cdo.getRefCode2());             //수주승인사용일 경우 lblApp1AmtInfo 값 표시

        cdo = codeInfo.getCodeInfo("S045", "2");
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsApp2AmtInfo",     cdo.getRefCode2());             //수주승인사용일 경우 lblApp2AmtInfo,lblApp3AmtInfo 값 표시

        cdo = codeInfo.getCodeInfo("S048", "SS");
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsTimeYN",          cdo.getRefCode1());

        cdo = codeInfo.getCodeInfo("S061", "1");
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsScmUseYN",        cdo.getRefCode1());             //Y:SCM연계탭 enable

        cdo = codeInfo.getCodeInfo("B078", "10");
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsPjtCodeYN",       cdo.getRefCode1());             //Y:수주검색팝업에 txtPlanNum enable

        cdo = codeInfo.getCodeInfo("B117", "S");
        if(!ObjUtils.isEmpty(cdo))  {
            model.addAttribute("gsPointYn",         cdo.getRefCode1());             //수주내역 그리드에서 ORDER_VOL_Q,ORDER_WGT_Q 입력값 체크시 사용
            model.addAttribute("gsUnitChack",       cdo.getRefCode2());             //수주내역 그리드에서 ORDER_VOL_Q,ORDER_WGT_Q 입력값 체크시 사용
        }

        cdo = codeInfo.getCodeInfo("S116", "srq101ukrv");
        if(!ObjUtils.isEmpty(cdo))  {
            model.addAttribute("gsPriceGubun",      cdo.getRefCode1());     //수주내역 그리드에서 PRICE_TYPE 디폴트값으로 사용
            model.addAttribute("gsWeight",          cdo.getRefCode2());     //수주내역 그리드에서 WGT_UNIT 디폴트값으로 사용
            model.addAttribute("gsVolume",          cdo.getRefCode3());     //수주내역 그리드에서 VOL_UNIT 디폴트값으로 사용
        }


        List<CodeDetailVO> gsOrderTypeSaleYN = codeInfo.getCodeList("S044", "", false);
        List<Map<String, Object>>  listOrderTypeSaleYN = new ArrayList<Map<String, Object>>();
        for(CodeDetailVO map : gsOrderTypeSaleYN)   {
            Map<String, Object> aMap = new HashMap<String, Object>();
            aMap.put("SUB_CODE", map.getCodeNo());
            aMap.put("CODE_NAME", map.getCodeName());
            aMap.put("REF_CODE1", map.getRefCode1());
            listOrderTypeSaleYN.add(aMap);
        }
        model.addAttribute("gsOrderTypeSaleYN", listOrderTypeSaleYN);

        List<CodeDetailVO> salesPrsn = codeInfo.getCodeList("S010", "", false);
        List<Map> divPrsn = new ArrayList<Map>();
        for(CodeDetailVO map : salesPrsn)   {
                Map rMap = new HashMap();
                rMap.put("value",map.getCodeNo());
                rMap.put("text", map.getCodeName());
                rMap.put("option",map.getRefCode1());
                divPrsn.add(rMap);
        }
        model.addAttribute("divPrsn", divPrsn);

        model.addAttribute("CAL_NO", comboService.getCalNo(param));

        Map<String, Object> gsCustomCode = w_sof100ukrv_ypService.getCustomCode(param);  //연계시스템 및 품명수정여부, 출력여부, 출력파일명 조회
        if(!ObjUtils.isEmpty(gsCustomCode)){
            model.addAttribute("gsCustomCode",gsCustomCode.get("CUSTOM_CODE"));
            model.addAttribute("gsCustomName",gsCustomCode.get("CUSTOM_NAME"));
            model.addAttribute("gsBusiPrsn",gsCustomCode.get("BUSI_PRSN"));
        }

        return JSP_PATH + "w_sof101ukrv_yp";
    }

    /** 주문현황조회(양평) - WEB
     *
     * @param _req
     * @param loginVO
     * @param listOp
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/z_yp/w_sof100skrv_yp.do")
    public String sof100skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
        model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
        model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));

        Map<String, Object> gsCustomCode = w_sof100ukrv_ypService.getCustomCode(param);  //연계시스템 및 품명수정여부, 출력여부, 출력파일명 조회
        if(!ObjUtils.isEmpty(gsCustomCode)){
            model.addAttribute("gsCustomCode",gsCustomCode.get("CUSTOM_CODE"));
            model.addAttribute("gsCustomName",gsCustomCode.get("CUSTOM_NAME"));
            model.addAttribute("gsBusiPrsn",gsCustomCode.get("BUSI_PRSN"));
        }

        return JSP_PATH + "w_sof100skrv_yp";
    }

    /** 주문확정 - WEB
     *
     * @param _req
     * @param loginVO
     * @param listOp
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/z_yp/w_sof301ukrv_yp.do")
    public String w_sof301ukrv_yp(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        Map<String, Object> gsCustomCode = w_sof100ukrv_ypService.getCustomCode(param);  //연계시스템 및 품명수정여부, 출력여부, 출력파일명 조회
        if(!ObjUtils.isEmpty(gsCustomCode)){
            model.addAttribute("gsCustomCode",gsCustomCode.get("CUSTOM_CODE"));
            model.addAttribute("gsCustomName",gsCustomCode.get("CUSTOM_NAME"));
            model.addAttribute("gsBusiPrsn",gsCustomCode.get("BUSI_PRSN"));
        }

        return JSP_PATH + "w_sof301ukrv_yp";
    }
    /** 출고현황조회 - WEB
     *
     * @param _req
     * @param loginVO
     * @param listOp
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/z_yp/w_str302skrv_yp.do")
    public String str302skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        param.put("S_COMP_CODE",loginVO.getCompCode());
        model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
        model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
        model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
        model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

        Map<String, Object> gsCustomCode = w_sof100ukrv_ypService.getCustomCode(param);  //연계시스템 및 품명수정여부, 출력여부, 출력파일명 조회
        if(!ObjUtils.isEmpty(gsCustomCode)){
            model.addAttribute("gsCustomCode",gsCustomCode.get("CUSTOM_CODE"));
            model.addAttribute("gsCustomName",gsCustomCode.get("CUSTOM_NAME"));
            model.addAttribute("gsBusiPrsn",gsCustomCode.get("BUSI_PRSN"));
        }

        return JSP_PATH + "w_str302skrv_yp";
    }
    /** 매출현황조회 - WEB
     *
     * @param _req
     * @param loginVO
     * @param listOp
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/z_yp/w_ssa450skrv_yp.do")
    public String ssa450skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
        model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
        model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));

        Map<String, Object> gsCustomCode = w_sof100ukrv_ypService.getCustomCode(param);  //연계시스템 및 품명수정여부, 출력여부, 출력파일명 조회
        if(!ObjUtils.isEmpty(gsCustomCode)){
            model.addAttribute("gsCustomCode",gsCustomCode.get("CUSTOM_CODE"));
            model.addAttribute("gsCustomName",gsCustomCode.get("CUSTOM_NAME"));
            model.addAttribute("gsBusiPrsn",gsCustomCode.get("BUSI_PRSN"));
        }
        return JSP_PATH + "w_ssa450skrv_yp";
    }
    /** 세금계산서현황조회 - WEB
     *
     * @param _req
     * @param loginVO
     * @param listOp
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/z_yp/w_ssa580skrv_yp.do")
    public String ssa580skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        Map<String, Object> gsCustomCode = w_sof100ukrv_ypService.getCustomCode(param);  //연계시스템 및 품명수정여부, 출력여부, 출력파일명 조회
        if(!ObjUtils.isEmpty(gsCustomCode)){
            model.addAttribute("gsCustomCode",gsCustomCode.get("CUSTOM_CODE"));
            model.addAttribute("gsCustomName",gsCustomCode.get("CUSTOM_NAME"));
            model.addAttribute("gsBusiPrsn",gsCustomCode.get("BUSI_PRSN"));
        }

        return JSP_PATH + "w_ssa580skrv_yp";
    }
    /** 영업진행현황조회 - WEB
     *
     * @param _req
     * @param loginVO
     * @param listOp
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/z_yp/w_sof300skrv_yp.do")
    public String sof300skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
        model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
        model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));

        Map<String, Object> gsCustomCode = w_sof100ukrv_ypService.getCustomCode(param);  //연계시스템 및 품명수정여부, 출력여부, 출력파일명 조회
        if(!ObjUtils.isEmpty(gsCustomCode)){
            model.addAttribute("gsCustomCode",gsCustomCode.get("CUSTOM_CODE"));
            model.addAttribute("gsCustomName",gsCustomCode.get("CUSTOM_NAME"));
            model.addAttribute("gsBusiPrsn",gsCustomCode.get("BUSI_PRSN"));
        }
        return JSP_PATH + "w_sof300skrv_yp";
    }

    /**
     * 양평공사 WEB - 메인
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/z_yp/w_bsa000skrv_yp.do")
    public String w_bsa000skrv_yp(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model)throws Exception{
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        param.put("S_COMP_CODE",loginVO.getCompCode());
        model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
        model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
        model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
        model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

        return JSP_PATH+"w_bsa000skrv_yp";
    }

    /**
     * 작업지시현황 조회
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/z_yp/s_pmp100skrv_yp.do")
    public String s_pmp100skrv_yp(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        param.put("S_COMP_CODE",loginVO.getCompCode());
        model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
        model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
        model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
        model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));

        return JSP_PATH + "s_pmp100skrv_yp";
    }

    /**
     * 현재고현황 조회(수매품목)
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/z_yp/s_biv300skrv_yp.do")
    public String s_biv300skrv_yp(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        param.put("S_COMP_CODE",loginVO.getCompCode());
        model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
        model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
        model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
        model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;

        cdo = codeInfo.getCodeInfo("I004", "1");
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsAvgPHiddenYN",cdo.getRefCode1());

        List<Map<String, Object>> gsWHGroupYN = s_biv300skrv_ypService.getgsWHGroupYN(param);
        if(ObjUtils.isEmpty(gsWHGroupYN) || gsWHGroupYN.get(0).get("GROUP_CD").equals("")){
            gsWHGroupYN = new ArrayList<Map<String, Object>>();
            Map<String, Object> map = new HashMap<String, Object>();
            model.addAttribute("gsWHGroupYN","N");
            gsWHGroupYN.add(map);
        } else {
            model.addAttribute("gsWHGroupYN","Y");
        }
        return JSP_PATH + "s_biv300skrv_yp";
    }

    @RequestMapping( value = "/z_yp/s_hpa930rkr_yp.do" )
    public String s_hpa930rkr_yp( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        param.put("S_COMP_CODE",loginVO.getCompCode());
        model.addAttribute("costPoolCombo", comboService.getHumanCostPool(param));
        return JSP_PATH + "s_hpa930rkr_yp";
    }

    /**
     * 급여내역일괄조정(s_hpa350ukr_yp)
     *
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/z_yp/s_hpa350ukr_yp.do" )
    public String s_hpa350ukr_yp( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());

        param.put("S_COMP_CODE", loginVO.getCompCode());

        //지급구분에서 refcode1이 1인 데이터만 가져오기
        List<CodeDetailVO> gsList1 = codeInfo.getCodeList("H032", "", false);
        Object list1 = "";
        for (CodeDetailVO map : gsList1) {
            if ("1".equals(map.getRefCode1())) {
                if (list1.equals("")) {
                    list1 = map.getCodeNo();
                } else {
                    list1 = list1 + ";" + map.getCodeNo();
                }
            }
        }
        model.addAttribute("gsList1", list1);

        Gson gson = new Gson();
        String colData = gson.toJson(s_hpa350ukr_ypService.selectColumns(loginVO));
        model.addAttribute("colData", colData);

        Map map = new HashMap();
        model.addAttribute("COMBO_DEPTS2", comboService.fnGetauthDepts(loginVO,map));//특정부서 콤보

        return JSP_PATH + "s_hpa350ukr_yp";
    }

    /**
     * 재직/경력증명서 출력
     */
    @RequestMapping( value = "/z_yp/s_hum970rkr_yp.do" )
    public String hum970rkr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        return JSP_PATH + "s_hum970rkr_yp";
    }

    /**
     * 입고현황조회_양평
     */
    @RequestMapping(value = "/z_yp/s_mtr110skrv_yp.do")
	public String s_mtr110skrv_yp(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		logger.debug("[[]]");
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		List<CodeDetailVO> gsInOutPrsn = codeInfo.getCodeList("B024", "", false);	//구매담당 정보 조회
		model.addAttribute("gsInOutPrsn", "");
		for(CodeDetailVO map : gsInOutPrsn)	{
			if(loginVO.getUserID().equals(map.getRefCode2()))	{
				model.addAttribute("gsInOutPrsn", map.getCodeNo());
			}
		}

		return JSP_PATH + "s_mtr110skrv_yp";
	}

    @RequestMapping(value = "/z_yp/s_ssa900skrv_yp.do")
	public String s_ssa900skrv_yp(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		return JSP_PATH + "s_ssa900skrv_yp";
	}

    @RequestMapping(value = "/z_yp/s_map900skrv_yp.do")
	public String s_map900skrv_yp(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");


		return JSP_PATH + "s_map900skrv_yp";
	}

    @RequestMapping(value = "/z_yp/s_str400rkrv_yp.do")
    public String s_str400rkrv_yp(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        return JSP_PATH + "s_str400rkrv_yp";
    }

    @RequestMapping(value = "/z_yp/s_str120ukrv_yp.do")
	public String s_str120ukrv_yp(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
		model.addAttribute("COMBO_WH_CELL_LIST", comboService.getWhCellList(param));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		cdo = codeInfo.getCodeInfo("S012", "5");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsAutoType",cdo.getRefCode1());				//Y:입고번호

		List<CodeDetailVO> gsMoneyUnit = codeInfo.getCodeList("B004", "", false);					//자국화폐단위 정보
		for(CodeDetailVO map : gsMoneyUnit)	{
			if("Y".equals(map.getRefCode1()))	{
				model.addAttribute("gsMoneyUnit", map.getCodeNo());
			}
		}

		List<CodeDetailVO> gsInspecFlag = codeInfo.getCodeList("Q004", "", false);
		for(CodeDetailVO map : gsInspecFlag){
			if("Y".equals(map.getRefCode1()))	{
				model.addAttribute("gsInspecFlag", map.getCodeNo());
			}
		}

		cdo = codeInfo.getCodeInfo("B084", "D");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsSumTypeCell",cdo.getRefCode1());			//Y:창고Cell 합산


		//Lot 연계여부 조회
		cdo = codeInfo.getCodeInfo("B090", "SC");
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("mngLot",cdo.getRefCode1());
			model.addAttribute("essYn",cdo.getRefCode2());
			model.addAttribute("essAccount",cdo.getRefCode3());
		}

		List<Map<String, Object>> gsWkShopDivCode = str120ukrvService.getWkShopDivCode(param);	//작업장의 사업장 조회
		model.addAttribute("gsWkShopDivCode",ObjUtils.toJsonStr(gsWkShopDivCode));

//		Map<String, Object> comboParam = new HashMap<String, Object>();
//		comboParam.put("COMP_CODE", loginVO.getCompCode());
//        comboParam.put("TYPE", "BSA225T");
//        model.addAttribute("WH_CELL",  salesCommonService.fnRecordCombo(comboParam, session));







		/*


		cdo = codeInfo.getCodeInfo("S026", "1");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsCreditYn",cdo.getRefCode1());	//Y:여신잔액(txtRemainCredit) visible

		cdo = codeInfo.getCodeInfo("S028", "1");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsVatRate",cdo.getRefCode1());



		List<CodeDetailVO> gsProdtDtAutoYN = codeInfo.getCodeList("S031", "", false);
		for(CodeDetailVO map : gsProdtDtAutoYN)	{
			if("Y".equals(map.getRefCode1()))	{
				model.addAttribute("gsProdtDtAutoYN", map.getCodeNo());
			}
		}

		List<CodeDetailVO>  gsSaleAutoYN= codeInfo.getCodeList("S035", "", false);
		for(CodeDetailVO map : gsSaleAutoYN)	{
			if("Y".equals(map.getRefCode1()))	{
				model.addAttribute("gsSaleAutoYN", map.getCodeNo());
			}
		}

		cdo = codeInfo.getCodeInfo("S037", "1");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsSof100ukrLink",	cdo.getCodeName());


		cdo = codeInfo.getCodeInfo("S037", "2");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsSrq100UkrLink",	cdo.getCodeName());				//출하지시등록 링크 PGM ID

		cdo = codeInfo.getCodeInfo("S037", "3");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsStr100UkrLink",	cdo.getCodeName());				//출고등록 링크 PGM ID

		cdo = codeInfo.getCodeInfo("S037", "4");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsSsa100UkrLink",	cdo.getCodeName());				//매출등록 링크 PGM ID

		List<CodeDetailVO> gsProcessFlag = codeInfo.getCodeList("BS07", "", false);
		for(CodeDetailVO map : gsProcessFlag)	{
			if("Y".equals(map.getRefCode1()))	{
				model.addAttribute("gsProcessFlag", map.getCodeNo());
			}
		}

		List<CodeDetailVO> gsCondShowFlag = codeInfo.getCodeList("S043", "", false);
		for(CodeDetailVO map : gsCondShowFlag)	{
			if("Y".equals(map.getRefCode1()))	{
				model.addAttribute("gsCondShowFlag", map.getCodeNo());				//Y:수주내역의 할인율,할인율일괄적용,해당행 visible
			}
		}

		List<CodeDetailVO> gsDraftFlag = codeInfo.getCodeList("S044", "", false);
		for(CodeDetailVO map : gsDraftFlag)	{
			if("Y".equals(map.getRefCode1()))	{
				model.addAttribute("gsDraftFlag", map.getCodeNo());					//Y:수주승인관련 필드 visible
			}
		}

		cdo = codeInfo.getCodeInfo("S045", "1");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsApp1AmtInfo",		cdo.getRefCode2());				//수주승인사용일 경우 lblApp1AmtInfo 값 표시

		cdo = codeInfo.getCodeInfo("S045", "2");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsApp2AmtInfo",		cdo.getRefCode2());				//수주승인사용일 경우 lblApp2AmtInfo,lblApp3AmtInfo 값 표시

		cdo = codeInfo.getCodeInfo("S048", "SS");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsTimeYN",			cdo.getRefCode1());

		cdo = codeInfo.getCodeInfo("S061", "1");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsScmUseYN",		cdo.getRefCode1());				//Y:SCM연계탭 enable

		cdo = codeInfo.getCodeInfo("B078", "10");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsPjtCodeYN",		cdo.getRefCode1());				//Y:수주검색팝업에 txtPlanNum enable

		cdo = codeInfo.getCodeInfo("B117", "S");
		if(!ObjUtils.isEmpty(cdo))	{
			model.addAttribute("gsPointYn",			cdo.getRefCode1());				//수주내역 그리드에서 ORDER_VOL_Q,ORDER_WGT_Q 입력값 체크시 사용
			model.addAttribute("gsUnitChack",		cdo.getRefCode2());				//수주내역 그리드에서 ORDER_VOL_Q,ORDER_WGT_Q 입력값 체크시 사용
		}

		cdo = codeInfo.getCodeInfo("S116", "srq101ukrv");
		if(!ObjUtils.isEmpty(cdo))	{
			model.addAttribute("gsPriceGubun",		cdo.getRefCode1());		//수주내역 그리드에서 PRICE_TYPE 디폴트값으로 사용
			model.addAttribute("gsWeight",			cdo.getRefCode2());		//수주내역 그리드에서 WGT_UNIT 디폴트값으로 사용
			model.addAttribute("gsVolume",			cdo.getRefCode3());		//수주내역 그리드에서 VOL_UNIT 디폴트값으로 사용
		}


		List<CodeDetailVO> gsOrderTypeSaleYN = codeInfo.getCodeList("S044", "", false);
	    List<Map<String, Object>>  listOrderTypeSaleYN = new ArrayList<Map<String, Object>>();
		for(CodeDetailVO map : gsOrderTypeSaleYN)	{
			Map<String, Object> aMap = new HashMap<String, Object>();
			aMap.put("SUB_CODE", map.getCodeNo());
			aMap.put("CODE_NAME", map.getCodeName());
			aMap.put("REF_CODE1", map.getRefCode1());
			listOrderTypeSaleYN.add(aMap);
		}
		model.addAttribute("gsOrderTypeSaleYN", listOrderTypeSaleYN);

		List<CodeDetailVO> salesPrsn = codeInfo.getCodeList("S010", "", false);
		List<Map> divPrsn = new ArrayList<Map>();
		for(CodeDetailVO map : salesPrsn)	{
				Map rMap = new HashMap();
				rMap.put("value",map.getCodeNo());
				rMap.put("text", map.getCodeName());
				rMap.put("option",map.getRefCode1());
				divPrsn.add(rMap);
		}
		model.addAttribute("divPrsn", divPrsn);
		*/
		return JSP_PATH + "s_str120ukrv_yp";
	}

    @RequestMapping(value = "/z_yp/s_biv120ukrv_yp.do",method = RequestMethod.GET)
	public String s_biv120ukrv_yp(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
	 final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		cdo = codeInfo.getCodeInfo("B084", "C");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsSumTypeLot",cdo.getRefCode1());		/* 재고합산유형 : Lot No. 합산 */

		cdo = codeInfo.getCodeInfo("B084", "D");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsSumTypeCell",cdo.getRefCode1());		/* 재고합산유형 : 창고 Cell 합산 */

		return JSP_PATH + "s_biv120ukrv_yp";
	}

    /** 입고등록(양평)
    *
    * @param _req
    * @param loginVO
    * @param listOp
    * @param model
    * @return
    * @throws Exception
    */
   @RequestMapping(value = "/z_yp/s_mms515ukrv_yp.do",method = RequestMethod.GET)
   public String s_mms515ukrv_yp(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {

       final String[] searchFields = {  };
       NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
       LoginVO session = _req.getSession();
       Map<String, Object> param = navigator.getParam();
       String page = _req.getP("page");

       param.put("S_COMP_CODE",loginVO.getCompCode());
       model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
       model.addAttribute("COMBO_WH_CELL_LIST", comboService.getWhCellList(param));

       CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
       CodeDetailVO cdo = null;

       List<CodeDetailVO> gsInoutTypeDetail = codeInfo.getCodeList("M103", "", false);     //입고유형
       for(CodeDetailVO map : gsInoutTypeDetail)   {
               model.addAttribute("gsInoutTypeDetail", map.getCodeNo());
       }

       List<CodeDetailVO> gsInOutPrsn = codeInfo.getCodeList("B024", "", false);   //입고담당 정보 조회
       for(CodeDetailVO map : gsInOutPrsn) {

           if(loginVO.getDivCode().equals(map.getRefCode1()))  {
               model.addAttribute("gsInOutPrsn", map.getCodeNo());
           }
       }

       List<CodeDetailVO> cdList = codeInfo.getCodeList("M103");   //기표대상여부관련
       if(!ObjUtils.isEmpty(cdList))   model.addAttribute("gsInTypeAccountYN",ObjUtils.toJsonStr(cdList));


       cdo = codeInfo.getCodeInfo("M102", "1");
       if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsExcessRate",cdo.getRefCode1());   //과입고허용률\

       cdo = codeInfo.getCodeInfo("B022", "1");
       if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsInvstatus",cdo.getRefCode1());    //재고상태관리



       List<CodeDetailVO> gsProcessFlag = codeInfo.getCodeList("BS07", "", false);     //처리방법 분류
       for(CodeDetailVO map : gsProcessFlag)   {
           if("Y".equals(map.getRefCode1()))   {
               model.addAttribute("gsProcessFlag", map.getCodeNo());
           }
       }

       List<CodeDetailVO> gsInspecFlag = codeInfo.getCodeList("Q003", "", false);      //검사프로그램사용여부
       for(CodeDetailVO map : gsInspecFlag)    {
           if("Y".equals(map.getRefCode1()))   {
               model.addAttribute("gsInspecFlag", map.getCodeNo());
           }
       }

       cdo = codeInfo.getCodeInfo("M024", "1");
       if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsMap100UkrLink",   cdo.getCodeName());     //링크프로그램정보(지급결의등록)


       cdo = codeInfo.getCodeInfo("B084", "C");
       if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsSumTypeLot",cdo.getRefCode1());   //재고합산유형:Lot No. 합산

       cdo = codeInfo.getCodeInfo("B084", "D");
       if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsSumTypeCell",cdo.getRefCode1());  //재고합산유형:창고 Cell. 합산

       List<CodeDetailVO> gsDefaultMoney = codeInfo.getCodeList("B004", "", false);        //기본 화폐단위
       for(CodeDetailVO map : gsDefaultMoney)  {
           if("Y".equals(map.getRefCode1()))   {
               model.addAttribute("gsDefaultMoney", map.getCodeNo());
           }
       }

       cdo = codeInfo.getCodeInfo("M101", "2");
       if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsAutoType",cdo.getRefCode1());

       cdo = codeInfo.getCodeInfo("M503", "1");
       if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsOScmYn",StringUtils.isBlank(cdo.getRefCode1())?"N":cdo.getRefCode1());

       if(StringUtils.isNotBlank(cdo.getRefCode1()) && "Y".equalsIgnoreCase(cdo.getRefCode1())){
           cdo = codeInfo.getCodeInfo("B605", "1");
           if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsDbName",StringUtils.isBlank(cdo.getRefCode3())?null:cdo.getRefCode3()+"..");
       }

       List<CodeDetailVO> gsGwYn = codeInfo.getCodeList("B610", "", false);//그룹웨어 사용여부
       for(CodeDetailVO map : gsGwYn) {
           if("Y".equals(map.getRefCode1()))   {
               model.addAttribute("gsGwYn", map.getCodeNo());
           }
       }

       cdo = codeInfo.getCodeInfo("B090", "OA");
       if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsLotNoInputMethod",cdo.getRefCode1() == null || "".equals(cdo.getRefCode1())?"N":cdo.getRefCode1());
       if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsLotNoEssential",cdo.getRefCode2() == null || "".equals(cdo.getRefCode2())?"N":cdo.getRefCode2());
       if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsEssItemAccount",cdo.getRefCode3() == null || "".equals(cdo.getRefCode3())?"":cdo.getRefCode3());

       return JSP_PATH + "s_mms515ukrv_yp";
   }

}
