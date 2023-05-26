package foren.unilite.modules.z_kd;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ConfigUtil;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.utils.DevFreeUtils;
import foren.unilite.utils.ExtFileUtils;

@Service( "s_tpl200ukr_kdService" )
public class S_tpl200ukr_kdServiceImpl extends TlabAbstractServiceImpl {
    private final Logger logger = LoggerFactory.getLogger(this.getClass());
    
    /**
     * 그리드 조회
     * 
     * @param param
     * @param loginVO
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_READ, group = "template" )
    public List<Map<String, Object>> select( Map param, LoginVO loginVO ) throws Exception {
        logger.debug("FILE_ID :: {}", param.get("FILE_ID"));
        logger.debug("CSV_LOAD_YN :: {}", param.get("CSV_LOAD_YN"));
        
        if ("N".equals((String)param.get("CSV_LOAD_YN"))) {
            return (List)super.commonDao.list("s_tpl200ukr_kdServiceImpl.select", param);
        } else {
            String filePath = ConfigUtil.getString("common.upload.csv");
            String FILE_ID = (String)param.get("FILE_ID");
            String PGM_ID = (String)param.get("PGM_ID");
            String csvFile = filePath + FILE_ID + ".bin";
            
            logger.debug("csvFile :: {}", csvFile);
            
            // CSV 업로드를 위한 30개 컬럼 TEMPLATE 테이블
            super.commonDao.update("configService.createCSV30", null);
            
            FileReader fin = null;
            BufferedReader in = null;
            
            try {
                fin = new FileReader(csvFile);
                in = new BufferedReader(fin);
                
                Map<String, Object> iMap = null;
                
                String csvline = "";
                int row = 1;
                
                long start = System.currentTimeMillis();
                while (( csvline = in.readLine() ) != null) {
                    logger.debug("csvline :: {}", csvline);
                    if(csvline.trim().length() > 0) {
                        String[] cols = csvline.split(",");
                        logger.debug("cols.length :: {}", cols.length);
                        
                        iMap = new HashMap<String, Object>();
                        iMap.put("PGM_ID", PGM_ID);
                        iMap.put("FILE_ID", FILE_ID);
                        iMap.put("SEQ", row);
                        
                        for (int i = 0; i < cols.length; i++) {
                            iMap.put("COL" + DevFreeUtils.addZero("" + ( i + 1 ), 2), cols[i].replaceAll("\"", "").trim());
                        }
                        
                        logger.debug("iMap :: ", iMap);
                        super.commonDao.update("s_tpl200ukr_kdServiceImpl.insertCSV", iMap);
                        
                        row++;
                    }
                }
                long finish = System.currentTimeMillis();
                
                logger.debug("CSV 파일 읽은 시간 :: " + ( finish - start ) + "ms");
                
            } catch (IOException e) {
                e.printStackTrace();
            } finally {
                try {
                    if (in != null) in.close();
                    
                    logger.debug("임시파일삭제.... 시작");
                    ExtFileUtils.delFile(filePath + FILE_ID + ".bin");
                    ExtFileUtils.delFile(filePath + FILE_ID + ".txt");
                    logger.debug("임시파일삭제.... 종료");
                } catch (IOException ex) {
                    ex.printStackTrace();
                }
            }
            
            return (List)super.commonDao.list("s_tpl200ukr_kdServiceImpl.select", param);
        }
    }
    
    /**
     * 저장
     * 
     * @param paramList 리스트의 create, update, destroy 오퍼레이션별 정보
     * @param paramMaster 폼(마스터 정보)의 기본 정보
     * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_SYNCALL, group = "template" )
    @Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
    public List<Map> saveAll( List<Map> paramList, Map paramMaster, LoginVO user ) throws Exception {
        
        if (paramList != null) {
            List<Map> insertList = null;
            List<Map> updateList = null;
            List<Map> deleteList = null;
            for (Map dataListMap : paramList) {
                if (dataListMap.get("method").equals("delete")) {
                    deleteList = (List<Map>)dataListMap.get("data");
                } else if (dataListMap.get("method").equals("insert")) {
                    insertList = (List<Map>)dataListMap.get("data");
                } else if (dataListMap.get("method").equals("update")) {
                    updateList = (List<Map>)dataListMap.get("data");
                }
            }
            if (deleteList != null) this.delete(deleteList, user);
            if (insertList != null) this.insert(insertList, user);
            if (updateList != null) this.update(updateList, user);
        }
        paramList.add(0, paramMaster);
        
        return paramList;
    }
    
    /**
     * 삭제
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( group = "accnt", needsModificatinAuth = true )
    public Integer delete( List<Map> paramList, LoginVO user ) throws Exception {
        for (Map param : paramList) {
            try {
                super.commonDao.delete("templateServiceImpl.deleteDetail", param);
            } catch (Exception e) {
                throw new UniDirectValidateException(this.getMessage("547", user));//사용중인 코드는 삭제할 수 없습니다.
            }
        }
        return 0;
    }
    
    /**
     * 입력
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "accnt" )
    public Integer insert( List<Map> paramList, LoginVO user ) throws Exception {
        try {
            for (Map param : paramList) {
                super.commonDao.update("templateServiceImpl.insertDetail", param);
            }
        } catch (Exception e) {
            throw new UniDirectValidateException(this.getMessage("2627", user));//중복되는 자료가 입력 되었습니다.
        }
        return 0;
    }
    
    /**
     * 수정
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "accnt" )
    public Integer update( List<Map> paramList, LoginVO user ) throws Exception {
        for (Map param : paramList) {
            super.commonDao.update("templateServiceImpl.updateDetail", param);
        }
        return 0;
    }
    
}
