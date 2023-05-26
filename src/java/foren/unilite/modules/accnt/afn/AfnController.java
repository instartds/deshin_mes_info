package foren.unilite.modules.accnt.afn;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
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
import foren.unilite.modules.accnt.AccntCommonServiceImpl;

/**
 *    프로그램명 : 자금관리
 *    작  성  자 : (주)포렌 개발실
 */
@Controller
public class AfnController extends UniliteCommonController {
	
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	final static String JSP_PATH = "/accnt/afn/";
	
	/**
	 * 어음명세
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/accnt/afn100skr.do")
	public String afn100skr(	)throws Exception{
		return JSP_PATH+"afn100skr";
	}
	
	@RequestMapping(value="/accnt/afn100rkr.do")
	public String afn100rkr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE",loginVO.getCompCode());
		
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		List<CodeDetailVO> gsReportGubun = codeInfo.getCodeList("A126", "", false);		//모듈별 출력 설정에서 ClipReport추가로 인한 리포트 프로그램 설정값 가져오기(크리스탈,jasper 또는 ClipReport)
		for(CodeDetailVO map : gsReportGubun) {
			if("afn100rkr".equals(map.getCodeName())) {
				model.addAttribute("gsReportGubun", map.getRefCode10());
			}
		}
		return JSP_PATH + "afn100rkr";
	}
	
	/**
	 * 어음명세수정
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/accnt/afn100ukr.do")
	public String afn100ukr(	)throws Exception{
		return JSP_PATH+"afn100ukr";
	}
	
	/**
	 * 지급어음수표등록
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/accnt/afn200ukr.do",method = RequestMethod.GET)
	public String afn200ukr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE",loginVO.getCompCode());
	
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		return JSP_PATH + "afn200ukr";
	}
	
	/**
     * 지급어음수표등록( 극동용으로 변경 )
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/accnt/afn201ukr.do",method = RequestMethod.GET)
    public String afn201ukr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
        
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        
        param.put("S_COMP_CODE",loginVO.getCompCode());
    
        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;

        return JSP_PATH + "afn201ukr";
    }
	
	/**
	 * 지급어음수표일괄등록
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/accnt/afn210ukr.do",method = RequestMethod.GET)
	public String afn210ukr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE",loginVO.getCompCode());
				
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;
		
		return JSP_PATH + "afn210ukr";
	}

    /**
     * 차입금/예적금 스케줄표생성
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/accnt/afn310ukr.do")
    public String afn310ukr(    )throws Exception{
        return JSP_PATH+"afn310ukr";
    }    

    /**
     * 차입금이자스케줄표
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/accnt/afn310skr.do")
    public String afn310skr(    )throws Exception{
        return JSP_PATH+"afn310skr";
    }    

    /**
     * 예적금이자스케줄표
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/accnt/afn410skr.do")
    public String afn410skr(    )throws Exception{
        return JSP_PATH+"afn410skr";
    }    
}
