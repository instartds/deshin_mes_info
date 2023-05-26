<%@ page language="java" contentType="text/html; charset=UTF-8"     pageEncoding="UTF-8"%>
<%-- <%@ page import="unipass.co.lib.menu.*" %> --%>
<%-- <%@ page import="unipass.co.service.*" %> --%>
<%
//  MenuNode menuNode = (MenuNode) request.getAttribute(TraMenuService.KEY_MENU_NODE_ATTRIBUTE);

//  String pageTitle = (menuNode != null ) ? menuNode.getMenuName(request):"No PageTitle" ;
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title>Autocomplete Test</title>
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
    <meta http-equiv="cache-control" content="no-cache" />
    <meta http-equiv="pragma" content="no-cache" />
    
    <script type="text/javascript">
        var CPATH ='<%=request.getContextPath()%>';
    </script>
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/co/default.css' />" />
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/co/jquery-ui-1.8.4.custom.css' />" />
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/co/jqueryLayout.css' />" />
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/cm/crg_common.css' />" />

    <script type="text/javascript" src="<c:url value='/js/jquery/jquery-1.6.2.js' />" ></script>

    <script type="text/javascript" charset="utf-8" src="<c:url value='/js/lib/jquery-ui-1.8.6.custom.min.js' />"></script>
    <script type="text/javascript" src="<c:url value='/js/lib/jquery.ui.datepicker-en-GB.js' />"></script>
    <script type="text/javascript" src="<c:url value='/js/lib/jquery.layout.js' />" ></script>
    <script type="text/javascript" src="<c:url value='/js/lib/jquery.maskedinput-1.2.2.min.js' />" ></script>
    <script type="text/javascript" src="<c:url value='/js/cm/jqueryUiCustoms.js' />" ></script>
    <script type="text/javascript" src="<c:url value='/js/cm/cm_common.js' />" ></script>
    <script type="text/javascript" src="<c:url value='/js/cm/message_en.js' />" ></script>
    
    <script type="text/javascript">
    $(document).ready(function() {
    	 tableRowSpanning($('table#validateTb'), 0);

    });
    
    /**
     * jquery를 이용한 자동 table rowspanning
     *
     * @author 이주헌 <kirrie@gmail.com>
     * @param object jquery $함수를 이용해서 리턴된 테이블 오브젝트
    * @param int rowspan을 적용할 td element의 인덱스
    * @return void
     */
     function tableRowSpanning(Table, spanning_row_index)
     {
	     var RowspanTd = false;
	     var RowspanText = false;
	     var RowspanCount = 0;
	     var Rows = $('tbody tr', Table);
	     
	    $.each(Rows, function() {
	     var This = $('td', this)[spanning_row_index];
	     var text = $(This).text();
	     
	    if(RowspanTd == false)
	     {
	     RowspanTd = This;
	     RowspanText = text;
	     RowspanCount = 1;
	     }
	     else if(RowspanText != text)
	     {
	     $(RowspanTd)
	     .attr('rowSpan', RowspanCount);
	     
	    RowspanTd = This;
	     RowspanText = text;
	     RowspanCount = 1;
	     }
	     else
	     {
	     $(This)
	     .remove();
	     RowspanCount++;
	     }
	     });
	    $(RowspanTd)
	    .attr('rowSpan', RowspanCount);
    }
    
    </script>
