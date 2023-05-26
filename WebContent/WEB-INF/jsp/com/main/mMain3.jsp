<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="decorator" uri="http://www.opensymphony.com/sitemesh/decorator"%>
<%@ page import="foren.framework.utils.*" %>
<%
		// <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">


		//request.setAttribute("DOC_TYPE", "PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\"");


		//, maximum-scale=1.0
%>
<!DOCTYPE html ${DOC_TYPE} >
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
<%@ include file='/WEB-INF/jspf/commonHead.jspf' %>
<%
	String extjsVersion = "6.5.0";//ConfigUtil.getString("extjs.version", "6.0.1");

	boolean isDevelopServer = ConfigUtil.getBooleanValue("system.isDevelopServer", true);

	request.setAttribute("isDevelopServer", isDevelopServer);
    if(isDevelopServer) {
    		request.setAttribute("ext_url", "/extjs_"+extjsVersion+"_modern/ext-modern-all-debug.js");
    } else {
    	request.setAttribute("ext_url", "/extjs_"+extjsVersion+"_modern/ext-modern-all.js");
    }

    request.setAttribute("css_url", "/extjs_"+extjsVersion+"_modern/resources/theme-triton-all.css");
    request.setAttribute("ext_root", "/extjs_"+extjsVersion+"_modern");
    request.setAttribute("ext_version", extjsVersion);
    request.setAttribute("mainDomain",  ConfigUtil.getString("servers[@domain]", ""));


    String hostName = request.getServerName();
    int portNum = request.getServerPort();

    String strPortNum = "";
    if(80==portNum || 443 == portNum )	{
    	strPortNum = "";
    }else {
    	strPortNum = ":"+String.valueOf(portNum);
    }


    request.setAttribute("CHOST",   hostName+strPortNum);
%>
<script type="text/javascript">
	var CPATH ='<%=request.getContextPath()%>';
	var EXTVERSION ='<%=extjsVersion%>';
	var docURL = document.URL;
	var scheme = docURL.substring(0,docURL.indexOf("//")+2);
	var CHOST = scheme + '${CHOST}'// 'request.getScheme()

	<c:if test="${not empty mainDomain}">
		document.domain = '${mainDomain}';
	</c:if>
</script>
<link rel="stylesheet" type="text/css" href='<c:url value="${css_url}" />' />

<script type="text/javascript" charset="UTF-8" src='<c:url value="${ext_url }" />'></script>

<script type="text/javascript" charset="UTF-8" src='<c:url value="${ext_root}/app/OmegaPlus/AppManager.js" />' ></script>
<script type="text/javascript" charset="UTF-8" src='<c:url value="${ext_root}/app/OmegaPlus/AbstractApp.js" />' ></script>


<script type="text/javascript" charset="UTF-8" src='<c:url value="${ext_root}/app/OmegaPlus/BaseApp.js" />' ></script>

<script type="text/javascript">
function detectmob() {
	 if( navigator.userAgent.match(/Android/i)
	 || navigator.userAgent.match(/webOS/i)
	 || navigator.userAgent.match(/iPhone/i)
	 || navigator.userAgent.match(/iPad/i)
	 || navigator.userAgent.match(/iPod/i)
	 || navigator.userAgent.match(/BlackBerry/i)
	 || navigator.userAgent.match(/Windows Phone/i)
	 ){
	    return true;
	  }
	 else {
	    return false;
	  }
	}
	var EXT_ROOT = '${ext_root}';
	var CPATH = '${CPATH }';
	Ext.Loader.setConfig({
		enabled : true,
		scriptCharset : 'UTF-8',
		paths: {
                "Ext": '${ext_root}/src',
            	"OmegaPlus": '${ext_root}/app/OmegaPlus'
        }
	});

	if(!detectmob()) {
		//window.location.href = CPATH+"main.do";
	}

	Ext.require('*');
	Ext.require('Ext.viewport.Viewport');
	Ext.require('OmegaPlus.AbstractApp');
	Ext.require('OmegaPlus.AppManager');


	Ext.require('OmegaPlus.BaseApp');
</script>

<c:choose>
<c:when test="${isDevelopServer }">


	<script type="text/javascript">
		var IS_DEVELOPE_SERVER = true;
	</script>
</c:when>
<c:otherwise>
<script type="text/javascript">
		var IS_DEVELOPE_SERVER = false;
