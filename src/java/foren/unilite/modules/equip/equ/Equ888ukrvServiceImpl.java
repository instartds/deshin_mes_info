package foren.unilite.modules.equip.equ;

import java.io.File;
import java.io.IOException;
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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.model.LoginVO;
import foren.framework.utils.ConfigUtil;
import foren.framework.utils.FileUtil;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.service.impl.TlabMenuService;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.base.bor.Bor100ukrvModel;
import foren.unilite.modules.com.fileman.FileMnagerService;
import foren.unilite.modules.equip.eqt.Eqt200ukvrModel;
import foren.unilite.utils.ExtFileUtils;


@Service("equ888ukrvService")
public class Equ888ukrvServiceImpl extends TlabAbstractServiceImpl {
        private final Logger    logger  = LoggerFactory.getLogger(this.getClass());

        Map itemCode = new HashMap();
        @Resource(name = "fileMnagerService")
        private FileMnagerService fileMnagerService;
    	public final static String FILE_TYPE_OF_PHOTO = "equip";



    	/**
         *  금형 조회
         *
         * @param param
         * @return
         * @throws Exception
         */
        @ExtDirectMethod(group = "equip", value = ExtDirectMethodType.STORE_READ)      // 조회
        public List<Map<String, Object>> selectMaster(Map param) throws Exception {
            return super.commonDao.list("equ888ukrvService.selectMaster", param);
        }


        /**
         * 금형 저장
         * @param param
         * @return
         * @throws Exception
         */
        @ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "equip")
        @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
        public List<Map> saveAllMaster(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {

            Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
            dataMaster.put("COMP_CODE", user.getCompCode());

            if(paramList != null)  {
               List<Map> insertList = null;
               List<Map> updateList = null;
               List<Map> deleteList = null;
               for(Map dataListMap: paramList) {
                   if(dataListMap.get("method").equals("deleteMaster")) {
                       deleteList = (List<Map>)dataListMap.get("data");
                   } else if(dataListMap.get("method").equals("updateMaster")) {
                       updateList = (List<Map>)dataListMap.get("data");
                   } else if(dataListMap.get("method").equals("insertMaster")) {
                       insertList = (List<Map>)dataListMap.get("data");
                   }
               }
               if(deleteList != null) this.deleteMaster(deleteList, user);
               if(updateList != null) this.updateMaster(updateList, user);
               if(insertList != null) this.insertMaster(insertList, user);
           }

           paramList.add(0, paramMaster);

           return  paramList;
       }

        @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "equip")
        public void insertMaster(List<Map> paramList, LoginVO user) throws Exception {
            for(Map param :paramList ) {
            	param.put("EQU_CODE", ObjUtils.getSafeString(param.get("EQU_CODE_1")).toUpperCase()+ "-" + ObjUtils.getSafeString(param.get("EQU_CODE_2")));
            	param.put("EQU_SIZE_W", ObjUtils.nvl(param.get("EQU_SIZE_W"),'0'));
            	param.put("EQU_SIZE_L", ObjUtils.nvl(param.get("EQU_SIZE_L"),'0'));
            	param.put("EQU_SIZE_H", ObjUtils.nvl(param.get("EQU_SIZE_H"),'0'));
            	param.put("PRODT_O", ObjUtils.nvl(param.get("PRODT_O"),'0'));
            	param.put("WORK_Q", ObjUtils.nvl(param.get("WORK_Q"),'0'));


                super.commonDao.update("equ888ukrvService.insertMaster", param);
            }
            return ;
        }

        @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "equip")
        public void updateMaster(List<Map> paramList, LoginVO user) throws Exception {
            for(Map param :paramList ) {
            	param.put("EQU_SIZE_W", ObjUtils.nvl(param.get("EQU_SIZE_W"),'0'));
            	param.put("EQU_SIZE_L", ObjUtils.nvl(param.get("EQU_SIZE_L"),'0'));
            	param.put("EQU_SIZE_H", ObjUtils.nvl(param.get("EQU_SIZE_H"),'0'));
            	param.put("PRODT_O", ObjUtils.nvl(param.get("PRODT_O"),'0'));
            	param.put("WORK_Q", ObjUtils.nvl(param.get("WORK_Q"),'0'));
                super.commonDao.update("equ888ukrvService.updateMaster", param);
            }
            return ;
        }

        @ExtDirectMethod(group = "equip", value = ExtDirectMethodType.STORE_MODIFY)
        public void deleteMaster(List<Map> paramList,  LoginVO user) throws Exception {
            for(Map param :paramList ) {
               super.commonDao.update("equ888ukrvService.deleteMaster", param);
            }
            return ;
        }


}
