package api.foren.pda.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import api.foren.pda.service.OutStorageServiceImpl;
import api.foren.pda.service.Pdi100ukrvServiceImpl;
import api.foren.pda.service.Pdi200ukrvServiceImpl;
import api.foren.pda.service.Pdi210ukrvServiceImpl;
import api.foren.pda.service.Pdi220ukrvServiceImpl;
import api.foren.pda.service.Pdi300ukrvServiceImpl;
import api.foren.pda.service.Pdi310ukrvServiceImpl;
import api.foren.pda.service.Pdm130ukrvServiceImpl;
import api.foren.pda.service.Pdm210ukrvServiceImpl;
import api.foren.pda.service.Pds110ukrvServiceImpl;
import api.foren.pda.service.Pds200ukrvServiceImpl;
import api.foren.pda.service.Pds210ukrvServiceImpl;
import api.foren.pda.service.StorageServiceImpl;
import api.foren.pda.util.JsonUtils;
import foren.framework.exception.UniDirectException;
import foren.framework.model.LoginVO;
import foren.unilite.modules.sales.SalesCommonServiceImpl;

@Controller
@RequestMapping("/api-storage/storage")
public class StorageController extends BaseController {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	/**
	 * 입고(구매) 入库（购买）
	 */
	@Resource(name = "storageService")
	private StorageServiceImpl storageService;

	@Resource(name = "salesCommonService")
	private SalesCommonServiceImpl salesCommonService;

	/**
	 * 출고(구매) 출고요청 정상출고
	 */
	@Resource(name = "outStorageService")
	private OutStorageServiceImpl outStorageService;

	/**
	 * 박스패킹등록 箱包装注册
	 */
	@Resource(name = "pds200ukrvService")
	private Pds200ukrvServiceImpl pds200ukrvService;

	/**
	 * 기타출고(자재) 其他出库（材料）
	 */
	@Resource(name = "pdm210ukrvService")
	private Pdm210ukrvServiceImpl pdm210ukrvService;

	/**
	 * 기타출고(제품) 其他出库（产品）
	 */
	@Resource(name = "pds110ukrvService")
	private Pds110ukrvServiceImpl pds110ukrvService;

	/**
	 * 正常入库（产品）
	 */
	@Resource(name = "pds210ukrvService")
	private Pds210ukrvServiceImpl pds210ukrvService;

	/**
	 * 재고실사등록 库存清点登记
	 */
	@Resource(name = "pdi100ukrvService")
	private Pdi100ukrvServiceImpl pdi100ukrvService;

	/**
	 * 재고이동출고 出库库存移动
	 */
	@Resource(name = "pdi200ukrvService")
	private Pdi200ukrvServiceImpl pdi200ukrvService;

	/**
	 * 재고이동입고 入库库存移动
	 */
	@Resource(name = "pdi210ukrvService")
	private Pdi210ukrvServiceImpl pdi210ukrvService;

	/**
	 * 이동출고조회 移动出库查询
	 */
	@Resource(name = "pdi220ukrvService")
	private Pdi220ukrvServiceImpl pdi220ukrvService;

	/**
	 * 재고조회 库存查询
	 */
	@Resource(name = "pdi300ukrvService")
	private Pdi300ukrvServiceImpl pdi300ukrvService;

	/**
	 * 로케이션등록
	 */
	@Resource(name = "pdi310ukrvService")
	private Pdi310ukrvServiceImpl pdi310ukrvService;

	/**
	 * 접수입고
	 */
	@Resource(name = "pdm130ukrvService")
	private Pdm130ukrvServiceImpl pdm130ukrvService;

	@RequestMapping("/selectStorageList")
	@ResponseBody
	public Map<String, Object> selectStorageList(@RequestBody String json, LoginVO user) throws UniDirectException {
		Map map = JsonUtils.jsonToMap(json);
		List<Map<String, Object>> poList = pdi310ukrvService.selectStorageList(map);
		return success(poList);
	}

	/**
	 * get po master list
	 */
	@RequestMapping("/selectPoList")
	@ResponseBody
	public Map<String, Object> selectPoList(@RequestBody String json, LoginVO user) throws UniDirectException {
		Map map = JsonUtils.jsonToMap(json);
		List<Map<String, Object>> poList = storageService.selectPoList(map);
		return success(poList);
	}

	/**
	 * get po detail list
	 */
	@RequestMapping("/selectPoDetailList")
	@ResponseBody
	public Map<String, Object> selectPoDetailList(@RequestBody String json, LoginVO user) throws Exception {
		Map map = JsonUtils.jsonToMap(json);
		List<Map<String, Object>> poList = storageService.selectPoDetailList(map);
		return success(poList);
	}

