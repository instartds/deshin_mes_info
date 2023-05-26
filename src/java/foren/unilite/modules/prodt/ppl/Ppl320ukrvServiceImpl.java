package foren.unilite.modules.prodt.ppl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.lib.tree.GenericTreeDataMap;
import foren.framework.lib.tree.GenericTreeNode;
import foren.framework.logging.InjectLogger;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.com.tree.UniTree;
import foren.unilite.modules.com.tree.UniTreeHelper;
import foren.unilite.modules.com.tree.UniTreeNode;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;

import org.apache.commons.exec.CommandLine;
import org.apache.commons.exec.DefaultExecutor;
import org.apache.commons.exec.PumpStreamHandler;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;


@Service("ppl320ukrvService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class Ppl320ukrvServiceImpl  extends TlabAbstractServiceImpl {
	@InjectLogger
	public static   Logger  logger  ;// = LoggerFactory.getLogger(this.getClass());

	/**
	 *공정 설비 목록
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.TREE_LOAD, group = "prodt")
	public List<GenericTreeNode<GenericTreeDataMap>>  selectResourcelist(Map param) throws Exception {
		
		List<GenericTreeDataMap> dataList = super.commonDao.list("ppl320ukrvServiceImpl.selectResourcelist", param);
		
		UniTreeNode tree = UniTreeHelper.makeTreeAndGetRootNode(dataList);
        return tree.getChildren();
	}
	
	@ExtDirectMethod(group = "prodt")
	public List<Map<String, Object>>  selectResourcelist2(Map param) throws Exception {
		
		List<Map<String, Object>>  dataList = super.commonDao.list("ppl320ukrvServiceImpl.selectResourcelist2", param);
		
        return dataList;
	}
	/**
	 * APS DATA
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>>   selectDetailList(Map param) throws Exception {
		List<Map<String, Object>> dataList = new ArrayList<Map<String, Object>>();
		dataList = super.commonDao.list("ppl320ukrvServiceImpl.selectDatalist", param);
		
		return  dataList;
	}
	
	/**
	 * 주차 관련 (몇주차)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public Object  getCalNo(Map param) throws Exception {
		return  super.commonDao.select("ppl320ukrvServiceImpl.getCalNo", param);
	}
	

	
	/**
	 * aps파라미터 저장
	 * @param paramList	리스트의  update 오퍼레이션별 정보
	 * @param paramMaster 폼(마스터 정보)의 기본 정보
	 * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "prodt")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {


		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");

		List<Map> dataList = new ArrayList<Map>();
		List<List<Map>> resultList = new ArrayList<List<Map>>();
		if(paramList != null)	{
			List<Map> updateList = null;
			for(Map param: paramList) {
				if(param.get("method").equals("updateList")) {
					updateList = (List<Map>)param.get("data");
				}
			}
			if(updateList != null) this.updateList(updateList, user);
		}

		paramList.add(0, paramMaster);

		return  paramList;
	}

	/**
	 * aps 정보 업데이트
	 */
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "prodt" )
	public List<Map> updateList(List<Map> params, LoginVO user) throws Exception {
		for(Map param: params)	{
				super.commonDao.update("ppl320ukrvServiceImpl.updateList", param);
		}
		return params;
	}
}
