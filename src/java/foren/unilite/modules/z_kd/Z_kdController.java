package foren.unilite.modules.z_kd;

import java.io.File;
import java.io.FileOutputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.type.TypeFactory;
import com.google.gson.Gson;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.lib.listop.ListOp;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.framework.model.NavigatorInfo;
import foren.framework.utils.ConfigUtil;
import foren.framework.utils.GStringUtils;
import foren.framework.utils.ObjUtils;
import foren.framework.web.view.FileDownloadInfo;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.com.code.CodeDetailVO;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.com.tags.ComboItemModel;
import foren.unilite.modules.accnt.AccntCommonServiceImpl;
import foren.unilite.modules.accnt.afb.Afb240skrServiceImpl;
import foren.unilite.modules.accnt.agj.Agj100ukrServiceImpl;
import foren.unilite.modules.base.BaseCommonServiceImpl;
import foren.unilite.modules.base.bpr.Bpr300ukrvServiceImpl;
import foren.unilite.modules.com.combo.ComboServiceImpl;
import foren.unilite.modules.human.hat.Hat200ukrServiceImpl;
import foren.unilite.modules.human.hbo.Hbo800rkrServiceImpl;
import foren.unilite.modules.human.hpa.Hpa950skrServiceImpl;
import foren.unilite.modules.human.hum.Hum100ukrServiceImpl;
import foren.unilite.modules.matrl.mpo.Mpo150skrvServiceImpl;
import foren.unilite.com.code.CodeInfo;

@Controller
public class Z_kdController extends UniliteCommonController {

	private final Logger	logger		= LoggerFactory.getLogger(this.getClass());

	final static String		JSP_PATH	= "/z_kd/";

	@Resource(name="UniliteComboServiceImpl")
    private ComboServiceImpl comboService;

	@Resource(name="baseCommonService")
	private BaseCommonServiceImpl baseCommonService;

    @Resource(name="s_ppl111ukrv_kdService")
    private S_ppl111ukrv_kdServiceImpl s_ppl111ukrv_kdService;

    @Resource( name = "accntCommonService" )
    private AccntCommonServiceImpl accntCommonService;

    @Resource( name = "agj100ukrService" )
    private Agj100ukrServiceImpl   agj100ukrService;

    @Resource(name="s_sbx900ukrv_kdService")
    private S_sbx900ukrv_kdServiceImpl s_sbx900ukrv_kdService;

    @Resource(name="s_sbx901ukrv_kdService")
    private S_sbx901ukrv_kdServiceImpl s_sbx901ukrv_kdService;

    @Resource(name="s_bco100ukrv_kdService")
    private S_bco100ukrv_kdServiceImpl s_bco100ukrv_kdService;

	@Resource(name="s_mpo150skrv_kdService")
    private S_mpo150skrv_kdServiceImpl s_mpo150skrv_kdService;

	@Resource( name = "hum100ukrService" )
    private Hum100ukrServiceImpl   hum100ukrService;

    @Resource( name = "hpa950skrService" )
    private Hpa950skrServiceImpl   hpa950skrService;

    @Resource( name = "s_hbo800rkr_kdService" )
    private S_Hbo800rkr_kdServiceImpl   s_hbo800rkr_kdService;

	@Resource(name="s_zee300ukrv_kdService")
	private S_zee300ukrv_kdServiceImpl s_zee300ukrv_kdService;

	@Resource(name="s_zcc800skrv_kdService")
	private S_zcc800skrv_kdServiceImpl s_zcc800skrv_kdService;

	@Resource(name="s_zdd100ukrv_kdService")
	private S_zdd100ukrv_kdServiceImpl s_zdd100ukrv_kdService;
	
    @Resource( name = "s_hat200ukr_kdService" )
    private S_Hat200ukr_kdServiceImpl       s_hat200ukr_kdService;

	@RequestMapping(value = "/z_kd/s_bco100ukrv_kd.do", method = RequestMethod.GET)
	public String s_bco100ukrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        param.put("S_COMP_CODE",loginVO.getCompCode());

        model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
        model.addAttribute("WB22_LIST", s_bco100ukrv_kdService.wb22List(param));
        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;

        cdo = codeInfo.getCodeInfo("S012", "2");
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsAutoType",cdo.getRefCode1());      //Y:의뢰번호(txtOrderNum) lock,disable


        cdo = codeInfo.getCodeInfo("B609", "GW_URL");   //그룹웨어 호출 url
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("groupUrl",cdo.getCodeName());
//        if(!ObjUtils.isEmpty(cdo)){
//            model.addAttribute("GW_URL",cdo.getCodeName());
//        }else {
//            model.addAttribute("GW_URL", "");
//        }

	    List<CodeDetailVO> gsMoneyUnit = codeInfo.getCodeList("B004", "", false);
        for(CodeDetailVO map : gsMoneyUnit) {
            if("Y".equals(map.getRefCode1()))   {
                model.addAttribute("gsMoneyUnit", map.getCodeNo());
            }
        }                                                                                   /* 주화폐단위 */

