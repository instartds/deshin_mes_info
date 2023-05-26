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
import foren.unilite.modules.com.fileman.FileMnagerService;


@Service("s_zdd300ukrv_kdService")
public class S_zdd300ukrv_kdServiceImpl extends TlabAbstractServiceImpl {
        private final Logger    logger  = LoggerFactory.getLogger(this.getClass());
    
        Map docNum = new HashMap();
        @Resource(name = "fileMnagerService")
        private FileMnagerService fileMnagerService;
        
        /**
         * 
         * 마스터 기안상태 조회
         * @param param
         * @return
         * @throws Exception
         */
        @ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
        public List<Map<String, Object>> selectGwData(Map param) throws Exception {
            return super.commonDao.list("s_zdd300ukrv_kdService.selectGwData", param);
        }
        
        /**
         *  기안버튼 눌렀을때 번호생성(UPDATE)
         * 
         * @param param
         * @return
         * @throws Exception
         */
        @ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_READ)  /* 기안버튼 눌렀을때 번호생성(UPDATE) */
        public List<Map<String, Object>> makeDraftNum(Map param) throws Exception {
            return super.commonDao.list("s_zdd300ukrv_kdService.makeDraftNum", param);
        }
        
        

        /**
         *  조회
         * 
         * @param param
         * @return
         * @throws Exception
         */
        @ExtDirectMethod(value = ExtDirectMethodType.FORM_LOAD, group = "base")
        public Object selectMaster(Map param) throws Exception {     
            param.put("REQ_NUM", param.get("REQ_NUM"));
            param.put("DIV_CODE", param.get("DIV_CODE"));
            return super.commonDao.select("s_zdd300ukrv_kdService.selectMaster", param);
        }
        
        /**
         *  의뢰번호 조회
         * 
         * @param param
         * @return
         * @throws Exception
         */
        @ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
        public List<Map<String, Object>> selectReqNum(Map param) throws Exception {
            return super.commonDao.list("s_zdd300ukrv_kdService.selectReqNum", param);
        }
        
        /**
         *  의뢰번호 조회
         * 
         * @param param
         * @return
         * @throws Exception
         */
        @ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
        public List<Map<String, Object>> selectReqNumFormSet(Map param) throws Exception {
            return super.commonDao.list("s_zdd300ukrv_kdService.selectReqNumFormSet", param);
        }
        
        /**
         * 
         * 사원의 해당부서 조회
         * @param param
         * @return
         * @throws Exception
         */
        @ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
        public List<Map<String, Object>> selectPersonDept(Map param) throws Exception {
            return super.commonDao.list("s_zdd300ukrv_kdService.selectPersonDept", param);
        }
        
        /**
         *  저장
         * 
         * @param param
         * @return
         * @throws Exception
         */
        @ExtDirectMethod(value = ExtDirectMethodType.FORM_POST, group = "base")
        public ExtDirectFormPostResult syncMaster(S_zdd300ukrv_kdModel param, LoginVO user,  BindingResult result) throws Exception {
            param.setS_USER_ID(user.getUserID());
            if(param.getFLAG().equals("N") && param.getREQ_NUM().isEmpty()) {
                Map<String, Object> spParam = new HashMap<String, Object>();
                SimpleDateFormat dateFormat = new SimpleDateFormat ("yyyyMMdd");
                Date dateGet = new Date ();
                String dateGetString = dateFormat.format(dateGet);
                spParam.put("COMP_CODE", user.getCompCode());            
                spParam.put("DIV_CODE", param.getDIV_CODE());
                spParam.put("TABLE_ID","s_zdd300ukrv_kd");
                spParam.put("PREFIX", "A");
                spParam.put("BASIS_DATE", dateGetString);
                spParam.put("AUTO_TYPE", "1");

                super.commonDao.queryForObject("s_zdd300ukrv_kdService.spAutoNum", spParam); 
//                param.put("P_REQ_NUM", ObjUtils.getSafeString(spParam.get("KEY_NUMBER"))); 
                param.setREQ_NUM(ObjUtils.getSafeString(spParam.get("KEY_NUMBER")));
                
                super.commonDao.update("s_zdd300ukrv_kdService.insert", param);
            } else if(param.getFLAG().equals("D")) {
                super.commonDao.update("s_zdd300ukrv_kdService.delete", param); 
            } else if(param.getFLAG().equals("U")) {
                super.commonDao.update("s_zdd300ukrv_kdService.update", param);
            }      
            ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);
            param.setREQ_NUM(ObjUtils.getSafeString(param.getREQ_NUM()));
            return extResult;
        }
}
