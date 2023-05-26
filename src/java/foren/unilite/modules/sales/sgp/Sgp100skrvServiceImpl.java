package foren.unilite.modules.sales.sgp;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("sgp100skrvService")
public class Sgp100skrvServiceImpl  extends TlabAbstractServiceImpl {
	
	/**
     * 거래처별
     * @param param 검색항목
     * @return
     * @throws Exception
     */ 
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "ssa")
    public List<Map<String, Object>>  customSelectList(Map param) throws Exception {
        
        return  super.commonDao.list("sgp100skrvServiceImpl.customSelectList", param);
    }	

	/**
	 * 영업담당별
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "ssa")
	public List<Map<String, Object>>  salePrsnSelectList(Map param) throws Exception {
		
		return  super.commonDao.list("sgp100skrvServiceImpl.salePrsnSelectList", param);
	}
    
    /**
     * 품목별
     * @param param 검색항목
     * @return
     * @throws Exception
     */ 
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "ssa")
    public List<Map<String, Object>>  itemSelectList(Map param) throws Exception {
        
        return  super.commonDao.list("sgp100skrvServiceImpl.itemSelectList", param);
    }
    
    /**
     * 품목분류별
     * @param param 검색항목
     * @return
     * @throws Exception
     */ 
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "ssa")
    public List<Map<String, Object>>  itemSortSelectList(Map param) throws Exception {
        
        return  super.commonDao.list("sgp100skrvServiceImpl.itemSortSelectList", param);
    }
    
    /**
     * 대표모델별별
     * @param param 검색항목
     * @return
     * @throws Exception
     */ 
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "ssa")
    public List<Map<String, Object>>  spokesItemSelectList(Map param) throws Exception {
        
        return  super.commonDao.list("sgp100skrvServiceImpl.spokesItemSelectList", param);
    }
    
    /**
     * 거래처품목별
     * @param param 검색항목
     * @return
     * @throws Exception
     */ 
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "ssa")
    public List<Map<String, Object>>  customerItemSelectList(Map param) throws Exception {
        
        return  super.commonDao.list("sgp100skrvServiceImpl.customerItemSelectList", param);
    }
    
    /**
     * 판매유형별
     * @param param 검색항목
     * @return
     * @throws Exception
     */ 
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "ssa")
    public List<Map<String, Object>>  saleTypeSelectList(Map param) throws Exception {
        
        return  super.commonDao.list("sgp100skrvServiceImpl.saleTypeSelectList", param);
    }

    
    /**
     * 고객품목분류별
     * @param param 검색항목
     * @return
     * @throws Exception
     */ 
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "ssa")
    public List<Map<String, Object>>  customitemSortSelectList(Map param) throws Exception {
        
        return  super.commonDao.list("sgp100skrvServiceImpl.customitemSortSelectList", param);
    }    
	
}
