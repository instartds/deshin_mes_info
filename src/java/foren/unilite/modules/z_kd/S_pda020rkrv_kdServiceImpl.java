package foren.unilite.modules.z_kd;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.BindingResult;

import com.crystaldecisions.reports.common.StringUtil;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.service.impl.TlabMenuService;

import java.math.BigDecimal;

@Service("s_pda020rkrv_kdService")
@SuppressWarnings({"rawtypes", "unchecked"})
public class S_pda020rkrv_kdServiceImpl extends TlabAbstractServiceImpl {


	private final Logger	logger	= LoggerFactory.getLogger(this.getClass());

	@Resource(name = "tlabMenuService")
	 TlabMenuService tlabMenuService;

	/**
	 *  Location조회
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "z_kd", value = ExtDirectMethodType.STORE_READ)  /* 조회 */
    public List<Map<String, Object>> selectList1(Map param) throws Exception {
        return super.commonDao.list("s_pda020rkrv_kdService.selectList1", param);
    }

	/**
	 * 라벨출력을 위한 데이터 생성
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "z_kd")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> createBarcodeData(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		if(paramList != null)   {
			List<Map> insertList = null;
			Map<String, Object> paramMap = new HashMap<> ();

			String data = "";
			String lotNoData = "";
			String lotNoNew = "";

			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("createBarcode")) {
					insertList = (List<Map>)dataListMap.get("data");
				}
			}


			for(Map param: insertList) {


						 if(param.get("PRINT_YN").toString().equals("true")){      // 체크한 것만

								BigDecimal inQty1 = new BigDecimal(param.get("IN_QTY1").toString());
												inQty1 = inQty1.multiply(BigDecimal.valueOf(1.000));
								BigDecimal inQty2 = new BigDecimal(param.get("IN_QTY2").toString());
												inQty2 = inQty2.multiply(BigDecimal.valueOf(1.000));
								BigDecimal inQty3 = new BigDecimal(param.get("IN_QTY3").toString());
												inQty3 = inQty3.multiply(BigDecimal.valueOf(1.000));
								BigDecimal inQty4 = new BigDecimal(param.get("IN_QTY4").toString());
												inQty4 = inQty4.multiply(BigDecimal.valueOf(1.000));
								BigDecimal inQty5 = new BigDecimal(param.get("IN_QTY5").toString());
												inQty5 = inQty5.multiply(BigDecimal.valueOf(1.000));
								BigDecimal inQty6 = new BigDecimal(param.get("IN_QTY6").toString());
												inQty6 = inQty6.multiply(BigDecimal.valueOf(1.000));
								BigDecimal inQty7 = new BigDecimal(param.get("IN_QTY7").toString());
												inQty7 = inQty7.multiply(BigDecimal.valueOf(1.000));
								BigDecimal inQty8 = new BigDecimal(param.get("IN_QTY8").toString());
												inQty8 = inQty8.multiply(BigDecimal.valueOf(1.000));
								BigDecimal inQty9 = new BigDecimal(param.get("IN_QTY9").toString());
												inQty9 = inQty9.multiply(BigDecimal.valueOf(1.000));
								BigDecimal inQty10 = new BigDecimal(param.get("IN_QTY10").toString());
											inQty10 = inQty10.multiply(BigDecimal.valueOf(1.000));

								lotNoNew = (String) param.get("LOT_NO");

							 	if( ObjUtils.isEmpty(param.get("LOT_NO")) ){

									paramMap.put("COMP_CODE", param.get("S_MAIN_COMP_CODE"));
							 	   	paramMap.put("DIV_CODE", param.get("S_DIV_CODE"));
							 		paramMap.put("PO_NUM", param.get("ORDER_NUM"));
							 		paramMap.put("PO_SEQ", param.get("ORDER_SEQ"));
							 		paramMap.put("USER_ID", param.get("S_USER_ID"));
							 		paramMap.put("ROW_COUNT", param.get("ROW_COUNT"));
							 		lotNoNew = (String) super.commonDao.queryForObject ("s_pda020rkrv_kdService.autoLotNoCreate", paramMap);


							 	}
							 		param.put("LOT_NO", lotNoNew);
							 		logger.debug("[[채번된 lotNo]]" + lotNoNew);
							 		logger.debug("[[qty3]]" + inQty1.add(BigDecimal.valueOf(0.00000)));
							 		logger.debug("[[qty4]]" +  inQty1.toString());
								 if( param.get("IN_QTY1") != null &&  inQty1.compareTo(BigDecimal.ZERO) == 1){

									 data += (String) param.get("ITEM_CODE") + "|" + lotNoNew+ "|" + (String) param.get("ITEM_NAME") + "|" + (String) param.get("SPEC") + "|" + (String) param.get("OEM_ITEM_CODE") + "|" + inQty1.toString() + "|" + (String) param.get("STOCK_UNIT") + "|" + param.get("PRINT_CNT") + "\r\n";

								 }

								 if(param.get("IN_QTY2") != null &&   inQty2.compareTo(BigDecimal.ZERO) == 1){

									 data += (String) param.get("ITEM_CODE") + "|" + lotNoNew + "|" + (String) param.get("ITEM_NAME") + "|" + (String) param.get("SPEC") + "|" + (String) param.get("OEM_ITEM_CODE") + "|" + inQty2 + "|" + (String) param.get("STOCK_UNIT") + "|" + param.get("PRINT_CNT") + "\r\n";

								 }
								 if(param.get("IN_QTY3") != null &&   inQty3.compareTo(BigDecimal.ZERO) == 1){

									 data += (String) param.get("ITEM_CODE") + "|" + (String) param.get("LOT_NO") + "|" + (String) param.get("ITEM_NAME") + "|" + (String) param.get("SPEC") + "|" + (String) param.get("OEM_ITEM_CODE") + "|" + inQty3 + "|" + (String) param.get("STOCK_UNIT") + "|" + param.get("PRINT_CNT") + "\r\n";

								 }
								 if(param.get("IN_QTY4") != null &&   inQty4.compareTo(BigDecimal.ZERO) == 1){

									 data += (String) param.get("ITEM_CODE") + "|" + (String) param.get("LOT_NO") + "|" + (String) param.get("ITEM_NAME") + "|" + (String) param.get("SPEC") + "|" + (String) param.get("OEM_ITEM_CODE") + "|" + inQty4 + "|" + (String) param.get("STOCK_UNIT") + "|" + param.get("PRINT_CNT") + "\r\n";

								 }
								 if(param.get("IN_QTY5") != null &&   inQty5.compareTo(BigDecimal.ZERO) == 1){

									 data += (String) param.get("ITEM_CODE") + "|" + (String) param.get("LOT_NO") + "|" + (String) param.get("ITEM_NAME") + "|" + (String) param.get("SPEC") + "|" + (String) param.get("OEM_ITEM_CODE") + "|" +inQty5 + "|" + (String) param.get("STOCK_UNIT") + "|" + param.get("PRINT_CNT") + "\r\n";

								 }
								 if(param.get("IN_QTY6") != null &&   inQty6.compareTo(BigDecimal.ZERO) == 1){

									 data += (String) param.get("ITEM_CODE") + "|" + (String) param.get("LOT_NO") + "|" + (String) param.get("ITEM_NAME") + "|" + (String) param.get("SPEC") + "|" + (String) param.get("OEM_ITEM_CODE") + "|" +inQty6 + "|" + (String) param.get("STOCK_UNIT") + "|" + param.get("PRINT_CNT") + "\r\n";

								 }
								 if(param.get("IN_QTY7") != null &&   inQty7.compareTo(BigDecimal.ZERO) == 1){

									 data += (String) param.get("ITEM_CODE") + "|" + (String) param.get("LOT_NO") + "|" + (String) param.get("ITEM_NAME") + "|" + (String) param.get("SPEC") + "|" + (String) param.get("OEM_ITEM_CODE") + "|" + inQty7 + "|" + (String) param.get("STOCK_UNIT") + "|" + param.get("PRINT_CNT") + "\r\n";

								 }
								 if(param.get("IN_QTY8") != null &&   inQty8.compareTo(BigDecimal.ZERO) == 1){

									 data += (String) param.get("ITEM_CODE") + "|" + (String) param.get("LOT_NO") + "|" + (String) param.get("ITEM_NAME") + "|" + (String) param.get("SPEC") + "|" + (String) param.get("OEM_ITEM_CODE") + "|" + inQty8+ "|" + (String) param.get("STOCK_UNIT") + "|" + param.get("PRINT_CNT") + "\r\n";

								 }
								 if(param.get("IN_QTY9") != null &&   inQty9.compareTo(BigDecimal.ZERO) == 1){

									 data += (String) param.get("ITEM_CODE") + "|" + (String) param.get("LOT_NO") + "|" + (String) param.get("ITEM_NAME") + "|" + (String) param.get("SPEC") + "|" + (String) param.get("OEM_ITEM_CODE") + "|" + inQty9 + "|" + (String) param.get("STOCK_UNIT") + "|" + param.get("PRINT_CNT") + "\r\n";

								 }
								 if(param.get("IN_QTY10") != null &&   inQty10.compareTo(BigDecimal.ZERO) == 1){

									 data += (String) param.get("ITEM_CODE") + "|" + (String) param.get("LOT_NO") + "|" + (String) param.get("ITEM_NAME") + "|" + (String) param.get("SPEC") + "|" + (String) param.get("OEM_ITEM_CODE") + "|" + inQty10 + "|" + (String) param.get("STOCK_UNIT") + "|" + param.get("PRINT_CNT") + "\r\n";

								 }


					      }

			}

			if(insertList != null) this.createBarcode(insertList, paramMaster, user, data, lotNoData);


		}


		paramList.add(0, paramMaster);

		return paramList;
	}
	 /**
	  * @param decimal     부동소수
	  * @param loc            자릿수 제한 위치. 2자리까지 보이면 2 , 3자리까지면 3 이런식으로 지정
	  * @param mode        1 내림 , 2 반올림 , 3 올림
	  * @return
	  */
	 public static double decimalScale(String decimal , int loc , int mode) {

	  BigDecimal bd = new BigDecimal(decimal);
	  BigDecimal result = null;

	  if(mode == 1) {
	   result = bd.setScale(loc, BigDecimal.ROUND_DOWN);       //내림
	  }
	  else if(mode == 2) {
	   result = bd.setScale(loc, BigDecimal.ROUND_HALF_UP);   //반올림
	  }
	  else if(mode == 3) {
	   result = bd.setScale(loc, BigDecimal.ROUND_UP);             //올림
	  }

	  return result.doubleValue();

	 }
	/**
	 * 라벨출력을 위한 데이터 생성
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_kd")
	public void createBarcode(List<Map> paramList, Map paramMaster, LoginVO user, String data, String lotNoData) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>)paramMaster.get("data");
		dataMaster.put("DESC", data);
		dataMaster.put("LOT_NO_DATA", lotNoData);

		return;
	}

	/**
	 * 라벨출력을 위한 데이터 생성
	 * @param param
	 * @return
	 * @throws Exception
	 */

	public String createBarcodeDataCreate(List<Map> insertList, Map paramMaster, LoginVO user) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>)paramMaster.get("data");
		Map<String, Object> paramMap = new HashMap<> ();

		for(Map param: insertList) {
			logger.debug("[[param2]]" + param.get("ROW_COUNT"));
			paramMap.put("LOT_NO_DATA", param.get("ROW_COUNT"));
			super.commonDao.select("s_pda020rkrv_kdService.autoLotNoCreate", paramMap);

		}
		return "";
	}

}
