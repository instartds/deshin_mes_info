package foren.unilite.modules.z_kd;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.sql.Blob;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.imageio.ImageIO;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.service.impl.TlabMenuService;

@Service("s_sco901skrv_kdService")
public class S_sco901skrv_kdServiceImpl  extends TlabAbstractServiceImpl {

    @Resource(name = "tlabMenuService")
    TlabMenuService tlabMenuService;
   /**
    *  조회
    * 
    * @param param
    * @return
    * @throws Exception
    */
   @ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_READ)      // 조회
   public List<Map<String, Object>> selectList(Map param) throws Exception {
       return super.commonDao.list("s_sco901skrv_kdService.selectList", param);
   }
}
