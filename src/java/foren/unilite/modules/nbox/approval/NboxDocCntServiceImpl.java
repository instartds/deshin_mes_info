package foren.unilite.modules.nbox.approval;

import java.io.File;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestParam;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.model.LoginVO;
import foren.framework.utils.ConfigUtil;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.modules.nbox.approval.model.NboxDocModel;
import foren.unilite.modules.nbox.link.NboxLinkDataCodeByApprovalService;
import foren.unilite.multidb.cubrid.sp.USP_GWAPP;


@Service("nboxDocCntService")
public class NboxDocCntServiceImpl extends TlabAbstractServiceImpl implements NboxDocCntService {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	public String xa003DocCnt(Map param) throws Exception {
		logger.debug("\n xa003DocCnt.param: {}", param );
		
		int rv = 0;
		rv =(int)super.commonDao.select("nboxDocCntService.xa003DocCnt", param);
		
		logger.debug("\n xa003DocCnt.cnt: {}", String.valueOf(rv) );
		
		return String.valueOf(rv);
	}
	
	
	public String getMenuName(Map param) throws Exception  {
		logger.debug("\n getMenuName.param: {}", param );
		
		String rv = "";
		
		rv = (String)super.commonDao.select("nboxDocCntService.getMenuName", param);
		
		logger.debug("\n getMenuName.rv: {}", rv );
		
		return rv;
		
	}
	
	

}
