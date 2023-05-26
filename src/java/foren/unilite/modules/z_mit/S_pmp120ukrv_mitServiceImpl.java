package foren.unilite.modules.z_mit;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.model.LoginVO;
import foren.framework.utils.ConfigUtil;
import foren.framework.utils.FileUtil;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.tags.ComboItemModel;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.z_yp.S_bcm100ukrv_ypModel;


@Service("s_pmp120ukrv_mitService")
@SuppressWarnings({ "unchecked", "rawtypes" })
public class S_pmp120ukrv_mitServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	

	/**
	 * 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_mit")
	public List<Map<String, Object>> selectList(Map param) throws Exception{
		return super.commonDao.list("s_pmp120ukrv_mitServiceImpl.selectList", param);
	}	







	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "z_mit")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");

		if(paramList != null) {
			List<Map> insertDetail = null;
			List<Map> updateDetail = null;
			List<Map> deleteDetail = null;

			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("insertDetail")) {
					insertDetail = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("updateDetail")) {
					updateDetail = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("deleteDetail")) {
					deleteDetail = (List<Map>)dataListMap.get("data");
				}
			}
//			if(insertDetail != null) this.insertDetail(insertDetail, user, dataMaster);
			if(updateDetail != null) this.updateDetail(updateDetail, user, dataMaster);
//			if(deleteDetail != null) this.deleteDetail(deleteDetail, user, dataMaster);
		}
		paramList.add(0, paramMaster);
		return  paramList;
	}

//	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_mit")
//	public Integer insertDetail(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {
//		try {
//			for(Map param : paramList ) {
//				if(ObjUtils.isEmpty(param.get("CONT_NUM"))) {
//					param.put("CONT_NUM", paramMaster.get("CONT_NUM"));
//				}
//				super.commonDao.insert("s_pmp120ukrv_mitServiceImpl.insertDetail", param);
//			}
//		}catch(Exception e){
//			throw new  UniDirectValidateException(this.getMessage("8114", user));
//		}
//		return 0;
//	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_mit")
	public Integer updateDetail(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {
		for(Map param :paramList ) {	
			super.commonDao.update("s_pmp120ukrv_mitServiceImpl.updateDetail", param);
		}
		return 0;
	} 
	
//	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_mit")
//	public Integer deleteDetail(List<Map> paramList,  LoginVO user, Map paramMaster) throws Exception {
//		 for(Map param :paramList ) {
//			try {
//				super.commonDao.delete("s_pmp120ukrv_mitServiceImpl.deleteDetail", param);
//				//DETAIL DATA가 없으면 MASTER DATA 삭제
//				int detailCount = (int) super.commonDao.select("s_pmp120ukrv_mitServiceImpl.checkDetailData", param);
//				if(detailCount == 0) {
//					super.commonDao.delete("s_pmp120ukrv_mitServiceImpl.deleteDetail1", param);
//				}
//			}catch(Exception e) {
//				throw new  UniDirectValidateException(this.getMessage("547",user));
//			}
//		}
//		return 0;
//	}















	/**
	 * 엑셀업로드 체크로직
	 * @param jobID
	 * @param param
	 * @throws Exception
	 */
	public void excelValidate(String jobID, Map param) throws Exception {	// 엑셀 Validate
		return;
	}
}