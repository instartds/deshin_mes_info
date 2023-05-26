package test.sourcegen.model;

import java.util.ArrayList;
import java.util.List;

/**
 * @Class Name : TGPackageVO.java
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

public class TGPackageVO {
    private List<TGProgramVO> programs;
    private String name;
    private boolean use = false;
    
    public TGPackageVO() {
        programs = new ArrayList<TGProgramVO>();
    }
    /**
     * @return the programs
     */
    public List<TGProgramVO> getPrograms() {
        return programs;
    }
    /**
     * @param program the programs to set
     */
    public void addProgram(TGProgramVO program) {
        this.programs.add(program);
    }
    /**
     * @param programs the programs to set
     */
    public void setPrograms(List<TGProgramVO> programs) {
        this.programs = programs;
    }
    /**
     * @return the name
     */
    public String getName() {
        return name;
    }
    /**
     * @param name the name to set
     */
    public void setName(String name) {
        this.name = name;
    }
    /**
     * @return the use
     */
    public boolean isUse() {
        return use;
    }
    /**
     * @param use the use to set
     */
    public void setUse(boolean use) {
        this.use = use;
    }
    
    
}
