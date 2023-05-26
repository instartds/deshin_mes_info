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


@Service("s_zcc100skrv_kdService")
public class S_zcc100skrv_kdServiceImpl extends TlabAbstractServiceImpl {
        private final Logger    logger  = LoggerFactory.getLogger(this.getClass());
    
        Map isirNum = new HashMap();
        @Resource(name = "fileMnagerService")
        private FileMnagerService fileMnagerService;
        
        /**
         *  조회
         * 
         * @param param
         * @return
         * @throws Exception
         */
        @ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_READ)      // 조회
        public List<Map<String, Object>> selectList(Map param) throws Exception {
            return super.commonDao.list("s_zcc100skrv_kdService.selectList", param);
        }
        
        
        /**
         * 파일업로드 조회
         * 
         * @param param
         * @return
         * @throws Exception
         */
        @SuppressWarnings("unchecked")
        @ExtDirectMethod(group = "jim")
        public List<Map<String, Object>> getFileList(Map param,  LoginVO login) throws Exception {
            param.put("S_COMP_CODE", login.getCompCode());
            return super.commonDao.list("s_zcc100skrv_kdService.getFileList", param);
        }
}
