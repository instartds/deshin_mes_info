package foren.unilite.modules.z_kd;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.BindingResult;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.service.impl.TlabMenuService;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.accnt.afb.Afb600ukrModel;
import foren.unilite.modules.base.bor.Bor100ukrvModel;
import foren.unilite.modules.com.fileman.FileMnagerService;


@Service("s_zcc800ukrv_kdService")
public class S_zcc800ukrv_kdServiceImpl extends TlabAbstractServiceImpl {
        private final Logger    logger  = LoggerFactory.getLogger(this.getClass());

        Map isirNum = new HashMap();
        @Resource(name = "fileMnagerService")
        private FileMnagerService fileMnagerService;

        /**
         *
         * 사원의 해당부서 조회
         * @param param
         * @return
         * @throws Exception
         */
        @ExtDirectMethod(group = "z_kd", value = ExtDirectMethodType.STORE_READ)
        public List<Map<String, Object>> selectPersonDept(Map param) throws Exception {
            return super.commonDao.list("s_zcc800ukrv_kdService.selectPersonDept", param);
        }



        /**
         * 조회팝업 조회
         *
         * @param param
         * @return
         * @throws Exception
         */
        @ExtDirectMethod(group = "z_kd", value = ExtDirectMethodType.STORE_READ)
        public List<Map<String, Object>> selectSearchInfo(Map param) throws Exception {
            return super.commonDao.list("s_zcc800ukrv_kdService.selectSearchInfo", param);
        }

        /**
         *  메인그리드 조회
         *
         * @param param
         * @return
         * @throws Exception
         */
        @ExtDirectMethod(group = "z_kd", value = ExtDirectMethodType.STORE_READ)
        public List<Map<String, Object>> selectDetail(Map param) throws Exception {
            return super.commonDao.list("s_zcc800ukrv_kdService.selectDetail", param);
        }

    	/**마스터만 저장시**/
    	@ExtDirectMethod(value = ExtDirectMethodType.FORM_POST, group = "z_kd")
    	public ExtDirectFormPostResult syncMaster(S_zcc800ukrv_kdModel param, LoginVO user, BindingResult result) throws Exception {

    		param.setS_COMP_CODE(user.getCompCode());
    		param.setS_USER_ID(user.getUserID());
    		super.commonDao.update("s_zcc800ukrv_kdService.updateMaster", param);

    		ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);

    		return extResult;
    	}
    	@Transactional(readOnly=true)
    	@ExtDirectMethod(group = "z_kd", value = ExtDirectMethodType.STORE_READ)
    	public Object  fnOrderPrice(Map param) throws Exception {
    		return  super.commonDao.select("s_zcc800ukrv_kdService.fnOrderPrice", param);
    	}

        /**
         * 저장
         * @param param
         * @return
         * @throws Exception
         */
        @ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "z_kd")
        @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
        public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {

            Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
            dataMaster.put("COMP_CODE", user.getCompCode());

            String reqNum = (String) dataMaster.get("REQ_NUM");

            if (ObjUtils.isEmpty(dataMaster.get("REQ_NUM") )) {
                Map<String, Object> spParam = new HashMap<String, Object>();
                SimpleDateFormat dateFormat = new SimpleDateFormat ("yyyyMMdd");
                Date dateGet = new Date ();
                String dateGetString = dateFormat.format(dateGet);
                spParam.put("COMP_CODE", user.getCompCode());
                spParam.put("DIV_CODE", dataMaster.get("DIV_CODE"));
                spParam.put("TABLE_ID","s_zcc800ukrv_kd");
                spParam.put("PREFIX", "A");
                spParam.put("BASIS_DATE", dateGetString);
                spParam.put("AUTO_TYPE", "1");

                super.commonDao.queryForObject("s_zcc800ukrv_kdService.spAutoNum", spParam);
//                List<Map>paramDetail = (List<Map>) paramList.get(0).get("data");
//                String gwFlag = (String) paramDetail.get(0).get("GW_FLAG");
//                dataMaster.put("GW_FLAG",   gwFlag);
                dataMaster.put("REQ_NUM", ObjUtils.getSafeString(spParam.get("KEY_NUMBER")));
                reqNum = ObjUtils.getSafeString(spParam.get("KEY_NUMBER"));
                super.commonDao.insert("s_zcc800ukrv_kdService.insertMaster", dataMaster);

            } else {
            			
        		super.commonDao.update("s_zcc800ukrv_kdService.updateMaster", dataMaster);
            }

            if(paramList != null)  {
                   List<Map> insertList = null;
                   List<Map> updateList = null;
                   List<Map> deleteList = null;
                   for(Map dataListMap: paramList) {
                       if(dataListMap.get("method").equals("deleteDetail")) {
                           deleteList = (List<Map>)dataListMap.get("data");
                       } else if(dataListMap.get("method").equals("updateDetail")) {
                           updateList = (List<Map>)dataListMap.get("data");
                       } else if(dataListMap.get("method").equals("insertDetail")) {
                           insertList = (List<Map>)dataListMap.get("data");
                       }
                   }
                   if(deleteList != null) this.deleteDetail(deleteList, user, dataMaster);
                   if(updateList != null) this.updateDetail(updateList, user, dataMaster);
                   if(insertList != null) this.insertDetail(insertList, user, reqNum);
               }

               dataMaster.put("REQ_NUM", reqNum);


               paramList.add(0, paramMaster);

               return  paramList;
       }

        @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_kd")                                             // INSERT
        public void insertDetail(List<Map> paramList, LoginVO user, String reqNum) throws Exception {
            for(Map param :paramList ) {
            	if(ObjUtils.isNotEmpty(reqNum)){
            		param.put("REQ_NUM", reqNum);
            	}
                super.commonDao.update("s_zcc800ukrv_kdService.insertList", param);
            }
            return ;
        }

        @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_kd")                                             // UPDATE
        public void updateDetail(List<Map> paramList, LoginVO user, Map<String, Object> dataMaster) throws Exception {
            Map compCodeMap = new HashMap();
            for(Map param :paramList ) {
                super.commonDao.update("s_zcc800ukrv_kdService.updateList", param);
            }

            if(dataMaster.get("masterSaveFlag").equals("U")){
            	super.commonDao.insert("s_zcc800ukrv_kdService.updateMaster", dataMaster);

            }

            return ;
        }

        @ExtDirectMethod(group = "z_kd", value = ExtDirectMethodType.STORE_MODIFY)                                                   // DELETE
        public void deleteDetail(List<Map> paramList,  LoginVO user, Map<String, Object> dataMaster) throws Exception {
            Map compCodeMap = new HashMap();
            for(Map param :paramList ) {
               super.commonDao.update("s_zcc800ukrv_kdService.deleteList", param);
            }

            if(dataMaster.get("masterSaveFlag").equals("D")){
            	super.commonDao.insert("s_zcc800ukrv_kdService.deleteMaster", dataMaster);

            }

            return ;
        }

        /**
        *
        * 마스터 기안상태 조회
        * @param param
        * @return
        * @throws Exception
        */
       @ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
       public List<Map<String, Object>> selectGwData(Map param) throws Exception {
           return super.commonDao.list("s_zcc800ukrv_kdService.selectGwData", param);
       }

       /**
        *  기안버튼 눌렀을때 번호생성(UPDATE)
        *
        * @param param
        * @return
        * @throws Exception
        */
       @ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)  /* 기안버튼 눌렀을때 번호생성(UPDATE) */
       public List<Map<String, Object>> makeDraftNum(Map param) throws Exception {
           return super.commonDao.list("s_zcc800ukrv_kdService.makeDraftNum", param);
       }
}
