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
import foren.unilite.modules.com.fileman.FileMnagerService;


@Service("s_zcc800skrv_kdService")
public class S_zcc800skrv_kdServiceImpl extends TlabAbstractServiceImpl {
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
        @ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
        public List<Map<String, Object>> selectPersonDept(Map param) throws Exception {
            return super.commonDao.list("s_zcc800skrv_kdService.selectPersonDept", param);
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
            return super.commonDao.list("s_zcc800skrv_kdService.selectList", param);
        }
}