	/**
	 * save InStorage list
	 */
	@RequestMapping("/saveInStorage")
	@ResponseBody
	public Map<String, Object> saveInStorage(@RequestBody String json, LoginVO user) {
		LoginVO userTemp = new LoginVO();
		Map map = JsonUtils.parseJSON2Map(json);
		userTemp.setLanguage("ko");
		Map<String, Object> paramMaster = (Map<String, Object>) map.get("master");
		if (paramMaster == null) {
			paramMaster = new HashMap<String, Object>();
		}
		paramMaster.put("type", map.get("type"));
		List<Map> paramList = (List<Map>) map.get("detail");
		List<Map> poList = null;
		try {
			poList = storageService.saveInStorage(paramList, paramMaster, userTemp);
		} catch (Exception e) {
			logger.debug(e.getMessage());
			e.printStackTrace();
			return error(e.getMessage());
		}

		return success(poList.get(0));
	}

	/**
	 * save InLocationlist
	 */
	@RequestMapping("/saveInLocation")
	@ResponseBody
	public Map<String, Object> saveInLocation(@RequestBody String json, LoginVO user) {
		LoginVO userTemp = new LoginVO();
		Map map = JsonUtils.parseJSON2Map(json);
		userTemp.setLanguage("ko");
		Map<String, Object> paramMaster = (Map<String, Object>) map.get("master");
		if (paramMaster == null) {
			paramMaster = new HashMap<String, Object>();
		}
		paramMaster.put("comp_code", map.get("COMP_CODE"));
		paramMaster.put("div_code", map.get("DIV_CODE"));
		List<Map> paramList = null;
		String strLocation = (String) map.get("item_location");
		String itemcode = (String) map.get("item_code");
		List<Map> poList = null;

		try {
			poList = pdi310ukrvService.saveInLocation(paramList, paramMaster, userTemp, strLocation, itemcode);
		} catch (Exception e) {
			logger.debug(e.getMessage());
			e.printStackTrace();
			return error(e.getMessage());
		}

		return success(poList.get(0));
	}

	/**
	 * get item by barcode
	 */
	@RequestMapping("/selectItemByBarCode")
	@ResponseBody
	public Map<String, Object> selectItemByBarCode(@RequestBody String json, LoginVO user) throws UniDirectException {
		Map map = JsonUtils.jsonToMap(json);
		List<Map<String, Object>> itemList = storageService.selectItemByBarCode(map);
		return success(itemList);
	}

	/**
	 * get ExchgRateO
	 * 
	 * @throws Exception
	 */
	@RequestMapping("/fnExchgRateO")
	@ResponseBody
	public Map<String, Object> fnExchgRateO(@RequestBody String json, LoginVO user) throws Exception {
		Map map = JsonUtils.jsonToMap(json);
		Object object = salesCommonService.fnExchgRateO(map);
		return success(object);
	}

	/**
	 * get out storage detail list
	 */
	@RequestMapping("/selectOutStorageDetailList")
	@ResponseBody
	public Map<String, Object> selectOutStorageDetailList(@RequestBody String json, LoginVO user)
			throws UniDirectException {
		Map map = JsonUtils.jsonToMap(json);
		List<Map<String, Object>> itemList = outStorageService.selectOutStorageDetailList(map);
		return success(itemList);
	}

	/**
	 * 
	 * save outStorage list
	 */
	@RequestMapping("/saveOutStorage")
	@ResponseBody
	public Map<String, Object> saveOutStorage(@RequestBody String json, LoginVO user) {
		LoginVO userTemp = new LoginVO();
		Map map = JsonUtils.parseJSON2Map(json);
		userTemp.setLanguage("ko");
		Map<String, Object> paramMaster = (Map<String, Object>) map.get("master");
		if (paramMaster == null) {
			paramMaster = new HashMap<String, Object>();
		}
		List<Map> paramList = (List<Map>) map.get("detail");
		List<Map> poList = null;
		try {
			poList = pdm210ukrvService.saveStorage(paramList, paramMaster, userTemp);
		} catch (Exception e) {
			logger.debug(e.getMessage());
			e.printStackTrace();
			return error(e.getMessage());
		}

		return success(poList.get(0));
	}