</script>
</c:otherwise>
</c:choose>


<script type="text/javascript" charset="UTF-8" src='<c:url value="/api.js" />'></script>
<script type="text/javascript">


	var clipper;
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
		     userLang:		'KR',
		     compCountry:	'KR',
		     refItem:		"${loginVO.refItem}",
		     customCode:	"${loginVO.customCode}",	//외부사용자용
		     customName:	"${loginVO.customName}",	//외부사용자용
		     appOption: 	(Ext.isDefined(parent) && Ext.isDefined(parent.UserInfo) ) ? parent.UserInfo.appOption:{}
		 }
	);

	//Ext.define("CommonMsg", {
	var CommonMsg = {
		'errorTitle':{
			'ERROR':'<t:message code="unilite.msg.errorTitle" default="에러"/>',
			'WARNING':'<t:message code="unilite.msg.warnTitle" default="경고"/>',
			'INFO':'<t:message code="unilite.msg.infoTitle" default="정보"/>'
		}
	};
	//)
	Ext.define("UniFormat", {
    		singleton: true,
		 	Qty: 			'0,000', //						// 수량
		    UnitPrice: 		'0,000.00',		// "${loginVO.userID}",		// 단가
		    Price: 			'0,000',		// "${loginVO.userName}",		// 금액
		    FC: 			'0,000.00',  	// "${loginVO.personNumb}",	// 외화
		    ER: 			'0,000.00',  	//  ${loginVO.personNumb}",	// 환율
		    Percent: 		'0,000.00',		// "${loginVO.userID}",		// 확률
 			FDATE:			'Y-m-d', 		//  "${loginVO.fDate}",			// 날자
		    FYM: 			'Y-m' //"${loginVO.fYM}"			// 연월
		 }
	);
	var pgmInfo = {
		authoUser: '<%="null".equals(request.getParameter("authoUser")) ? "":request.getParameter("authoUser") %>'
	}

	Ext.onReady(function() {
		//Ext.app.REMOTING_API.enableBuffer = 100;



		var chk = false;
		if(typeof appMain !== 'undefined')  {
		 	if( Ext.isFunction(appMain)) {
				chk = true;
			}
		}

		Ext.application ( {
			name : 'DeltaMES',
			launch: function () {
				Ext.direct.Manager.addProvider(Ext.app.REMOTING_API);

				var app, appList , panelSearch, masterView, regForm, main;

				var treeSystemMenuStore = Ext.create('Ext.data.TreeStore',{
					storeId: 'treeSystemMenuStore',
			        autoLoad: false,
			        folderSort: false,
			        defaultRootProperty: 'items',
		        	root:{
					     text: 'OmegaPlus',
					     items: [{
					         text: '인사',
					         leaf: true
					         }, {
					             text: '회계',
					             leaf: true
					         }, {
					             text: '영업',
					             items: [{
						             text: '판매계획',
					             		leaf: true
						         }, {
						             text: '견적관리',
						             leaf: true
						         }, {
						             text: '수주관리',
						             items: [{
						                 text: '수주현황',
						                 leaf: true,
						                 url:CPATH+'/mobile/msof100skrv.do'
						             }, {
						                 text: '미납현황',
						                 leaf: true
						             }, {
						                 text: '수주진행현황',
						                 leaf: true
						             }]
					         }, {
					             text: '출하지시',
					             leaf: true
					         }, {
					             text: '수불관리',
					             leaf: true
					         }, {
					             text: '매출관리',
					             leaf: true
					         }, {
					             text: '채권관리',
					             leaf: true
					         }, {
					             text: '세금계산서',
					             leaf: true
					         }, {
					             text: '수금관리',
					             leaf: true
					         }]
					     }, {
			             text: '생산',
			             leaf: true
			         }, {
			             text: '구매',
			             leaf: true
			         }, {
			             text: '재고',
			             leaf: true
			         }, {
			             text: '원가',
			             leaf: true
			         }]
		        	}
				});


				/*var mainApp = Ext.create('OmegaPlus.BaseApp', {
            		appItems:[{
        				title: 'OmegaPlus',
        				xtype:'nestedlist',
					    displayField: 'text',
					    store:treeSystemMenuStore
					    }
            		]
				});

				Ext.define('menuItemModel', {
					extend: 'Ext.app.ViewModel',
					alias: 'viewmodel.menuItemModel'
				    ,stores:{
		        		navItems:Ext.data.StoreManager.lookup('treeSystemMenuStore')
		        	}
				});

				var main = Ext.create('Ext.Container', {
		            layout: 'hbox',
		            items: [mainApp]
	            });*/
	            var treeList =  Ext.create('Ext.NestedList', {
    				title: 'OmegaPlus',
    				//xtype:'nestedlist',
				    displayField: 'text',
				    store:treeSystemMenuStore,
				    useTitleAsBackText:false,
				    //fullscreen: true,
				    listeners:{
				    	leafitemtap : function ( listView, list, index, target, record, e, eOpts )	{
				    		var u = record.get("url");
                    		if(!Ext.isEmpty(u))	{
            					//window.location.href = u;
					             Ext.Viewport.add(main);
					             Ext.Viewport.setActiveItem(main);
					             //Ext.Viewport.setFlex({grow:1, shrink:1});

                    		}else {
                    			return false;
                    		}
				    	}
				    }
				});
				Ext.Viewport.add(treeList);
				 /*Ext.Viewport.setMenu(menu, {
				     side: 'left',
				     // omitting the reveal config defaults the animation to 'cover'
				     reveal: false
				 });

				treeSystemMenuStore.treeLoadRecords(data1,"발주")*/

				//=======================================  app  ===============================================

				panelSearch = Ext.create('Ext.form.Panel', {
						id:'panelSearch',
						itemId: 'search_panel1',
						flex:1,
						layout: {type: 'vbox', align: 'stretch'},

						defaults:{
							labelWidth:80
						},
						items: [ {
				            xtype: 'fieldset',
				            items: [
				                	{
						    			xtype: 'selectfield',
						            	name: 'DIV_CODE',
						            	label: '사업장',
						            	options:[
						            		{text:'포렌인더스트리', value:'01'}
						            	]
						            },{
						    			xtype: 'containerfield',
						    			label: '수주일',
						            	items:[{
						            		xtype: 'datepickerfield',
						            		name: 'ORDER_DATE_FR',
								            flex:.5
						            	},{
						            		xtype: 'datepickerfield',
								            name: 'ORDER_DATE_TO',
								            flex:.5
						            	}]
						    		},{
						    			xtype: 'containerfield',
						            	label: '납기일',
						            	items:[{
						            		xtype: 'datepickerfield',//'datepickerfield',
								            name: 'DVRY_DATE_FR',
								            flex:.5
						            	},{
						            		xtype: 'datepickerfield',//'datepickerfield',
								            name: 'DVRY_DATE_TO',
								            flex:.5
						            	}]
						            },{
						    			xtype: 'selectfield',
						            	name: 'ORDER_TYPE',
						            	label: '판매유형',
						            	options:[
						            		{value:"",text:""}
						            		,{value:"10",text:"내수정상판매"}
						            		,{value:"21",text:"내수DEMO판매"}
						            		,{value:"22",text:"내수RENT판매"}
						            		,{value:"30",text:"내수A/S판매"}
						            		,{value:"40",text:"직수출(LC)"}
						            		,{value:"50",text:"로컬수출(LC)"}
						            		,{value:"60",text:"직수출(비LC)"}
						            		,{value:"70",text:"로컬수출(비LC)"}
						            		,{value:"90",text:"수출DEMO판매"}
						            		,{value:"91",text:"수출RENT판매"}
						            		,{value:"92",text:"수출A/S판매"}
						            		,{value:"99",text:"수정세금계산서 계약해제"}
						            	]
						            },{
						    			xtype: 'selectfield',
						            	name: 'ORDER_PRSN',
						            	label: '영업담당',
						            	options:[
						            		{value:"",text:""}
						            		,{value:"01",text:"조중현"}
						            		,{value:"04",text:"이동선"}
						            		,{value:"05",text:"박종선"}
						            		,{value:"06",text:"홍승태"}
						            		,{value:"07",text:"김광순"}
						            		,{value:"08",text:"김동섭"}
						            		,{value:"09",text:"이영종"}
						            	]
						            },{
						    			xtype: 'containerfield',
						            	label: '부서',
						            	items:[{
						            		xtype: 'textfield',//'datepickerfield',
								            name: 'DEPT',
								            flex:.3
						            	},{
						            		xtype: 'textfield',//'datepickerfield',
								            name: 'DEPT_NAME',
								            flex:.7
						            	}]
						            }]
				        },{
			            	xtype:'component',
			            	flex:1,
			            	style: {
		    					'background-color': '#fff'
		    				},
			            	html:'<div></div>'
			            }],
			            bbar:[{
			    			xtype: 'button',
			    			flex:1,
			            	text: '조회',
			            	handler:function()	{
			            		directMasterStore.loadStoreRecords();
			            		var subView = Ext.getCmp('masterView');
						 		var view = Ext.getCmp('muduleList2');
						 		//view.setTitle('수주현황')
						 		view.push(subView);
						 		/*view.push({ xtype:'dataview',
					 				layout:{type:'vbox', align:'stretch'},
					 				itemId:'sof100skrvlist',
					 				flex:{grow:1, shrink:1},
					 				items:[masterView]
					 			});*/

						 		view.getNavigationBar().setTitle('수주현황');
			            	}
			            }]
			});

			/**
			 * Master Model
			 */
			 Ext.define('sof100skrvModel', {
				extend:'Ext.data.Model',
				fields: [
					{name: 'DVRY_DATE1'				,text:'납기일'		,type:'date',convert:dateToString},
					{name: 'DVRY_TIME1'				,text:'납기시간'		,type:'string'},
					{name: 'ITEM_CODE'		 		,text:'품목코드' 		,type:'string'},
					{name: 'ITEM_NAME'		 		,text:'품목명' 		,type:'string'},
					{name: 'CUSTOM_CODE1'		 	,text:'거래처코드'		,type:'string'},
					{name: 'CUSTOM_NAME1'		 	,text:'거래처명' 		,type:'string'},
					{name: 'SPEC'			 		,text:'규격' 			,type:'string'},
					{name: 'ORDER_UNIT'		 		,text:'단위' 			,type:'string', displayField: 'value'},
					{name: 'PRICE_TYPE'		 		,text:'단가구분' 		,type:'string'},
					{name: 'TRANS_RATE'		 		,text:'입수' 			,type:'string'},
					{name: 'ORDER_UNIT_Q'	 		,text:'수주량' 		,type:'number'},
					{name: 'ORDER_WGT_Q'	 		,text:'수주량(중량)' 	,type:'number'},
					{name: 'ORDER_VOL_Q'	 		,text:'수주량(부피)' 	,type:'number'},
					{name: 'STOCK_UNIT'		 		,text:'재고단위' 		,type:'string', displayField: 'value'},
					{name: 'STOCK_Q'		 		,text:'재고단위수주량' 	,type:'number'},
					{name: 'MONEY_UNIT'		 		,text:'화폐' 			,type:'string'},
					{name: 'ORDER_P'		 		,text:'단가' 			,type:'number'},
					{name: 'ORDER_WGT_P'	 		,text:'단가(중량)' 	,type:'number'},
					{name: 'ORDER_VOL_P'	 		,text:'단가(부피)' 	,type:'number'},
					{name: 'ORDER_O'		 		,text:'수주액' 		,type:'number'},
					{name: 'EXCHG_RATE_O'	 		,text:'환율' 			,type:'number'},
					{name: 'SO_AMT_WON'		 		,text:'환산액' 		,type:'number'},
					{name: 'TAX_TYPE'		 		,text:'과세여부' 		,type:'string', comboType:'AU', comboCode:'B050'},
					{name: 'ORDER_TAX_O'	 		,text:'세액' 			,type:'number'},
					{name: 'WGT_UNIT'		 		,text:'중량단위' 		,type:'string'},
					{name: 'UNIT_WGT'		 		,text:'단위중량' 		,type:'string'},
					{name: 'VOL_UNIT'		 		,text:'부피단위' 		,type:'string'},
					{name: 'UNIT_VOL'		 		,text:'단위부피' 		,type:'string'},
					{name: 'CUSTOM_CODE2'	 		,text:'거래처코드' 	,type:'string'},
					{name: 'CUSTOM_NAME2'	 		,text:'거래처명' 		,type:'string'},
					{name: 'ORDER_DATE'		 		,text:'수주일' 		,type:'date',convert:dateToString},
					{name: 'ORDER_TYPE'		 		,text:'판매유형' 		,type:'string',comboType:"AU", comboCode:"S002"},
					{name: 'ORDER_TYPE_NM'	 		,text:'판매유형' 		,type:'string'},
					{name: 'ORDER_NUM'		 		,text:'수주번호' 		,type:'string'},
					{name: 'SER_NO'			 		,text:'순번' 			,type:'integer'},
					{name: 'ORDER_PRSN'		 		,text:'영업담당' 		,type:'string',comboType:"AU", comboCode:"S010"},
					{name: 'ORDER_PRSN_NM'	 		,text:'영업담당' 		,type:'string'},
					{name: 'PO_NUM'			 		,text:'P/O NO' 		,type:'string'},
					{name: 'DVRY_DATE2'		 		,text:'납기일' 		,type:'date',convert:dateToString},
					{name: 'DVRY_TIME'		 		,text:'납기시간' 		,type:'date'},
					{name: 'DVRY_CUST_NM'	 		,text:'배송처' 		,type:'string'},
					{name: 'PROD_END_DATE'	 		,text:'생산완료요청일' 	,type:'date',convert:dateToString},
					{name: 'PROD_Q'			 		,text:'생산요청량' 	,type:'number'},
					{name: 'ORDER_STATUS'	 		,text:'마감' 			,type:'string',comboType:"AU", comboCode:"S011"},
					{name: 'REMARK'					,text:'비고'			,type:'string'},
					{name: 'SORT_KEY'		 		,text:'SORTKEY' 	,type:'string'},
					{name: 'CREATE_LOC'		 		,text:'CREATE_LOC' 	,type:'string'}
				]
			});
			function dateToString(v, record){
				return v;
			 }
			/**
			 * Master Store
			 */
			var directMasterStore = Ext.create('Ext.data.Store',{

					storeId:'sof100skrvMasterStore',
					proxy: {
			            type: 'direct',
			            api: {
			                read: 'sof100skrvService.selectList1'
			            }
			        },
					model: 'sof100skrvModel',
		           	autoLoad: false
		        	,loadStoreRecords : function()	{
						var param= panelSearch.getValues();
						this.load({
								params : param,
								callback : function(records, operation, success) {
									if(success)	{

									}
								}
							}
						);

					}
			});
				masterView = Ext.create('Ext.dataview.List', {
					 		height:'100%',
						 	//xtype:'list',
						 	id:'masterView',
					    	store : directMasterStore,
					    	width:'100%',
					    	itemTpl: [//수주번호, 수주일, 거래처명(코드), 품목명(코드), 단위, 수주량, 단가(화폐), 수주액
					            '<div class="top"><div>수주번호:{ORDER_NUM}<br/>' +
					            '					  수주일:{ORDER_DATE}<br/>' +
					            '					  거래처:{CUSTOM_NAME1}({CUSTOM_CODE1})<br/>' +
					            '					  품목:{ITEM_NAME}({ITEM_CODE})<br/>' +
					            '					  단위:{ORDER_UNIT}<br/>' +
					            '					  수주량:{ORDER_UNIT_Q}<br/>' +
					            '					  단가:{ORDER_P}({MONEY_UNIT})<br/>' +
					            '					  수주액:{ORDER_O}({MONEY_UNIT})</div></div>'
					        ],
					        listeners:{
					        	itemtap : function( dataView , index , target , record , e , eOpts ) {
					        		/*var itemView =  Ext.create('Ext.Container', itemViewConf);
					        		itemView.setRecord(record);
					        		dataView.up('#navView').push(itemView);*/

					        	},
					        	hide : function(dataView)	{
					        		panelSearch.hide();
					        	},
					        	show : function(dataView)	{
					        		panelSearch.show();
					        	}
					        }

					 });
				Ext.define('sof100ukrvDetailModel', {
					extend:'Ext.data.Model',
				    fields: [
						{name: 'ITEM_CODE'        		, type: 'string', allowBlank: false},
						{name: 'ITEM_NAME'        		, type: 'string'},
						{name: 'ORDER_Q'    	    	, type: 'number', allowBlank: false, defaultValue: 0},
						{name: 'ORDER_P'    	    	, type: 'number', allowBlank: false , defaultValue: 0},
						{name: 'ORDER_O'    	    	, type: 'number', allowBlank: false , defaultValue: 0}

					]
				});
				var directDetailStore = Ext.create('Ext.data.Store',{

					storeId:'sof100skrvMasterStore',
					/*proxy: {
			            type: 'direct',
			            api: {
			                read: 'sof100ukrvService.selectDetailList'
			            }
			        },*/
					data:[{'ITEM_CODE':'I00001','ITEM_NAME':'ITEM1','ORDER_Q':10, 'ORDER_P':3000, 'ORDER_O':30000},
					{'ITEM_CODE':'I00002','ITEM_NAME':'ITEM2','ORDER_Q':10, 'ORDER_P':3000, 'ORDER_O':30000},
					{'ITEM_CODE':'I00003','ITEM_NAME':'ITEM3','ORDER_Q':11, 'ORDER_P':1000, 'ORDER_O':11000},
					{'ITEM_CODE':'I00004','ITEM_NAME':'ITEM4','ORDER_Q':12, 'ORDER_P':1000, 'ORDER_O':12000},
					{'ITEM_CODE':'I00005','ITEM_NAME':'ITEM5','ORDER_Q':13, 'ORDER_P':1000, 'ORDER_O':13000},
					{'ITEM_CODE':'I00006','ITEM_NAME':'ITEM6','ORDER_Q':14, 'ORDER_P':1000, 'ORDER_O':14000},
					{'ITEM_CODE':'I00007','ITEM_NAME':'ITEM7','ORDER_Q':15, 'ORDER_P':1000, 'ORDER_O':15000},
					{'ITEM_CODE':'I00008','ITEM_NAME':'ITEM8','ORDER_Q':16, 'ORDER_P':1000, 'ORDER_O':16000},
					{'ITEM_CODE':'I00009','ITEM_NAME':'ITEM9','ORDER_Q':17, 'ORDER_P':1000, 'ORDER_O':17000},
					{'ITEM_CODE':'I00010','ITEM_NAME':'ITEM10','ORDER_Q':18, 'ORDER_P':1000, 'ORDER_O':18000}],

					model: 'sof100ukrvDetailModel',
		           	autoLoad: false
		        	,loadStoreRecords : function()	{
						var param= panelSearch.getValues();
						this.load({
								params : param,
								callback : function(records, operation, success) {
									if(success)	{

									}
								}
							}
						);

					}
			});

			var detailGrid = Ext.create('Ext.grid.Grid', {
			    store: directDetailStore,
			    columns: [
			        { text: '품목',  dataIndex: 'ITEM_NAME', width: '30%' },
			        { text: '수량', dataIndex: 'ORDER_Q', width: '20%' },
			        { text: '단가', dataIndex: 'ORDER_P', width: '20%' },
			         { text: '금액', dataIndex: 'ORDER_O', width: '30%'}
			    ],
				height:200,
			    layout: 'fit',
			    listeners:{
			    	selectionchange:function(view, records, eOpts)	{
			    		if(records && records.length > 0)	{
			    			detailForm = view.up().down('#detailItem');
			    			detailForm.show();
			    			detailForm.setValues(records[0].data);
			    			detailForm.focus();
			    		}else {
			    			detailForm.getForm().reset();
			    		}
			    	}
			    }
			});
			   regForm = Ext.create('Ext.form.Panel', {
						id:'regForm',
						itemId: 'regForm',
						flex:1,
						layout: {type: 'vbox', align: 'stretch'},
						scrollable :'y',
						items: [ {
							xtype:'panel',
					        title:'기본정보',
							collapsible :'top',
							scrollable :false,
							height:'100%',
							layout: {type: 'vbox', align: 'stretch'},
							items:[{
					            xtype: 'fieldset',
					            items: [
					                	{
							    			xtype: 'selectfield',
							            	name: 'DIV_CODE',
							            	label: '사업장',
							            	options:[
							            		{text:'포렌인더스트리', value:'01'}
							            	]
							            },{
							    			xtype: 'datepickerfield',
							    			label: '수주일',
							            	name: 'ORDER_DATE'
							    		},{
							    			xtype: 'containerfield',
							            	label: '거래처',
							            	items:[{
							            		xtype: 'textfield',//'datepickerfield',
									            name: 'CUSTOM_CODE',
									            flex:.3
							            	},{
							            		xtype: 'textfield',//'datepickerfield',
									            name: 'CUSTOM_NAME',
									            flex:.7
							            	}]
							            },{
							    			xtype: 'containerfield',
							            	label: '부서',
							            	items:[{
							            		xtype: 'textfield',//'datepickerfield',
									            name: 'DEPT',
									            flex:.3
							            	},{
							            		xtype: 'textfield',//'datepickerfield',
									            name: 'DEPT_NAME',
									            flex:.7
							            	}]
							            },{
							    			xtype: 'selectfield',
							            	name: 'ORDER_PRSN',
							            	label: '영업담당',
							            	options:[
							            		{value:"",text:""}
							            		,{value:"01",text:"조중현"}
							            		,{value:"04",text:"이동선"}
							            		,{value:"05",text:"박종선"}
							            		,{value:"06",text:"홍승태"}
							            		,{value:"07",text:"김광순"}
							            		,{value:"08",text:"김동섭"}
							            		,{value:"09",text:"이영종"}
							            	]
							            },{
							    			xtype: 'selectfield',
							            	name: 'ORDER_TYPE',
							            	label: '판매유형',
							            	options:[
							            		{value:"",text:""}
							            		,{value:"10",text:"내수정상판매"}
							            		,{value:"21",text:"내수DEMO판매"}
							            		,{value:"22",text:"내수RENT판매"}
							            		,{value:"30",text:"내수A/S판매"}
							            		,{value:"40",text:"직수출(LC)"}
							            		,{value:"50",text:"로컬수출(LC)"}
							            		,{value:"60",text:"직수출(비LC)"}
							            		,{value:"70",text:"로컬수출(비LC)"}
							            		,{value:"90",text:"수출DEMO판매"}
							            		,{value:"91",text:"수출RENT판매"}
							            		,{value:"92",text:"수출A/S판매"}
							            		,{value:"99",text:"수정세금계산서 계약해제"}
							            	]
							            },{
							    			xtype: 'selectfield',
							            	name: 'BILL_TYPE',
							            	label: '부가세유형',
							            	options:[
							            		{value:"",text:""}
							            		,{value:"10",text:"과세매출"}
							            		,{value:"20",text:"영수증매출"}
							            		,{value:"30",text:"금전등록매출"}
							            		,{value:"40",text:"카드매출"}
							            		,{value:"50",text:"영세매출"}
							            		,{value:"60",text:"직수출"}
							            	]
							            },{
							    			xtype: 'containerfield',
							            	label: '세액포함여부',
							            	items:[{
							            		xtype: 'radiofield',
									            name: 'TAX_INOUT',
									            boxLabelAlign :'after',
									            boxLabel:'별도',
									            value:'1',
									            flex:.5
							            	},{
							            		xtype: 'radiofield',
									            name: 'TAX_INOUT',
									            boxLabelAlign :'after',
									            boxLabel:'포함',
									            value:'2',
									            flex:.5
							            	}]
							            },{
							            		xtype: 'textareafield',
									            name: 'REMARK',
									            lable:'비고',
									             maxRows: 4
							            }]
					        }]

						}, {
							xtype:'panel',
					        title:'기타정보',
							collapsible :'top',
							scrollable :false,
							height:'100%',
							layout: {type: 'vbox', align: 'stretch'},
								items:[{
					            xtype: 'fieldset',
					            items: [
					                	{
							    			xtype: 'textfield',
							            	name: 'PROJECT_NO',
							            	label: '관리번호',
							            	options:[
							            		{text:'포렌인더스트리', value:'01'}
							            	]
							            },{
							    			xtype: 'containerfield',
							            	label: '매출처',
							            	items:[{
							            		xtype: 'textfield',//'datepickerfield',
									            name: 'SALE_CUST_CD',
									            flex:.3
							            	},{
							            		xtype: 'textfield',//'datepickerfield',
									            name: 'SALE_CUST_NM',
									            flex:.7
							            	}]
							            },{
							    			xtype: 'selectfield',
							            	name: 'RECEIPT_SET_METH',
							            	label: '결제방법',
							            	options:[
							            		{value:"",text:""}
							            		,{value:"100",text:"현금"}
							            		,{value:"200",text:"어음"}
							            	]
							            },{
							    			xtype: 'numberfield',
							            	name: 'ORDER_O',
							            	label: '수주액'
							            },{
							    			xtype: 'numberfield',
							            	name: 'ORDER_O',
							            	label: '부가세액'
							            },{
							    			xtype: 'numberfield',
							            	name: 'ORDER_O',
							            	label: '수주총액'
							            },{
							    			xtype: 'numberfield',
							            	name: 'ORDER_O',
							            	label: '여신잔액'
							            }]
								}]
					       },
					       {
								xtype:'panel',
								heigth:400,
						        title:'상세정보',
								collapsible :'top',
								scrollable :false,
								layout: {type: 'vbox', align: 'stretch'},
								items:[detailGrid,
									{
										xtype:'formpanel',
							            itemId:'detailItem',
										collapsible :false,
										scrollable :false,
										hidden:true,
										height:'100%',
										layout: {type: 'vbox', align: 'stretch'},
											items:[{
									            xtype: 'fieldset',
									            items: [
									                	{
											    			xtype: 'containerfield',
											            	label: '품목',
											            	items:[{
											            		xtype: 'textfield',//'datepickerfield',
													            name: 'ITEM_CODE',
													            flex:.3
											            	},{
											            		xtype: 'textfield',//'datepickerfield',
													            name: 'ITEM_NAME',
													            flex:.7
											            	}]
											            },{
											    			xtype: 'numberfield',
											            	name: 'ORDER_O',
											            	label: '수량'
											            },{
											    			xtype: 'numberfield',
											            	name: 'ORDER_P',
											            	label: '단가'
											            },{
											    			xtype: 'numberfield',
											            	name: 'ORDER_Q',
											            	label: '금액'
											            }]
										}]
									}]
							}],
			          bbar:[{
			    			xtype: 'button',
			    			width:'100%',
			            	text: '저장',
			            	handler:function()	{}
			            }]
			});
			var mainApp = Ext.create('Ext.Container', {
					layout:{type:'vbox', align:'stretch'},
					flex:{grow:1, shrink:1},

					//height:500,
            		items:[{
	            		xtype:'navigationview',
	            		width:'100%',
	            		height:'100%',

	            		itemId:'muduleList2',
	            		id:'muduleList2',
	            		flex:{grow:1, shrink:1},
	            		navigationBar:{
	            			items:[{
				                    xtype: 'button',
				                    id: 'customBackButton',
				                    text: 'Back',
				                    align: 'left',
				                    handler:function()	{
				                    	Ext.Viewport.add(treeList);
				                    	Ext.Viewport.setActiveItem(treeList);

				                    }
				                },
	            				{
				                    xtype: 'button',
				                    id: 'registButton',
				                    text: '등록',
				                    align: 'right',
				                    handler:function()	{
				                    	var navView = mainApp.down('#muduleList2');
								 		//navView.push(panelSearch);
								 		navView.push({ xtype:'container',
								 				id:'regView',
								 				itemId:'regView',
								 				layout:{type:'vbox', align:'stretch'},
								 				flex:{grow:1, shrink:1},
								 				items:[regForm]
								 		});
								 		var regBtn = Ext.getCmp('registButton');
								 		navView.getNavigationBar().remove(regBtn);
								 		navView.getNavigationBar().setTitle('수주등록');
				                    }
				                }
	            			]
	            		},
	            		items:[
	            			{ xtype:'container',
	            					title:'수주현황',
					 				id:'formview',
					 				itemId:'searchForm',
					 				layout:{type:'vbox', align:'stretch'},
					 				flex:{grow:1, shrink:1},
					 				items:[panelSearch]
					 		}
	            		],
	            		listeners:{
	            			back:function()	{
		 						var regBtn = Ext.getCmp('registButton');
		 						var navView = Ext.getCmp('muduleList2');
		 						console.log("navView activItem", navView.getActiveItem().getItemId());
		 						var cItemId = navView.getActiveItem().getItemId();
		 						if(regBtn && cItemId && cItemId !='searchForm' && cItemId !='sof100skrvList' ) navView.getNavigationBar().remove(regBtn);

	            			},
	            			activeItemchange:function ( sender, value, oldValue, eOpts )	{
	            				var cBackBtn = Ext.getCmp('customBackButton');
	            				if(value && value.getItemId() == 'searchForm')	{

	            					cBackBtn.show();
	            				}else {
	            					cBackBtn.hide();
	            				}
	            			}
	            		}

	            		}]});
				main = Ext.create('Ext.Container', {
		            layout:{type:'vbox', align:'stretch'},
		            flex:{grow:1, shrink:1},
		            height:'100%',
		            //fullscreen: true,
		            items: [mainApp]
	            });
	            //Ext.Viewport.add(main);
        }
		} ) ;


	});
</script>

</head>
<body id="ext-body">
</body>
</html>
