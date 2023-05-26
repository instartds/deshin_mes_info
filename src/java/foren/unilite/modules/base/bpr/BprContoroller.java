package foren.unilite.modules.base.bpr;

import java.io.DataOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.lang.reflect.Field;
import java.net.Socket;
import java.nio.charset.Charset;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.util.ExtDirectSpringUtil;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.type.TypeFactory;

import foren.framework.lib.listop.ListOp;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.framework.model.NavigatorInfo;
import foren.framework.utils.ConfigUtil;
import foren.framework.utils.ObjUtils;
import foren.framework.web.support.CustomHandlerMethodArgumentResolver;
import foren.framework.web.view.FileDownloadInfo;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.com.code.CodeDetailVO;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.modules.base.BaseCommonServiceImpl;
import foren.unilite.modules.com.barcodePrint.BarcodePrintUtils;
import foren.unilite.modules.com.combo.ComboItemModel;
import foren.unilite.modules.com.combo.ComboServiceImpl;
import foren.unilite.modules.com.tree.UniTreeNode;

import java.sql.Connection;

@Controller
public class BprContoroller extends UniliteCommonController {

	private final Logger	logger		= LoggerFactory.getLogger(this.getClass());

	final static String		JSP_PATH	= "/base/bpr/";

	@Resource(name="UniliteComboServiceImpl")
	private ComboServiceImpl comboService;

	@Resource(name="baseCommonService")
	private BaseCommonServiceImpl baseCommonService;

	@Resource(name="bpr100ukrvService")
	private Bpr100ukrvServiceImpl bpr100ukrvService;

	@Resource(name="bpr130ukrvService")
	private Bpr130ukrvServiceImpl bpr130ukrvService;
	
	@Resource(name="bpr300ukrvService")
	private Bpr300ukrvServiceImpl bpr300ukrvService;

	@Resource(name="bpr580skrvService")
	private Bpr580skrvServiceImpl bpr580skrvService;

	@Resource(name="bpr581skrvService")
	private Bpr581skrvServiceImpl bpr581skrvService;

	@Resource(name="bpr810rkrvService")
	private Bpr810rkrvServiceImpl bpr810rkrvService;


	@RequestMapping(value = "/base/bpr400skrv.do", method = RequestMethod.GET)
	public String bpr400skrv() throws Exception {
		return JSP_PATH + "bpr400skrv";
	}

	@RequestMapping(value = "/base/bpr401skrv.do", method = RequestMethod.GET)
	public String bpr401skrv() throws Exception {
		return JSP_PATH + "bpr401skrv";
	}

	@RequestMapping(value = "/base/bpr402skrv.do", method = RequestMethod.GET)
	public String bpr402skrv() throws Exception {
		return JSP_PATH + "bpr402skrv";
	}

	@RequestMapping(value = "/base/bpr110ukrv.do", method = RequestMethod.GET)
	public String bpr110ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));

		return JSP_PATH + "bpr110ukrv";
	}

	@RequestMapping(value = "/base/bpr100ukrv.do", method = RequestMethod.GET)
	public String bpr100ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
		model.addAttribute("UseByDate",this.tlabCodeService.getCodeInfo(loginVO.getCompCode()).getCodeInfo("B073", "1").getRefCode1());
		//model.addAttribute("UseByDate",this.tlabCodeService.getCodeInfo(loginVO.getCompCode()).getCodeInfo("B108", "B005").getRefCode3());
		String precision = null;
		String formatWithPrecision = "0,000.";
		List<CodeDetailVO> configList = this.tlabCodeService.getCodeInfo(loginVO.getCompCode()).getCodeList("B108", "", false);
		for(CodeDetailVO map : configList)	{
			if("bpr100ukrv".equals(map.getRefCode1()))	{
				if("REIM".equals(map.getRefCode2()))	{
					precision = map.getRefCode3();

					int intPrecision = ObjUtils.parseInt(precision);
					for(int i=0; i<intPrecision; i++ )	{
						formatWithPrecision+="0";
					}
					model.addAttribute("REIM_Precision", map.getRefCode3());
					model.addAttribute("REIM_PrecisionFormat",formatWithPrecision);
				}
			}
		}
		if(precision == null)	{
			model.addAttribute("REIM_Precision", 2);
		}
		return JSP_PATH + "bpr100ukrv";
	}

	/**
	 * 품목표준공수등록(bpr201ukrv)
	 *
	 */
	@RequestMapping(value = "/base/bpr201ukrv.do")
	public String bpr201ukrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));

		List<CodeDetailVO> gsMoneyUnit = codeInfo.getCodeList("B004", "", false);
		for(CodeDetailVO map : gsMoneyUnit) {
			if("Y".equals(map.getRefCode1())) {
				model.addAttribute("gsMoneyUnit", map.getCodeNo());
			}
		}

		return JSP_PATH + "bpr201ukrv";
	}

	@RequestMapping(value = "/base/bpr100rkrv.do", method = RequestMethod.GET)
	public String bpr100rkrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		return JSP_PATH + "bpr100rkrv";
	}

	@RequestMapping(value = "/base/bpr520rkrv.do", method = RequestMethod.GET)
	public String bpr520rkrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		return JSP_PATH + "bpr520rkrv";
	}

	@RequestMapping(value = "/base/bpr101rkrv.do", method = RequestMethod.GET)
	public String bpr101rkrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		return JSP_PATH + "bpr101rkrv";
	}

	@RequestMapping(value="/base/printBarcode", method = RequestMethod.POST)
	  public  ModelAndView printBarcode( ExtHtttprequestParam _req) throws Exception {

		//Map pData = _req.getParameterMap();

		ObjectMapper mapper = new ObjectMapper();
		List<Map> paramList = mapper.readValue( ObjUtils.getSafeString((_req.getP("data"))),
				TypeFactory.defaultInstance().constructCollectionType(List.class,   Map.class));

		File dir = new File(ConfigUtil.getUploadBasePath("omegapluslabel"));
		if(!dir.exists())  dir.mkdir();
		FileDownloadInfo fInfo = new FileDownloadInfo(ConfigUtil.getUploadBasePath("omegapluslabel"), "omegapluslabel.txt");

		FileOutputStream fos = new FileOutputStream(fInfo.getFile());
		String data = "";
		for(Map param: paramList) {

				if(param.get("PRINT_P_YN").toString().equals("true")){//단가 출력여부..
					data += param.get("ITEM_CODE") + "|" + param.get("ITEM_NAME") + "|" + param.get("SALE_BASIS_P") + "|" + param.get("PRINT_Q") + "\r\n";
				}else{
					data += param.get("ITEM_CODE") + "|" + param.get("ITEM_NAME") + "||" + param.get("PRINT_Q") + "\r\n";
				}

		}
		byte[] bytesArray = data.getBytes();
		fos.write(bytesArray);

		fos.flush();
		fos.close();
		fInfo.setStream(fos);

		return ViewHelper.getFileDownloadView(fInfo);

	 }

	@RequestMapping(value = "/base/bpr101ukrv.do", method = RequestMethod.GET)
	public String bpr101ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
		model.addAttribute("UseByDate",this.tlabCodeService.getCodeInfo(loginVO.getCompCode()).getCodeInfo("B073", "1").getRefCode1());

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		cdo = codeInfo.getCodeInfo("S242", "1");	//품목코드, 바코드 동기화 여부
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsItemCodeSyncYN",cdo.getRefCode1());
		}else {
			model.addAttribute("gsItemCodeSyncYN", "N");
		}
		List<CodeDetailVO> binNumList = codeInfo.getCodeList("YP02", "", false);
		Object numList= "";
		for(CodeDetailVO map : binNumList)	{
			if("1".equals(map.getRefCode2()))	{
				if(numList.equals("")){
				numList =  map.getCodeNo();
				}else{
					numList = numList + ";" + map.getCodeNo();
				}
			}
		}
		model.addAttribute("binNumList", numList);

		List<CodeDetailVO> itemAccount = codeInfo.getCodeList("B020", "", false);
		Object accountList= "";
		for(CodeDetailVO map : itemAccount)	{
			if("1".equals(map.getRefCode4()))	{
				if(accountList.equals("")){
				accountList =  map.getCodeNo();
				}else{
					accountList = accountList + ";" + map.getCodeNo();
				}
			}
		}
		model.addAttribute("itemAccount", accountList);
		return JSP_PATH + "bpr101ukrv";
	}

	@RequestMapping(value = "/base/bpr101skrv.do", method = RequestMethod.GET)
	public String bpr101skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
		model.addAttribute("UseByDate",this.tlabCodeService.getCodeInfo(loginVO.getCompCode()).getCodeInfo("B073", "1").getRefCode1());

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		cdo = codeInfo.getCodeInfo("S242", "1");	//품목코드, 바코드 동기화 여부
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsItemCodeSyncYN",cdo.getRefCode1());
		}else {
			model.addAttribute("gsItemCodeSyncYN", "N");
		}
		List<CodeDetailVO> binNumList = codeInfo.getCodeList("YP02", "", false);
		Object numList= "";
		for(CodeDetailVO map : binNumList)	{
			if("1".equals(map.getRefCode2()))	{
				if(numList.equals("")){
				numList =  map.getCodeNo();
				}else{
					numList = numList + ";" + map.getCodeNo();
				}
			}
		}
		model.addAttribute("binNumList", numList);

		List<CodeDetailVO> itemAccount = codeInfo.getCodeList("B020", "", false);
		Object accountList= "";
		for(CodeDetailVO map : itemAccount)	{
			if("1".equals(map.getRefCode4()))	{
				if(accountList.equals("")){
				accountList =  map.getCodeNo();
				}else{
					accountList = accountList + ";" + map.getCodeNo();
				}
			}
		}
		model.addAttribute("itemAccount", accountList);
		return JSP_PATH + "bpr101skrv";
	}

	@RequestMapping(value = "/base/bpr102ukrv.do", method = RequestMethod.GET)
	public String bpr102ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
		model.addAttribute("UseByDate",this.tlabCodeService.getCodeInfo(loginVO.getCompCode()).getCodeInfo("B073", "1").getRefCode1());


		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		List<CodeDetailVO> binNumList = codeInfo.getCodeList("YP02", "", false);
		Object numList= "";
		for(CodeDetailVO map : binNumList)	{
			if("0".equals(map.getRefCode2()))	{
				if(numList.equals("")){
				numList =  map.getCodeNo();
				}else{
					numList = numList + ";" + map.getCodeNo();
				}
			}
		}
		model.addAttribute("binNumList", numList);

		List<CodeDetailVO> itemAccount = codeInfo.getCodeList("B020", "", false);
		Object accountList= "";
		for(CodeDetailVO map : itemAccount)	{
			if("0".equals(map.getRefCode4()))	{
				if(accountList.equals("")){
				accountList =  map.getCodeNo();
				}else{
					accountList = accountList + ";" + map.getCodeNo();
				}
			}
		}
		model.addAttribute("itemAccount", accountList);

		return JSP_PATH + "bpr102ukrv";
	}

	@RequestMapping(value = "/base/bpr102skrv.do", method = RequestMethod.GET)
	public String bpr102skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
		model.addAttribute("UseByDate",this.tlabCodeService.getCodeInfo(loginVO.getCompCode()).getCodeInfo("B073", "1").getRefCode1());


		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		List<CodeDetailVO> binNumList = codeInfo.getCodeList("YP02", "", false);
		Object numList= "";
		for(CodeDetailVO map : binNumList)	{
			if("0".equals(map.getRefCode2()))	{
				if(numList.equals("")){
				numList =  map.getCodeNo();
				}else{
					numList = numList + ";" + map.getCodeNo();
				}
			}
		}
		model.addAttribute("binNumList", numList);

		List<CodeDetailVO> itemAccount = codeInfo.getCodeList("B020", "", false);
		Object accountList= "";
		for(CodeDetailVO map : itemAccount)	{
			if("0".equals(map.getRefCode4()))	{
				if(accountList.equals("")){
				accountList =  map.getCodeNo();
				}else{
					accountList = accountList + ";" + map.getCodeNo();
				}
			}
		}
		model.addAttribute("itemAccount", accountList);

		return JSP_PATH + "bpr102skrv";
	}

	@RequestMapping(value = "/base/bpr120skrv.do", method = RequestMethod.GET)
	public String bpr120skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));

		return JSP_PATH + "bpr120skrv";
	}

	@RequestMapping(value = "/base/bpr103ukrv.do", method = RequestMethod.GET)
	public String bpr103ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
		model.addAttribute("UseByDate",this.tlabCodeService.getCodeInfo(loginVO.getCompCode()).getCodeInfo("B073", "1").getRefCode1());
		//model.addAttribute("UseByDate",this.tlabCodeService.getCodeInfo(loginVO.getCompCode()).getCodeInfo("B108", "B005").getRefCode3());
