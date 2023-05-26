package foren.unilite.modules.prodt.pbs;

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

@Controller
public class PbsController extends UniliteCommonController {

	private final Logger	logger		= LoggerFactory.getLogger(this.getClass());

	final static String		JSP_PATH	= "/prodt/pbs/";

	@Resource(name="UniliteComboServiceImpl")
	private ComboServiceImpl comboService;

	/**
	 * 기준코드 등록
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/prodt/pbs050ukrv.do")
	public String aba050ukr(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		return JSP_PATH+"pbs050ukrv";
	}

	/**
	 * 생산업무 설정-조회데이터포멧설정
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/prodt/pbs010ukrv.do")
	public String pbs010ukrv(	)throws Exception{
		return JSP_PATH+"pbs010ukrv";
	}

	/**
	 * 생산업무 설정
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/prodt/pbs060ukrv.do")
	public String pbs060ukrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());

		//CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		//CodeDetailVO cdo = null;

		return JSP_PATH+"pbs060ukrv";
	}

	/**
	 * 생산업무 설정-생산기준설정
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/prodt/pbs120ukrv.do")
	public String pbs120ukrv(	)throws Exception{
		return JSP_PATH+"pbs120ukrv";
	}

	/**
	 * 기본정보 등록-생산휴일등록
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/prodt/pbs030ukrv.do")
	public String pbs030ukrv(	)throws Exception{
		return JSP_PATH+"pbs030ukrv";
	}

	/**
	 * 기본정보 등록
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/prodt/pbs070ukrv.do")
	public String pbs070ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());

		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
		model.addAttribute("COMBO_WS_U_LIST", comboService.getWsUList(param));
		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		//20200603 추가
		cdo = codeInfo.getCodeInfo("B259", "1");    //사이트 구분 운영코드
		if(ObjUtils.isNotEmpty(cdo)){
			if(ObjUtils.isNotEmpty(cdo.getCodeName())){
				model.addAttribute("gsSiteCode", cdo.getCodeName().toUpperCase());
			}else{
				model.addAttribute("gsSiteCode", "STANDARD");
			}
		} else {
			model.addAttribute("gsSiteCode", "STANDARD");
		}
		return JSP_PATH+"pbs070ukrv";
	}
	/**
	 * 기본정보 등록 - 카렌더
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/prodt/pbs070ukrs3_1.do")
	public String pbs070ukrs3_1(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {

		return JSP_PATH+"pbs070ukrs3_1";
	}

	/**
	 * 기본정보 등록-카렌더정보생성
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/prodt/pbs100ukrv.do")
	public String pbs100ukrv(	)throws Exception{
		return JSP_PATH+"pbs100ukrv";
	}

	/**
	 * 기본정보 등록-카렌더정보수정
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/prodt/pbs110ukrv.do")
	public String pbs110ukrv(	)throws Exception{
		return JSP_PATH+"pbs110ukrv";
	}

	/**
	 * 기본정보 등록-카렌더정소조회
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/prodt/pbs120skrv.do")
	public String pbs120skrv(	)throws Exception{
		return JSP_PATH+"pbs120skrv";
	}

	/**
	 * 기본정보 등록-공정등록
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/prodt/pbs200ukrv.do")
	public String pbs200ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		return JSP_PATH + "pbs200ukrv";
	}

	/**
	 * 기본정보 등록-공정수순등록
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/prodt/pbs300ukrv.do")
	public String pbs300ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		return JSP_PATH + "pbs300ukrv";
	}

	/**
	 * 기본정보 등록-제조오더분할기준등록
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/prodt/pbs400ukrv.do")
	public String pbs400ukrv(	)throws Exception{
		return JSP_PATH+"pbs400ukrv";
	}

	/**
	 * 기본정보 등록-작업장CAPA등록
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/prodt/pbs500ukrv.do")
	public String pbs500ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		return JSP_PATH + "pbs500ukrv";
	}

	/**
	 * 설비별 표준CAPA등록 --202100901 신규
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/prodt/pbs405ukrv.do")
	public String pbs405ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());

		return JSP_PATH + "pbs405ukrv";
	}

	/**
	 * 설비별생산공수 등록 --20210517 신규
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/prodt/pbs410ukrv.do")
	public String pbs410ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());

		return JSP_PATH + "pbs410ukrv";
	}

	/**
	 * 설비별캘린더 등록
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/prodt/pbs510ukrv.do")
	public String pbs510ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
//		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
//		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
//		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
//		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
//		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
		model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param)); 	//작업장 SELECT 후 넘겨줌
		
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		List<CodeDetailVO> cdoList = codeInfo.getCodeList("B604");
		for(CodeDetailVO map : cdoList)	{
			if("Y".equals(map.getRefCode1()))	{
				model.addAttribute("STD_DAYOFWEEK", map.getCodeName());	// 주차 시작요일
			}
		}

		return JSP_PATH + "pbs510ukrv";
	}
}
