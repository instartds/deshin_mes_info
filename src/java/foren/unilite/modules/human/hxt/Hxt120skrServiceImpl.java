package foren.unilite.modules.human.hxt;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service( "hxt120skrServiceImpl" )
public class Hxt120skrServiceImpl extends TlabAbstractServiceImpl {
    private final Logger logger = LoggerFactory.getLogger(this.getClass());
    
    /**
     * 경력사항조회
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(group = "hum", value = ExtDirectMethodType.STORE_READ)   /* 조회 */
    public List<Map<String, Object>> selectList(Map param) throws Exception {
        return super.commonDao.list("hxt120skrService.selectList", param);
    }
}
