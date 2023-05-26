package test.sys;

import java.net.InetAddress;
import java.net.NetworkInterface;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;

import foren.framework.utils.GStringUtils;

public class GetSysInfoTest {

    public static void main(String[] args) throws Exception {
//        MiscUtils misutil = new MiscUtilsWin32();
//
//        System.out.println("Board ID:" + misutil.getMotherboardSN());
//        System.out.println("DISK C:" + misutil.getHDDSerialNumber("C:"));
//        System.out.println("DISK D:" + misutil.getHDDSerialNumber("D:"));
        showNICS4();
    }

    public static void showNICS() throws Exception {
        Enumeration e = NetworkInterface.getNetworkInterfaces();
        while (e.hasMoreElements()) {
            NetworkInterface n = (NetworkInterface) e.nextElement();
            Enumeration ee = n.getInetAddresses();
            while (ee.hasMoreElements()) {
                InetAddress i = (InetAddress) ee.nextElement();
             //   System.out.println(n.getName() + ":"+  i.getHostAddress()+"/" + new String(n.getHardwareAddress()));
                byte[] b = n.getHardwareAddress();
                String t = GStringUtils.bytesToHex(b);
                System.out.println(n.getName() + ":"+ t );
            }
        }
    }
    
    public static void showNICS2() throws Exception {
    	// 로컬 IP취득
		InetAddress ip = InetAddress.getLocalHost();
		System.out.println("IP : " + ip.getHostAddress());
		
		// 네트워크 인터페이스 취득
		NetworkInterface nif = NetworkInterface.getByInetAddress(ip);

		// 네트워크 인터페이스가 NULL이 아니면
		if (nif != null) {
			// 네트워크 인터페이스 표시명 출력
			System.out.print(nif.getDisplayName() + " : ");
			
			// 맥어드레스 취득
			byte[] b = nif.getHardwareAddress();
			
			// 맥어드레스 출력
//			for (byte b : mac) {
//				System.out.printf("[%02X]", b);
//			}
			String mac = GStringUtils.bytesToHex(b);
			System.out.print(mac);
			System.out.println();
		}

    }
    
    public static void showNICS3() throws Exception {
    	String firstInterface = null;        
        Map<String, String> addressByNetwork = new HashMap<>();
        Enumeration<NetworkInterface> nifs = NetworkInterface.getNetworkInterfaces();

        while(nifs.hasMoreElements()){
            NetworkInterface nif = nifs.nextElement();
            if(nif.isLoopback()) {
            	continue;
            }

            byte[] bmac = nif.getHardwareAddress();
            if(bmac != null){
                StringBuilder sb = new StringBuilder();
                for (int i = 0; i < bmac.length; i++){
                    sb.append(String.format("%02X%s", bmac[i], (i < bmac.length - 1) ? "-" : ""));        
                }

                if(sb.toString().isEmpty()==false){
                    addressByNetwork.put(nif.getName(), sb.toString());
                    System.out.println("Address = "+sb.toString()+" @ ["+nif.getName()+"] "+nif.getDisplayName());
                }

                if(sb.toString().isEmpty()==false && firstInterface == null){
                    firstInterface = nif.getName();
                }
            }
        }

        if(firstInterface != null){
            //return addressByNetwork.get(firstInterface);
            System.out.print(addressByNetwork.get(firstInterface));
        }
    }
    
    public static void showNICS4() throws Exception {
    	String mac = null;
    	InetAddress ip = InetAddress.getLocalHost();

    	Enumeration e = NetworkInterface.getNetworkInterfaces();

    	while(e.hasMoreElements()) {

	    	NetworkInterface n = (NetworkInterface) e.nextElement();
	    	 Enumeration ee = n.getInetAddresses();
	    	 while(ee.hasMoreElements()) {
		    	 InetAddress i = (InetAddress) ee.nextElement();
		    	 if(i.isLoopbackAddress()) continue;
		    	 if(i.isLinkLocalAddress()) continue;
		    	 if(i.isSiteLocalAddress()) {
		    		 ip = i;
		    	 }
	    	 }
    	 }

    	
    	NetworkInterface network = NetworkInterface.getByInetAddress(ip);
    	byte[] mac_byte = network.getHardwareAddress();

    	StringBuilder sb = new StringBuilder();
    	 for(int i = 0; i < mac_byte.length; i++) {
    	 sb.append(String.format("%02X%s", mac_byte[i], (i < mac_byte.length -1) ? "-" : ""));
    	 }
    	mac = sb.toString();
    	 System.out.println(mac);

    }
}
