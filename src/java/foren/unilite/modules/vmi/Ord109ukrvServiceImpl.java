package foren.unilite.modules.vmi;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

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
import foren.unilite.com.service.impl.TlabBadgeService;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.sales.sof.Sof100ukrvModel;

@Service("ord109ukrvService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class Ord109ukrvServiceImpl  extends TlabAbstractServiceImpl {

	//20201216 뱃지기능 추가
	@Resource(name="tlabBadgeService")
	private TlabBadgeService tlabBadgeService;

	/**
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "vmi")
	public List<Map<String, Object>>  selectList(Map param,LoginVO user) throws Exception {
		param.put("S_USER_ID", user.getUserID());
		param.put("S_COMP_CODE", user.getCompCode());
		return  super.commonDao.list("ord109ukrvServiceImpl.selectList", param);
	}



	/**
	 * 저장
	 * @param paramList
	 * @param paramMaster
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "vmi")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		//logger.debug("[saveAll] paramDetail:" + paramList);
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		dataMaster.put("S_COMP_CODE", user.getCompCode());

		//1.저장 시, SOF220T.STATUS_FLAG = '2'로 UPDATE
		List<Map> dataList = new ArrayList<Map>();
		if(paramList != null) {
			for(Map param: paramList) {
				dataList = (List<Map>)param.get("data");

				if(param.get("method").equals("updateDetail")) {
					param.put("data", updateDetail(dataList, user, dataMaster) );
				} else if(param.get("method").equals("deleteDetail")) {
					deleteDetail(dataList, user, dataMaster);
				} /*else if(param.get("method").equals("insertDetail")) {
					param.put("data", insertDetail(dataList, user) );
				}*/
			}
		}
		paramList.add(0, paramMaster);
		//20201216 뱃지기능 추가
		tlabBadgeService.reload();

		return paramList;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "vmi")
	public List<Map> updateDetail(List<Map> params, LoginVO user, Map dataMaster) throws Exception {
		//20190830 주문확정(dataMaster.get("SAVE_FLAG") = 'Y') 시, 신규로 주문번호, 순번 채번하여 master Data insert하고 detail Data update하도록 수정
		String soNum= "";
		int soSeq	= 0;
		if("Y".equals(dataMaster.get("SAVE_FLAG"))) {
			soNum = (String) commonDao.select("ord109ukrvServiceImpl.getSoNum", dataMaster);
			dataMaster.put("SO_NUM", soNum);
			super.commonDao.insert("ord109ukrvServiceImpl.insertMaster", dataMaster);
		}

		for(Map param: params) {
			if("Y".equals(param.get("SAVE_FLAG"))) {
				soSeq = soSeq + 1;
				param.put("SO_NUM_NEW", soNum);
				param.put("SO_SEQ_NEW", soSeq);
			}
			param.put("CUSTOM_CODE", dataMaster.get("CUSTOM_CODE"));
			param.put("CUSTOM_NAME", dataMaster.get("CUSTOM_NAME"));
			//주문확정 버튼로직인 경우, 체크된 데이터만 update
			super.commonDao.update("ord109ukrvServiceImpl.updateDetail", param);

			if(params.size() == soSeq){
				//20201216 뱃지기능 추가
				super.commonDao.update("ord109ukrvServiceImpl.updateAlert", param);
			}
		}
		return params;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "vmi")
	public Integer deleteDetail(List<Map> paramList, LoginVO user, Map dataMaster) throws Exception {
		for(Map param :paramList )	{
			try {
				param.put("CUSTOM_CODE", dataMaster.get("CUSTOM_CODE"));
				super.commonDao.delete("ord109ukrvServiceImpl.deleteDetail", param);

			} catch(Exception e)	{
				throw new  UniDirectValidateException(this.getMessage("547", user));
			}
		}
		return 0;
	}
}