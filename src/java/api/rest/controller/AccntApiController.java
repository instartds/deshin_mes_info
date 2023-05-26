package api.rest.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONArray;
import net.sf.json.JSONException;
import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import api.rest.service.CommonServiceImpl;
import api.rest.service.If_agd360ukrServiceImpl;
import api.rest.service.If_agd365ukrServiceImpl;
import api.rest.utils.RestUtils;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.utils.ConfigUtil;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.com.constants.Unilite;

/**
 * <pre>
 * 회계 전표처리를 위한 Web Service를 위한 API Controller
 * </pre>
 *
 * @author 박종영
 */
@Controller
public class AccntApiController extends UniliteCommonController {

    private final Logger            logger = LoggerFactory.getLogger(this.getClass());

    RestUtils                       utils  = new RestUtils();

    /**
     * Log 테이블 관리
     */
    @Resource( name = "commonServiceImpl" )
    private CommonServiceImpl       commonServiceImpl;

    /**
     * 전표자동기표 Service
     */
    @Resource( name = "if_agd360ukrServiceImpl" )
    private If_agd360ukrServiceImpl if_agd360ukrServiceImpl;

    /**
     * 전표자동기표취소 Service
     */
    @Resource( name = "if_agd365ukrServiceImpl" )
    private If_agd365ukrServiceImpl if_agd365ukrServiceImpl;

    /**
     * <pre>
     * 전표 자동기표
     * 오류의 확인은 IF_ERROR_MSG, AGD361T 두개 테이블을 확인해야 함.
     * IF_C0006
     *
     * status  : "0" 성공, "1" 실패
     * message : 오류메시지
     * if_num  : 전표처리 결과
     *
     * status 가 "0" 이더라도 전표처리 결과에 따라 "AC_DATE", "SLIP_NUM"를 반환하지 않을 수 있음.
     * </pre>
     *
     * @param _req
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/api/saveInf001", method = RequestMethod.POST )
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public ModelAndView saveInf001( ExtHtttprequestParam _req, HttpServletRequest request ) throws Exception {

        logger.debug("logger 시작 ----------------------------");
        logger.debug("contextName :: " + Unilite.getCurrentContextName(request.getContextPath()));
        logger.debug("접속자 IP :: " + request.getRemoteAddr());
        logger.debug("----------------------------");

        boolean webServiceYn = ConfigUtil.getBooleanValue("common.dataOption.web-service", false);
        logger.debug("webServiceYn :: {}", webServiceYn);

        if (webServiceYn) {

            Map rtnMsg = new HashMap();
            Map logMap = new HashMap();
            boolean errYn = false;

            /*
             * Job ID 생성
             */
            String jobId = utils.makeJobID();

            /*
             * Logging 시작
             */
            logMap.put("BATCH_SEQ", jobId);
            logMap.put("BATCH_ID", "IF_C0006");
            logMap.put("CLIENT_IP", request.getRemoteAddr());
            commonServiceImpl.insertLog(logMap);

            List<Map<String, Object>> dataList = (List<Map<String, Object>>)_req.getObject("data");
            logger.debug("dataList : {}", dataList);

            if (dataList == null || dataList.size() == 0) {
                /*
                 * Logging 끝
                 */
                logMap.put("STATUS", "1");
                logMap.put("RESULT_MSG", "전송된 마스터 데이터가 없습니다.");
                commonServiceImpl.updateLog(logMap);

                return ViewHelper.getJsonView(utils.convErrorMessage("Error", "전송된 마스터 데이터가 없습니다."));
            }

