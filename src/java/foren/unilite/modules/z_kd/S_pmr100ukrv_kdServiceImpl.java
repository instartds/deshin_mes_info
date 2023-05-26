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
import foren.framework.extjs.UniliteExtjsUtils;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.base.bdc.Bdc100ukrvService;
import foren.unilite.modules.com.fileman.FileMnagerService;
import foren.unilite.modules.prodt.pmp.Pmp160ukrvModel;


@Service("s_pmr100ukrv_kdService")
@SuppressWarnings({"rawtypes", "unchecked"})
public class S_pmr100ukrv_kdServiceImpl extends TlabAbstractServiceImpl {
    	private final Logger logger = LoggerFactory.getLogger(this.getClass());

    	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)		// 작업실적등록 조회
    	public List<Map<String, Object>> selectDetailList(Map param) throws Exception {
    		return super.commonDao.list("s_pmr100ukrv_kdServiceImpl.selectDetailList", param);
    	}
    	// END OF 작업실적등록

    	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)		// 공정별등록 조회1
    	public List<Map<String, Object>> selectDetailList3(Map param) throws Exception {
    		return super.commonDao.list("s_pmr100ukrv_kdServiceImpl.selectDetailList3", param);
    	}
    	// END OF 공정별등록 조회1

    	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)		// 공정별등록 조회2
    	public List<Map<String, Object>> selectDetailList4(Map param) throws Exception {
    		return super.commonDao.list("s_pmr100ukrv_kdServiceImpl.selectDetailList4", param);
    	}
    	// END OF 공정별등록2

    	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)		// 불량내역등록 조회
    	public List<Map<String, Object>> selectDetailList5(Map param) throws Exception {
    		return super.commonDao.list("s_pmr100ukrv_kdServiceImpl.selectDetailList5", param);
    	}
    	// END OF 불량내역등록

    	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)		// 특이사항등록 조회
    	public List<Map<String, Object>> selectDetailList6(Map param) throws Exception {
    		return super.commonDao.list("s_pmr100ukrv_kdServiceImpl.selectDetailList6", param);
    	}
    	// END OF 특이사항등록




    	/**
         *  detail 저장
         *
         * @param param
         * @return
         * @throws Exception
         */
		@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
        @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
        public List<Map> saveAll3(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
            logger.debug("[saveAll] paramDetail:" + paramList);

            List<Map> dataList = new ArrayList<Map>();
            for(Map paramData: paramList) {
                dataList = (List<Map>) paramData.get("data");
                String oprFlag = "N";
                if(paramData.get("method").equals("insertDetail3")) oprFlag="N";
                if(paramData.get("method").equals("updateDetail3")) oprFlag="N";
                if(paramData.get("method").equals("deleteDetail3")) oprFlag="D";

                for(Map param:  dataList) {

                    Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
                    Map<String, Object> spParam = new HashMap<String, Object>();
                    SimpleDateFormat dateFormat = new SimpleDateFormat ("yyyyMMdd");
                    Date dateGet = new Date ();
                    String dateGetString = dateFormat.format(dateGet);

                    String prodtNum = (String) dataMaster.get("PRODT_NUM");
                    spParam.put("COMP_CODE", user.getCompCode());
                    spParam.put("DIV_CODE", dataMaster.get("DIV_CODE"));
                    spParam.put("TABLE_ID","s_pmr100ukrv_kd");
                    spParam.put("PREFIX", "P");
                    spParam.put("BASIS_DATE", dateGetString);
                    spParam.put("AUTO_TYPE", "1");


                    param.put("STATUS",     oprFlag);
                    param.put("USER_ID",    user.getUserID());
                    param.put("PRODT_TYPE",  "1");
                    if(param.get("STATUS").equals("N")) {
                        //자동채번
                        super.commonDao.queryForObject("s_pmr100ukrv_kdServiceImpl.spAutoNum", spParam);
                        prodtNum = ObjUtils.getSafeString(spParam.get("KEY_NUMBER"));
                        param.put("PRODT_NUM",  prodtNum);
                        super.commonDao.update("s_pmr100ukrv_kdServiceImpl.insert", param);
                    } else if(param.get("STATUS").equals("N") && param.get("FLAG").equals("U")) {
                        super.commonDao.update("s_pmr100ukrv_kdServiceImpl.update", param);
                    }

                    int zero = 0;

                    param.put("COMP_CODE", user.getCompCode());
                    param.put("DIV_CODE", param.get("DIV_CODE"));
                    param.put("PRODT_NUM", param.get("PRODT_NUM"));
                    param.put("WKORD_NUM", param.get("WKORD_NUM"));
                    param.put("CONTROL_STATUS", param.get("CONTROL_STATUS"));
                    param.put("PRODT_TYPE", "1");
                    param.put("STATUS", param.get("FLAG"));
                    param.put("USER_ID", user.getUserID());
                    if(dataMaster.get("RESULT_YN").equals("2")) {

                    	param.put("GOOD_Q", ObjUtils.parseDouble(param.get("GOOD_WORK_Q")));
                        param.put("GOOD_WH_CODE", param.get("GOOD_WH_CODE"));
                        param.put("GOOD_PRSN", param.get("GOOD_PRSN"));
                        param.put("GOOD_WH_CELL_CODE", param.get("GOOD_WH_CELL_CODE"));
                        param.put("BAD_Q", ObjUtils.parseDouble(param.get("BAD_WORK_Q")));
                        param.put("BAD_WH_CODE", param.get("BAD_WH_CODE"));
                        param.put("BAD_PRSN", param.get("BAD_PRSN"));
                        param.put("BAD_WH_CELL_CODE", param.get("BAD_WH_CELL_CODE"));
                    } else {

                    	param.put("GOOD_WH_CODE", "");
                        param.put("GOOD_WH_CELL_CODE", "");
                        param.put("GOOD_PRSN", "");
                        param.put("GOOD_Q", ObjUtils.parseDouble(zero));
                        param.put("BAD_WH_CODE", "");
                        param.put("BAD_WH_CELL_CODE", "");
                        param.put("BAD_PRSN", "");
                        param.put("BAD_Q", ObjUtils.parseDouble(zero));
                    }

                    super.commonDao.update("s_pmr100ukrv_kdServiceImpl.spReceiving", param);
                    String errorDesc = ObjUtils.getSafeString(param.get("ERROR_DESC"));
                    if(!ObjUtils.isEmpty(errorDesc)) {
//                        String[] messsage = errorDesc.split(";");
                        throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
                    }

                    if(param.get("STATUS").equals("D")) {
                        super.commonDao.update("s_pmr100ukrv_kdServiceImpl.delete", param);
                    }
                }
            }

            paramList.add(0, paramMaster);
            return  paramList;
       }

       @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")          // INSERT
       public Integer insertDetail3(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {

           return 0;
       }

       @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")          // UPDATE
       public Integer updateDetail3(List<Map> paramList, LoginVO user) throws Exception {

           return 0;
       }


       @ExtDirectMethod(group = "base", needsModificatinAuth = true)                        // DELETE
       public Integer deleteDetail3(List<Map> paramList,  LoginVO user) throws Exception {

           return 0;
       }







       /**
        *  detail 저장
        *
        * @param param
        * @return
        * @throws Exception
        */
       @ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
       @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
       public List<Map> saveAll4(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
           logger.debug("[saveAll] paramDetail:" + paramList);
           Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");


           List<Map> dataList = new ArrayList<Map>();
           for(Map paramData: paramList) {
               dataList = (List<Map>) paramData.get("data");
               String oprFlag = "N";
               if(paramData.get("method").equals("insertDetail4")) oprFlag="N";
               if(paramData.get("method").equals("updateDetail4")) oprFlag="U";
               if(paramData.get("method").equals("deleteDetail4")) oprFlag="D";

               for(Map param:  dataList) {
                   param.put("STATUS", oprFlag);
                   param.put("USER_ID", user.getUserID());
                   param.put("PRODT_TYPE",  "1");

                   super.commonDao.update("s_pmr100ukrv_kdServiceImpl.spReceiving", param);
                   String errorDesc = ObjUtils.getSafeString(param.get("ERROR_DESC"));
                   if(!ObjUtils.isEmpty(errorDesc)) {
                    //  String[] messsage = errorDesc.split(";");
                       throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
                   }
                   super.commonDao.update("s_pmr100ukrv_kdServiceImpl.delete", param);
               }
           }

           paramList.add(0, paramMaster);
           return  paramList;
      }

      @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")          // INSERT
      public Integer insertDetail4(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {

          return 0;
      }

      @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")          // UPDATE
      public Integer updateDetail4(List<Map> paramList, LoginVO user) throws Exception {

          return 0;
      }


      @ExtDirectMethod(group = "base", needsModificatinAuth = true)                        // DELETE
      public Integer deleteDetail4(List<Map> paramList,  LoginVO user) throws Exception {

          return 0;
      }







      @ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
      @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
      public List<Map> saveAll5(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {

          if(paramList != null)  {
                 List<Map> insertList = null;
                 List<Map> updateList = null;
                 List<Map> deleteList = null;
                 for(Map dataListMap: paramList) {
                     if(dataListMap.get("method").equals("deleteDetail5")) {
                         deleteList = (List<Map>)dataListMap.get("data");
                     }else if(dataListMap.get("method").equals("insertDetail5")) {
                         insertList = (List<Map>)dataListMap.get("data");
                     } else if(dataListMap.get("method").equals("updateDetail5")) {
                         updateList = (List<Map>)dataListMap.get("data");
                     }
                 }
                 if(deleteList != null) this.deleteDetail5(deleteList, user);
                 if(insertList != null) this.insertDetail5(insertList, user);
                 if(updateList != null) this.updateDetail5(updateList, user);
             }
             paramList.add(0, paramMaster);

             return  paramList;
     }

      @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")     // INSERT
      public Integer  insertDetail5(List<Map> paramList, LoginVO user) throws Exception {
          for(Map param : paramList ) {
              super.commonDao.update("s_pmr100ukrv_kdServiceImpl.insertDetail5", param);
          }
          return 0;
      }

      @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")      // UPDATE
      public Integer updateDetail5(List<Map> paramList, LoginVO user) throws Exception {
          for(Map param :paramList ) {
              super.commonDao.update("s_pmr100ukrv_kdServiceImpl.updateDetail5", param);
          }
          return 0;
      }


      @ExtDirectMethod(group = "base", needsModificatinAuth = true)       // DELETE
      public Integer deleteDetail5(List<Map> paramList,  LoginVO user) throws Exception {
          for(Map param :paramList ) {
              super.commonDao.update("s_pmr100ukrv_kdServiceImpl.deleteDetail5", param);
          }
          return 0;
      }







      @ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
      @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
      public List<Map> saveAll6(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {

          if(paramList != null)  {
                 List<Map> insertList = null;
                 List<Map> updateList = null;
                 List<Map> deleteList = null;
                 for(Map dataListMap: paramList) {
                     if(dataListMap.get("method").equals("deleteDetail6")) {
                         deleteList = (List<Map>)dataListMap.get("data");
                     }else if(dataListMap.get("method").equals("insertDetail6")) {
                         insertList = (List<Map>)dataListMap.get("data");
                     } else if(dataListMap.get("method").equals("updateDetail6")) {
                         updateList = (List<Map>)dataListMap.get("data");
                     }
                 }
                 if(deleteList != null) this.deleteDetail6(deleteList, user);
                 if(insertList != null) this.insertDetail6(insertList, user);
                 if(updateList != null) this.updateDetail6(updateList, user);
             }
             paramList.add(0, paramMaster);

             return  paramList;
     }

      @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")     // INSERT
      public Integer  insertDetail6(List<Map> paramList, LoginVO user) throws Exception {
          for(Map param : paramList ) {
              super.commonDao.update("s_pmr100ukrv_kdServiceImpl.insertDetail6", param);
          }
          return 0;
      }

      @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")      // UPDATE
      public Integer updateDetail6(List<Map> paramList, LoginVO user) throws Exception {
          for(Map param :paramList ) {
              super.commonDao.update("s_pmr100ukrv_kdServiceImpl.updateDetail6", param);
          }
          return 0;
      }


      @ExtDirectMethod(group = "base", needsModificatinAuth = true)       // DELETE
      public Integer deleteDetail6(List<Map> paramList,  LoginVO user) throws Exception {
          for(Map param :paramList ) {
              super.commonDao.update("s_pmr100ukrv_kdServiceImpl.deleteDetail6", param);
          }
          return 0;
      }
}
