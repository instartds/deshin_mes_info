package foren.unilite.modules.matrl.mrt;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import foren.framework.context.FwContext;
import foren.framework.lib.listop.ListOp;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.framework.model.NavigatorInfo;
import foren.framework.utils.ObjUtils;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.com.code.CodeDetailVO;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.modules.com.combo.ComboServiceImpl;

@Controller
public class MrtController extends UniliteCommonController {

	private final Logger	logger		= LoggerFactory.getLogger(this.getClass());

	final static String		JSP_PATH	= "/matrl/mrt/";
	
	@Resource(name="UniliteComboServiceImpl")
	private ComboServiceImpl comboService;
	
	
/**
 * 반품등록
 * @param loginVO
 * @param model
 * @return
 * @throws Exception
 */
@RequestMapping(value = "/matrl/mrt100ukrp1v.do",method = RequestMethod.GET)
public String mrt100ukrp1v( LoginVO loginVO, ModelMap model) throws Exception {
	return JSP_PATH + "mrt100ukrp1v";
}

@RequestMapping(value = "/matrl/mrt100ukrv.do",method = RequestMethod.GET)

public String mrt100ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
	
	final String[] searchFields = {  };
	NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
	LoginVO session = _req.getSession();
	Map<String, Object> param = navigator.getParam();
	String page = _req.getP("page");
	
	param.put("S_COMP_CODE",loginVO.getCompCode());
	model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
	
	CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
	CodeDetailVO cdo = null;
	
	List<CodeDetailVO> gsInOutPrsn = codeInfo.getCodeList("B024", "", false);	//반품담당 정보 조회
	for(CodeDetailVO map : gsInOutPrsn)	{
		
		if(/*loginVO.getUserID().equals(map.getRefCode2()) && */loginVO.getDivCode().equals(map.getRefCode1()))	{
			model.addAttribute("gsInOutPrsn", map.getCodeNo());
		}
	}
	
	List<CodeDetailVO> gsInoutTypeDetail = codeInfo.getCodeList("M106", "", false);		//입고유형
	for(CodeDetailVO map : gsInoutTypeDetail)	{
			model.addAttribute("gsInoutTypeDetail", map.getCodeNo());
	}

	List<CodeDetailVO> cdList = codeInfo.getCodeList("M106");	//기표대상여부관련
	if(!ObjUtils.isEmpty(cdList))	model.addAttribute("gsInTypeAccountYN",ObjUtils.toJsonStr(cdList));
	
	
	cdo = codeInfo.getCodeInfo("M102", "1");
	if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsExcessRate",cdo.getRefCode1());	//과입고허용률
	
	cdo = codeInfo.getCodeInfo("B022", "1");
	if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsInvstatus",cdo.getRefCode1());	//재고상태관리
	
	
	
	List<CodeDetailVO> gsProcessFlag = codeInfo.getCodeList("BS07", "", false);		//처리방법 분류
	for(CodeDetailVO map : gsProcessFlag)	{
		if("Y".equals(map.getRefCode1()))	{
			model.addAttribute("gsProcessFlag", map.getCodeNo());
		}
	}
	
	List<CodeDetailVO> gsInspecFlag = codeInfo.getCodeList("Q003", "", false);		//검사프로그램사용여부
	for(CodeDetailVO map : gsInspecFlag)	{
		if("Y".equals(map.getRefCode1()))	{
			model.addAttribute("gsInspecFlag", map.getCodeNo());
		}
	}
	
	cdo = codeInfo.getCodeInfo("M024", "1");
	if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsMap100UkrLink",	cdo.getCodeName());		//링크프로그램정보(지급결의등록)		
	
	
	cdo = codeInfo.getCodeInfo("B084", "C");
	if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsSumTypeLot",cdo.getRefCode1());	//재고합산유형:Lot No. 합산

	cdo = codeInfo.getCodeInfo("B084", "D");
	if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsSumTypeCell",cdo.getRefCode1());	//재고합산유형:창고 Cell. 합산
	
	List<CodeDetailVO> gsDefaultMoney = codeInfo.getCodeList("B004", "", false);		//기본 화폐단위
	for(CodeDetailVO map : gsDefaultMoney)	{
		if("Y".equals(map.getRefCode1()))	{
			model.addAttribute("gsDefaultMoney", map.getCodeNo());
		}
	}
	cdo = codeInfo.getCodeInfo("M101", "2");
	if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsAutoType",cdo.getRefCode1());

	return JSP_PATH + "mrt100ukrv";
	}

/**
 * 반품등록
 * @param loginVO
 * @param model
 * @return
 * @throws Exception
 */
