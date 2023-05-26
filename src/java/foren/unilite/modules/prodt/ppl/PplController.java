package foren.unilite.modules.prodt.ppl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.codehaus.jackson.map.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import foren.framework.lib.listop.ListOp;
import foren.framework.lib.tree.GenericTreeDataMap;
import foren.framework.lib.tree.GenericTreeNode;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.framework.model.NavigatorInfo;
import foren.framework.utils.ObjUtils;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.com.code.CodeDetailVO;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.com.combo.ComboServiceImpl;
import foren.unilite.modules.com.tree.UniTreeNode;
import foren.unilite.modules.prodt.pmp.Pmp110ukrvServiceImpl;

@Controller
public class PplController extends UniliteCommonController {

	private final Logger	logger		= LoggerFactory.getLogger(this.getClass());

	final static String		JSP_PATH	= "/prodt/ppl/";

	@Resource(name="UniliteComboServiceImpl")
	private ComboServiceImpl comboService;

	@Resource(name="ppl300ukrvService")
	private Ppl300ukrvServiceImpl ppl300ukrvService;

	@Resource(name="ppl301ukrvService")
	private Ppl301ukrvServiceImpl ppl301ukrvService;
	
	@Resource(name="ppl320ukrvService")
	private Ppl320ukrvServiceImpl ppl320ukrvService;
	
