package foren.unilite.modules.base.bpr;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("bpr585skrvService")
public class Bpr585skrvServiceImpl  extends TlabAbstractServiceImpl {

    /**
     * 집약정전개 조회
     * @param param 검색항목
     * @return
     * @throws Exception
     */ 
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "bpr")
    public List<Map<String, Object>>  selectList1(Map param) throws Exception {
        return  super.commonDao.list("bpr585skrvServiceImpl.selectList1", param);
    }

    @ExtDirectMethod(group = "base", value = ExtDirectMethodType.STORE_READ)
    public Object chekCompCode(Map param) throws Exception {
        return super.commonDao.select("bpr585skrvServiceImpl.chekCompCode", param);
    }
}
