package foren.unilite.modules.z_mit;

import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.digester.Digester;
import org.apache.commons.digester.xmlrules.DigesterLoader;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.joda.time.DateTime;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.type.TypeFactory;

import foren.framework.lib.XMLDigester;
import foren.framework.lib.calendar.LazyDate;
import foren.framework.model.FileInfoVO;
import foren.framework.utils.ConfigUtil;
import foren.framework.utils.FileUtil;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.excel.ExcelUploadException;
import foren.unilite.com.excel.ForenExcelServiceImpl;
import foren.unilite.com.excel.support.ExcelUtil;
import foren.unilite.com.excel.vo.ExcelUploadFieldVO;
import foren.unilite.com.excel.vo.ExcelUploadResult;
import foren.unilite.com.excel.vo.ExcelUploadSheetVO;
import foren.unilite.com.excel.vo.ExcelUploadWorkBookVO;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.TlabFormValidatorService;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.com.validator.ValidateResult;


// TODO: Auto-generated Javadoc
/**
 * The Class ForenExcelServiceImpl.
 *
 * @author SangJoon Kim
 * @version 1.0
 * @since Aug 3, 2012
 * <pre>
 *    Date                Changer         Comment
 *  ===========    =========    ===========================
 *  Aug 3, 2012 by SangJoon Kim: initial version
 * </pre>
 */
@Service("s_extDB_ExcelUpload_mitService")
public class S_ExtDB_ForenExcel_mitServiceImpl extends TlabAbstractServiceImpl   {
    
	private final Logger	logger		= LoggerFactory.getLogger(this.getClass());
	
	@Resource(name = "forenExcelUploadService")
	ForenExcelServiceImpl forenExcelUploadService;
	
   
	@Resource( name = "externalDAO_MIT" )
	 protected ExternalDAO_MIT externalDAO;
	
    /**
     * Parses the uploaded excel for Exteral DataBase .
     *  외부 DB 연동 엑셀업로드 data insert 
     *  
     * @param excelConfigName the excel config name
     * @param excelFile the excel file
     * @param param the param
     * @return the excel upload result
     * @throws ExcelUploadException the excel upload exception
     */
    public ExcelUploadResult parseUploadedExcel(String excelConfigName, MultipartFile excelFile, Map<String, Object> param ) throws ExcelUploadException {
        Workbook wb = null;
        ExcelUploadResult result = null;
        
        if (excelFile != null && !excelFile.isEmpty()) {
            logger.debug("File1 Name : " + excelFile.getName());
            logger.debug("File1 Bytes: " + excelFile.getSize());
            
            try{
                wb = forenExcelUploadService.loadFromStream(excelFile.getInputStream());
            }catch (Exception e) {
                logger.error(e.getMessage());
                //throw new  ExcelUploadException("Excel 파일로 올려주세요.");
                throw new  ExcelUploadException(e.getMessage());
            }

            try{
                String jobID = forenExcelUploadService.makeExcelJobID();
                param.put(forenExcelUploadService.EXCEL_JOBID, jobID);
                result  = forenExcelUploadService.parseWorkbook(wb, excelConfigName, param, true);
                result.setJobID(jobID);
                
                String[] sheets = result.getSheetNames();
                
                for(String sheetSeq : sheets) {
                    ExcelUploadSheetVO sheetConfig = result.getConfig().getSheetInfo(ObjUtils.parseInt(sheetSeq));
                    List<Map<String, Object>> records =  result.getSheetData(sheetSeq);
                    for(Map<String, Object> record : records) {
                        String sqlID = sheetConfig.getSqlId();
                        if(ObjUtils.isNotEmpty(sqlID)) {
                        	StringBuilder errorMessage = new  StringBuilder("");
                        	externalDAO.update(sheetConfig.getSqlId(), record, errorMessage);
                        	if(ObjUtils.isNotEmpty(errorMessage))	{
                        		throw new	UniDirectValidateException(errorMessage.toString());
                        	}
                        } else {
                            logger.debug("Data:{}", record);
                        }
                    }
                }
                
                ExcelUploadWorkBookVO config = forenExcelUploadService.getExcelConfig(excelConfigName);
                String validateServiceID = config.getValidateService();
                if(ObjUtils.isNotEmpty(validateServiceID)) {
                    String[] names = validateServiceID.split("\\.");
                    if(names.length > 0) {
                        Object obj = ObjUtils.getBean(names[0]);
                        Class c = obj.getClass();  
                        Class[] argTypes = new Class[] { String.class, Map.class };
                        Method main = c.getDeclaredMethod(names[1], argTypes);
                        
                        main.invoke(obj, jobID, param);
                        
                        logger.debug("serviceID : {} / {}", names[0], names[1]);
                    } else {
                        throw new Exception ("Can not find "+ validateServiceID+" service.!!!");
                    }
                }
                
                
                logger.debug("Errors:{}", result.getValidateResults());
            }catch (Exception e) {
                logger.error("Exception: {}",e);
                throw new  ExcelUploadException(e.getMessage());
            }
        }
        return result;
    }
    
}
