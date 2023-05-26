package foren.unilite.modules.human.hbo;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import foren.framework.lib.listop.ListOp;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.framework.model.NavigatorInfo;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.com.code.CodeDetailVO;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.modules.com.combo.ComboServiceImpl;
import foren.unilite.modules.human.HumanCommonServiceImpl;

@Controller
public class HboController extends UniliteCommonController {

    @Resource( name = "UniliteComboServiceImpl" )
    private ComboServiceImpl       comboService;

    private final Logger           logger   = LoggerFactory.getLogger(this.getClass());

    final static String            JSP_PATH = "/human/hbo/";

    @Resource( name = "humanCommonService" )
    private HumanCommonServiceImpl humanCommonService;

    /**
     * 서비스 연결
     */
    @Resource( name = "hbo300ukrService"  )
    private Hbo300ukrServiceImpl   hbo300ukrService;

    @Resource( name = "hbo210ukrService" )
    private Hbo210ukrServiceImpl   hbo210ukrService;

    @Resource( name = "hbo220ukrService" )
    private Hbo220ukrServiceImpl   hbo220ukrService;

    @Resource( name = "hbo800rkrService" )
    private Hbo800rkrServiceImpl   hbo800rkrService;

    @Resource( name = "hbo900skrServiceImpl" )
    private Hbo900skrServiceImpl   hbo900skrServiceImpl;

    @Resource( name = "hbo900ukrServiceImpl" )
    private Hbo900ukrServiceImpl   hbo900ukrServiceImpl;

    @Resource( name = "hbo910skrServiceImpl" )
    private Hbo910skrServiceImpl   hbo910skrServiceImpl;

    @Resource( name = "hbo920skrServiceImpl" )
    private Hbo920skrServiceImpl   hbo920skrServiceImpl;

    /**
     * 계정과목등록
     *
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/human/hbo210ukr.do" )
    public String hbo210ukr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        param.put("S_COMP_CODE", loginVO.getCompCode());

        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());

        //지급구분에서 refcode1이 1을 제외한 데이터만 가져오기
        List<CodeDetailVO> gsList1 = codeInfo.getCodeList("H032", "", false);
        Object list1 = "";
        for (CodeDetailVO map : gsList1) {
            if ("".equals(map.getRefCode1())) {
                if (list1.equals("")) {
                    list1 = map.getCodeNo();
                } else {
                    list1 = list1 + ";" + map.getCodeNo();
                }
            }
        }
        model.addAttribute("gsList1", list1);

        return JSP_PATH + "hbo210ukr";
    }

    /**
     * 상여조회 및 조정 (hbo220ukr)
     *
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/human/hbo220ukr.do" )
    public String hbo220ukr( String popupID, ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        param.put("S_COMP_CODE", loginVO.getCompCode());

        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());

        //지급구분에서 refcode1이 1을 제외한 데이터만 가져오기
        List<CodeDetailVO> gsList1 = codeInfo.getCodeList("H032", "", false);
        Object list1 = "";
        for (CodeDetailVO map : gsList1) {
            if ("".equals(map.getRefCode1())) {
                if (list1.equals("")) {
                    list1 = map.getCodeNo();
                } else {
                    list1 = list1 + ";" + map.getCodeNo();
                }
            }
        }
        model.addAttribute("gsList1", list1);

        return JSP_PATH + "hbo220ukr";
    }

    /**
     * Navi버튼 활성화를 결정
     *
     * @param param
     * @param loginVO
     * @return 현재 사원의 전후로 데이터가 있는지 확인
     * @throws Exception
     */
    @RequestMapping( value = "/human/checkAvailableNaviHpo220.do" )
    public ModelAndView checkAvailableNavi( @RequestParam Map<String, String> param, LoginVO loginVO ) throws Exception {
        param.put("S_COMP_CODE", loginVO.getCompCode());
        List<Map<String, Object>> result = hbo220ukrService.checkAvailableNavi(param);
        return ViewHelper.getJsonView(result);
    }

    /**
     * 관리항목등록
     *
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/human/hbo300ukr.do" )
    public String hbo300ukr( String popupID, ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {

    	CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());

    	//지급구분에서 refcode1이 1인 데이터만 가져오기
        List<CodeDetailVO> gsList1 = codeInfo.getCodeList("H032", "", false);
        Object list1 = "";
        for (CodeDetailVO map : gsList1) {
            if ("".equals(map.getRefCode1())) {
                if (list1.equals("")) {
                    list1 = map.getCodeNo();
                } else {
                    list1 = list1 + ";" + map.getCodeNo();
                }
            }
        }
        model.addAttribute("gsList1", list1);

        return JSP_PATH + "hbo300ukr";
    }

    /**
     * add by zhongshl
     *
     * @param popupID
     * @param _req
     * @param loginVO
     * @param listOp
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/human/hbo800rkr.do" )
    public String hbo800rkr( String popupID, ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        String costPool = hbo800rkrService.getCostPoolName(null, loginVO);
        model.addAttribute("COST_POOL", costPool);
        List list = hbo800rkrService.getCostPoolValueList(null, loginVO);
        model.addAttribute("COST_POOL_LIST", list);
        return JSP_PATH + "hbo800rkr";
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
    @RequestMapping( value = "/human/hbo900skr.do" )
    public String hbo900skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        param.put("S_COMP_CODE", loginVO.getCompCode());

        return JSP_PATH + "hbo900skr";
    }

    /**
     * <pre>
     * 상여기준등록
     * </pre>
     *
     * @param _req
     * @param loginVO
     * @param listOp
     * @param model
     * @return
     * @throws Exception
     */
    @SuppressWarnings( "rawtypes" )
    @RequestMapping( value = "/human/hbo900ukr.do" )
    public String hbo900ukr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        // 상여구분
        List list = humanCommonService.getCodeList(loginVO);
        model.addAttribute("BONUS_CODE", list);

        param.put("S_COMP_CODE", loginVO.getCompCode());

        return JSP_PATH + "hbo900ukr";
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
    @RequestMapping( value = "/human/hbo910skr.do"  )
    public String hbo910skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        param.put("S_COMP_CODE", loginVO.getCompCode());

        return JSP_PATH + "hbo910skr";
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
    @RequestMapping( value = "/human/hbo920skr.do" )
    public String hbo920skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        param.put("S_COMP_CODE", loginVO.getCompCode());

        return JSP_PATH + "hbo920skr";
    }
}
