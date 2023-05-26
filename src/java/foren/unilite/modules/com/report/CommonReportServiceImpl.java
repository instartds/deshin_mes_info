package foren.unilite.modules.com.report;

import java.util.HashMap;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.validation.BindingResult;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractCommonServiceImpl;

@Service("commonReportService")
public class CommonReportServiceImpl extends TlabAbstractCommonServiceImpl {
    private static final Logger logger = LoggerFactory.getLogger(CommonReportServiceImpl.class);

    /**
     * 인쇄옵션 정보 가져오기
     * @param param
     * @param user
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(group = "com")
    public Object getPdfWinConfig(Map<String, Object> param, LoginVO user) throws Exception {
        Object config = super.commonDao.select("commonReportServiceImpl.getPdfWinConfig", param);
        return config;
    }
    
    @ExtDirectMethod(value = ExtDirectMethodType.FORM_LOAD, group = "com")
    public Object loadPdfWinUserConfig(Map<String, Object> param, LoginVO user) throws Exception {
        Object config = super.commonDao.select("commonReportServiceImpl.loadPdfWinUserConfig", param);
        
        if(ObjUtils.isEmpty(config) )	{
        	Map<String, Object> rtn = new HashMap();
        	Map<String, Object> compConfig = (Map<String, Object>) this.getPdfWinConfig(param, user);      
        	if(ObjUtils.isNotEmpty(compConfig))	{
        		rtn.put("PT_TITLENAME", ObjUtils.nvl(compConfig.get("PT_TITLENAME"), ""));
        	}else {
        		rtn.put("PT_TITLENAME", "");
        	}
        	rtn.put("PT_COMPANY_YN", "Y");
        	rtn.put("PT_SANCTION_YN", "N");
        	rtn.put("PT_PAGENUM_YN", "Y");
        	rtn.put("PT_OUTPUTDATE_YN", "Y");
        	config = rtn;
        }
        return config;
    }    
    /**
     * 인쇄옵션 저장
     * @param param
     * @param user
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(value = ExtDirectMethodType.FORM_POST, group = "com")
    public ExtDirectFormPostResult savePdfWinUserConfig(PdfUserConfigModel param, LoginVO user, BindingResult result) throws Exception {
        param.setS_COMP_CODE(user.getCompCode());
        param.setS_USER_ID(user.getUserID());

        int cnt =(Integer) super.commonDao.select("commonReportServiceImpl.existsPdfWinUserConfig", param);
		if(cnt>0) {
			 super.commonDao.update("commonReportServiceImpl.updatePdfWinUserConfig", param);			
		} else {
			 super.commonDao.insert("commonReportServiceImpl.insertPdfWinUserConfig", param);
		}
        ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);
        return extResult;
    }
    
    /**
     * 인쇄 옵션 기본값 복원
     * @param param
     * @param user
     * @return
     * @throws Exception
     */
    
    @ExtDirectMethod(value = ExtDirectMethodType.SIMPLE, group = "com")
    public Object resetPdfWinUserConfig(Map<String, Object> param, LoginVO user) throws Exception {

        super.commonDao.update("commonReportServiceImpl.resetPdfWinUserConfig", param);
        return true;
    }
    
    
}
