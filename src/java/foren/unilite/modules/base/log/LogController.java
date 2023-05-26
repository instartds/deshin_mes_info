package foren.unilite.modules.base.log;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;

import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import api.rest.scheduler.AccntBatchTask;
import api.rest.scheduler.SecuBatchTask;
import api.rest.utils.HttpClientUtils;
import foren.framework.lib.listop.ListOp;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.modules.base.BaseCommonServiceImpl;

@Controller
public class LogController extends UniliteCommonController {

    private final Logger          logger   = LoggerFactory.getLogger(this.getClass());

    final static String           JSP_PATH = "/base/log/";
/*
    @Autowired
    @Qualifier( "accntTask" )
    private AccntBatchTask         accntTask;

    @Autowired
    @Qualifier( "secuTask" )
    private SecuBatchTask          secuTask;
*/
    /**
     * 기준정보 공통
     */
    @Resource( name = "baseCommonService" )
    private BaseCommonServiceImpl baseCommonService;

    /**
     * 기준정보 공통
     */
    @Resource( name = "log901ukrService" )
    private Log901ukrServiceImpl  log901ukrService;

    /**
     * 배치 및 인터페이스 LOG조회
     *
     * @param _req
     * @param loginVO
     * @param listOp
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/base/log900skr.do" )
    public String log900skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        return JSP_PATH + "log900skr";
    }

    /**
     * 배치 및 인터페이스 LOG
     *
     * @param _req
     * @param loginVO
     * @param listOp
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/base/log901ukr.do" )
    public String log901ukr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        // 회사코드 Combo
        Map<String, Object> param = new HashMap<String, Object>();
        model.addAttribute("COMBO_CODE01", baseCommonService.getCodeWithCondition(param));

        return JSP_PATH + "log901ukr";
    }

    /**
     * 배치 및 인터페이스 LOG
     *
     * @param _req
     * @param loginVO
     * @param listOp
     * @param model
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @RequestMapping( value = "/base/runBatch.do" )
    public ModelAndView runBatch( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        logger.info("BATCH_CODE :: {}", _req.getP("BATCH_CODE"));
        Map<String, Object> rMap = new HashMap<String, Object>();

        try {
/*
            // 그룹웨어 사용자정보 인터페이스
            if (_req.getP("BATCH_CODE").equals("IF_0001")) {
                accntTask.batchRun03();
            }
            // 전자결재상태확인
            else if (_req.getP("BATCH_CODE").equals("IF_0002")) {
                accntTask.batchRun04();
            }
            // 입출금거래내역암호화
            else if (_req.getP("BATCH_CODE").equals("IF_0003")) {
                secuTask.batchRun01();
            }
            // 경비관리-개인정보암호화
            else if (_req.getP("BATCH_CODE").equals("IF_0004")) {
                secuTask.batchRun02();
            }
            // 경비관리-계좌번호암호화
            else if (_req.getP("BATCH_CODE").equals("IF_0005")) {
                secuTask.batchRun03();
            }
            // 법인카드-카드번호암호화
            else if (_req.getP("BATCH_CODE").equals("IF_0006")) {
                secuTask.batchRun04();
            }
            // 카드사용내역-카드번호암호화
            else if (_req.getP("BATCH_CODE").equals("IF_0007")) {
                secuTask.batchRun04();
            }
            // 카드한도-카드번호암호화
            else if (_req.getP("BATCH_CODE").equals("IF_0008")) {
                secuTask.batchRun04();
            }
            // MIS사용자정보취합
            else if (_req.getP("BATCH_CODE").equals("IF_0009")) {
                accntTask.batchRun05();
            }
            // 스마트빌 매입 전자세금계산서
            else if (_req.getP("BATCH_CODE").equals("IF_0010")) {
                secuTask.batchRun07();
            }
            // 가수금정보 인터페이스
            else if (_req.getP("BATCH_CODE").equals("IF_0011")) {
                accntTask.batchRun06();
            }
*/
            // 발행 데이터 결과 PUSH
//            else
            if (_req.getP("BATCH_CODE").equals("IF_0012")) {
                HttpClientUtils httpclient = new HttpClientUtils();
                Map iMap = (Map)baseCommonService.getEtaxRunUrl();
                logger.info("iMap :: {}", iMap);
                String runUrl = (String)iMap.get("CODE_NAME");
                if(runUrl != null) {
                    String responseString = httpclient.post(runUrl, runUrl, "{GUBUN:\"1\"}", "application/json", "UTF-8", 1000, 1000);
                    logger.debug("responseString :: {}", responseString);
                    JSONObject jsonObj = JSONObject.fromObject(JSONSerializer.toJSON(responseString));
                    if (!( (String)jsonObj.get("status") ).equals("0")) {
                        throw new Exception((String)jsonObj.get("message"));
                    }
                }
            }
            // 거래명세서 결과 PUSH
            else if (_req.getP("BATCH_CODE").equals("IF_0013")) {
                HttpClientUtils httpclient = new HttpClientUtils();
                Map iMap = (Map)baseCommonService.getEtaxRunUrl();
                logger.info("iMap :: {}", iMap);
                String runUrl = (String)iMap.get("CODE_NAME");
                if(runUrl != null) {
                    String responseString = httpclient.post(runUrl, runUrl, "{GUBUN:\"2\"}", "application/json", "UTF-8", 1000, 1000);
                    logger.debug("responseString :: {}", responseString);
                    JSONObject jsonObj = JSONObject.fromObject(JSONSerializer.toJSON(responseString));
                    if (!( (String)jsonObj.get("status") ).equals("0")) {
                        throw new Exception((String)jsonObj.get("message"));
                    }
                }
            }
            // 발송결과 PUSH
            else if (_req.getP("BATCH_CODE").equals("IF_0014")) {
                HttpClientUtils httpclient = new HttpClientUtils();
                Map iMap = (Map)baseCommonService.getEtaxRunUrl();
                logger.info("iMap :: {}", iMap);
                String runUrl = (String)iMap.get("CODE_NAME");
                if(runUrl != null) {
                    String responseString = httpclient.post(runUrl, runUrl, "{GUBUN:\"3\"}", "application/json", "UTF-8", 1000, 1000);
                    logger.debug("responseString :: {}", responseString);
                    JSONObject jsonObj = JSONObject.fromObject(JSONSerializer.toJSON(responseString));
                    if (!( (String)jsonObj.get("status") ).equals("0")) {
                        throw new Exception((String)jsonObj.get("message"));
                    }
                }
            }

            rMap.put("success", "0");
            rMap.put("returnMsg", "정상처리되었습니다.");
        } catch (Exception e) {
            rMap.put("success", "1");
            rMap.put("returnMsg", e.getMessage());
        }

        logger.info("rtnVal :: {}", rMap);

        return ViewHelper.getJsonView(rMap);
    }

	@RequestMapping(value = "/base/log100skrv.do", method = RequestMethod.GET)
	public String log100skrv() throws Exception {
		return JSP_PATH + "log100skrv";
	}
}
