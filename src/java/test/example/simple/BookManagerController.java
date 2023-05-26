package test.example.simple;

import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import test.example.cmm.ExampleAbstractController;

import foren.framework.lib.listop.ListOp;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.framework.model.NavigatorInfo;

@Controller
public class BookManagerController extends ExampleAbstractController {
    private static final Logger logger = LoggerFactory.getLogger(BookManagerController.class);

    public final static String JSP_PATH = "example/bookManager/";
    
    /** CmiLoadingDeclarationService */
    @Resource(name = "BookManagerServiceImpl")
    private BookManagerService myFirstService;
    
    /**
     * selectMrnList
     * @param 
     * @return String
     * @exception Exception
     */
	@RequestMapping(value = "/example/bookManager/list.do")	
    public String selectBookList(ExtHtttprequestParam _req, ListOp listOp, ModelMap model) throws Exception {
	    
		final String[] searchFields = { "srchStartDate:$d{-7d}"
				   					   ,"srchEndDate:$d{today}"
						               ,"srchKey1"
						               ,"srchVal1"
						               ,"srchVal2"};
		
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);

        LoginVO session = _req.getSession();
        
        Map<String, Object> param=navigator.getParam();
        

        
    	navigator.setList(myFirstService.selectBookList(param));
        
        model.addAttribute(NAVI_KEY, navigator);        
		model.addAttribute(ListOp.LIST_OP_NAME, listOp);
	 
        return JSP_PATH + "selectBookList";
            
    }
}
