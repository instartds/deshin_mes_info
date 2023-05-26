package foren.unilite.modules.matrl.mpo;

import java.util.List;
import java.util.Map;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.BindingResult;

import com.google.gson.Gson;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.lib.tree.GenericTreeDataMap;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.base.bdc.Bdc100ukrvService;
import foren.unilite.modules.com.tree.UniTreeHelper;
import foren.unilite.modules.com.tree.UniTreeNode;
import foren.unilite.modules.sales.scn.Scn100ukrvModel;
import foren.unilite.modules.sales.sof.Sof100ukrvModel;
import foren.unilite.utils.ExtFileUtils;


@Service("mpo340ukrvService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class Mpo340ukrvServiceImpl  extends TlabAbstractServiceImpl {

	/**
	 *  발주납기변경 등록
	 * @param param 
	 * @return
	 * @throws Exception
	 */	
	
	//조회-- xml의 selectList 호출
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "mpo")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {
		return  super.commonDao.list("mpo340ukrvServiceImpl.selectList", param);
	}
	
	//update -> 저장 
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "mpo")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
			
		if(paramList != null)   {
			
			List<Map> updateList = null;
			
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("updateDetail")) {
					updateList = (List<Map>)dataListMap.get("data");
				}
			}
			if(updateList != null) this.updateDetail(updateList, user);
		}
		paramList.add(0, paramMaster);

		return paramList;
	}
	
	
	//수정 --xml의 updateDetail 호출
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "mpo")
	public void updateDetail(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param :paramList )  {
			super.commonDao.update("mpo340ukrvServiceImpl.updateDetail", param);
		}
		return;
	}
}