            try {

                /*
                 * Temp 테이블에 데이터를 Insert 한다.
                 */
                Map param = if_agd360ukrServiceImpl.saveIfAgd360T(jobId, dataList);

                /*
                 * Temp 테이블에서 전표 자동기표 으로 데이터를 저장 한다.
                 */
                if_agd360ukrServiceImpl.saveTempToAgd360T(jobId);

                /*
                 * 전표 처리 한다.
                 */
                Map map = if_agd360ukrServiceImpl.apiSaveAll(jobId, param);
                logger.info("jobId {}의 결과 :: {}", jobId, map);
                rtnMsg.put("if_num", map.get("RESULT"));      //

                Map rtnMap = if_agd360ukrServiceImpl.selectErrorList(map);
                String rtnValue = (String)rtnMap.get("ERR_KEY_SEQNO");
                if (rtnValue.startsWith("0/")) {

                    List<Map> rtnList = (List)map.get("RESULT");
                    String errMsg = "";
                    for (Map rMap : rtnList) {
                        if (( (String)rMap.get("ERROR_DESC") ).length() > 0) {
                            errYn = true;
                            errMsg = errMsg + (String)rMap.get("ERROR_DESC") + "\n";
                        }
                    }

                    if (errYn) {
                        rtnMsg.put("status", "1");        //
                        rtnMsg.put("message", errMsg);        //

                        /*
                         * Logging 끝
                         */
                        logMap.put("STATUS", "1");
                        logMap.put("RESULT_MSG", errMsg);
                    } else {
                        rtnMsg.put("status", "0");        //
                        rtnMsg.put("message", "");        //

                        /*
                         * Logging 끝
                         */
                        logMap.put("STATUS", "0");
                        logMap.put("RESULT_MSG", "SUCC");
                    }

                } else {
                    rtnMsg.put("status", "1");        //
                    rtnMsg.put("message", rtnValue);  //

                    /*
                     * Logging 끝
                     */
                    logMap.put("STATUS", "1");
                    logMap.put("RESULT_MSG", rtnValue);
                }

                commonServiceImpl.updateLog(logMap);

            } catch (Exception e) {
                e.printStackTrace();
                rtnMsg = utils.convErrorMessage("Error", e.getMessage());

                /*
                 * Logging 끝
                 */
                logMap.put("STATUS", "1");
                logMap.put("RESULT_MSG", e.getMessage());
                commonServiceImpl.updateLog(logMap);
            }

            logger.debug("rtnMsg :: {}", rtnMsg);

