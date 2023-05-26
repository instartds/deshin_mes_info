package foren.unilite.modules.equip.equ;

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


@Service("equ270skrvService")
public class Equ270skrvServiceImpl extends TlabAbstractServiceImpl {
        private final Logger    logger  = LoggerFactory.getLogger(this.getClass());
    
        Map itemCode = new HashMap();
        @Resource(name = "fileMnagerService")
        private FileMnagerService fileMnagerService;
        
        /**
    	 * 이미지리스트 
    	 * @param param
    	 * @return
    	 * @throws Exception
    	 */
    	@ExtDirectMethod(group = "equit", value = ExtDirectMethodType.STORE_READ)
    	public List<Map<String, Object>> imagesList(Map param) throws Exception {
    		return super.commonDao.list("equ270skrvService.imagesList", param);
    	}
    	
        /**
    	 * 파일 조회
    	 * @param param
    	 * @return
    	 * @throws Exception
    	 */
    	@ExtDirectMethod( group = "equip", value = ExtDirectMethodType.STORE_READ )
    	public List<Map<String, Object>> getEquInfo( Map param ) throws Exception {
    		return super.commonDao.list("equ270skrvService.getEquInfo", param);
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
            return super.commonDao.list("equ270skrvService.selectList", param);
        }
        
        /**
         *  저장
         * 
         * @param param
         * @return
         * @throws Exception
         */
        @ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "prodt")
        @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})   
        public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
            itemCode = null;
            Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
            String addFid = dataMaster.get("ADD_FID").toString();
            String delFid = dataMaster.get("DEL_FID").toString();
            if(paramList != null)   {
                List<Map> updateList = null;
                for(Map dataListMap: paramList) {
                    if(dataListMap.get("method").equals("updateList")) {
                        updateList = (List<Map>)dataListMap.get("data");    
                    } 
                }
                if(updateList != null) this.updateList(updateList, user, addFid, delFid);   
            }
            if(!ObjUtils.isEmpty(itemCode)){
                dataMaster.put("ITEM_CODE", itemCode.get("ITEM_CODE"));           
            }
            
            paramList.add(0, paramMaster);
                    
            return  paramList;
        }
        
        @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")          // UPDATE
        public Integer updateList(List<Map> paramList, LoginVO user, String addFid, String delFid) throws Exception {
            Map compCodeMap = new HashMap();
            for(Map param :paramList ) {  
                param.put("ADD_FIDS", addFid);
                param.put("DEL_FIDS", delFid);
                this.deleteBDC101(param);
                fileMnagerService.deleteFile(user, ObjUtils.getSafeString(param.get("DEL_FIDS")));
                this.insertBDC101(param);
                String itemCode = (String)super.commonDao.select("equ270skrvService.insertCheck", param);
                if(!ObjUtils.isEmpty(itemCode)) {
                    super.commonDao.update("equ270skrvService.updateList", param);
                } else {
                    super.commonDao.insert("equ270skrvService.insertList", param);
                }
            }
            return 0;
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
            return super.commonDao.list("equ270skrvService.getFileList", param);
        }
        
        private void insertBDC101(Map param) throws Exception {
             String[] fids =  ObjUtils.getSafeString(param.get("ADD_FIDS")).split(",");      
             for(String fid : fids) {
                 param.put("FID", fid);
                 super.commonDao.insert("equ270skrvService.insertBDC101", param);
             }
        }
        
        private void deleteBDC101(Map param) throws Exception {
            String[] fids =  ObjUtils.getSafeString(param.get("DEL_FIDS")).split(",");
             for(String fid : fids) {
                 param.put("FID", fid);
                 super.commonDao.update("equ270skrvService.deleteBDC101", param);
             }
        }
}