	/**
	 * 
	 * save OutStorageProduct
	 */
	@RequestMapping("/saveOutStorageProduct")
	@ResponseBody
	public Map<String, Object> saveOutStorageProduct(@RequestBody String json, LoginVO user) {
		LoginVO userTemp = new LoginVO();
		Map map = JsonUtils.parseJSON2Map(json);
		userTemp.setLanguage("ko");
		Map<String, Object> paramMaster = (Map<String, Object>) map.get("master");
		if (paramMaster == null) {
			paramMaster = new HashMap<String, Object>();
		}
		paramMaster.put("TYPE", map.get("TYPE"));
		List<Map> paramList = (List<Map>) map.get("detail");
		List<Map> poList = null;
		try {
			poList = pds110ukrvService.saveOutStorageProduct(paramList, paramMaster, userTemp);
		} catch (Exception e) {
			logger.debug(e.getMessage());
			e.printStackTrace();
			return error(e.getMessage());
		}

		return success(poList.get(0));
	}

	/**
	 * get OutRequest list
	 * 
	 * @throws Exception
	 */
	@RequestMapping("/selectOutRequestList")
	@ResponseBody
	public Map<String, Object> selectOutRequestList(@RequestBody String json, LoginVO user) throws Exception {
		Map map = JsonUtils.jsonToMap(json);
		List<Map<String, Object>> poList = outStorageService.selectOutRequestList(map);
		return success(poList);
	}

	/**
	 * OutInstruct
	 * 
	 * @throws Exception
	 */
	@RequestMapping("/selectOutInstructList")
	@ResponseBody
	public Map<String, Object> selectOutInstructList(@RequestBody String json, LoginVO user) throws Exception {
		Map map = JsonUtils.jsonToMap(json);
		List<Map<String, Object>> poList = outStorageService.selectOutInstructList(map);
		return success(poList);
	}

	/**
	 * OutInstruct
	 * 
	 * @throws Exception
	 */
	@RequestMapping("/selectOutInstructDetailList")
	@ResponseBody
	public Map<String, Object> selectOutInstructDetailList(@RequestBody String json, LoginVO user) throws Exception {
		Map map = JsonUtils.jsonToMap(json);
		List<Map<String, Object>> poList = outStorageService.selectOutInstructDetailList(map);
		return success(poList);
	}

	@RequestMapping("/selectInNormalProd")
	@ResponseBody
	public Map<String, Object> selectDetailList(@RequestBody String json, LoginVO user) throws Exception {
		Map map = JsonUtils.jsonToMap(json);
		List<Map<String, Object>> poList = pds210ukrvService.selectDetailList(map);
		return success(poList);
	}

	/**
	 * get BoxPakage detail list
	 */
	@RequestMapping("/selectBoxDetailList")
	@ResponseBody
	public Map<String, Object> selectBoxDetailList(@RequestBody String json, LoginVO user) throws Exception {
		Map map = JsonUtils.jsonToMap(json);
		List<Map<String, Object>> poList = pds200ukrvService.selectBoxDetailList(map);
		return success(poList);
	}

	/**
	 * save BoxPakage list
	 */
	@RequestMapping("/saveBoxPakage")
	@ResponseBody
	public Map<String, Object> saveBoxPakage(@RequestBody String json, LoginVO user) {
		Map map = JsonUtils.parseJSON2Map(json);
		List<Map> paramList = (List<Map>) map.get("detail");

		List<Map> poList = null;
		try {
			poList = pds200ukrvService.saveBoxPakage(paramList, null, null);
		} catch (Exception e) {
			logger.debug(e.getMessage());
			e.printStackTrace();
			return error(e.getMessage());
		}

		return success("Save successfully!");
	}

	/**
	 * 库存清点 saveStockInventory
	 */
	@RequestMapping("/saveStockInventory")
	@ResponseBody
	public Map<String, Object> saveStockInventory(@RequestBody String json, LoginVO user) {
		LoginVO userTemp = new LoginVO();
		Map map = JsonUtils.parseJSON2Map(json);
		userTemp.setLanguage("ko");
		Map<String, Object> paramMaster = (Map<String, Object>) map.get("master");
		if (paramMaster == null) {
			paramMaster = new HashMap<String, Object>();
		}
		List<Map> paramList = (List<Map>) map.get("detail");
		List<Map> poList = null;
		try {
			poList = pdi100ukrvService.saveStockInventory(paramList, paramMaster, userTemp);
		} catch (Exception e) {
			logger.debug(e.getMessage());
			e.printStackTrace();
			return error(e.getMessage());
		}

		return success(poList.get(0));
	}