</head>
<body>
<div class="list_panel">
<hr/>
 <form>
   <table class="panel2" summary="" id="validateTb">
                <colgroup>
                    <col width="30%" />
                    <col width="30%" />
                    <col width="*" />
                </colgroup>
                <thead>
                    <tr>
                        <th scope="col">Error Row Infomation</th>
                        <th scope="col">Error Message</th>
                        <th scope="col">Error Message</th>
                    </tr>
                </thead>
                
                <tbody>
                    
                    <tr class="tr">
                        <td class="text_align_left marge">
                            <div style="width: 70%; display: inline-block;">
                                Master B/L No - [ 4564RW]
                            </div>
                        </td>
                        <td class="text_align_left marge1">
                            
                            
                        </td>
                        <td class="text_align_left">[Freight Forwarder] is required.</td>
                    </tr>
                    
                    <tr class="tr">
                        <td class="text_align_left marge">
                            <div style="width: 70%; display: inline-block;">
                                Master B/L No - [ 4564RW]
                            </div>
                        </td>
                        <td class="text_align_left marge1">
                            
                            
                        </td>
                        <td class="text_align_left">[Number of Package] is required.</td>
                    </tr>
                    
                    <tr class="tr">
                        <td class="text_align_left marge">
                            <div style="width: 70%; display: inline-block;">
                                Master B/L No - [ 4564RW]
                            </div>
                        </td>
                        <td class="text_align_left marge1">
                            
                            
                        </td>
                        <td class="text_align_left">[Notify Tel] is required.</td>
                    </tr>
                    
                    <tr class="tr">
                        <td class="text_align_left marge">
                            <div style="width: 70%; display: inline-block;">
                                Master B/L No - [ 4564RW]
                            </div>
                        </td>
                        <td class="text_align_left marge1">
                            
                            
                        </td>
                        <td class="text_align_left">[Port of Loading] is required.</td>
                    </tr>
                    
                    <tr class="tr">
                        <td class="text_align_left marge">
                            <div style="width: 70%; display: inline-block;">
                                Master B/L No - [ 4564RW]
                            </div>
                        </td>
                        <td class="text_align_left marge1">
                            
                            
                        </td>
                        <td class="text_align_left">[Consignee Address] is required.</td>
                    </tr>
                    
                    <tr class="tr">
                        <td class="text_align_left marge">
                            <div style="width: 70%; display: inline-block;">
                                Master B/L No - [ 4564RW]
                            </div>
                        </td>
                        <td class="text_align_left marge1">
                            
                            
                        </td>
                        <td class="text_align_left">[Notify Name] is required.</td>
                    </tr>
                    
                    <tr class="tr">
                        <td class="text_align_left marge">
                            <div style="width: 70%; display: inline-block;">
                                Master B/L No - [ 4564RW]
                            </div>
                        </td>
                        <td class="text_align_left marge1">
                            
                            
                        </td>
                        <td class="text_align_left">[Forwarder Tel] is required.</td>
                    </tr>
                    
                    <tr class="tr">
                        <td class="text_align_left marge">
                            <div style="width: 70%; display: inline-block;">
                                Master B/L No - [ 4564RW]
                            </div>
                        </td>
                        <td class="text_align_left marge1">
                            
                            
                        </td>
                        <td class="text_align_left">[Cargo Type] is required.</td>
                    </tr>
                    
                    <tr class="tr">
                        <td class="text_align_left marge">
                            <div style="width: 70%; display: inline-block;">
                                Master B/L No - [ 4564RW]
                            </div>
                        </td>
                        <td class="text_align_left marge1">
                            
                            
                        </td>
                        <td class="text_align_left">[Desciption of Goods] is required.</td>
                    </tr>
                    
                    <tr class="tr">
                        <td class="text_align_left marge">
                            <div style="width: 70%; display: inline-block;">
                                Master B/L No - [ 4564RW]
                            </div>
                        </td>
                        <td class="text_align_left marge1">
                            
                            
                        </td>
                        <td class="text_align_left">[Place of Delivery] is required.</td>
                    </tr>
                    
                    <tr class="tr">
                        <td class="text_align_left marge">
                            <div style="width: 70%; display: inline-block;">
                                Master B/L No - [ 4564RW]
                            </div>
                        </td>
                        <td class="text_align_left marge1">
                            
                            
                        </td>
                        <td class="text_align_left">[Consignee Tel] is required.</td>
                    </tr>
                    
                    <tr class="tr">
                        <td class="text_align_left marge">
                            <div style="width: 70%; display: inline-block;">
                                Master B/L No - [ 4564RW]
                            </div>
                        </td>
                        <td class="text_align_left marge1">
                            
                            
                        </td>
                        <td class="text_align_left">[Exporter Name] is required.</td>
                    </tr>
                    
                    <tr class="tr">
                        <td class="text_align_left marge">
                            <div style="width: 70%; display: inline-block;">
                                Master B/L No - [ 4564RW]
                            </div>
                        </td>
                        <td class="text_align_left marge1">
                            
                            
                        </td>
                        <td class="text_align_left">[Consignee Name] is required.</td>
                    </tr>
                    
                    <tr class="tr">
                        <td class="text_align_left marge">
                            <div style="width: 70%; display: inline-block;">
                                Master B/L No - [ 4564RW]
                            </div>
                        </td>
                        <td class="text_align_left marge1">
                            
                            
                        </td>
                        <td class="text_align_left">[Gross Weight] is required.</td>
                    </tr>
                    
                    <tr class="tr">
                        <td class="text_align_left marge">
                            <div style="width: 70%; display: inline-block;">
                                Master B/L No - [ 4564RW]
                            </div>
                        </td>
                        <td class="text_align_left marge1">
                            
                            
                        </td>
                        <td class="text_align_left">[Place of Destination] is required.</td>
                    </tr>
                    
                    <tr class="tr">
                        <td class="text_align_left marge">
                            <div style="width: 70%; display: inline-block;">
                                Master B/L No - [ 4564RW]
                            </div>
                        </td>
                        <td class="text_align_left marge1">
                            
                            
                        </td>
                        <td class="text_align_left">[Notify Address] is required.</td>
                    </tr>
                    
                    <tr class="tr">
                        <td class="text_align_left marge">
                            <div style="width: 70%; display: inline-block;">
                                Master B/L No - [ 4564RW]
                            </div>
                        </td>
                        <td class="text_align_left marge1">
                            
                                    hblNo - [ FEORK2943]
                            
                            
                        </td>
                        <td class="text_align_left">[Forwarder Tel] is required.</td>
                    </tr>
                    
                    <tr class="tr">
                        <td class="text_align_left marge">
                            <div style="width: 70%; display: inline-block;">
                                Master B/L No - [ 4564RW]
                            </div>
                        </td>
                        <td class="text_align_left marge1">
                            
                                    hblNo - [ FEORK2943]
                            
                            
                        </td>
                        <td class="text_align_left">[Desciption of Goods] is required.</td>
                    </tr>
                    
                    <tr class="tr">
                        <td class="text_align_left marge">
                            <div style="width: 70%; display: inline-block;">
                                Master B/L No - [ BKKBJM110000001]
                            </div>
                        </td>
                        <td class="text_align_left marge1">
                            
                            
                        </td>
                        <td class="text_align_left">[Forwarder Tel] is required.</td>
                    </tr>
                    
                    <tr class="tr">
                        <td class="text_align_left marge">
                            <div style="width: 70%; display: inline-block;">
                                Master B/L No - [ MBEO341]
                            </div>
                        </td>
                        <td class="text_align_left marge1">
                            
                            
                        </td>
                        <td class="text_align_left">[Desciption of Goods] is required.</td>
                    </tr>
                    
                    <tr class="tr">
                        <td class="text_align_left marge">
                            <div style="width: 70%; display: inline-block;">
                                Master B/L No - [ MBEO341]
                            </div>
                        </td>
                        <td class="text_align_left marge1">
                            
                            
                                    Type - [ Container ]
                                    <br/>
                             
                        </td>
                        <td class="text_align_left">[Cargo Reference No] is required.</td>
                    </tr>
                    
                    <tr class="tr">
                        <td class="text_align_left marge">
                            <div style="width: 70%; display: inline-block;">
                                Master B/L No - [ MBEO341]
                            </div>
                        </td>
                        <td class="text_align_left marge1">
                            
                            
                                    Type - [ Container ]
                                    <br/>
                             
                        </td>
                        <td class="text_align_left">[Declaration No] is required.</td>
                    </tr>
                    
                    <tr class="tr">
                        <td class="text_align_left marge">
                            <div style="width: 70%; display: inline-block;">
                                Master B/L No - [ MBEO341]
                            </div>
                        </td>
                        <td class="text_align_left marge1">
                            
                            
                                    Type - [ Container ]
                                    <br/>
                             
                        </td>
                        <td class="text_align_left">[Place of Delivery] is required.</td>
                    </tr>
                    
                    <tr class="tr">
                        <td class="text_align_left marge">
                            <div style="width: 70%; display: inline-block;">
                                Master B/L No - [ MBEO341]
                            </div>
                        </td>
                        <td class="text_align_left marge1">
                            
                            
                                    Type - [ Container ]
                                    <br/>
                             
                        </td>
                        <td class="text_align_left">[Container No] is required.</td>
                    </tr>
                    
                    <tr class="tr">
                        <td class="text_align_left marge">
                            <div style="width: 70%; display: inline-block;">
                                Master B/L No - [ MBEO341]
                            </div>
                        </td>
                        <td class="text_align_left marge1">
                            
                                    hblNo - [ TESO32123]
                            
                            
                        </td>
                        <td class="text_align_left">[Consignee Name] is required.</td>
                    </tr>
                    
                    <tr class="tr">
                        <td class="text_align_left marge">
                            <div style="width: 70%; display: inline-block;">
                                Master B/L No - [ MBEO341]
                            </div>
                        </td>
                        <td class="text_align_left marge1">
                            
                                    hblNo - [ TESO32123]
                            
                            
                                    Type - [ Container ]
                                    <br/>
                             
                        </td>
                        <td class="text_align_left">[Cargo Reference No] is required.</td>
                    </tr>
                    
                    <tr class="tr">
                        <td class="text_align_left marge">
                            <div style="width: 70%; display: inline-block;">
                                Master B/L No - [ MBEO341]
                            </div>
                        </td>
                        <td class="text_align_left marge1">
                            
                                    hblNo - [ TESO32123]
                            
                            
                                    Type - [ Container ]
                                    <br/>
                             
                        </td>
                        <td class="text_align_left">[Seal No #1] is required.</td>
                    </tr>
                    
                    <tr class="tr">
                        <td class="text_align_left marge">
                            <div style="width: 70%; display: inline-block;">
                                Master B/L No - [ MBEO341]
                            </div>
                        </td>
                        <td class="text_align_left marge1">
                            
                                    hblNo - [ TESO32123]
                            
                            
                                    Type - [ Container ]
                                    <br/>
                             
                        </td>
                        <td class="text_align_left">[Declaration No] is required.</td>
                    </tr>
                    
                    <tr class="tr">
                        <td class="text_align_left marge">
                            <div style="width: 70%; display: inline-block;">
                                Master B/L No - [ MBEO341]
                            </div>
                        </td>
                        <td class="text_align_left marge1">
                            
                                    hblNo - [ TESO32123]
                            
                            
                                    Type - [ Container ]
                                    <br/>
                             
                        </td>
                        <td class="text_align_left">[Place of Delivery] is required.</td>
                    </tr>
                    
                    <tr class="tr">
                        <td class="text_align_left marge">
                            <div style="width: 70%; display: inline-block;">
                                Master B/L No - [ MBEO341]
                            </div>
                        </td>
                        <td class="text_align_left marge1">
                            
                                    hblNo - [ TESO32123]
                            
                            
                                    Type - [ Container ]
                                    <br/>
                             
                        </td>
                        <td class="text_align_left">[Cargo Reference No] is required.</td>
                    </tr>
                    
                    <tr class="tr">
                        <td class="text_align_left marge">
                            <div style="width: 70%; display: inline-block;">
                                Master B/L No - [ MBEO341]
                            </div>
                        </td>
                        <td class="text_align_left marge1">
                            
                                    hblNo - [ TESO32123]
                            
                            
                                    Type - [ Container ]
                                    <br/>
                             
                        </td>
                        <td class="text_align_left">[Declaration No] is required.</td>
                    </tr>
                    
                    <tr class="tr">
                        <td class="text_align_left marge">
                            <div style="width: 70%; display: inline-block;">
                                Master B/L No - [ MBEO341]
                            </div>
                        </td>
                        <td class="text_align_left marge1">
                            
                                    hblNo - [ TESO32123]
                            
                            
                                    Type - [ Container ]
                                    <br/>
                             
                        </td>
                        <td class="text_align_left">[Place of Delivery] is required.</td>
                    </tr>
                    
                    <tr class="tr">
                        <td class="text_align_left marge">
                            <div style="width: 70%; display: inline-block;">
                                Master B/L No - [ MBEO341]
                            </div>
                        </td>
                        <td class="text_align_left marge1">
                            
                                    hblNo - [ TESO32123]
                            
                            
                                    Type - [ Container ]
                                    <br/>
                             
                        </td>
                        <td class="text_align_left">[Container No] is required.</td>
                    </tr>
                    
                </tbody>
            </table>
 	</form>
 </div>
</body>
</html>