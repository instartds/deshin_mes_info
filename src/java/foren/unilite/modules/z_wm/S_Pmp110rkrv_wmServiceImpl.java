package foren.unilite.modules.z_wm;

import java.io.File;
import java.io.FileInputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFFormulaEvaluator;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.DataFormat;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ConfigUtil;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.service.impl.TlabCodeService;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.utils.AES256DecryptoUtils;


@Service("s_pmp110rkrv_wmService")
@SuppressWarnings({"rawtypes", "unchecked"})
public class S_Pmp110rkrv_wmServiceImpl extends TlabAbstractServiceImpl  {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	//20201112 추가: 주소정제 데이터 가져오기 위해 추가
	@Resource(name = "externalDAO_JUSO_WM")
	protected ExternalDAO_JUSO_WM extDaoJuso;


	/**
	 * 작업지시등록 데이터 조회
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sales")
	public List<Map> selectList(Map param, LoginVO user) throws Exception {
		return super.commonDao.list("s_pmp110rkrv_wmServiceImpl.selectList", param);
	}



	/** SOF110T.SERVICE_NO 저장로직 - 20210324 추가
	 * @param params
	 * @param user
	 * @param dataMaster
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");

		if(paramList != null) {
			List<Map> updateDetail = null;

			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("updateDetail")) {
					updateDetail = (List<Map>)dataListMap.get("data");
				}
			}
			if(updateDetail != null) this.updateDetail(updateDetail, user, dataMaster);
		}
		paramList.add(0, paramMaster);
		return paramList;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")
	public Integer updateDetail(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {
		for(Map param :paramList) {
			super.commonDao.update("s_pmp110rkrv_wmServiceImpl.updateDetail", param);
		}
		return 0;
	}





	/**
	 * 작업지시서 출력
	 * @param paramList
	 * @param user
	 * @param paramMaster
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "z_wm", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> printMasterData(Map param) throws Exception {
		return super.commonDao.list("s_pmp110rkrv_wmServiceImpl.printMasterData", param);
	}

	@ExtDirectMethod(group = "z_wm", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> printDetailData(Map param) throws Exception {
		return super.commonDao.list("s_pmp110rkrv_wmServiceImpl.printDetailData", param);
	}

	/**
	 * 작업지시서 출력 후, 상태값 변경(PMP100T.TEMPC_01)
	 * @param params
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "z_wm", value = ExtDirectMethodType.STORE_MODIFY)
	public int updatePrintStatus(Map param, LoginVO user) throws Exception {
		String[] workOrderInfoArry	= param.get("workOrderInfo").toString().split(",");
		List<Map> workOrderInfoList	= new ArrayList<Map>();

		for(int i=0; i<ObjUtils.parseInt(param.get("dataCount")); i++){
			Map map = new HashMap();
			map.put("WORK_ORDER_INFO", workOrderInfoArry[i]);
			workOrderInfoList.add(map);
		}
		param.put("WORK_ORDER_LIST", workOrderInfoList);
		super.commonDao.update("s_pmp110rkrv_wmServiceImpl.updatePrintStatus", param);
		return 0;
	}





	/**
	 * 라벨 출력 - 20201102 추가
	 * @param paramList
	 * @param user
	 * @param paramMaster
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "z_wm", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> printLabelData(Map param) throws Exception {
		return super.commonDao.list("s_pmp110rkrv_wmServiceImpl.printLabelData", param);
	}





	/**
	 * 운송장 출력 - 20201112, 20201123 추가
	 * @param paramList
	 * @param user
	 * @param paramMaster
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "z_wm", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> getData(Map param) throws Exception {
		return super.commonDao.list("s_pmp110rkrv_wmServiceImpl.getData", param);
	}

	@ExtDirectMethod(group = "z_wm", value = ExtDirectMethodType.STORE_READ)
	public Map<String, Object> printCarriageBillData(Map param) throws Exception {
		return extDaoJuso.procExec("s_pmp110rkrv_wmServiceImpl.printCarriageBillData", param);
	}





	/**
	 * 바른서비스 엑셀 다운로드 - 20210322 추가
	 * @param paramList
	 * @param user
	 * @param paramMaster
	 * @return
	 * @throws Exception
	 */
	public Workbook makeExcel( Map param ) throws Exception {
		String keyValue			= getLogKey();
		FileInputStream file	= new FileInputStream(new File(ConfigUtil.getUploadBasePath("ExcelFrame") + File.separatorChar + "s_BARUN_erp_WM.xlsx"));
		Workbook workbook		= new XSSFWorkbook(file);		//Get the workbook instance for XLS file
		Sheet sheet1			= workbook.getSheetAt(0);		//Get first sheet from the workbook

		//각 상품의 옵션정보를 임시테이블에 insert
		String[] workOrderInfoArry	= param.get("workOrderInfo").toString().split(",");
		List<Map> workOrderInfoList	= new ArrayList<Map>();
		for(int i=0; i<ObjUtils.parseInt(param.get("dataCount")); i++){
			int j	= 0;
			Map map	= new HashMap();
			map.put("COMP_CODE"			, param.get("S_COMP_CODE"));
			map.put("DIV_CODE"			, param.get("DIV_CODE"));
			map.put("WORK_ORDER_INFO"	, workOrderInfoArry[i]);
			workOrderInfoList.add(map);
			List<Map> baseDataList = super.commonDao.list("s_pmp110rkrv_wmServiceImpl.getBaseData", map);
			for(Map baseData: baseDataList){
				map.put("KEY_VALUE"			, keyValue);
				map.put("WKORD_NUM"			, baseData.get("WKORD_NUM"));
				map.put("ITEM_NAME"	+ (j+1)	, baseData.get("ITEM_NAME"));
				map.put("ALLOCK_Q"	+ (j+1)	, baseData.get("ALLOCK_Q"));
				j++;
			}
			super.commonDao.update("s_pmp110rkrv_wmServiceImpl.makeBaseData", map);
		}

		param.put("KEY_VALUE"		, keyValue);
		param.put("WORK_ORDER_LIST"	, workOrderInfoList);
		List<Map> list1 = super.commonDao.list("s_pmp110rkrv_wmServiceImpl.makeExcel", param);
		for(int i = 0; i < list1.size(); i++) {
			sheet1.getRow(i+1).getCell(0).setCellValue(list1.get(i).get("SERVICE_NO").toString());
			sheet1.getRow(i+1).getCell(1).setCellValue(list1.get(i).get("RECEIVER_NAME").toString());
			sheet1.getRow(i+1).getCell(2).setCellValue(list1.get(i).get("HANDPHONE_NUM").toString());
			sheet1.getRow(i+1).getCell(3).setCellValue(list1.get(i).get("TELEPHONE_NUM").toString());
			sheet1.getRow(i+1).getCell(4).setCellValue(list1.get(i).get("ZIP_NUM").toString());
			sheet1.getRow(i+1).getCell(5).setCellValue(list1.get(i).get("ADDRESS1").toString());
			sheet1.getRow(i+1).getCell(6).setCellValue(list1.get(i).get("ADDRESS2").toString());
			sheet1.getRow(i+1).getCell(7).setCellValue(list1.get(i).get("EMAIL").toString());
			sheet1.getRow(i+1).getCell(8).setCellValue(list1.get(i).get("MODEL_NAME").toString());
			sheet1.getRow(i+1).getCell(9).setCellValue(list1.get(i).get("ITEM_NAME1").toString());
			sheet1.getRow(i+1).getCell(10).setCellValue(list1.get(i).get("ALLOCK_Q1").toString());
			sheet1.getRow(i+1).getCell(11).setCellValue(list1.get(i).get("ITEM_NAME2").toString());
			sheet1.getRow(i+1).getCell(12).setCellValue(list1.get(i).get("ALLOCK_Q2").toString());
			sheet1.getRow(i+1).getCell(13).setCellValue(list1.get(i).get("ITEM_NAME3").toString());
			sheet1.getRow(i+1).getCell(14).setCellValue(list1.get(i).get("ALLOCK_Q3").toString());
			sheet1.getRow(i+1).getCell(15).setCellValue(list1.get(i).get("ITEM_NAME4").toString());
			sheet1.getRow(i+1).getCell(16).setCellValue(list1.get(i).get("ALLOCK_Q4").toString());
			sheet1.getRow(i+1).getCell(17).setCellValue(list1.get(i).get("ITEM_NAME5").toString());
			sheet1.getRow(i+1).getCell(18).setCellValue(list1.get(i).get("ALLOCK_Q5").toString());
			sheet1.getRow(i+1).getCell(19).setCellValue(list1.get(i).get("ITEM_NAME6").toString());
			sheet1.getRow(i+1).getCell(20).setCellValue(list1.get(i).get("ALLOCK_Q6").toString());
			sheet1.getRow(i+1).getCell(21).setCellValue(list1.get(i).get("ITEM_NAME7").toString());
			sheet1.getRow(i+1).getCell(22).setCellValue(list1.get(i).get("ALLOCK_Q7").toString());
			sheet1.getRow(i+1).getCell(23).setCellValue(list1.get(i).get("ITEM_NAME8").toString());
			sheet1.getRow(i+1).getCell(24).setCellValue(list1.get(i).get("ALLOCK_Q8").toString());
			sheet1.getRow(i+1).getCell(25).setCellValue(list1.get(i).get("ITEM_NAME9").toString());
			sheet1.getRow(i+1).getCell(26).setCellValue(list1.get(i).get("ALLOCK_Q9").toString());
			sheet1.getRow(i+1).getCell(27).setCellValue(list1.get(i).get("ITEM_NAME10").toString());
			sheet1.getRow(i+1).getCell(28).setCellValue(list1.get(i).get("ALLOCK_Q10").toString());
			sheet1.getRow(i+1).getCell(29).setCellValue(list1.get(i).get("ITEM_NAME11").toString());
			sheet1.getRow(i+1).getCell(30).setCellValue(list1.get(i).get("ALLOCK_Q11").toString());
			sheet1.getRow(i+1).getCell(31).setCellValue(list1.get(i).get("ITEM_NAME12").toString());
			sheet1.getRow(i+1).getCell(32).setCellValue(list1.get(i).get("ALLOCK_Q12").toString());
			sheet1.getRow(i+1).getCell(33).setCellValue(list1.get(i).get("ITEM_NAME13").toString());
			sheet1.getRow(i+1).getCell(34).setCellValue(list1.get(i).get("ALLOCK_Q13").toString());
			sheet1.getRow(i+1).getCell(35).setCellValue(list1.get(i).get("ITEM_NAME14").toString());
			sheet1.getRow(i+1).getCell(36).setCellValue(list1.get(i).get("ALLOCK_Q14").toString());
			sheet1.getRow(i+1).getCell(37).setCellValue(list1.get(i).get("ITEM_NAME15").toString());
			sheet1.getRow(i+1).getCell(38).setCellValue(list1.get(i).get("ALLOCK_Q15").toString());
			sheet1.getRow(i+1).getCell(39).setCellValue(list1.get(i).get("ITEM_NAME16").toString());
			sheet1.getRow(i+1).getCell(40).setCellValue(list1.get(i).get("ALLOCK_Q16").toString());
			sheet1.getRow(i+1).getCell(41).setCellValue(list1.get(i).get("ITEM_NAME17").toString());
			sheet1.getRow(i+1).getCell(42).setCellValue(list1.get(i).get("ALLOCK_Q17").toString());
			sheet1.getRow(i+1).getCell(43).setCellValue(list1.get(i).get("ITEM_NAME18").toString());
			sheet1.getRow(i+1).getCell(44).setCellValue(list1.get(i).get("ALLOCK_Q18").toString());
			sheet1.getRow(i+1).getCell(45).setCellValue(list1.get(i).get("ITEM_NAME19").toString());
			sheet1.getRow(i+1).getCell(46).setCellValue(list1.get(i).get("ALLOCK_Q19").toString());
			sheet1.getRow(i+1).getCell(47).setCellValue(list1.get(i).get("ITEM_NAME20").toString());
			sheet1.getRow(i+1).getCell(48).setCellValue(list1.get(i).get("ALLOCK_Q20").toString());
//			HSSFFormulaEvaluator.evaluateAllFormulaCells(workbook);		의 계산식 사용
		}
		return workbook;
	}
}