package foren.unilite.modules.sales.sgp;

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
import foren.unilite.modules.accnt.afb.Afb720skrServiceImpl;
import foren.unilite.modules.com.combo.ComboServiceImpl;

@Controller
public class SgpContoroller extends UniliteCommonController {
	
	@Resource(name="UniliteComboServiceImpl")
	private ComboServiceImpl comboService;
	
	
	@Resource(name="sgp100ukrvService")
    private Sgp100ukrvServiceImpl sgp100ukrvService;
	@Resource(name="sgp200ukrvService")
	private Sgp200ukrvServiceImpl sgp200ukrvService;
	
	private final Logger	logger		= LoggerFactory.getLogger(this.getClass());

    

	final static String		JSP_PATH	= "/sales/sgp/";
	

    
    @RequestMapping(value = "/sales/sgp100ukrv.do")
    public String sgp100ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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
        
        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;
        
        int i = 0;
        List<CodeDetailVO> gsEntMoneyUnit = codeInfo.getCodeList("B042", "", false);  //  default 금액단위 가져오기  
        for(CodeDetailVO map : gsEntMoneyUnit)    {
            if("D".equals(map.getRefCode2())){
                model.addAttribute("gsEntMoneyUnit", map.getCodeNo());
            }
            i++;
        }
        if(i == 0) model.addAttribute("gsEntMoneyUnit", "1");
        
