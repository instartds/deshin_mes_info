package foren.unilite.modules.base.bpr;

import java.io.File;
import java.io.FileOutputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;

import com.fasterxml.jackson.databind.ObjectMapper;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.lib.XMLDigester;
import foren.framework.lib.tree.GenericTreeDataMap;
import foren.framework.lib.tree.GenericTreeNode;
import foren.framework.model.LoginVO;
import foren.framework.utils.ConfigUtil;
import foren.framework.utils.FileUtil;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.code.CodeDetailVO;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.com.excel.support.ExcelUtil;
import foren.unilite.com.excel.vo.ExcelDownloadFieldVO;
import foren.unilite.com.excel.vo.ExcelDownloadSheetVO;
import foren.unilite.com.excel.vo.ExcelDownloadWorkBookVO;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.service.impl.TlabCodeService;
import foren.unilite.com.tags.ComboItemModel;
import foren.unilite.com.tags.ComboService;
import foren.unilite.modules.com.tree.UniTreeHelper;
import foren.unilite.modules.com.tree.UniTreeNode;

@Service("bpr581skrvService")
public class Bpr581skrvServiceImpl  extends TlabAbstractServiceImpl {

	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@ExtDirectMethod(group = "base", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList2(Map param) throws Exception {
		logger.debug("[[param::::]]"+param);
		return super.commonDao.list("bpr581skrvServiceImpl.selectList2", param);
	}
	/**
	 * 제조BOM 조회
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "base", value = ExtDirectMethodType.STORE_READ)
	public Object selectMaster(Map param) throws Exception {
		return super.commonDao.select("bpr581skrvServiceImpl.selectMaster", param);
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "base")
	public UniTreeNode selectList(Map param, LoginVO user) throws Exception {


		List<GenericTreeDataMap> treeList = new ArrayList<GenericTreeDataMap>();

		if("0".equals(param.get("OPTSEL"))){

			treeList  = super.commonDao.list("bpr581skrvServiceImpl.selectList_new", param);
			/*GenericTreeDataMap treeMap = (GenericTreeDataMap) super.commonDao.select("bpr581skrvServiceImpl.selectList", param);

			//ITEM_LVL
			if(treeMap != null){
				treeList.add(treeMap);
				param.put("ITEM_CODE", treeMap.get("ITEM_CODE"));
				param.put("parentId", treeMap.get("id"));
				getChildren(param,treeList);
			}*/
		}else{
			GenericTreeDataMap treeMap = (GenericTreeDataMap) super.commonDao.select("bpr581skrvServiceImpl.selectList1", param);
			if(treeMap != null){
				treeList.add(treeMap);
				param.put("PROD_ITEM_CODE", treeMap.get("PROD_ITEM_CODE"));
				param.put("CHILD_ITEM_CODE", treeMap.get("ITEM_CODE"));
				param.put("ROOT_ITEM_CODE", treeMap.get("id"));
				param.put("INTENS_Q", 1);
				getParent(param,treeList);
			}
		}


