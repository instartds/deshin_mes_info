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
import foren.unilite.com.tags.ComboItemModel;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.base.bor.Bor100ukrvModel;


@Service("s_sbx901ukrv_kdService")
public class S_sbx901ukrv_kdServiceImpl extends TlabAbstractServiceImpl {
    	private final Logger	logger	= LoggerFactory.getLogger(this.getClass());

    	@Resource(name = "tlabMenuService")
    	 TlabMenuService tlabMenuService;
    	/**
         *  입고조회
         *
         * @param param
         * @return
         * @throws Exception
         */
        @ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_READ)      // 조회
        public List<Map<String, Object>> selectList(Map param) throws Exception {
            return super.commonDao.list("s_sbx901ukrv_kdService.selectList", param);
        }

        /**
         *  출고조회
         *
         * @param param
         * @return
         * @throws Exception
         */
        @ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_READ)      // 조회
        public List<Map<String, Object>> selectList2(Map param) throws Exception {
            return super.commonDao.list("s_sbx901ukrv_kdService.selectList2", param);
        }

        /**
         *  검색POPUP조회
         *
         * @param param
         * @return
         * @throws Exception
         */
        @ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_READ)      // 조회
        public List<Map<String, Object>> selectList3(Map param) throws Exception {
            return super.commonDao.list("s_sbx901ukrv_kdService.selectList3", param);
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
        public List<Map> saveAll(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
            logger.debug("[saveAll] paramDetail:" + paramList);
            Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
            Map<String, Object> spParam = new HashMap<String, Object>();
            SimpleDateFormat dateFormat = new SimpleDateFormat ("yyyyMMdd");
            Date dateGet = new Date ();
            String dateGetString = dateFormat.format(dateGet);

            List<Map> dataList = new ArrayList<Map>();
            for(Map paramData: paramList) {
                dataList = (List<Map>) paramData.get("data");
                String oprFlag = "N";
                if(paramData.get("method").equals("insertDetail")) oprFlag="N";
                if(paramData.get("method").equals("updateDetail")) oprFlag="U";
                if(paramData.get("method").equals("deleteDetail")) oprFlag="D";

                for(Map param:  dataList) {
                    param.put("FLAG", oprFlag);
                    param.put("USER_ID", user.getUserID());
                    param.put("COMP_CODE", user.getCompCode());
                    super.commonDao.update("s_sbx901ukrv_kdService.spReceiving", param);
                }
            }
            String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
            if(!ObjUtils.isEmpty(errorDesc)) {
                String[] messsage = errorDesc.split(";");
                throw new  UniDirectValidateException(this.getMessage(messsage[0], user));
            }

            paramList.add(0, paramMaster);
            return  paramList;
       }

       @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")          // INSERT
       public Integer insertDetail(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {

           return 0;
       }

       @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")          // UPDATE
       public Integer updateDetail(List<Map> paramList, LoginVO user) throws Exception {

           return 0;
       }


       @ExtDirectMethod(group = "base", needsModificatinAuth = true)                        // DELETE
       public Integer deleteDetail(List<Map> paramList,  LoginVO user) throws Exception {

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
       public List<Map> saveAll2(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
           logger.debug("[saveAll] paramDetail:" + paramList);
           Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
           Map<String, Object> spParam = new HashMap<String, Object>();
           SimpleDateFormat dateFormat = new SimpleDateFormat ("yyyyMMdd");
           Date dateGet = new Date ();
           String dateGetString = dateFormat.format(dateGet);

           List<Map> dataList = new ArrayList<Map>();
           for(Map paramData: paramList) {
               dataList = (List<Map>) paramData.get("data");
               String oprFlag = "N";
               if(paramData.get("method").equals("insertDetail2")) oprFlag="N";
               if(paramData.get("method").equals("updateDetail2")) oprFlag="U";
               if(paramData.get("method").equals("deleteDetail2")) oprFlag="D";

               for(Map param:  dataList) {
                   param.put("FLAG", oprFlag);
                   param.put("USER_ID", user.getUserID());
                   param.put("COMP_CODE", user.getCompCode());
                   super.commonDao.update("s_sbx901ukrv_kdService.spReceiving", param);
               }
           }
           String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
           if(!ObjUtils.isEmpty(errorDesc)) {
               String[] messsage = errorDesc.split(";");
               throw new  UniDirectValidateException(this.getMessage(messsage[0], user));
           }

           paramList.add(0, paramMaster);
           return  paramList;
      }

      @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")          // INSERT
      public Integer insertDetail2(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {

          return 0;
      }

      @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")          // UPDATE
      public Integer updateDetail2(List<Map> paramList, LoginVO user) throws Exception {

          return 0;
      }


      @ExtDirectMethod(group = "base", needsModificatinAuth = true)                        // DELETE
      public Integer deleteDetail2(List<Map> paramList,  LoginVO user) throws Exception {

          return 0;
      }

      /**
       *  BOX입출고유형 조회
       *
       * @param param
       * @return
       * @throws Exception
       */
      @ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_READ)      // 조회
      public  List<ComboItemModel> selectZ0031(Map param) throws Exception {
          return super.commonDao.list("s_sbx901ukrv_kdService.selectZ0031", param);
      }

      /**
       *  BOX입출고유형 조회
       *
       * @param param
       * @return
       * @throws Exception
       */
      @ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_READ)      // 조회
      public  List<ComboItemModel> selectZ0032(Map param) throws Exception {
          return super.commonDao.list("s_sbx901ukrv_kdService.selectZ0032", param);
      }
      
      
      
      @ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_READ)
      public List<Map<String, Object>> selectExcelUploadSheet1(Map param) throws Exception {
  		  return super.commonDao.list("s_sbx901ukrv_kdService.selectExcelUploadSheet1", param);
  	  }
      public void excelValidate(String jobID, Map param) throws Exception {
  		logger.debug("validate: {}", jobID);
  		//UPLOAD 전 데이터 존재여부 체크
  		List<Map> getData = (List<Map>) super.commonDao.list("s_sbx901ukrv_kdService.getData", param);
  		
  		if(!getData.isEmpty()){
  			//excel 파일의 데이터 체크
  			for(Map data : getData )  { 
                  param.put("ROWNUM", data.get("_EXCEL_ROWNUM"));
  				param.put("COMP_CODE", data.get("COMP_CODE"));
  				param.put("PERSON_NUMB", data.get("PERSON_NUMB"));
  				param.put("RETR_DATE", data.get("RETR_DATE"));
  				param.put("RETR_TYPE", data.get("RETR_TYPE"));
  			}
  		}
  	}
      
}
