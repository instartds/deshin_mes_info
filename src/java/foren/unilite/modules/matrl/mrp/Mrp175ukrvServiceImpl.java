package foren.unilite.modules.matrl.mrp;

import java.util.ArrayList;
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
import foren.framework.extjs.UniliteExtjsUtils;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.base.bdc.Bdc100ukrvService;
import foren.unilite.modules.com.fileman.FileMnagerService;



@Service("mrp175ukrvService")
public class Mrp175ukrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	

	
	
	/**
	 * ROP품목 소요량 확정(부분) detail 조회
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectGrid(Map param) throws Exception {
		return super.commonDao.list("mrp175ukrvServiceImpl.selectGrid", param);
	}
	
	/**
     *  ROP품목 소요량 확정(부분)
     * @param paramList 리스트의 create, update, destroy 오퍼레이션별 정보
     * @param paramMaster 폼(마스터 정보)의 기본 정보
     * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
     * @throws Exception
     */
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "matrl")
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})   
    public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
        logger.debug("[saveAll] paramDetail:" + paramList);

        //1.로그테이블에서 사용할 KeyValue 생성
        String keyValue = getLogKey();                      
                
        //2.출하지시 로그테이블에 KEY_VALUE, OPR_FLAG 업데이트
        List<Map> dataList = new ArrayList<Map>();
        List<List<Map>> resultList = new ArrayList<List<Map>>();
        Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
        for(Map paramData: paramList) {
            dataList = (List<Map>) paramData.get("data");
            for(Map param:  dataList) {
                param.put("PLAN_PSRN", dataMaster.get("PLAN_PSRN"));
                Map errorMap = (Map) super.commonDao.select("mrp175ukrvServiceImpl.USP_MATRL_Mrp175ukrv", param);
                if(!ObjUtils.isEmpty(errorMap.get("errorDesc"))){
                    String errorDesc = (String) errorMap.get("errorDesc");
                    String[] messsage = errorDesc.split(";");
                    throw new  UniDirectValidateException(this.getMessage(messsage[0], user));
                }                     
            }
        }        
        paramList.add(0, paramMaster);      
        return  paramList;
    }
    
    /**
     * 출고 Detail 입력
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_MODIFY)
    public List<Map> insertDetail(List<Map> params, LoginVO user) throws Exception {        
        return params;
    }
	
	
}
