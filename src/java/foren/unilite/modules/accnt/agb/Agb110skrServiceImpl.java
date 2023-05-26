package foren.unilite.modules.accnt.agb;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("agb110skrService")
public class Agb110skrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@ExtDirectMethod(group = "Accnt")
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return (List) super.commonDao.list("agb110skrServiceImpl.selectList", param);
	}

	@ExtDirectMethod(group = "Accnt")
	public List<Map<String, Object>> getGridName(Map param) throws Exception {
		return (List) super.commonDao.list("agb110skrServiceImpl.getGridName", param);
	}
	
	
	/* 각주 조회 (전표조회 쿼리 실행)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public Object  getPostIt(Map param) throws Exception {
		return  super.commonDao.select("agb110skrServiceImpl.getPostIt", param);
	}
	
	/* 각주 수정(전표조회 쿼리 실행)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public Object  updatePostIt(Map param) throws Exception {
		return  super.commonDao.select("agb110skrServiceImpl.updatePostIt", param);
	}
	
	/* 각주 삭제(전표조회 쿼리 실행)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public Object  deletePostIt(Map param) throws Exception {
		return  super.commonDao.select("agb110skrServiceImpl.deletePostIt", param);
	}
	
	@ExtDirectMethod(group = "Accnt")
	public List<Map<String, Object>> selectListTo110rkrPrint(Map param) throws Exception {
		return (List) super.commonDao.list("agb110skrServiceImpl.selectListTo110rkrPrint", param);
	}
	
	/* 클립 레포트 (20200911 추가)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "Accnt")
	public List<Map<String, Object>> selectListTo111rkrPrint(Map param) throws Exception {
		return (List) super.commonDao.list("agb111rkrServiceImpl.selectListTo111rkrPrint", param);
	}
}
