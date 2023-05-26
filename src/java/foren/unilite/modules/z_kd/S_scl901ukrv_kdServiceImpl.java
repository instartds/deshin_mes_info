package foren.unilite.modules.z_kd;

import java.text.SimpleDateFormat;
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
import foren.unilite.modules.z_kd.S_scl901ukrv_kdModel;


@Service("s_scl901ukrv_kdService")
public class S_scl901ukrv_kdServiceImpl extends TlabAbstractServiceImpl {
	private final Logger	logger	= LoggerFactory.getLogger(this.getClass());

	@Resource(name = "tlabMenuService")
	 TlabMenuService tlabMenuService;
	/**
	 *  조회
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */

	@ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_READ)  /* 조회 */
    public List<Map<String, Object>> selectList(Map param) throws Exception {
        return super.commonDao.list("s_scl901ukrv_kdService.selectList", param);
    }

	/**
     *  검색팝업창 조회
     *
     * @param param
     * @return
     * @throws Exception
     */

    @ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)  /* 검색팝업창 조회 */
    public List<Map<String, Object>> selectList2(Map param) throws Exception {
        return super.commonDao.list("s_scl901ukrv_kdService.selectList2", param);
    }

//    /**
//     *  마스터 조회
//     *
//     * @param param
//     * @return
//     * @throws Exception
//     */
//
//    @ExtDirectMethod(value = ExtDirectMethodType.FORM_LOAD, group = "sales")
//    public Object selectMaster(Map param) throws Exception {
//        return super.commonDao.select("s_scl901ukrv_kdService.selectMaster", param);
//    }

    /**
     *  클레임번호 조회(중복검사)
     *
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_READ)  /* 클레임번호 조회(중복검사) */
    public List<Map<String, Object>> checkClaimNo(Map param) throws Exception {
        return super.commonDao.list("s_scl901ukrv_kdService.checkClaimNo", param);
    }

//    /**
//     *  master 저장
//     *
//     * @param param
//     * @return
//     * @throws Exception
//     */
//    @ExtDirectMethod(value = ExtDirectMethodType.FORM_POST, group = "sales")
//    public ExtDirectFormPostResult syncMaster(S_scl901ukrv_kdModel param, LoginVO user,  BindingResult result) throws Exception {
//        param.setS_USER_ID(user.getUserID());
//        Map<String, Object> autoSpParam = new HashMap<String, Object>();
//        SimpleDateFormat dateFormat = new SimpleDateFormat ("yyyyMMdd");
//        Date dateGet = new Date ();
//        String dateGetString = dateFormat.format(dateGet);
//        autoSpParam.put("COMP_CODE", user.getCompCode());
//        autoSpParam.put("DIV_CODE", "");
//        autoSpParam.put("TABLE_ID","s_scl901ukrv_kd");
//        autoSpParam.put("PREFIX", "A");
//        autoSpParam.put("BASIS_DATE", dateGetString);
//        autoSpParam.put("AUTO_TYPE", "1");
//        super.commonDao.queryForObject("s_scl901ukrv_kdService.spAutoNum", autoSpParam);
//
//        param.setCLAIM_NO((String)autoSpParam.get("KEY_NUMBER"));
//        param.setCOMP_CODE((String)autoSpParam.get("COMP_CODE"));
//        super.commonDao.insert("s_scl901ukrv_kdService.insert", param);
//        ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);
//
//        extResult.addResultProperty("CLAIM_NO", ObjUtils.getSafeString(param.getCLAIM_NO()));
//
//        return extResult;
//    }

    /**
     *  detail 저장
     *
     * @param param
     * @return
     * @throws Exception
     */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
    public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
        logger.debug("[saveAll] paramMaster:" + paramMaster);
        Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
        dataMaster.put("COMP_CODE", user.getCompCode());

        String claimNo = (String) dataMaster.get("CLAIM_NO");
        //if (ObjUtils.isEmpty(dataMaster.get("CLAIM_NO") )) {
            Map<String, Object> spParam = new HashMap<String, Object>();
            spParam.put("COMP_CODE", user.getCompCode());
            spParam.put("DIV_CODE", dataMaster.get("DIV_CODE"));
            spParam.put("TABLE_ID","s_scl901ukrv_kd");
            spParam.put("PREFIX", "A");
            spParam.put("BASIS_DATE", dataMaster.get("CLAIM_DATE"));
            spParam.put("AUTO_TYPE", "1");
          //  super.commonDao.queryForObject("s_scl901ukrv_kdService.spAutoNum", spParam);
          // dataMaster.put("CLAIM_NO", ObjUtils.getSafeString(spParam.get("KEY_NUMBER")));
          //claimNo = ObjUtils.getSafeString(spParam.get("KEY_NUMBER"));


       /* } else {

        }*/
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
            if(deleteList != null) this.deleteDetail(deleteList, user);
            if(updateList != null) this.updateDetail(updateList, user);
            if(insertList != null) this.insertDetail(insertList, user, claimNo);
        } else {

        }
        paramList.add(0, paramMaster);

        return  paramList;
   }

       @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")          // INSERT
       public Integer insertDetail(List<Map> paramList, LoginVO user, String claimNo) throws Exception {
           for(Map param : paramList ) {
               param.put("CLAIM_NO", claimNo);
               int chk = 0;
               chk = (int) super.commonDao.select("s_scl901ukrv_kdService.checkClaimNoBeforeInsert", param);
               if(chk == 0){
            	   super.commonDao.insert("s_scl901ukrv_kdService.insert", param);
               }
               super.commonDao.update("s_scl901ukrv_kdService.insertDetail", param);
           }
           return 0;
       }

       @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")          // UPDATE
       public Integer updateDetail(List<Map> paramList, LoginVO user) throws Exception {
           Map compCodeMap = new HashMap();
           for(Map param :paramList ) {
               super.commonDao.update("s_scl901ukrv_kdService.updateDetail", param);
           }
           return 0;
       }


       @ExtDirectMethod(group = "base", needsModificatinAuth = true)                        // DELETE
       public Integer deleteDetail(List<Map> paramList,  LoginVO user) throws Exception {
           Map compCodeMap = new HashMap();
           for(Map param :paramList ) {
               super.commonDao.update("s_scl901ukrv_kdService.deleteDetail", param);
           }
           return 0;
   }
       @ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_READ)
       public List<Map<String, Object>> selectExcelUploadSheet1(Map param) throws Exception {
   		  return super.commonDao.list("s_scl901ukrv_kdService.selectExcelUploadSheet1", param);
   	  }
       public void excelValidate(String jobID, Map param) throws Exception {
   		logger.debug("validate: {}", jobID);
   		//UPLOAD 전 데이터 존재여부 체크
   		List<Map> getData = (List<Map>) super.commonDao.list("s_scl901ukrv_kdService.getData", param);

   		if(!getData.isEmpty()){
   			//excel 파일의 데이터 체크
   			for(Map data : getData )  {
                   param.put("ROWNUM", data.get("_EXCEL_ROWNUM"));
   				param.put("COMP_CODE", data.get("COMP_CODE"));
   				param.put("ITEM_CODE", data.get("ITEM_CODE"));
   				param.put("BS_COUNT", data.get("BS_COUNT"));
   				param.put("CLAIM_AMT", data.get("CLAIM_AMT"));
   				param.put("GJ_AMT", data.get("GJ_AMT"));
   			}
   		}
   	}
}
