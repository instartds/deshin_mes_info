package api.foren.pda2.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import api.foren.pda2.common.ApiResult;
import api.foren.pda2.common.ApiResultUtil;
import api.foren.pda2.dto.WkordDTO;
import api.foren.pda2.dto.hspDto.Pdm100ukrvDTO;
import api.foren.pda2.dto.hspDto.Pdm101ukrvDTO;
import api.foren.pda2.dto.hspDto.Pdp100ukrvDTO;
import api.foren.pda2.dto.hspDto.Pdp200ukrvDTO;
import api.foren.pda2.dto.hspDto.Pds200ukrvDTO;
import api.foren.pda2.dto.hspDto.Pds200ukrvSub1DTO;
import api.foren.pda2.dto.hspDto.Pdv200ukrvDTO;
import api.foren.pda2.dto.kodiDto.Pdm200ukrvDTO;
import api.foren.pda2.service.PdaHspServiceImpl;

/**
 * hsulphur PDA 관련 controller
 * @author chaeseongmin
 *
 */
@Controller
@RequestMapping("/api/pda/hsp")
public class PdaHspController {

	private static final Logger logger = LoggerFactory.getLogger(PdaHspController.class);
	

	@Resource(name = "pdaHspService")
	private PdaHspServiceImpl pdaHspService;
	
	
	/**
	 * 자재입고 거래처 팝업
	 * @param paramMap
	 * @return
	 */
	@RequestMapping(value = "/searchListPdm100ukrvSub1", method = RequestMethod.GET)
	@ResponseBody
	public ApiResult searchListSub1(@RequestParam HashMap<String, Object> paramMap){
		
		Map<String, Object> params = new HashMap<String, Object>(); 
				
		List<Map<String, Object>> data = pdaHspService.searchListPdm100ukrvSub1(paramMap);
		
		return ApiResultUtil.result(data);
	}
	
	/**
	 * 자재입고 품목 팝업
	 * @param paramMap
	 * @return
	 */
	@RequestMapping(value = "/searchListPdm100ukrvSub2", method = RequestMethod.GET)
	@ResponseBody
	public ApiResult searchListSub2(@RequestParam HashMap<String, Object> paramMap){
		
		Map<String, Object> params = new HashMap<String, Object>(); 
				
		List<Map<String, Object>> data = pdaHspService.searchListPdm100ukrvSub2(paramMap);
		
		return ApiResultUtil.result(data);
	}

	/**
	 * 자재입고저장
	 * @param dtos
	 * @param userId
	 * @return
	 */
	@RequestMapping(value = "/savePdm100ukrv", method = RequestMethod.POST)
	@ResponseBody
	public ApiResult savePdm100ukrv(@RequestBody Pdm100ukrvDTO dtos,
			@RequestHeader(value = "userId", required = false) String userId) {

		logger.debug("param: {}", dtos.toString());

		LoginVO user = new LoginVO();
		user.setUserID(userId);
		try {
			pdaHspService.savePdm100ukrv(dtos, user);
		} catch (Exception e) {
			logger.debug(e.getMessage());
			e.printStackTrace();
			return ApiResult.fail(e.getMessage());
		}
		return ApiResult.success();
	}
	
	/**
	 * 자재입고 2 (스캔저장방식)
	 * @param pdp200ukrvDTO
	 * @param userId
	 * @return
	 */
	@RequestMapping(value = "/savePdm101ukrv", method = RequestMethod.POST)
	@ResponseBody
	public ApiResult savePdm101ukrv(@RequestBody Pdm101ukrvDTO pdm101ukrvDTO,
			@RequestHeader(value = "userId", required = false) String userId) {


		LoginVO user = new LoginVO();
		user.setUserID(userId);
		try {
			pdaHspService.savePdm101ukrv(pdm101ukrvDTO, user);
			return ApiResult.success();
		} catch (Exception e) {
			e.printStackTrace();
			return ApiResult.fail(e.getMessage());
		}
	}
	
