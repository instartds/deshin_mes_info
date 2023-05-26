<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
// 우편번호 팝업
request.setAttribute("PKGNAME","Unilite.app.popup.ZipPopupTest");
%>
/**
 * 검색조건 (Search Panel)
 * @type 
 */
Ext.define('${PKGNAME}', {
    extend: 'Unilite.com.BaseJSPopupApp',
    constructor : function(config) {
        var me = this;
        if (config) {
            Ext.apply(me, config);
        }
	    /**
	     * 검색조건 (Search Panel)
	     * @type 
	     */
	    var wParam = this.param;
		me.data = {},
		me.uniOpt = {
			btnQueryHide:true,
	    	btnCloseHide:false
		},

		config.items = [
			{
				xtype:'component',  
				tdAttrs:{height:800},
				html:'<div id="aprvPopupLayer" style="overflow:auto;z-index:1;-webkit-overflow-scrolling:touch;margin:5px"></div>',
				listeners:{
					afterrender:function()	{
						me.zip_execDaumPostcode();
					}
				}
    		}
		];
		me.callParent(arguments);
		
		
    },
	initComponent : function(){    
    	var me  = this;
        
    	this.callParent();    	
    },    

	onSubmitButtonDown : function()	{
        var me=this;
	 	var rv ;
		if(!Ext.isEmpty(me.data))	{
		 	rv = {
				status : "OK",
				data:[me.data]
			};
		}
		me.returnData(rv);
	},
    
    zip_execDaumPostcode: function() {

        var aprvPopupLayer = document.getElementById('aprvPopupLayer');
        
/*
        var me = this;
        var form = "";
        form = form + "<form id='f1' name='f1' action='http://ep.joinsdev.net/WebSite/Approval/FormLinkForLEGACY.aspx' method='post' onSubmit='return false;' >";
        form = form + "    <input type='hidden' id='loginid' name='loginid' value='superadmin' />";
        form = form + "    <input type='hidden' id='fmpf' name='fmpf' value='WF_COST_MIS_REQ' />";
        form = form + "    <input type='hidden' id='fmbd' name='fmbd' runat='server' />";
        form = form + "</form>";
        form = form + "<iframe id='_if_' name='_if_' style='width:100%;height:100%;'></iframe>";

        aprvPopupLayer.innerHTML = form;
        
        var data = ""; 
        data += "<?xml version='1.0' encoding='euc-kr' ?>";
        data += "<aprv APPID='MIS_ACCNT'>";
        data += "<item>";
        data += "<apprManageNo>AP2014123100001482</apprManageNo>";
        data += "</item>";
        data += "<content><![CDATA[";
        data += "<table style='border-collapse:collapse; border:1px gray solid;'>";
        data += "<tr style='border:1px gray solid;padding: 5px 10px;'>";
        data += "<td style='border:1px gray solid;padding: 5px 10px;'>";
        data += "<p>테스트 데이터내용입니다.1</p>";
        data += "<p><a target='_blank' href='http://www.naver.com'>url 테스트</a></p>";
        data += "</td>";
        data += "</tr>";
        data += "<tr style='border:1px gray solid;padding: 5px 10px;'>";
        data += "<td style='border:1px gray solid;padding: 5px 10px;'>";
        data += "<p>테스트 데이터내용입니다.2</p>";
        data += "<p><a target='_blank' href='http://www.naver.com'>url 테스트</a></p>";
        data += "</td>";
        data += "</tr>";
        data += "</table>";
        data += "]]></content>";
        data += "</aprv>";
*/
        
        var me = this;
        var form = '';
        form = form + '<form id="f1" name="f1" action="http://ep.joinsdev.net/WebSite/Approval/FormLinkForLEGACY.aspx" method="post" onSubmit="return false;" >';
        form = form + '    <input type="hidden" id="loginid" name="loginid" value="superadmin" />';
        form = form + '    <input type="hidden" id="fmpf" name="fmpf" value="WF_COST_MIS_REQ" />';
        form = form + '    <input type="hidden" id="fmbd" name="fmbd"  />';
        form = form + '</form>';
        form = form + '<iframe id="_if_" name="_if_" style="width:100%;height:100%;"></iframe>';

        aprvPopupLayer.innerHTML = form;
        
        var data = ''; 
        data += '<?xml version="1.0" encoding="euc-kr" ?>';
        data += '<aprv APPID="MIS_ACCNT">';
        data += '<item>';
        data += '<apprManageNo>AP2014123100001482</apprManageNo>';
        data += '</item>';
        data += '<content><![CDATA[';
        data += '<table style="border-collapse:collapse; border:1px gray solid;">';
        data += '<tr style="border:1px gray solid;padding: 5px 10px;">';
        data += '<td style="border:1px gray solid;padding: 5px 10px;">';
        data += '<p>테스트 데이터내용입니다.1</p>';
        data += '<p><a target="_blank" href="http://www.naver.com">url 테스트</a></p>';
        data += '</td>';
        data += '</tr>';
        data += '<tr style="border:1px gray solid;padding: 5px 10px;">';
        data += '<td style="border:1px gray solid;padding: 5px 10px;">';
        data += '<p>테스트 데이터내용입니다.2</p>';
        data += '<p><a target="_blank" href="http://www.naver.com">url 테스트</a></p>';
        data += '</td>';
        data += '</tr>';
        data += '</table>';
        data += ']]></content>';
        data += '</aprv>';
        
        var fmbd = document.getElementById('fmbd');
        fmbd.value = data;
        
        console.log("fmbd :: " + document.getElementById('fmbd').value);
        
        document.getElementById("f1").target = "_if_";
        document.getElementById("f1").submit();
    }
	
});