//		String precision = null;
//		String formatWithPrecision = "0,000.";
//		List<CodeDetailVO> configList = this.tlabCodeService.getCodeInfo(loginVO.getCompCode()).getCodeList("B108", "", false);
//		for(CodeDetailVO map : configList)	{
//			if("bpr103ukrv".equals(map.getRefCode1()))	{
//				if("REIM".equals(map.getRefCode2()))	{
//					precision = map.getRefCode3();
//
//					int intPrecision = ObjUtils.parseInt(precision);
//					for(int i=0; i<intPrecision; i++ )	{
//						formatWithPrecision+="0";
//					}
//					model.addAttribute("REIM_Precision", map.getRefCode3());
//					model.addAttribute("REIM_PrecisionFormat",formatWithPrecision);
//				}
//			}
//		}
//		if(precision == null)	{
//			model.addAttribute("REIM_Precision", 2);
//		}
		return JSP_PATH + "bpr103ukrv";
	}

	@RequestMapping(value = "/base/bpr104skrv.do", method = RequestMethod.GET)
	public String bpr104skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
		model.addAttribute("UseByDate",this.tlabCodeService.getCodeInfo(loginVO.getCompCode()).getCodeInfo("B073", "1").getRefCode1());
		//model.addAttribute("UseByDate",this.tlabCodeService.getCodeInfo(loginVO.getCompCode()).getCodeInfo("B108", "B005").getRefCode3());