		return  UniTreeHelper.makeTreeAndGetRootNode(treeList);
	}

	private void getParent(Map param, List<GenericTreeDataMap> treeList) {
		List<GenericTreeDataMap> treeParentList = super.commonDao.list("bpr581skrvServiceImpl.getParent", param);
		if(treeParentList == null || treeParentList.size() == 0){
			treeParentList = super.commonDao.list("bpr581skrvServiceImpl.getParent1", param);
			for(GenericTreeDataMap treeMap1 : treeParentList){
				treeList.add(treeMap1);
			}
			treeParentList = null;
		}
		if(treeParentList != null && treeParentList.size()>0){
			for(GenericTreeDataMap treeMap : treeParentList){

				treeList.add(treeMap);
				param.put("PROD_ITEM_CODE", treeMap.get("PROD_ITEM_CODE"));
				param.put("CHILD_ITEM_CODE", treeMap.get("ITEM_CODE"));
				param.put("INTENS_Q", treeMap.get("INTENS_Q"));
				getParent(param,treeList);
			}
		}


	}

	public void getChildren(Map param, List<GenericTreeDataMap> treeList){
		List<GenericTreeDataMap> treeChildrenList = super.commonDao.list("bpr581skrvServiceImpl.getChildren", param);
		if(treeChildrenList != null && treeChildrenList.size()>0){
			for(GenericTreeDataMap treeMap : treeChildrenList){
				treeList.add(treeMap);

				param.put("ITEM_CODE", treeMap.get("ITEM_CODE"));
				param.put("INTENS_Q", treeMap.get("INTENS_Q"));
				param.put("parentId", treeMap.get("id"));
				getChildren(param,treeList);

				param.put("INTENS_Q", treeMap.get("INTENS_Q"));
				param.put("ITEM_CODE", treeMap.get("ITEM_CODE"));
				param.put("PROD_ITEM_CODE", treeMap.get("PROD_ITEM_CODE"));
				//param.put("parentId", treeMap.get("id"));
				getSubstitute(param,treeList);
			}
		}

	}

	public void getSubstitute(Map param, List<GenericTreeDataMap> treeList){
		List<GenericTreeDataMap> treeChildrenList = super.commonDao.list("bpr581skrvServiceImpl.getSubstitute", param);
		if(treeChildrenList != null && treeChildrenList.size()>0){
			for(GenericTreeDataMap treeMap : treeChildrenList){
				treeList.add(treeMap);
			}
		}
	}

	@ExtDirectMethod(group = "base", value = ExtDirectMethodType.STORE_READ)
	public Object chekCompCode(Map param) throws Exception {
		return super.commonDao.select("bpr581skrvServiceImpl.chekCompCode", param);
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "base")
	public List<GenericTreeDataMap> selectListForExcel(Map param, LoginVO user) throws Exception {
		List<GenericTreeDataMap> treeList = new ArrayList<GenericTreeDataMap>();
		if("0".equals(param.get("OPTSEL"))){

			treeList  = super.commonDao.list("bpr581skrvServiceImpl.selectList_new", param);
		}
		return treeList;
	}
	private Map<String, ExcelDownloadWorkBookVO> excelConfigMap = new HashMap<String, ExcelDownloadWorkBookVO>();
    private final static String CONFIG_FILE_PATH = FileUtil.getAbsoluteFileName("classpath:/foren/conf/excel/");
    private final static String DIGESTER_FILE_NAME = CONFIG_FILE_PATH + "excelDownloadDigestRules.xml";


	@Resource(name="tlabCodeService")
	private TlabCodeService tlabCodeService;

	@Resource(name="UniliteComboServiceImpl")
	private ComboService comboService;

    private void configure(String data, String pgmId) {
        ExcelDownloadWorkBookVO workBook = null ;
        try {
        	File input = new File(ConfigUtil.getUploadBasePath("ExcelDownload")  +"/"+pgmId+".xml");
        	logger.debug("####  ConfigUtil.getUploadBasePath(ExcelDownload)  +pgmId+.xml  : "+ConfigUtil.getUploadBasePath("ExcelDownload")  +"/"+pgmId+".xml");
        	FileOutputStream fos = new FileOutputStream(input);
        	byte[] bytesArray = data.getBytes("UTF-8");
        	fos.write(bytesArray);
        	fos.flush();
        	fos.close();

        	String dtdFile = DIGESTER_FILE_NAME;

        	if(ObjUtils.isNotEmpty(System.getProperty("jboss.home.dir")))	{
        		dtdFile = ConfigUtil.getUploadBasePath("ExcelDownload")+"/dtd/excelDownloadDigestRules.xml";
        	}
            workBook = (ExcelDownloadWorkBookVO) XMLDigester.digest(ConfigUtil.getUploadBasePath("ExcelDownload")  +"/"+pgmId+".xml", dtdFile);
            if (workBook != null) {
                 logger.debug("===" + workBook.getName());

                excelConfigMap.put(workBook.getName(), workBook);
            } else {
                logger.debug("Can not get download Excel config (pgmId : " + pgmId +")");
            }
        } catch (Exception e) {
            logger.error("[" + pgmId + "] Download Excel Configuration Error !!!\n" + e.getMessage());
        }
    }

   /* private List<Map<String, Object>> execService(String serviceName, Map<String, Object> param )	{
    	return   super.commonDao.list(serviceName, param);
    }*/

    public SXSSFWorkbook genWorkBook(String data, String pgmId, Map<String, Object> param,  UniTreeNode recordList, LoginVO loginVO) throws Exception  {

    	configure(data, pgmId);
        ExcelDownloadWorkBookVO config = excelConfigMap.get(pgmId);

        SXSSFWorkbook wb = ExcelUtil.createSXSSFWorkbook();
        int rowIdx =0;

        if (config != null ) {

            for (ExcelDownloadSheetVO sheetVO : config.getSheetList()) {
            	logger.debug( " >> " + sheetVO.getName());


                Sheet sheet = wb.createSheet(sheetVO.getName());

                // Create a row and put some cells in it. Rows are 0 based.
                rowIdx =0;

                List<ExcelDownloadFieldVO> fieldList = sheetVO.getFieldList();

            	//Excel Title
                if(!ObjUtils.parseBoolean(param.get("onlyData"), false))	{
	                sheet.addMergedRegion(new CellRangeAddress(0,1,0,(fieldList.size()-1)));

	            	Row rowTitle = sheet.createRow(rowIdx++);
	            	Cell titleCell = rowTitle.createCell(0);
	            	ExcelUtil.setTitleCell(wb, sheet, titleCell, sheetVO.getName());
	            	rowIdx ++;
            	}

            	//Excel Header and column style
                Row rowHeader = sheet.createRow(rowIdx++);
                logger.debug("###################   set title " );
                for(ExcelDownloadFieldVO field : fieldList ) {
                	//Excel Header
                	//if(!ObjUtils.parseBoolean(param.get("onlyData"), false))	{
                		Cell cell = rowHeader.createCell(field.getCol());
                		ExcelUtil.setHeaderCell(wb,sheet,cell,field);
                	//}
                    sheet.setColumnWidth(field.getCol(), field.getWidth()*40);
                    field.setStyle(ExcelUtil.setDataStyleCell(wb, field));
                    if(field.getComboData() != null)	{
                    	String comboData = ObjUtils.getSafeString(field.getComboData() );
                    	comboData = comboData.replaceAll("\'", "\"");
	                    ObjectMapper mapper = new ObjectMapper();
	                	Map dataList = mapper.readValue( ObjUtils.getSafeString(comboData), Map.class);
	                	field.setComboDataList(dataList);
                    }
                    if(field.getComboType()!=null && !"AU".equals(field.getComboType()))	{
                    	List<ComboItemModel> comboList = comboService.getComboList(field.getComboType(), field.getComboCode(),  loginVO,  param, null, Boolean.parseBoolean(field.getIncludeMainCode()));
                    	Map dataList = new HashMap();
                    	for(ComboItemModel model : comboList)	{
                    		dataList.put(model.getValue(), model.getText());
                    	}
                    	field.setComboDataList(dataList);
                    }
                }

                CodeInfo codeInfo = tlabCodeService.getCodeInfo(ObjUtils.getSafeString(param.get("S_COMP_CODE")));
                logger.debug("###################   start data cell" );

                if(recordList != null) {
                	if(recordList.hasChildren())	{
                		rowIdx = makeChildrenRows( recordList,  wb,  sheet,  rowIdx, fieldList,  codeInfo);
                    }
                    /*for(int i=0; i < recordList.getNumberOfChildren() ; i++) {
                    	GenericTreeNode<GenericTreeDataMap> node = recordList.getChildAt(i);
                		GenericTreeDataMap record = node.getData();

                    }*/
                	/*
                	 // public SXSSFWorkbook genWorkBook(String data, String pgmId, Map<String, Object> param,  List<GenericTreeDataMap> recordList, LoginVO loginVO)
                	for(GenericTreeDataMap record : recordList) {

                        Row rowSample = sheet.createRow(rowIdx++);
                        for(ExcelDownloadFieldVO field : fieldList ) {

                            Cell cell = rowSample.createCell(field.getCol());
                            String value = ObjUtils.getSafeString(record.get(field.getName()));

                            if(field.getComboCode() != null)	{

                            	CodeDetailVO cdo = codeInfo.getCodeInfo(field.getComboCode(), value);
                            	if(cdo != null) {
                            		value = cdo.getCodeName();
                            	}
                            }
                            if(field.getComboDataList() != null)	{
                            	value = ObjUtils.nvl(field.getComboDataList().get(value), value);
                            }
                            //cell.setCellValue(value);


                            ExcelUtil.setDataCell2(wb,cell,field, value);
                            cell.setCellStyle(field.getStyle());
                            cell.setCellType(field.getCellType());
                        }


                    }*/

                }
                logger.debug("###################   end data cell" );

            }
        } else {
            logger.error(" Excel Config : {} is null or data is null ", pgmId );
        }

        return wb;
    }

    private int makeChildrenRows(GenericTreeNode<GenericTreeDataMap> nodeList, SXSSFWorkbook wb, Sheet sheet, int rowIdx, List<ExcelDownloadFieldVO> fieldList, CodeInfo codeInfo) throws Exception 	{

    	for(int i=0; i < nodeList.getNumberOfChildren() ; i++) {
        	GenericTreeNode<GenericTreeDataMap> node = nodeList.getChildAt(i);
        	GenericTreeDataMap record = node.getData();
        	Row rowSample = sheet.createRow(rowIdx);
        	rowIdx = rowIdx+1;

            for(ExcelDownloadFieldVO field : fieldList ) {
            	logger.debug("###################   field Name "+i+" : "+field.getName()+" /"+ ObjUtils.getSafeString(record.get(field.getName())));
                Cell cell = rowSample.createCell(field.getCol());
                String value = "";
                if("ITEM_CODE".equals(field.getName()))	{
                	if(record.get("LVL") != null && ObjUtils.parseInt(record.get("LVL")) > 1)	{
                		for(int j=0; j < ObjUtils.parseInt(record.get("LVL")) ; j++)	{
                			value +="    ";
                		}
                	}
                	value += ObjUtils.getSafeString(record.get(field.getName()));
                }else {
                	value = ObjUtils.getSafeString(record.get(field.getName()));
                }
                if(field.getComboCode() != null)	{

                	CodeDetailVO cdo = codeInfo.getCodeInfo(field.getComboCode(), value);
                	if(cdo != null) {
                		value = cdo.getCodeName();
                	}
                }
                if(field.getComboDataList() != null)	{
                	value = ObjUtils.nvl(field.getComboDataList().get(value), value);
                }
                //cell.setCellValue(value);


                ExcelUtil.setDataCell2(wb,cell,field, value);
                cell.setCellStyle(field.getStyle());
                cell.setCellType(field.getCellType());
            }
            if(node.hasChildren())	{
            	rowIdx = makeChildrenRows( node,  wb,  sheet,  rowIdx, fieldList,  codeInfo);
            }

        }


    	return rowIdx;
    }
}
