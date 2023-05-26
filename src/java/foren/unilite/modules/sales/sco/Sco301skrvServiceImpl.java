package foren.unilite.modules.sales.sco;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.sql.Blob;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.imageio.ImageIO;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("sco301skrvService")
public class Sco301skrvServiceImpl  extends TlabAbstractServiceImpl {

	/**
	 * 수금현황 조회 : 그리드 조회 목록
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "ssa")
	public List<Map<String, Object>>  selectList1(Map param) throws Exception {
		
		return  super.commonDao.list("sco301skrvServiceImpl.selectList1", param);
	}
	
	/**
     * 수금현황 조회 : 그리드 조회 목록
     * @param param 검색항목
     * @return
     * @throws Exception
     */ 
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "ssa")
    public List<Map<String, Object>>  selectList2(Map param) throws Exception {
        
        return  super.commonDao.list("sco301skrvServiceImpl.selectList2", param);
    }
    
    /**
     * 수금처집계
     * @param param 검색항목
     * @return
     * @throws Exception
     */ 
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "ssa")
    public List<Map<String, Object>>  selectCustomTotaliList(Map param) throws Exception {
        
        return  super.commonDao.list("sco301skrvServiceImpl.selectCustomTotaliList", param);
    }
    
    /**
     * 담당자집계
     * @param param 검색항목
     * @return
     * @throws Exception
     */ 
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "ssa")
    public List<Map<String, Object>>  selectPrsnTotaliList(Map param) throws Exception {
        
        return  super.commonDao.list("sco301skrvServiceImpl.selectPrsnTotaliList", param);
    }
    

}
