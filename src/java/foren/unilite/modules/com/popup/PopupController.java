package foren.unilite.modules.com.popup;

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

import foren.framework.lib.listop.ListOp;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.framework.model.NavigatorInfo;
import foren.framework.utils.GStringUtils;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.com.code.CodeDetailVO;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.modules.base.BaseCommonServiceImpl;
import foren.unilite.modules.com.combo.ComboServiceImpl;

/**
 * 프로그램명 : 공통팝업
 * 작 성 자 : (주)포렌 개발실
 */

@Controller
public class PopupController extends UniliteCommonController {

	private final Logger		logger		= LoggerFactory.getLogger(this.getClass());
	final static String			JSP_PATH	= "/com/popup/";


	/**
	 * 서비스 연결
	 */
	@Resource(name = "popupService")
	private PopupServiceImpl	popupService;

	@Resource(name="UniliteComboServiceImpl")
	private ComboServiceImpl comboService;

	@Resource(name = "baseCommonService")
	private BaseCommonServiceImpl	baseCommonService;

	/**
	 * 거래처 팝업
	 * @param popupID  팝업구분
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/com/popup/bk/CustPopup.do")
	public String custPopup() throws Exception {
		return JSP_PATH + "CustPopup";
	}

	/**
	 * JS용
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/CustPopup.do")
	public String custPopupWin() throws Exception {
		return JSP_PATH + "CustPopupWin";
	}

	/**
	 * 거래처 팝업(거래처 분류 조건 포함)
	 * @param popupID  팝업구분
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/com/popup/bk/AgentCustPopup.do")
	public String agentCustPopup() throws Exception {
		return JSP_PATH + "AgentCustPopup";
	}

	@RequestMapping(value = "/app/Unilite/app/popup/AgentCustPopup.do")
	public String agentCustPopupWin() throws Exception {
		return JSP_PATH + "AgentCustPopupWin";
	}

	@RequestMapping(value = "/app/Unilite/app/popup/AgentCustPopup2.do")
	public String agentCustPopupMultipleWin() throws Exception {
		return JSP_PATH + "AgentCustPopupMultipleWin";
	}

	/**
	 * 지점정보 팝업
	 * @param popupID
	 * @param _req
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/BussOfficeCode.do")
	public String BussOfficeCode(String popupID, ExtHtttprequestParam _req, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();

		return JSP_PATH + "BussOfficePopupWin";
	}

	/**
	 * 부표코드 팝업
	 * @param popupID
	 * @param _req
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/BuCodePopup.do")
	public String BuCodePopup(String popupID, ExtHtttprequestParam _req, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();

		return JSP_PATH + "BuCodePopupWin";
	}

	/**
	 * 금융상품코드 2012년 이전 까지 사용
	 * @param popupID
	 * @param _req
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/PrizePopup.do")
	public String PrizePopup(String popupID, ExtHtttprequestParam _req, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();

		return JSP_PATH + "PrizePopupWin";
	}

	/**
	 * 지점정보 팝업
	 * @param popupID
	 * @param _req
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/SaupPopupCode.do")
	public String SaupPopupCode(String popupID, ExtHtttprequestParam _req, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();

		return JSP_PATH + "SaupPopupCodePopupWin";
	}

	/**
	 * 금융기관 팝업(은행팝업)
	 * @param popupID  팝업구분
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/com/popup/bk/BankPopup.do")
	public String bankPopup() throws Exception {
		return JSP_PATH + "BankPopup";
	}

	@RequestMapping(value = "/app/Unilite/app/popup/BankPopup.do")
	public String bankPopupWin() throws Exception {
		return JSP_PATH + "BankPopupWin";
	}

	/**
	 * 우편번호
	 * @param popupID  팝업구분
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/com/popup/bk/ZipPopup.do")
	public String bzipPopup() throws Exception {
		return JSP_PATH + "ZipPopup";
	}

	@RequestMapping(value = "/app/Unilite/app/popup/ZipPopup.do")
	public String bzipPopupWin() throws Exception {
		//return JSP_PATH + "ZipPopupWin";
		return JSP_PATH + "ZipPopupWin_Daum";
	}

	@RequestMapping(value = "/app/Unilite/app/popup/ZipPopupTest.do")
	public String bzipPopupWin2() throws Exception {
		//return JSP_PATH + "ZipPopupWin";
		return JSP_PATH + "ZipPopupWin_Test";
	}

	/**
	 * 사용자 팝업
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/UserPopup.do")
	public String userPopupWin(LoginVO loginVO, ModelMap model) throws Exception {

		CodeDetailVO cdo = null;
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		cdo = codeInfo.getCodeInfo("B265", "Y");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsSyTalkYn",cdo.getRefCode1());	//LOT관리기준 설정

		return JSP_PATH + "UserPopupWin";
	}

	/**
	 * 사용자(COMP_CODE 조건 없음) 팝업
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/UserNoCompPopup.do")
	public String userNoCompPopupWin() throws Exception {
		return JSP_PATH + "UserNoCompPopupWin";
	}

	/**
	 * 사원팝업
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/com/popup/bk/EmployeePopup.do")
	public String employeePopup() throws Exception {
		return JSP_PATH + "EmployeePopup";
	}

	@RequestMapping(value = "/app/Unilite/app/popup/EmployeePopup.do")
	public String employeePopupWin() throws Exception {
		return JSP_PATH + "EmployeePopupWin";
	}

	@RequestMapping(value = "/app/Unilite/app/popup/EmployeePopup1.do")
	public String employeePopupWin1() throws Exception {
		return JSP_PATH + "EmployeePopupWin1";
	}
	/**
	 * 일용직사원팝업
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/ParttimeEmployeePopup.do")
	public String ParttimeEmployeeePopupWin() throws Exception {
		return JSP_PATH + "ParttimeEmployeePopupWin";
	}

	/**
	 * 사원팝업(회계)
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/EmployeeAccntPopup.do")
	public String employeeAccntPopupWin() throws Exception {
		return JSP_PATH + "EmployeeAccntPopupWin";
	}

	/**
	 * 부서팝업
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/com/popup/bk/DeptPopup.do")
	public String deptPopup() throws Exception {
		return JSP_PATH + "DeptPopup";
	}

	@RequestMapping(value = "/app/Unilite/app/popup/DeptPopup.do")
	public String deptPopupWin() throws Exception {
		return JSP_PATH + "DeptPopupWin";
	}

	/**
	 * 주민번호 암복호화 팝업
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/CipherRepreNoPopup.do")
	public String cipherRepreNoPopup() throws Exception {
		return JSP_PATH + "CipherRepreNoPopupWin";
	}

	/**
	 * 외국인번호 암복호화 팝업
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/CipherForeignNoPopup.do")
	public String cipherForeignNoPopup() throws Exception {
		return JSP_PATH + "CipherForeignNoPopupWin";
	}

	/**
	 * 카드번호 암복호화 팝업
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/CipherCardNoPopup.do")
	public String cipherCardNoPopup() throws Exception {
		return JSP_PATH + "CipherCardNoPopupWin";
	}

	/**
	 * 계좌번호 암복호화 팝업
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/CipherBankAccntPopup.do")
	public String cipherBankAccntPopup() throws Exception {
		return JSP_PATH + "CipherBankAccntPopupWin";
	}

	/**
	 * 비밀번호 암복호화 팝업
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/CipherPassWordPopup.do")
	public String cipherPassWordPopup() throws Exception {
		return JSP_PATH + "CipherPassWordPopupWin";
	}

	/**
	 * 공통 암복호화 팝업
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/CipherCommPopup.do")
	public String cipherCommPopup() throws Exception {
		return JSP_PATH + "CipherCommPopupWin";
	}

	/**
	 * 일반 필드 암복호화 팝업
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/CipherOtherPopup.do")
	public String cipherOtherPopup() throws Exception {
		return JSP_PATH + "CipherOtherPopupWin";
	}

	/**
	 * 복호화 팝업 20181002
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/DecryptComPopup.do")
	public String DecryptComPopup() throws Exception {
		return JSP_PATH + "DecryptComPopupWin";
	}

	/**
	 * 작업장팝업
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/WorkShopPopup.do")
	public String workShopPopupWin() throws Exception {
		return JSP_PATH + "WorkShopPopupWin";
	}

	/**
	 * 품목정보팝업
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/com/popup/bk/ItemPopup.do")
	public String itemPopup(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();

		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));

		return JSP_PATH + "ItemPopup";
	}

	@RequestMapping(value = "/app/Unilite/app/popup/ItemPopup.do")
	public String itemPopupWin(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();

		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));

		return JSP_PATH + "ItemPopupWin";
	}

	/**
	 * 사용자별 품목정보팝업
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/com/popup/bk/ItemPopup2.do")
	public String itemPopup2(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();
		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));

		return JSP_PATH + "ItemPopup2";
	}

	@RequestMapping(value = "/app/Unilite/app/popup/ItemPopup2.do")
	public String itemPopup2Win(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();
		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));

		return JSP_PATH + "ItemPopup2Win";
	}

	/**
	 * 거래처별 품목정보 팝업
	 * @param popupID
	 * @param _req
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/CustPumokPopup.do")
	public String CustPumokPopup(String popupID, ExtHtttprequestParam _req, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();
		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

		return JSP_PATH + "CustPumokPopupWin";
	}

	/**
	 * 사업자별 품목정보 팝업
	 * @param popupID
	 * @param _req
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/com/popup/bk/DivPumokPopup.do")
	public String divPumok(String popupID, ExtHtttprequestParam _req, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();
		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

		return JSP_PATH + "DivPumokPopup";
	}

	/**
	 * 사용자별 BOX정보팝업
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/com/popup/bk/DivBoxPopup.do")
	public String DivBoxPopup(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();
		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));

		return JSP_PATH + "DivBoxPopup";
	}

	@RequestMapping(value = "/app/Unilite/app/popup/DivPumokPopup.do")
	public String divPumokWin(String popupID, ExtHtttprequestParam _req, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();

		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

		return JSP_PATH + "DivPumokPopupWin";
	}

	@RequestMapping(value = "/com/popup/bk/DivPumok2Popup.do")
	public String divPumok2(String popupID, ExtHtttprequestParam _req, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();
		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

		return JSP_PATH + "DivPumok2Popup";
	}

	@RequestMapping(value = "/app/Unilite/app/popup/DivPumok2Popup.do")
	public String divPumok2Win(String popupID, ExtHtttprequestParam _req, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();

		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

		return JSP_PATH + "DivPumok2PopupWin";
	}

	@RequestMapping(value = "/app/Unilite/app/popup/CommissionDivPumokPopup.do")
	public String commissionDivPumokWin(String popupID, ExtHtttprequestParam _req, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();

		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

		return JSP_PATH + "CommissionDivPumokPopupWin";
	}

	/**
	 * 대표모델 팝업
	 * @param popupID
	 * @param _req
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/com/popup/bk/ItemGroupPopup.do")
	public String itemGroup(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();

		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

		return JSP_PATH + "ItemGroupPopup";
	}

	@RequestMapping(value = "/app/Unilite/app/popup/ItemGroupPopup.do")
	public String itemGroupWin(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();

		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

		return JSP_PATH + "ItemGroupPopupWin";
	}

	/**
	 * 사업장별 대표모델 팝업
	 * @param popupID
	 * @param _req
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/com/popup/bk/DivItemGroupPopup.do")
	public String divItemGroup(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();

		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

		return JSP_PATH + "DivItemGroupPopup";
	}

	@RequestMapping(value = "/app/Unilite/app/popup/DivItemGroupPopup.do")
	public String divItemGroupWin(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();

		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

		return JSP_PATH + "DivItemGroupPopupWin";
	}

	/**
	 * 세무서코드 팝업
	 * @param popupID
	 * @param _req
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/com/popup/bk/SafferTaxPopup.do")
	public String safferTaxPopup() throws Exception {
		return JSP_PATH + "SafferTaxPopup";
	}

	@RequestMapping(value = "/app/Unilite/app/popup/SafferTaxPopup.do")
	public String safferTaxPopupWin() throws Exception {
		return JSP_PATH + "SafferTaxPopupWin";
	}

	/**
	 * JS용 그리드 환경 설정창
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/GridConfigPopup.do")
	public String gridConfigPopupWin(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		List<CodeDetailVO> cdo = codeInfo.getCodeList("B251");
		String userId = GStringUtils.toLowerCase(loginVO.getUserID());
		boolean isAdmin = false;
		for(CodeDetailVO cdMap : cdo) {
			if(userId.equals(GStringUtils.toLowerCase(cdMap.getRefCode1()))) {
				isAdmin = true;
			}
		}
		model.addAttribute("isAdmin", isAdmin);
		return JSP_PATH + "GridConfigPopupWin";
	}

	/**
	 * JS용 그리드 환경 설정 신규 저장
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/GridNewConfigPopup.do")
	public String gridNewConfigPopupWin(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		List<CodeDetailVO> cdo = codeInfo.getCodeList("B251");
		String userId = loginVO.getUserID();
		boolean isAdmin = false;
		for(CodeDetailVO cdMap : cdo) {
			if(userId.equals(cdMap.getRefCode1())) {
				isAdmin = true;
			}
		}
		if(isAdmin) {
			String[] arr = {"C","P"};
			model.addAttribute("TYPE_STORE", comboService.getComboList("AU", "B125", loginVO, null,arr ));
		}else {
			String[] arr = {"P"};
			model.addAttribute("TYPE_STORE", comboService.getComboList("AU", "B125", loginVO, null,arr ));
		}
		return JSP_PATH + "GridNewConfigPopupWin";
	}

	@RequestMapping(value = "/app/Unilite/app/popup/DriverPopup.do")
	public String driverPopupWin() throws Exception {
		return JSP_PATH + "DriverPopupWin";
	}

	@RequestMapping(value = "/app/Unilite/app/popup/MechanicPopupWin.do")
	public String mechanicPopupWin() throws Exception {
		return JSP_PATH + "MechanicPopupWin";
	}

	@RequestMapping(value = "/app/Unilite/app/popup/VehiclePopup.do")
	public String vehiclePopupWin() throws Exception {
		return JSP_PATH + "VehiclePopupWin";
	}

	@RequestMapping(value = "/app/Unilite/app/popup/CountDatePopup.do")
	public String countdatePopupWin() throws Exception {
		return JSP_PATH + "CountDatePopupWin";
	}

	@RequestMapping(value = "/app/Unilite/app/popup/ShopPopup.do")
	public String shopPopupWin() throws Exception {
		return JSP_PATH + "ShopPopupWin";
	}

	@RequestMapping(value = "/app/Unilite/app/popup/LotPopup.do")
	public String lotPopupWin() throws Exception {
		return JSP_PATH + "LotPopupWin";
	}

	@RequestMapping(value = "/app/Unilite/app/popup/LotPopupMulti.do")
	public String lotPopupMultiWin(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();

		model.addAttribute("COMBO_WH_LIST"		, comboService.getWhList(param));
		//20190626 추가
		model.addAttribute("COMBO_WH_CELL_LIST"	, comboService.getWhCellList(param));

		return JSP_PATH + "LotPopupMultiWin";
	}

	/**20190508
	 * 기타출고 등록(LOT)에서 사용하는 현재고 존재하는 데이터만 보여주는 LOT팝업
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/LotPopupStock.do")
	public String LotPopupStock (String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();

		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

		return JSP_PATH + "LotPopupStockWin";
	}

	@RequestMapping(value = "/app/Unilite/app/popup/HsPopup.do")
	public String hsPopupWin() throws Exception {
		return JSP_PATH + "HsPopupWin";
	}

	@RequestMapping(value = "/app/Unilite/app/popup/LotNoPopup.do")
	public String lotNoPopupWin(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
		return JSP_PATH + "LotNoPopupWin";
	}

	@RequestMapping(value = "/app/Unilite/app/popup/LotNoYpPopup.do")
	public String lotNoYpPopupWin(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
		return JSP_PATH + "LotNoYpPopupWin";
	}

	@RequestMapping(value = "/app/Unilite/app/popup/LotNoYpPopup2.do")
	public String lotNoYpPopupWin2(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
		return JSP_PATH + "LotNoYpPopupWin2";
	}

	@RequestMapping(value = "/app/Unilite/app/popup/ReqNumPopup.do")
	public String reqNumPopupWin(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
		return JSP_PATH + "ReqNumPopupWin";
	}

	//계획번호팝업
	@RequestMapping(value = "/app/Unilite/app/popup/PlanNumPopup.do")
	public String planNumPopupWin(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
		return JSP_PATH + "PlanNumPopupWin";
	}

	//관세환급번호팝업
	@RequestMapping(value = "/app/Unilite/app/popup/ReturnNumPopup.do")
	public String returnNumPopupWin(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
		return JSP_PATH + "ReturnNumPopupWin";
	}

	/**
	 * 관리번호 팝업
	 * @param popupID
	 * @param _req
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/ProjectPopup.do")
	public String projectPopupWin() throws Exception {
		return JSP_PATH + "ProjectPopupWin";
	}

	/**
	 * 프로젝트정보 팝업
	 * @param popupID
	 * @param _req
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/PjtPopup.do")
	public String PjtPopupWin(String popupID, ExtHtttprequestParam _req, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();

		return JSP_PATH + "PjtPopupWin";
	}

	/**
	 * 수불번호 팝업
	 * @param popupID
	 * @param _req
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/InoutNumPopup.do")
	public String inoutNumPopup() throws Exception {
		return JSP_PATH + "InoutNumPopupWin";
	}

	/**
	 * 수주번호 팝업
	 * @param popupID
	 * @param _req
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/OrderNumPopup.do")
	public String orderNumPopup() throws Exception {
		return JSP_PATH + "OrderNumPopupWin";
	}

	/**
	 * 원본세금계산서 조회 팝업
	 * @param popupID
	 * @param _req
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/TaxBillSearchPopup.do")
	public String TaxBillSearchPopup() throws Exception {
		return JSP_PATH + "TaxBillSearchPopupWin";
	}

	@RequestMapping(value = "/app/Unilite/app/popup/CustBillPrsnPopupWin.do")
	public String custBillPrsnPopupWin() throws Exception {
		return JSP_PATH + "CustBillPrsnPopupWin";
	}

	@RequestMapping(value = "/app/Unilite/app/popup/CustBillPrsnPopupMultiWin.do")
	public String custBillPrsnPopupMultiWin() throws Exception {
		return JSP_PATH + "CustBillPrsnPopupMultiWin";
	}

	@RequestMapping(value = "/app/Unilite/app/popup/BomCopyPopup.do")
	public String bomCopyWin(LoginVO loginVO,  ModelMap model) throws Exception {
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
		for(CodeDetailVO map : gsExchgRegYN) {
			if("Y".equals(map.getRefCode1())) {
				model.addAttribute("gsExchgRegYN", map.getCodeNo());
			}
		}
		return JSP_PATH + "BomCopyPopupWin";
	}

	@RequestMapping(value = "/app/Unilite/app/popup/CreditCard2.do")
	public String creditCard2() throws Exception {
		return JSP_PATH + "CreditCard2PopupWin";
	}

	@RequestMapping(value = "/app/Unilite/app/popup/OutStockNum.do")
	public String OutStockNum() throws Exception {
		return JSP_PATH + "OutStockNumPopupWin";
	}

	@RequestMapping(value = "/app/Unilite/app/popup/CustCreditCard.do")
	public String custCreditCard() throws Exception {
		return JSP_PATH + "CustCreditCardPopupWin";
	}

	@RequestMapping(value = "/app/Unilite/app/popup/CreditCard.do")
	public String creditCard() throws Exception {
		return JSP_PATH + "CreditCardPopupWin";
	}

	@RequestMapping(value = "/app/Unilite/app/popup/BinPopup.do")
	public String binPopupWin() throws Exception {
		return JSP_PATH + "BinPopupWin";
	}

	@RequestMapping(value = "/app/Unilite/app/popup/PosPopup.do")
	public String PosPopup(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

		return JSP_PATH + "PosPopupWin";
	}

	/**
	 * 공정정보 팝업
	 * @param popupID
	 * @param _req
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/ProgWorkCode.do")
	public String ProgWorkCode(String popupID, ExtHtttprequestParam _req, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();

		return JSP_PATH + "ProgWorkCodePopupWin";
	}

	/**
	 * 설비정보 팝업
	 * @param popupID
	 * @param _req
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/EquipCode.do")
	public String EquipCode(String popupID, ExtHtttprequestParam _req, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();

		return JSP_PATH + "EquipCodePopupWin";
	}

	/**
	 * 금형정보 팝업
	 * @param popupID
	 * @param _req
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/MoldCode.do")
	public String MoldCode(String popupID, ExtHtttprequestParam _req, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();

		return JSP_PATH + "MoldCodePopupWin";
	}

	/**
	 * 작업지시정보 팝업
	 * @param popupID
	 * @param _req
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/WkordNum.do")
	public String WkordNum(String popupID, ExtHtttprequestParam _req, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();

		model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));

		return JSP_PATH + "WkordNumWin";
	}
	/**
	 * 무역 수입NEGO 관리번호 팝업
	 * @param popupID
	 * @param _req
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/NegoIncomNoPopup.do")
	public String NegoIncomNoPopup(String popupID, ExtHtttprequestParam _req, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();

		return JSP_PATH + "NegoIncomNoPopupWin";
	}

	/**
	 * 무역 수출 NEGO 관리번호 팝업
	 * @param popupID
	 * @param _req
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/NegoNoPopup.do")
	public String NegoNoPopup(String popupID, ExtHtttprequestParam _req, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();

		return JSP_PATH + "NegoNoPopupWin";
	}

	/**
	 * 무역 수입 통관관리번호 팝업
	 * @param popupID
	 * @param _req
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/PassIncomNoPopup.do")
	public String PassIncomNoPopup(String popupID, ExtHtttprequestParam _req, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();

		return JSP_PATH + "PassIncomNoPopupWin";
	}

	/**
	 * 무역 수입 OFFER관리번호 팝업
	 * @param popupID
	 * @param _req
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/IncomOfferNoPopup.do")
	public String IncomOfferNoPopup(String popupID, ExtHtttprequestParam _req, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();

		return JSP_PATH + "IncomOfferNoPopupWin";
	}

	/**
	 * 무역 수입 B/L관리번호 팝업
	 * @param popupID
	 * @param _req
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/IncomBlNoPopup.do")
	public String IncomBlNoPopup(String popupID, ExtHtttprequestParam _req, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();

		return JSP_PATH + "IncomBlNoPopupWin";
	}

	/**
	 * 배송처
	 * @param popupID
	 * @param _req
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/DeliveryPopup.do")
	public String DeliveryPopup(String popupID, ExtHtttprequestParam _req, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();

		return JSP_PATH + "DeliveryPopupWin";
	}


	/* -----------------------------------------회계팝업 시작------------------------------------- */