@RequestMapping(value = "/matrl/mrt200ukrp1v.do",method = RequestMethod.GET)
public String mrt200ukrp1v( LoginVO loginVO, ModelMap model) throws Exception {
	return JSP_PATH + "mrt200ukrp1v";
}

@RequestMapping(value = "/matrl/mrt200ukrv.do",method = RequestMethod.GET)

public String mrt200ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
	
	final String[] searchFields = {  };
	NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
	LoginVO session = _req.getSession();
	Map<String, Object> param = navigator.getParam();
	String page = _req.getP("page");
	
	param.put("S_COMP_CODE",loginVO.getCompCode());
	model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
	
	CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
	CodeDetailVO cdo = null;
	
	List<CodeDetailVO> gsInOutPrsn = codeInfo.getCodeList("B024", "", false);	//반품담당 정보 조회
	for(CodeDetailVO map : gsInOutPrsn)	{
		
		if(/*loginVO.getUserID().equals(map.getRefCode2()) && */loginVO.getDivCode().equals(map.getRefCode1()))	{
			model.addAttribute("gsInOutPrsn", map.getCodeNo());
		}
	}
	
	List<CodeDetailVO> gsInoutTypeDetail = codeInfo.getCodeList("M106", "", false);		//입고유형
	for(CodeDetailVO map : gsInoutTypeDetail)	{
			model.addAttribute("gsInoutTypeDetail", map.getCodeNo());
	}

	List<CodeDetailVO> cdList = codeInfo.getCodeList("M106");	//기표대상여부관련
	if(!ObjUtils.isEmpty(cdList))	model.addAttribute("gsInTypeAccountYN",ObjUtils.toJsonStr(cdList));
	
	
	cdo = codeInfo.getCodeInfo("M102", "1");
	if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsExcessRate",cdo.getRefCode1());	//과입고허용률
	
	cdo = codeInfo.getCodeInfo("B022", "1");
	if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsInvstatus",cdo.getRefCode1());	//재고상태관리
	
	
	
	List<CodeDetailVO> gsProcessFlag = codeInfo.getCodeList("BS07", "", false);		//처리방법 분류
	for(CodeDetailVO map : gsProcessFlag)	{
		if("Y".equals(map.getRefCode1()))	{
			model.addAttribute("gsProcessFlag", map.getCodeNo());
		}
	}
	
	List<CodeDetailVO> gsInspecFlag = codeInfo.getCodeList("Q003", "", false);		//검사프로그램사용여부
	for(CodeDetailVO map : gsInspecFlag)	{
		if("Y".equals(map.getRefCode1()))	{
			model.addAttribute("gsInspecFlag", map.getCodeNo());
		}
	}
	
	cdo = codeInfo.getCodeInfo("M024", "1");
	if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsMap100UkrLink",	cdo.getCodeName());		//링크프로그램정보(지급결의등록)		
	
	
	cdo = codeInfo.getCodeInfo("B084", "C");
	if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsSumTypeLot",cdo.getRefCode1());	//재고합산유형:Lot No. 합산

	cdo = codeInfo.getCodeInfo("B084", "D");
	if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsSumTypeCell",cdo.getRefCode1());	//재고합산유형:창고 Cell. 합산
	
	List<CodeDetailVO> gsDefaultMoney = codeInfo.getCodeList("B004", "", false);		//기본 화폐단위
	for(CodeDetailVO map : gsDefaultMoney)	{
		if("Y".equals(map.getRefCode1()))	{
			model.addAttribute("gsDefaultMoney", map.getCodeNo());
		}
	}
	cdo = codeInfo.getCodeInfo("M101", "2");
	if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsAutoType",cdo.getRefCode1());

	return JSP_PATH + "mrt200ukrv";
	}
	
	@RequestMapping(value = "/matrl/mrt110skrv.do")
	public String mrt110skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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
		
		return JSP_PATH + "mrt110skrv";
	}
	@RequestMapping(value = "/matrl/mrt111skrv.do")
	public String mrt111skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE",loginVO.getCompCode()); 
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
		
		return JSP_PATH + "mrt111skrv";
	}
	@RequestMapping(value = "/matrl/mrt120skrv.do")
	public String mrt120skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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
		
		return JSP_PATH + "mrt120skrv";
	}
	
	/** Jasper Report Image 경로
	 *
	 **/
	@RequestMapping(value="/matrl/stampPhoto/{IMAGE_FILE}")
	public ModelAndView viewPhoto2(@PathVariable("IMAGE_FILE")  String IMAGE_FILE, ModelMap model, HttpServletRequest request)throws Exception{

		File photo = new File( FwContext.getRealPath("/" )+"WEB-INF/report/images/", IMAGE_FILE+".png");
		
		logger.debug("File = {} ", photo.getAbsolutePath());
		return ViewHelper.getImageView(photo);
	}

}

	
	
	