	/**
	 * 出库库存移动 saveOutStockMove
	 */
	@RequestMapping("/saveOutStockMove")
	@ResponseBody
	public Map<String, Object> saveOutStockMove(@RequestBody String json, LoginVO user) {
		LoginVO userTemp = new LoginVO();
		Map map = JsonUtils.parseJSON2Map(json);
		userTemp.setLanguage("ko");
		Map<String, Object> paramMaster = (Map<String, Object>) map.get("master");
		if (paramMaster == null) {
			paramMaster = new HashMap<>();
		}
		List<Map> paramList = (List<Map>) map.get("detail");
		List<Map> poList = null;
		try {
			poList = pdi200ukrvService.saveOutStockMove(paramList, paramMaster, userTemp);
		} catch (Exception e) {
			logger.debug(e.getMessage());
			e.printStackTrace();
			return error(e.getMessage());
		}

		return success(poList.get(0));
	}

	/**
	 * 入库库存移动 saveOutStockMove
	 */
	@RequestMapping("/saveInStockMove")
	@ResponseBody
	public Map<String, Object> saveInStockMove(@RequestBody String json, LoginVO user) {
		LoginVO userTemp = new LoginVO();
		Map map = JsonUtils.parseJSON2Map(json);
		userTemp.setLanguage("ko");
		Map<String, Object> paramMaster = (Map<String, Object>) map.get("master");
		if (paramMaster == null) {
			paramMaster = new HashMap<>();
		}
		List<Map> paramList = (List<Map>) map.get("detail");
		List<Map> poList = null;
		try {
			poList = pdi210ukrvService.saveInStockMove(paramList, paramMaster, userTemp);
		} catch (Exception e) {
			logger.debug(e.getMessage());
			e.printStackTrace();
			return error(e.getMessage());
		}

		return success(poList.get(0));
	}

	/**
	 * 이동출고조회 移动出库查询 selectOutStockMoveList
	 */
	@RequestMapping("/selectOutStockMoveList")
	@ResponseBody
	public Map<String, Object> selectOutStockMoveList(@RequestBody String json, LoginVO user) throws Exception {
		Map map = JsonUtils.jsonToMap(json);
		List<Map<String, Object>> poList = pdi220ukrvService.selectOutStockMoveList(map);
		return success(poList);
	}

	/**
	 * 재고조회 库存查询 selectStockList
	 */
	@RequestMapping("/selectStockList")
	@ResponseBody
	public Map<String, Object> selectStockList(@RequestBody String json, LoginVO user) throws Exception {
		Map map = JsonUtils.jsonToMap(json);
		List<Map<String, Object>> poList = pdi300ukrvService.selectStockList(map);
		return success(poList);
	}

	/**
	 * 
	 * save OutStorageProduct
	 */
	@RequestMapping("/saveInNormalProd")
	@ResponseBody
	public Map<String, Object> saveInNormalProd(@RequestBody String json, LoginVO user) {
		LoginVO userTemp = new LoginVO();
		Map map = JsonUtils.parseJSON2Map(json);
		userTemp.setLanguage("ko");
		Map<String, Object> paramMaster = (Map<String, Object>) map.get("master");
		if (paramMaster == null) {
			paramMaster = new HashMap<String, Object>();
		}
		List<Map> paramList = (List<Map>) map.get("detail");
		List<Map> poList = null;
		try {
			poList = pds210ukrvService.saveInNormalProd(paramList, paramMaster, userTemp);
		} catch (Exception e) {
			logger.debug(e.getMessage());
			e.printStackTrace();
			return error(e.getMessage());
		}

		return success(poList.get(0));
	}

	/**
	 * 
	 * save ReceiptItem
	 */
	@RequestMapping("/saveReceiptItem")
	@ResponseBody
	public Map<String, Object> saveReceiptItem(@RequestBody String json, LoginVO user) {
		LoginVO userTemp = new LoginVO();
		Map map = JsonUtils.parseJSON2Map(json);
		userTemp.setLanguage("ko");
		Map<String, Object> paramMaster = (Map<String, Object>) map.get("master");
		if (paramMaster == null) {
			paramMaster = new HashMap<String, Object>();
		}
		List<Map> paramList = (List<Map>) map.get("detail");
		List<Map> poList = null;
		try {
			poList = pdm130ukrvService.saveReceiptItem(paramList, paramMaster, userTemp);
		} catch (Exception e) {
			logger.debug(e.getMessage());
			e.printStackTrace();
			return error(e.getMessage());
		}

		return success(poList.get(0));
	}

}
