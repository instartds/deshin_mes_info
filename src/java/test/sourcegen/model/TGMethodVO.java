package test.sourcegen.model;

/**
 * @Class Name : MethodVO.java
 * @Description : !!! Describe Class
 * @author SangJoon Kim
 * @since 2012. 4. 30.
 * @version 1.0
 * @see
 * 
 * @Modification Information
 * 
 *               <pre>
 *    Date                Changer         Comment
 *  ===========    =========    ===========================
 *  2012. 4. 30. by SangJoon Kim: initial version
 * </pre>
 */

public class TGMethodVO {
    private String name;
    private String type;
    private String description;
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
     * @return the type
     */
    public String getType() {
        if (this.name.endsWith("List")) {
            return "list";
        } else {
            return type;
        }
    }
    /**
     * @param type the type to set
     */
    public void setType(String type) {
        this.type = type;
    }
    /**
     * @return the description
     */
    public String getDescription() {
        return (description != null) ? this.description : this.name;
    }
    /**
     * @param description the description to set
     */
    public void setDescription(String description) {
        this.description = description;
    }


}