	/**
	 * 사업장 팝업
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/AccntDivCodePopup.do")
	public String accntDivCodePopup() throws Exception {
		return JSP_PATH + "AccntDivCodePopupWin";
	}

	/**
	 * 계정과목 팝업
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/AccntsPopup.do")
	public String accntsPopupWin() throws Exception {
		return JSP_PATH + "AccntsPopupWin";
	}

	/**
	 * 외화계정과목 팝업
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/ForeignAccntsPopup.do")
	public String foreignAccntPopupWin() throws Exception {
		return JSP_PATH + "ForeignAccntsPopupWin";
	}

	/**
	 * 환산계정과목 팝업
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/ExchangeAccntsPopup.do")
	public String exchangeAccntPopupWin() throws Exception {
		return JSP_PATH + "ExchangeAccntsPopupWin";
	}
	/**
	 * 지출결의계정과목 팝업
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/AccntsPayPopup.do")
	public String accntsPayPopupWin() throws Exception {
		return JSP_PATH + "AccntsPayPopupWin";
	}
	/**
	 * 계정과목,관리항목 팝업
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/AccntsPopupWithAcCode.do")
	public String accntsPopupWithAcCodeWin() throws Exception {
		return JSP_PATH + "AccntsPopupWithAcCodeWin";
	}

	/**
	 * 관리항목 팝업
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/ManagePopup.do")
	public String managePopupWin() throws Exception {
		return JSP_PATH + "ManagePopupWin";
	}

	/**
	 * 관리항목 팝업(사용자)
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/UserManagePopup.do")
	public String userManagePopupWin() throws Exception {
		return JSP_PATH + "UserManagePopupWin";
	}

	/**
	 * 적요 팝업
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/RemarkPopup.do")
	public String remarkPopupWin() throws Exception {
		return JSP_PATH + "RemarkPopupWin";
	}

	/**
	 * 적요 팝업(물류)
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/RemarkDistributionPopup.do")
	public String remarkDistributionPopupWin() throws Exception {
		return JSP_PATH + "RemarkDistributionPopupWin";
	}

	/**
	 * 기간비용 팝업
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/CostPopup.do")
	public String costPopupWin() throws Exception {
		return JSP_PATH + "CostPopupWin";
	}

	/**
	 * 회계담당자 팝업
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/AccntPrsnPopup.do")
	public String accntPrsnPopupWin() throws Exception {
		return JSP_PATH + "AccntPrsnPopupWin";
	}

	/**
	 * 경비코드 팝업
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/ExpensePopup.do")
	public String expensePopupWin() throws Exception {
		return JSP_PATH + "ExpensePopupWin";
	}

	/**
	 * 수당/공제코드 팝업
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/AllowPopup.do")
	public String allowPopupWin() throws Exception {
		return JSP_PATH + "AllowPopupWin";
	}

	/**
	 * 소득자 팝업
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/EarnerPopup.do")
	public String earnerPopupWin() throws Exception {
		return JSP_PATH + "EarnerPopupWin";
	}

	/**
	 * 부동산 팝업
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/RealtyPopup.do")
	public String realtyPopupWin() throws Exception {
		return JSP_PATH + "RealtyPopupWin";
	}

	/**
	 * 자산코드 팝업
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/AssetPopup.do")
	public String assetPopupWin() throws Exception {
		return JSP_PATH + "AssetPopupWin";
	}

	/**
	 * Cost Pool 팝업
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/CostPoolPopup.do")
	public String costPoolPopupWin() throws Exception {
		return JSP_PATH + "CostPoolPopupWin";
	}

	/**
	 * Cost Pool Cbm600t팝업
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/CostPoolCbm600tPopup.do")
	public String costPoolCbm600tPopupWin() throws Exception {
		return JSP_PATH + "CostPoolCbm600tPopupWin";
	}

	/**
	 * 단위 팝업
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/UnitPopup.do")
	public String unitPopupWin() throws Exception {
		return JSP_PATH + "UnitPopupWin";
	}

	/**
	 * 어음종류 팝업
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/NoteTypePopup.do")
	public String noteTypePopupWin() throws Exception {
		return JSP_PATH + "NoteTypePopupWin";
	}

	/**
	 * 어음번호 팝업
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/NoteNumPopup.do")
	public String noteNumPopupWin() throws Exception {
		return JSP_PATH + "NoteNumPopupWin";
	}

	/**
	 * 수표번호 팝업
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/CheckNumPopup.do")
	public String checkNumPopupWin() throws Exception {
		return JSP_PATH + "CheckNumPopupWin";
	}

	/**
	 * 화폐단위 팝업
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/MoneyPopup.do")
	public String moneyPopupWin() throws Exception {
		return JSP_PATH + "MoneyPopupWin";
	}

	/**
	 * L/C번호(수출) 팝업
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/ExLcnoPopup.do")
	public String exLcnoPopupWin() throws Exception {
		return JSP_PATH + "ExLcnoPopupWin";
	}

	/**
	 * L/C번호(수입) 팝업
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/InLcnoPopup.do")
	public String inLcnoPopupWin() throws Exception {
		return JSP_PATH + "InLcnoPopupWin";
	}

	/**
	 * B/L번호(수출) 팝업
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/ExBlnoPopup.do")
	public String exBlnoPopupWin() throws Exception {
		return JSP_PATH + "ExBlnoPopupWin";
	}

	/**
	 * B/L번호(수입) 팝업
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/InBlnoPopup.do")
	public String inBlnoPopupWin() throws Exception {
		return JSP_PATH + "InBlnoPopupWin";
	}

	/**
	 * 수출신고번호
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/PassSerNoPopup.do")
	public String passSerNoPopupWin() throws Exception {
		return JSP_PATH + "PassSerNoPopupWin";
	}

	/**
	 * 프로젝트 팝업
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/AcProjectPopup.do")
	public String acProjectPopupWin() throws Exception {
		return JSP_PATH + "AcProjectPopupWin";
	}

	/**
	 * 급호 팝업
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/PayGradePopup.do")
	public String payGradePopupWin(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		//param에 COMP_CODE 정보 추가
		param.put("S_COMP_CODE",loginVO.getCompCode());

		//CODE_NAME 가져오기
		List<Map<String, Object>> payGradeNameList = popupService.fnHum100P1(param);
		model.addAttribute("payGradeNameList",ObjUtils.toJsonStr(payGradeNameList));

		return JSP_PATH + "PayGradePopupWin";
	}

	/**
	 * 자금항목 팝업
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/FundPopup.do")
	public String fundPopupWin() throws Exception {
		return JSP_PATH + "FundPopupWin";
	}

	/**
	 * 신용카드번호 팝업
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/CreditNoPopup.do")
	public String creditNoPopupWin() throws Exception {
		return JSP_PATH + "CreditNoPopupWin";
	}

	/**
	 * 신용카드번호 팝업
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/CreditNoPopupJ.do")
	public String creditNoPopupJWin() throws Exception {
		return JSP_PATH + "CreditNoPopupJWin";
	}

	/**
	 * 매입매출구분 팝업
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/PurSaleTypePopup.do")
	public String purSaleTypePopupWin() throws Exception {
		return JSP_PATH + "PurSaleTypePopupWin";
	}

	/**
	 * 증빙유형 팝업
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/ProofPopup.do")
	public String proofPopupWin() throws Exception {
		return JSP_PATH + "ProofPopupWin";
	}

	/**
	 * 전자발행여부 팝업
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/EmissionPopup.do")
	public String emissionPopupWin() throws Exception {
		return JSP_PATH + "EmissionPopupWin";
	}

	/**
	 * 통장번호 팝업
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/BankBookPopup.do")
	public String bankBookPopupWin() throws Exception {
		return JSP_PATH + "BankBookPopupWin";
	}

	/**
	 * 통장번호코드 팝업 (보안 이슈, 계좌번호 코드로 관리)
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/BankBookCodePopup.do")
	public String bankBookCodePopupWin() throws Exception {
		return JSP_PATH + "BankBookCodePopupWin";
	}

	/**
	 * 차입금번호 팝업
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/DebtNoPopup.do")
	public String debtNoPopupWin() throws Exception {
		return JSP_PATH + "DebtNoPopupWin";
	}

	/**
	 * 계좌번호 팝업
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/BankAccntPopup.do")
	public String bankAccntPopupWin() throws Exception {
		return JSP_PATH + "BankAccntPopupWin";
	}

	/**
	 * 차량번호 팝업
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/CarNumPopup.do")
	public String carNumPopupWin() throws Exception {
		return JSP_PATH + "CarNumPopupWin";
	}

	/**
	 * 거래은행 팝업
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/BusinessBankPopup.do")
	public String businessBankPopupWin() throws Exception {
		return JSP_PATH + "BusinessBankPopupWin";
	}

	/**
	 * 통화코드 팝업
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/MoneyUnitPopup.do")
	public String moneyUnitPopupWin() throws Exception {
		return JSP_PATH + "MoneyUnitPopupWin";
	}

	/**
	 * 지급처 팝업
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/PayCustomPopup.do")
	public String payCustomPopupWin() throws Exception {
		return JSP_PATH + "PayCustomPopupWin";
	}

	/**
	 * 예산과목 팝업
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/BudgPopup.do")
	public String budgPopupWin(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		//param에 COMP_CODE 정보 추가
		param.put("S_COMP_CODE",loginVO.getCompCode());

		//CODE_NAME 가져오기
		List<Map<String, Object>> budgNameList = popupService.selectBudgName(param, loginVO);
		model.addAttribute("budgNameList",ObjUtils.toJsonStr(budgNameList));

		return JSP_PATH + "BudgPopupWin";
	}

	/**
	 * 회사 팝업
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/com/popup/bk/CompPopup.do")
	public String compPopup() throws Exception {
		return JSP_PATH + "CompPopup";
	}

	@RequestMapping(value = "/app/Unilite/app/popup/CompPopup.do")
	public String compPopupWin() throws Exception {
		return JSP_PATH + "CompPopupWin";
	}

	/**
	 * 채권번호 팝업
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/com/popup/bk/ConfRecePopup.do")
	public String confRecePopup() throws Exception {
		return JSP_PATH + "ConfRecePopup";
	}

	@RequestMapping(value = "/app/Unilite/app/popup/ConfRecePopup.do")
	public String confRecePopupWin() throws Exception {
		return JSP_PATH + "ConfRecePopupWin";
	}

	/**
	 * 가지급전표 팝업
	 * @param popupID
	 * @param _req
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/AdvmReqSlipNo.do")
	public String AdvmReqSlipNo(String popupID, ExtHtttprequestParam _req, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();

		return JSP_PATH + "AdvmReqSlipNoWin";
	}

	/**
	 * 클레임번호 팝업
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/ClaimPopup.do")
	public String ClaimPopupWin() throws Exception {
		return JSP_PATH + "ClaimPopupWin";
	}


	/* -----------------------------------------회계팝업 끝------------------------------------- */
	/**
	 * 공통코드 동적 팝업
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/CommonPopup.do")
	public String commonPopupWin() throws Exception {
		return JSP_PATH + "CommonPopupWin";
	}

	/**
	 * 사용자정의 동적 팝업
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/UserDefinePopup.do")
	public String userDefinePopupWin() throws Exception {
		return JSP_PATH + "UserDefinePopupWin";
	}

	/**
	 * 부서 조직도 팝업
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/DeptTree.do")
	public String deptTreePopupWin() throws Exception {
		return JSP_PATH + "DeptTree";
	}

	/**
	 * 사업코드 트리 팝업
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/PjtTree.do")
	public String pjtTreePopupWin() throws Exception {
		return JSP_PATH + "PjtTree";
	}

	/**
	 * 사업코드 입력 팝업 (트리 팝업 아님
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/PjtNonTreePopup.do")
	public String pjtNonTreePopupWin() throws Exception {
		return JSP_PATH + "PjtNonTreePopupWin";
	}

	/**
	 * 사업코드 트리(그리드) 팝업
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/PjtTreeGPopup.do")
	public String pjtTreeGPopupWin() throws Exception {
		return JSP_PATH + "PjtTreeGPopupWin";
	}

	/**
	 * 비과세코드 팝업
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/NonTaxPopup.do")
	public String nonTaxPopupWin() throws Exception {
		return JSP_PATH + "NonTaxPopupWin";
	}

	/**
	 * IFRS - 자산코드 팝업
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/IFRSAssetPopup.do")
	public String IFRSassetPopupWin() throws Exception {
		return JSP_PATH + "IFRSAssetPopupWin";
	}

	/**
	 * Branch 연동 - 구매카드 팝업
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/PurchaseCardPopup.do")
	public String PurchaseCardPopupWin() throws Exception {
		return JSP_PATH + "PurchaseCardPopupWin";
	}

	/**
	 * COM ABA210 팝업
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/ComAba210Popup.do")
	public String ComAba210PopupWin() throws Exception {
		return JSP_PATH + "ComAba210PopupWin";
	}

	/**
	 * COM ABA900 팝업
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/ComAba900Popup.do")
	public String ComAba900PopupWin() throws Exception {
		return JSP_PATH + "ComAba900PopupWin";
	}

	//관리코드팝업(Z_ZCC600T_KD)
	@RequestMapping(value = "/app/Unilite/app/popup/EntryNumPopup1.do")
	public String entryNumPopup1Win(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();

		return JSP_PATH + "EntryNumPopup1Win";
	}

	//관리코드팝업(Z_ZCC700T_KD)
	@RequestMapping(value = "/app/Unilite/app/popup/EntryNumPopup2.do")
	public String entryNumPopup2Win(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();

		return JSP_PATH + "EntryNumPopup2Win";
	}

	//관리번호 (EQU_CODE)
	/**
	 * 관리번호
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/EquCodePopup.do")
	public String EquCodePopup(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();

		return JSP_PATH + "EquCodePopupWin";
	}

	/**
	 * 설비정보_정규
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/EquMachCodePopup.do")
	public String EquMachCodePopup(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();

		return JSP_PATH + "EquMachCodePopupWin";
	}

	/**
	 * 금형정보_정규
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/EquMoldCodePopup.do")
	public String EquMoldCodePopup(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();

		return JSP_PATH +"EquMoldCodePopupWin";
	}

	/**
	 * 코어정보_정규
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/CoreCodePopup.do")
	public String CoreCodePopup(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();

		return JSP_PATH + "CoreCodePopupWin";
	}
	//소모공구 정보 (TreeCodePopup)
	/**
	 * 소모공구 정보
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/TreeCodePopup.do")
	public String TreeCodePopup(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();

		return JSP_PATH + "TreeCodePopupWin";
	}

	//접수번호 (AS_NUM)
	/**
	 * 접수번호
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/AsNumPopup.do")
	public String AsNumPopup(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();

		return JSP_PATH + "AsNumPopupWin";
	}

	/**
	 * SMS 전송
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/SendSMS.do")
	public String SendSMS(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();

		return JSP_PATH + "SendSMSPopupWin";
	}

	//모니터정보팝업(Z_ZEE200T_KD)
	@RequestMapping(value = "/app/Unilite/app/popup/MregNumPopup.do")
	public String mRegNumPopupWin(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();

		return JSP_PATH + "MregNumPopupWin";
	}

	//SW정보팝업(Z_ZEE100T_KD)
	@RequestMapping(value = "/app/Unilite/app/popup/SwCodePopup.do")
	public String swCodePopupWin(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();

		return JSP_PATH + "SwCodePopupWin";
	}

	//의뢰서번호(S_ZCC800T_KD)
	@RequestMapping(value = "/app/Unilite/app/popup/ReqNum2Popup.do")
	public String reqNum2PopupWin(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();

		return JSP_PATH + "ReqNum2PopupWin";
	}

	/**
	 * 농가별 입고정보
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/FarmInout.do")
	public String FarmInout(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();

		return JSP_PATH + "FarmInoutPopupWin";
	}

 	/**
	 * 비밀번호 변경 팝업
	 * @param loginVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/changePassword.do")
	public String changePassword( LoginVO loginVO, ModelMap model) throws Exception {
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;
		cdo = codeInfo.getCodeInfo("B110", "40");	//대소문자 구분
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("caseSensYN",cdo.getRefCode1());
		}
		cdo = codeInfo.getCodeInfo("B110", "20");	//대소문자 구분
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("numberPast",cdo.getRefCode1());
		}
		cdo = codeInfo.getCodeInfo("B110", "10");	//Y이면 주기 초과 미변경 시 로그아웃
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("logOutYN",cdo.getRefCode3());
		}

		Map passwordChangeInfo = (Map)baseCommonService.getUserLoginInfo(null, loginVO);
		if(passwordChangeInfo != null)	{
			model.addAttribute("PWD_CYCLE_SHOW_YN",  "Y");
			model.addAttribute("PWD_DAY_DIFF",  ObjUtils.getSafeString(passwordChangeInfo.get("PWD_DAY_DIFF")));
			model.addAttribute("PWD_CYCLE",  ObjUtils.getSafeString(passwordChangeInfo.get("PWD_CYCLE")));
		} else {
			model.addAttribute("PWD_CYCLE_SHOW_YN",  "N");
			model.addAttribute("PWD_DAY_DIFF",  "");
			model.addAttribute("PWD_CYCLE",  "180");
		}
		return JSP_PATH + "changePasswordPopupWin";
	}

	/**
	 * 비밀번호 변경 팝업
	 * @param loginVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/showAlertMsgPopup.do")
	public String showAlertMsgPopup( LoginVO loginVO, ModelMap model) throws Exception {
		return JSP_PATH + "showAlertMsgPopupWin";
	}

	/**
	 * 사업자별 품목정보 팝업(양평)
	 * @param popupID
	 * @param _req
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/DivPumokPopup_YP.do")
	public String divPumokPopup_YP(String popupID, ExtHtttprequestParam _req, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();

		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

		return JSP_PATH + "DivPumokPopupWin_YP";
	}

	/**
	 * 작업지시정보(KDG) 팝업
	 * @param popupID
	 * @param _req
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/WkordNum_KDG.do")
	public String WkordNum_KDG(String popupID, ExtHtttprequestParam _req, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();

		model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));

		return JSP_PATH + "WkordNumWin_KDG";
	}

	/**
	 * 작업지시정보(JW) 팝업
	 * @param popupID
	 * @param _req
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/WkordNum_JW.do")
	public String WkordNum_JW(String popupID, ExtHtttprequestParam _req, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();

		model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));

		return JSP_PATH + "WkordNumWin_JW";
	}

	/**
	 * 목형정보 팝업
	 * @param popupID
	 * @param _req
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/WoodenCode.do")
	public String WoodenCode(String popupID, ExtHtttprequestParam _req, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();

		return JSP_PATH + "WoodenCodePopupWin";
	}

	/**
	 * 창고팝업
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/WhCodePopup.do")
	public String whCodePopupWin() throws Exception {
		return JSP_PATH + "WhCodePopupWin";
	}

	/**
	 * 프로그램 팝업
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/programPopup.do")
	public String programPopupWin() throws Exception {
		return JSP_PATH + "ProgramPopupWin";
	}

	/**
	 * 성분 팝업
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/chemicalPopup.do")
	public String chemicalPopupWin() throws Exception {
		return JSP_PATH + "ChemicalPopupWin";
	}

	/**
	 * LAP NO 팝업
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/LabNoPopup.do")
	public String LabNoPopup(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();

		return JSP_PATH + "LabNoPopupWin";
	}

	/**20190909
	 * LOT 그리드용 (멀티 선택), 현재고 > 0, 품목 팝업 대신 사용 (출고등록(건별)(LOT팝업) (str106ukrv))
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/LotPopupItem.do")
	public String LotPopupItem (String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();

		model.addAttribute("COMBO_WH_LIST"		, comboService.getWhList(param));
		model.addAttribute("COMBO_WH_CELL_LIST"	, comboService.getWhCellList(param));

		return JSP_PATH + "LotPopupItemWin";
	}

	/**
	 * LOT 재고 팝업 (MIT) - 20191113 추가
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/LotPopupMulti_mit.do")
	public String lotPopupMultiWin_mit(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();

		model.addAttribute("COMBO_WH_LIST"		, comboService.getWhList(param));
		model.addAttribute("COMBO_WH_CELL_LIST"	, comboService.getWhCellList(param));

		return JSP_PATH + "LotPopupMultiWin_mit";
	}

	/**
	 * 실사일(외주) 팝업  - 20200217 추가
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/CountDateOutPopup.do")
	public String countDateOutPopupWin() throws Exception {
		return JSP_PATH + "CountDateOutPopupWin";
	}

	/**
	 * 출하지시번호 팝업 - 20200228 추가
	 * @param popupID
	 * @param _req
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/IssueReqNumPopup.do")
	public String issueReqNumPopup() throws Exception {
		return JSP_PATH + "IssueReqNumPopupWin";
	}

	/**
	 * MIT IFRS - 자산코드 팝업
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/s_asset_mitPopup.do")
	public String s_asset_mitPopupWin() throws Exception {
		return JSP_PATH + "s_asset_mitPopupWin";
	}

	/**
	 * LOT 재고 팝업 (IN) - 20200506 추가
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/LotPopupMulti_in.do")
	public String lotPopupMultiWin_in(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();

		model.addAttribute("COMBO_WH_LIST"		, comboService.getWhList(param));
		model.addAttribute("COMBO_WH_CELL_LIST"	, comboService.getWhCellList(param));

		return JSP_PATH + "LotPopupMultiWin_in";
	}
	/**
	 * 구매확인서팝업
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/purchDocNoPopup.do")
	public String purchDonNoPopupWin() throws Exception {

		return JSP_PATH + "PurchDocNoPopupWin";
	}

	/**
	 * 팜매이력 S/N팝업(MIT)
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/sasLotPopup.do")
	public String sasLotPopupWin() throws Exception {

		return JSP_PATH + "SasLotPopupWin";
	}

	/**
	 * AS 접수 팝업(MIT)
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/receiptNumPopup.do")
	public String receiptNumPopupWin() throws Exception {

		return JSP_PATH + "ReceiptNumPopupWin";
	}

	/**
	 * AS 견적 팝업(MIT)
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/quotNumPopup.do")
	public String quotNumPopupWin() throws Exception {

		return JSP_PATH + "QuotNumPopupWin";
	}

	/**
	 * AS 수리 팝업(MIT)
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/repairNumPopup.do")
	public String repairNumPopupWin() throws Exception {

		return JSP_PATH + "RepairNumPopupWin";
	}

	/**
	 * AS 수리이력 팝업(MIT)
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/repairHistoryPopup.do")
	public String repairHistoryPopupWin() throws Exception {
		return JSP_PATH + "RepairHistoryPopupWin";
	}

	/**
	 * 공정불량 팝업
	 * @param popupID
	 * @param _req
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/BadCode.do")
	public String badCode(String popupID, ExtHtttprequestParam _req, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();

		return JSP_PATH + "BadCodePopupWin";
	}


	/**
	 * 사업자별 품목정보 팝업(월드와이드메모리) - 20201125 추가
	 * @param popupID
	 * @param _req
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/DivPumokPopup_WM.do")
	public String divPumokPopup_WM(String popupID, ExtHtttprequestParam _req, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields	= {  };
		NavigatorInfo navigator		= new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param	= navigator.getParam();

		model.addAttribute("COMBO_ITEM_LEVEL1"	, comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2"	, comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3"	, comboService.getItemLevel3(param));
		model.addAttribute("COMBO_WH_LIST"		, comboService.getWhList(param));

		return JSP_PATH + "DivPumokPopupWin_WM";
	}
	
		
	/**
	 * AS 품목 팝업
	 * @param popupID
	 * @param _req
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/ASDivPumokPopup.do")
	public String asDivPumokWin(String popupID, ExtHtttprequestParam _req, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();

		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

		return JSP_PATH + "ASDivPumokPopupWin";
	}
	
	/**
	 * 엠아이텍 대리점 품목팝업
	 * @param popupID
	 * @param _req
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/AgentDivPumokPopup.do")
	public String AjentDivPumokPopup(String popupID, ExtHtttprequestParam _req, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();
		

		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
		
		model.addAttribute("COMBO_DIV_CODE", comboService.getDivCode(param));
		
		return JSP_PATH + "AgentDivPumokPopupWin";
	}
	
	/**
	 * AS 자산 팝업
	 * @param popupID
	 * @param _req
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/ASAssetPopup.do")
	public String asAssetPopup(String popupID, ExtHtttprequestParam _req, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();

		return JSP_PATH + "ASAssetPopupWin";
	}


 	/**
	 * 비밀번호 변경 팝업(외부사용자) - 20210427 추가
	 * @param loginVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/changePassword2.do")
	public String changePassword2( LoginVO loginVO, ModelMap model ) throws Exception {
		CodeInfo codeInfo	= this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo	= null;
		cdo = codeInfo.getCodeInfo("B110", "40");	//대소문자 구분
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("caseSensYN",cdo.getRefCode5());
		}
		cdo = codeInfo.getCodeInfo("B110", "20");	//대소문자 구분
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("numberPast",cdo.getRefCode5());
		}
		cdo = codeInfo.getCodeInfo("B110", "10");	//Y이면 주기 초과 미변경 시 로그아웃
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("logOutYN",cdo.getRefCode6());
		}

		Map passwordChangeInfo = (Map)baseCommonService.getUserLoginInfo2(null, loginVO);
		if(passwordChangeInfo != null)	{
			model.addAttribute("PWD_CYCLE_SHOW_YN"	, "Y");
			model.addAttribute("PWD_DAY_DIFF"		, ObjUtils.getSafeString(passwordChangeInfo.get("PWD_DAY_DIFF")));
			model.addAttribute("PWD_CYCLE"			, ObjUtils.getSafeString(passwordChangeInfo.get("PWD_CYCLE")));
		} else {
			model.addAttribute("PWD_CYCLE_SHOW_YN"	, "N");
			model.addAttribute("PWD_DAY_DIFF"		, "");
			model.addAttribute("PWD_CYCLE"			, "180");
		}
		return JSP_PATH + "changePasswordPopupWin2";
	}
	
	/**
	 * 외부 사용자용 품목 팝업 - 20210803
	 * @param popupID
	 * @param _req
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/VmiPumokPopup.do")
	public String vmiPumok(String popupID, ExtHtttprequestParam _req, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();

		return JSP_PATH + "VmiPumokPopupWin";
	}
	
	/**
	 * 모델 팝업 (멕아이씨에스)	20210821
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */

	@RequestMapping(value = "/app/Unilite/app/popup/ModelPopup.do")
	public String modelPopup() throws Exception {
		return JSP_PATH + "ModelPopupWin_MICS";
	}
	
	/**
	 * 202109 jhj: 원산지 팝업 (양평농협 전용)
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */

	@RequestMapping(value = "/app/Unilite/app/popup/wonsangiPopup.do")
	public String wonsangiPopup() throws Exception {
		return JSP_PATH + "WonsangiPopupWin_YP";
	}
}