package test.sourcegen.model;

import java.util.ArrayList;
import java.util.List;

/**
 * @Class Name : TGProgramListVO.java
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

public class TGProgramListVO {
        private List<TGPackageVO> packages;
        private String basePackageName ;

        public TGProgramListVO() {
            packages = new ArrayList<TGPackageVO>();
        }
        /**
         * @return the packages
         */
        public List<TGPackageVO> getPackages() {
            return packages;
        }

        /**
         * @param packages the packages to set
         */
        public void setPackages(List<TGPackageVO> packages) {
            this.packages = packages;
        }
        
        /**
         * @param packages the packages to set
         */
        public void addPackage(TGPackageVO packageVo) {
            this.packages.add(packageVo);
        }
        /**
         * @return the basePackageName
         */
        public String getBasePackageName() {
            return basePackageName;
        }
        /**
         * @param basePackageName the basePackageName to set
         */
        public void setBasePackageName(String basePackageName) {
            this.basePackageName = basePackageName;
        }

       
        
}
