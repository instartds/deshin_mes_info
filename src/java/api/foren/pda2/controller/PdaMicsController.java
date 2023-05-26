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
import api.foren.pda2.common.ApiResult;
import api.foren.pda2.common.ApiResultUtil;
import api.foren.pda2.dto.micsDto.Pds510ukrvPackDTO;
import api.foren.pda2.dto.micsDto.Pds600ukrvPackDTO;
import api.foren.pda2.service.PdaMicsServiceImpl;

/**
 * Mek-ics PDA 관련 controller
 * @author byk
 *
 */
@Controller
@RequestMapping("/api/pda/mics")
public class PdaMicsController {

	private static final Logger logger = LoggerFactory.getLogger(PdaMicsController.class);
	
	@Resource(name = "pdaMicsService")
	private PdaMicsServiceImpl pdaMicsService;
	
	/**
	 * 바코드 데이터 조회
	 * @param paramMap
	 * @return
	 */
	@RequestMapping(value = "/getBarcodeData", method = RequestMethod.GET)
	@ResponseBody
	public ApiResult getBarcodeData(@RequestParam HashMap<String, Object> paramMap, @RequestHeader(value = "userID", required = false) String userId){
		
		LoginVO user = new LoginVO();
		user.setUserID(userId);
		
		try {
			Map<String, Object> data = pdaMicsService.getBarcodeData(paramMap, user);
			return ApiResultUtil.result(data);
			
		} catch (Exception e) {
			logger.debug(e.getMessage());
			e.printStackTrace();
			return ApiResult.fail(e.getMessage());
		}
	}
	
	
	/**
	 * 출하지시서 팝업 조회
	 * @param paramMap
	 * @return
	 */
	@RequestMapping(value = "/searchListPds510ukrvSub1", method = RequestMethod.GET)
	@ResponseBody
	public ApiResult searchListPds510ukrvSub1(@RequestParam HashMap<String, Object> paramMap){

		List<Map<String, Object>> data = pdaMicsService.searchListPds510ukrvSub1(paramMap);
		
		return ApiResultUtil.result(data);
	}
	
	/**
	 * 메인 패킹 조회
	 * @param paramMap
	 * @return
	 */
	@RequestMapping(value = "/searchListPds510ukrvMain", method = RequestMethod.GET)
	@ResponseBody
	public ApiResult searchListPds510ukrvMain(@RequestParam HashMap<String, Object> paramMap){

		List<Map<String, Object>> data = pdaMicsService.searchListPds510ukrvMain(paramMap);
		
		return ApiResultUtil.result(data);
	}
	
	/**
	 * 패킹 조회
	 * @param paramMap
	 * @return
	 */
	@RequestMapping(value = "/searchListPds510ukrvSub2", method = RequestMethod.GET)
	@ResponseBody
	public ApiResult searchListPds510ukrvSub2(@RequestParam HashMap<String, Object> paramMap){

		List<Map<String, Object>> data = pdaMicsService.searchListPds510ukrvSub2(paramMap);
		
		return ApiResultUtil.result(data);
	}
	
	
	/**
	 * 제품 리스트 조회
	 * @param paramMap
	 * @return
	 */
	@RequestMapping(value = "/searchListPds510ukrvSub3", method = RequestMethod.GET)
	@ResponseBody
	public ApiResult searchListPds510ukrvSub3(@RequestParam HashMap<String, Object> paramMap){

		List<Map<String, Object>> data = pdaMicsService.searchListPds510ukrvSub3(paramMap);
		
		return ApiResultUtil.result(data);
	}
	
	/**
	 * 제품 패킹 & 패킹삭제 & 전체삭제 & 확정(pds510ukrv)
	 * @param paramMap
	 * @return
	 */
	@RequestMapping(value = "/savePds510ukrvPack", method = RequestMethod.POST)
	@ResponseBody
	public ApiResult savePds510ukrvPack(@RequestBody Pds510ukrvPackDTO saveDTO, @RequestHeader(value = "userID", required = false) String userId) {

		LoginVO user = new LoginVO();
		user.setUserID(userId);
		
		try {
			pdaMicsService.savePds510ukrvPack(saveDTO, user);
			return ApiResult.success();
			
		} catch (Exception e) {
			
			logger.debug(e.getMessage());
			e.printStackTrace();
			return ApiResult.fail(e.getMessage());
		}
	}
	
	
	/**
	 * 패킹번호 리스트 조회
	 * @param paramMap
	 * @return
	 */
	@RequestMapping(value = "/searchListPds600ukrvMain", method = RequestMethod.GET)
	@ResponseBody
	public ApiResult searchListPds600ukrvMain(@RequestParam HashMap<String, Object> paramMap){
				
		List<Map<String, Object>> data = pdaMicsService.searchListPds600ukrvMain(paramMap);
		
		return ApiResultUtil.result(data);
	}
	
	/**
	 * 제품 패킹 & 패킹삭제 & 확정 (pds600ukrv)
	 * @param paramMap
	 * @return
	 */
	@RequestMapping(value = "/savePds600ukrvPack", method = RequestMethod.POST)
	@ResponseBody
	public ApiResult savePds600ukrvPack(@RequestBody Pds600ukrvPackDTO saveDTO, @RequestHeader(value = "userID", required = false) String userId) {

		LoginVO user = new LoginVO();
		user.setUserID(userId);
		
		try {
			pdaMicsService.savePds600ukrvPack(saveDTO, user);
			return ApiResult.success();
			
		} catch (Exception e) {
			
			logger.debug(e.getMessage());
			e.printStackTrace();
			return ApiResult.fail(e.getMessage());
		}
	}
	
}