		return JSP_PATH + "s_bco100ukrv_kd";
	}

	@RequestMapping(value = "/z_kd/s_bco110ukrv_kd.do", method = RequestMethod.GET)
    public String s_bco110ukrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        param.put("S_COMP_CODE",loginVO.getCompCode());

        model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;

        cdo = codeInfo.getCodeInfo("S012", "2");
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsAutoType",cdo.getRefCode1());      //Y:의뢰번호(txtOrderNum) lock,disable


        List<CodeDetailVO> gsMoneyUnit = codeInfo.getCodeList("B004", "", false);
        for(CodeDetailVO map : gsMoneyUnit) {
            if("Y".equals(map.getRefCode1()))   {
                model.addAttribute("gsMoneyUnit", map.getCodeNo());
            }
        }                                                                                   /* 주화폐단위 */

        return JSP_PATH + "s_bco110ukrv_kd";
    }

	@RequestMapping(value = "/z_kd/s_bco200ukrv_kd.do", method = RequestMethod.GET)
    public String s_bco200ukrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        param.put("S_COMP_CODE",loginVO.getCompCode());

        model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;

        cdo = codeInfo.getCodeInfo("S012", "2");
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsAutoType",cdo.getRefCode1());      //Y:의뢰번호(txtOrderNum) lock,disable


        List<CodeDetailVO> gsMoneyUnit = codeInfo.getCodeList("B004", "", false);
        for(CodeDetailVO map : gsMoneyUnit) {
            if("Y".equals(map.getRefCode1()))   {
                model.addAttribute("gsMoneyUnit", map.getCodeNo());
            }
        }                                                                                   /* 주화폐단위 */

        return JSP_PATH + "s_bco200ukrv_kd";
    }

	@RequestMapping(value = "/z_kd/s_bco100skrv_kd.do", method = RequestMethod.GET)
    public String s_bco100skrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        param.put("S_COMP_CODE",loginVO.getCompCode());

        model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
        model.addAttribute("WB22_LIST", s_bco100ukrv_kdService.wb22List(param));
        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;

        List<CodeDetailVO> gsMoneyUnit = codeInfo.getCodeList("B004", "", false);
        for(CodeDetailVO map : gsMoneyUnit) {
            if("Y".equals(map.getRefCode1()))   {
                model.addAttribute("gsMoneyUnit", map.getCodeNo());
            }
        }                                                                                   /* 주화폐단위 */

        cdo = codeInfo.getCodeInfo("B609", "GW_URL");   //그룹웨어 호출 url
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("groupUrl",cdo.getCodeName());

        return JSP_PATH + "s_bco100skrv_kd";
    }

	@RequestMapping(value = "/z_kd/s_bco300skrv_kd.do", method = RequestMethod.GET)
	public String s_bco300skrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        param.put("S_COMP_CODE",loginVO.getCompCode());

        model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;

        List<CodeDetailVO> gsMoneyUnit = codeInfo.getCodeList("B004", "", false);
        for(CodeDetailVO map : gsMoneyUnit) {
            if("Y".equals(map.getRefCode1()))   {
                model.addAttribute("gsMoneyUnit", map.getCodeNo());
            }
        }

        cdo = codeInfo.getCodeInfo("B609", "GW_URL");   //그룹웨어 호출 url
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("groupUrl",cdo.getCodeName());/* 주화폐단위 */

        return JSP_PATH + "s_bco300skrv_kd";
    }

	@RequestMapping(value = "/z_kd/s_bpr100ukrv_kd.do", method = RequestMethod.GET)
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
		return JSP_PATH + "s_bpr100ukrv_kd";
	}


	/**
	 * 사업장별 품목정보 현황
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/z_kd/s_bpr200skrv_kd.do")
	public String hum317skrv(ExtHtttprequestParam _req,LoginVO loginVO, ListOp listOp, ModelMap model)throws Exception{

		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();
		param.put("S_COMP_CODE",loginVO.getCompCode());
		/*
		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
		*/
		Map<String, Object> comboParam = new HashMap<String, Object>();
		comboParam.put("COMP_CODE", loginVO.getCompCode());
		comboParam.put("TYPE", "DIV_PRSN");
		model.addAttribute("COMBO_DIV_PRSN",  baseCommonService.fnRecordCombo(comboParam));

		return JSP_PATH+"s_bpr200skrv_kd";
	}


	/**
	 * 일근태집계작업
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/z_kd/s_hat600ukr_kd.do")
	public String s_hat600ukr_kd(ExtHtttprequestParam _req,LoginVO loginVO, ListOp listOp, ModelMap model)throws Exception{
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();
		param.put("S_COMP_CODE",loginVO.getCompCode());

		return JSP_PATH+"s_hat600ukr_kd";
	}

	//아래는 테스트용 실행 화면입니다
	//나중에 삭제하겠습니다
	@RequestMapping(value = "/z_kd/form01_test.do", method = RequestMethod.GET)
	public String tpl102ukrv() throws Exception {
		return JSP_PATH + "form01_test";
	}


//	@RequestMapping(value = "/z_kd/s_sgp100ukrv_kd.do")
//    public String s_sgp100ukrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
//        final String[] searchFields = {  };
//        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
//        LoginVO session = _req.getSession();
//        Map<String, Object> param = navigator.getParam();
//        String page = _req.getP("page");
//
//        param.put("S_COMP_CODE",loginVO.getCompCode());
//
//        model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
//
//        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
//        CodeDetailVO cdo = null;
//
////        List<CodeDetailVO> gsBalanceOut = codeInfo.getCodeList("WB06", "", false);
////        for(CodeDetailVO map : gsBalanceOut) {
////            if("Y".equals(map.getRefCode1()))   {
////                model.addAttribute("gsBalanceOut", map.getCodeNo());
////            }
////        }
//
//        return JSP_PATH + "s_sgp100ukrv_kd";
//    }

	@RequestMapping(value = "/z_kd/s_sgp100ukrv_kd.do", method = RequestMethod.GET)
    public String s_sgp100ukrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        param.put("S_COMP_CODE",loginVO.getCompCode());

        model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;

        List<CodeDetailVO> gsBalanceOut = codeInfo.getCodeList("WB06", "", false);
        for(CodeDetailVO map : gsBalanceOut) {
            if("Y".equals(map.getRefCode1()))   {
                model.addAttribute("gsBalanceOut", map.getCodeNo());
            }
        }

        return JSP_PATH + "s_sgp100ukrv_kd";
    }

	@RequestMapping(value = "/z_kd/s_sgp100skrv_kd.do", method = RequestMethod.GET)
    public String s_sgp100skrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

        return JSP_PATH + "s_sgp100skrv_kd";
    }

	@RequestMapping(value = "/z_kd/s_str900ukrv_kd.do", method = RequestMethod.GET)
    public String s_str900ukrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        param.put("S_COMP_CODE",loginVO.getCompCode());

        model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;

        cdo = codeInfo.getCodeInfo("S012", "2");
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsAutoType",cdo.getRefCode1());      //Y:의뢰번호(txtOrderNum) lock,disable


        List<CodeDetailVO> gsMoneyUnit = codeInfo.getCodeList("B004", "", false);
        for(CodeDetailVO map : gsMoneyUnit) {
            if("Y".equals(map.getRefCode1()))   {
                model.addAttribute("gsMoneyUnit", map.getCodeNo());
            }
        }                                                                                   /* 주화폐단위 */

        return JSP_PATH + "s_str900ukrv_kd";
    }

	@RequestMapping(value = "/z_kd/s_str901skrv_kd.do", method = RequestMethod.GET)
    public String s_str901skrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        param.put("S_COMP_CODE",loginVO.getCompCode());

        model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;
        return JSP_PATH + "s_str901skrv_kd";
    }

	@RequestMapping(value = "/z_kd/s_str902skrv_kd.do", method = RequestMethod.GET)
    public String s_str902skrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        param.put("S_COMP_CODE",loginVO.getCompCode());

        model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;
        return JSP_PATH + "s_str902skrv_kd";
    }

	@RequestMapping(value = "/z_kd/s_str904skrv_kd.do", method = RequestMethod.GET)
    public String s_str904skrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        param.put("S_COMP_CODE",loginVO.getCompCode());

        model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;
        return JSP_PATH + "s_str904skrv_kd";
    }

	@RequestMapping(value = "/z_kd/s_sco901skrv_kd.do", method = RequestMethod.GET)
    public String s_sco901skrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        param.put("S_COMP_CODE",loginVO.getCompCode());

        model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;
        return JSP_PATH + "s_sco901skrv_kd";
    }

	@RequestMapping(value = "/z_kd/s_sco902skrv_kd.do", method = RequestMethod.GET)
    public String s_sco902skrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        param.put("S_COMP_CODE",loginVO.getCompCode());

        model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;
        return JSP_PATH + "s_sco902skrv_kd";
    }

	@RequestMapping(value = "/z_kd/s_scl901ukrv_kd.do", method = RequestMethod.GET)
    public String s_scl901ukrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        param.put("S_COMP_CODE",loginVO.getCompCode());

        model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;

        cdo = codeInfo.getCodeInfo("S012", "2");
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsAutoType",cdo.getRefCode1());      //Y:의뢰번호(txtOrderNum) lock,disable


        List<CodeDetailVO> gsMoneyUnit = codeInfo.getCodeList("B004", "", false);
        for(CodeDetailVO map : gsMoneyUnit) {
            if("Y".equals(map.getRefCode1()))   {
                model.addAttribute("gsMoneyUnit", map.getCodeNo());
            }
        }                                                                                   /* 주화폐단위 */

        return JSP_PATH + "s_scl901ukrv_kd";
    }

	@RequestMapping(value = "/z_kd/s_scl901skrv_kd.do", method = RequestMethod.GET)
    public String s_scl901skrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        param.put("S_COMP_CODE",loginVO.getCompCode());

        model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;

        cdo = codeInfo.getCodeInfo("S012", "2");
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsAutoType",cdo.getRefCode1());      //Y:의뢰번호(txtOrderNum) lock,disable


        List<CodeDetailVO> gsMoneyUnit = codeInfo.getCodeList("B004", "", false);
        for(CodeDetailVO map : gsMoneyUnit) {
            if("Y".equals(map.getRefCode1()))   {
                model.addAttribute("gsMoneyUnit", map.getCodeNo());
            }
        }                                                                                   /* 주화폐단위 */

        cdo = codeInfo.getCodeInfo("B609", "GW_URL");   //그룹웨어 호출 url
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("groupUrl",cdo.getCodeName());

        return JSP_PATH + "s_scl901skrv_kd";
    }

	@RequestMapping(value = "/z_kd/s_str903ukrv_kd.do", method = RequestMethod.GET)
    public String s_str903ukrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        param.put("S_COMP_CODE",loginVO.getCompCode());

        model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;

        return JSP_PATH + "s_str903ukrv_kd";
    }

	@RequestMapping(value = "/z_kd/s_str903skrv_kd.do", method = RequestMethod.GET)
    public String s_str903skrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        param.put("S_COMP_CODE",loginVO.getCompCode());

        model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;

        cdo = codeInfo.getCodeInfo("B609", "GW_URL");   //그룹웨어 호출 url
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("groupUrl",cdo.getCodeName());

        return JSP_PATH + "s_str903skrv_kd";
    }

    @RequestMapping(value = "/z_kd/s_sbx900ukrv_kd.do", method = RequestMethod.GET)
    public String s_sbx900ukrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        param.put("S_COMP_CODE",loginVO.getCompCode());

        model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;


        model.addAttribute("COMBO_Z0031", s_sbx900ukrv_kdService.selectZ0031(param));
        model.addAttribute("COMBO_Z0032", s_sbx900ukrv_kdService.selectZ0032(param));

        cdo = codeInfo.getCodeInfo("S012", "2");
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsAutoType",cdo.getRefCode1());

        return JSP_PATH + "s_sbx900ukrv_kd";
    }

    @RequestMapping(value = "/z_kd/s_sbx901ukrv_kd.do", method = RequestMethod.GET)
    public String s_sbx901ukrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        param.put("S_COMP_CODE",loginVO.getCompCode());

        model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;


        model.addAttribute("COMBO_Z0031", s_sbx900ukrv_kdService.selectZ0031(param));
        model.addAttribute("COMBO_Z0032", s_sbx900ukrv_kdService.selectZ0032(param));

        cdo = codeInfo.getCodeInfo("S012", "2");
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsAutoType",cdo.getRefCode1());

        return JSP_PATH + "s_sbx901ukrv_kd";
    }

    @RequestMapping(value = "/z_kd/s_sbx900skrv_kd.do", method = RequestMethod.GET)
    public String s_sbx900skrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        param.put("S_COMP_CODE",loginVO.getCompCode());

        model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;

        List<CodeDetailVO> gsMoneyUnit = codeInfo.getCodeList("B004", "", false);
        for(CodeDetailVO map : gsMoneyUnit) {
            if("Y".equals(map.getRefCode1()))   {
                model.addAttribute("gsMoneyUnit", map.getCodeNo());
            }
        }

        cdo = codeInfo.getCodeInfo("B609", "GW_URL");   //그룹웨어 호출 url
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("groupUrl",cdo.getCodeName());

        return JSP_PATH + "s_sbx900skrv_kd";
    }

    @RequestMapping(value = "/z_kd/s_sbx901skrv_kd.do", method = RequestMethod.GET)
    public String s_sbx901skrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        param.put("S_COMP_CODE",loginVO.getCompCode());

        model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;

        cdo = codeInfo.getCodeInfo("B609", "GW_URL");   //그룹웨어 호출 url
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("groupUrl",cdo.getCodeName());

        return JSP_PATH + "s_sbx901skrv_kd";
    }

    @RequestMapping(value = "/z_kd/s_sbx902skrv_kd.do", method = RequestMethod.GET)
    public String s_sbx902skrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        param.put("S_COMP_CODE",loginVO.getCompCode());

        model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;

        cdo = codeInfo.getCodeInfo("B609", "GW_URL");   //그룹웨어 호출 url
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("groupUrl",cdo.getCodeName());

        return JSP_PATH + "s_sbx902skrv_kd";
    }


    @RequestMapping(value = "/z_kd/s_pmr910skrv_kd.do", method = RequestMethod.GET)
    public String s_pmr910skrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        param.put("S_COMP_CODE",loginVO.getCompCode());

        model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
        model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));

        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;

        List<CodeDetailVO> gsMoneyUnit = codeInfo.getCodeList("B004", "", false);
        for(CodeDetailVO map : gsMoneyUnit) {
            if("Y".equals(map.getRefCode1()))   {
                model.addAttribute("gsMoneyUnit", map.getCodeNo());
            }
        }                                                                                   /* 주화폐단위 */

        return JSP_PATH + "s_pmr910skrv_kd";
    }

    @RequestMapping(value = "/z_kd/s_pmr913ukrv_kd.do", method = RequestMethod.GET)
    public String s_pmr913ukrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        param.put("S_COMP_CODE",loginVO.getCompCode());

        model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;

        List<CodeDetailVO> gsMoneyUnit = codeInfo.getCodeList("B004", "", false);
        for(CodeDetailVO map : gsMoneyUnit) {
            if("Y".equals(map.getRefCode1()))   {
                model.addAttribute("gsMoneyUnit", map.getCodeNo());
            }
        }                                                                                   /* 주화폐단위 */

        return JSP_PATH + "s_pmr913ukrv_kd";
    }

    @RequestMapping(value = "/z_kd/s_pmr913skrv_kd.do", method = RequestMethod.GET)
    public String s_pmr913skrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        param.put("S_COMP_CODE",loginVO.getCompCode());

        model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;

        List<CodeDetailVO> gsMoneyUnit = codeInfo.getCodeList("B004", "", false);
        for(CodeDetailVO map : gsMoneyUnit) {
            if("Y".equals(map.getRefCode1()))   {
                model.addAttribute("gsMoneyUnit", map.getCodeNo());
            }
        }                                                                                   /* 주화폐단위 */

        return JSP_PATH + "s_pmr913skrv_kd";
    }

    @RequestMapping(value = "/z_kd/s_pmr914skrv_kd.do", method = RequestMethod.GET)
    public String s_pmr914skrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        param.put("S_COMP_CODE",loginVO.getCompCode());

        model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
        model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));

        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;

        List<CodeDetailVO> gsMoneyUnit = codeInfo.getCodeList("B004", "", false);
        for(CodeDetailVO map : gsMoneyUnit) {
            if("Y".equals(map.getRefCode1()))   {
                model.addAttribute("gsMoneyUnit", map.getCodeNo());
            }
        }                                                                                   /* 주화폐단위 */

        return JSP_PATH + "s_pmr914skrv_kd";
    }

    @RequestMapping(value = "/z_kd/s_pmr915skrv_kd.do", method = RequestMethod.GET)
    public String s_pmr915skrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        param.put("S_COMP_CODE",loginVO.getCompCode());

        model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
        model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));

        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;

        List<CodeDetailVO> gsMoneyUnit = codeInfo.getCodeList("B004", "", false);
        for(CodeDetailVO map : gsMoneyUnit) {
            if("Y".equals(map.getRefCode1()))   {
                model.addAttribute("gsMoneyUnit", map.getCodeNo());
            }
        }                                                                                   /* 주화폐단위 */

        return JSP_PATH + "s_pmr915skrv_kd";
    }

    @RequestMapping(value = "/z_kd/s_pmr916skrv_kd.do", method = RequestMethod.GET)
    public String s_pmr916skrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        param.put("S_COMP_CODE",loginVO.getCompCode());

        model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
        model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));

        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;

        List<CodeDetailVO> gsMoneyUnit = codeInfo.getCodeList("B004", "", false);
        for(CodeDetailVO map : gsMoneyUnit) {
            if("Y".equals(map.getRefCode1()))   {
                model.addAttribute("gsMoneyUnit", map.getCodeNo());
            }
        }                                                                                   /* 주화폐단위 */

        return JSP_PATH + "s_pmr916skrv_kd";
    }

    @RequestMapping(value = "/z_kd/s_pmr918skrv_kd.do", method = RequestMethod.GET)
    public String s_pmr918skrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        param.put("S_COMP_CODE",loginVO.getCompCode());

        model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
        model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));

        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;

        List<CodeDetailVO> gsMoneyUnit = codeInfo.getCodeList("B004", "", false);
        for(CodeDetailVO map : gsMoneyUnit) {
            if("Y".equals(map.getRefCode1()))   {
                model.addAttribute("gsMoneyUnit", map.getCodeNo());
            }
        }                                                                                   /* 주화폐단위 */

        return JSP_PATH + "s_pmr918skrv_kd";
    }

    @RequestMapping(value = "/z_kd/s_pmr926skrv_kd.do", method = RequestMethod.GET)
    public String s_pmr926skrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        param.put("S_COMP_CODE",loginVO.getCompCode());

        model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
        model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));

        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;

        List<CodeDetailVO> gsMoneyUnit = codeInfo.getCodeList("B004", "", false);
        for(CodeDetailVO map : gsMoneyUnit) {
            if("Y".equals(map.getRefCode1()))   {
                model.addAttribute("gsMoneyUnit", map.getCodeNo());
            }
        }                                                                                   /* 주화폐단위 */

        return JSP_PATH + "s_pmr926skrv_kd";
    }

    @RequestMapping(value = "/z_kd/s_pmr927skrv_kd.do", method = RequestMethod.GET)
    public String s_pmr927skrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        param.put("S_COMP_CODE",loginVO.getCompCode());

        model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
        model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));

        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;

        List<CodeDetailVO> gsMoneyUnit = codeInfo.getCodeList("B004", "", false);
        for(CodeDetailVO map : gsMoneyUnit) {
            if("Y".equals(map.getRefCode1()))   {
                model.addAttribute("gsMoneyUnit", map.getCodeNo());
            }
        }                                                                                   /* 주화폐단위 */

        return JSP_PATH + "s_pmr927skrv_kd";
    }

    @RequestMapping(value = "/z_kd/s_pmr904skrv_kd.do", method = RequestMethod.GET)
    public String s_pmr904skrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        param.put("S_COMP_CODE",loginVO.getCompCode());

        model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
        model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));

        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;

        List<CodeDetailVO> gsMoneyUnit = codeInfo.getCodeList("B004", "", false);
        for(CodeDetailVO map : gsMoneyUnit) {
            if("Y".equals(map.getRefCode1()))   {
                model.addAttribute("gsMoneyUnit", map.getCodeNo());
            }
        }                                                                                   /* 주화폐단위 */

        return JSP_PATH + "s_pmr904skrv_kd";
    }

    /**
     * 공정등록
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/z_kd/s_pbs070ukrv_kd.do")
    public String s_pbs070ukrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        param.put("S_COMP_CODE",loginVO.getCompCode());
        model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
        model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));

        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;

        cdo = codeInfo.getCodeInfo("M400", "2");
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("ConfirmPeriod", cdo.getRefCode1());     // MRP 관련 기준 설정 (확정기간)

        cdo = codeInfo.getCodeInfo("M400", "3");
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("PrePeriod", cdo.getRefCode1());         // MRP 관련 기준 설정 (예시기간)

        cdo = codeInfo.getCodeInfo("P005", "2");
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsAutoYN", cdo.getRefCode1());

        cdo = codeInfo.getCodeInfo("P121", "01");
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsChildStockPopYN", cdo.getRefCode1());

        List<CodeDetailVO> gsMoldCode = codeInfo.getCodeList("WP01", "", false);            // 작지설비 관리여부
        for(CodeDetailVO map : gsMoldCode) {
            if("Y".equals(map.getRefCode1()))   {
                model.addAttribute("gsMoldCode", map.getCodeNo());
            }
        }

        List<CodeDetailVO> gsEquipCode = codeInfo.getCodeList("WP02", "", false);            // 작지금형 관리여부
        for(CodeDetailVO map : gsEquipCode) {
            if("Y".equals(map.getRefCode1()))   {
                model.addAttribute("gsEquipCode", map.getCodeNo());
            }
        }

        List<CodeDetailVO> gsProgWorkCode = codeInfo.getCodeList("WB27", "", false);   //공정등록기준
        for(CodeDetailVO map : gsProgWorkCode) {
            if("Y".equals(map.getRefCode1()))   {
                model.addAttribute("gsProgWorkCode", map.getCodeNo());
            }
        }

        return JSP_PATH + "s_pbs070ukrv_kd";
    }

    /**
     * 공정수순등록
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/z_kd/s_pbs071ukrv_kd.do")
    public String s_pbs071ukrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        param.put("S_COMP_CODE",loginVO.getCompCode());

        model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
        model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));
        model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
        model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
        model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));

        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;


        List<CodeDetailVO> gsProgWorkCode = codeInfo.getCodeList("WB27", "", false);   //공정등록기준
        for(CodeDetailVO map : gsProgWorkCode) {
            if("Y".equals(map.getRefCode1()))   {
                model.addAttribute("gsProgWorkCode", map.getCodeNo());
            }
        }

        List<CodeDetailVO> gsMoldCode = codeInfo.getCodeList("WP01", "", false);            // 작지설비 관리여부
        for(CodeDetailVO map : gsMoldCode) {
            if("Y".equals(map.getRefCode1()))   {
                model.addAttribute("gsMoldCode", map.getCodeNo());
            }
        }

        List<CodeDetailVO> gsEquipCode = codeInfo.getCodeList("WP02", "", false);            // 작지금형 관리여부
        for(CodeDetailVO map : gsEquipCode) {
            if("Y".equals(map.getRefCode1()))   {
                model.addAttribute("gsEquipCode", map.getCodeNo());
            }
        }


        return JSP_PATH+"s_pbs071ukrv_kd";
    }

    /**
     * 설비마스터등록
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/z_kd/s_peq100ukrv_kd.do")
    public String s_peq100ukrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        param.put("S_COMP_CODE",loginVO.getCompCode());

        model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
        model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));
        model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
        model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
        model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));

        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;



        return JSP_PATH+"s_peq100ukrv_kd";
    }

    /**
     * 설비부품등록
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/z_kd/s_peq101ukrv_kd.do")
    public String s_peq101ukrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        param.put("S_COMP_CODE",loginVO.getCompCode());

        model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
        model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));
        model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
        model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
        model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));

        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;



        return JSP_PATH+"s_peq101ukrv_kd";
    }

    /**
     * 설비부품현황
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/z_kd/s_peq101skrv_kd.do")
    public String s_peq101skrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        param.put("S_COMP_CODE",loginVO.getCompCode());

        model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
        model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));
        model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
        model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
        model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));

        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;



        return JSP_PATH+"s_peq101skrv_kd";
    }

    /**
     * 금형마스터등록
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/z_kd/s_pmd100ukrv_kd.do")
    public String s_pmd100ukrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        param.put("S_COMP_CODE",loginVO.getCompCode());

        model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
        model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));
        model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
        model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
        model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));

        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;



        return JSP_PATH+"s_pmd100ukrv_kd";
    }

    /**
     * 수리의뢰등록
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/z_kd/s_pmd200ukrv_kd.do")
    public String s_pmd200ukrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        param.put("S_COMP_CODE",loginVO.getCompCode());

        model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
        model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));
        model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
        model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
        model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));

        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;

        cdo = codeInfo.getCodeInfo("S012", "2");
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsAutoType",cdo.getRefCode1());      //Y:의뢰번호(txtOrderNum) lock,disable

        cdo = codeInfo.getCodeInfo("B609", "GW_URL");   //그룹웨어 호출 url
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("groupUrl",cdo.getCodeName());

        return JSP_PATH+"s_pmd200ukrv_kd";
    }

    /**
     * 수리의뢰서조회
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/z_kd/s_pmd200skrv_kd.do")
    public String s_pmd200skrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        param.put("S_COMP_CODE",loginVO.getCompCode());

        model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
        model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));
        model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
        model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
        model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));

        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;

        cdo = codeInfo.getCodeInfo("S012", "2");
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsAutoType",cdo.getRefCode1());      //Y:의뢰번호(txtOrderNum) lock,disable

        return JSP_PATH+"s_pmd200skrv_kd";
    }

    /**
     * 수리의뢰이력등록
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/z_kd/s_pmd201ukrv_kd.do")
    public String s_pmd201ukrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        param.put("S_COMP_CODE",loginVO.getCompCode());

        model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
        model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));
        model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
        model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
        model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));

        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;

        cdo = codeInfo.getCodeInfo("S012", "2");
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsAutoType",cdo.getRefCode1());      //Y:의뢰번호(txtOrderNum) lock,disable

        return JSP_PATH+"s_pmd201ukrv_kd";
    }

    /**
     * 금형타발수현황
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/z_kd/s_pmd900skrv_kd.do")
    public String s_pmd900skrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        param.put("S_COMP_CODE",loginVO.getCompCode());

        model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
        model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));
        model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
        model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
        model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));

        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;

        cdo = codeInfo.getCodeInfo("S012", "2");
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsAutoType",cdo.getRefCode1());      //Y:의뢰번호(txtOrderNum) lock,disable

        return JSP_PATH+"s_pmd900skrv_kd";
    }

    /**
     * 금형관리대장조회
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/z_kd/s_pmd901skrv_kd.do")
    public String s_pmd901skrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        param.put("S_COMP_CODE",loginVO.getCompCode());

        model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
        model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));
        model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
        model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
        model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));

        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;

        cdo = codeInfo.getCodeInfo("S012", "2");
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsAutoType",cdo.getRefCode1());      //Y:의뢰번호(txtOrderNum) lock,disable

        return JSP_PATH+"s_pmd901skrv_kd";
    }

    /**
     * 과거차문제점관리대장

     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/z_kd/s_zbb300ukrv_kd.do")
    public String s_zbb300ukrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        param.put("S_COMP_CODE",loginVO.getCompCode());

        model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
        model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));
        model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
        model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
        model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));

        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;

        cdo = codeInfo.getCodeInfo("S012", "2");
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsAutoType",cdo.getRefCode1());      //Y:의뢰번호(txtOrderNum) lock,disable

        return JSP_PATH+"s_zbb300ukrv_kd";
    }

    /**
     * 과거차문제점관리현황

     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/z_kd/s_zbb300skrv_kd.do")
    public String s_zbb300skrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        param.put("S_COMP_CODE",loginVO.getCompCode());

        model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
        model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));
        model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
        model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
        model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));

        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;

        cdo = codeInfo.getCodeInfo("S012", "2");
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsAutoType",cdo.getRefCode1());      //Y:의뢰번호(txtOrderNum) lock,disable

        return JSP_PATH+"s_zbb300skrv_kd";
    }

    /**
     * 도면관리대장
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/z_kd/s_zbb500ukrv_kd.do")
    public String s_zbb500ukrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        param.put("S_COMP_CODE",loginVO.getCompCode());

        model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
        model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));
        model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
        model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
        model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));

        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;

        cdo = codeInfo.getCodeInfo("S012", "2");
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsAutoType",cdo.getRefCode1());      //Y:의뢰번호(txtOrderNum) lock,disable

        return JSP_PATH+"s_zbb500ukrv_kd";
    }

    /**
     * 도면관리현황
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/z_kd/s_zbb500skrv_kd.do")
    public String s_zbb500skrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        param.put("S_COMP_CODE",loginVO.getCompCode());

        model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
        model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));
        model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
        model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
        model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));

        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;

        cdo = codeInfo.getCodeInfo("S012", "2");
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsAutoType",cdo.getRefCode1());      //Y:의뢰번호(txtOrderNum) lock,disable

        return JSP_PATH+"s_zbb500skrv_kd";
    }

    /**
     * 기술문서관리대장
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/z_kd/s_zbb400ukrv_kd.do")
    public String s_zbb400ukrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        param.put("S_COMP_CODE",loginVO.getCompCode());

        model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
        model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));
        model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
        model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
        model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));

        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;

        cdo = codeInfo.getCodeInfo("S012", "2");
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsAutoType",cdo.getRefCode1());      //Y:의뢰번호(txtOrderNum) lock,disable

        return JSP_PATH+"s_zbb400ukrv_kd";
    }

    /**
     * 기술문서관리현황
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/z_kd/s_zbb400skrv_kd.do")
    public String s_zbb400skrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        param.put("S_COMP_CODE",loginVO.getCompCode());

        model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
        model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));
        model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
        model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
        model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));

        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;

        cdo = codeInfo.getCodeInfo("S012", "2");
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsAutoType",cdo.getRefCode1());      //Y:의뢰번호(txtOrderNum) lock,disable

        return JSP_PATH+"s_zbb400skrv_kd";
    }

    /**
     * 제조재질규격대장

     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/z_kd/s_zbb600ukrv_kd.do")
    public String s_zbb600ukrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        param.put("S_COMP_CODE",loginVO.getCompCode());

        model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
        model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));
        model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
        model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
        model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));

        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;

        cdo = codeInfo.getCodeInfo("S012", "2");
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsAutoType",cdo.getRefCode1());      //Y:의뢰번호(txtOrderNum) lock,disable

		model.addAttribute("gsAuthorityLevel", loginVO.getAuthorityLevel());

        return JSP_PATH+"s_zbb600ukrv_kd";
    }

    /**
     * 제조재질규격조회

     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/z_kd/s_zbb600skrv_kd.do")
    public String s_zbb600skrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        param.put("S_COMP_CODE",loginVO.getCompCode());

        model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
        model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));
        model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
        model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
        model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));

        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;

        cdo = codeInfo.getCodeInfo("S012", "2");
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsAutoType",cdo.getRefCode1());      //Y:의뢰번호(txtOrderNum) lock,disable

        return JSP_PATH+"s_zbb600skrv_kd";
    }

    /**
     * ISIR관리등록
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/z_kd/s_zcc100ukrv_kd.do")
    public String s_zcc100ukrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        param.put("S_COMP_CODE",loginVO.getCompCode());

        model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
        model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));
        model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
        model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
        model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));

        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;

        cdo = codeInfo.getCodeInfo("S012", "2");
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsAutoType",cdo.getRefCode1());      //Y:의뢰번호(txtOrderNum) lock,disable

        return JSP_PATH+"s_zcc100ukrv_kd";
    }

    /**
     * ISIR관리현황
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/z_kd/s_zcc100skrv_kd.do")
    public String s_zcc100skrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        param.put("S_COMP_CODE",loginVO.getCompCode());

        model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
        model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));
        model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
        model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
        model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));

        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;

        cdo = codeInfo.getCodeInfo("S012", "2");
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsAutoType",cdo.getRefCode1());      //Y:의뢰번호(txtOrderNum) lock,disable

        return JSP_PATH+"s_zcc100skrv_kd";
    }

    /**
     * 견적서등록
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/z_kd/s_zcc200ukrv_kd.do")
    public String s_zcc200ukrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        param.put("S_COMP_CODE",loginVO.getCompCode());

        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;

        List<CodeDetailVO> gsMoneyUnit = codeInfo.getCodeList("B004", "", false);
        for(CodeDetailVO map : gsMoneyUnit) {
            if("Y".equals(map.getRefCode1()))   {
                model.addAttribute("gsMoneyUnit", map.getCodeNo());
            }
        }                                                                                   /* 주화폐단위 */

        cdo = codeInfo.getCodeInfo("B609", "GW_URL");   //그룹웨어 호출 url
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("groupUrl",cdo.getCodeName());

        cdo = codeInfo.getCodeInfo("S012", "2");
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsAutoType",cdo.getRefCode1());      //Y:의뢰번호(txtOrderNum) lock,disable

        return JSP_PATH+"s_zcc200ukrv_kd";
    }

    /**
     * 견적서조회
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/z_kd/s_zcc200skrv_kd.do")
    public String s_zcc200skrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        param.put("S_COMP_CODE",loginVO.getCompCode());

        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;

        model.addAttribute("COMBO_GW_STATUS", comboService.fnGetGwStatus(param));

        cdo = codeInfo.getCodeInfo("B609", "GW_URL");   //그룹웨어 호출 url
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("groupUrl",cdo.getCodeName());

        return JSP_PATH+"s_zcc200skrv_kd";
    }

    @RequestMapping(value = "/z_kd/s_pmp200ukrv_kd.do")
    public String s_pmp200ukrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");


        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;

        param.put("S_COMP_CODE",loginVO.getCompCode());
        model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
        model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
        model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
        model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));

        // BOM PATH 관리여부
        int i = 0;
        List<CodeDetailVO> gsBomPathYN = codeInfo.getCodeList("B082", "", false);
        for(CodeDetailVO map : gsBomPathYN) {
            if("Y".equals(map.getRefCode1())||"y".equals(map.getRefCode1()))    {
                model.addAttribute("gsShowBtnReserveYN", map.getCodeNo());
                i++;  // RecordCount
            }
        }
        if(i == 0) model.addAttribute("gsShowBtnReserveYN", "N");

        //출고요청 승인방식(수동/자동승인) 공통코드에서 가져오기(P118)
        List<CodeDetailVO> gsAutoAgree = codeInfo.getCodeList("P118", "", false);
        for(CodeDetailVO map : gsAutoAgree) {
            if("Y".equals(map.getRefCode1())||"y".equals(map.getRefCode1()))    {
                model.addAttribute("gsAutoAgree", map.getCodeNo());
            }
        }

        //자동채번 공통코드에서 가져오기(P005)
        cdo = codeInfo.getCodeInfo("P005", "3");
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsAutotype",cdo.getRefCode1());

        //승인자 ID 가져오기(P119)에서 출고요청자에 따른 승인자ID 가져오기
        /*
         * List<CodeDetailVO> gsExchgRegYN = codeInfo.getCodeList("P119", "", false);
        for(CodeDetailVO map : gsExchgRegYN)    {
            if(사용자명.equals(map.getCodeName()))  {
                model.addAttribute("gsAgreePrsn", map.getRefCode1());
            }
        }
        */

        List<CodeDetailVO> gsUsePabStockYn = codeInfo.getCodeList("I014", "", false);//가용재고 체크여부
        for(CodeDetailVO map : gsUsePabStockYn) {
            if("Y".equals(map.getRefCode1()))   {
                model.addAttribute("gsUsePabStockYn", map.getCodeNo());
            }
        }

        cdo = codeInfo.getCodeInfo("B609", "GW_URL");   //그룹웨어 호출 url
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("groupUrl",cdo.getCodeName());
//        if(!ObjUtils.isEmpty(cdo)){
//            model.addAttribute("GW_URL",cdo.getCodeName());
//        }else {
//            model.addAttribute("GW_URL", "");
//        }

        return JSP_PATH + "s_pmp200ukrv_kd";
    }

    /**
     * 작업실적 등록
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/z_kd/s_pmr100ukrv_kd.do")
    public String s_pmr100ukrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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


        model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
        model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
        model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
        model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));
        model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

        cdo = codeInfo.getCodeInfo("B090", "PB");
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsManageLotNoYN",cdo.getRefCode1()); // 작업지시와 생산실적LOT 연계여부 설정 값 알기

        cdo = codeInfo.getCodeInfo("P000", "6");
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsChkProdtDateYN",cdo.getRefCode1()); // 작업실적 등록시 착수예정일 체크여부

        cdo = codeInfo.getCodeInfo("P100", "1");                                              // 생산완료시점 (100%)
        if(!ObjUtils.isEmpty(cdo)){
            model.addAttribute("glEndRate",cdo.getRefCode1());
        }

        cdo = codeInfo.getCodeInfo("B084", "D");                                              // 재고대체 합산
        if(!ObjUtils.isEmpty(cdo)){
            model.addAttribute("gsSumTypeCell",cdo.getRefCode1());
        }else {
            model.addAttribute("gsSumTypeCell", "N");
        }

        List<CodeDetailVO> gsMoldCode = codeInfo.getCodeList("WP01", "", false);            // 작지설비 관리여부
        for(CodeDetailVO map : gsMoldCode) {
            if("Y".equals(map.getRefCode1()))   {
                model.addAttribute("gsMoldCode", map.getCodeNo());
            }
        }

        List<CodeDetailVO> gsEquipCode = codeInfo.getCodeList("WP02", "", false);            // 작지금형 관리여부
        for(CodeDetailVO map : gsEquipCode) {
            if("Y".equals(map.getRefCode1()))   {
                model.addAttribute("gsEquipCode", map.getCodeNo());
            }
        }



        return JSP_PATH + "s_pmr100ukrv_kd";
    }

    @RequestMapping(value = "/z_kd/s_ppl111ukrv_kd.do")
    public String s_ppl111ukrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        param.put("S_COMP_CODE",loginVO.getCompCode());
        model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;

        List<Map<String, Object>> frWeekList = s_ppl111ukrv_kdService.selectFromWeek(param);        // 시작주차 조회
        model.addAttribute("frWeekList",ObjUtils.toJsonStr(frWeekList));

        List<Map<String, Object>> toWeekList = s_ppl111ukrv_kdService.selectToWeek(param);        // 마지막주차 조회
        model.addAttribute("toWeekList",ObjUtils.toJsonStr(toWeekList));

        model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
        model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
        model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
        model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));


        cdo = codeInfo.getCodeInfo("S048", "PP");
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsManageTimeYN",            cdo.getRefCode1());

        return JSP_PATH + "s_ppl111ukrv_kd";
    }

    /**
     * 일괄제조오더 등록
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/z_kd/s_pmp100ukrv_kd.do")
    public String s_pmp100ukrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

        return JSP_PATH + "s_pmp100ukrv_kd";
    }

    /**
     * 긴급작업지시 등록
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/z_kd/s_pmp110ukrv_kd.do")
    public String s_pmp110ukrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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
        model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));
        cdo = codeInfo.getCodeInfo("P005", "2");
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsAutoNo", cdo.getRefCode1());     // 생산자동채번유무

        cdo = codeInfo.getCodeInfo("P000", "3");
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsBadInputYN",cdo.getRefCode1());  // 자동입고시 불량입고 반영여부

        cdo = codeInfo.getCodeInfo("P121", "01");
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsChildStockPopYN",cdo.getRefCode1());  // 자재부족팝업 호출여부

        List<CodeDetailVO> gsMoldCode = codeInfo.getCodeList("WP01", "", false);            // 작지설비 관리여부
        for(CodeDetailVO map : gsMoldCode) {
            if("Y".equals(map.getRefCode1()))   {
                model.addAttribute("gsMoldCode", map.getCodeNo());
            }
        }

        List<CodeDetailVO> gsEquipCode = codeInfo.getCodeList("WP02", "", false);            // 작지금형 관리여부
        for(CodeDetailVO map : gsEquipCode) {
            if("Y".equals(map.getRefCode1()))   {
                model.addAttribute("gsEquipCode", map.getCodeNo());
            }
        }

        int i = 0;
        List<CodeDetailVO> gsBomPathYN = codeInfo.getCodeList("B082", "", false);   // BOM PATH 관리여부
        for(CodeDetailVO map : gsBomPathYN) {
            if("Y".equals(map.getRefCode1())||"y".equals(map.getRefCode1()))    {
                model.addAttribute("gsShowBtnReserveYN", map.getCodeNo());

                i++;  // RecordCount
            }
        }
        if(i == 0) model.addAttribute("gsShowBtnReserveYN", "N");

        cdo = codeInfo.getCodeInfo("B090", "PA");   //                              // LOT 관리기준 설정 재고와 작업지시 LOT 연계여부
        if(!ObjUtils.isEmpty(cdo)){
            model.addAttribute("gsLotNoInputMethod",cdo.getRefCode1());
            model.addAttribute("gsLotNoEssential",cdo.getRefCode2());
            model.addAttribute("gsEssItemAccount",cdo.getRefCode3());
        }

        cdo = codeInfo.getCodeInfo("P000", "4");
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsGoodsInputYN",cdo.getRefCode1());  // 긴급작지시 상품입력 가능여부

        cdo = codeInfo.getCodeInfo("S012", "2");
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsAutoType",cdo.getRefCode1());      //Y:의뢰번호(txtOrderNum) lock,disable

        return JSP_PATH + "s_pmp110ukrv_kd";


    }

    /**
     * 물품의뢰등록
     * @param loginVO
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/z_kd/s_mre100ukrv_kd.do",method = RequestMethod.GET)
    public String s_mre100ukrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {

        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;


        List<CodeDetailVO> gsDefaultMoney = codeInfo.getCodeList("B004", "", false);        //화폐단위(기본화폐단위설정
        for(CodeDetailVO map : gsDefaultMoney)  {
            if("Y".equals(map.getRefCode1()) || "y".equals(map.getRefCode1()))  {
                model.addAttribute("gsDefaultMoney", map.getCodeNo());
            }
        }

        cdo = codeInfo.getCodeInfo("M101", "1");
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsAutoType",cdo.getRefCode1());

        cdo = codeInfo.getCodeInfo("B609", "GW_URL");   //그룹웨어 호출 url
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("groupUrl",cdo.getCodeName());


        System.out.println("========s_s_mre101ukrv_kd_kd ===========================");
        return JSP_PATH + "s_mre100ukrv_kd";
    }


    /**
     * 원산지등록
     * @param loginVO
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/z_kd/s_mtr903ukrv_kd.do",method = RequestMethod.GET)
    public String s_mtr903ukrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {

        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;


        List<CodeDetailVO> gsDefaultMoney = codeInfo.getCodeList("B004", "", false);        //화폐단위(기본화폐단위설정
        for(CodeDetailVO map : gsDefaultMoney)  {
            if("Y".equals(map.getRefCode1()) || "y".equals(map.getRefCode1()))  {
                model.addAttribute("gsDefaultMoney", map.getCodeNo());
            }
        }

        cdo = codeInfo.getCodeInfo("M101", "1");
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsAutoType",cdo.getRefCode1());

        System.out.println("========s_s_mre101ukrv_kd_kd ===========================");
        return JSP_PATH + "s_mtr903ukrv_kd";
    }

    /**
     * 원산지조회
     * @param loginVO
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/z_kd/s_mtr903skrv_kd.do",method = RequestMethod.GET)
    public String s_mtr903skrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {

        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;


        List<CodeDetailVO> gsDefaultMoney = codeInfo.getCodeList("B004", "", false);        //화폐단위(기본화폐단위설정
        for(CodeDetailVO map : gsDefaultMoney)  {
            if("Y".equals(map.getRefCode1()) || "y".equals(map.getRefCode1()))  {
                model.addAttribute("gsDefaultMoney", map.getCodeNo());
            }
        }

        cdo = codeInfo.getCodeInfo("M101", "1");
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsAutoType",cdo.getRefCode1());

        System.out.println("========s_s_mre101ukrv_kd_kd ===========================");
        return JSP_PATH + "s_mtr903skrv_kd";
    }

    /**
     * 개발일정등록
     * @param loginVO
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/z_kd/s_zaa100ukrv_kd.do",method = RequestMethod.GET)
    public String s_zaa100ukrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {

        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;


        List<CodeDetailVO> gsDefaultMoney = codeInfo.getCodeList("B004", "", false);        //화폐단위(기본화폐단위설정
        for(CodeDetailVO map : gsDefaultMoney)  {
            if("Y".equals(map.getRefCode1()) || "y".equals(map.getRefCode1()))  {
                model.addAttribute("gsDefaultMoney", map.getCodeNo());
            }
        }

        cdo = codeInfo.getCodeInfo("M101", "1");
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsAutoType",cdo.getRefCode1());

        return JSP_PATH + "s_zaa100ukrv_kd";
    }

    /**
     * 개발일정수정
     * @param loginVO
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/z_kd/s_zaa110ukrv_kd.do",method = RequestMethod.GET)
    public String s_zaa110ukrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {

        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;


        List<CodeDetailVO> gsDefaultMoney = codeInfo.getCodeList("B004", "", false);        //화폐단위(기본화폐단위설정
        for(CodeDetailVO map : gsDefaultMoney)  {
            if("Y".equals(map.getRefCode1()) || "y".equals(map.getRefCode1()))  {
                model.addAttribute("gsDefaultMoney", map.getCodeNo());
            }
        }

        cdo = codeInfo.getCodeInfo("M101", "1");
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsAutoType",cdo.getRefCode1());

        return JSP_PATH + "s_zaa110ukrv_kd";
    }

    /**
     * 개발일정등록
     * @param loginVO
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/z_kd/s_zaa100skrv_kd.do",method = RequestMethod.GET)
    public String s_zaa100skrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {

        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;


        List<CodeDetailVO> gsDefaultMoney = codeInfo.getCodeList("B004", "", false);        //화폐단위(기본화폐단위설정
        for(CodeDetailVO map : gsDefaultMoney)  {
            if("Y".equals(map.getRefCode1()) || "y".equals(map.getRefCode1()))  {
                model.addAttribute("gsDefaultMoney", map.getCodeNo());
            }
        }

        cdo = codeInfo.getCodeInfo("M101", "1");
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsAutoType",cdo.getRefCode1());

        return JSP_PATH + "s_zaa100skrv_kd";
    }

    @RequestMapping(value = "/z_kd/s_zaa300skrv_kd.do",method = RequestMethod.GET)
    public String s_zaa300skrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {

        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;


        List<CodeDetailVO> gsDefaultMoney = codeInfo.getCodeList("B004", "", false);        //화폐단위(기본화폐단위설정
        for(CodeDetailVO map : gsDefaultMoney)  {
            if("Y".equals(map.getRefCode1()) || "y".equals(map.getRefCode1()))  {
                model.addAttribute("gsDefaultMoney", map.getCodeNo());
            }
        }

        cdo = codeInfo.getCodeInfo("M101", "1");
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsAutoType",cdo.getRefCode1());

        return JSP_PATH + "s_zaa300skrv_kd";
    }

    /**
     * 수출관세환급 등록
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/z_kd/s_tex900ukrv_kd.do")
    public String s_tex900ukrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;

        cdo = codeInfo.getCodeInfo("B609", "GW_URL");   //그룹웨어 호출 url
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("groupUrl",cdo.getCodeName());

        param.put("S_COMP_CODE",loginVO.getCompCode());

        return JSP_PATH + "s_tex900ukrv_kd";
    }

    /**
     * 수출관세환급 조회
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/z_kd/s_tex900skrv_kd.do")
    public String s_tex900skrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        param.put("S_COMP_CODE",loginVO.getCompCode());

        return JSP_PATH + "s_tex900skrv_kd";
    }

    /**
     * local 판가대비 NEGO가
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/z_kd/s_ten900ukrv_kd.do")
    public String s_ten900ukrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;

        param.put("S_COMP_CODE",loginVO.getCompCode());

        cdo = codeInfo.getCodeInfo("B609", "GW_URL");   //그룹웨어 호출 url
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("groupUrl",cdo.getCodeName());

        return JSP_PATH + "s_ten900ukrv_kd";
    }

    /** dbhan
     * 영업>수출관리
     * 최종단가대비 수출가등록
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/z_kd/s_ttr900ukrv_kd.do")
    public String s_ttr900ukrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;

        param.put("S_COMP_CODE",loginVO.getCompCode());

        cdo = codeInfo.getCodeInfo("B609", "GW_URL");   //그룹웨어 호출 url
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("groupUrl",cdo.getCodeName());

        return JSP_PATH + "s_ttr900ukrv_kd";
    }

    /** dbhan
     * 구매/자재>수입관리
     * 관세 환급내역등록
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/z_kd/s_tix902ukrv_kd.do")
    public String s_tix902ukrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        param.put("S_COMP_CODE",loginVO.getCompCode());

        return JSP_PATH + "s_tix902ukrv_kd";
    }

    /** dbhan
     * 구매/자재>수입관리
     * 관세 환급현황(조회)
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/z_kd/s_tix902skrv_kd.do")
    public String s_tix902skrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        param.put("S_COMP_CODE",loginVO.getCompCode());

        return JSP_PATH + "s_tix902skrv_kd";
    }

    /** dbhan
     * 구매/자재>수불관리
     * 입고보고서현황(조회)
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/z_kd/s_mtr902skrv_kd.do")
    public String s_mtr902skrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;
        param.put("S_COMP_CODE",loginVO.getCompCode());

        cdo = codeInfo.getCodeInfo("B609", "GW_URL");   //그룹웨어 호출 url
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("groupUrl",cdo.getCodeName());


        return JSP_PATH + "s_mtr902skrv_kd";
    }


    /** dbhan
     * 구매/자재>수불관리
     * 자재 구매계획 및 실적현황 조회
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/z_kd/s_mtr900skrv_kd.do")
    public String s_mtr900skrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        param.put("S_COMP_CODE",loginVO.getCompCode());

        return JSP_PATH + "s_mtr900skrv_kd";
    }


    /** dbhan
     * 구매/자재>Configuration
     * 2차 협력사 외주상품 조회
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/z_kd/s_mrt900skrv_kd.do")
    public String s_mrt900skrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        param.put("S_COMP_CODE",loginVO.getCompCode());

        return JSP_PATH + "s_mrt900skrv_kd";
    }

    /** dbhan
     * 구매/자재>수불관리
     * 매입처별 수불현황조회
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/z_kd/s_map900skrv_kd.do")
    public String s_map900skrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        param.put("S_COMP_CODE",loginVO.getCompCode());

        return JSP_PATH + "s_map900skrv_kd";
    }

    /** dbhan
     * 재고>재고현황관리
     * 일재고현황
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/z_kd/s_biv901skrv_kd.do")
    public String s_biv901skrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        param.put("S_COMP_CODE",loginVO.getCompCode());

        return JSP_PATH + "s_biv901skrv_kd";
    }










    /**
     * 바코드출력
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/z_kd/s_pda010rkrv_kd.do", method = RequestMethod.GET)
    public String s_pda010rkrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        param.put("S_COMP_CODE",loginVO.getCompCode());

        model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

        return JSP_PATH + "s_pda010rkrv_kd";
    }




    // Location바코드 출력
    @RequestMapping(value="/z_kd/printBarcode1", method = RequestMethod.POST)
    public  ModelAndView printBarcode1( ExtHtttprequestParam _req) throws Exception {

          //Map pData = _req.getParameterMap();

          ObjectMapper mapper = new ObjectMapper();
          List<Map> paramList = mapper.readValue( ObjUtils.getSafeString((_req.getP("data"))),
                  TypeFactory.defaultInstance().constructCollectionType(List.class,   Map.class));

          File dir = new File("C:/OmegaPlusPDA");
          if(!dir.exists())  dir.mkdir();
          FileDownloadInfo fInfo = new FileDownloadInfo("C:/OmegaPlusPDA", "locationLabel.txt");

          FileOutputStream fos = new FileOutputStream(fInfo.getFile());
          String data = "";
          for(Map param: paramList) {

              if(param.get("PRINT_YN").toString().equals("true")){      // 출력여부..
                  data += param.get("WH_CODE") + "|" + param.get("WH_NAME") + "|" + param.get("WH_CELL_CODE") + "|" + param.get("PRINT_CNT") + "\r\n";
              }

          }
          byte[] bytesArray = data.getBytes("euckr");
          fos.write(bytesArray);

          fos.flush();
          fos.close();
          fInfo.setStream(fos);

          return ViewHelper.getFileDownloadView(fInfo);
      }

      // 금형바코드 출력
      @RequestMapping(value="/z_kd/printBarcode2", method = RequestMethod.POST)
      public  ModelAndView printBarcode2( ExtHtttprequestParam _req) throws Exception {

            //Map pData = _req.getParameterMap();

            ObjectMapper mapper = new ObjectMapper();
            List<Map> paramList = mapper.readValue( ObjUtils.getSafeString((_req.getP("data"))),
                    TypeFactory.defaultInstance().constructCollectionType(List.class,   Map.class));

            File dir = new File("C:/OmegaPlusPDA");
            if(!dir.exists())  dir.mkdir();
            FileDownloadInfo fInfo = new FileDownloadInfo("C:/OmegaPlusPDA", "moldLabel.txt");

            FileOutputStream fos = new FileOutputStream(fInfo.getFile());
            String data = "";
            for(Map param: paramList) {

                if(param.get("PRINT_YN").toString().equals("true")){      // 출력여부..
                    data += param.get("MOLD_CODE") + "|" + param.get("OEM_ITEM_CODE") + "|" + param.get("CAR_TYPE") + "|" + param.get("PROG_WORK_NAME") + "|" + param.get("DATE_MAKE") + "|" + param.get("MOLD_MTL") + "|" + param.get("MOLD_SPEC") + "|" + param.get("PRINT_CNT") + "\r\n";
                }

            }
            byte[] bytesArray = data.getBytes("euckr");
            fos.write(bytesArray);

            fos.flush();
            fos.close();
            fInfo.setStream(fos);

            return ViewHelper.getFileDownloadView(fInfo);
        }

        // 품목LOT바코드 출력(제품형)
        @RequestMapping(value="/z_kd/printBarcode3", method = RequestMethod.POST)
        public  ModelAndView printBarcode3( ExtHtttprequestParam _req) throws Exception {

              //Map pData = _req.getParameterMap();

              ObjectMapper mapper = new ObjectMapper();
              List<Map> paramList = mapper.readValue( ObjUtils.getSafeString((_req.getP("data"))),
                      TypeFactory.defaultInstance().constructCollectionType(List.class,   Map.class));

              File dir = new File("C:/OmegaPlusPDA");
              if(!dir.exists())  dir.mkdir();
              FileDownloadInfo fInfo = new FileDownloadInfo("C:/OmegaPlusPDA", "itemLotLabel1.txt");

              FileOutputStream fos = new FileOutputStream(fInfo.getFile());
              String data = "";
              for(Map param: paramList) {
                  String floatQty = (String)param.get("QTY");
                  if(param.get("PRINT_YN").toString().equals("true")){      // 출력여부..
                      data += param.get("ITEM_CODE") + "|" + param.get("LOT_NO") + "|" + param.get("ITEM_NAME") + "|" + param.get("SPEC") + "|" + param.get("OEM_ITEM_CODE") + "|" + floatQty + "|" + param.get("STOCK_UNIT") + "|" + param.get("PRINT_CNT") + "\r\n";
                  }

              }
              byte[] bytesArray = data.getBytes("euckr");
              fos.write(bytesArray);

              fos.flush();
              fos.close();
              fInfo.setStream(fos);

              return ViewHelper.getFileDownloadView(fInfo);
       }

     // 품목LOT바코드 출력(원자재형)
        @RequestMapping(value="/z_kd/printBarcode4", method = RequestMethod.POST)
        public  ModelAndView printBarcode4( ExtHtttprequestParam _req) throws Exception {

              //Map pData = _req.getParameterMap();

              ObjectMapper mapper = new ObjectMapper();
              List<Map> paramList = mapper.readValue( ObjUtils.getSafeString((_req.getP("data"))),
                      TypeFactory.defaultInstance().constructCollectionType(List.class,   Map.class));

              File dir = new File("C:/OmegaPlusPDA");
              if(!dir.exists())  dir.mkdir();
              FileDownloadInfo fInfo = new FileDownloadInfo("C:/OmegaPlusPDA", "itemLotLabel2.txt");

              FileOutputStream fos = new FileOutputStream(fInfo.getFile());
              String data = "";
              for(Map param: paramList) {
                  String floatQty = (String)param.get("QTY");
                  if(param.get("PRINT_YN").toString().equals("true")){      // 출력여부..
                      data += param.get("ITEM_CODE") + "|" + param.get("LOT_NO") + "|" + param.get("ITEM_NAME") + "|" + param.get("SPEC") + "|" + param.get("OEM_ITEM_CODE") + "|" + floatQty + "|" + param.get("STOCK_UNIT") + "|" + param.get("PRINT_CNT") + "\r\n";
                  }

              }
              byte[] bytesArray = data.getBytes("euckr");
              fos.write(bytesArray);

              fos.flush();
              fos.close();
              fInfo.setStream(fos);

              return ViewHelper.getFileDownloadView(fInfo);
       }

        /**
         * 바코드출력
         * @return
         * @throws Exception
         */
        @RequestMapping(value = "/z_kd/s_pda020rkrv_kd.do", method = RequestMethod.GET)
        public String s_pda020rkrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
            final String[] searchFields = {  };
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");

            param.put("S_COMP_CODE",loginVO.getCompCode());

            model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

            return JSP_PATH + "s_pda020rkrv_kd";
        }

     // 구매입고바코드 출력(제품형)
        @RequestMapping(value="/z_kd/matlPrintBarcode1", method = RequestMethod.POST)
        public  ModelAndView matlPrintBarcode1( ExtHtttprequestParam _req) throws Exception {

              //Map pData = _req.getParameterMap();

              ObjectMapper mapper = new ObjectMapper();
              List<Map> paramList = mapper.readValue( ObjUtils.getSafeString((_req.getP("data"))),
                      TypeFactory.defaultInstance().constructCollectionType(List.class,   Map.class));

              File dir = new File("C:/OmegaPlusPDA");
              if(!dir.exists())  dir.mkdir();
              FileDownloadInfo fInfo = new FileDownloadInfo("C:/OmegaPlusPDA", "itemLotLabel1.txt");

              FileOutputStream fos = new FileOutputStream(fInfo.getFile());
              String data = "";
              for(Map param: paramList) {
                  String floatQty = (String)param.get("QTY");
                  if(param.get("PRINT_YN").toString().equals("true")){      // 출력여부..
                      data += param.get("ITEM_CODE") + "|" + param.get("LOT_NO") + "|" + param.get("ITEM_NAME") + "|" + param.get("SPEC") + "|" + param.get("OEM_ITEM_CODE") + "|" + floatQty + "|" + param.get("STOCK_UNIT") + "|" + param.get("PRINT_CNT") + "\r\n";
                  }

              }
              byte[] bytesArray = data.getBytes("euckr");
              fos.write(bytesArray);

              fos.flush();
              fos.close();
              fInfo.setStream(fos);

              return ViewHelper.getFileDownloadView(fInfo);
       }

     // 구매입고바코드 출력(원자재형)
        @RequestMapping(value="/z_kd/matlPrintBarcode2", method = RequestMethod.POST)
        public  ModelAndView matlPrintBarcode2( ExtHtttprequestParam _req) throws Exception {

              //Map pData = _req.getParameterMap();

              ObjectMapper mapper = new ObjectMapper();
              List<Map> paramList = mapper.readValue( ObjUtils.getSafeString((_req.getP("data"))),
                      TypeFactory.defaultInstance().constructCollectionType(List.class,   Map.class));

              File dir = new File("C:/OmegaPlusPDA");
              if(!dir.exists())  dir.mkdir();
              FileDownloadInfo fInfo = new FileDownloadInfo("C:/OmegaPlusPDA", "itemLotLabel2.txt");

              FileOutputStream fos = new FileOutputStream(fInfo.getFile());
              String data = "";
              for(Map param: paramList) {
                  String floatQty = (String)param.get("QTY");
                  if(param.get("PRINT_YN").toString().equals("true")){      // 출력여부..
                      data += param.get("ITEM_CODE") + "|" + param.get("LOT_NO") + "|" + param.get("ITEM_NAME") + "|" + param.get("SPEC") + "|" + param.get("OEM_ITEM_CODE") + "|" + floatQty + "|" + param.get("STOCK_UNIT") + "|" + param.get("PRINT_CNT") + "\r\n";
                  }

              }
              byte[] bytesArray = data.getBytes("euckr");
              fos.write(bytesArray);

              fos.flush();
              fos.close();
              fInfo.setStream(fos);

              return ViewHelper.getFileDownloadView(fInfo);
       }

        /**
         * 바코드출력
         * @return
         * @throws Exception
         */
        @RequestMapping(value = "/z_kd/s_pda030rkrv_kd.do", method = RequestMethod.GET)
        public String s_pda030rkrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
            final String[] searchFields = {  };
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");

            param.put("S_COMP_CODE",loginVO.getCompCode());

            model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
            model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));

            return JSP_PATH + "s_pda030rkrv_kd";
        }

     // 생산실적바코드 출력(제품형)
        @RequestMapping(value="/z_kd/prdtPrintBarcode1", method = RequestMethod.POST)
        public  ModelAndView prdtPrintBarcode1( ExtHtttprequestParam _req) throws Exception {

              //Map pData = _req.getParameterMap();

              ObjectMapper mapper = new ObjectMapper();
              List<Map> paramList = mapper.readValue( ObjUtils.getSafeString((_req.getP("data"))),
                      TypeFactory.defaultInstance().constructCollectionType(List.class,   Map.class));

              File dir = new File("C:/OmegaPlusPDA");
              if(!dir.exists())  dir.mkdir();
              FileDownloadInfo fInfo = new FileDownloadInfo("C:/OmegaPlusPDA", "itemLotLabel1.txt");

              FileOutputStream fos = new FileOutputStream(fInfo.getFile());
              String data = "";
              for(Map param: paramList) {
                  String floatQty = (String)param.get("QTY");
                  if(param.get("PRINT_YN").toString().equals("true")){      // 출력여부..
                      data += param.get("ITEM_CODE") + "|" + param.get("LOT_NO") + "|" + param.get("ITEM_NAME") + "|" + param.get("SPEC") + "|" + param.get("OEM_ITEM_CODE") + "|" + floatQty + "|" + param.get("STOCK_UNIT") + "|" + param.get("PRINT_CNT") + "\r\n";
                  }

              }
              byte[] bytesArray = data.getBytes("euckr");
              fos.write(bytesArray);

              fos.flush();
              fos.close();
              fInfo.setStream(fos);

              return ViewHelper.getFileDownloadView(fInfo);
       }

     // 생산실적바코드 출력(원자재형)
        @RequestMapping(value="/z_kd/prdtPrintBarcode2", method = RequestMethod.POST)
        public  ModelAndView prdtPrintBarcode2( ExtHtttprequestParam _req) throws Exception {

              //Map pData = _req.getParameterMap();

              ObjectMapper mapper = new ObjectMapper();
              List<Map> paramList = mapper.readValue( ObjUtils.getSafeString((_req.getP("data"))),
                      TypeFactory.defaultInstance().constructCollectionType(List.class,   Map.class));

              File dir = new File("C:/OmegaPlusPDA");
              if(!dir.exists())  dir.mkdir();
              FileDownloadInfo fInfo = new FileDownloadInfo("C:/OmegaPlusPDA", "itemLotLabel2.txt");

              FileOutputStream fos = new FileOutputStream(fInfo.getFile());
              String data = "";
              for(Map param: paramList) {
                  String floatQty = (String)param.get("QTY");
                  if(param.get("PRINT_YN").toString().equals("true")){      // 출력여부..
                      data += param.get("ITEM_CODE") + "|" + param.get("LOT_NO") + "|" + param.get("ITEM_NAME") + "|" + param.get("SPEC") + "|" + param.get("OEM_ITEM_CODE") + "|" + floatQty + "|" + param.get("STOCK_UNIT") + "|" + param.get("PRINT_CNT") + "\r\n";
                  }

              }
              byte[] bytesArray = data.getBytes("euckr");
              fos.write(bytesArray);

              fos.flush();
              fos.close();
              fInfo.setStream(fos);

              return ViewHelper.getFileDownloadView(fInfo);
       }

     // 생산검사바코드 출력(제품형)
        @RequestMapping(value="/z_kd/prdtPrintBarcode3", method = RequestMethod.POST)
        public  ModelAndView prdtPrintBarcode3( ExtHtttprequestParam _req) throws Exception {

              //Map pData = _req.getParameterMap();

              ObjectMapper mapper = new ObjectMapper();
              List<Map> paramList = mapper.readValue( ObjUtils.getSafeString((_req.getP("data"))),
                      TypeFactory.defaultInstance().constructCollectionType(List.class,   Map.class));

              File dir = new File("C:/OmegaPlusPDA");
              if(!dir.exists())  dir.mkdir();
              FileDownloadInfo fInfo = new FileDownloadInfo("C:/OmegaPlusPDA", "itemLotLabel1.txt");

              FileOutputStream fos = new FileOutputStream(fInfo.getFile());
              String data = "";
              for(Map param: paramList) {
                  String floatQty = (String)param.get("QTY");
                  if(param.get("PRINT_YN").toString().equals("true")){      // 출력여부..
                      data += param.get("ITEM_CODE") + "|" + param.get("LOT_NO") + "|" + param.get("ITEM_NAME") + "|" + param.get("SPEC") + "|" + param.get("OEM_ITEM_CODE") + "|" + floatQty + "|" + param.get("STOCK_UNIT") + "|" + param.get("PRINT_CNT") + "\r\n";
                  }

              }
              byte[] bytesArray = data.getBytes("euckr");
              fos.write(bytesArray);

              fos.flush();
              fos.close();
              fInfo.setStream(fos);

              return ViewHelper.getFileDownloadView(fInfo);
       }

     // 생산검사바코드 출력(원자재형)
        @RequestMapping(value="/z_kd/prdtPrintBarcode4", method = RequestMethod.POST)
        public  ModelAndView prdtPrintBarcode4( ExtHtttprequestParam _req) throws Exception {

              //Map pData = _req.getParameterMap();

              ObjectMapper mapper = new ObjectMapper();
              List<Map> paramList = mapper.readValue( ObjUtils.getSafeString((_req.getP("data"))),
                      TypeFactory.defaultInstance().constructCollectionType(List.class,   Map.class));

              File dir = new File("C:/OmegaPlusPDA");
              if(!dir.exists())  dir.mkdir();
              FileDownloadInfo fInfo = new FileDownloadInfo("C:/OmegaPlusPDA", "itemLotLabel2.txt");

              FileOutputStream fos = new FileOutputStream(fInfo.getFile());
              String data = "";
              for(Map param: paramList) {
                  String floatQty = (String)param.get("QTY");
                  if(param.get("PRINT_YN").toString().equals("true")){      // 출력여부..
                      data += param.get("ITEM_CODE") + "|" + param.get("LOT_NO") + "|" + param.get("ITEM_NAME") + "|" + param.get("SPEC") + "|" + param.get("OEM_ITEM_CODE") + "|" + floatQty + "|" + param.get("STOCK_UNIT") + "|" + param.get("PRINT_CNT") + "\r\n";
                  }

              }
              byte[] bytesArray = data.getBytes("euckr");
              fos.write(bytesArray);

              fos.flush();
              fos.close();
              fInfo.setStream(fos);

              return ViewHelper.getFileDownloadView(fInfo);
       }

        /**
         * 수입OFFER자금계획
         * @return
         * @throws Exception
         */
        @RequestMapping(value = "/z_kd/s_tix900ukrv_kd.do")
        public String s_tix900ukrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
            final String[] searchFields = {  };
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");

            param.put("S_COMP_CODE",loginVO.getCompCode());

            CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
            //DefaultMoney
            List<CodeDetailVO> gsDefaultMoney = codeInfo.getCodeList("B004", "", false);
            for(CodeDetailVO map : gsDefaultMoney)  {
                if("Y".equals(map.getRefCode1()) || "y".equals(map.getRefCode1()))  {
                    model.addAttribute("gsDefaultMoney", map.getCodeNo());
                }
            }
            return JSP_PATH + "s_tix900ukrv_kd";
        }

        /**
         * 수입OFFER자금현황
         * @return
         * @throws Exception
         */
        @RequestMapping(value = "/z_kd/s_tix900skrv_kd.do")
        public String s_tix900skrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
            final String[] searchFields = {  };
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");

            param.put("S_COMP_CODE",loginVO.getCompCode());

            CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
            //DefaultMoney
            List<CodeDetailVO> gsDefaultMoney = codeInfo.getCodeList("B004", "", false);
            for(CodeDetailVO map : gsDefaultMoney)  {
                if("Y".equals(map.getRefCode1()) || "y".equals(map.getRefCode1()))  {
                    model.addAttribute("gsDefaultMoney", map.getCodeNo());
                }
            }

            CodeDetailVO cdo = null;

            cdo = codeInfo.getCodeInfo("B609", "GW_URL");   //그룹웨어 호출 url
            if(!ObjUtils.isEmpty(cdo))  model.addAttribute("groupUrl",cdo.getCodeName());

            return JSP_PATH + "s_tix900skrv_kd";
        }

        /**
         * 수입물품원가산출등록
         * @return
         * @throws Exception
         */
        @RequestMapping(value = "/z_kd/s_tix901ukrv_kd.do")
        public String s_tix901ukrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
            final String[] searchFields = {  };
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");

            param.put("S_COMP_CODE",loginVO.getCompCode());

            CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
            //DefaultMoney
            List<CodeDetailVO> gsDefaultMoney = codeInfo.getCodeList("B004", "", false);
            for(CodeDetailVO map : gsDefaultMoney)  {
                if("Y".equals(map.getRefCode1()) || "y".equals(map.getRefCode1()))  {
                    model.addAttribute("gsDefaultMoney", map.getCodeNo());
                }
            }
            return JSP_PATH + "s_tix901ukrv_kd";
        }

        /**
         * 수입물품원가산출현황
         * @return
         * @throws Exception
         */
        @RequestMapping(value = "/z_kd/s_tix901skrv_kd.do")
        public String s_tix901skrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
            final String[] searchFields = {  };
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");

            param.put("S_COMP_CODE",loginVO.getCompCode());

            CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
            //DefaultMoney
            List<CodeDetailVO> gsDefaultMoney = codeInfo.getCodeList("B004", "", false);
            for(CodeDetailVO map : gsDefaultMoney)  {
                if("Y".equals(map.getRefCode1()) || "y".equals(map.getRefCode1()))  {
                    model.addAttribute("gsDefaultMoney", map.getCodeNo());
                }
            }
            return JSP_PATH + "s_tix901skrv_kd";
        }

        /**
         * 년도별수출실적집계
         * @return
         * @throws Exception
         */
        @RequestMapping(value = "/z_kd/s_tes900skrv_kd.do")
        public String s_tes900skrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
            final String[] searchFields = {  };
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");

            param.put("S_COMP_CODE",loginVO.getCompCode());

            CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
            //DefaultMoney
            List<CodeDetailVO> gsDefaultMoney = codeInfo.getCodeList("B004", "", false);
            for(CodeDetailVO map : gsDefaultMoney)  {
                if("Y".equals(map.getRefCode1()) || "y".equals(map.getRefCode1()))  {
                    model.addAttribute("gsDefaultMoney", map.getCodeNo());
                }
            }
            return JSP_PATH + "s_tes900skrv_kd";
        }

        // 생산구매요청등록
        @RequestMapping(value = "/z_kd/s_mre090ukrv_kd.do",method = RequestMethod.GET)
        public String s_mre090ukrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {

            final String[] searchFields = {  };
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");

            model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
            model.addAttribute("COMBO_GW_STATUS", comboService.fnGetGwStatus(param));
            CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
            CodeDetailVO cdo = null;


            List<CodeDetailVO> gsDefaultMoney = codeInfo.getCodeList("B004", "", false);        //화폐단위(기본화폐단위설정
            for(CodeDetailVO map : gsDefaultMoney)  {
                if("Y".equals(map.getRefCode1()) || "y".equals(map.getRefCode1()))  {
                    model.addAttribute("gsDefaultMoney", map.getCodeNo());
                }
            }

            cdo = codeInfo.getCodeInfo("B609", "GW_URL");   //그룹웨어 호출 url
            if(!ObjUtils.isEmpty(cdo))  model.addAttribute("groupUrl",cdo.getCodeName());

            cdo = codeInfo.getCodeInfo("M101", "1");
            if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsAutoType",cdo.getRefCode1());

            System.out.println("========s_mre090ukrv_kd ===========================");
            return JSP_PATH + "s_mre090ukrv_kd";
        }

        /**
         * 라인,제품,월별 생산수량조회
         * @return
         * @throws Exception
         */
        @RequestMapping(value = "/z_kd/s_pmr907skrv_kd.do")
        public String s_pmr907skrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
            final String[] searchFields = {  };
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");

            param.put("S_COMP_CODE",loginVO.getCompCode());

            CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
            //DefaultMoney
            List<CodeDetailVO> gsDefaultMoney = codeInfo.getCodeList("B004", "", false);
            for(CodeDetailVO map : gsDefaultMoney)  {
                if("Y".equals(map.getRefCode1()) || "y".equals(map.getRefCode1()))  {
                    model.addAttribute("gsDefaultMoney", map.getCodeNo());
                }
            }
            return JSP_PATH + "s_pmr907skrv_kd";
        }

        /**
         * 라인별 생산계획 조회
         * @return
         * @throws Exception
         */
        @RequestMapping(value = "/z_kd/s_pmr919rkrv_kd.do")
        public String s_pmr919rkrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
            final String[] searchFields = {  };
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");

            param.put("S_COMP_CODE",loginVO.getCompCode());

            CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
            //DefaultMoney
            List<CodeDetailVO> gsDefaultMoney = codeInfo.getCodeList("B004", "", false);
            for(CodeDetailVO map : gsDefaultMoney)  {
                if("Y".equals(map.getRefCode1()) || "y".equals(map.getRefCode1()))  {
                    model.addAttribute("gsDefaultMoney", map.getCodeNo());
                }
            }
            return JSP_PATH + "s_pmr919rkrv_kd";
        }

        /**
         * 라인별 판매계획 출력(월)
         * @return
         * @throws Exception
         */
        @RequestMapping(value = "/z_kd/s_pmr922skrv_kd.do")
        public String s_pmr922skrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
            final String[] searchFields = {  };
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");

            param.put("S_COMP_CODE",loginVO.getCompCode());

            CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
            //DefaultMoney
            List<CodeDetailVO> gsDefaultMoney = codeInfo.getCodeList("B004", "", false);
            for(CodeDetailVO map : gsDefaultMoney)  {
                if("Y".equals(map.getRefCode1()) || "y".equals(map.getRefCode1()))  {
                    model.addAttribute("gsDefaultMoney", map.getCodeNo());
                }
            }
            return JSP_PATH + "s_pmr922skrv_kd";
        }

        @RequestMapping(value = "/z_kd/s_tpl200ukr_kd.do", method = RequestMethod.GET)
        public String s_tpl200ukr_kd() throws Exception {
            return JSP_PATH + "s_tpl200ukr_kd";
        }

        //s_str900skr_kd(출고현황)
        @RequestMapping(value = "/z_kd/s_str900skrv_kd.do", method = RequestMethod.GET)
        public String s_str900skrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
            final String[] searchFields = {  };
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");

            param.put("S_COMP_CODE",loginVO.getCompCode());

            model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

            CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
            CodeDetailVO cdo = null;

            cdo = codeInfo.getCodeInfo("B609", "GW_URL");   //그룹웨어 호출 url
            if(!ObjUtils.isEmpty(cdo))  model.addAttribute("groupUrl",cdo.getCodeName());

            return JSP_PATH + "s_str900skrv_kd";
        }


		/**
		 * 영업일보 조회(KDG) (s_str910skrv_kd)
		 * @param _req
		 * @param loginVO
		 * @param listOp
		 * @param model
		 * @return
		 * @throws Exception
		 */
        @RequestMapping(value = "/z_kd/s_str910skrv_kd.do", method = RequestMethod.GET)
        public String s_str910skrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
            final String[] searchFields = {  };
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");

            param.put("S_COMP_CODE",loginVO.getCompCode());

            model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

            CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
            CodeDetailVO cdo = null;

            cdo = codeInfo.getCodeInfo("B609", "GW_URL");   //그룹웨어 호출 url
            if(!ObjUtils.isEmpty(cdo))  model.addAttribute("groupUrl",cdo.getCodeName());

            return JSP_PATH + "s_str910skrv_kd";
        }

        /**
         * 구매요청등록
         * @param loginVO
         * @param model
         * @return
         * @throws Exception
         */
        @RequestMapping(value = "/z_kd/s_mre101ukrv_kd.do",method = RequestMethod.GET)
        public String s_mre101ukrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {

            final String[] searchFields = {  };
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");
            model.addAttribute("COMBO_GW_STATUS", comboService.fnGetGwStatus(param));
            model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
            CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
            CodeDetailVO cdo = null;


            List<CodeDetailVO> gsDefaultMoney = codeInfo.getCodeList("B004", "", false);        //화폐단위(기본화폐단위설정
            for(CodeDetailVO map : gsDefaultMoney)  {
                if("Y".equals(map.getRefCode1()) || "y".equals(map.getRefCode1()))  {
                    model.addAttribute("gsDefaultMoney", map.getCodeNo());
                }
            }

            cdo = codeInfo.getCodeInfo("B609", "GW_URL");   //그룹웨어 호출 url
            if(!ObjUtils.isEmpty(cdo))  model.addAttribute("groupUrl",cdo.getCodeName());

            cdo = codeInfo.getCodeInfo("M101", "1");
            if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsAutoType",cdo.getRefCode1());


            System.out.println("========s_mre101ukrv_kd ===========================");
            return JSP_PATH + "s_mre101ukrv_kd";
        }

        @RequestMapping(value="/z_kd/s_agd110ukr_kd.do")
        public String s_agd110ukr_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
            final String[] searchFields = {  };
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");

            //param에 COMP_CODE 정보 추가
            param.put("S_COMP_CODE",loginVO.getCompCode());

            return JSP_PATH + "s_agd110ukr_kd";
        }

        @RequestMapping(value = "/z_kd/s_str400rkrv_kd.do")
        public String s_str400rkrv_kd(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
            final String[] searchFields = {  };
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");

            param.put("S_COMP_CODE",loginVO.getCompCode());

            model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

            return JSP_PATH + "s_str400rkrv_kd";
        }

        @RequestMapping(value="/z_kd/s_ryt600ukrv_kd.do")
        public String s_ryt600ukrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
            final String[] searchFields = {  };
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");

            //param에 COMP_CODE 정보 추가
            param.put("S_COMP_CODE",loginVO.getCompCode());

            return JSP_PATH + "s_ryt600ukrv_kd";
        }

        @RequestMapping(value="/z_kd/s_ryt100ukrv_kd.do")
        public String s_ryt100ukrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
            final String[] searchFields = {  };
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");

            //param에 COMP_CODE 정보 추가
            param.put("S_COMP_CODE",loginVO.getCompCode());

            CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
            CodeDetailVO cdo = null;

            cdo = codeInfo.getCodeInfo("B609", "GW_URL");   //그룹웨어 호출 url
            if(!ObjUtils.isEmpty(cdo))  model.addAttribute("groupUrl",cdo.getCodeName());

            return JSP_PATH + "s_ryt100ukrv_kd";
        }

        @RequestMapping(value = "/z_kd/s_btr140skrv_kd.do")
        public String s_btr140skrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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
            if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsLotNoYN",cdo.getRefCode1());

            cdo = codeInfo.getCodeInfo("B084", "D");
            if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsCellCodeYN",cdo.getRefCode1());

            return JSP_PATH + "s_btr140skrv_kd";
        }

        //s_ryt200skrv_kd(기술료관리품목변황)
        @RequestMapping(value = "/z_kd/s_ryt200skrv_kd.do", method = RequestMethod.GET)
        public String s_ryt200skrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
            final String[] searchFields = {  };
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");

            param.put("S_COMP_CODE",loginVO.getCompCode());

            CodeDetailVO cdo = null;
            return JSP_PATH + "s_ryt200skrv_kd";
        }

        //s_ryt530skrv_kd(제품별거래처별매출현황)
        @RequestMapping(value = "/z_kd/s_ryt530skrv_kd.do", method = RequestMethod.GET)
        public String s_ryt530skrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
            final String[] searchFields = {  };
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");
            CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
            CodeDetailVO cdo = null;
            cdo = codeInfo.getCodeInfo("B609", "GW_URL");   //그룹웨어 호출 url
            if(!ObjUtils.isEmpty(cdo))  model.addAttribute("groupUrl",cdo.getCodeName());
            param.put("S_COMP_CODE",loginVO.getCompCode());

            return JSP_PATH + "s_ryt530skrv_kd";
        }

        //s_ryt540skrv_kd(기술료제품별매출(영업))
        @RequestMapping(value = "/z_kd/s_ryt540skrv_kd.do", method = RequestMethod.GET)
        public String s_ryt540skrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
            final String[] searchFields = {  };
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");
            CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
            CodeDetailVO cdo = null;
            cdo = codeInfo.getCodeInfo("B609", "GW_URL");   //그룹웨어 호출 url
            if(!ObjUtils.isEmpty(cdo))  model.addAttribute("groupUrl",cdo.getCodeName());
            param.put("S_COMP_CODE",loginVO.getCompCode());


            return JSP_PATH + "s_ryt540skrv_kd";
        }

        @RequestMapping(value = "/z_kd/s_ryt200ukrv_kd.do", method = RequestMethod.GET)
        public String s_ryt200ukrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
            final String[] searchFields = {  };
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");

            param.put("S_COMP_CODE",loginVO.getCompCode());

            CodeDetailVO cdo = null;
            return JSP_PATH + "s_ryt200ukrv_kd";
        }

        @RequestMapping(value = "/z_kd/s_ryt300ukrv_kd.do", method = RequestMethod.GET)
        public String s_ryt300ukrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
            final String[] searchFields = {  };
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");

            param.put("S_COMP_CODE",loginVO.getCompCode());

            CodeDetailVO cdo = null;
            return JSP_PATH + "s_ryt300ukrv_kd";
        }

        @RequestMapping(value = "/z_kd/s_ryt400ukrv_kd.do", method = RequestMethod.GET)
        public String s_ryt400ukrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
            final String[] searchFields = {  };
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");

            param.put("S_COMP_CODE",loginVO.getCompCode());

            CodeDetailVO cdo = null;
            return JSP_PATH + "s_ryt400ukrv_kd";
        }

        @RequestMapping(value = "/z_kd/s_ryt500ukrv_kd.do", method = RequestMethod.GET)
        public String s_ryt500ukrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
            final String[] searchFields = {  };
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");

            param.put("S_COMP_CODE",loginVO.getCompCode());

            CodeDetailVO cdo = null;
            return JSP_PATH + "s_ryt500ukrv_kd";
        }

        @RequestMapping(value = "/z_kd/s_ryt500skrv_kd.do", method = RequestMethod.GET)
        public String s_ryt500skrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
            final String[] searchFields = {  };
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");

            param.put("S_COMP_CODE",loginVO.getCompCode());

            CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
            CodeDetailVO cdo = null;
            cdo = codeInfo.getCodeInfo("B609", "GW_URL");   //그룹웨어 호출 url
            if(!ObjUtils.isEmpty(cdo))  model.addAttribute("groupUrl",cdo.getCodeName());
            return JSP_PATH + "s_ryt500skrv_kd";
        }

        @RequestMapping(value = "/z_kd/s_ryt510skrv_kd.do", method = RequestMethod.GET)
        public String s_ryt510skrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
            final String[] searchFields = {  };
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");

            param.put("S_COMP_CODE",loginVO.getCompCode());

            CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
            CodeDetailVO cdo = null;
            cdo = codeInfo.getCodeInfo("B609", "GW_URL");   //그룹웨어 호출 url
            if(!ObjUtils.isEmpty(cdo))  model.addAttribute("groupUrl",cdo.getCodeName());
            return JSP_PATH + "s_ryt510skrv_kd";
        }

        @RequestMapping(value = "/z_kd/s_ryt520skrv_kd.do", method = RequestMethod.GET)
        public String s_ryt520skrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
            final String[] searchFields = {  };
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");
            CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
            CodeDetailVO cdo = null;
            cdo = codeInfo.getCodeInfo("B609", "GW_URL");   //그룹웨어 호출 url
            if(!ObjUtils.isEmpty(cdo))  model.addAttribute("groupUrl",cdo.getCodeName());
            param.put("S_COMP_CODE",loginVO.getCompCode());

            return JSP_PATH + "s_ryt520skrv_kd";
        }

        @RequestMapping(value = "/z_kd/s_ryt410skrv_kd.do", method = RequestMethod.GET)
        public String s_ryt410skrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
            final String[] searchFields = {  };
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");

            param.put("S_COMP_CODE",loginVO.getCompCode());

            CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
            CodeDetailVO cdo = null;

            cdo = codeInfo.getCodeInfo("B609", "GW_URL");   //그룹웨어 호출 url
            if(!ObjUtils.isEmpty(cdo))  model.addAttribute("groupUrl",cdo.getCodeName());

            return JSP_PATH + "s_ryt410skrv_kd";
        }

        /**
         * 금형비미수금등록
         * @param loginVO
         * @param model
         * @return
         * @throws Exception
         */
        @RequestMapping(value = "/z_kd/s_zcc600ukrv_kd.do",method = RequestMethod.GET)
        public String s_zcc600ukrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
            final String[] searchFields = {  };
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();

            param.put("S_COMP_CODE",loginVO.getCompCode());

    		model.addAttribute("gsAuthorityLevel", loginVO.getAuthorityLevel());

            return JSP_PATH + "s_zcc600ukrv_kd";
        }



        /**
         * 금형수금등록
         * @param loginVO
         * @param model
         * @return
         * @throws Exception
         */
        @RequestMapping(value = "/z_kd/s_zcc610ukrv_kd.do",method = RequestMethod.GET)
        public String s_zcc610ukrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
            final String[] searchFields = {  };
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();

            param.put("S_COMP_CODE",loginVO.getCompCode());

    		model.addAttribute("gsAuthorityLevel", loginVO.getAuthorityLevel());

            return JSP_PATH + "s_zcc610ukrv_kd";
        }

        /**
         * 금형미수금조회
         * @param loginVO
         * @param model
         * @return
         * @throws Exception
         */
        @RequestMapping(value = "/z_kd/s_zcc610skrv_kd.do",method = RequestMethod.GET)
        public String s_zcc610skrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
            final String[] searchFields = {  };
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();

            param.put("S_COMP_CODE",loginVO.getCompCode());

    		model.addAttribute("gsAuthorityLevel", loginVO.getAuthorityLevel());

            CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
            CodeDetailVO cdo = null;

            cdo = codeInfo.getCodeInfo("B609", "GW_URL");   //그룹웨어 호출 url
            if(!ObjUtils.isEmpty(cdo))  model.addAttribute("groupUrl",cdo.getCodeName());

            return JSP_PATH + "s_zcc610skrv_kd";
        }

        /**
         * 금형비미수금정리
         * @param loginVO
         * @param model
         * @return
         * @throws Exception
         */
        @RequestMapping(value = "/z_kd/s_zcc601ukrv_kd.do",method = RequestMethod.GET)
        public String s_zcc601ukrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
            final String[] searchFields = {  };
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();

            param.put("S_COMP_CODE",loginVO.getCompCode());

            return JSP_PATH + "s_zcc601ukrv_kd";
        }


        /**
         * 금형비미수금조회
         * @param loginVO
         * @param model
         * @return
         * @throws Exception
         */
        @RequestMapping(value = "/z_kd/s_zcc600skrv_kd.do",method = RequestMethod.GET)
        public String s_zcc600skrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
            final String[] searchFields = {  };
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();

            param.put("S_COMP_CODE",loginVO.getCompCode());

            CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
            CodeDetailVO cdo = null;

            cdo = codeInfo.getCodeInfo("B609", "GW_URL");   //그룹웨어 호출 url
            if(!ObjUtils.isEmpty(cdo))  model.addAttribute("groupUrl",cdo.getCodeName());

            return JSP_PATH + "s_zcc600skrv_kd";
        }

        /**
         * 샘플비미수금등록
         * @param loginVO
         * @param model
         * @return
         * @throws Exception
         */
        @RequestMapping(value = "/z_kd/s_zcc700ukrv_kd.do",method = RequestMethod.GET)
        public String s_zcc700ukrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
            final String[] searchFields = {  };
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();

            param.put("S_COMP_CODE",loginVO.getCompCode());

            return JSP_PATH + "s_zcc700ukrv_kd";
        }

        /**
         * 샘플비미수금정리
         * @param loginVO
         * @param model
         * @return
         * @throws Exception
         */
        @RequestMapping(value = "/z_kd/s_zcc701ukrv_kd.do",method = RequestMethod.GET)
        public String s_zcc701ukrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
            final String[] searchFields = {  };
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();

            param.put("S_COMP_CODE",loginVO.getCompCode());

            return JSP_PATH + "s_zcc701ukrv_kd";
        }

        /**
         * 샘플비미수금조회
         * @param loginVO
         * @param model
         * @return
         * @throws Exception
         */
        @RequestMapping(value = "/z_kd/s_zcc700skrv_kd.do",method = RequestMethod.GET)
        public String s_zcc700skrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
            final String[] searchFields = {  };
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();

            param.put("S_COMP_CODE",loginVO.getCompCode());

            CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
            CodeDetailVO cdo = null;

            cdo = codeInfo.getCodeInfo("B609", "GW_URL");   //그룹웨어 호출 url
            if(!ObjUtils.isEmpty(cdo))  model.addAttribute("groupUrl",cdo.getCodeName());

            return JSP_PATH + "s_zcc700skrv_kd";
        }

        /**
         * 자재발주진행현황
         * @param loginVO
         * @param model
         * @return
         * @throws Exception
         */
        @RequestMapping(value = "/z_kd/s_mtr901skrv_kd.do")
        public String s_mtr901skrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
            final String[] searchFields = {  };
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");

            param.put("S_COMP_CODE",loginVO.getCompCode());

            return JSP_PATH + "s_mtr901skrv_kd";
        }

        /**
         * B/OUT공급/폐기 현황
         * @param loginVO
         * @param model
         * @return
         * @throws Exception
         */
        @RequestMapping(value = "/z_kd/s_bpr110rkrv_kd.do")
        public String s_bpr110rkrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
            final String[] searchFields = {  };
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");

            param.put("S_COMP_CODE",loginVO.getCompCode());

            CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
            CodeDetailVO cdo = null;
            cdo = codeInfo.getCodeInfo("B609", "GW_URL");   //그룹웨어 호출 url
            if(!ObjUtils.isEmpty(cdo))  model.addAttribute("groupUrl",cdo.getCodeName());

            return JSP_PATH + "s_bpr110rkrv_kd";
        }

        //발주서출력
        @RequestMapping(value = "/z_kd/s_mpo150rkrv_kd.do")
        public String s_mpo150rkrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
            final String[] searchFields = {  };
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");

            param.put("S_COMP_CODE", loginVO.getCompCode());
            CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());

            model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

            List<CodeDetailVO> gsReportGubun = codeInfo.getCodeList("M030", "", false);		//모듈별 출력 설정에서 ClipReport추가로 인한 리포트 프로그램 설정값 가져오기(크리스탈,jasper 또는 ClipReport)
        	for(CodeDetailVO map : gsReportGubun)	{
        		if("s_mpo150rkrv_kd".equals(map.getCodeName()))	{
        			model.addAttribute("gsReportGubun", map.getRefCode10());
        		}
        	}


            return JSP_PATH + "s_mpo150rkrv_kd";
    }

        //발주서출력(외주)
        @RequestMapping(value = "/z_kd/s_opo110rkrv_kd.do")
        public String s_opo110rkrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
            final String[] searchFields = {  };
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");

            param.put("S_COMP_CODE", loginVO.getCompCode());

            model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

            return JSP_PATH + "s_opo110rkrv_kd";
    }

        @RequestMapping(value = "/z_kd/s_otr100ukrv_kd.do",method = RequestMethod.GET)
        public String s_otr100ukrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
            final String[] searchFields = {  };
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");

            param.put("S_COMP_CODE",loginVO.getCompCode());

            model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

            CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
            CodeDetailVO cdo = null;

            List<CodeDetailVO> gsExchgRegYN = codeInfo.getCodeList("B081", "", false);
            for(CodeDetailVO map : gsExchgRegYN)    {
                if("Y".equals(map.getRefCode1()))   {
                    model.addAttribute("gsExchgRegYN", map.getCodeNo());
                }
            }                                                                                   /* 대체품목 등록여부 */

            List<CodeDetailVO> gsCheckMath = codeInfo.getCodeList("M031", "", false);
            for(CodeDetailVO map : gsCheckMath) {
                if("Y".equals(map.getRefCode1()))   {
                    model.addAttribute("gsCheckMath", map.getCodeNo());
                }
            }                                                                                   /* 외주입고시 외주출고량 체크방법 */

            return JSP_PATH + "s_otr100ukrv_kd";
        }

     	@RequestMapping(value = "/z_kd/s_mrp110ukrv_kd.do")
    	public String s_mrp110ukrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {

    		final String[] searchFields = {  };
    		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
    		Map<String, Object> param = navigator.getParam();

    		param.put("DIV_CODE",loginVO.getDivCode());

    		return JSP_PATH + "s_mrp110ukrv_kd";
    	}

        //s_tio190skrv_kd(수입Offer현황2)
        @RequestMapping(value = "/z_kd/s_tio190skrv_kd.do", method = RequestMethod.GET)
        public String s_tio190skrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
            final String[] searchFields = {  };
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");

            param.put("S_COMP_CODE",loginVO.getCompCode());

            CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
            CodeDetailVO cdo = null;

            cdo = codeInfo.getCodeInfo("B609", "GW_URL");   //그룹웨어 호출 url
            if(!ObjUtils.isEmpty(cdo))  model.addAttribute("groupUrl",cdo.getCodeName());

            return JSP_PATH + "s_tio190skrv_kd";
        }

        //s_sof100skrv_kd(수출Offer현황)
        @RequestMapping(value = "/z_kd/s_sof100skrv_kd.do", method = RequestMethod.GET)
        public String s_sof100skrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
            final String[] searchFields = {  };
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");

            param.put("S_COMP_CODE",loginVO.getCompCode());

            CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
            CodeDetailVO cdo = null;

            cdo = codeInfo.getCodeInfo("B609", "GW_URL");   //그룹웨어 호출 url
            if(!ObjUtils.isEmpty(cdo))  model.addAttribute("groupUrl",cdo.getCodeName());

            return JSP_PATH + "s_sof100skrv_kd";
        }

        /**
         * 생산계획대비 작지현황
         * @return
         * @throws Exception
         */
        @RequestMapping(value = "/z_kd/s_ppl190skrv_kd.do")
        public String s_ppl190skrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
            final String[] searchFields = {  };
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");

            param.put("S_COMP_CODE",loginVO.getCompCode());
            model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));

            return JSP_PATH + "s_ppl190skrv_kd";
        }

        /**
         * 작업지시서출력
         * @return
         * @throws Exception
         */
        @RequestMapping(value = "/z_kd/s_pmr902rkrv_kd.do")
        public String s_pmr902rkrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
            final String[] searchFields = {  };
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");

            param.put("S_COMP_CODE",loginVO.getCompCode());

            CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
            CodeDetailVO cdo = null;

            cdo = codeInfo.getCodeInfo("B609", "GW_URL");   //그룹웨어 호출 url
            if(!ObjUtils.isEmpty(cdo))  model.addAttribute("groupUrl",cdo.getCodeName());

            return JSP_PATH + "s_pmr902rkrv_kd";
        }

        /**
         * 생산일보출력
         * @return
         * @throws Exception
         */
        @RequestMapping(value = "/z_kd/s_pmr900rkrv_kd.do")
        public String s_pmr900rkrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
            final String[] searchFields = {  };
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");

            param.put("S_COMP_CODE",loginVO.getCompCode());

            CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
            CodeDetailVO cdo = null;

            cdo = codeInfo.getCodeInfo("B609", "GW_URL");   //그룹웨어 호출 url
            if(!ObjUtils.isEmpty(cdo))  model.addAttribute("groupUrl",cdo.getCodeName());

            return JSP_PATH + "s_pmr900rkrv_kd";
        }

        /**
         * 라인별월실적현황
         * @return
         * @throws Exception
         */
        @RequestMapping(value = "/z_kd/s_pmr120skrv_kd.do")
        public String s_pmr120skrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
            final String[] searchFields = {  };
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");

            param.put("S_COMP_CODE",loginVO.getCompCode());

            CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
            CodeDetailVO cdo = null;

            cdo = codeInfo.getCodeInfo("B609", "GW_URL");   //그룹웨어 호출 url
            if(!ObjUtils.isEmpty(cdo))  model.addAttribute("groupUrl",cdo.getCodeName());

            return JSP_PATH + "s_pmr120skrv_kd";
        }

        /**
         * 검교정계획등록
         * @return
         * @throws Exception
         */
        @RequestMapping(value = "/z_kd/s_zdd100ukrv_kd.do")
        public String s_zdd100ukrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
            final String[] searchFields = {  };
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");

            param.put("S_COMP_CODE",loginVO.getCompCode());

            CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
            CodeDetailVO cdo = null;

            cdo = codeInfo.getCodeInfo("B609", "GW_URL");   //그룹웨어 호출 url
            if(!ObjUtils.isEmpty(cdo))  model.addAttribute("groupUrl",cdo.getCodeName());

    		model.addAttribute("COMBO_EQUIP_TYPE", s_zdd100ukrv_kdService.getEquipType(param));

            return JSP_PATH + "s_zdd100ukrv_kd";
        }

        /**
         * 검교정계획조회
         * @return
         * @throws Exception
         */
        @RequestMapping(value = "/z_kd/s_zdd100skrv_kd.do")
        public String s_zdd100skrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
            final String[] searchFields = {  };
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");

            param.put("S_COMP_CODE",loginVO.getCompCode());

            CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
            CodeDetailVO cdo = null;

            cdo = codeInfo.getCodeInfo("B609", "GW_URL");   //그룹웨어 호출 url
            if(!ObjUtils.isEmpty(cdo))  model.addAttribute("groupUrl",cdo.getCodeName());

            return JSP_PATH + "s_zdd100skrv_kd";
        }

        /**
         * 스페어파트현황
         * @return
         * @throws Exception
         */
        @RequestMapping(value = "/z_kd/s_zdd200skrv_kd.do")
        public String s_zdd200skrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
            final String[] searchFields = {  };
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");

            param.put("S_COMP_CODE",loginVO.getCompCode());

            CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
            CodeDetailVO cdo = null;

            cdo = codeInfo.getCodeInfo("B609", "GW_URL");   //그룹웨어 호출 url
            if(!ObjUtils.isEmpty(cdo))  model.addAttribute("groupUrl",cdo.getCodeName());

            return JSP_PATH + "s_zdd200skrv_kd";
        }

        /**
         * 시험의뢰서작성
         * @return
         * @throws Exception
         */
        @RequestMapping(value = "/z_kd/s_zdd300ukrv_kd.do")
        public String s_zdd300ukrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
            final String[] searchFields = {  };
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");

            param.put("S_COMP_CODE",loginVO.getCompCode());

            CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
            CodeDetailVO cdo = null;

            cdo = codeInfo.getCodeInfo("B609", "GW_URL");   //그룹웨어 호출 url
            if(!ObjUtils.isEmpty(cdo))  model.addAttribute("groupUrl",cdo.getCodeName());

            return JSP_PATH + "s_zdd300ukrv_kd";
        }

        /**
         * 시험의뢰서작성
         * @return
         * @throws Exception
         */
        @RequestMapping(value = "/z_kd/s_zdd300skrv_kd.do")
        public String s_zdd300skrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
            final String[] searchFields = {  };
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");

            param.put("S_COMP_CODE",loginVO.getCompCode());

            CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
            CodeDetailVO cdo = null;

            cdo = codeInfo.getCodeInfo("B609", "GW_URL");   //그룹웨어 호출 url
            if(!ObjUtils.isEmpty(cdo))  model.addAttribute("groupUrl",cdo.getCodeName());

            return JSP_PATH + "s_zdd300skrv_kd";
        }

        /**
         * 시험의뢰서결과
         * @return
         * @throws Exception
         */
        @RequestMapping(value = "/z_kd/s_zdd400ukrv_kd.do")
        public String s_zdd400ukrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
            final String[] searchFields = {  };
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");

            param.put("S_COMP_CODE",loginVO.getCompCode());

            CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
            CodeDetailVO cdo = null;

            cdo = codeInfo.getCodeInfo("B609", "GW_URL");   //그룹웨어 호출 url
            if(!ObjUtils.isEmpty(cdo))  model.addAttribute("groupUrl",cdo.getCodeName());

            return JSP_PATH + "s_zdd400ukrv_kd";
        }

        /**
         * 시험의뢰서마감
         * @return
         * @throws Exception
         */
        @RequestMapping(value = "/z_kd/s_zdd410ukrv_kd.do")
        public String s_zdd410ukrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
            final String[] searchFields = {  };
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");

            param.put("S_COMP_CODE",loginVO.getCompCode());

            model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
            model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));
            model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
            model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
            model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));

            CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
            CodeDetailVO cdo = null;

            cdo = codeInfo.getCodeInfo("S012", "2");
            if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsAutoType",cdo.getRefCode1());      //Y:의뢰번호(txtOrderNum) lock,disable

            return JSP_PATH+"s_zdd410ukrv_kd";
        }

        /**
         * 의뢰서작성 등록
         * @return
         * @throws Exception
         */
        @RequestMapping(value = "/z_kd/s_zcc800ukrv_kd.do")
        public String s_zcc800ukrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
            final String[] searchFields = {  };
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");

            param.put("S_COMP_CODE",loginVO.getCompCode());

            model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
            model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));
            model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
            model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
            model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));

            CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
            CodeDetailVO cdo = null;

            cdo = codeInfo.getCodeInfo("S012", "2");
            if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsAutoType",cdo.getRefCode1());      //Y:의뢰번호(txtOrderNum) lock,disable

            cdo = codeInfo.getCodeInfo("B609", "GW_URL");   //그룹웨어 호출 url
            if(!ObjUtils.isEmpty(cdo))  model.addAttribute("groupUrl",cdo.getCodeName());

            List<CodeDetailVO> gsDefaultMoney = codeInfo.getCodeList("B004", "", false);		//기본 화폐단위
        	for(CodeDetailVO map : gsDefaultMoney)	{
        		if("Y".equals(map.getRefCode1()))	{
        			model.addAttribute("gsDefaultMoney", map.getCodeNo());
        		}
        	}
            return JSP_PATH+"s_zcc800ukrv_kd";
        }

        /**
         * 의뢰서현황
         * @return
         * @throws Exception
         */
        @RequestMapping(value = "/z_kd/s_zcc800skrv_kd.do")
        public String s_zcc800skrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
            final String[] searchFields = {  };
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");

            param.put("S_COMP_CODE",loginVO.getCompCode());

            model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
            model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));
            model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
            model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
            model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));

            CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
            CodeDetailVO cdo = null;

            cdo = codeInfo.getCodeInfo("S012", "2");
            if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsAutoType",cdo.getRefCode1());      //Y:의뢰번호(txtOrderNum) lock,disable

            return JSP_PATH+"s_zcc800skrv_kd";
        }

        //외주긴급발주등록
        @RequestMapping(value = "/z_kd/s_opo100ukrv_kd.do")
        public String s_opo100ukrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

            cdo = codeInfo.getCodeInfo("B609", "GW_URL");   //그룹웨어 호출 url
            if(!ObjUtils.isEmpty(cdo))  model.addAttribute("groupUrl",cdo.getCodeName());

            List<CodeDetailVO> gsOrderPrsn = codeInfo.getCodeList("M201", "", false);   //구매담당 정보 조회
            model.addAttribute("gsOrderPrsn", "");
            model.addAttribute("gsOrderPrsnYN", "N");
            for(CodeDetailVO map : gsOrderPrsn) {
                if(loginVO.getUserID().equals(map.getRefCode2()) && loginVO.getDivCode().equals(map.getRefCode4()))     {
                    model.addAttribute("gsOrderPrsn", map.getCodeNo());
                    model.addAttribute("gsOrderPrsnYN", "Y");
                }
            }

            List<CodeDetailVO> gsDefaultMoney = codeInfo.getCodeList("B004", "", false);        //화폐단위(기본화폐단위설정
            for(CodeDetailVO map : gsDefaultMoney)  {
                if("Y".equals(map.getRefCode1()) || "y".equals(map.getRefCode1())) {
                    model.addAttribute("gsDefaultMoney", map.getCodeNo());
                }
            }

            List<CodeDetailVO> gsApproveYN = codeInfo.getCodeList("M008", "", false);       //발주승인 방식
            for(CodeDetailVO map : gsApproveYN) {
                if("Y".equals(map.getRefCode1()) || "y".equals(map.getRefCode1())) {
                    model.addAttribute("gsApproveYN", map.getCodeNo());
                }
            }

            cdo = codeInfo.getCodeInfo("M101", "1");
            if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsAutoType",cdo.getRefCode1());

            cdo = codeInfo.getCodeInfo("M029", "01");
            if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsScChildStockPopYN",cdo.getRefCode1());    // 외주부족수량 팝업 호출여부

            return JSP_PATH + "s_opo100ukrv_kd";
        }

        /**
         * 전산장비등록
         * @return
         * @throws Exception
         */
        @RequestMapping(value = "/z_kd/s_zee200ukrv_kd.do")
        public String s_zee200ukrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
            final String[] searchFields = {  };
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");

            param.put("S_COMP_CODE",loginVO.getCompCode());

            CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
            CodeDetailVO cdo = null;

            cdo = codeInfo.getCodeInfo("S012", "2");
            if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsAutoType",cdo.getRefCode1());      //Y:의뢰번호(txtOrderNum) lock,disable

            cdo = codeInfo.getCodeInfo("B609", "GW_URL");   //그룹웨어 호출 url
            if(!ObjUtils.isEmpty(cdo))  model.addAttribute("groupUrl",cdo.getCodeName());

            return JSP_PATH + "s_zee200ukrv_kd";
        }

        /**
         * SW 등록
         * @return
         * @throws Exception
         */
        @RequestMapping(value = "/z_kd/s_zee100ukrv_kd.do")
        public String s_zee100ukrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
            final String[] searchFields = {  };
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");

            param.put("S_COMP_CODE",loginVO.getCompCode());

            CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
            CodeDetailVO cdo = null;

            cdo = codeInfo.getCodeInfo("S012", "2");
            if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsAutoType",cdo.getRefCode1());      //Y:의뢰번호(txtOrderNum) lock,disable

            return JSP_PATH + "s_zee100ukrv_kd";
        }

        /**
         * SW 등록
         * @return
         * @throws Exception
         */
        @RequestMapping(value = "/z_kd/s_zee100skrv_kd.do")
        public String s_zee100skrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
            final String[] searchFields = {  };
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");

            param.put("S_COMP_CODE",loginVO.getCompCode());

            CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
            CodeDetailVO cdo = null;

            cdo = codeInfo.getCodeInfo("S012", "2");
            if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsAutoType",cdo.getRefCode1());      //Y:의뢰번호(txtOrderNum) lock,disable

            return JSP_PATH + "s_zee100skrv_kd";
        }

        /**
         * 집기비품등록
         * @return
         * @throws Exception
         */
        @RequestMapping(value = "/z_kd/s_zee300ukrv_kd.do")
        public String s_zee300ukrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
            final String[] searchFields = {  };
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");

            param.put("S_COMP_CODE",loginVO.getCompCode());

            CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
            CodeDetailVO cdo = null;

            List<CodeDetailVO> gsMoneyUnit = codeInfo.getCodeList("B004", "", false);
            for(CodeDetailVO map : gsMoneyUnit) {
                if("Y".equals(map.getRefCode1()))   {
                    model.addAttribute("gsMoneyUnit", map.getCodeNo());
                }
            }                                                                                   /* 주화폐단위 */

            cdo = codeInfo.getCodeInfo("B609", "GW_URL");   //그룹웨어 호출 url
            if(!ObjUtils.isEmpty(cdo))  model.addAttribute("groupUrl",cdo.getCodeName());

            cdo = codeInfo.getCodeInfo("S012", "2");
            if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsAutoType",cdo.getRefCode1());      //Y:의뢰번호(txtOrderNum) lock,disable

    		model.addAttribute("COMBO_QEQ_GUBUN2", s_zee300ukrv_kdService.getQeqGubun2(param));
    		model.addAttribute("COMBO_QEQ_GUBUN3", s_zee300ukrv_kdService.getQeqGubun3(param));

            return JSP_PATH + "s_zee300ukrv_kd";
        }

        /**
         * CAD도면번호관리
         * @return
         * @throws Exception
         */
        @RequestMapping(value = "/z_kd/s_zbb100ukrv_kd.do")
        public String s_zbb100ukrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
            final String[] searchFields = {  };
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");

            param.put("S_COMP_CODE",loginVO.getCompCode());

            CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
            CodeDetailVO cdo = null;

            cdo = codeInfo.getCodeInfo("S012", "2");
            if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsAutoType",cdo.getRefCode1());      //Y:의뢰번호(txtOrderNum) lock,disable

            return JSP_PATH + "s_zbb100ukrv_kd";
        }

        /**
         * FMEA등록대장
         * @return
         * @throws Exception
         */
        @RequestMapping(value = "/z_kd/s_zbb200ukrv_kd.do")
        public String s_zbb200ukrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
            final String[] searchFields = {  };
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");

            param.put("S_COMP_CODE",loginVO.getCompCode());

            CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
            CodeDetailVO cdo = null;

            cdo = codeInfo.getCodeInfo("S012", "2");
            if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsAutoType",cdo.getRefCode1());      //Y:의뢰번호(txtOrderNum) lock,disable

            return JSP_PATH + "s_zbb200ukrv_kd";
        }

        /**
         * FMEA등록현황
         * @return
         * @throws Exception
         */
        @RequestMapping(value = "/z_kd/s_zbb200skrv_kd.do")
        public String s_zbb200skrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
            final String[] searchFields = {  };
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");

            param.put("S_COMP_CODE",loginVO.getCompCode());

            return JSP_PATH + "s_zbb200skrv_kd";
        }

        /**
         * 입고등록(SP+통합)
         * @param loginVO
         * @param model
         * @return
         * @throws Exception
         */
        @RequestMapping(value = "/z_kd/s_mms510ukrp1v_kd.do",method = RequestMethod.GET)
        public String s_mms510ukrp1v_kd( LoginVO loginVO, ModelMap model) throws Exception {
            return JSP_PATH + "s_mms510ukrp1v_kd";
        }


        @RequestMapping(value = "/z_kd/s_mms510ukrv_kd.do",method = RequestMethod.GET)

        public String s_mms510ukrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {

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

            return JSP_PATH + "s_mms510ukrv_kd";
        }

        //s_pmr911rkrv_kd(제품별월판매계획대가용실적)
        @RequestMapping(value = "/z_kd/s_pmr911rkrv_kd.do", method = RequestMethod.GET)
        public String s_pmr911rkrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
            final String[] searchFields = {  };
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");

            param.put("S_COMP_CODE",loginVO.getCompCode());

            CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
            CodeDetailVO cdo = null;

            cdo = codeInfo.getCodeInfo("B609", "GW_URL");   //그룹웨어 호출 url
            if(!ObjUtils.isEmpty(cdo))  model.addAttribute("groupUrl",cdo.getCodeName());

            return JSP_PATH + "s_pmr911rkrv_kd";
        }

        //s_pmr903rkrv_kd(LOT관리대장)
        @RequestMapping(value = "/z_kd/s_pmr903rkrv_kd.do", method = RequestMethod.GET)
        public String s_pmr903rkrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
            final String[] searchFields = {  };
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");

            param.put("S_COMP_CODE",loginVO.getCompCode());

            CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
            CodeDetailVO cdo = null;

            cdo = codeInfo.getCodeInfo("B609", "GW_URL");   //그룹웨어 호출 url
            if(!ObjUtils.isEmpty(cdo))  model.addAttribute("groupUrl",cdo.getCodeName());

            return JSP_PATH + "s_pmr903rkrv_kd";
        }

        //재고실사부족표출력
        @RequestMapping(value = "/z_kd/s_biv121rkrv_kd.do")
        public String s_biv121rkrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
            final String[] searchFields = {  };
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");

            param.put("S_COMP_CODE",loginVO.getCompCode());

            model.addAttribute("COMBO_WH_LIST",      comboService.getWhList(param));

            return JSP_PATH + "s_biv121rkrv_kd";
        }

        //s_pmr928rkrv_kd
        @RequestMapping(value = "/z_kd/s_pmr928rkrv_kd.do")
        public String s_pmr928rkrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
            final String[] searchFields = {  };
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");

            param.put("S_COMP_CODE",loginVO.getCompCode());

            return JSP_PATH + "s_pmr928rkrv_kd";
        }

        //s_ssa901rkrv_kd(거래처별매출집계표(부서별))
        @RequestMapping(value = "/z_kd/s_ssa901rkrv_kd.do", method = RequestMethod.GET)
        public String s_ssa901rkrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
            final String[] searchFields = {  };
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");

            param.put("S_COMP_CODE",loginVO.getCompCode());

            CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
            CodeDetailVO cdo = null;

            cdo = codeInfo.getCodeInfo("B609", "GW_URL");   //그룹웨어 호출 url
            if(!ObjUtils.isEmpty(cdo))  model.addAttribute("groupUrl",cdo.getCodeName());

            return JSP_PATH + "s_ssa901rkrv_kd";
        }

        //s_ssa902rkrv_kd(년간매출액비교)
        @RequestMapping(value = "/z_kd/s_ssa902rkrv_kd.do", method = RequestMethod.GET)
        public String s_ssa902rkrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
            final String[] searchFields = {  };
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");

            param.put("S_COMP_CODE",loginVO.getCompCode());

            CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
            CodeDetailVO cdo = null;

            cdo = codeInfo.getCodeInfo("B609", "GW_URL");   //그룹웨어 호출 url
            if(!ObjUtils.isEmpty(cdo))  model.addAttribute("groupUrl",cdo.getCodeName());

            return JSP_PATH + "s_ssa902rkrv_kd";
        }

      //s_ssa912rkrv_kd(월별거래처별미수금집계)
        @RequestMapping(value = "/z_kd/s_ssa912rkrv_kd.do", method = RequestMethod.GET)
        public String s_ssa912rkrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
            final String[] searchFields = {  };
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");

            param.put("S_COMP_CODE",loginVO.getCompCode());

            CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
            CodeDetailVO cdo = null;

            cdo = codeInfo.getCodeInfo("B609", "GW_URL");   //그룹웨어 호출 url
            if(!ObjUtils.isEmpty(cdo))  model.addAttribute("groupUrl",cdo.getCodeName());

            return JSP_PATH + "s_ssa912rkrv_kd";
        }

        //판매목표대납품실적
        @RequestMapping(value = "/z_kd/s_ssa904rkrv_kd.do", method = RequestMethod.GET)
        public String s_ssa904rkrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
            final String[] searchFields = {  };
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");

            param.put("S_COMP_CODE",loginVO.getCompCode());

            CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
            CodeDetailVO cdo = null;

            cdo = codeInfo.getCodeInfo("B609", "GW_URL");   //그룹웨어 호출 url
            if(!ObjUtils.isEmpty(cdo))  model.addAttribute("groupUrl",cdo.getCodeName());

            return JSP_PATH + "s_ssa904rkrv_kd";
        }

        //판매목표대납품실적
        @RequestMapping(value = "/z_kd/s_pmd902rkrv_kd.do", method = RequestMethod.GET)
        public String s_pmd902rkrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
            final String[] searchFields = {  };
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");

            param.put("S_COMP_CODE",loginVO.getCompCode());

            CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
            CodeDetailVO cdo = null;

            cdo = codeInfo.getCodeInfo("B609", "GW_URL");   //그룹웨어 호출 url
            if(!ObjUtils.isEmpty(cdo))  model.addAttribute("groupUrl",cdo.getCodeName());

            return JSP_PATH + "s_pmd902rkrv_kd";
        }

        //무역부 매출처원장
        @RequestMapping(value = "/z_kd/s_tes910rkrv_kd.do", method = RequestMethod.GET)
        public String s_tes910rkrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
            final String[] searchFields = {  };
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");

            param.put("S_COMP_CODE",loginVO.getCompCode());

            CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
            CodeDetailVO cdo = null;

            cdo = codeInfo.getCodeInfo("B609", "GW_URL");   //그룹웨어 호출 url
            if(!ObjUtils.isEmpty(cdo))  model.addAttribute("groupUrl",cdo.getCodeName());

            List<CodeDetailVO> gsMoneyUnit = codeInfo.getCodeList("B004", "", false);
            for(CodeDetailVO map : gsMoneyUnit) {
                if("Y".equals(map.getRefCode1()))   {
                    model.addAttribute("gsMoneyUnit", map.getCodeNo());
                }
            }                                                                                   /* 주화폐단위 */

            return JSP_PATH + "s_tes910rkrv_kd";
        }

        //일괄제조오더등록(*) 극동전용
        @RequestMapping(value = "/z_kd/s_pmp102ukrv_kd.do", method = RequestMethod.GET)
        public String s_pmp102ukrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
        	final String[] searchFields = {  };
    		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
    		LoginVO session = _req.getSession();
    		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
    		Map<String, Object> param = navigator.getParam();
    		String page = _req.getP("page");

    		param.put("S_COMP_CODE",loginVO.getCompCode());
    		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
    		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
    		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
    		model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));

		   List<CodeDetailVO> gsEquipCode = codeInfo.getCodeList("WP01", "", false);            // 작지설비 관리여부
           for(CodeDetailVO map : gsEquipCode) {
               if("Y".equals(map.getRefCode1()))   {
                   model.addAttribute("gsEquipCode", map.getCodeNo());
               }
           }

    	    List<CodeDetailVO> gsMoldCode = codeInfo.getCodeList("WP02", "", false);            // 작지금형 관리여부
            for(CodeDetailVO map : gsMoldCode) {
                if("Y".equals(map.getRefCode1()))   {
                    model.addAttribute("gsMoldCode", map.getCodeNo());
                }
            }



            return JSP_PATH + "s_pmp102ukrv_kd";
        }

        @RequestMapping(value = "/z_kd/s_pmp201ukrv_kd.do")
        public String s_pmp201ukrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
            final String[] searchFields = {  };
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");


            CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
            CodeDetailVO cdo = null;

            param.put("S_COMP_CODE",loginVO.getCompCode());
            model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
            model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
            model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
            model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));
            model.addAttribute("COMBO_GW_STATUS", comboService.fnGetGwStatus(param));

            // BOM PATH 관리여부
            int i = 0;
            List<CodeDetailVO> gsBomPathYN = codeInfo.getCodeList("B082", "", false);
            for(CodeDetailVO map : gsBomPathYN) {
                if("Y".equals(map.getRefCode1())||"y".equals(map.getRefCode1()))    {
                    model.addAttribute("gsShowBtnReserveYN", map.getCodeNo());
                    i++;  // RecordCount
                }
            }
            if(i == 0) model.addAttribute("gsShowBtnReserveYN", "N");

            //출고요청 승인방식(수동/자동승인) 공통코드에서 가져오기(P118)
            List<CodeDetailVO> gsAutoAgree = codeInfo.getCodeList("P118", "", false);
            for(CodeDetailVO map : gsAutoAgree) {
                if("Y".equals(map.getRefCode1())||"y".equals(map.getRefCode1()))    {
                    model.addAttribute("gsAutoAgree", map.getCodeNo());
                }
            }

            //자동채번 공통코드에서 가져오기(P005)
            cdo = codeInfo.getCodeInfo("P005", "3");
            if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsAutotype",cdo.getRefCode1());

            //승인자 ID 가져오기(P119)에서 출고요청자에 따른 승인자ID 가져오기
            /*
             * List<CodeDetailVO> gsExchgRegYN = codeInfo.getCodeList("P119", "", false);
            for(CodeDetailVO map : gsExchgRegYN)    {
                if(사용자명.equals(map.getCodeName()))  {
                    model.addAttribute("gsAgreePrsn", map.getRefCode1());
                }
            }
            */

            List<CodeDetailVO> gsUsePabStockYn = codeInfo.getCodeList("I014", "", false);//가용재고 체크여부
            for(CodeDetailVO map : gsUsePabStockYn) {
                if("Y".equals(map.getRefCode1()))   {
                    model.addAttribute("gsUsePabStockYn", map.getCodeNo());
                }
            }

            cdo = codeInfo.getCodeInfo("B609", "GW_URL");   //그룹웨어 호출 url
            if(!ObjUtils.isEmpty(cdo))  model.addAttribute("groupUrl",cdo.getCodeName());
