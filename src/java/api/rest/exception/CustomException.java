package api.rest.exception;

import java.util.Map;

@SuppressWarnings( "rawtypes" )
public class CustomException extends Exception {
    private static final long serialVersionUID = 272472861475656689L;
    
    String err_msg = null;
    Map    map     = null;
    
    public CustomException() {
        super();
    }
    
    public CustomException( String err ) {
        super(err);
        err_msg = err;
    }

    public CustomException( String err, Map map ) {
        super(err);
        err_msg = err;
        this.map = map;
    }
    
    public String getErrMsg() {
        return err_msg;
    }
    
    public Map getMap() {
        return map;
    }
    
    public void setMap( Map map ) {
        this.map = map;
    }
    
}
