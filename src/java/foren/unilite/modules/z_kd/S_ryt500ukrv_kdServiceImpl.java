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
import foren.unilite.modules.base.bor.Bor100ukrvModel;


@Service("s_ryt500ukrv_kdService")
public class S_ryt500ukrv_kdServiceImpl extends TlabAbstractServiceImpl {
        private final Logger    logger  = LoggerFactory.getLogger(this.getClass());

        @Resource(name = "tlabMenuService")
         TlabMenuService tlabMenuService;

        @ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_READ)      // 거래처 조회
        public List<Map<String, Object>> selectCustData(Map param) throws Exception {
            return super.commonDao.list("s_ryt500ukrv_kdService.selectCustData", param);
        }

        /**
         *  조회
         *
         * @param param
         * @return
         * @throws Exception
         */
        @ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_READ)      // 조회
        public List<Map<String, Object>> selectList(Map param) throws Exception {
            return super.commonDao.list("s_ryt500ukrv_kdService.selectList", param);
        }

        /**
         *  조회2
         *
         * @param param
         * @return
         * @throws Exception
         */
        @ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_READ)      // 조회
        public List<Map<String, Object>> selectList2(Map param) throws Exception {
            return super.commonDao.list("s_ryt500ukrv_kdService.selectList2", param);
        }

        /**
         *  저장
         *
         * @param param
         * @return
         * @throws Exception
         */
        @ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
        @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
        public List<Map> saveAll(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {

            Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
            Map<String, Object> spParam = new HashMap<String, Object>();
            SimpleDateFormat dateFormat = new SimpleDateFormat ("yyyyMMdd");
            Date dateGet = new Date ();
            String dateGetString = dateFormat.format(dateGet);
            String saveStyle 	 = (String)dataMaster.get("SAVE_TYPE");
            List<Map> dataList = new ArrayList<Map>();
            for(Map paramData: paramList) {
                dataList = (List<Map>) paramData.get("data");
                String oprFlag = "N";
                if(paramData.get("method").equals("insertDetail4")) oprFlag="N";
                if(paramData.get("method").equals("updateDetail4")) oprFlag="U";
                if(paramData.get("method").equals("deleteAll")) oprFlag="D";
                if((oprFlag.equals("N") || oprFlag.equals("U")) && saveStyle.equals("CALC")){//로얄티 정산인 경우
                	for(Map param:  dataList) {
//                      param.put("CAL_DATE", dateGetString);
                  	  param.put("USER_ID", user.getUserID());
                      param.put("EXCHG_RATE_O", ObjUtils.parseDouble(param.get("EXCHG_RATE_O")));

                      spParam.put("USER_ID", user.getUserID());
                      spParam.put("EXCHG_RATE_O", ObjUtils.parseDouble(param.get("EXCHG_RATE_O")));
                      spParam.put("COMP_CODE", param.get("COMP_CODE"));
                      spParam.put("DIV_CODE", param.get("DIV_CODE"));
                      spParam.put("CUSTOM_CODE", param.get("CUSTOM_CODE"));
                      spParam.put("WORK_YEAR", dataMaster.get("WORK_YEAR"));
                      spParam.put("WORK_SEQ", dataMaster.get("WORK_SEQ"));
                      spParam.put("CON_FR_YYMM", dataMaster.get("CON_FR_YYMM"));
                      spParam.put("CON_TO_YYMM", dataMaster.get("CON_TO_YYMM"));
                      spParam.put("GUBUN1", param.get("GUBUN1"));
                      spParam.put("GUBUN3",param.get("GUBUN3"));
                      spParam.put("CAL_DATE", param.get("CAL_DATE"));
                      spParam.put("MONEY_UNIT", param.get("MONEY_UNIT"));
                      spParam.put("CONFIRM_YN", param.get("CONFIRM_YN"));
                      super.commonDao.update("s_ryt500ukrv_kdService.spReceiving", spParam);
                     // super.commonDao.update("s_ryt500ukrv_kdService.updateConfirmYn", param);
                  }
                }else if((oprFlag.equals("N") || oprFlag.equals("U")) && !saveStyle.equals("CALC")){	//확정체크해서 저장하는 경우
                	updateConfirmYn(dataList, user) ;
                	if((int) super.commonDao.select("s_ryt500ukrv_kdService.confirmYnChk", dataMaster) > 1){
                  	  	throw new	UniDirectValidateException(this.getMessage("이미 확정된 데이터가 있습니다.\n 기존 내역 확정 취소 후 다시 시도해주세요.", user));
                  	  }
                }else if(oprFlag.equals("D")){
              	  deleteAll(dataList, user) ;
                }

            }

            String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
			if(!ObjUtils.isEmpty(errorDesc)) {
//					String[] messsage = errorDesc.split(";");
				throw new	UniDirectValidateException(this.getMessage(errorDesc, user));
			}

            paramList.add(0, paramMaster);
            return  paramList;
       }

        @ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
        @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
        public List<Map> saveAll2(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
        	logger.debug("[saveall23]" +  paramMaster.get("data"));

        	 Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
        	if(paramList != null)  {
                List<Map> updateList2 = null;
                List<Map> deleteList2 = null;
                for(Map dataListMap: paramList) {
                	logger.debug("[dataListMap]" + dataListMap);
                	if(dataListMap.get("method").equals("updateDetail2")) {
                    	updateList2 = (List<Map>)dataListMap.get("data");
                    }else if(dataListMap.get("method").equals("deleteDetail2")){
                    	deleteList2 = (List<Map>)dataListMap.get("data");
                    }
                }
                if(updateList2 != null) this.updateDetail2(updateList2, user, (String) dataMaster.get("CUSTOM_CODE"));
                if(deleteList2 != null) this.deleteDetail2(deleteList2, user, (String) dataMaster.get("CUSTOM_CODE"));
            }
            paramList.add(0, paramMaster);

            return  paramList;
       }

        @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")          // INSERT
        public Integer insertDetail(List<Map> paramList, LoginVO user) throws Exception {
            for(Map param : paramList ) {
                super.commonDao.update("s_ryt500ukrv_kdService.insertDetail", param);
            }
            return 0;
        }

        @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")          // INSERT
        public Integer insertDetail2(List<Map> paramList, LoginVO user) throws Exception {
            for(Map param : paramList ) {
                super.commonDao.update("s_ryt500ukrv_kdService.insertDetail2", param);
            }
            return 0;
        }

        @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")          // UPDATE
        public Integer updateDetail2(List<Map> paramList, LoginVO user, String customCode ) throws Exception {
            Map compCodeMap = new HashMap();
            for(Map param :paramList ) {

            	param.put("CUSTOM_CODE", customCode);
            	super.commonDao.update("s_ryt500ukrv_kdService.updateDetail2", param);
            }
            return 0;
        }

        @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")          // UPDATE
        public Integer updateDetail(List<Map> paramList, LoginVO user) throws Exception {
            Map compCodeMap = new HashMap();
            for(Map param :paramList ) {
                super.commonDao.update("s_ryt500ukrv_kdService.spReceiving", param);
            }
            return 0;
        }

        @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")          // DELETE
        public Integer deleteDetail2(List<Map> paramList,  LoginVO user, String customCode) throws Exception {
        	for(Map param :paramList ) {
        		param.put("CUSTOM_CODE", customCode);
                //1 디테일 삭제
                //super.commonDao.delete("s_ryt500ukrv_kdService.deleteDetail", param);
        		super.commonDao.delete("s_ryt500ukrv_kdService.deleteDetail", param);
                //2 체크
               /* int chk =  (int) super.commonDao.select("s_ryt500ukrv_kdService.beforeDeleteCheck", param);

                    //3 디테일 없으면 마스터 삭제
                if(chk == 0){
                	super.commonDao.delete("s_ryt500ukrv_kdService.deleteMaster", param);
                }
*/
            }
            return 0;
        }

        @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")          // UPDATE
        public Integer updateConfirmYn(List<Map> paramList, LoginVO user ) throws Exception {
            Map compCodeMap = new HashMap();
            for(Map param :paramList ) {

            	super.commonDao.update("s_ryt500ukrv_kdService.updateConfirmYn", param);
            }
            return 0;
        }

        @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")          // UPDATE
        public Integer deleteAll(List<Map> paramList, LoginVO user ) throws Exception {
            Map compCodeMap = new HashMap();
            for(Map param :paramList ) {

            	super.commonDao.update("s_ryt500ukrv_kdService.deleteMaster", param);
            }
            return 0;
        }

}
