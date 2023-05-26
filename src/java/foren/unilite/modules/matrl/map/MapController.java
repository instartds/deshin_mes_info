package foren.unilite.modules.matrl.map;

import java.util.ArrayList;
import java.util.HashMap;
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
import foren.framework.utils.ObjUtils;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.com.code.CodeDetailVO;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.modules.com.combo.ComboServiceImpl;
import foren.unilite.modules.matrl.map.Map080ukrvServiceImpl;
import foren.unilite.modules.vmi.VmiCommonServiceImpl;
@Controller
public class MapController extends UniliteCommonController {

	private final Logger	logger		= LoggerFactory.getLogger(this.getClass());

	final static String		JSP_PATH	= "/matrl/map/";

	@Resource(name="UniliteComboServiceImpl")
	private ComboServiceImpl comboService;

	@Resource(name="map080ukrvService")
	private Map080ukrvServiceImpl map080ukrvService;

	@Resource(name = "vmiCommonService")
	private VmiCommonServiceImpl vmiCommonService;


	@RequestMapping(value = "/matrl/map040skrv.do")
	public String map040skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		return JSP_PATH + "map040skrv";
	}


	@RequestMapping(value = "/matrl/map110skrv.do")
	public String map110skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		return JSP_PATH + "map110skrv";
	}



	@RequestMapping(value = "/matrl/map120skrv.do")
	public String map120skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
		List<CodeDetailVO> gsList1 = codeInfo.getCodeList("A022", "", false);
		Object list1= "";
		for(CodeDetailVO map : gsList1)	{
			if("1".equals(map.getRefCode3()) && "Y".equals(map.getRefCode4()))	{
				if(list1.equals("")){
				list1 =  map.getCodeNo();
				}else{
					list1 = list1 + ";" + map.getCodeNo();
				}
			}
		}
		model.addAttribute("gsList1", list1);

		return JSP_PATH + "map120skrv";
	}
	// 연세대 VMI 외상매입집계현황
	@RequestMapping(value = "/matrl/map121skrv.do")
	public String map121skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
		List<CodeDetailVO> gsList1 = codeInfo.getCodeList("A022", "", false);
		Object list1= "";
		for(CodeDetailVO map : gsList1)	{
			if("1".equals(map.getRefCode3()) && "Y".equals(map.getRefCode4()))	{
				if(list1.equals("")){
				list1 =  map.getCodeNo();
				}else{
					list1 = list1 + ";" + map.getCodeNo();
				}
			}
		}
		model.addAttribute("gsList1", list1);

		return JSP_PATH + "map121skrv";
	}

	@RequestMapping(value = "/matrl/map120ukrv.do",method = RequestMethod.GET)

	public String map120ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {

		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		List<CodeDetailVO> gsList1 = codeInfo.getCodeList("A022", "", false);
		Object list1= "";
		for(CodeDetailVO map : gsList1)	{
			if("1".equals(map.getRefCode3()) && "Y".equals(map.getRefCode4()))	{
				if(list1.equals("")){
				list1 =  map.getCodeNo();
				}else{
					list1 = list1 + ";" + map.getCodeNo();
				}
			}
		}
		model.addAttribute("gsList1", list1);


		return JSP_PATH + "map120ukrv";
	}

	@RequestMapping(value = "/matrl/map140skrv.do")
	public String map140skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		return JSP_PATH + "map140skrv";
	}

	@RequestMapping(value = "/matrl/map250ukrv.do")
	public String map250ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		return JSP_PATH + "map250ukrv";
	}

	@RequestMapping(value = "/matrl/map300ukrv.do")
	public String map300ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());

		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		List<CodeDetailVO> gsDefaultMoney = codeInfo.getCodeList("B004", "", false);		//기본 화폐단위
		for(CodeDetailVO map : gsDefaultMoney)	{
			if("Y".equals(map.getRefCode1()))	{
				model.addAttribute("gsDefaultMoney", map.getCodeNo());
			}
		}

		return JSP_PATH + "map300ukrv";
	}

	/**
	 * 거래처기초잔액등록
	 * @param loginVO
	 * @param model
	 * @return
	 * @throws Exception
	 */

	@RequestMapping(value = "/matrl/map000ukrv.do")
	public String map000ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());

		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		List<CodeDetailVO> gsDefaultMoney = codeInfo.getCodeList("B004", "", false);		//기본 화폐단위
		for(CodeDetailVO map : gsDefaultMoney)	{
			if("Y".equals(map.getRefCode1()))	{
				model.addAttribute("gsDefaultMoney", map.getCodeNo());
			}
		}

		return JSP_PATH + "map000ukrv";
	}




	/**
	 * 매입집계작업
	 * @param loginVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/matrl/map200ukrv.do",method = RequestMethod.GET)
	public String map200ukrv( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

		return JSP_PATH + "map200ukrv";
	}


	/**
     * 지급결의등록
     * @param loginVO
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/matrl/map110ukrp1v.do",method = RequestMethod.GET)
    public String map110ukrp1v( LoginVO loginVO, ModelMap model) throws Exception {
        return JSP_PATH + "map110ukrp1v";
    }



    @RequestMapping(value = "/matrl/map110ukrv.do",method = RequestMethod.GET)

    public String map110ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {

        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        param.put("S_COMP_CODE",loginVO.getCompCode());
        model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;

        cdo = codeInfo.getCodeInfo("M502", "1");
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsAdvanUseYn",cdo.getRefCode1());   //선지급사용여부 조회
        else model.addAttribute("gsAdvanUseYn",'N');

        List<CodeDetailVO> gsDefaultMoney = codeInfo.getCodeList("B004", "", false);        //기본 화폐단위
        for(CodeDetailVO map : gsDefaultMoney)  {
            if("Y".equals(map.getRefCode1()))   {
                model.addAttribute("gsDefaultMoney", map.getCodeNo());
            }
        }
        cdo = codeInfo.getCodeInfo("M101", "4");
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsAutoType1",cdo.getRefCode1());

        cdo = codeInfo.getCodeInfo("M101", "5");
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsAutoType2",cdo.getRefCode1());

        List<CodeDetailVO> gsList1 = codeInfo.getCodeList("A022", "", false);
        Object list1= "";
        for(CodeDetailVO map : gsList1) {
            if("1".equals(map.getRefCode3()) && "Y".equals(map.getRefCode5()))  {
                if(list1.equals("")){
                list1 =  map.getCodeNo();
                }else{
                    list1 = list1 + ";" + map.getCodeNo();
                }
            }
        }
        model.addAttribute("gsList1", list1);

        List<CodeDetailVO> gsList2 = codeInfo.getCodeList("M302", "", false);
        Object list2= "";
        for(CodeDetailVO map : gsList2) {
            if("Y".equals(map.getRefCode5()))   {
                if(list2.equals("")){
                list2 =  map.getCodeNo();
                }else{
                    list2 = list2 + ";" + map.getCodeNo();
                }
            }
        }
        model.addAttribute("gsList2", list2);
        /*List<CodeDetailVO> AccountType = codeInfo.getCodeList("M302", "", false);     //기본 화폐단위
        for(CodeDetailVO map : AccountType) {
            if("Y".equals(map.getRefCode4()))   {
                model.addAttribute("AccountType", map.getCodeNo());
            }
        }

        List<CodeDetailVO> BillType = codeInfo.getCodeList("M302", "", false);      //기본 화폐단위
        for(CodeDetailVO map : BillType)    {
            if("Y".equals(map.getRefCode()))    {
                model.addAttribute("AccountType", map.getCodeNo());
            }
        }*/

        List<CodeDetailVO> AccountType = codeInfo.getCodeList("M302");
        if(!ObjUtils.isEmpty(AccountType))  model.addAttribute("AccountType",ObjUtils.toJsonStr(AccountType));

        List<CodeDetailVO> BillType = codeInfo.getCodeList("A022");
        if(!ObjUtils.isEmpty(BillType)) model.addAttribute("BillType",ObjUtils.toJsonStr(BillType));

        return JSP_PATH + "map110ukrv";
    }







	/**
	 * 지급결의등록
	 * @param loginVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/matrl/map100ukrp1v.do",method = RequestMethod.GET)
	public String map100ukrp1v( LoginVO loginVO, ModelMap model) throws Exception {
		return JSP_PATH + "map100ukrp1v";
	}



	@RequestMapping(value = "/matrl/map100ukrv.do",method = RequestMethod.GET)

	public String map100ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {

		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		cdo = codeInfo.getCodeInfo("M502", "1");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsAdvanUseYn",cdo.getRefCode1());	//선지급사용여부 조회
		else model.addAttribute("gsAdvanUseYn",'N');

		List<CodeDetailVO> gsDefaultMoney = codeInfo.getCodeList("B004", "", false);		//기본 화폐단위
		for(CodeDetailVO map : gsDefaultMoney)	{
			if("Y".equals(map.getRefCode1()))	{
				model.addAttribute("gsDefaultMoney", map.getCodeNo());
			}
		}
		cdo = codeInfo.getCodeInfo("M101", "4");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsAutoType1",cdo.getRefCode1());

		cdo = codeInfo.getCodeInfo("M101", "5");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsAutoType2",cdo.getRefCode1());

		List<CodeDetailVO> gsList1 = codeInfo.getCodeList("A022", "", false);
		Object list1= "";
		for(CodeDetailVO map : gsList1)	{
			if("1".equals(map.getRefCode3()) && "Y".equals(map.getRefCode5()))	{
				if(list1.equals("")){
				list1 =  map.getCodeNo();
				}else{
					list1 = list1 + ";" + map.getCodeNo();
				}
			}
		}
		model.addAttribute("gsList1", list1);

		List<CodeDetailVO> gsList2 = codeInfo.getCodeList("M302", "", false);
		Object list2= "";
		for(CodeDetailVO map : gsList2)	{
			if("Y".equals(map.getRefCode5()))	{
				if(list2.equals("")){
				list2 =  map.getCodeNo();
				}else{
					list2 = list2 + ";" + map.getCodeNo();
				}
			}
		}
		model.addAttribute("gsList2", list2);
		/*List<CodeDetailVO> AccountType = codeInfo.getCodeList("M302", "", false);		//기본 화폐단위
		for(CodeDetailVO map : AccountType)	{
			if("Y".equals(map.getRefCode4()))	{
				model.addAttribute("AccountType", map.getCodeNo());
			}
		}

		List<CodeDetailVO> BillType = codeInfo.getCodeList("M302", "", false);		//기본 화폐단위
		for(CodeDetailVO map : BillType)	{
			if("Y".equals(map.getRefCode()))	{
				model.addAttribute("AccountType", map.getCodeNo());
			}
		}*/

		List<CodeDetailVO> AccountType = codeInfo.getCodeList("M302");
		if(!ObjUtils.isEmpty(AccountType))	model.addAttribute("AccountType",ObjUtils.toJsonStr(AccountType));

		List<CodeDetailVO> BillType = codeInfo.getCodeList("A022");
		if(!ObjUtils.isEmpty(BillType))	model.addAttribute("BillType",ObjUtils.toJsonStr(BillType));

		cdo = codeInfo.getCodeInfo("B259", "1");    //사이트 구분 운영코드
		 if(ObjUtils.isNotEmpty(cdo)){
			 if(ObjUtils.isNotEmpty(cdo.getCodeName())){
			 	model.addAttribute("gsSiteCode", cdo.getCodeName().toUpperCase());
			 }else{
			 	model.addAttribute("gsSiteCode", "STANDARD");
			 }
	    }else {
	           model.addAttribute("gsSiteCode", "STANDARD");
	    }

		return JSP_PATH + "map100ukrv";
	}
	/**
	 * 개별 지급결의등록(YSU)
	 * @param loginVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/matrl/map103ukrp1v.do",method = RequestMethod.GET)
	public String map103ukrp1v( LoginVO loginVO, ModelMap model) throws Exception {
		return JSP_PATH + "map103ukrp1v";
	}



	@RequestMapping(value = "/matrl/map103ukrv.do",method = RequestMethod.GET)

	public String map103ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {

		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		cdo = codeInfo.getCodeInfo("M502", "1");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsAdvanUseYn",cdo.getRefCode1());	//선지급사용여부 조회
		else model.addAttribute("gsAdvanUseYn",'N');

		List<CodeDetailVO> gsDefaultMoney = codeInfo.getCodeList("B004", "", false);		//기본 화폐단위
		for(CodeDetailVO map : gsDefaultMoney)	{
			if("Y".equals(map.getRefCode1()))	{
				model.addAttribute("gsDefaultMoney", map.getCodeNo());
			}
		}
		cdo = codeInfo.getCodeInfo("M101", "4");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsAutoType1",cdo.getRefCode1());

		cdo = codeInfo.getCodeInfo("M101", "5");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsAutoType2",cdo.getRefCode1());

		List<CodeDetailVO> gsList1 = codeInfo.getCodeList("A022", "", false);
		Object list1= "";
		for(CodeDetailVO map : gsList1)	{
			if("1".equals(map.getRefCode3()) && "Y".equals(map.getRefCode4()))	{
				if(list1.equals("")){
				list1 =  map.getCodeNo();
				}else{
					list1 = list1 + ";" + map.getCodeNo();
				}
			}
		}
		model.addAttribute("gsList1", list1);



		return JSP_PATH + "map103ukrv";
	}
	/**
	 * 일괄지급결의확정(YSU)
	 * @param loginVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/matrl/map101ukrp1v.do",method = RequestMethod.GET)
	public String map101ukrp1v( LoginVO loginVO, ModelMap model) throws Exception {
		return JSP_PATH + "map101ukrp1v";
	}


	@RequestMapping(value = "/matrl/map101ukrv.do",method = RequestMethod.GET)

	public String map101ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {

		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		cdo = codeInfo.getCodeInfo("M502", "1");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsAdvanUseYn",cdo.getRefCode1());	//선지급사용여부 조회
		else model.addAttribute("gsAdvanUseYn",'N');

		List<CodeDetailVO> gsDefaultMoney = codeInfo.getCodeList("B004", "", false);		//기본 화폐단위
		for(CodeDetailVO map : gsDefaultMoney)	{
			if("Y".equals(map.getRefCode1()))	{
				model.addAttribute("gsDefaultMoney", map.getCodeNo());
			}
		}
		List<CodeDetailVO> gsList1 = codeInfo.getCodeList("A022", "", false);
		Object list1= "";
		for(CodeDetailVO map : gsList1)	{
			if("1".equals(map.getRefCode3()) && "Y".equals(map.getRefCode4()))	{
				if(list1.equals("")){
				list1 =  map.getCodeNo();
				}else{
					list1 = list1 + ";" + map.getCodeNo();
				}
			}
		}
		model.addAttribute("gsList1", list1);


		return JSP_PATH + "map101ukrv";
	}
	/**
	 * 지급결의확정
	 * @param loginVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/matrl/map102ukrp1v.do",method = RequestMethod.GET)
	public String map102ukrp1v( LoginVO loginVO, ModelMap model) throws Exception {
		return JSP_PATH + "map101ukrp1v";
	}


	@RequestMapping(value = "/matrl/map102ukrv.do",method = RequestMethod.GET)

	public String map102ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {

		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		cdo = codeInfo.getCodeInfo("M502", "1");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsAdvanUseYn",cdo.getRefCode1());	//선지급사용여부 조회
		else model.addAttribute("gsAdvanUseYn",'N');

		List<CodeDetailVO> gsDefaultMoney = codeInfo.getCodeList("B004", "", false);		//기본 화폐단위
		for(CodeDetailVO map : gsDefaultMoney)	{
			if("Y".equals(map.getRefCode1()))	{
				model.addAttribute("gsDefaultMoney", map.getCodeNo());
			}
		}
		List<CodeDetailVO> gsList1 = codeInfo.getCodeList("A022", "", false);
		Object list1= "";
		for(CodeDetailVO map : gsList1)	{
			if("1".equals(map.getRefCode3()) && "Y".equals(map.getRefCode4()))	{
				if(list1.equals("")){
				list1 =  map.getCodeNo();
				}else{
					list1 = list1 + ";" + map.getCodeNo();
				}
			}
		}
		model.addAttribute("gsList1", list1);

		List<CodeDetailVO> gsCreditCard = codeInfo.getCodeList("A022", "", false);			// A022 ref_code1 (신용카드)
		Object list3= "";
		for(CodeDetailVO map : gsCreditCard)	{
			if("1".equals(map.getRefCode3()) && "F".equals(map.getRefCode1()))	{
				if(list3.equals("")){
					list3 =  map.getCodeNo();
				}else{
					list3 = list3 + ";" + map.getCodeNo();
				}
			}
		}
		model.addAttribute("gsCreditCard", list3);

		List<CodeDetailVO> gsCashReceipt = codeInfo.getCodeList("A022", "", false);			// A022 ref_code1 (현금영수증)
		Object list2= "";
		for(CodeDetailVO map : gsCashReceipt)	{
			if("1".equals(map.getRefCode3()) && "E".equals(map.getRefCode1()))	{
				if(list2.equals("")){
					list2 =  map.getCodeNo();
				}else{
					list2 = list2 + ";" + map.getCodeNo();
				}
			}
		}
		model.addAttribute("gsCashReceipt", list2);


		List<CodeDetailVO> AccountType = codeInfo.getCodeList("M302");
		if(!ObjUtils.isEmpty(AccountType))	model.addAttribute("AccountType",ObjUtils.toJsonStr(AccountType));

		List<CodeDetailVO> BillType = codeInfo.getCodeList("A022");
		if(!ObjUtils.isEmpty(BillType))	model.addAttribute("BillType",ObjUtils.toJsonStr(BillType));


		return JSP_PATH + "map102ukrv";
	}
	/**
	 * 거래원장대사등록
	 * @param loginVO
	 * @param model
	 * @return
	 * @throws Exception
	 */

	@RequestMapping(value = "/matrl/map050ukrv.do")
	public String map050ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());

		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		List<CodeDetailVO> gsDefaultMoney = codeInfo.getCodeList("B004", "", false);		//기본 화폐단위
		for(CodeDetailVO map : gsDefaultMoney)	{
			if("Y".equals(map.getRefCode1()))	{
				model.addAttribute("gsDefaultMoney", map.getCodeNo());
			}
		}

		return JSP_PATH + "map050ukrv";
	}

	/**
	 * 거래원장대사조회 vmi
	 * @param loginVO
	 * @param model
	 * @return
	 * @throws Exception
	 */

	@RequestMapping(value = "/matrl/map051skrv.do")
	public String map051skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		Map getVmiUserLevel = (Map) vmiCommonService.getVmiUserLevel(param);
		model.addAttribute("getVmiUserLevel", getVmiUserLevel.get("USER_LEVEL"));

		return JSP_PATH + "map051skrv";
	}
	/**
	 * 매출조회 vmi
	 * @param loginVO
	 * @param model
	 * @return
	 * @throws Exception
	 */

	@RequestMapping(value = "/matrl/map201skrv.do")
	public String map201skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		return JSP_PATH + "map201skrv";
	}
	// 매입처별 기간별 잔액현황

	@RequestMapping(value = "/matrl/map060skrv.do")
	public String map060skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());

		return JSP_PATH + "map060skrv";
	}


	/* 매입처 지불예정 명세서 */
	@RequestMapping(value = "/matrl/map070skrv.do")
	public String map070skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());

		return JSP_PATH + "map070skrv";
	}

	/**
	 * 지불예정명세서등록
	 * @param loginVO
	 * @param model
	 * @return
	 * @throws Exception
	 */

	@RequestMapping(value = "/matrl/map080ukrv.do")
	public String map080ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());

		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
		model.addAttribute("COMBO_COLLECT_DAY", map080ukrvService.getNewCollectDay(param));
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		List<CodeDetailVO> gsDefaultMoney = codeInfo.getCodeList("B004", "", false);		//기본 화폐단위
		for(CodeDetailVO map : gsDefaultMoney)	{
			if("Y".equals(map.getRefCode1()))	{
				model.addAttribute("gsDefaultMoney", map.getCodeNo());
			}
		}

		return JSP_PATH + "map080ukrv";
	}

	@RequestMapping(value = "/matrl/map080skrv.do")
	public String map080skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());

		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
		model.addAttribute("COMBO_COLLECT_DAY", map080ukrvService.getNewCollectDay(param));
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		List<CodeDetailVO> gsDefaultMoney = codeInfo.getCodeList("B004", "", false);		//기본 화폐단위
		for(CodeDetailVO map : gsDefaultMoney)	{
			if("Y".equals(map.getRefCode1()))	{
				model.addAttribute("gsDefaultMoney", map.getCodeNo());
			}
		}

		return JSP_PATH + "map080skrv";
	}


	/**
	 * 지불예정명세서등록(임시)
	 * @param loginVO
	 * @param model
	 * @return
	 * @throws Exception
	 */

	@RequestMapping(value = "/matrl/map081ukrv.do")
	public String map081ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());

		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		List<CodeDetailVO> gsDefaultMoney = codeInfo.getCodeList("B004", "", false);		//기본 화폐단위
		for(CodeDetailVO map : gsDefaultMoney)	{
			if("Y".equals(map.getRefCode1()))	{
				model.addAttribute("gsDefaultMoney", map.getCodeNo());
			}
		}

		return JSP_PATH + "map081ukrv";
	}


	//전사 매입현황
	@RequestMapping(value = "/matrl/map150skrv.do")
	public String map150skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_COLLECT_DAY", comboService.getCollectDay(param));
		return JSP_PATH + "map150skrv";
	}

	private int Integer(String codeNo) {
		// TODO Auto-generated method stub
		return 0;
	}
	@RequestMapping(value = "/matrl/map160rkrv.do")
	public String map160rkrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());

		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

		return JSP_PATH + "map160rkrv";
	}
	@RequestMapping(value = "/matrl/map150rkrv.do")
	public String map150rkrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		return JSP_PATH + "map150rkrv";
	}

	@RequestMapping(value = "/matrl/map301ukrv.do")
	public String map301ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());

		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

		return JSP_PATH + "map301ukrv";
	}
	/**
	 * 외상매입금내역출력
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
    @RequestMapping(value = "/matrl/map130rkrv.do")
    public String map130rkrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

        return JSP_PATH + "map130rkrv";
    }
}
