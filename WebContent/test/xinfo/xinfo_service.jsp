<%@page language="java" contentType="text/html; charset=utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@page import="java.util.*"%>
<%@page import="foren.framework.utils.*"%>
<%@page import="java.net.*"%>
<%@page import="java.io.*"%>
<%@page import="java.text.*"%>
<%@page import="java.lang.reflect.Method"%>
<%@ page import="org.springframework.core.io.Resource"%>
<%@ page import="org.springframework.core.io.support.PathMatchingResourcePatternResolver"%>
<%@ page import="org.springframework.core.type.classreading.*"%>
<%@ page import="org.springframework.core.type.*"%>
<%@ page import="org.springframework.web.servlet.mvc.annotation.*"%>
<%@ page import="org.springframework.web.bind.annotation.RequestMapping"%>
<table border="1">
	<thead>
		<tr>
			<th>ClassName / AnnotationMetadata</th>
		</tr>
	</thead>
	<tbody>
		
		<%
		   
		 
		    PathMatchingResourcePatternResolver resolver = new PathMatchingResourcePatternResolver();
		    //if ("".equals(reqName) ) {
		    
		    Resource[] rs1 = resolver.getResources("/egovframework/**/*Controller.class");
		    Resource[] rs2 = resolver.getResources("/unipass/**/*Controller.class");
		    Resource[] rs = (Resource[]) ArrayUtil.addAll(rs1, rs2);
		    for (Resource r : rs) {
		        
		        //				MetadataReader mr = new SimpleMetadataReaderFactory().getMetadataReader(r);
		        MetadataReader mr = new CachingMetadataReaderFactory()
		                .getMetadataReader(r);

		        ClassMetadata cmd = mr.getClassMetadata();
		        AnnotationMetadata amd = mr.getAnnotationMetadata();
		        
		        out.println("<tr><th>&nbsp;");
		        out.println(cmd.getClassName());
		        out.println("&nbsp; / &nbsp;");
		        out.println(ObjUtils.toJsonStr(amd.getAnnotationAttributes("org.springframework.web.bind.annotation.RequestMapping")));
		        out.println("</th></tr>");
		       
		        out.println("<tr>");
		        out.println("<td>");
		        for (String an : amd.getAnnotationTypes()) {
		            out.println("# " + an + "<br/>");
		            //if(an.equals("org.springframework.web.bind.annotation.RequestMapping")) {
		            //out.println("#"  + ObjUtils.toJsonStr(amd.getAnnotationAttributes("org.springframework.web.bind.annotation.RequestMapping")));
		            out.println("## "
		                    + an
		                    + " : "
		                    + ObjUtils.toJsonStr(amd
		                            .getAnnotationAttributes(an)));
		            out.println("<br/>");
		            //}
		        }
		       
		        out.println("======= Methods  ==<br/>");
		        for (Method obj : mr.getClass().getDeclaredMethods()) {
		            out.println("- [" + obj + "]<br/>");
		            if (obj.getAnnotation(RequestMapping.class) != null) {
		                out.println(" $$ " + obj + "<br/>");
		            }
		        }
		        out.println("======= Annotation  ==<br/>");
		        for (java.lang.annotation.Annotation obj : mr.getClass()
		                .getDeclaredAnnotations()) {
		            out.println("- [" + obj + "]<br/>");

		        }
		        out.println("&nbsp;</td>");
		        out.println("</tr>");
		        
		    }
		    //}
		    
		    
		%>
	</tbody>
</table>