	@RequestMapping(value = "/prodt/ppl190skrv.do")
	public String ppl190skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		return JSP_PATH + "ppl190skrv";
	}

	@RequestMapping(value = "/prodt/ppl190rkrv.do")
	public String ppl190rkrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		return JSP_PATH + "ppl190rkrv";
	}

	@RequestMapping(value = "/prodt/ppl120skrv.do")
	public String ppl120skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		return JSP_PATH + "ppl120skrv";
	}

	@RequestMapping(value = "/prodt/ppl112skrv.do")
	public String ppl112skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		return JSP_PATH + "ppl112skrv";
	}

	@RequestMapping(value = "/prodt/ppl111ukrv.do")
	public String ppl111ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
		model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));


		cdo = codeInfo.getCodeInfo("S048", "PP");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsManageTimeYN",			cdo.getRefCode1());

		return JSP_PATH + "ppl111ukrv";
	}

	/**
	 * 생산계획등록
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/prodt/ppl113ukrv.do")
	public String ppl113ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
		model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));


		cdo = codeInfo.getCodeInfo("S048", "PP");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsManageTimeYN",			cdo.getRefCode1());

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

		cdo = codeInfo.getCodeInfo("BS82", loginVO.getDivCode());    //작업지시데이터연동정보
		 if(ObjUtils.isNotEmpty(cdo)){
			 if(ObjUtils.isNotEmpty(cdo.getCodeName())){
			 	model.addAttribute("gsIfCode", cdo.getRefCode1().toUpperCase());
			 	model.addAttribute("gsIfSiteCode", cdo.getRefCode2());
			 }else{
			 	model.addAttribute("gsIfCode", "N");
			 	model.addAttribute("gsIfSiteCode", "");
			 }
	     }else {
			 	model.addAttribute("gsIfCode", "N");
			 	model.addAttribute("gsIfSiteCode", "");
	     }


		return JSP_PATH + "ppl113ukrv";
	}


	@RequestMapping(value = "/prodt/ppl140skrv.do")
	public String ppl140skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		return JSP_PATH + "ppl140skrv";
	}

	@RequestMapping(value = "/prodt/ppl160skrv.do")
	public String ppl160skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		return JSP_PATH + "ppl160skrv";
	}

	@RequestMapping(value = "/prodt/ppl180skrv.do")
	public String ppl180skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		return JSP_PATH + "ppl180skrv";
	}

	@RequestMapping(value = "/prodt/ppl100ukrv.do")
	public String ppl100ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
		model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));


		cdo = codeInfo.getCodeInfo("S048", "PP");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsManageTimeYN",			cdo.getRefCode1());

		return JSP_PATH + "ppl100ukrv";
	}
/**
 * 생산계획등록
 **/
	@RequestMapping(value = "/prodt/ppl101ukrv.do")
    public String ppl101ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
       /*
        param.put("S_COMP_CODE",loginVO.getCompCode());
        model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
        */
        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;
        /*
        model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
        model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
        model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
        model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));


        cdo = codeInfo.getCodeInfo("S048", "PP");
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsManageTimeYN",            cdo.getRefCode1());
                */
        return JSP_PATH + "ppl101ukrv";
    }


	/**
	 * 생산계획등록(작업장별)(II) (ppl102ukrv)
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/prodt/ppl102ukrv.do")
	public String s_ppl100ukrv_jw (ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
		model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));


		cdo = codeInfo.getCodeInfo("S048", "PP");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsManageTimeYN",			cdo.getRefCode1());

		return JSP_PATH + "ppl102ukrv";
	}

	/**
	 * 생산계획등록(사출)
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/prodt/ppl114ukrv.do")
    public String ppl114ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;


        List<CodeDetailVO> gsList1 = codeInfo.getCodeList("P001", "", false);
		Object list1= "";
		for(CodeDetailVO map : gsList1)	{
			if("작지".equals(map.getRefCode1()))	{
				if(list1.equals("")){
					list1 = map.getCodeNo();
				}else{
					list1 = list1 + ";" + map.getCodeNo();
				}
			}
		}
		model.addAttribute("gsList1", list1);

        return JSP_PATH + "ppl114ukrv";
    }

	/**
	 * 생산계획등록(조립)
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/prodt/ppl115ukrv.do")
    public String ppl115ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;


        List<CodeDetailVO> gsList1 = codeInfo.getCodeList("P001", "", false);
		Object list1= "";
		for(CodeDetailVO map : gsList1)	{
			if("작지".equals(map.getRefCode1()))	{
				if(list1.equals("")){
					list1 = map.getCodeNo();
				}else{
					list1 = list1 + ";" + map.getCodeNo();
				}
			}
		}
		model.addAttribute("gsList1", list1);

        return JSP_PATH + "ppl115ukrv";
    }

	@RequestMapping(value = "/prodt/ppl116ukrv.do")
    public String ppl116ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        return JSP_PATH + "ppl116ukrv";
    }
	@RequestMapping(value = "/prodt/ppl116ukrv1.do")
    public String ppl116ukrv1(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        return JSP_PATH + "ppl116ukrv1";
    }
	@RequestMapping(value = "/prodt/ppl300ukrv.do")
	public String ganttest(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		//model.addAttribute("CSS_TYPE", "-large2");

		return JSP_PATH + "ppl300ukrv";
	}

	@RequestMapping(value = "/prodt/ppl301ukrv.do")
	public String ppl301ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		//model.addAttribute("CSS_TYPE", "-large2");

		return JSP_PATH + "ppl301ukrv";
	}

	@RequestMapping(value = "/prodt/ppl320ukrv.do")
	public String ppl320ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		//model.addAttribute("CSS_TYPE", "-large2");

		return JSP_PATH + "ppl320ukrv";
	}
	
	
	@RequestMapping(value = "/prodt/apsChartData.do"  ,method = { RequestMethod.PUT, RequestMethod.POST, RequestMethod.GET })
	public ModelAndView  apsChartData(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
	
		
		String data = (String) _req.getParameter("data");
		ObjectMapper mapper = new ObjectMapper();
		Map<String, String> param = mapper.readValue(data, Map.class);
        param.put("S_COMP_CODE", loginVO.getCompCode());
	    
        //resources Json
        Map resourceMap = new HashMap();
        List<GenericTreeNode<GenericTreeDataMap>> resouceList =  ppl320ukrvService.selectResourcelist(param);
        resourceMap.put("rows", resouceList);
        
        //event Json
        Map eventMap = new HashMap();
        List<Map<String, Object>> eventData = ppl320ukrvService.selectDetailList(param);
        eventMap.put("rows", eventData);
        
        //dependancy Json
        Map dependancyMap = new HashMap();
        List<Map<String, Object>> dependancyData = new ArrayList();
        for(Map event : eventData)	{
        	Map dependancy = new HashMap();
        	dependancy.put("id", ObjUtils.getSafeString(event.get("id")));
        	dependancy.put("from",  ObjUtils.getSafeString(event.get("DEPENDENCY_FROM")));
        	dependancy.put("to",  ObjUtils.getSafeString(event.get("DEPENDENCY_TO")));
        	dependancyData.add(dependancy);
        }
        dependancyMap.put("rows", dependancyData);
        
        Map rMap = new HashMap();
        rMap.put("success", true);
        rMap.put("events", eventMap);
        rMap.put("resources", resourceMap);
        //rMap.put("dependencies", dependancyMap);
        
	    return ViewHelper.getJsonView(rMap);
	    //return result;
	}
	
	/**
	 * APS대상등록 (ppl310ukrv) - 20210826 신규 등록
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/prodt/ppl310ukrv.do")
	public String ppl310ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields	= {  };
		NavigatorInfo navigator		= new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session				= _req.getSession();
		Map<String, Object> param	= navigator.getParam();
		String page					= _req.getP("page");

		return JSP_PATH + "ppl310ukrv";
	}

	@RequestMapping(value = "/prodt/ganttJsonData.do")
	@ResponseBody
	public String  ganttJsonData(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		System.out.println("[[PARAM]]" + param);
		String page 	   = _req.getP("page");
		String searchParam = _req.getParameter("data");

		HashMap<String, String> hashmap = new HashMap<String, String>();
		ObjectMapper mapper = new ObjectMapper();
		Map<String, String> searchMap = mapper.readValue(searchParam, Map.class);
		searchMap.put("COMP_CODE", loginVO.getCompCode());
		ModelAndView mv = new ModelAndView();
		Map<String, Object> dataMaster = new HashMap<>();
	    String result = ppl300ukrvService.selectMaster(searchMap);
	    
	    result = new String(result.getBytes("utf-8"),"iso-8859-1");	    
	    return result;

	}

	@RequestMapping(value = "/prodt/apsData.do")
	@ResponseBody
	public String  apsJsonData(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String result = "";
	    //result = ganttchartService.selectDetailList(param);

	    result = new String(result.getBytes("euc-kr"),"ksc5601");
	    return result;

	}
	
	
	@RequestMapping(value = "/prodt/ganttApsData.do")
	@ResponseBody
	public String  ganttApsData(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model, HttpServletRequest request) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page 	   = _req.getP("page");
		String searchParam = _req.getParameter("data");

		ModelAndView mv = new ModelAndView();
		Map<String, Object> dataMaster = new HashMap<>();
		String path = request.getServletContext().getRealPath("/resources/js/python_files");
		String result = "";
		try{
			result = ppl300ukrvService.insertApsInputData(param, loginVO, path);
			
		}catch(Exception e){
			e.printStackTrace();
			String errorDesc = e.getMessage();
//			String[] messsage = errorDesc.split(";");
			errorDesc = "44444;"+ errorDesc;
			result = errorDesc;
		}

//	    return new String(result.getBytes("euc-kr"),"ksc5601");
		return result;
	}
	@RequestMapping(value = "/prodt/ganttApsData1.do")
	@ResponseBody
	public String  ganttApsData1(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model, HttpServletRequest request) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page 	   = _req.getP("page");
		String searchParam = _req.getParameter("data");

		ModelAndView mv = new ModelAndView();
		Map<String, Object> dataMaster = new HashMap<>();
		String path = request.getServletContext().getRealPath("/resources/js/python_files");
		String result = "";
		try{
			result = ppl301ukrvService.insertApsInputData(param, loginVO, path);
			
		}catch(Exception e){
			e.printStackTrace();
			String errorDesc = e.getMessage();
//			String[] messsage = errorDesc.split(";");
			errorDesc = "44444;"+ errorDesc;
			result = errorDesc;
		}

//	    return new String(result.getBytes("euc-kr"),"ksc5601");
		return result;
	}
	
	@RequestMapping(value = "/prodt/ppl117ukrv.do")
    public String ppl117ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        return JSP_PATH + "ppl117ukrv";
    }
	@RequestMapping(value = "/prodt/ppl117ukrv1.do")
    public String ppl117ukrv1(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        return JSP_PATH + "ppl117ukrv1";
    }
}
