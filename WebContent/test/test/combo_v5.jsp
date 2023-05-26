<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%
    request.setAttribute("ext_url", "/extjs5/ext-all-debug_5.1.0.js");
	
	//request.setAttribute("css_url", "/extjs/resources/ext-theme-classic/ext-theme-classic-all-debug.css"); // 4.2.2
    request.setAttribute("css_url", "/extjs5/resources/ext-theme-classic-omega/ext-overrides.css"); // 5.1.0    
    request.setAttribute("ext_root", "extjs5"); // 5.1.0
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Edit Grid Sample</title>

	<link rel="stylesheet" type="text/css" href='<c:url value="${css_url}" />' />
	<link rel="stylesheet" type="text/css" href='<c:url value="/resources/css/ux-overrides.css" />' />
	<link rel="stylesheet" type="text/css" href='<c:url value="/resources/css/unilite_5.1.0.css" />' />
	
	<script type="text/javascript" charset="UTF-8" src='<c:url value="${ext_url }" />'></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Ext/overrides/ext-bug-overrides.js" />' ></script>
	
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/resources/js/moment/moment-with-langs.min.js" />' ></script>
    <script type="text/javascript">
    	var CPATH ='<%=request.getContextPath()%>';
        Ext.Loader.setConfig({
		enabled : true,
		scriptCharset : 'UTF-8',
		paths: {
                "Ext": '${CPATH }/${ext_root}/src',
            	"Ext.ux": '${CPATH }/${ext_root}/app/Ext/ux',
            	"Unilite": '${CPATH }/${ext_root}/app/Unilite',
            	"Extensible": '${CPATH }/${ext_root}/app/Extensible'
        }
	});
	Ext.require('*');	
    </script>
    
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/UniUtils.js" />' ></script>
	
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/Unilite.js"/>' ></script>
	
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/data/UniWriter.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/data/proxy/UniDirectProxy.js" />' ></script>

	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/layout/UniTable.js" />' ></script>
	
    
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/form/field/UniBaseField.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/form/field/UniComboBox.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/form/field/UniTextField.js" />' ></script>			
	
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/locale/Message-ko.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/locale/unilite-lang-ko.js" />'> </script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/locale/ext-lang-ko.js" />' ></script>
	
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/api.js" />'></script>
	
    <script type="text/javascript">   
		Ext.define("UserInfo", {
    		 singleton: true,
		     userID: 		"${loginVO.userID}",
		     userName: 		"${loginVO.userName}",
		     personNumb: 	"${loginVO.personNumb}",
		     divCode: 		"${loginVO.divCode}",
		     deptCode: 		"${loginVO.deptCode}",
		     deptName: 		"${loginVO.deptName}",
		     compCode: 		"${loginVO.compCode}",
		     currency:  	'KRW',
		     appOption: {
		     	collapseMenuOnOpen: true,
		     	showPgmId: false,
		     	collapseLeftSearch: true
		     }
		 }
	);
	
		Ext.require([
		    'Ext.data.*',
		    'Ext.tip.QuickTipManager',
		    'Ext.window.MessageBox'
		]);
		
		
		
        Ext.onReady(function(){
        	Ext.tip.QuickTipManager.init();
        	Ext.direct.Manager.addProvider(Ext.app.REMOTING_API);
        	
        	var masterForm = Ext.create('Ext.form.Panel', {//Unilite.createSearchPanel('sof100ukrvMasterForm', {
				title: '수주정보',
		        //defaultType: 'uniSearchSubPanel',
				 listeners: {
			       /* collapse: function () {
			        	panelResult.show();
			        },
			        expand: function() {
			        	panelResult.hide();
			        },*/
			        uniOnChange: function(basicForm, dirty, eOpts) {				
						UniAppManager.setToolbarButtons('save', true);
					}
				 },
			    items: [{ 
					title: '기본정보', 	
		           	layout: {type: 'uniTable', columns: 1},
					defaultType: 'uniTextfield',
					items: [
						{
						fieldLabel: '<t:message code="unilite.msg.sMS832" default="판매유형"/>',
						name: 'ORDER_TYPE',
						comboType: 'AU',
						comboCode: 'S002',
						//xtype: 'uniCombobox',
						xtype: 'combobox',
						queryMode: 'local',
						typeAhead: true,
						autoSelect: true,
						forceSelection: true,
						selectOnFocus: false,
						valueField: 'value',
						displayField: 'text',
						allowBlank:false,
						//holdable: 'hold',
						store: Ext.create('Ext.data.Store', { 
					        autoLoad: true, 
					        fields: ['value', 'text', 'option', 'search'],
					        sorters: [{
						        property: 'value',
						        direction: 'ASC' // or 'ASC'
						    }],
					        proxy: { 
					            type: 'ajax', 
					            url: CPATH+'/com/getComboList.do?comboType=AU&comboCode=S002'
					        }
					    } ),
						listeners: {
							expand: function( field, eOpts ) {
								console.log(eOpts);
							},
							beforeselect: function( combo, record, index, eOpts ) {
//								var orderType = panelResult.getForm().findField('ORDER_TYPE');
//								orderType.setValue(record.data.value);
							},
							change: function(field, newValue, oldValue, eOpts) {						
								//panelResult.setValue('ORDER_TYPE', newValue);
//								var orderType = panelResult.getForm().findField('ORDER_TYPE');
//								orderType.setValue(newValue);
							}
						}
					},{
						xtype: 'button',
						text: 'click',
						handler: function() {
							var orderType = panelResult.getForm().findField('ORDER_TYPE');
							orderType.select(10);
						}
					}]
			    }]
			});
			
			var panelResult = Ext.create('Ext.form.Panel', {//Unilite.createSearchPanel('sof100ukrvMasterForm', {
				title: '수주정보2',
		        //defaultType: 'uniSearchSubPanel',				
			    items: [{ 
					title: '기본정보', 	
		           	layout: {type: 'uniTable', columns: 1},
					defaultType: 'uniTextfield',
					items: [
						{
						fieldLabel: '<t:message code="unilite.msg.sMS832" default="판매유형"/>',
						name: 'ORDER_TYPE',
						comboType: 'AU',
						comboCode: 'S002',
						//xtype: 'uniCombobox',
						xtype: 'combobox',
						queryMode: 'local',
						typeAhead: true,
						autoSelect: true,
						forceSelection: true,
						selectOnFocus: false,
						valueField: 'value',
						displayField: 'text',
						allowBlank:false,
						//holdable: 'hold',						
						store: Ext.create('Ext.data.Store', { 
					        autoLoad: true, 
					        fields: ['value', 'text', 'option', 'search'],
					        sorters: [{
						        property: 'value',
						        direction: 'ASC' // or 'ASC'
						    }],
					        proxy: { 
					            type: 'ajax', 
					            url: CPATH+'/com/getComboList.do?comboType=AU&comboCode=S002'
					        }
					    } ),
						listeners: {
							beforeselect: function( combo, record, index, eOpts ) {
//								var orderType = masterForm.getForm().findField('ORDER_TYPE');
//								orderType.setValue(record.data.value);
							},
							change: function(field, newValue, oldValue, eOpts) {						
								//panelResult.setValue('ORDER_TYPE', newValue);
//								var orderType = masterForm.getForm().findField('ORDER_TYPE');
//								orderType.setValue(newValue);
							}
						}
					}]
			    },{
						xtype: 'button',
						text: 'click',
						handler: function() {
							var orderType = masterForm.getForm().findField('ORDER_TYPE');
							orderType.select(10);
						}
					}]
			});
		
		    var main = Ext.create('Ext.container.Container', {
		        padding: '0 0 0 20',
		        width: 1000,
		        height: Ext.themeName === 'neptune' ? 500 : 450,
		        renderTo: document.body,
		        layout: {
		            type: 'vbox',
		            align: 'stretch'
		        },
		        items: [
		        	masterForm,		        	
		        	panelResult
		        ]
		    });
        });
    </script>
    <!-- </x-compile> -->
</head>
<body>
</body>
</html>
