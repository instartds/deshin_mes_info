package test.example.jms.support;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.net.InetAddress;

/**
 * @Class Name : NetUtil.java
 * @Description : !!! Describe Class
 * @author SangJoon Kim
 * @since Jul 2, 2012
 * @version 1.0
 * @see 
 *
 * @Modification Information
 * <pre>
 *    Date                Changer         Comment
 *  ===========    =========    ===========================
 *  Jul 2, 2012 by SangJoon Kim: initial version
 * </pre>
 */

public class NetUtils {
    private String hostName ;
    private String hostAddress ;
    private static NetUtils instance = null;
    
    public static synchronized NetUtils getInstance() {
        if ( instance == null) {
            instance = new NetUtils();
        }
        return instance;
    }
    
    private NetUtils() {
        try {
            InetAddress inetAddress  = InetAddress.getLocalHost();
            hostName=inetAddress.getHostName();
            hostAddress=inetAddress.getHostAddress();
        } catch (Exception e) {
            
        }
    }
    
    public final  String getHostName() {
        return instance.hostName;
    }
    
    public final  String getHostAddress() {
        return instance.hostAddress;
    }
    
    
    public static byte[] serialize(Object obj) throws IOException {
        ByteArrayOutputStream out = new ByteArrayOutputStream();
        ObjectOutputStream os = new ObjectOutputStream(out);
        os.writeObject(obj);
        return out.toByteArray();
    }
    
    public static Object deserialize(byte[] data) throws IOException , ClassNotFoundException {
        ByteArrayInputStream in = new ByteArrayInputStream(data);
        ObjectInputStream is = new ObjectInputStream(in);
        return is.readObject();
    }
}