	/**
	 * 생산일지 메인조회
	 * @param paramMap
	 * @return
	 */ 
	@RequestMapping(value = "/searchListPdp100ukrvMain", method = RequestMethod.GET)
	@ResponseBody
	public ApiResult searchListPdp100ukrvMain(@RequestParam HashMap<String, Object> paramMap){
		
		Map<String, Object> params = new HashMap<String, Object>(); 
				
		List<Map<String, Object>> data = pdaHspService.searchListPdp100ukrvMain(paramMap);
		
		return ApiResultUtil.result(data);
	}

	@RequestMapping(value = "/savePdp100ukrv", method = RequestMethod.POST)
	@ResponseBody
	public ApiResult savePdp100ukrv(@RequestBody Pdp100ukrvDTO pdp100ukrvDTO,
			@RequestHeader(value = "userId", required = false) String userId) {


		LoginVO user = new LoginVO();
		user.setUserID(userId);
		try {
			pdaHspService.savePdp100ukrv(pdp100ukrvDTO, user);
			return ApiResult.success();
		} catch (Exception e) {
			e.printStackTrace();
			return ApiResult.fail(e.getMessage());
		}
	}
	
	
	/**
	 * 생산실적 메인조회
	 * @param paramMap
	 * @return
	 */ 
	@RequestMapping(value = "/searchPdp200ukrvMain", method = RequestMethod.GET)
	@ResponseBody
	public ApiResult searchPdp200ukrvMain(@RequestParam HashMap<String, Object> paramMap){
		
		Map<String, Object> params = new HashMap<String, Object>(); 
				
		Map<String, Object> data = pdaHspService.searchPdp200ukrvMain(paramMap);
		
		return ApiResultUtil.result(data);
	}
	
	@RequestMapping(value = "/savePdp200ukrv", method = RequestMethod.POST)
	@ResponseBody
	public ApiResult savePdp200ukrv(@RequestBody Pdp200ukrvDTO pdp200ukrvDTO,
			@RequestHeader(value = "userId", required = false) String userId) {


		LoginVO user = new LoginVO();
		user.setUserID(userId);
		try {
			pdaHspService.savePdp200ukrv(pdp200ukrvDTO, user);
			return ApiResult.success();
		} catch (Exception e) {
			e.printStackTrace();
			return ApiResult.fail(e.getMessage());
		}
	}
	/**
	 * 제품출고 메인
	 * @param paramMap
	 * @return
	 */
	@RequestMapping(value = "/searchListPds200ukrvMain", method = RequestMethod.GET)
	@ResponseBody
	public ApiResult searchListPds200ukrvMain(@RequestParam HashMap<String, Object> paramMap){

		List<Map<String, Object>> list = pdaHspService.searchListPds200ukrvMain(paramMap);

		return ApiResultUtil.result(list);
	}
	
	/**
	 * 제품출고 sub LOT 출고 pda 총 작업수량
	 * @param compCode
	 * @param divCode
	 * @return
	 */
	@RequestMapping(value = "/searchPds200ukrvSub1WorkTot", method = RequestMethod.GET)
	@ResponseBody
	public ApiResult searchPds200ukrvSub1WorkTot(@RequestParam HashMap<String, Object> paramMap) {

		Map<String, Object> data = pdaHspService.searchPds200ukrvSub1WorkTot(paramMap);
		return ApiResult.success(data.get("PDA_WORK_TOT_Q"));
	}
	
	/**
	 * 제품출고 sub LOT출고
	 * @param paramMap
	 * @return
	 */
	@RequestMapping(value = "/searchListPds200ukrvSub1", method = RequestMethod.GET)
	@ResponseBody
	public ApiResult searchListPds200ukrvSub1(@RequestParam HashMap<String, Object> paramMap){

		List<Map<String, Object>> list = pdaHspService.searchListPds200ukrvSub1(paramMap);

		return ApiResultUtil.result(list);
	}
	/**
	 * 제품출고 sub 출하지시팝업
	 * @param paramMap
	 * @return
	 */
	@RequestMapping(value = "/searchListPds200ukrvSub2", method = RequestMethod.GET)
	@ResponseBody
	public ApiResult searchListPds200ukrvSub2(@RequestParam HashMap<String, Object> paramMap){

		List<Map<String, Object>> list = pdaHspService.searchListPds200ukrvSub2(paramMap);

		return ApiResultUtil.result(list);
	}
	
