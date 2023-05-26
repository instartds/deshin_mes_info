package test;

import java.io.FileOutputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.ClientAnchor;
import org.apache.poi.ss.usermodel.Comment;
import org.apache.poi.ss.usermodel.CreationHelper;
import org.apache.poi.ss.usermodel.Drawing;
import org.apache.poi.ss.usermodel.RichTextString;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.ui.ModelMap;

import foren.framework.lib.fileupload.FileUploadModel;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.utils.MessageUtils;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.excel.ExcelUploadService;
import foren.unilite.com.excel.vo.ExcelUploadResult;
import foren.unilite.com.validator.TlabFormValidatorService;
import foren.unilite.com.validator.ValidateResult;
import foren.unilite.com.validator.support.ValidatorUtils;

public class ExcelUploadSampleServiceImpl {
	private static final Logger logger = LoggerFactory.getLogger(ExcelUploadSampleServiceImpl.class);
	@Resource(name = "forenExcelUploadService")
	private ExcelUploadService genExcel;
    @Resource(name = "tlabFormValidatorService")
    protected TlabFormValidatorService tlabFormValidatorService;
	
	public String sampleExcel(ExtHtttprequestParam _req, ModelMap model) throws Exception {
		String EXCEL_CONF_NAME = "cmExHouseBl"; 
		ExcelUploadResult result = null;		
		ValidateResult validator = new ValidateResult();
		List<Map<String,Object>> errList = new ArrayList<Map<String,Object>>();
		String errorMsg = null;
		Workbook wb = null;
		List<FileUploadModel> files = _req.getFiles("excelFile");
		if(!ObjUtils.isEmpty(files)) {
			FileUploadModel file = files.get(0);

			Map<String,Object> paramMap = new HashMap<String,Object>();
			try{
				wb = genExcel.loadFromStream(file.getInputStream());
			}catch (Exception e) {
				logger.error(e.getMessage());
				model.addAttribute("errorAlert", e.getMessage());
				return "cm/popup/popupExcelUpload";
			}
			
			try{
				result  = genExcel.parseWorkbook(wb, EXCEL_CONF_NAME, paramMap, true);
			}catch (Exception e) {
				e.printStackTrace();
				model.addAttribute("errorAlert",e.getMessage());
				return "cm/popup/popupExcelUpload";
			}
			
			List<Map<String,Object>> excelDataHbl = result.getSheetData("HouseBL");
			
			if(excelDataHbl != null){
				if(excelDataHbl.size() > 0){
					for(Map<String,Object> bl: excelDataHbl){

						if(!"TS".equals(bl.get("crgClass"))){
							bl.put("refDocNo", "TmpVal");
						}

						tlabFormValidatorService.validate("cmeExportManifestBl", validator, bl, 0, false);
					}


					if(validator.hasErrors()){
						errList = ValidatorUtils.submitValidErrMsg(validator, _req.getLocale());
						model.addAttribute("errList", errList);

						return "/cm/cme/manifest/Import/MasterManifest/selectValidateResultMrn";
					}else{
						ValidateResult resultValidator = null;
						try{
							//hbl insert, container insert
							//resultValidator = cmeHouseManifestService.uploadExcelItems(null,excelDataHbl, excelDataCntnr);
						}catch(Exception e){
							logger.error(e.getMessage());
							model.addAttribute("errorAlert",e.getMessage());
							return "cm/popup/popupExcelUpload";
						}

						if(resultValidator.hasErrors()){
							errList = ValidatorUtils.submitValidErrMsg(resultValidator, _req.getLocale());
							model.addAttribute("errList", errList);
							return "/cm/cme/manifest/Import/MasterManifest/selectValidateResultMrn";
						}else{
							model.addAttribute("isUpload","Y");
						}
					}
				}else{
					errorMsg = MessageUtils.getMessage("cm.msg.excel.noData", _req);
					model.addAttribute("isUpload", errorMsg);
					logger.error("no data");

				}
			}else{
				errorMsg = MessageUtils.getMessage("cm.msg.excel.nullData", _req);
				model.addAttribute("isUpload", errorMsg);
				logger.error("sheet data null");
			}
		}
		return null;
	}
	
	
	
	public void t1 () throws Exception {
	    Workbook wb = new XSSFWorkbook(); //or new HSSFWorkbook();

	    CreationHelper factory = wb.getCreationHelper();

	    Sheet sheet = wb.createSheet();
	    
	    Row row  = sheet.createRow(3);
	    Cell cell = row.createCell(5);
	    cell.setCellValue("F4");
	    
	    Drawing drawing = sheet.createDrawingPatriarch();

	    // When the comment box is visible, have it show in a 1x3 space
	    ClientAnchor anchor = factory.createClientAnchor();
	    anchor.setCol1(cell.getColumnIndex());
	    anchor.setCol2(cell.getColumnIndex()+1);
	    anchor.setRow1(row.getRowNum());
	    anchor.setRow2(row.getRowNum()+3);

	    // Create the comment and set the text+author
	    Comment comment = drawing.createCellComment(anchor);
	    RichTextString str = factory.createRichTextString("Hello, World!");
	    comment.setString(str);
	    comment.setAuthor("Apache POI");

	    // Assign the comment to the cell
	    cell.setCellComment(comment);

	    String fname = "comment-xssf.xls";
	    if(wb instanceof XSSFWorkbook) fname += "x";
	    FileOutputStream out = new FileOutputStream(fname);
	    wb.write(out);
	    out.close();
	}
}
