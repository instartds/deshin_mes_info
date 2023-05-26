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


@Service("s_ryt100ukrv_kdService")
public class S_ryt100ukrv_kdServiceImpl extends TlabAbstractServiceImpl {
        private final Logger    logger  = LoggerFactory.getLogger(this.getClass());

        @Resource(name = "tlabMenuService")
         TlabMenuService tlabMenuService;

        @ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_READ)      // 거래처 조회
        public List<Map<String, Object>> selectCustData(Map param) throws Exception {
            return super.commonDao.list("s_ryt100ukrv_kdService.selectCustData", param);
        }

        @ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_READ)      // 품목 조회
        public List<Map<String, Object>> selectItemData(Map param) throws Exception {
            return super.commonDao.list("s_ryt100ukrv_kdService.selectItemData", param);
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
            return super.commonDao.list("s_ryt100ukrv_kdService.selectList", param);
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
            return super.commonDao.list("s_ryt100ukrv_kdService.selectList2", param);
        }







        /**
         *  저장
         *
         * @param param
         * @return
         * @throws Exception
         */
        @ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "prodt")
        @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
        public List<Map> saveAll(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
            logger.debug("[saveAll] paramMaster:" + paramMaster);
            Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
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
                   if(insertList != null) this.insertDetail(insertList, user);
               }
               paramList.add(0, paramMaster);

               return  paramList;
       }

        @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")          // INSERT
        public Integer insertDetail(List<Map> paramList, LoginVO user) throws Exception {
        	String sAutoNo = null;
        	for(Map param : paramList ) {
        		param.put("TABLE","S_RYT100T_KD");
        		param.put("TYPE","R");

				Map<String, Object> autoNumMap = (Map<String, Object>)super.commonDao.select("s_ryt100ukrv_kdService.selectAutoNum",param);
				if(autoNumMap != null){
					sAutoNo = autoNumMap.get("AUTO_NUM")+"";
					param.put("CONTRACT_NUM", sAutoNo);
				}

            	super.commonDao.update("s_ryt100ukrv_kdService.insertDetail", param);
            }
            return 0;
        }

        @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")          // UPDATE
        public Integer updateDetail(List<Map> paramList, LoginVO user) throws Exception {
            Map compCodeMap = new HashMap();
            for(Map param :paramList ) {
                super.commonDao.update("s_ryt100ukrv_kdService.updateDetail", param);
            }
            return 0;
        }


        @ExtDirectMethod(group = "base", needsModificatinAuth = true)                        // DELETE
        public Integer deleteDetail(List<Map> paramList,  LoginVO user) throws Exception {
            Map compCodeMap = new HashMap();
            for(Map param :paramList ) {
                super.commonDao.update("s_ryt100ukrv_kdService.deleteDetail", param);
            }
            return 0;
        }







        /**
         *  저장2
         *
         * @param param
         * @return
         * @throws Exception
         */
        @ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "prodt")
        @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
        public List<Map> saveAll2(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
            logger.debug("[saveAll] paramMaster:" + paramMaster);
            Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
            if(paramList != null)  {
                   List<Map> insertList = null;
                   List<Map> updateList = null;
                   List<Map> deleteList = null;
                   for(Map dataListMap: paramList) {
                       if(dataListMap.get("method").equals("deleteDetail2")) {
                           deleteList = (List<Map>)dataListMap.get("data");
                       } else if(dataListMap.get("method").equals("updateDetail2")) {
                           updateList = (List<Map>)dataListMap.get("data");
                       } else if(dataListMap.get("method").equals("insertDetail2")) {
                           insertList = (List<Map>)dataListMap.get("data");
                       }
                   }
                   if(deleteList != null) this.deleteDetail2(deleteList, user);
                   if(updateList != null) this.updateDetail2(updateList, user);
                   if(insertList != null) this.insertDetail2(insertList, user);
               }
               paramList.add(0, paramMaster);

               return  paramList;
       }

        @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")          // INSERT
        public Integer insertDetail2(List<Map> paramList, LoginVO user) throws Exception {
            for(Map param : paramList ) {
//                super.commonDao.update("s_ryt100ukrv_kdService.insertDetail2", param);

                Map<String, Object> itemInfo = (Map<String, Object>)super.commonDao.select("s_ryt100ukrv_kdService.itemCheckBeforeSave", param);
                if(ObjUtils.parseInt(itemInfo.get("CNT")) >= 1) {
                    throw new  UniDirectValidateException("작업기간내에 같은 품목이 입력되었습니다.");
                } else {
                    super.commonDao.update("s_ryt100ukrv_kdService.insertDetail2", param);
                }


            }
            return 0;
        }

        @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")          // UPDATE
        public Integer updateDetail2(List<Map> paramList, LoginVO user) throws Exception {
            Map compCodeMap = new HashMap();
            for(Map param :paramList ) {

//                Map<String, Object> itemInfo2 = (Map<String, Object>)super.commonDao.select("s_ryt100ukrv_kdService.itemCheckBeforeUpdate", param);
                Map<String, Object> itemInfo2 = (Map<String, Object>)super.commonDao.select("s_ryt100ukrv_kdService.itemCheckBeforeSave", param);
                if(ObjUtils.parseInt(itemInfo2.get("CNT")) >= 1) {
                    throw new  UniDirectValidateException("작업기간내에 같은 품목이 입력되었습니다.");
                } else {
                    super.commonDao.update("s_ryt100ukrv_kdService.updateDetail2", param);
                }

//                super.commonDao.update("s_ryt100ukrv_kdService.updateDetail2", param);
            }
            return 0;
        }


        @ExtDirectMethod(group = "base", needsModificatinAuth = true)                        // DELETE
        public Integer deleteDetail2(List<Map> paramList,  LoginVO user) throws Exception {
            Map compCodeMap = new HashMap();
            for(Map param :paramList ) {
                super.commonDao.update("s_ryt100ukrv_kdService.deleteDetail2", param);
            }
            return 0;
        }
}