            return ViewHelper.getJsonView(rtnMsg);
        } else {
            return ViewHelper.getJsonView(null);
        }
    }

    /**
     * <pre>
     * 전표 자동기표 ( 파워빌더용 )
     * 오류의 확인은 IF_ERROR_MSG, AGD361T 두개 테이블을 확인해야 함.
     * IF_C0006
     * </pre>
     *
     * @param _req
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/api/saveInfPB001", method = RequestMethod.POST )
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public ModelAndView saveInfPB001( HttpServletRequest request ) throws Exception {

        logger.debug("logger 시작 ----------------------------");
        logger.debug("contextName :: " + Unilite.getCurrentContextName(request.getContextPath()));
        logger.debug("data : " + request.getParameter("data"));
        logger.debug("접속자 IP :: " + request.getRemoteAddr());
        logger.debug("----------------------------");

        boolean webServiceYn = ConfigUtil.getBooleanValue("common.dataOption.web-service", false);
        logger.debug("webServiceYn :: {}", webServiceYn);

        if (webServiceYn) {
            Map rtnMsg = new HashMap();
            Map logMap = new HashMap();

            /*
             * Job ID 생성
             */
            String jobId = utils.makeJobID();

            /*
             * Logging 시작
             */
            logMap.put("BATCH_SEQ", jobId);
            logMap.put("BATCH_ID", "IF_C0006");
            logMap.put("CLIENT_IP", request.getRemoteAddr());
            commonServiceImpl.insertLog(logMap);

            if (request.getParameter("data") == null || request.getParameter("data").length() == 0) {
                /*
                 * Logging 끝
                 */
                logMap.put("STATUS", "1");
                logMap.put("RESULT_MSG", "전송된 데이터가 없습니다.");
                commonServiceImpl.updateLog(logMap);

                rtnMsg.put("message", "1/전송된 데이터가 없습니다.");
                return ViewHelper.getJsonView(rtnMsg);
            }

            String data = null;
            String platstr = System.getProperty("os.name");
            JSONObject jsonObj = null;

            if (platstr.indexOf("Windows") != -1) {

                data = new String(request.getParameter("data").getBytes("iso-8859-1"), "euc-kr");

            } else {
                //data = request.getParameter("data");
                data = new String(request.getParameter("data").getBytes("iso-8859-1"), "utf-8");

            }

            try {
                jsonObj = JSONObject.fromObject(JSONSerializer.toJSON(data));
            } catch (JSONException jsonexception) {

                /*
                 * Logging 끝
                 */
                logMap.put("STATUS", "1");
                logMap.put("RESULT_MSG", "JSON 문자열 오류.");
                commonServiceImpl.updateLog(logMap);

                rtnMsg = new HashMap();
                rtnMsg.put("message", "1/JSON 문자열 오류.");
                return ViewHelper.getJsonView(rtnMsg);
            }

            List dataList = utils.jsonToList((JSONArray)jsonObj.get("data"));

            try {
                Map map = if_agd360ukrServiceImpl.apiSaveAllPB(dataList);
                Map rtnMap = if_agd360ukrServiceImpl.selectErrorListPB(map);
                String rtnValue = (String)rtnMap.get("ERR_KEY_SEQNO");
                if (rtnValue.startsWith("0/")) {
                    List rtnList = (List)map.get("RESULT");

                    String idxNum = "";
                    int errCnt = 0;
                    if (rtnList.size() > 0) {
                        for (int i = 0; i < rtnList.size(); i++) {
                            Map o_map = (Map)rtnList.get(i);
                            if (( (String)o_map.get("ERROR_DESC") ).length() > 0) {
                                idxNum += (String)o_map.get("AC_DATE") + (String)o_map.get("SLIP_NUM") + ",";
                                errCnt++;
                            } else {
                                idxNum += (String)o_map.get("AC_DATE") + (String)o_map.get("SLIP_NUM") + ",";
                            }
                        }
                    }
                    if (errCnt > 0) {
                        rtnMsg.put("message", errCnt + "/" + idxNum.substring(0, idxNum.length() - 1));      // Power Builder는 status 를 보내지 않음.

                        /*
                         * Logging 끝
                         */
                        logMap.put("STATUS", "1");
                        logMap.put("RESULT_MSG", errCnt + "/" + idxNum.substring(0, idxNum.length() - 1));
                    } else {
                        rtnMsg.put("message", "0/" + idxNum.substring(0, idxNum.length() - 1));              // Power Builder는 status 를 보내지 않음.

                        /*
                         * Logging 끝
                         */
                        logMap.put("STATUS", "0");
                        logMap.put("RESULT_MSG", "");
                    }

                } else {
                    rtnMsg.put("message", rtnValue);      // Power Builder는 status 를 보내지 않음.

                    /*
                     * Logging 끝
                     */
                    logMap.put("STATUS", "1");
                    logMap.put("RESULT_MSG", rtnValue);
                }

                commonServiceImpl.updateLog(logMap);

            } catch (Exception e) {
                e.printStackTrace();
                rtnMsg.put("message", "1/" + e.getMessage());

                /*
                 * Logging 끝
                 */
                logMap.put("STATUS", "1");
                logMap.put("RESULT_MSG", e.getMessage());
                commonServiceImpl.updateLog(logMap);
            }

            logger.debug("rtnMsg :: {}", rtnMsg);

            return ViewHelper.getJsonView(rtnMsg);
        } else {
            return ViewHelper.getJsonView(null);
        }
    }

    /**
     * <pre>
     * 전표 자동기표취소
     * IF_C0007
     *
     * status  : "0" 성공, "1" 실패
     * message : 오류메시지
     *
     * </pre>
     *
     * @param _req
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/api/saveInf002", method = RequestMethod.POST )
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public ModelAndView saveInf002( ExtHtttprequestParam _req, HttpServletRequest request ) throws Exception {

        logger.debug("logger 시작 ----------------------------");
        logger.debug("contextName :: " + Unilite.getCurrentContextName(request.getContextPath()));
        logger.debug("접속자 IP :: " + request.getRemoteAddr());
        logger.debug("----------------------------");

        boolean webServiceYn = ConfigUtil.getBooleanValue("common.dataOption.web-service", false);
        logger.debug("webServiceYn :: {}", webServiceYn);

        if (webServiceYn) {
            Map rtnMsg = new HashMap();
            Map logMap = new HashMap();

            /*
             * Job ID 생성
             */
            String jobId = utils.makeJobID();

            /*
             * Logging 시작
             */
            logMap.put("BATCH_SEQ", jobId);
            logMap.put("BATCH_ID", "IF_C0007");
            logMap.put("CLIENT_IP", request.getRemoteAddr());
            commonServiceImpl.insertLog(logMap);

            List<Map<String, Object>> dataList = (List<Map<String, Object>>)_req.getObject("data");
            logger.debug("dataList : {}", dataList);

            if (dataList == null || dataList.size() == 0) {
                /*
                 * Logging 끝
                 */
                logMap.put("STATUS", "1");
                logMap.put("RESULT_MSG", "전송된 마스터 데이터가 없습니다.");
                commonServiceImpl.updateLog(logMap);

                return ViewHelper.getJsonView(utils.convErrorMessage("Error", "전송된 마스터 데이터가 없습니다."));
            }

            boolean errYn = false;
            try {
                /*
                 * Temp 폴더에 데이터를 Insert 한다.
                 */
                Map param = if_agd365ukrServiceImpl.saveIfAgd365T(jobId, dataList);

                /*
                 * Temp 테이블에서 전표 자동기표취소 으로 데이터를 저장 한다.
                 */
                if_agd365ukrServiceImpl.saveTempToAgd365T(jobId);

                Map map = if_agd365ukrServiceImpl.apiSaveAll(jobId, param);
                rtnMsg.put("if_num", map.get("RESULT"));      //

                Map rtnMap = if_agd365ukrServiceImpl.selectErrorList(map);
                String rtnValue = (String)rtnMap.get("ERR_KEY_SEQNO");
                if (rtnValue.startsWith("0/")) {
                    List<Map> rtnList = (List)map.get("RESULT");
                    String errMsg = "";
                    for (Map rMap : rtnList) {
                        if (( (String)rMap.get("ERROR_DESC") ).length() > 0) {
                            errYn = true;
                            errMsg = errMsg + (String)rMap.get("ERROR_DESC");
                        }
                    }

                    if (errYn) {
                        rtnMsg.put("status", "1");        //
                        rtnMsg.put("message", errMsg);        //

                        /*
                         * Logging 끝
                         */
                        logMap.put("STATUS", "1");
                        logMap.put("RESULT_MSG", errMsg);
                    } else {
                        rtnMsg.put("status", "0");        //
                        rtnMsg.put("message", "");        //

                        /*
                         * Logging 끝
                         */
                        logMap.put("STATUS", "0");
                        logMap.put("RESULT_MSG", "");
                    }

                } else {
                    rtnMsg.put("status", "1");        //
                    rtnMsg.put("message", rtnValue);  //

                    /*
                     * Logging 끝
                     */
                    logMap.put("STATUS", "1");
                    logMap.put("RESULT_MSG", rtnValue);
                }

                commonServiceImpl.updateLog(logMap);

            } catch (Exception e) {
                e.printStackTrace();
                rtnMsg = utils.convErrorMessage("Error", e.getMessage());

                /*
                 * Logging 끝
                 */
                logMap.put("STATUS", "1");
                logMap.put("RESULT_MSG", e.getMessage());
                commonServiceImpl.updateLog(logMap);
            }

            logger.debug("rtnMsg :: {}", rtnMsg);

            return ViewHelper.getJsonView(rtnMsg);
        } else {
            return ViewHelper.getJsonView(null);
        }
    }

    /**
     * <pre>
     * 전표 자동기표취소 ( 파워빌더용 )
     * IF_C0007
     * </pre>
     *
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/api/saveInfPB002", method = RequestMethod.POST )
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public ModelAndView saveInfPB002( HttpServletRequest request ) throws Exception {

        logger.debug("logger 시작 ----------------------------");
        logger.debug("contextName :: " + Unilite.getCurrentContextName(request.getContextPath()));
        logger.debug("data : " + request.getParameter("data"));
        logger.debug("접속자 IP :: " + request.getRemoteAddr());
        logger.debug("----------------------------");

        boolean webServiceYn = ConfigUtil.getBooleanValue("common.dataOption.web-service", false);
        logger.debug("webServiceYn :: {}", webServiceYn);

        if (webServiceYn) {
            Map rtnMsg = new HashMap();
            Map logMap = new HashMap();
            /*
             * Job ID 생성
             */
            String jobId = utils.makeJobID();

            /*
             * Logging 시작
             */
            logMap.put("BATCH_SEQ", jobId);
            logMap.put("BATCH_ID", "IF_C0007");
            logMap.put("CLIENT_IP", request.getRemoteAddr());
            commonServiceImpl.insertLog(logMap);

            if (request.getParameter("data") == null || request.getParameter("data").length() == 0) {
                /*
                 * Logging 끝
                 */
                logMap.put("STATUS", "1");
                logMap.put("RESULT_MSG", "전송된 데이터가 없습니다.");
                commonServiceImpl.updateLog(logMap);

                return ViewHelper.getJsonView(utils.convErrorMessage("Error", "전송된 데이터가 없습니다."));
            }

            String data = null;
            String platstr = System.getProperty("os.name");
            JSONObject jsonObj = null;

            if (platstr.indexOf("Windows") != -1) {

                data = new String(request.getParameter("data").getBytes("iso-8859-1"), "euc-kr");

            } else {

                data = new String(request.getParameter("data").getBytes("iso-8859-1"), "utf-8");

            }

            try {
                jsonObj = JSONObject.fromObject(JSONSerializer.toJSON(data));
            } catch (JSONException jsonexception) {
                /*
                 * Logging 끝
                 */
                logMap.put("STATUS", "1");
                logMap.put("RESULT_MSG", "JSON 문자열 오류.");
                commonServiceImpl.updateLog(logMap);

                rtnMsg.put("message", "JSON 문자열 오류.");
                return ViewHelper.getJsonView(rtnMsg);
            }

            List dataList = utils.jsonToList((JSONArray)jsonObj.get("data"));

            try {

                Map map = if_agd365ukrServiceImpl.apiSaveAllPB(dataList);
                Map rtnMap = if_agd365ukrServiceImpl.selectErrorListPB(map);
                String rtnValue = (String)rtnMap.get("ERR_KEY_SEQNO");
                if (rtnValue.startsWith("0/")) {
                    List rtnList = (List)map.get("RESULT");

                    String idxNum = "";
                    int errCnt = 0;
                    if (rtnList.size() > 0) {
                        for (int i = 0; i < rtnList.size(); i++) {
                            Map o_map = (Map)rtnList.get(i);
                            if (( (String)o_map.get("ERROR_DESC") ).length() > 0) {
                                idxNum += (String)o_map.get("AC_DATE") + (String)o_map.get("SLIP_NUM") + ",";
                                errCnt++;
                            }
                        }
                    }
                    if (idxNum.length() > 0) {
                        rtnMsg.put("message", errCnt + "/" + idxNum.substring(0, idxNum.length() - 1));      // Power Builder는 status 를 보내지 않음.

                        /*
                         * Logging 끝
                         */
                        logMap.put("STATUS", "1");
                        logMap.put("RESULT_MSG", errCnt + "/" + idxNum.substring(0, idxNum.length() - 1));
                    } else {
                        rtnMsg.put("message", "0/");      // Power Builder는 status 를 보내지 않음.

                        /*
                         * Logging 끝
                         */
                        logMap.put("STATUS", "0");
                        logMap.put("RESULT_MSG", "");
                    }

                } else {
                    /*
                     * Logging 끝
                     */
                    logMap.put("STATUS", "1");
                    logMap.put("RESULT_MSG", rtnValue);

                    rtnMsg.put("message", rtnValue);      // Power Builder는 status 를 보내지 않음.
                }

                commonServiceImpl.updateLog(logMap);
            } catch (Exception e) {
                e.printStackTrace();
                rtnMsg = utils.convErrorMessage("Error", e.getMessage());

                /*
                 * Logging 끝
                 */
                logMap.put("STATUS", "1");
                logMap.put("RESULT_MSG", e.getMessage());
                commonServiceImpl.updateLog(logMap);
            }

            logger.debug("rtnMsg :: {}", rtnMsg);

            return ViewHelper.getJsonView(rtnMsg);
        } else {
            return ViewHelper.getJsonView(null);
        }
    }

    /**
     * <pre>
     * Interface 유형 01 조회
     * IF_C0006
     * </pre>
     *
     * @param _req
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/api/getInf001", method = RequestMethod.POST )
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public ModelAndView getInf001( ExtHtttprequestParam _req, HttpServletRequest request ) throws Exception {
        logger.debug("logger 시작 ----------------------------");
        logger.debug("contextName :: " + Unilite.getCurrentContextName(request.getContextPath()));
        logger.debug("접속자 IP :: " + request.getRemoteAddr());
        logger.debug("----------------------------");

        /*List<Map<String, Object>> dataList = (List<Map<String, Object>>)_req.getObject("data");
        logger.debug("dataList : {}", dataList);

        if (dataList == null || dataList.size() == 0) {
            return ViewHelper.getJsonView(utils.convErrorMessage("Error", "전송된 마스터 데이터가 없습니다."));
        }

        Map logMap = new HashMap();

         * Job ID 생성

        String jobId = utils.makeJobID();


         * Logging 시작

        logMap.put("BATCH_SEQ", jobId);
        logMap.put("BATCH_ID", "IF_C0006");
        logMap.put("CLIENT_IP", request.getRemoteAddr());
        commonServiceImpl.insertLog(logMap);
        */
        //List list = bom100ukrService.selectList(dataList);
        Map map = new HashMap();
        map.put("status", "0");
        map.put("message", "정상처리되었습니다.");

        /*
         * Logging 끝
         */
     /*   logMap.put("STATUS", "0");
        logMap.put("RESULT_MSG", "");
        commonServiceImpl.updateLog(logMap);*/

        return ViewHelper.getJsonView(map);
    }

}