        List<CodeDetailVO> gsS022UseYn = codeInfo.getCodeList("S022", "", false); //계획별 탭사용여부 조회         
        for(CodeDetailVO map : gsS022UseYn)   {
            if("Y".equals(map.getRefCode1()))   {
                //각각 탭 사용 여부..S022
                String useCode_1 = "N";
                String useCode_2 = "N";
                String useCode_3 = "N";
                String useCode_4 = "N";
                String useCode_5 = "N";
                String useCode_6 = "N";
                String useCode_7 = "N";
                String useCode_8 = "N";
                String useCode_9 = "N";
                String useCode_10 = "N";
                
                if(map.getCodeNo().equals("1")){
                    model.addAttribute("useCode1", "Y");
                }else if(map.getCodeNo().equals("2")){
                    model.addAttribute("useCode2", "Y");
                }else if(map.getCodeNo().equals("3")){
                    model.addAttribute("useCode3", "Y");
                }else if(map.getCodeNo().equals("4")){
                    model.addAttribute("useCode4", "Y");
                }else if(map.getCodeNo().equals("5")){
                    model.addAttribute("useCode5", "Y");
                }else if(map.getCodeNo().equals("6")){
                    model.addAttribute("useCode6", "Y");
                }else if(map.getCodeNo().equals("7")){
                    model.addAttribute("useCode7", "Y");
                }else if(map.getCodeNo().equals("8")){
                    model.addAttribute("useCode8", "Y");
                }else if(map.getCodeNo().equals("S")){
                    model.addAttribute("useCode9", "Y");
	            }else if(map.getCodeNo().equals("A")){
	                model.addAttribute("useCode10", "Y");
	            }                
            }
        }
        
       
        return JSP_PATH + "sgp100ukrv";
    }
	
	@RequestMapping(value = "/sales/sgp200ukrv.do")
	public String sgp200ukrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        
        param.put("S_COMP_CODE",loginVO.getCompCode());

        model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
        
        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;
        
        List<Map<String, Object>> selectWeek = sgp200ukrvService.selectWeek(param);              
        model.addAttribute("selectWeek",ObjUtils.toJsonStr(selectWeek));
        
        List<Map<String, Object>> planYear = sgp200ukrvService.planYear(param);              
        model.addAttribute("planYear",ObjUtils.toJsonStr(planYear));
        
        List<Map<String, Object>> baseDate = sgp200ukrvService.baseDate(param);              
        model.addAttribute("baseDate",ObjUtils.toJsonStr(baseDate));

        //기준요일 확인 (공통코드 B604의 SUB_CODE1)
        List<Map<String, Object>> refConfig = sgp200ukrvService.selectRefCode(param);
        model.addAttribute("refConfig",ObjUtils.toJsonStr(refConfig));

        //고객관리여부 확인 (공통코드 S060의 REF_CODE1)
        List<Map<String, Object>> refConfig2 = sgp200ukrvService.selectRefCode2(param);
        model.addAttribute("refConfig2",ObjUtils.toJsonStr(refConfig2));

        //SRM 데이터수신 사용여부 확인 (공통코드 S146의 SUB_CODE = '1'의 REF_CODE1)
		cdo = codeInfo.getCodeInfo("S146", "1");
		if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsUseReceiveSrmYN", cdo.getRefCode1());     // 생산자동채번유무

        //화폐단위 가져오기
		int i = 0;
		List<CodeDetailVO> gsMoneyUnit = codeInfo.getCodeList("B004", "", false);	//자국화폐단위 정보		
		for(CodeDetailVO map : gsMoneyUnit)	{
			if("Y".equals(map.getRefCode1())){
				model.addAttribute("gsMoneyUnit", map.getCodeNo());
				i++;
			}			 
		}
		if(i == 0) model.addAttribute("gsMoneyUnit", "KRW");	

        return JSP_PATH + "sgp200ukrv";
	}
	
	@RequestMapping(value = "/sales/sgp100skrv.do")
	public String sgp100skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
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
        
        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;
        int i = 0;
        List<CodeDetailVO> gsEntMoneyUnit = codeInfo.getCodeList("B042", "", false);  //  default 금액단위 가져오기
        for(CodeDetailVO map : gsEntMoneyUnit)    {
            if("D".equals(map.getRefCode2())){
                model.addAttribute("gsEntMoneyUnit", map.getCodeNo());
            }
            i++;
        }
        if(i == 0) model.addAttribute("gsEntMoneyUnit", "1");
        
        List<CodeDetailVO> gsS022UseYn = codeInfo.getCodeList("S022", "", false);       //계획별 탭사용여부 조회   
        for(CodeDetailVO map : gsS022UseYn)   {
            if("Y".equals(map.getRefCode1()))   {
                //각각 탭 사용 여부..S022
                String useCode_1 = "N";
                String useCode_2 = "N";
                String useCode_3 = "N";
                String useCode_4 = "N";
                String useCode_5 = "N";
                String useCode_6 = "N";
                String useCode_7 = "N";
                String useCode_8 = "N";
                String useCode_9 = "N";
                String useCode_10 = "N";
                
                if(map.getCodeNo().equals("1")){
                    model.addAttribute("useCode1", "Y");
                }else if(map.getCodeNo().equals("2")){
                    model.addAttribute("useCode2", "Y");
                }else if(map.getCodeNo().equals("3")){
                    model.addAttribute("useCode3", "Y");
                }else if(map.getCodeNo().equals("4")){
                    model.addAttribute("useCode4", "Y");
                }else if(map.getCodeNo().equals("5")){
                    model.addAttribute("useCode5", "Y");
                }else if(map.getCodeNo().equals("6")){
                    model.addAttribute("useCode6", "Y");
                }else if(map.getCodeNo().equals("7")){
                    model.addAttribute("useCode7", "Y");
                }else if(map.getCodeNo().equals("8")){
                    model.addAttribute("useCode8", "Y");
                }else if(map.getCodeNo().equals("S")){
                    model.addAttribute("useCode9", "Y");
                }else if(map.getCodeNo().equals("A")){
                    model.addAttribute("useCode10", "Y");
                }
            }
        }
		return JSP_PATH + "sgp100skrv";
	}
	
	@RequestMapping(value = "/sales/sgp101ukrv.do")
	public String sgp101ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		/*final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));  
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));   
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param)); 
		model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));*/
		
		return JSP_PATH + "sgp101ukrv";
	}
	
	@RequestMapping(value = "/sales/sgp200skrv.do")
	public String sgp200skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        Map<String, Object> param = navigator.getParam();

        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());

        List<Map<String, Object>> selectWeek = sgp200ukrvService.selectWeek(param);              
        model.addAttribute("selectWeek",ObjUtils.toJsonStr(selectWeek));
        
        List<Map<String, Object>> planYear = sgp200ukrvService.planYear(param);              
        model.addAttribute("planYear",ObjUtils.toJsonStr(planYear));
        
        List<Map<String, Object>> baseDate = sgp200ukrvService.baseDate(param);              
        model.addAttribute("baseDate",ObjUtils.toJsonStr(baseDate));

        //기준요일 확인 (공통코드 B604의 SUB_CODE1)
        List<Map<String, Object>> refConfig = sgp200ukrvService.selectRefCode(param);
        model.addAttribute("refConfig",ObjUtils.toJsonStr(refConfig));

        //고객관리여부 확인 (공통코드 S060의 REF_CODE1)
        List<Map<String, Object>> refConfig2 = sgp200ukrvService.selectRefCode2(param);
        model.addAttribute("refConfig2",ObjUtils.toJsonStr(refConfig2));

        //화폐단위 가져오기
		int i = 0;
		List<CodeDetailVO> gsMoneyUnit = codeInfo.getCodeList("B004", "", false);	//자국화폐단위 정보		
		for(CodeDetailVO map : gsMoneyUnit)	{
			if("Y".equals(map.getRefCode1())){
				model.addAttribute("gsMoneyUnit", map.getCodeNo());
				i++;
			}			 
		}
		if(i == 0) model.addAttribute("gsMoneyUnit", "KRW");	

		return JSP_PATH + "sgp200skrv";
	}
	
	@RequestMapping(value = "/sales/sgp300ukrv.do")
	public String sgp300ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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
		
		return JSP_PATH + "sgp300ukrv";
	}
	
	@RequestMapping(value = "/sales/sgp500ukrv.do")
	public String sgp500ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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
		
		return JSP_PATH + "sgp500ukrv";
	}
	
	@RequestMapping(value = "/sales/sgp510ukrv.do")
	public String sgp510ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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
		
		return JSP_PATH + "sgp510ukrv";
	}

	
}
