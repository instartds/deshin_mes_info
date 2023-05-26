package foren.unilite.modules.sales.ssu;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.com.fileman.FileMnagerService;

@Service("ssu100ukrvService")
public class Ssu100ukrvServiceImpl extends TlabAbstractServiceImpl  {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@Resource(name = "fileMnagerService")
	private FileMnagerService fileMnagerService;
	
	
	/**
     * 조회
     * @param param
     * @param user
     * @return
     * @throws Exception
     */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "base")
    public List<Map> selectList(Map param, LoginVO user) throws Exception {
        return  super.commonDao.list("ssu100ukrvServiceImpl.selectList", param);
    }
	
	
	
	/**
     * 저장
     * @param paramList 리스트의 create, update, destroy 오퍼레이션별 정보
     * @param paramMaster 폼(마스터 정보)의 기본 정보
     * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
     * @throws Exception
     */
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "hum")
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})   
    public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {

        if(paramList != null)   {
            List<Map> insertList = null;
            List<Map> updateList = null;
            List<Map> deleteList = null;
            for(Map dataListMap: paramList) {
                if(dataListMap.get("method").equals("deleteDetail")) {
                    deleteList = (List<Map>)dataListMap.get("data");
                }else if(dataListMap.get("method").equals("insertDetail")) {        
                    insertList = (List<Map>)dataListMap.get("data");
                } else if(dataListMap.get("method").equals("updateDetail")) {
                    updateList = (List<Map>)dataListMap.get("data");    
                } 
            }           
            if(deleteList != null) this.deleteDetail(deleteList, user);
            if(insertList != null) this.insertDetail(insertList, user);
            if(updateList != null) this.updateDetail(updateList, user);             
        }
        paramList.add(0, paramMaster);
                
        return  paramList;
    }
    
    /**
     * Detail 입력
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hum")
    public Integer  insertDetail(List<Map> paramList, LoginVO user) throws Exception {      
        try {
            for(Map param : paramList ) {
                super.commonDao.update("ssu100ukrvServiceImpl.insertDetail", param);
            }
        }catch(Exception e){
            throw new  UniDirectValidateException(this.getMessage("2627", user));
        }       
        return 0;
    }   
    
    /**
     * Detail 수정
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hum")
    public Integer updateDetail(List<Map> paramList, LoginVO user) throws Exception {       
         for(Map param :paramList ) {
             super.commonDao.update("ssu100ukrvServiceImpl.updateDetail", param);
         }       
         return 0;
    } 
    
    /**
     * Detail 삭제
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(group = "hum", needsModificatinAuth = true)
    public Integer deleteDetail(List<Map> paramList,  LoginVO user) throws Exception {
         for(Map param :paramList ) {
             
//             Map deletableMap = (Map) super.commonDao.select("ssu100ukrvServiceImpl.deletableCheck", param);     //수불내역 있는지 확인 있으면 삭제 불가..
//             if(ObjUtils.parseInt(deletableMap.get("CNT1")) > 0 ||
//                ObjUtils.parseInt(deletableMap.get("CNT2")) > 0 ||
//                ObjUtils.parseInt(deletableMap.get("CNT3")) > 0 ||
//                ObjUtils.parseInt(deletableMap.get("CNT4")) > 0 ||
//                ObjUtils.parseInt(deletableMap.get("CNT5")) > 0 ||
//                ObjUtils.parseInt(deletableMap.get("CNT6")) > 0 ||
//                ObjUtils.parseInt(deletableMap.get("CNT7")) > 0 ){
//                 throw new  UniDirectValidateException(this.getMessage("55305",user) + "\n계정코드: " + param.get("ACCNT"));                     
//             }else{
//                 super.commonDao.delete("ssu100ukrvServiceImpl.deleteDetail", param);
//             }
             super.commonDao.delete("ssu100ukrvServiceImpl.deleteDetail", param);
         }
         return 0;
    }
	
}