	@RequestMapping(value = "/savePds200ukrvSub1", method = RequestMethod.POST)
	@ResponseBody
	public ApiResult savePdp200ukrvSub1(@RequestBody Pds200ukrvSub1DTO pds200ukrvSub1DTO,
			@RequestHeader(value = "userId", required = false) String userId) {


		LoginVO user = new LoginVO();
		user.setUserID(userId);
		try {
			pdaHspService.savePds200ukrvSub1(pds200ukrvSub1DTO, user);
			return ApiResult.success();
		} catch (Exception e) {
			e.printStackTrace();
			return ApiResult.fail(e.getMessage());
		}
	}
	
	@RequestMapping(value = "/savePds200ukrv", method = RequestMethod.POST)
	@ResponseBody
	public ApiResult savePds200ukrv(@RequestBody Pds200ukrvDTO dtos,
			@RequestHeader(value = "userId", required = false) String userId) {

		logger.debug("param: {}", dtos.toString());

		LoginVO user = new LoginVO();
		user.setUserID(userId);
		try {
			pdaHspService.savePds200ukrv(dtos, user);
		} catch (Exception e) {
			logger.debug(e.getMessage());
			e.printStackTrace();
			return ApiResult.fail(e.getMessage());
		}
		return ApiResult.success();
	}	
	
	/**
	 * 재고대체 (스캔저장방식)
	 * @param pdp200ukrvDTO
	 * @param userId
	 * @return
	 */
	@RequestMapping(value = "/savePdv200ukrv", method = RequestMethod.POST)
	@ResponseBody
	public ApiResult savePdv200ukrv(@RequestBody Pdv200ukrvDTO pdv200ukrvDTO,
			@RequestHeader(value = "userId", required = false) String userId) {

		LoginVO user = new LoginVO();
		user.setUserID(userId);
		
		Map<String, Object> params = new HashMap<>();
		params.put("S_USER_ID", user.getUserID());
		params.put("COMP_CODE", pdv200ukrvDTO.getCompCode());
		params.put("DIV_CODE", pdv200ukrvDTO.getDivCode());

		params.put("OUT_ITEM_CODE", pdv200ukrvDTO.getOutItemCode());
		params.put("OUT_LOT_NO", pdv200ukrvDTO.getOutLotNo());
		params.put("OUT_SEQ", pdv200ukrvDTO.getOutSeq());
		params.put("OUT_Q", pdv200ukrvDTO.getOutQ());
		
		params.put("REPLACE_ITEM_CODE", pdv200ukrvDTO.getReplaceItemCode());
		params.put("REPLACE_LOT_NO", pdv200ukrvDTO.getReplaceLotNo());
//		params.put("REPLACE_SEQ", pdv200ukrvDTO.getReplaceSeq());
		params.put("REPLACE_Q", pdv200ukrvDTO.getReplaceQ());
		params.put("REPLACE_DATE", pdv200ukrvDTO.getReplaceDate());
		params.put("REPLACE_PRSN", pdv200ukrvDTO.getReplacePrsn());

		params.put("CHECK_FLAG", "N");
		params.put("ITEM_STATUS", "1");
		
		
		
		
		
		try {
//			pdaHspService.savePdv200ukrv(pdv200ukrvDTO, user);
			
			Map<String, Object> result = pdaHspService.savePdv200ukrv(params);
			String errMsg = "ERROR CODE: " + ObjUtils.getSafeString(result.get("ERROR_CODE")) + "\n"
					+ ObjUtils.getSafeString(result.get("ERROR_DESC"));

			if (ObjUtils.isEmpty(result.get("ERROR_CODE"))) {
//				String inoutNum = ObjUtils.getSafeString(result.get("INOUT_NUM"));
				return ApiResult.success();
			} else {
				return ApiResult.fail(errMsg);
			}
//			return ApiResult.success();
		} catch (Exception e) {
			e.printStackTrace();
			return ApiResult.fail(e.getMessage());
		}
	}
}