//		String precision = null;
//		String formatWithPrecision = "0,000.";
//		List<CodeDetailVO> configList = this.tlabCodeService.getCodeInfo(loginVO.getCompCode()).getCodeList("B108", "", false);
//		for(CodeDetailVO map : configList)	{
//			if("bpr103ukrv".equals(map.getRefCode1()))	{
//				if("REIM".equals(map.getRefCode2()))	{
//					precision = map.getRefCode3();
//
//					int intPrecision = ObjUtils.parseInt(precision);
//					for(int i=0; i<intPrecision; i++ )	{
//						formatWithPrecision+="0";
//					}
//					model.addAttribute("REIM_Precision", map.getRefCode3());
//					model.addAttribute("REIM_PrecisionFormat",formatWithPrecision);
//				}
//			}
//		}
//		if(precision == null)	{
//			model.addAttribute("REIM_Precision", 2);
//		}
		return JSP_PATH + "bpr104skrv";
	}


	/** 품목정보 Upload
	 *
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/base/bpr130ukrv.do", method = RequestMethod.GET)
	public String bpr130ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());

		return JSP_PATH + "bpr130ukrv";
	}

	/**
	 * 품목/거래처/BOM 업로드 (bpr130ukrv)에 전체BOM 다운로드 기능 추가 - 20191217
	 * @param _req
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@ResponseBody
	@RequestMapping(value = "/base/bpr130ukrv_BOM_ExcelDown.do")
	public ModelAndView bpr130ukrvDownLoadExcel(ExtHtttprequestParam _req, HttpServletResponse response) throws Exception{	
		Map<String, Object> paramMap = _req.getParameterMap();
		Workbook wb = bpr130ukrvService.makeExcelData(paramMap);
		String title = "전체 BOM 정보";
		
		return ViewHelper.getExcelDownloadView(wb, title);
	}


	@RequestMapping(value = "/base/bpr250ukrv.do", method = RequestMethod.GET)
	public String bpr250ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));

		Map<String, Object> comboParam = new HashMap<String, Object>();
		comboParam.put("COMP_CODE", loginVO.getCompCode());
		comboParam.put("TYPE", "DIV_PRSN");
		model.addAttribute("COMBO_DIV_PRSN",  baseCommonService.fnRecordCombo(comboParam));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;
		cdo = codeInfo.getCodeInfo("B084", "D");	//재고합산유형 : 창고 Cell 합산
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsSumTypeCell",cdo.getRefCode1());
		}else {
			model.addAttribute("gsSumTypeCell", "N");
		}

		return JSP_PATH + "bpr250ukrv";
	}
	/** 품목정보등록(통합)(코디 임시사용 추후 정규와 합칠것임)
	 *
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/base/s_bpr300ukrv_kodi.do", method = RequestMethod.GET)
	public String s_bpr300ukrv_kodi(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
		model.addAttribute("UseByDate",this.tlabCodeService.getCodeInfo(loginVO.getCompCode()).getCodeInfo("B073", "1").getRefCode1());
		//model.addAttribute("UseByDate",this.tlabCodeService.getCodeInfo(loginVO.getCompCode()).getCodeInfo("B108", "B005").getRefCode3());
		String precision = null;
		String formatWithPrecision = "0,000.";
		List<CodeDetailVO> configList = this.tlabCodeService.getCodeInfo(loginVO.getCompCode()).getCodeList("B108", "", false);
		for(CodeDetailVO map : configList)	{
			if("bpr100ukrv".equals(map.getRefCode1()))	{
				if("REIM".equals(map.getRefCode2()))	{
					precision = map.getRefCode3();

					int intPrecision = ObjUtils.parseInt(precision);
					for(int i=0; i<intPrecision; i++ )	{
						formatWithPrecision+="0";
					}
					model.addAttribute("REIM_Precision", map.getRefCode3());
					model.addAttribute("REIM_PrecisionFormat",formatWithPrecision);
				}
			}
		}
		if(precision == null)	{
			model.addAttribute("REIM_Precision", 2);
		}

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;
		cdo = codeInfo.getCodeInfo("B910", "Y");	//품목 모든 사업장 추가
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsItemAllDivAdd",cdo.getRefCode1());
		} else {
			model.addAttribute("gsItemAllDivAdd", "N");
		}
		
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

		return JSP_PATH + "s_bpr300ukrv_novis";
	}
	/** 품목정보등록(통합)
	 *
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/base/bpr300ukrv.do", method = RequestMethod.GET)
	public String bpr300ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
		model.addAttribute("UseByDate",this.tlabCodeService.getCodeInfo(loginVO.getCompCode()).getCodeInfo("B073", "1").getRefCode1());
		//model.addAttribute("UseByDate",this.tlabCodeService.getCodeInfo(loginVO.getCompCode()).getCodeInfo("B108", "B005").getRefCode3());
		String precision = null;
		String formatWithPrecision = "0,000.";
		List<CodeDetailVO> configList = this.tlabCodeService.getCodeInfo(loginVO.getCompCode()).getCodeList("B108", "", false);
		for(CodeDetailVO map : configList)	{
			if("bpr100ukrv".equals(map.getRefCode1()))	{
				if("REIM".equals(map.getRefCode2()))	{
					precision = map.getRefCode3();

					int intPrecision = ObjUtils.parseInt(precision);
					for(int i=0; i<intPrecision; i++ )	{
						formatWithPrecision+="0";
					}
					model.addAttribute("REIM_Precision", map.getRefCode3());
					model.addAttribute("REIM_PrecisionFormat",formatWithPrecision);
				}
			}
		}
		if(precision == null)	{
			model.addAttribute("REIM_Precision", 2);
		}

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;
		cdo = codeInfo.getCodeInfo("B910", "Y");	//품목 모든 사업장 추가
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsItemAllDivAdd",cdo.getRefCode1());
		}else {
			model.addAttribute("gsItemAllDivAdd", "N");
		}

		cdo = codeInfo.getCodeInfo("B256", "1");	//품목코드 자동채번 필드셋
		if(ObjUtils.isNotEmpty(cdo)){
			if(ObjUtils.isNotEmpty(cdo.getCodeName())){
				model.addAttribute("gsAutoItemCode", "./itemCode_" + cdo.getCodeName().toUpperCase() + ".jsp");
			}else{
				model.addAttribute("gsAutoItemCode", "./itemCode_STANDARD.jsp");
			}
		}else {
			model.addAttribute("gsAutoItemCode", "./itemCode_STANDARD.jsp");
		}

		/**
		 * 2021.08.20 맥아이씨에스 전용 JSP 호출은 코드값(B259) 에서 설정
		 */
		cdo = codeInfo.getCodeInfo("B256", "1");	//추가항목 필드셋
		if(ObjUtils.isNotEmpty(cdo)){
			if(ObjUtils.isNotEmpty(cdo.getCodeName())){
				model.addAttribute("gsStieAdditems", "./addItems_" + cdo.getCodeName().toUpperCase() + ".jsp");
			}else{
				model.addAttribute("gsStieAdditems", "./addItems_STANDARD.jsp");
			}
		}else {
			model.addAttribute("gsStieAdditems", "./addItems_STANDARD.jsp");
		}

		//20191218 추가
		cdo = codeInfo.getCodeInfo("B259", "1");	//추가항목 필드셋
		if(ObjUtils.isNotEmpty(cdo)){
			model.addAttribute("gsStieAdditems", "./addItems_" + cdo.getCodeName().toUpperCase() + ".jsp"); // 20210820 멕아이씨에스 전용 JSP 호출에도 사용 
			model.addAttribute("gsSetField", cdo.getCodeName().toUpperCase());
		}
		
		cdo = codeInfo.getCodeInfo("B256", "1");	//추가항목 필드셋:품목코드자동채번
		if(ObjUtils.isNotEmpty(cdo)){
			model.addAttribute("gsSetFieldItemcode", cdo.getCodeName().toUpperCase());
		}		

		//20191210 추가
		model.addAttribute("COMBO_WH_CELL_LIST", comboService.getWhCellList(param));
		
		//20210705 추가
		
		List<ComboItemModel> costPool =  bpr300ukrvService.selectListCbm700(param);
		if(ObjUtils.isNotEmpty(costPool))	{
			model.addAttribute("COST_POOL", costPool);
		} else {
			costPool = new ArrayList<ComboItemModel>();
			model.addAttribute("COST_POOL", costPool);
		}

		//model.addAttribute("COST_POOL", bpr300ukrvService.selectListCbm700(param));
		return JSP_PATH + "bpr300ukrv";
	}
	/**
	 * 품목정보등록(통합) - 품목 관련 파일 다운로드
	 * @param fid
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/fileman/downloadItemInfoImage/{fid}" )
	public ModelAndView downloader( @PathVariable( "fid" ) String fid, LoginVO user ) throws Exception {
		logger.debug("inlineViewer fid:{}", fid);
		FileDownloadInfo fdi = bpr300ukrvService.getFileInfo(user, fid);
		if (fdi != null) {
			fdi.setInLineYn(false);
		}
		return ViewHelper.getFileDownloadView(fdi);
	}

	/** 품목정보 이력조회
	 *
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/base/bpr290skrv.do", method = RequestMethod.GET)
	public String bpr290skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
		
		model.addAttribute("COMBO_WH_CELL_LIST", comboService.getWhCellList(param));

		return JSP_PATH + "bpr290skrv";
	}

	@RequestMapping(value = "/base/bpr530skrv.do")
	public String bpr530skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		Map<String, Object> comboParam = new HashMap<String, Object>();
		comboParam.put("COMP_CODE", loginVO.getCompCode());
		comboParam.put("TYPE", "DIV_PRSN");
		model.addAttribute("COMBO_DIV_PRSN",  baseCommonService.fnRecordCombo(comboParam));


		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;
		//BOM PATH 관리여부(B082)
		List<CodeDetailVO> gsBomPathYN = codeInfo.getCodeList("B082", "", false);
		for(CodeDetailVO map : gsBomPathYN) {
			if("Y".equals(map.getRefCode1())) {
				model.addAttribute("gsBomPathYN", map.getCodeNo());
			}
		}
		//대체품목 등록여부(B081)
		List<CodeDetailVO> gsExchgRegYN = codeInfo.getCodeList("B081", "", false);
		for(CodeDetailVO map : gsExchgRegYN)	{
			if("Y".equals(map.getRefCode1())) {
				model.addAttribute("gsExchgRegYN", map.getCodeNo());
			}
		}
		return JSP_PATH + "bpr530skrv";
	}

	/**
	 * 집약전개 조회 (bpr540skrv) - 20200717 신규 프로그램 등록
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/base/bpr540skrv.do")
	public String bpr540skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		Map<String, Object> comboParam = new HashMap<String, Object>();
		comboParam.put("COMP_CODE", loginVO.getCompCode());
		comboParam.put("TYPE", "DIV_PRSN");
		model.addAttribute("COMBO_DIV_PRSN",  baseCommonService.fnRecordCombo(comboParam));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;
		//BOM PATH 관리여부(B082)
		List<CodeDetailVO> gsBomPathYN = codeInfo.getCodeList("B082", "", false);
		for(CodeDetailVO map : gsBomPathYN) {
			if("Y".equals(map.getRefCode1())) {
				model.addAttribute("gsBomPathYN", map.getCodeNo());
			}
		}
		//대체품목 등록여부(B081)
		List<CodeDetailVO> gsExchgRegYN = codeInfo.getCodeList("B081", "", false);
		for(CodeDetailVO map : gsExchgRegYN)	{
			if("Y".equals(map.getRefCode1())) {
				model.addAttribute("gsExchgRegYN", map.getCodeNo());
			}
		}
		return JSP_PATH + "bpr540skrv";
	}

	@RequestMapping(value = "/base/bpr550skrv.do", method = RequestMethod.GET)
	public String bpr550skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));

		Map<String, Object> comboParam = new HashMap<String, Object>();
		comboParam.put("COMP_CODE", loginVO.getCompCode());
		comboParam.put("TYPE", "DIV_PRSN");
		model.addAttribute("COMBO_DIV_PRSN",  baseCommonService.fnRecordCombo(comboParam));

		return JSP_PATH + "bpr550skrv";
	}

	@RequestMapping(value = "/base/bpr580skrv.do")
	public String bpr580skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		Map<String, Object> comboParam = new HashMap<String, Object>();
		comboParam.put("COMP_CODE", loginVO.getCompCode());
		comboParam.put("TYPE", "DIV_PRSN");
		model.addAttribute("COMBO_DIV_PRSN",  baseCommonService.fnRecordCombo(comboParam));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;
		//BOM PATH 관리여부(B082)
		List<CodeDetailVO> gsBomPathYN = codeInfo.getCodeList("B082", "", false);
		for(CodeDetailVO map : gsBomPathYN)	{
			if("Y".equals(map.getRefCode1()))	{
				model.addAttribute("gsBomPathYN", map.getCodeNo());
			}
		}
		//대체품목 등록여부(B081)
		List<CodeDetailVO> gsExchgRegYN = codeInfo.getCodeList("B081", "", false);
		for(CodeDetailVO map : gsExchgRegYN)	{
			if("Y".equals(map.getRefCode1()))	{
				model.addAttribute("gsExchgRegYN", map.getCodeNo());
			}
		}
		return JSP_PATH + "bpr580skrv";
	}

	@RequestMapping(value = "/base/bpr581skrv.do")
	public String bpr581skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		Map<String, Object> comboParam = new HashMap<String, Object>();
		comboParam.put("COMP_CODE", loginVO.getCompCode());
		comboParam.put("TYPE", "DIV_PRSN");
		model.addAttribute("COMBO_DIV_PRSN",  baseCommonService.fnRecordCombo(comboParam));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;
		//BOM PATH 관리여부(B082)
		List<CodeDetailVO> gsBomPathYN = codeInfo.getCodeList("B082", "", false);
		for(CodeDetailVO map : gsBomPathYN)	{
			if("Y".equals(map.getRefCode1()))	{
				model.addAttribute("gsBomPathYN", map.getCodeNo());
			}
		}
		//대체품목 등록여부(B081)
		List<CodeDetailVO> gsExchgRegYN = codeInfo.getCodeList("B081", "", false);
		for(CodeDetailVO map : gsExchgRegYN)	{
			if("Y".equals(map.getRefCode1()))	{
				model.addAttribute("gsExchgRegYN", map.getCodeNo());
			}
		}
		return JSP_PATH + "bpr581skrv";
	}

	@RequestMapping(value = "/base/bpr585skrv.do")
	public String bpr585skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		Map<String, Object> comboParam = new HashMap<String, Object>();
		comboParam.put("COMP_CODE", loginVO.getCompCode());
		comboParam.put("TYPE", "DIV_PRSN");
		model.addAttribute("COMBO_DIV_PRSN",  baseCommonService.fnRecordCombo(comboParam));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;
		//BOM PATH 관리여부(B082)
		List<CodeDetailVO> gsBomPathYN = codeInfo.getCodeList("B082", "", false);
		for(CodeDetailVO map : gsBomPathYN) {
			if("Y".equals(map.getRefCode1())) {
				model.addAttribute("gsBomPathYN", map.getCodeNo());
			}
		}
		//대체품목 등록여부(B081)
		List<CodeDetailVO> gsExchgRegYN = codeInfo.getCodeList("B081", "", false);
		for(CodeDetailVO map : gsExchgRegYN)	{
			if("Y".equals(map.getRefCode1())) {
				model.addAttribute("gsExchgRegYN", map.getCodeNo());
			}
		}

		return JSP_PATH + "bpr585skrv";
	}

	@RequestMapping(value = "/base/bpr590skrv.do", method = RequestMethod.GET)
	public String bpr590skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));

		Map<String, Object> comboParam = new HashMap<String, Object>();
		comboParam.put("COMP_CODE", loginVO.getCompCode());
		comboParam.put("TYPE", "DIV_PRSN");
		model.addAttribute("COMBO_DIV_PRSN",  baseCommonService.fnRecordCombo(comboParam));

		return JSP_PATH + "bpr590skrv";
	}

	@RequestMapping(value = "/base/bpr255ukrv.do", method = RequestMethod.GET)
	public String bpr255ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));

		Map<String, Object> comboParam = new HashMap<String, Object>();
		comboParam.put("COMP_CODE", loginVO.getCompCode());
		comboParam.put("TYPE", "DIV_PRSN");
		model.addAttribute("COMBO_DIV_PRSN",  baseCommonService.fnRecordCombo(comboParam));

		return JSP_PATH + "bpr255ukrv";
	}
	@RequestMapping(value = "/base/bpr120ukrv.do", method = RequestMethod.GET)
	public String bpr120ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));

		Map<String, Object> comboParam = new HashMap<String, Object>();
		comboParam.put("COMP_CODE", loginVO.getCompCode());
		comboParam.put("TYPE", "DIV_PRSN");
		model.addAttribute("COMBO_DIV_PRSN",  baseCommonService.fnRecordCombo(comboParam));

		return JSP_PATH + "bpr120ukrv";
	}


	@RequestMapping(value = "/base/bpr560ukrv.do", method = RequestMethod.GET)
	public String bpr560ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));

		Map<String, Object> comboParam = new HashMap<String, Object>();
		comboParam.put("COMP_CODE", loginVO.getCompCode());
		comboParam.put("TYPE", "DIV_PRSN");
		model.addAttribute("COMBO_DIV_PRSN",  baseCommonService.fnRecordCombo(comboParam));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;
		//BOM PATH 관리여부(B082)
		List<CodeDetailVO> gsBomPathYN = codeInfo.getCodeList("B082", "", false);
		for(CodeDetailVO map : gsBomPathYN)	{
			if("Y".equals(map.getRefCode1()))	{
				model.addAttribute("gsBomPathYN", map.getCodeNo());
			}
		}
		//대체품목 등록여부(B081)
		List<CodeDetailVO> gsExchgRegYN = codeInfo.getCodeList("B081", "", false);
		for(CodeDetailVO map : gsExchgRegYN)	{
			if("Y".equals(map.getRefCode1()))	{
				model.addAttribute("gsExchgRegYN", map.getCodeNo());
			}
		}
		//20190607 SAMPLE코드 사용여부(B912.REF_CODE1), 품목계정(B912.REF_CODE2)
		cdo = codeInfo.getCodeInfo("B912", "1");
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsSampleCodeYn"	, cdo.getRefCode1());
			model.addAttribute("gsItemAccount"	, cdo.getRefCode2());
		} else {
			model.addAttribute("gsSampleCodeYn"	, "N");
			model.addAttribute("gsItemAccount"	, "*");
		}
		//20190617 자품목 순번증가 단위 설정(B913)
		cdo = codeInfo.getCodeInfo("B913", "1");
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsSeqIncUit", cdo.getRefCode1());
		} else {
			model.addAttribute("gsSeqIncUit", "1");
		}
		//20201207 추가
		cdo = codeInfo.getCodeInfo("B256", "1");	//추가항목 필드셋:
		if(ObjUtils.isNotEmpty(cdo)){
			model.addAttribute("gsSetField", cdo.getCodeName().toUpperCase());
		}
		return JSP_PATH + "bpr560ukrv";
	}

	@RequestMapping(value = "/base/bpr501ukrv.do", method = RequestMethod.GET)
	public String bpr501ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;
		//대체품목 등록여부(B081)
		List<CodeDetailVO> gsExchgRegYN = codeInfo.getCodeList("B081", "", false);
		for(CodeDetailVO map : gsExchgRegYN)	{
			if("Y".equals(map.getRefCode1())) {
				model.addAttribute("gsExchgRegYN", map.getCodeNo());
			}
		}
		//BOM PATH 관리여부(B082)
		List<CodeDetailVO> gsBomPathYN = codeInfo.getCodeList("B082", "", false);
		for(CodeDetailVO map : gsBomPathYN) {
			if("Y".equals(map.getRefCode1())) {
				model.addAttribute("gsBomPathYN", map.getCodeNo());
			}
		}

		return JSP_PATH + "bpr501ukrv";
	}

	@RequestMapping(value = "/base/bpr570ukrv.do", method = RequestMethod.GET)
	public String bpr570ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {


		return JSP_PATH + "bpr570ukrv";
	}


	@RequestMapping(value = "/base/bpr800ukrv.do", method = RequestMethod.GET)
	public String bpr800ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));

		Map<String, Object> comboParam = new HashMap<String, Object>();
		comboParam.put("COMP_CODE", loginVO.getCompCode());
		comboParam.put("TYPE", "DIV_PRSN");
		model.addAttribute("COMBO_DIV_PRSN",  baseCommonService.fnRecordCombo(comboParam));

		return JSP_PATH + "bpr800ukrv";
	}
	@RequestMapping(value = "/base/bpr700ukrv.do", method = RequestMethod.GET)
	public String bpr700ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));

		Map<String, Object> comboParam = new HashMap<String, Object>();
		comboParam.put("COMP_CODE", loginVO.getCompCode());
		comboParam.put("TYPE", "DIV_PRSN");
		model.addAttribute("COMBO_DIV_PRSN",  baseCommonService.fnRecordCombo(comboParam));

		return JSP_PATH + "bpr700ukrv";
	}
	@RequestMapping(value = "/base/bpr900ukrv.do", method = RequestMethod.GET)
	public String bpr900ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));

		Map<String, Object> comboParam = new HashMap<String, Object>();
		comboParam.put("COMP_CODE", loginVO.getCompCode());
		comboParam.put("TYPE", "DIV_PRSN");
		model.addAttribute("COMBO_DIV_PRSN",  baseCommonService.fnRecordCombo(comboParam));

		return JSP_PATH + "bpr900ukrv";
	}

	@RequestMapping(value = "/base/modern/bpr100.do" , method = {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView selectItemModern(HttpServletRequest req, ModelMap model, LoginVO login) throws Exception {
		Map<String, Object> param = new HashMap();
		param.put("S_COMP_CODE",login.getCompCode());
		List<Map> rList =  bpr100ukrvService.selectDetailList2(param, login);

		return ViewHelper.getJsonView(rList);
	}
	@RequestMapping(value = "/base/bpr620ukrv.do", method = RequestMethod.GET)
	public String bpr620ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {

		return JSP_PATH + "bpr620ukrv";
	}
	/**
	 * 제품바코드 대,소   및 TR 라벨 출력 관련
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/base/bpr810rkrv.do", method = RequestMethod.GET)
	public String bpr810rkrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));
		return JSP_PATH + "bpr810rkrv";
	}
	/**
	 * 제품바코드 BOX 라벨 출력 관련
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/base/bpr811rkrv.do", method = RequestMethod.GET)
	public String bpr811rkrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));
		return JSP_PATH + "bpr811rkrv";
	}
	/**
	 * PCB 라벨 출력 관련
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/base/bpr813rkrv.do", method = RequestMethod.GET)
	public String bpr813rkrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		return JSP_PATH + "bpr813rkrv";
	}
	/**
	 * 원자재 라벨 출력 관련
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/base/bpr814rkrv.do", method = RequestMethod.GET)
	public String bpr814rkrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		model.addAttribute("COMBO_WS_LIST", comboService.getWhList(param));
		return JSP_PATH + "bpr814rkrv";
	}
	@ResponseBody
	@RequestMapping(value = "/barcode/bpr810rkrvBarcodePrint.do", method = {RequestMethod.GET, RequestMethod.POST})
//	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
//	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "bpr")
	public /*ModelAndView*/String bpr810rkrvBarcodePrint(ExtHtttprequestParam _req, HttpServletResponse response) throws Exception{


	 //controller 쪽 롤백 문제로 서비스로 옮기는 작업 진행

		Map<String, Object> param = _req.getParameterMap();

		String SuccessFlag = "N";


//Connection conn = null;
		try{

		//	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
		//	conn = DriverManager.getConnection("jdbc:sqlserver://192.168.1.90:7304;databaseName=OMEGAPLUS_YG;user=unilite5;password=;");
		//	conn.setAutoCommit(false);

			Map<String, Object> tempParam1 = new HashMap<String, Object>();

			tempParam1.put("COMP_CODE", param.get("S_COMP_CODE"));
			tempParam1.put("DIV_CODE", param.get("DIV_CODE"));
			tempParam1.put("S_USER_ID", param.get("S_USER_ID"));

			bpr810rkrvService.insertSerialNo(tempParam1);




			Map tempMap1 = bpr810rkrvService.checkSerialNo(param);


		  //채번테이블에 마지막으로 저장된 시리얼번호
			int readSerialNo = 0;
			readSerialNo = Integer.parseInt(ObjUtils.getSafeString(tempMap1.get("SERIAL_NO")));
		  //채번테이블에 저장된 오늘날짜
			String today = ObjUtils.getSafeString(tempMap1.get("BASIS_DATE"));


			//채번테이블에 마지막으로 저장된 시리얼번호 + 발행매수
			int saveSerialNo = 0;
			saveSerialNo = readSerialNo + Integer.parseInt(ObjUtils.getSafeString(param.get("CNT")));



			String ZPLString = "";

			String ipAdr = "192.168.1.40";
			int port = 6101;

			int cnt = 0;


			cnt = ObjUtils.parseInt(param.get("CNT"));

			String itemName = ObjUtils.getSafeString(param.get("ITEM_NAME"));
			String itemCode = ObjUtils.getSafeString(param.get("ITEM_CODE"));
			String spec = ObjUtils.getSafeString(param.get("SPEC"));
			String type = ObjUtils.getSafeString(param.get("TYPE"));

			String lotNo = today.substring(2,8);

			String DataMatrix = "";

		  //임시로 SUPPLY_TYPE 씀 바꿔야함
			String ksMarkKinds = ObjUtils.getSafeString(param.get("SUPPLY_TYPE"));

			/**
			 * BAUTONOT(채번테이블)  UPDATE
			 * LAST_SEQ 마지막 시리얼번호
			 */
			tempParam1.put("LAST_SEQ", saveSerialNo);
			bpr810rkrvService.updateSerialNo(tempParam1);


			/**
			 * 재발행이 아닐시
			 * 해당 PMR110T  UPDATE
			 * FR_SERIAL_NO 시리얼(FR)
			 * TO_SERIAL_NO 시리얼(TO)
			 * TEMPC_01	 출력여부
			 *
			 */
			int frSerialNo = 0;

			frSerialNo = readSerialNo + 1;


			String frSerialNoFormatChange =String.format("%05d",frSerialNo);
			String toSerialNoFormaChanget =String.format("%05d",saveSerialNo);


			Map<String, Object> tempParam2 = new HashMap<String, Object>();

			tempParam2.put("COMP_CODE", param.get("S_COMP_CODE"));
			tempParam2.put("DIV_CODE", param.get("DIV_CODE"));
			tempParam2.put("S_USER_ID", param.get("S_USER_ID"));
			tempParam2.put("PRODT_NUM", param.get("PRODT_NUM"));


			tempParam2.put("FR_SERIAL_NO", frSerialNoFormatChange);
			tempParam2.put("TO_SERIAL_NO", toSerialNoFormaChanget);
			tempParam2.put("PRINT_YN", "Y");

			bpr810rkrvService.updatePMR110T(tempParam2);



			Socket clientSocket=new Socket(ipAdr,port);

			for(int i=0; i<cnt; i++) {
				DataMatrix = itemCode + lotNo + String.format("%05d",readSerialNo+1+i);

				if(ObjUtils.getSafeString(param.get("SIZE")).equals("1")){	  // 대
					ZPLString= "^XA";
					ZPLString  +="^SEE:UHANGUL.DAT^FS" ;

					ZPLString +="^CW1,E:corefont.TTF^CI26^FS";//돋음

					ZPLString +="^FO75,50^A1N,33,33^FDItem^FS";

					ZPLString +="^FO150,50^A1N,30,30^FD"+itemName+"^FS";

					ZPLString +="^FO75,80^A1N,33,33^FDCode^FS";

					ZPLString +="^FO150,80^A1N,30,30^FD"+itemCode+"^FS";

					ZPLString +="^FO75,110^A1N,33,33^FDSpec/Type^FS";

					ZPLString +="^FO200,110^A1N,30,30^FD"+spec+"/"+type+ "^FS";

		//			ZPLString +="^FO75,140^A1N,33,33^FDToday^FS";
		//
		//			ZPLString +="^FO150,140^A1N,30,30^FD"+today+"^FS";

					ZPLString +="^FO75,140^A1N,33,33^FDLotNo^FS";

					ZPLString +="^FO150,140^A1N,30,30^FD"+lotNo+"^FS";


					ZPLString +="^FO75,200^BXN,4,200,,,,^FD"+DataMatrix+"^FS";

		//			ZPLString +="^FO75,190^BXN,4,200,,,,^FD"+lotNo+"^FS";


					ZPLString +="^XZ";
				}else{		  //소
					ZPLString= "^XA";
					ZPLString  +="^SEE:UHANGUL.DAT^FS" ;

		//			ZPLString4 +="^CW1,E:KFONT3.FNT^CI26^FS";
					ZPLString +="^CW1,E:corefont.TTF^CI26^FS";//돋음

					ZPLString +="^FO75,50^A1N,22,22^FDItem^FS";

					ZPLString +="^FO150,50^A1N,20,20^FD"+itemName+"^FS";

					ZPLString +="^FO75,80^A1N,22,22^FDCode^FS";

					ZPLString +="^FO150,80^A1N,20,20^FD"+itemCode+"^FS";

					ZPLString +="^FO75,110^A1N,22,22^FDSpec/Type^FS";

					ZPLString +="^FO150,110^A1N,20,20^FD"+spec+"/"+type+"^FS";

		//			ZPLString +="^FO75,140^A1N,22,22^FDToday^FS";
		//
		//			ZPLString +="^FO150,140^A1N,20,20^FD"+today+"^FS";

					ZPLString +="^FO75,140^A1N,22,22^FDLotNo^FS";

					ZPLString +="^FO200,140^A1N,20,20^FD"+lotNo+"^FS";


					ZPLString +="^FO75,200^BXN,4,200,,,,^FD"+DataMatrix+"^FS";

		//			ZPLString +="^FO75,190^BXN,4,200,,,,^FD"+lotNo+"^FS";

					ZPLString +="^XZ";
				}





				DataOutputStream outToServer = new DataOutputStream(clientSocket.getOutputStream());
				byte[] dataTest = ZPLString.getBytes("EUC-KR");
				outToServer.write(dataTest);
			}



			clientSocket.close();

		//	conn.commit();

		////	param.put("IP_ADR", ipAdr);
		////	param.put("PORT", port);
		////	param.put("ZPL_STR", ZPLString);
		//
		////	BarcodePrintUtils.barcodePrint(param);




		//
		//	/**
		//	 * BAUTONOT(채번테이블)  UPDATE
		//	 * LAST_SEQ 마지막 시리얼번호
		//	 */
		//	tempParam1.put("LAST_SEQ", saveSerialNo);
		//	bpr810rkrvService.updateSerialNo(tempParam1);
		//
		//
		//	/**
		//	 * 재발행이 아닐시
		//	 * 해당 PMR110T  UPDATE
		//	 * FR_SERIAL_NO 시리얼(FR)
		//	 * TO_SERIAL_NO 시리얼(TO)
		//	 * TEMPC_01	 출력여부
		//	 *
		//	 */
		//	int frSerialNo = 0;
		//
		//	frSerialNo = readSerialNo + 1;
		//
		//
		//	String frSerialNoFormatChange =String.format("%05d",frSerialNo);
		//	String toSerialNoFormaChanget =String.format("%05d",saveSerialNo);
		//
		//
		//	Map<String, Object> tempParam2 = new HashMap<String, Object>();
		//
		//	tempParam2.put("COMP_CODE", param.get("S_COMP_CODE1"));
		//	tempParam2.put("DIV_CODE", param.get("DIV_CODE"));
		//	tempParam2.put("S_USER_ID", param.get("S_USER_ID"));
		//	tempParam2.put("PRODT_NUM", param.get("PRODT_NUM"));
		//
		//
		//	tempParam2.put("FR_SERIAL_NO", frSerialNoFormatChange);
		//	tempParam2.put("TO_SERIAL_NO", toSerialNoFormaChanget);
		//	tempParam2.put("PRINT_YN", "Y");
		//
		//	bpr810rkrvService.updatePMR110T(tempParam2);
		//
		/*

				String receiveParam = "";
				if(ObjUtils.isNotEmpty(param.get("TEST_TEXT"))){

					receiveParam = ObjUtils.getSafeString(param.get("TEST_TEXT"));
				}else{
					receiveParam = "No value";
				}



				int cntParam = 0;
				if(ObjUtils.isNotEmpty(param.get("CNT"))){

					cntParam = Integer.parseInt(ObjUtils.getSafeString(param.get("CNT")));
				}else{
					cntParam = 1;
				}

		//List<Map<String, Object>> allDatas = bpr810rkrvService.barCodeDataSelect(param);

				int tempIndex = 0;

		//		String ZPLString3 = "";

				String itemName = "테스트";
				String itemCode = "A111";
				String spec = "테스트규격";
				String today = "20180417";

				String lotNo = "L2222";




				Socket clientSocket=new Socket("192.168.1.40",6101);

				for(int i=0; i<cntParam; i++) {

		//			itemName = ObjUtils.getSafeString(allDatas.get(0).get("ITEM_NAME"));
		//			itemCode = ObjUtils.getSafeString(allDatas.get(0).get("ITEM_CODE"));
		//			spec = ObjUtils.getSafeString(allDatas.get(0).get("SPEC"));
		//			today = ObjUtils.getSafeString(allDatas.get(0).get("TODAY"));

					lotNo = itemCode + today.substring(2,8);

					lotNo =lotNo+ String.format("%03d",i+1);


							ZPLString4= "^XA";
							ZPLString4  +="^SEE:UHANGUL.DAT^FS" ;

		//					ZPLString4 +="^CW1,E:KFONT3.FNT^CI26^FS";
							ZPLString4 +="^CW1,E:corefont.TTF^CI26^FS";//돋음


							ZPLString4 +="^FO75,50^A1N,22,22^FDItem^FS";

							ZPLString4 +="^FO150,50^A1N,20,20^FD"+itemName+"^FS";

							ZPLString4 +="^FO75,80^A1N,22,22^FDCode^FS";

							ZPLString4 +="^FO150,80^A1N,20,20^FD"+itemCode+"^FS";

							ZPLString4 +="^FO75,110^A1N,22,22^FDSpec^FS";

							ZPLString4 +="^FO150,110^A1N,20,20^FD"+spec+"^FS";

							ZPLString4 +="^FO75,140^A1N,22,22^FDToday^FS";

							ZPLString4 +="^FO150,140^A1N,20,20^FD"+today+"^FS";

		//					ZPLString4 +="^FO50,150^A1N,20,20^FDLotNo		  "+lotNo+"^FS";

							ZPLString4 +="^FO75,190^BXN,4,200,,,,^FD"+lotNo+"^FS";


							ZPLString4 +="^XZ";





					logger.debug("@@@@@@@@@@@@@@테스트@@@@@@@@@@@@@:" +ZPLString4);




					DataOutputStream outToServer = new DataOutputStream(clientSocket.getOutputStream());

					byte[] dataTest = ZPLString4.getBytes("EUC-KR");

					outToServer.write(dataTest);

				}


				clientSocket.close();
				 */
						SuccessFlag ="Y";
					}
		//			catch (Exception ex)
		//			{
		//				SuccessFlag = "N";
		//				// Catch Exception
		//			}
		catch(SQLException sqle){
			logger.debug("@@@@@@@@@@@@@@테스트@@@@@@@@@@@@@:" +"11111111111111111111111");
		}catch(DataAccessException dae){
			logger.debug("@@@@@@@@@@@@@@테스트@@@@@@@@@@@@@:" +"222222222222222222222222222");
		//	conn.rollback();
		}catch(Exception e){
			SuccessFlag = "N";
			logger.debug("@@@@@@@@@@@@@@테스트@@@@@@@@@@@@@:" +"3333333333333333333333");
		}

//return ViewHelper.getJsonView(SuccessFlag);
		return SuccessFlag;
	}

	/**
	 * 제조 BOM ExcelDownload
	 * @param request
	 * @param response
	 * @param locale
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/base/bpr580skrvdownloadExcel.do", method = RequestMethod.POST )
	public ModelAndView bpr580skrvDownloadExcel( HttpServletRequest request, HttpServletResponse response, Locale locale,
			ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp ) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();

		String data = _req.getP("xmlData");
		String pgmId = _req.getP("pgmId");
		String fileName = _req.getP("fileName");
		//String dataParam = _req.getP("data");

		ObjectMapper mapper = new ObjectMapper();
		Map<String, Object> dataParam = mapper.readValue( ObjUtils.getSafeString(_req.getP("data")),
				new TypeReference<Map<String, Object>>(){});
		dataParam.put("S_COMP_CODE", loginVO.getCompCode());
		dataParam.put("S_USER_ID", loginVO.getUserID());
/*	  MethodInfo methodInfo = MethodInfoCache.INSTANCE.get(_req.getP("extAction"), _req.getP("extMethod"));
		Map<String, Object> paramMap = _req.getParameterMap();
		Map<String, Object> cMap = new HashMap<String, Object>();
		for (Map.Entry<String, Object> entry : paramMap.entrySet()) {
			if (ObjUtils.isNotEmpty(entry.getValue())) {
				cMap.put(entry.getKey(), entry.getValue());
			} else {
				cMap.put(entry.getKey(), "");
			}
		}
		Object[] paramArr = prepareParameters(request, response, locale, methodInfo, _req);

		List paramList = methodInfo.getParameters();
		logger.debug("################	 methodInfo.getParameters : " + paramList.get(0));

		Object result = ExtDirectSpringUtil.invoke(context, _req.getP("extAction"), methodInfo, paramArr);

		List<Map<String, Object>> dataList = (List<Map<String, Object>>)result;
		*/
		UniTreeNode dataList =  bpr580skrvService.selectList(dataParam, loginVO);

		SXSSFWorkbook wb = bpr580skrvService.genWorkBook(data, pgmId, param, dataList, loginVO);

		/*
		 * FileDownloadInfo fInfo = new FileDownloadInfo(ConfigUtil.getUploadBasePath("ExcelDownload"), pgmId+".xlsx");
		 * FileOutputStream fos = new FileOutputStream(fInfo.getFile()); wb.write(fos); fos.flush(); fos.close(); wb = null;
		 */
		logger.debug("################	fileName : " + fileName);
		return ViewHelper.getExcelDownloadView(wb, ObjUtils.nvl(fileName, pgmId));
		// return ViewHelper.getFileDownloadView(fInfo);
	}

	/**
	 * 제조 BOM ExcelDownload
	 * @param request
	 * @param response
	 * @param locale
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/base/bpr581skrvdownloadExcel.do", method = RequestMethod.POST )
	public ModelAndView bpr581skrvDownloadExcel( HttpServletRequest request, HttpServletResponse response, Locale locale,
			ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp ) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();

		String data = _req.getP("xmlData");
		String pgmId = _req.getP("pgmId");
		String fileName = _req.getP("fileName");
		//String dataParam = _req.getP("data");

		ObjectMapper mapper = new ObjectMapper();
		Map<String, Object> dataParam = mapper.readValue( ObjUtils.getSafeString(_req.getP("data")),
				new TypeReference<Map<String, Object>>(){});
		dataParam.put("S_COMP_CODE", loginVO.getCompCode());
		dataParam.put("S_USER_ID", loginVO.getUserID());
/*	  MethodInfo methodInfo = MethodInfoCache.INSTANCE.get(_req.getP("extAction"), _req.getP("extMethod"));
		Map<String, Object> paramMap = _req.getParameterMap();
		Map<String, Object> cMap = new HashMap<String, Object>();
		for (Map.Entry<String, Object> entry : paramMap.entrySet()) {
			if (ObjUtils.isNotEmpty(entry.getValue())) {
				cMap.put(entry.getKey(), entry.getValue());
			} else {
				cMap.put(entry.getKey(), "");
			}
		}
		Object[] paramArr = prepareParameters(request, response, locale, methodInfo, _req);

		List paramList = methodInfo.getParameters();
		logger.debug("################	 methodInfo.getParameters : " + paramList.get(0));

		Object result = ExtDirectSpringUtil.invoke(context, _req.getP("extAction"), methodInfo, paramArr);

		List<Map<String, Object>> dataList = (List<Map<String, Object>>)result;
		*/
		UniTreeNode dataList =  bpr581skrvService.selectList(dataParam, loginVO);

		SXSSFWorkbook wb = bpr581skrvService.genWorkBook(data, pgmId, param, dataList, loginVO);

		/*
		 * FileDownloadInfo fInfo = new FileDownloadInfo(ConfigUtil.getUploadBasePath("ExcelDownload"), pgmId+".xlsx");
		 * FileOutputStream fos = new FileOutputStream(fInfo.getFile()); wb.write(fos); fos.flush(); fos.close(); wb = null;
		 */
		logger.debug("################	fileName : " + fileName);
		return ViewHelper.getExcelDownloadView(wb, ObjUtils.nvl(fileName, pgmId));
		// return ViewHelper.getFileDownloadView(fInfo);
	}

	/**
	 * 제조 BOM ExcelDownload 파리메터
	 * @param request
	 * @param response
	 * @param locale
	 * @param methodInfo
	 * @param _req
	 * @return
	 * @throws Exception
	 *//*
	private Object[] prepareParameters( HttpServletRequest request, HttpServletResponse response, Locale locale,
			MethodInfo methodInfo, ExtHtttprequestParam _req ) throws Exception {
		List<ParameterInfo> methodParameters = methodInfo.getParameters();
		Object[] parameters = null;
		if (!methodParameters.isEmpty()) {
			parameters = new Object[methodParameters.size()];

			for (int paramIndex = 0; paramIndex < methodParameters.size(); paramIndex++) {
				ParameterInfo methodParameter = methodParameters.get(paramIndex);

				if (methodParameter.isSupportedParameter()) {
					parameters[paramIndex] = SupportedParameters.resolveParameter(methodParameter.getType(), request, response,
							locale);
					logger.debug("############  parameters isSupportedParameter : "
							+ ObjUtils.getSafeString(parameters[paramIndex]));
				} else if (methodParameter.isHasRequestHeaderAnnotation()) {
					parameters[paramIndex] = parametersResolver.resolveRequestHeader(request, methodParameter);
					logger.debug("############  parameters isHasRequestHeaderAnnotation : "
							+ ObjUtils.getSafeString(parameters[paramIndex]));
				} else {
					Map<String, Object> cMap = new HashMap<String, Object>();
					String jsonParam = _req.getParameter("data");
					ObjectMapper mapper = new ObjectMapper();
					Map<String, Object> paramMap = mapper.readValue(ObjUtils.getSafeString(jsonParam), HashMap.class);
					for (Map.Entry<String, Object> entry : paramMap.entrySet()) {
						if (ObjUtils.isNotEmpty(entry.getValue())) {
							cMap.put(entry.getKey(), entry.getValue());
						} else {
							cMap.put(entry.getKey(), "");
						}

					}

					Map<String, Object> s_paramMap = _req.getParameterMap();
					for (Map.Entry<String, Object> entry : s_paramMap.entrySet()) {
						if (ObjUtils.isNotEmpty(entry.getValue())) {
							if (!"xmlData".equals(entry.getKey()) && !"data".equals(entry.getKey())) {
								cMap.put(entry.getKey(), entry.getValue());
							}
						} else {
							cMap.put(entry.getKey(), "");
						}

					}
					parameters[paramIndex] = cMap;
					logger.debug("################################   parameters[" + paramIndex + "] : " + parameters[paramIndex]);
					logger.debug("################################   cMap :" + ObjUtils.toJsonStr(cMap));
					logger.debug("################################   cMap.get(POS_CODE) :" + cMap.get("POS_CODE"));

					// parameters[paramIndex] = parametersResolver.resolveRequestParam(request, null, methodParameter);
					// logger.debug("############  parameters else : "+ObjUtils.getSafeString(parameters[paramIndex]));
				}

			}
		}

		return parameters;
	}*/
	/**
	 * 품목 라벨출력 관련
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/base/bpr300rkrv.do", method = RequestMethod.GET)
	public String bpr300rkrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());

		//출력라벨 선택을 위한 로직
		List<CodeDetailVO> gsSelectLabel = codeInfo.getCodeList("B706", "", false);
		for(CodeDetailVO map : gsSelectLabel)	{
			if("Y".equals(map.getRefCode1()) || "y".equals(map.getRefCode1()))	{
				model.addAttribute("gsSelectLabel", map.getCodeNo());
			}
		}

		//라벨출력을 위해 LOT 이니셜 확인
		List<CodeDetailVO> gsLotInitail = codeInfo.getCodeList("Z011", "", false);
		for(CodeDetailVO map : gsLotInitail)	{
			if("Y".equals(map.getRefCode1()) || "y".equals(map.getRefCode1()))	{
				model.addAttribute("gsLotInitail", map.getCodeNo());
			}
		}

		//라벨출력을 위한 작업자 가져오는 로직
		List<CodeDetailVO> gsWorker = codeInfo.getCodeList("B705", "", false);
		for(CodeDetailVO map : gsWorker)	{
			if("Y".equals(map.getRefCode1()) || "y".equals(map.getRefCode1()))	{
				model.addAttribute("gsWorker", map.getCodeName());
			}
		}
		model.addAttribute("COMBO_WS_LIST", comboService.getWhList(param));

		List<CodeDetailVO> gsReportGubun = codeInfo.getCodeList("B909", "",   false);
		for(CodeDetailVO map :   gsReportGubun)	{
			if("bpr300rkrv".equals(map.getCodeName())) {
				model.addAttribute("gsReportGubun", map.getRefCode10());
				}
		}

		return JSP_PATH + "bpr300rkrv";
	}

	@RequestMapping(value = "/base/bpr260ukrv.do")
	public String bpr260ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());

		//20200511 추가: 컬럼명 변경 / 추가 그리드 보이게 하기 위해 추가
		CodeInfo codeInfo	= this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo	= null;
		cdo = codeInfo.getCodeInfo("B259", "1");	//사이트 구분 운영코드
		if(ObjUtils.isNotEmpty(cdo)){
			if(ObjUtils.isNotEmpty(cdo.getCodeName())){
				model.addAttribute("gsSiteCode", cdo.getCodeName().toUpperCase());
			}else{
				model.addAttribute("gsSiteCode", "STANDARD");
			}
		} else {
				model.addAttribute("gsSiteCode", "STANDARD");
		}
		return JSP_PATH + "bpr260ukrv";
	}


	/**
	 * 테스트 - 공정도 등록
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/base/bpr590ukrv.do")
	public String bpr590ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		return JSP_PATH + "bpr590ukrv";
	}

	/**
	 * 품목기본설정등록
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/base/bpr220ukrv.do")
	public String bpr220ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		return JSP_PATH + "bpr220ukrv";
	}




	/**
	 * 처방등록 (bpr580ukrv)
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/base/bpr580ukrv.do", method = RequestMethod.GET)
	public String bpr580ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));

		Map<String, Object> comboParam = new HashMap<String, Object>();
		comboParam.put("COMP_CODE", loginVO.getCompCode());
		comboParam.put("TYPE", "DIV_PRSN");
		model.addAttribute("COMBO_DIV_PRSN",  baseCommonService.fnRecordCombo(comboParam));


		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;
		//BOM PATH 관리여부(B082)
		List<CodeDetailVO> gsBomPathYN = codeInfo.getCodeList("B082", "", false);
		for(CodeDetailVO map : gsBomPathYN)	{
			if("Y".equals(map.getRefCode1()))	{
				model.addAttribute("gsBomPathYN", map.getCodeNo());
			}
		}
		//대체품목 등록여부(B081)
//		List<CodeDetailVO> gsExchgRegYN = codeInfo.getCodeList("B081", "", false);
//		for(CodeDetailVO map : gsExchgRegYN)	{
//			if("Y".equals(map.getRefCode1()))	{
//				model.addAttribute("gsExchgRegYN", map.getCodeNo());
//			}
//		}
		return JSP_PATH + "bpr580ukrv";
	}

	@RequestMapping(value = "/base/bpr561ukrv.do", method = RequestMethod.GET)
	public String bpr561ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));

		Map<String, Object> comboParam = new HashMap<String, Object>();
		comboParam.put("COMP_CODE", loginVO.getCompCode());
		comboParam.put("TYPE", "DIV_PRSN");
		model.addAttribute("COMBO_DIV_PRSN",  baseCommonService.fnRecordCombo(comboParam));


		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;
		//BOM PATH 관리여부(B082)
		List<CodeDetailVO> gsBomPathYN = codeInfo.getCodeList("B082", "", false);
		for(CodeDetailVO map : gsBomPathYN)	{
			if("Y".equals(map.getRefCode1()))	{
				model.addAttribute("gsBomPathYN", map.getCodeNo());
			}
		}
		//대체품목 등록여부(B081)
		List<CodeDetailVO> gsExchgRegYN = codeInfo.getCodeList("B081", "", false);
		for(CodeDetailVO map : gsExchgRegYN)	{
			if("Y".equals(map.getRefCode1()))	{
				model.addAttribute("gsExchgRegYN", map.getCodeNo());
			}
		}
		//20190607 SAMPLE코드 사용여부(B912.REF_CODE1), 품목계정(B912.REF_CODE2)
		cdo = codeInfo.getCodeInfo("B912", "1");
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsSampleCodeYn"	, cdo.getRefCode1());
			model.addAttribute("gsItemAccount"	, cdo.getRefCode2());
		} else {
			model.addAttribute("gsSampleCodeYn"	, "N");
			model.addAttribute("gsItemAccount"	, "*");
		}
		//20190617 자품목 순번증가 단위 설정(B913)
		cdo = codeInfo.getCodeInfo("B913", "1");
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsSeqIncUit", cdo.getRefCode1());
		} else {
			model.addAttribute("gsSeqIncUit", "1");
		}
		return JSP_PATH + "bpr561ukrv";
	}

	/**
	 * 품목 라벨출력 관련
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/base/bpr305rkrv.do", method = RequestMethod.GET)
	public String bpr305rkrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());

		//출력라벨 선택을 위한 로직
		List<CodeDetailVO> gsSelectLabel = codeInfo.getCodeList("B706", "", false);
		for(CodeDetailVO map : gsSelectLabel)	{
			if("Y".equals(map.getRefCode1()) || "y".equals(map.getRefCode1()))	{
				model.addAttribute("gsSelectLabel", map.getCodeNo());
			}
		}

		//라벨출력을 위해 LOT 이니셜 확인
		List<CodeDetailVO> gsLotInitail = codeInfo.getCodeList("Z011", "", false);
		for(CodeDetailVO map : gsLotInitail)	{
			if("Y".equals(map.getRefCode1()) || "y".equals(map.getRefCode1()))	{
				model.addAttribute("gsLotInitail", map.getCodeNo());
			}
		}

		//라벨출력을 위한 작업자 가져오는 로직
		List<CodeDetailVO> gsWorker = codeInfo.getCodeList("B705", "", false);
		for(CodeDetailVO map : gsWorker)	{
			if("Y".equals(map.getRefCode1()) || "y".equals(map.getRefCode1()))	{
				model.addAttribute("gsWorker", map.getCodeName());
			}
		}
		model.addAttribute("COMBO_WS_LIST", comboService.getWhList(param));

		List<CodeDetailVO> gsReportGubun = codeInfo.getCodeList("B909", "",   false);
		for(CodeDetailVO map :   gsReportGubun)	{
			if("bpr300rkrv".equals(map.getCodeName())) {
				model.addAttribute("gsReportGubun", map.getRefCode10());
				}
		}

		return JSP_PATH + "bpr305rkrv";
	}
	
	/**
	 * 원자재라벨출력
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/base/bpr815rkrv.do", method = RequestMethod.GET)
	public String bpr815rkrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		return JSP_PATH + "bpr815rkrv";
	}
	
	
	/**
	 * UPN 코드등록
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/base/bpr270ukrv.do", method = RequestMethod.GET)
	public String bpr270ukrv() throws Exception {
		return JSP_PATH + "bpr270ukrv";
	}
	
}