//            if(!ObjUtils.isEmpty(cdo)){
//                model.addAttribute("GW_URL",cdo.getCodeName());
//            }else {
//                model.addAttribute("GW_URL", "");
//            }

            return JSP_PATH + "s_pmp201ukrv_kd";
        }


        /**
         * 공정BOM 조회
         * @return
         * @throws Exception
         */
        @RequestMapping(value = "/z_kd/s_pbs300skrv_kd.do")
        public String s_pbs300skrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
            final String[] searchFields = {  };
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");
            return JSP_PATH + "s_pbs300skrv_kd";
        }

        /**
         * 개인별발령내역 조회
         *
         * @return
         * @throws Exception
         */
        @RequestMapping( value = "/z_kd/s_hum500skr_kd.do" )
        public String hum500skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
            final String[] searchFields = {};
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");

            param.put("S_COMP_CODE", loginVO.getCompCode());

            return JSP_PATH + "s_hum500skr_kd";
        }

        /**
         * 근로자명부 조회
         *
         * @return
         * @throws Exception
         */
        @RequestMapping( value = "/z_kd/s_hum510skr_kd.do" )
        public String hum510skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
            final String[] searchFields = {};
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");

            param.put("S_COMP_CODE", loginVO.getCompCode());

            return JSP_PATH + "s_hum510skr_kd";
        }

        /**
         * 인원현황 조회
         *
         * @return
         * @throws Exception
         */
        @RequestMapping( value = "/z_kd/s_hum520skr_kd.do" )
        public String hum520skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
            final String[] searchFields = {};
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");

            param.put("S_COMP_CODE", loginVO.getCompCode());

            return JSP_PATH + "s_hum520skr_kd";
        }

        /**
         * 상벌사항 조회
         *
         * @return
         * @throws Exception
         */
        @RequestMapping( value = "/z_kd/s_hum530skr_kd.do" )
        public String hum530skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
            final String[] searchFields = {};
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");

            param.put("S_COMP_CODE", loginVO.getCompCode());

            return JSP_PATH + "s_hum530skr_kd";
        }

        /**
         * 인사발령 급료변경 현황 조회
         *
         * @return
         * @throws Exception
         */
        @RequestMapping( value = "/z_kd/s_hum540skr_kd.do" )
        public String hum540skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
            final String[] searchFields = {};
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");

            param.put("S_COMP_CODE", loginVO.getCompCode());
            model.addAttribute("COMBO_ANLIST", comboService.getAnList2(param));
            return JSP_PATH + "s_hum540skr_kd";
        }

        /**
         * 직원인사 최종승진승급 현황 조회
         *
         * @return
         * @throws Exception
         */
        @RequestMapping( value = "/z_kd/s_hum550skr_kd.do" )
        public String hum550skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
            final String[] searchFields = {};
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");

            param.put("S_COMP_CODE", loginVO.getCompCode());

            return JSP_PATH + "s_hum550skr_kd";
        }

        /**
         * 입퇴사별 인원현황 조회
         *
         * @return
         * @throws Exception
         */
        @RequestMapping( value = "/z_kd/s_hum560skr_kd.do" )
        public String hum560skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
            final String[] searchFields = {};
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");

            param.put("S_COMP_CODE", loginVO.getCompCode());

            return JSP_PATH + "s_hum560skr_kd";
        }

        /**
         * 입사일자별 근속현황표 조회
         *
         * @return
         * @throws Exception
         */
        @RequestMapping( value = "/z_kd/s_hum570skr_kd.do" )
        public String hum570skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
            final String[] searchFields = {};
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");

            param.put("S_COMP_CODE", loginVO.getCompCode());

            return JSP_PATH + "s_hum570skr_kd";
        }

        /**
         * 정년만기 해당자현황 조회
         *
         * @return
         * @throws Exception
         */
        @RequestMapping( value = "/z_kd/s_hum580skr_kd.do" )
        public String hum580skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
            final String[] searchFields = {};
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");

            param.put("S_COMP_CODE", loginVO.getCompCode());

            return JSP_PATH + "s_hum580skr_kd";
        }

        /**
         * 연봉계약자 만기도래현황 명세서 조회
         *
         * @return
         * @throws Exception
         */
        @RequestMapping( value = "/z_kd/s_hum590skr_kd.do" )
        public String hum590skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
            final String[] searchFields = {};
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");

            param.put("S_COMP_CODE", loginVO.getCompCode());

            return JSP_PATH + "s_hum590skr_kd";
        }

        /**
         * 임금피크제 조회
         *
         * @return
         * @throws Exception
         */
        @RequestMapping( value = "/z_kd/s_hum600skr_kd.do" )
        public String hum600skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
            final String[] searchFields = {};
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");

            param.put("S_COMP_CODE", loginVO.getCompCode());

            return JSP_PATH + "s_hum600skr_kd";
        }

        /**
         * 해외출장 조회
         *
         * @return
         * @throws Exception
         */
        @RequestMapping( value = "/z_kd/s_hum910skr_kd.do" )
        public String hum910skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
            return JSP_PATH + "s_hum910skr_kd";
        }

        //기간별 근태현황 분석표 조회
        @RequestMapping( value = "/z_kd/s_hat850skr_kd.do" )
        public String hat850skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
            final String[] searchFields = {};
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");

            param.put("S_COMP_CODE", loginVO.getCompCode());

            return JSP_PATH + "s_hat850skr_kd";
        }

        //년월 개인별 일자별 근태현황
        @RequestMapping( value = "/z_kd/s_hat860skr_kd.do" )
        public String s_hat860skr( LoginVO loginVO, ModelMap model ) throws Exception {
            return JSP_PATH + "s_hat860skr_kd";
        }

        //인천(서울) 근태현황 조회
        @RequestMapping( value = "/z_kd/s_hat870skr_kd.do" )
        public String hat870skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
            final String[] searchFields = {};
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");

            param.put("S_COMP_CODE", loginVO.getCompCode());

            return JSP_PATH + "s_hat870skr_kd";
        }
        @RequestMapping( value = "/z_kd/s_hat875skr_kd.do" )
        public String hat875skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
            final String[] searchFields = {};
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");

            param.put("S_COMP_CODE", loginVO.getCompCode());

            return JSP_PATH + "s_hat875skr_kd";
        }

        //야근자 보고서 조회
        @RequestMapping( value = "/z_kd/s_hat880skr_kd.do" )
        public String hat880skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
            final String[] searchFields = {};
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");

            param.put("S_COMP_CODE", loginVO.getCompCode());

            return JSP_PATH + "s_hat880skr_kd";
        }

        //근태대장 조회
        @RequestMapping( value = "/z_kd/s_hat890skr_kd.do" )
        public String hat890skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
            final String[] searchFields = {};
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");

            param.put("S_COMP_CODE", loginVO.getCompCode());

            return JSP_PATH + "s_hat890skr_kd";
        }

        //일일 근태대장 조회
        @RequestMapping( value = "/z_kd/s_hat900skr_kd.do" )
        public String hat900skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
            final String[] searchFields = {};
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");

            param.put("S_COMP_CODE", loginVO.getCompCode());

            return JSP_PATH + "s_hat900skr_kd";
        }

        // 부서별 식수현황 집계표 조회
        @RequestMapping( value = "/z_kd/s_hat910skr_kd.do" )
        public String hat910skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
            final String[] searchFields = {};
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");

            param.put("S_COMP_CODE", loginVO.getCompCode());

            return JSP_PATH + "s_hat910skr_kd";
        }

     // 부서별 식수현황 집계표 조회
        @RequestMapping( value = "/z_kd/s_hat930skr_kd.do" )
        public String hat930skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
            final String[] searchFields = {};
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");

            param.put("S_COMP_CODE", loginVO.getCompCode());

            return JSP_PATH + "s_hat930skr_kd";
        }

        /*
         * 국민건강명세서조회(hpa100skr)
         * @return
         * @throws Exception
         */
        @RequestMapping( value = "/z_kd/s_hpa100skr_kd.do" )
        public String hpa100skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
            final String[] searchFields = {};
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");

            param.put("S_COMP_CODE", loginVO.getCompCode());

            return JSP_PATH + "s_hpa100skr_kd";
        }

        /*
         * 공제대장조회(hpa110skr)
         * @return
         * @throws Exception
         */
        @RequestMapping( value = "/z_kd/s_hpa110skr_kd.do" )
        public String hpa110skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
            final String[] searchFields = {};
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");

            param.put("S_COMP_CODE", loginVO.getCompCode());

            return JSP_PATH + "s_hpa110skr_kd";
        }

        /**
         * 년차현황 조회
         */
        @RequestMapping( value = "/z_kd/s_hpa710skr_kd.do" )
        public String hpa710skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
            final String[] searchFields = {};
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");

            param.put("S_COMP_CODE", loginVO.getCompCode());

            return JSP_PATH + "s_hpa710skr_kd";
        }

        /**
         * 월별 지급차수별 상여 지급대장 조회
         */
        @RequestMapping( value = "/z_kd/s_hpa720skr_kd.do" )
        public String hpa720skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
            final String[] searchFields = {};
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");

            param.put("S_COMP_CODE", loginVO.getCompCode());

            return JSP_PATH + "s_hpa720skr_kd";
        }

        /**
         * 년도별 연차 명세서 조회
         */
        @RequestMapping( value = "/z_kd/s_hpa730skr_kd.do" )
        public String hpa730skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
            final String[] searchFields = {};
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
            CodeDetailVO cdo = null;

            String page = _req.getP("page");

            param.put("S_COMP_CODE", loginVO.getCompCode());

            cdo = codeInfo.getCodeInfo("B609", "GW_URL");   //그룹웨어 호출 url
            if(!ObjUtils.isEmpty(cdo))  model.addAttribute("groupUrl",cdo.getCodeName());


            return JSP_PATH + "s_hpa730skr_kd";
        }

        /**
         * 월별 급여지급대장 집계표 조회(S)
         *
         * @return
         * @throws Exception
         */
        @RequestMapping( value = "/z_kd/s_hpa990skr_kd.do" )
        public String hpa990skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
            final String[] searchFields = {};
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");

            param.put("S_COMP_CODE", loginVO.getCompCode());

            //원천징수 년월 가져오기 (HBS130T)
            //		Map selectDefaultTaxYM = (Map)hpa990ukrService.selectDefaultTaxYM(param);
            //		model.addAttribute("selectDefaultTaxYM", selectDefaultTaxYM.get("TAX_YYYYMM"));

            return JSP_PATH + "s_hpa990skr_kd";
        }


        /**
         * 월별 급여지급대장 조회(S)
         *
         * @return
         * @throws Exception
         */
        @RequestMapping( value = "/z_kd/s_hpa995skr_kd.do" )
        public String hpa995skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
            final String[] searchFields = {};
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");

            param.put("S_COMP_CODE", loginVO.getCompCode());

            //원천징수 년월 가져오기 (HBS130T)
            //		Map selectDefaultTaxYM = (Map)hpa990ukrService.selectDefaultTaxYM(param);
            //		model.addAttribute("selectDefaultTaxYM", selectDefaultTaxYM.get("TAX_YYYYMM"));

            return JSP_PATH + "s_hpa995skr_kd";
        }
        /**
         * 기간별 급여지급대장 조회(S)
         *
         * @return
         * @throws Exception
         */
        @RequestMapping( value = "/z_kd/s_hpa996skr_kd.do" )
        public String hpa996skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
            final String[] searchFields = {};
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");

            param.put("S_COMP_CODE", loginVO.getCompCode());

            //원천징수 년월 가져오기 (HBS130T)
            //		Map selectDefaultTaxYM = (Map)hpa990ukrService.selectDefaultTaxYM(param);
            //		model.addAttribute("selectDefaultTaxYM", selectDefaultTaxYM.get("TAX_YYYYMM"));

            return JSP_PATH + "s_hpa996skr_kd";
        }


        /**
         * <pre>
         * 상여 금액계산 명세 조회
         * </pre>
         *
         * @param _req
         * @param loginVO
         * @param listOp
         * @param model
         * @return
         * @throws Exception
         */
        @RequestMapping( value = "/z_kd/s_hbo900skr_kd.do" )
        public String hbo900skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
            final String[] searchFields = {};
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");

            param.put("S_COMP_CODE", loginVO.getCompCode());

            return JSP_PATH + "s_hbo900skr_kd";
        }

        /**
         * <pre>
         * 월별 상여 지급대장 집계표 조회
         * </pre>
         *
         * @param _req
         * @param loginVO
         * @param listOp
         * @param model
         * @return
         * @throws Exception
         */
        @RequestMapping( value = "/z_kd/s_hbo910skr_kd.do" )
        public String hbo910skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
            final String[] searchFields = {};
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");

            param.put("S_COMP_CODE", loginVO.getCompCode());

            return JSP_PATH + "s_hbo910skr_kd";
        }

        /**
         * <pre>
         * 월별 지급차수별 상여 지급대장 조회
         * </pre>
         *
         * @param _req
         * @param loginVO
         * @param listOp
         * @param model
         * @return
         * @throws Exception
         */
        @RequestMapping( value = "/z_kd/s_hbo920skr_kd.do" )
        public String hbo920skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
            final String[] searchFields = {};
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");

            param.put("S_COMP_CODE", loginVO.getCompCode());

            return JSP_PATH + "s_hbo920skr_kd";
        }

        /**
         * <pre>
         * 상여금 지급내역 조회
         * </pre>
         *
         * @param _req
         * @param loginVO
         * @param listOp
         * @param model
         * @return
         * @throws Exception
         */
        @RequestMapping( value = "/z_kd/s_hbo930skr_kd.do" )
        public String hbo930skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
            final String[] searchFields = {};
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");

            param.put("S_COMP_CODE", loginVO.getCompCode());

            return JSP_PATH + "s_hbo930skr_kd";
        }

        /**
         * <pre>
         * 성금 납부금액 내역서 조회
         * </pre>
         *
         * @param _req
         * @param loginVO
         * @param listOp
         * @param model
         * @return
         * @throws Exception
         */
        @RequestMapping( value = "/z_kd/s_hpa920skr_kd.do" )
        public String hpa920skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
            final String[] searchFields = {};
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");

            param.put("S_COMP_CODE", loginVO.getCompCode());

            return JSP_PATH + "s_hpa920skr_kd";
        }



        /**
         * 차입금상환계획 조회
         *
         * @return
         * @throws Exception
         */
        @RequestMapping( value = "/z_kd/s_afd660skr_kd.do" )
        public String afd660skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
            final String[] searchFields = {};
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");

            List<Map<String, Object>> getStDt = accntCommonService.fnGetStDt(param);        //당기시작년월
            model.addAttribute("getStDt", ObjUtils.toJsonStr(getStDt));

            List<Map<String, Object>> getChargeCode = accntCommonService.fnGetChargeCode(param, loginVO);       // ChargeCode관련
            model.addAttribute("getChargeCode", ObjUtils.toJsonStr(getChargeCode));

            return JSP_PATH + "s_afd660skr_kd";
        }

        /**
         * SK대비표 조회
         *
         * @return
         * @throws Exception
         */
        @SuppressWarnings( "unused" )
        @RequestMapping( value = "/z_kd/s_axt110skr_kd.do" )
        public String axt110skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {

            final String[] searchFields = {};
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");

            param.put("S_COMP_CODE", loginVO.getCompCode());

            return JSP_PATH + "s_axt110skr_kd";
        }

        /**
         * SK대비표 조회
         *
         * @return
         * @throws Exception
         */
        @SuppressWarnings( "unused" )
        @RequestMapping( value = "/z_kd/s_axt100ukr_kd.do" )
        public String s_axt100ukr_kd( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {

            final String[] searchFields = {};
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");

            param.put("S_COMP_CODE", loginVO.getCompCode());

            return JSP_PATH + "s_axt100ukr_kd";
        }


        /**
         * 거래처별 월별 미지급명세서 조회
         *
         * @return
         * @throws Exception
         */
        @SuppressWarnings( "unused" )
        @RequestMapping( value = "/z_kd/s_axt120skr_kd.do" )
        public String axt120skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {

            final String[] searchFields = {};
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");

            param.put("S_COMP_CODE", loginVO.getCompCode());

            return JSP_PATH + "s_axt120skr_kd";
        }

        /**
         * 거래처별 미지급금 현금송금 명세서 조회
         *
         * @return
         * @throws Exception
         */
        @SuppressWarnings( "unused" )
        @RequestMapping( value = "/z_kd/s_axt130skr_kd.do" )
        public String axt130skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {

            final String[] searchFields = {};
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");

            param.put("S_COMP_CODE", loginVO.getCompCode());

            return JSP_PATH + "s_axt130skr_kd";
        }

        /**
         * 대출금현황 조회
         *
         * @return
         * @throws Exception
         */
        @SuppressWarnings( "unused" )
        @RequestMapping( value = "/z_kd/s_axt140skr_kd.do" )
        public String axt140skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {

            final String[] searchFields = {};
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");

            param.put("S_COMP_CODE", loginVO.getCompCode());

            return JSP_PATH + "s_axt140skr_kd";
        }

        /**
         * 입출금현황명세서 조회
         *
         * @return
         * @throws Exception
         */
        @SuppressWarnings( "unused" )
        @RequestMapping( value = "/z_kd/s_axt160skr_kd.do" )
        public String axt160skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {

            final String[] searchFields = {};
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");

            param.put("S_COMP_CODE", loginVO.getCompCode());

            return JSP_PATH + "s_axt160skr_kd";
        }

        /**
         * 자금현황명세서 조회
         *
         * @return
         * @throws Exception
         */
        @SuppressWarnings( "unused" )
        @RequestMapping( value = "/z_kd/s_axt170skr_kd.do" )
        public String axt170skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {

            final String[] searchFields = {};
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");

            param.put("S_COMP_CODE", loginVO.getCompCode());

            return JSP_PATH + "s_axt170skr_kd";
        }

        /**
         * 퇴직급여 충당금설정 명세서 조회
         *
         * @return
         * @throws Exception
         */
        @SuppressWarnings( "unused" )
        @RequestMapping( value = "/z_kd/s_axt180skr_kd.do" )
        public String axt180skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {

            final String[] searchFields = {};
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");

            param.put("S_COMP_CODE", loginVO.getCompCode());

            return JSP_PATH + "s_axt180skr_kd";
        }

        /**
         * 결의전표입력(전표번호별)
         *
         * @return
         * @throws Exception
         */
        @SuppressWarnings( { "rawtypes", "unchecked", "unused" } )
        @RequestMapping( value = "/z_kd/s_agj105ukr_kd.do" )
        public String agj105ukr( LoginVO loginVO, ModelMap model ) throws Exception {

            //신고사업장
            Map param = new HashMap();
            param.put("DIV_CODE", loginVO.getDivCode());
            param.put("S_COMP_CODE", loginVO.getCompCode());
            Map billDivMap = (Map)accntCommonService.fnGetBillDivCode(param);
            model.addAttribute("gsBillDivCode", ObjUtils.isNotEmpty(billDivMap) ? billDivMap.get("BILL_DIV_CODE") : "");

            String toDaty = new SimpleDateFormat("yyyyMMdd").format(new Date());
            Map param1 = new HashMap();
            param1.put("EX_DATE", toDaty);
            param1.put("S_COMP_CODE", loginVO.getCompCode());
            Map<String, Object> maxSlipNumMap = (Map<String, Object>)agj100ukrService.getSlipNum(param1);
            model.addAttribute("initExDate", toDaty);
            model.addAttribute("initExNum", maxSlipNumMap.get("SLIP_NUM"));

            Map param3 = new HashMap();
            param3.put("S_COMP_CODE", loginVO.getCompCode());
            param3.put("S_USER_ID", loginVO.getUserID());
            Map chargeMap = (Map)accntCommonService.fnGetChargeInfo(param3);

            Map paramMap = new HashMap();
            paramMap.put("S_COMP_CODE", loginVO.getCompCode());
            Map<String, Object> rMap = (Map<String, Object>)agj100ukrService.selectOption(paramMap);

            Map cashAccntMap = (Map)agj100ukrService.getCashAccnt(paramMap);
            Map accParam = new HashMap();
            String strCashAccnt = "{";
            if (ObjUtils.isNotEmpty(cashAccntMap)) {
                accParam.put("ACCNT_CD", ObjUtils.getSafeString(cashAccntMap.get("ACCNT")));
                Map<String, Object> cashAccnt = (Map<String, Object>)accntCommonService.fnGetAccntInfo(accParam, loginVO);

                for (String key : cashAccnt.keySet()) {
                    if (ObjUtils.isNotEmpty(cashAccnt.get(key))) {
                        strCashAccnt += "'" + key + "' : '" + cashAccnt.get(key) + "',";
                    }
                }
            }
            if (strCashAccnt.length() > 1) {
                strCashAccnt = strCashAccnt.substring(0, strCashAccnt.length() - 1) + "}";
            } else {
                strCashAccnt = "{}";
            }

            model.addAttribute("cashAccntInfo", strCashAccnt);

            Map param2 = new HashMap();
            param2.put("S_COMP_CODE", loginVO.getCompCode());
            param2.put("COL", "PEND_YN");
            Map gsPendMap = (Map)accntCommonService.fnGetAccntBasicInfo_a(param2);
            model.addAttribute("gsPendYn", gsPendMap.get("OPTION"));

            if (ObjUtils.isNotEmpty(chargeMap)) {
                model.addAttribute("chargeCode", chargeMap.get("CHARGE_CODE"));
                model.addAttribute("chargeName", chargeMap.get("CHARGE_NAME"));
                model.addAttribute("gsChargeDivi", chargeMap.get("CHARGE_DIVI"));
                model.addAttribute("gsChargePNumb", chargeMap.get("CHARGE_PNUMB"));
                model.addAttribute("gsChargePName", chargeMap.get("CHARGE_PNAME"));
            } else {

                model.addAttribute("chargeCode", "");
                model.addAttribute("chargeName", "");
                model.addAttribute("gsChargeDivi", "");
                model.addAttribute("gsChargePNumb", "");
                model.addAttribute("gsChargePName", "");
            }

            Map<String, Object> amtPoint = (Map<String, Object>)accntCommonService.fnGetAmtPoint(param3);
            model.addAttribute("gsAmtPoint", ( ObjUtils.isNotEmpty(amtPoint.get("AMT_POINT")) ? amtPoint.get("AMT_POINT") : 0 ));

            //출력
            Map param4 = new HashMap();
            param4.put("S_COMP_CODE", loginVO.getCompCode());
            List<Map<String, Object>> prtSettings = accntCommonService.fnGetPrintSetting(param4);
            if (prtSettings != null && prtSettings.size() > 0) {
                model.addAttribute("slipPrint", ObjUtils.getSafeString(prtSettings.get(0).get("SLIP_PRINT")));
                model.addAttribute("prtReturnYn", ObjUtils.getSafeString(prtSettings.get(0).get("RETURN_YN")));
            } else {
                model.addAttribute("slipPrint", "");
                model.addAttribute("prtReturnYn", "");
            }
            return JSP_PATH + "s_agj105ukr_kd";
        }

        /* SET품목 제작/분해 등록*/
    	@RequestMapping(value = "/z_kd/s_set210ukrv_kd.do")
    	public String s_set210ukrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
    		final String[] searchFields = {  };
    		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
    		LoginVO session = _req.getSession();
    		Map<String, Object> param = navigator.getParam();
    		String page = _req.getP("page");

    		param.put("S_COMP_CODE",loginVO.getCompCode());
    		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
    		model.addAttribute("COMBO_WH_CELL_LIST", comboService.getWhCellList(param));
    		model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));

    		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
    		CodeDetailVO cdo = null;

    		cdo = codeInfo.getCodeInfo("B090", "OA");
    		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsLotNoInputMethod",cdo.getRefCode1() == null || "".equals(cdo.getRefCode1())?"N":cdo.getRefCode1());
    		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsLotNoEssential",cdo.getRefCode2() == null || "".equals(cdo.getRefCode2())?"N":cdo.getRefCode2());
    		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsEssItemAccount",cdo.getRefCode3() == null || "".equals(cdo.getRefCode3())?"":cdo.getRefCode3());

    		cdo = codeInfo.getCodeInfo("B084", "D");
    		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsSumTypeCell",cdo.getRefCode1());	/* 재고합산유형 : 창고 Cell 합산 */
    		cdo = codeInfo.getCodeInfo("B084", "C");
    		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsSumTypeLot",cdo.getRefCode1());	/* 재고합산유형 : 창고 Cell 합산 */

    		return JSP_PATH + "s_set210ukrv_kd";
    	}


    	@RequestMapping(value = "/z_kd/s_str103ukrv_kd.do")
    	public String s_str103ukrv_kd(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
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


    		cdo = codeInfo.getCodeInfo("S116", "s_str103ukrv_kd");	//영업 중량및 부피 단위관련 Default 설정
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
    		return JSP_PATH + "s_str103ukrv_kd";
    	}

    	@RequestMapping(value = "/z_kd/s_mpo150skrv_kd.do")
    	public String s_mpo150skrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

    		Map<String, Object> mailInfo = (Map<String, Object>) s_mpo150skrv_kdService.getUserMailInfo(param);    //사용자명,메일주소,메일 비밀번호 가져오기
            model.addAttribute("gsUserId",mailInfo.get("USER_NAME"));
            model.addAttribute("gsMailAddr",mailInfo.get("EMAIL_ADDR"));
            model.addAttribute("gsMailPass",mailInfo.get("EMAIL_PASS"));

    		return JSP_PATH + "s_mpo150skrv_kd";
    }

        /**
         * 거래처별  월별 지급 등록
         *
         * @return
         * @throws Exception
         */
        @SuppressWarnings( "unused" )
        @RequestMapping( value = "/z_kd/s_axt121ukr_kd.do" )
        public String axt121ukrv( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {

            final String[] searchFields = {};
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");

            param.put("S_COMP_CODE", loginVO.getCompCode());

            return JSP_PATH + "s_axt121ukr_kd";
        }

        /**
         * 개인식대정산관리
         *
         * @return
         * @throws Exception
         */
        @SuppressWarnings( "unused" )
        @RequestMapping( value = "/z_kd/s_hat920ukr_kd.do" )
        public String s_hat920ukr_kd( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {

            final String[] searchFields = {};
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");

            param.put("S_COMP_CODE", loginVO.getCompCode());

            List<Map<String, Object>> wageStd = hum100ukrService.fnHum100P2Codes(param);

            if (ObjUtils.isNotEmpty(wageStd)) {
                model.addAttribute("wageStd", ObjUtils.toJsonStr(wageStd));
            } else {
                model.addAttribute("wageStd", "[]");
            }
            CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
            CodeDetailVO humManager = codeInfo.getCodeInfo("H162", "ref_code1", loginVO.getUserID());
            if(ObjUtils.isEmpty(humManager))	{
            	model.addAttribute("IsManager", "N");
            } else {
            	model.addAttribute("IsManager", "Y");
            }
            return JSP_PATH + "s_hat920ukr_kd";
        }

        /**
         * 개인식권발행및확정
         *
         * @return
         * @throws Exception
         */
        @SuppressWarnings( "unused" )
        @RequestMapping( value = "/z_kd/s_hat930ukr_kd.do" )
        public String s_hat930ukr_kd( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {

            final String[] searchFields = {};
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");

            param.put("S_COMP_CODE", loginVO.getCompCode());

            List<Map<String, Object>> wageStd = hum100ukrService.fnHum100P2Codes(param);

            if (ObjUtils.isNotEmpty(wageStd)) {
                model.addAttribute("wageStd", ObjUtils.toJsonStr(wageStd));
            } else {
                model.addAttribute("wageStd", "[]");
            }
            CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
            CodeDetailVO humManager = codeInfo.getCodeInfo("H162", "ref_code1", loginVO.getUserID());
            if(ObjUtils.isEmpty(humManager))	{
            	model.addAttribute("IsManager", "N");
            } else {
            	model.addAttribute("IsManager", "Y");
            }
            return JSP_PATH + "s_hat930ukr_kd";
        }

        /**
         * 급여지급조서출력
         *
         * @return
         * @throws Exception
         */
        @RequestMapping( value = "/z_kd/s_hpa900rkr_kd.do" )
        public String s_hpa900rkr_kd( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
            Gson gson = new Gson();
            String colData = gson.toJson(hpa950skrService.selectColumns(loginVO));
            model.addAttribute("colData", colData);

            //S_COMP_CODE 가져오기
            final String[] searchFields = {};
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");

            param.put("S_COMP_CODE", loginVO.getCompCode());

            //조회조건(사업명 : CBM600T 참조하여 콤보 가져오는 것)
            model.addAttribute("COMBO_HUMAN_COST_POOL", comboService.getHumanCostPool(param));

            List<Map<String, Object>> getCostPoolName = hpa950skrService.getCostPoolName(param);
            model.addAttribute("getCostPoolName", ObjUtils.toJsonStr(getCostPoolName));

            return JSP_PATH + "s_hpa900rkr_kd";
        }

        /**
         * 상여지급조서출력
         *
         * @param popupID
         * @param _req
         * @param loginVO
         * @param listOp
         * @param model
         * @return
         * @throws Exception
         */
        @RequestMapping( value = "/z_kd/s_hbo800rkr_kd.do" )
        public String hbo800rkr( String popupID, ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
            String costPool = s_hbo800rkr_kdService.getCostPoolName(null, loginVO);
            model.addAttribute("COST_POOL", costPool);
            List list = s_hbo800rkr_kdService.getCostPoolValueList(null, loginVO);
            model.addAttribute("COST_POOL_LIST", list);
            return JSP_PATH + "s_hbo800rkr_kd";
        }

        /**
         * 재직/경력증명서 출력
         */
        @RequestMapping( value = "/z_kd/s_hum970rkr_kd.do" )
        public String hum970rkr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
            final String[] searchFields = {};
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");

            return JSP_PATH + "s_hum970rkr_kd";
        }

        /**
         * BOX 라벨출력
         * @param _req
         * @param loginVO
         * @param listOp
         * @param model
         * @return
         * @throws Exception
         */
        @RequestMapping(value = "/z_kd/s_pmp120rkrv_kd.do", method = RequestMethod.GET)
        public String s_pmp120rkrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
            final String[] searchFields = {  };
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");

            param.put("S_COMP_CODE",loginVO.getCompCode());

            CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
            CodeDetailVO cdo = null;

            return JSP_PATH + "s_pmp120rkrv_kd";
        }

        /**
         * 라벨출력
         * @param _req
         * @param loginVO
         * @param listOp
         * @param model
         * @return
         * @throws Exception
         */
        @RequestMapping(value = "/z_kd/s_bpr210rkrv_kd.do", method = RequestMethod.GET)
        public String s_bpr210rkrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
            final String[] searchFields = {  };
            NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
            LoginVO session = _req.getSession();
            Map<String, Object> param = navigator.getParam();
            String page = _req.getP("page");

            param.put("S_COMP_CODE",loginVO.getCompCode());
            model.addAttribute("COMBO_WH_CELL_LIST", comboService.getWhCellList(param));

            CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
            CodeDetailVO cdo = null;

            return JSP_PATH + "s_bpr210rkrv_kd";
        }

	/**
	 * 어음만기현황조회
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_kd/s_afn100skr_kd.do", method = RequestMethod.GET)
	public String s_afn100skr_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		return JSP_PATH + "s_afn100skr_kd";
	}

	@RequestMapping(value = "/z_kd/s_sfa100skrv_kd.do")
	public String s_sfa100skrv_kd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model)throws Exception{
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        param.put("S_COMP_CODE",loginVO.getCompCode());

        model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;

		List<CodeDetailVO> gsMoneyUnit = codeInfo.getCodeList("B004", "", false);
        for(CodeDetailVO map : gsMoneyUnit) {
            if("Y".equals(map.getRefCode1()))   {
                model.addAttribute("gsMoneyUnit", map.getCodeNo());
            }
        }

		return JSP_PATH + "s_sfa100skrv_kd";
	}
	
	@RequestMapping( value = "/z_kd/s_hat200ukr_kd.do" )
    public String s_hat200ukr_kd( LoginVO loginVO, ModelMap model ) throws Exception {
        Gson gson = new Gson();
        String colData = gson.toJson(s_hat200ukr_kdService.selectDutycode(loginVO.getCompCode()));
        model.addAttribute("colData", colData);
        
        Map closeDateMap = s_hat200ukr_kdService.fnCheckCloseMonth(loginVO);
        String closeDate = "";
        if(closeDateMap != null )	{
        	closeDate = ObjUtils.getSafeString(closeDateMap.get("CLOSE_DATE"), "");
        }
        model.addAttribute("CLOSE_DATE", closeDate);
        
        Map map = new HashMap();
        model.addAttribute("COMBO_DEPTS2", comboService.fnGetauthDepts(loginVO,map));//특정부서 콤보
        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        List<CodeDetailVO> formatList = codeInfo.getCodeList("H235");
        String dutyNumFormat = "0.0";
        String dutyTimeFormat = "0.00";
        if(formatList != null) {
        	for(CodeDetailVO codeVO: formatList) {
        		if(codeVO != null)	{
	        		if("s_hat200ukr_kd".equals(codeVO.getRefCode1()) && "DUTY_NUM".equals(codeVO.getRefCode2())) {
	        			if(codeVO.getRefCode3() != null)	{
	        				if("0".equals(codeVO.getRefCode3())) {
	        					dutyNumFormat = "0,000";
	        				} else {
	        					dutyNumFormat = "0,000."+GStringUtils.rPad("", Integer.valueOf(codeVO.getRefCode3()),"0");
	        				}
	        			}
	        		}
	        		if("S_hat200ukr_kd".equals(codeVO.getRefCode1()) && "DUTY_TIME".equals(codeVO.getRefCode4())) {
	        			if(codeVO.getRefCode5() != null)	{
	        				if("0".equals(codeVO.getRefCode5())) {
	        					dutyTimeFormat = "0,000";
	        				} else {
	        					dutyTimeFormat = "0,000."+GStringUtils.rPad("", Integer.valueOf(codeVO.getRefCode5()),"0");
	        				}
	        			}
	        		}
        		}
        	}
        }
        
        model.addAttribute("DUTY_NUM_FORMAT", dutyNumFormat);
        model.addAttribute("DUTY_TIME_FORMAT", dutyTimeFormat);
        
        
        return JSP_PATH + "s_hat200ukr_kd";
    }
}
