package test.sourcegen.model;

import java.util.ArrayList;
import java.util.List;

import test.sourcegen.support.SGStringUtils;

/**
 * @Class Name : TGProgramVO.java
 * @Description : !!! Describe Class
 * @author SangJoon Kim
 * @since 2012. 4. 30.
 * @version 1.0
 * @see 
 *
 * @Modification Information
 * <pre>
 *    Date                Changer         Comment
 *  ===========    =========    ===========================
 *  2012. 4. 30. by SangJoon Kim: initial version
 * </pre>
 */

public class TGProgramVO {
    private List<TGMethodVO> methods;
    private String baseName;
    private String url;
    
    public TGProgramVO() {
        methods = new ArrayList<TGMethodVO> ();
    }
    /**
     * @return the mthoods
     */
    public List<TGMethodVO> getMethods() {
        return methods;
    }
    /**
     * @param mthoods the mthoods to set
     */
    public void setMethods(List<TGMethodVO> methods) {
        this.methods = methods;
    }
    
    /**
     * @param mthoods the mthoods to set
     */
    public void addMethod(TGMethodVO method) {
        this.methods.add( method );
    }
    /**
     * @return the baseName
     */
    public String getBaseName() {
        return baseName;
    }
    /**
     * @param baseName the baseName to set
     */
    public void setBaseName(String baseName) {
        this.baseName = SGStringUtils.capitalize(baseName);
    }
    /**
     * @return the url
     */
    public String getUrl() {
        return url;
    }
    
    public String getJspPath() {
        return url.substring(1);
    }
    /**
     * @param url the url to set
     */
    public void setUrl(String url) {
        this.url = url;
    }
    
    public String getControllName () {
        return this.baseName + "Controller";
    }
    
    public String getServiceName () {
        return this.baseName + "Service";
    }
    
    public String getServiceImplName () {
        return this.baseName + "ServiceImpl";
    }
    
    public String getServiceBeanName() {
        return SGStringUtils.uncapitalize(this.baseName + "Service");
    }
    
    
    
}
