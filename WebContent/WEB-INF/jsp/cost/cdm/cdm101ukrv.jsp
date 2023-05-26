<%@page language="java" contentType="text/html; charset=utf-8"%>
<%@ page import="foren.framework.utils.*" %>
<%
	String extjsVersion = ConfigUtil.getString("extjs.version", "4.2.2");
	request.setAttribute("ext_root", "extjs_"+extjsVersion);
%>
<t:appConfig pgmId="cdm100ukrv"  >
	<t:ExtComboStore comboType="BOR120"/> 				<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="CD03" />	<!-- 원가담당자 -->	
	<t:ExtComboStore comboType="AU" comboCode="CC05" />	<!-- 재료비적용단가 -->	
	<t:ExtComboStore comboType="AU" comboCode="C101" />	<!-- 간접재료비 배부유형 -->	
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >
function appMain() {
	function numberFormat(value) {
		return Ext.util.Format.number(value,UniFormat.Price);
	}
	Unilite.defineModel('Cdm101skrvModel1', {
	    fields: [ 
	    	{name: 'col1',		text: '구분',		type: 'string'},
	    	{name: 'col2',		text: '비목',		type: 'string'},
	    	{name: 'col3',		text: '금액',		type: 'uniPrice', convert:numberFormat}
		]
	});
	//부문	부문금액	보조배부금액	합계
	Unilite.defineModel('Cdm101skrvModel2', {
	    fields: [  	 
	    	{name: 'col1',		text: '부문',		type: 'string'},
	    	{name: 'col2',		text: '부문',		type: 'string'},
	    	{name: 'col3',		text: '부문금액',		type: 'uniPrice', convert:numberFormat},
	    	{name: 'col4',		text: '보조배부금액',		type: 'uniPrice', convert:numberFormat},
	    	{name: 'col5',		text: '합계',		    type: 'uniPrice', convert:numberFormat},
	    	{name: 'g1',		text: '구분별순번',		    type: 'int'}
	    	
		]
	}); //품목	직접비	간접비	합계
	Unilite.defineModel('Cdm101skrvModel3', {
	    fields: [  	 
	    	{name: 'col1',		text: '구분',		type: 'string'},
	    	{name: 'col2',		text: '품목',		type: 'string'},
	    	{name: 'col3',		text: '직접비',		type: 'uniPrice', convert:numberFormat},
	    	{name: 'col4',		text: '간접비',		    type: 'uniPrice', convert:numberFormat},
	    	{name: 'col5',		text: '합계',	type: 'uniPrice', convert:numberFormat},
	    	{name: 'g1',		text: '구분별순번',		    type: 'int'}
		]
	});
	Unilite.defineModel('Cdm101skrvModel4', {
	    fields: [  	 
	    	{name: 'col1',		text: '입고구분',		type: 'string'},
	    	{name: 'col2',		text: '입고구분',		type: 'string'},
	    	{name: 'col3',		text: '품목코드',		type: 'uniQty'},
	    	{name: 'col4',		text: '품명',		    type: 'uniQty'},
	    	{name: 'col5',		text: '생산입고수량',	type: 'uniQty'}
		]
	});
	
	var directMasterStore1 = Unilite.createStore('cdm101skrvMasterStore1',{
		model: 'Cdm101skrvModel1',
		uniOpt : {
        	isMaster  : true,
        	editable  : false,
        	deletable : false,
            useNavi   : false	
        },
        autoLoad: false,
        /*proxy: {
            type: 'direct',
            api: {			
                read: 'cdm101skrvService.selectList1'                	
            }
        },*/
		loadStoreRecords : function()	{
			
		},
		data:[
			{col1:'직접비', col2:'재료비', col3:1000},
			{col1:'직접비', col2:'노무비', col3:0},
			{col1:'직접비', col2:'경비', col3:0},
			{col1:'직접비', col2:'소계', col3:1000},
			{col1:'간접비', col2:'재료비', col3:500},
			{col1:'간접비', col2:'노무비', col3:200},
			{col1:'간접비', col2:'경비', col3:100},
			{col1:'간접비', col2:'소계', col3:800},
			{col1:'', col2:'합계', col3:1800}
		]/*,
		groupField:'col1'*/
	});
	var directMasterStore2 = Unilite.createStore('cdm101skrvMasterStore2',{
		model: 'Cdm101skrvModel2',
		uniOpt : {
        	isMaster  : true,
        	editable  : false,
        	deletable : false,
            useNavi   : false	
        },
        autoLoad: false,
        /*proxy: {
            type: 'direct',
            api: {			
                read: 'cdm101skrvService.selectList1'                	
            }
        },
		loadStoreRecords : function()	{
			
		}*/
		data:[
			{'col1':'제조부문',col2:'제1제조부문',col3:300 ,col4:150 ,col5:450 ,g1:1},
			{'col1':'제조부문',col2:'제2제조부문',col3:300 ,col4:50 ,col5:350 ,g1:2},
			{'col1':'제조부문',col2:'소계',col3:600 ,col4:200 ,col5:800 ,g1:3},
			{'col1':'보조부문',col2:'갑보조부문',col3:100 ,col4:0 ,col5:0 ,g1:1},
			{'col1':'보조부문',col2:'을보조부문',col3:100 ,col4:0 ,col5:0 ,g1:2},
			{'col1':'보조부문',col2:'소계',col3:200 ,col4:0 ,col5:0 ,g1:3},
			{'col1':'',col2:'합계',col3:800 ,col4:200 ,col5:800 ,g1:100}
		]
	});
	var directMasterStore3 = Unilite.createStore('cdm101skrvMasterStore3',{
		model: 'Cdm101skrvModel3',
		uniOpt : {
        	isMaster  : true,
        	editable  : false,
        	deletable : false,
            useNavi   : false	
        },
        autoLoad: false,
        /*proxy: {
            type: 'direct',
            api: {			
                read: 'cdm101skrvService.selectList1'                	
            }
        },
		loadStoreRecords : function()	{
			
		}*/
		data:[
			{'col1':'완제품','col2':'노트', 'col3':400, 'col4':450, 'col5':850,g1:1},
			{'col1':'완제품','col2':'-', 'col3':0, 'col4':0, 'col5':0,g1:2},
			{'col1':'완제품','col2':'-', 'col3':0, 'col4':0, 'col5':0,g1:2},
			{'col1':'완제품','col2':'-', 'col3':0, 'col4':0, 'col5':0,g1:2},
			{'col1':'완제품','col2':'-', 'col3':0, 'col4':0, 'col5':0,g1:2},
			{'col1':'완제품','col2':'-', 'col3':0, 'col4':0, 'col5':0,g1:2},
			{'col1':'완제품','col2':'-', 'col3':0, 'col4':0, 'col5':0,g1:2},
			{'col1':'완제품','col2':'-', 'col3':0, 'col4':0, 'col5':0,g1:2},
			{'col1':'완제품','col2':'-', 'col3':0, 'col4':0, 'col5':0,g1:2},
			{'col1':'완제품','col2':'-', 'col3':0, 'col4':0, 'col5':0,g1:2},
			{'col1':'완제품','col2':'소계', 'col3':400, 'col4':450, 'col5':850,g1:2},
			{'col1':'제공품','col2':'포장', 'col3':600, 'col4':350, 'col5':950,g1:1},
			{'col1':'제공품','col2':'-', 'col3':0, 'col4':0, 'col5':0,g1:2},
			{'col1':'제공품','col2':'-', 'col3':0, 'col4':0, 'col5':0,g1:2},
			{'col1':'제공품','col2':'-', 'col3':0, 'col4':0, 'col5':0,g1:2},
			{'col1':'제공품','col2':'-', 'col3':0, 'col4':0, 'col5':0,g1:2},
			{'col1':'제공품','col2':'-', 'col3':0, 'col4':0, 'col5':0,g1:2},
			{'col1':'제공품','col2':'-', 'col3':0, 'col4':0, 'col5':0,g1:2},
			{'col1':'제공품','col2':'-', 'col3':0, 'col4':0, 'col5':0,g1:2},
			{'col1':'제공품','col2':'-', 'col3':0, 'col4':0, 'col5':0,g1:2},
			{'col1':'제공품','col2':'-', 'col3':0, 'col4':0, 'col5':0,g1:2},
			{'col1':'제공품','col2':'소계', 'col3':600, 'col4':350, 'col5':950,g1:2},
			{'col1':'','col2':'합계', 'col3':1000, 'col4':800, 'col5':1800,g1:2}
		]
	});
	
	var directMasterStore4 = Unilite.createStore('cdm101skrvMasterStore4',{
		model: 'Cdm101skrvModel1',
		uniOpt : {
        	isMaster  : true,
        	editable  : false,
        	deletable : false,
            useNavi   : false	
        },
        autoLoad: false,
        proxy: {
            type: 'direct',
            api: {			
                read: 'cdm101skrvService.selectList1'                	
            }
        },
		loadStoreRecords : function()	{
			
		}
	});
	var directMasterStore5 = Unilite.createStore('cdm101skrvMasterStore5',{
		model: 'Cdm101skrvModel2',
		uniOpt : {
        	isMaster  : true,
        	editable  : false,
        	deletable : false,
            useNavi   : false	
        },
        autoLoad: false,
        proxy: {
            type: 'direct',
            api: {			
                read: 'cdm101skrvService.selectList1'                	
            }
        },
		loadStoreRecords : function()	{
			
		}
	});
	var directMasterStore6 = Unilite.createStore('cdm101skrvMasterStore6',{
		model: 'Cdm101skrvModel3',
		uniOpt : {
        	isMaster  : true,
        	editable  : false,
        	deletable : false,
            useNavi   : false	
        },
        autoLoad: false,
       proxy: {
            type: 'direct',
            api: {			
                read: 'cdm101skrvService.selectList1'                	
            }
        },
		loadStoreRecords : function()	{
			
		}
	});
	
	/**
	 * 작업조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createForm('cdm101ukrv', {		
		disabled: false,
		region:'north',
		padding:'10 0 5 0',
		style:{'background-color':'#FFF'},
		layout: {type: 'uniTable', columns: 2, tdAttrs: {valign:'top'}},
	    items: [{
			name: 'DIV_CODE',
			fieldLabel: '사업장',
			xtype: 'uniCombobox',
      		comboType: 'BOR120',
      		value: UserInfo.divCode,
      		hidden: false,
      		allowBlank: false,
      		maxLength: 20,
      		width:230
		},{
			name: 'WORK_MONTH',
		 	fieldLabel: '조회년월',
		 	xtype: 'uniMonthfield',
		  	value: UniDate.get('startOfMonth'),
		  	hidden: false,
		  	allowBlank: false,
		  	maxLength: 200,
      		width:230
		}]
	});	
	
	var costPanel1 = Unilite.createForm('cdm101ukrvCostPanel1', {		
		disabled: false,
		title:'원가계산',
		padding:0,
		width:270,
		height:"50%",
		scrollable:false,
		layout: {type: 'uniTable', columns: 1, tdAttrs: {valign:'top'}},
	    items: [{
			name: 'DIV_CODE',
			fieldLabel: '사업장',
			xtype: 'uniCombobox',
      		comboType: 'BOR120',
      		value: UserInfo.divCode,
      		hidden: false,
      		allowBlank: false,
      		maxLength: 20,
      		width:230
		},{ 
	 		name: 'COST_PRSN', 
	 		fieldLabel: '원가담당자',
	 		xtype: 'uniCombobox',
	 		comboType: 'AU',
	 		comboCode: 'CD03',
	 		allowBlank: true,
      		width:230
        },{
			name: 'WORK_MONTH',
		 	fieldLabel: '기준월',
		 	xtype: 'uniMonthfield',
		  	value: UniDate.get('startOfMonth'),
		  	hidden: false,
		  	allowBlank: false,
		  	maxLength: 200,
      		width:230
		},{ 
	 		name: 'APPLY_UNIT', 
	 		fieldLabel: '적용단가',
	 		xtype: 'uniCombobox',
		  	value: '02',
	 		comboType: 'AU',
	 		comboCode: 'CC05',
	 		allowBlank: false,
      		width:230
		},{ 
	 		name: 'DIST_KIND', 
	 		fieldLabel: '간접비배부유형',
	 		xtype: 'uniCombobox',
		  	value: '01',
	 		comboType: 'AU',
	 		comboCode: 'C101',
	 		allowBlank: false,
      		width:230
		},{
			fieldLabel: '원가계산이력',
			xtype: 'radiogroup',		            		
			id: 'rdoSelect',
			layout:{type:'vbox', align:'stretch'},
			items: [{
				boxLabel: '예(작업회수 추가)', 
				width: 150, 
				name: 'DEL_OPTION',
	    		inputValue: '01'
			},{
				boxLabel: '아니오(이전계산내역삭제)', 
				width: 200,
				name: 'DEL_OPTION',
	    		inputValue: '02',
				checked: true  
			}]
		},{
			xtype: 'container',
	    	padding: '10 0 30 0',
	    	layout: {
	    		type: 'hbox',
				align: 'center',
				pack:'center'
	    	},
		    items: [{
				xtype: 'button',
		    	text: '실행',
		    	width: 60,
				handler: function() {
//					if(panelSearch.setAllFieldsReadOnly(true)){
						var param = panelSearch.getValues();

						console.log("param",param)

//						param.LANG_TYPE		= 'ko';												//언어구분
//						param.CALL_PATH		= 'Batch';											//호출경로(Batch, List)
//						param.BILL_PUB_NUM	= '';												//계산서번호/계산서발행번호
//						param.KEY_VALUE		= '';												//KEY 문자열
						
						panelSearch.getEl().mask('로딩중...','loading-indicator');
						cdm100ukrvService.procButton(param, 
							function(provider, response) {
								if(provider) {	
									UniAppManager.updateStatus("원가계산이 완료되었습니다.");
								}
								console.log("response",response)
								panelSearch.getEl().unmask();
							}
						)
					
//						return panelSearch.setAllFieldsReadOnly(true);
//					}
				}
		    }]
		}]
	})
	var costPanel2 = Unilite.createForm('cdm101ukrvCostPanel2', {		
		disabled: false,
		title:'원가마감',
		padding:0,
		width:300,
		height:"50%",
		layout: {type: 'uniTable', columns: 1, tdAttrs: {valign:'top'}},
	    items: [{
			name: 'DIV_CODE',
			fieldLabel: '사업장',
			xtype: 'uniCombobox',
      		comboType: 'BOR120',
      		value: UserInfo.divCode,
      		hidden: false,
      		allowBlank: false,
      		maxLength: 20,
      		width:230
		},{ 
	 		name: 'COST_PRSN', 
	 		fieldLabel: '원가담당자',
	 		xtype: 'uniCombobox',
	 		comboType: 'AU',
	 		comboCode: 'CD03',
	 		allowBlank: true,
      		width:230
        },{
			name: 'WORK_MONTH',
		 	fieldLabel: '기준월',
		 	xtype: 'uniMonthfield',
		  	value: UniDate.get('startOfMonth'),
		  	hidden: false,
		  	allowBlank: false,
		  	maxLength: 200,
      		width:230
		},{
			xtype: 'container',
	    	padding: '10 0 30 0',
	    	layout: {
	    		type: 'hbox',
				align: 'center',
				pack:'center'
	    	},
		    items: [{
				xtype: 'button',
		    	text: '마감',
		    	width: 60,
				handler: function() {}
		    }]
		}]
	});
	var masterGrid1 = Unilite.createGrid('cdm200skrvGrid1', {
        layout : 'fit',
        flex:.3,
        region:'west',
        title  : '비목별집계(직접비,간접비)',
        uniOpt:{
			expandLastColumn: false,
			useRowNumberer: false,		//번호 컬럼 사용 여부		
			useGroupSummary: true,		//그룹핑 버튼 사용 여부
			state: {
				useState: false,			//그리드 설정 버튼 사용 여부
				useStateList: false		//그리드 설정 목록 사용 여부
			},
			onLoadSelectFirst: false,
			userToolbar :true
		},
        features: [{
        	id: 'masterGridSubTotal', 
        	ftype: 'uniGroupingsummary', 
        	showSummaryRow: true 
        },{
        	id: 'masterGridTotal', 	
        	ftype: 'uniSummary', 	 
        	showSummaryRow: true
        }],
    	store: directMasterStore1,
        columns: [  
        	{ dataIndex: 'col1',    	width: 80,
        	    summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			        return "<div align='right'>소계</div>"
                }
            },
        	{ dataIndex: 'col2',    	flex:1},
        	{ dataIndex: 'col3',    	width: 100, summaryType:'sum',
        	    summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
        	    	console.log("summaryData : ",summaryData);
        	    	console.log("metaData : ",metaData);
        	    	
        	    	var color = metaData.record.get("col1") == "간접비" ? "#FCE4D6":"#70AD47";
        	    	metaData.tdStyle = "background-color:"+color+";";
			        return Ext.util.Format.number(value,UniFormat.Price);
                }
            }
          ] 
    });
    var masterGrid2 = Unilite.createGrid('cdm200skrvGrid2', {
        layout : 'fit',
        region:'center',
        flex:.4,
        title  : '부문별 집계(간접비 부문별로 집계)',
        uniOpt:{
			expandLastColumn: false,
			useRowNumberer: false,		//번호 컬럼 사용 여부		
			useGroupSummary: true,		//그룹핑 버튼 사용 여부
			state: {
				useState: false,			//그리드 설정 버튼 사용 여부
				useStateList: false		//그리드 설정 목록 사용 여부
			},
			onLoadSelectFirst: false,
			userToolbar :true
		},
        features: [{
        	id: 'masterGridSubTotal2', 
        	ftype: 'uniGroupingsummary', 
        	showSummaryRow: true 
        },{
        	id: 'masterGridTotal2', 	
        	ftype: 'uniSummary', 	 
        	showSummaryRow: true
        }],
    	store: directMasterStore2,
        columns: [  
        	{ dataIndex: 'col1',    	width: 86},
        	{ dataIndex: 'col2',    	width: 120},
        	{ dataIndex: 'col3',    	width: 150},
        	{ dataIndex: 'col4',    	width: 166},
        	{ dataIndex: 'col5',    	width: 66}
          ] 
    });
    var masterGrid3 = Unilite.createGrid('cdm200skrvGrid3', {
        layout : 'fit',
        flex:1,
        region:'center',
        title  : '제품별 집계(직접비,간접비 제품별로 집계)',
        uniOpt:{
			expandLastColumn: false,
			useRowNumberer: false,		//번호 컬럼 사용 여부		
			useGroupSummary: true,		//그룹핑 버튼 사용 여부
			state: {
				useState: false,			//그리드 설정 버튼 사용 여부
				useStateList: false		//그리드 설정 목록 사용 여부
			},
			onLoadSelectFirst: false,
			userToolbar :false
		},
        features: [{
        	id: 'masterGridSubTotal3', 
        	ftype: 'uniGroupingsummary', 
        	showSummaryRow: true
        },{
        	id: 'masterGridTotal3', 	
        	ftype: 'uniSummary', 	 
        	showSummaryRow: true ,
        	dock :'bottom'
        }],
    	store: directMasterStore3,
        columns: [  
        	{ dataIndex: 'col1',    	width: 100,
			 summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
		              	return Unilite.renderSummaryRow(summaryData, metaData, '합계', '총계');
	                    }
	         },
        	{ dataIndex: 'col2',    	width: 150 },
        	{ dataIndex: 'col3',    	width: 150, summaryType:'sum',
			  summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			 	if(!metaData.record.ownerGroup) {
	          	  	metaData.tdStyle='background-color:#A0C07B !important';
			 	}
	          	return Ext.util.Format.number(value,UniFormat.Price);
              }
	         },
        	{ dataIndex: 'col4',    	width: 150, summaryType:'sum',
			  summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			 	if(!metaData.record.ownerGroup) {
	              	  metaData.tdStyle='background-color:#EFE4B0 !important';
			 	}
	              	  return Ext.util.Format.number(value,UniFormat.Price);;
              }
             },
        	{ dataIndex: 'col5',    	width: 150, summaryType:'sum',
			 summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			 	if(!metaData.record.ownerGroup) {
	              	  metaData.tdStyle='background-color:#F2A36D !important';
			 	}
	         	return Ext.util.Format.number(value,UniFormat.Price);;
             }
        	}
          ] 
    });
	
    var masterGrid1Template = new Ext.XTemplate(
	     '<div style="width:85%; margin-left:7%; margin-right:8%;height:40px;">',
	    '	<div style="margin-top:10px; padding-top:5px; margin-bottom:10px;font-size:10pt;font-weight:bold;color: #04408c;border-top: #c3c3c3 solid 5px;">비목별집계(직접비,간접비)</div>',
	    '</div>',
	    '<table cellspacing="0" cellpadding="4" style="width:85%; margin-left:7%; margin-right:8%;" >' ,
	    	'<tr style="">',
	    		'<th width="150"  style="background-color:#DDEBF7;border-top: #c3c3c3 solid 2px;border-bottom: #c3c3c3 solid 1px;" >구&nbsp;&nbsp;&nbsp;&nbsp;분</th>',
	    		'<th width="180"  style="background-color:#DDEBF7;border-top: #c3c3c3 solid 2px;border-bottom: #c3c3c3 solid 1px;">비&nbsp;&nbsp;&nbsp;&nbsp;목</th>',
	    		'<th width="150"  style="background-color:#DDEBF7;border-top: #c3c3c3 solid 2px;border-bottom: #c3c3c3 solid 1px;">금&nbsp;&nbsp;&nbsp;&nbsp;액</th>',
	    	'</tr>',
	    '<tpl for=".">' ,
	    	'<tpl if="col2 != \'소계\' && col2 != \'합계\'">',
		    	'<tr class="data-source" style="background-color:#eeeded;border-bottom: #c3c3c3 solid 1px;">',
		    		'<td width="150" style="background-color:#FFF;border-bottom: #c3c3c3 solid 1px;padding-left:10px;">{col1}</td>',
		    		'<td width="180" style="background-color:#FFF;border-bottom: #c3c3c3 solid 1px;">{col2}</td>',
		    		'<td width="150" style="background-color:#FFF;border-bottom: #c3c3c3 solid 1px;text-align:right;padding-right:10px;">{col3}</td>',
		    	'</tr>',
	    	'</tpl>',
	    	'<tpl if="col2 == \'소계\'">',
		    	'<tr class="data-source" style="background-color:#eeeded;">',
		    		'<td width="150" style="border-bottom: #c3c3c3 solid 1px;">&nbsp;</td>',
		    		'<td width="180" style="background-color:#eeeded;border-bottom: #c3c3c3 solid 1px;text-align:right;">{col2} : </td>',
		    		'<tpl if="col1 == \'직접비\'">',
		    		'<td width="150" style="background-color:#A0C07B;text-align:right;padding-right:10px" >{col3}</td>',
		    		'</tpl>',
		    		'<tpl if="col1 == \'간접비\'">',
		    		'<td width="150" style="background-color:#EFE4B0;text-align:right;padding-right:10px" >{col3}</td>',
		    		'</tpl>',
		    	'</tr>',
	    	'</tpl>',
	    	'<tpl if="col2 == \'합계\'">',
		    	'<tr class="data-source" style="background-color:#c3c3c3;">',
		    		'<td width="150" style="border-bottom: #c3c3c3 solid 2px;">&nbsp;</td>',
		    		'<td width="180" style="border-bottom: #c3c3c3 solid 2px;text-align:right;">{col2} : </td>',
		    		'<td width="150" style="background-color:#F2A36D;text-align:right;padding-right:10px;border-bottom: #c3c3c3 solid 2px;" >{col3}</td>',
		    	'</tr>',
	    	'</tpl>',
        '</tpl>' ,
        '</table>',
        '<div style="width:85%; margin-left:7%; margin-right:8%;height:35px;">',
	    '	<div style="margin-top:20px; margin-bottom:10px;font-size:10pt;font-weight:bold;color: #04408c;text-align:right">노무비/경비 집계기준 보기</div>',
	    '</div>'
	);
	var masterView1 = Ext.create('Ext.view.View', {
    	width:500,
    	height:365,
        autoScroll:true,
		tpl: masterGrid1Template,
        store: directMasterStore1,
        itemSelector: 'tr.data-source'  ,      
    	style:{'background-color':'#fff'}
    });
    var masterGrid2Template = new Ext.XTemplate(
    	 '<div style="width:85%; margin-left:7%; margin-right:8%;height:40px;">',
	    '	<div style="margin-top:10px; padding-top:5px; margin-bottom:10px;font-size:10pt;font-weight:bold;color: #04408c;border-top: #c3c3c3 solid 5px;">부문별 집계(간접비 부문별로 집계)</div>',
	    '</div>',
	    '<table cellspacing="0" cellpadding="4" style="width:85%; margin-left:7%; margin-right:8%;height:35px;" >' ,
	    	'<tr style="">',//부문	부문금액	보조배부금액	합계
	    		'<th width="120"  style="background-color:#DDEBF7;border-top: #c3c3c3 solid 2px;border-bottom: #c3c3c3 solid 1px;" >부&nbsp;&nbsp;&nbsp;&nbsp;문</th>',
	    		'<th width="100"  style="background-color:#DDEBF7;border-top: #c3c3c3 solid 2px;border-bottom: #c3c3c3 solid 1px;">부&nbsp;문&nbsp;금&nbsp;액</th>',
	    		'<th width="100"  style="background-color:#DDEBF7;border-top: #c3c3c3 solid 2px;border-bottom: #c3c3c3 solid 1px;">보조배부금액</th>',
	    		'<th width="100"  style="background-color:#DDEBF7;border-top: #c3c3c3 solid 2px;border-bottom: #c3c3c3 solid 1px;">합&nbsp;&nbsp;&nbsp;&nbsp;계</th>',
	    	'</tr>',
	    '<tpl for=".">' ,
	    	'<tpl if="g1 == 1 ">',
	    		'<tr style="background-color:#fff;border-bottom: #c3c3c3 solid 1px;">',
		    		'<td colspan="4" style="text-align:left;background-color:#FFF;border-bottom: #c3c3c3 solid 1px;"><strong>+{col1}</strong></td>',
		    	'</tr>',
	    	'</tpl>',
	    	'<tpl if="col2 != \'소계\' && col2 != \'합계\'">',
		    	'<tr class="data-source" style="background-color:#eeeded;border-bottom: #c3c3c3 solid 1px;">',
		    		'<td style="background-color:#FFF;border-bottom: #c3c3c3 solid 1px;padding-left:10px;">{col2}</td>',
		    		'<td style="background-color:#FFF;border-bottom: #c3c3c3 solid 1px;text-align:right;margin-left:5px;">{col3}</td>',
		    		'<td style="background-color:#FFF;border-bottom: #c3c3c3 solid 1px;text-align:right;margin-left:5px;">{col4}</td>',
		    		'<td style="background-color:#FFF;border-bottom: #c3c3c3 solid 1px;text-align:right;margin-left:5px;padding-right:10px;">{col5}</td>',
		    	'</tr>',
	    	'</tpl>',
	    	'<tpl if="col2 == \'소계\'">',
		    	'<tr class="data-source" style="background-color:#eeeded;">',
		    		'<td style="border-bottom: #c3c3c3 solid 1px;text-align:right;">{col2} : </td>',
		    		'<td style="background-color:#eeeded;border-bottom: #c3c3c3 solid 1px;;text-align:right;margin-left:5px;">{col3}</td>',
		    		'<td style="background-color:#eeeded;text-align:right;margin-left:5px;border-bottom: #c3c3c3 solid 1px;" >{col4}</td>',
		    		'<tpl if="col1 == \'제조부문\'">',
		    		'<td style="background-color:#EFE4B0;text-align:right;margin-left:5px;padding-right:10px;border-bottom: #c3c3c3 solid 1px;" >{col5}</td>',
		    		'</tpl>',
		    		'<tpl if="col1 != \'제조부문\'">',
		    		'<td style="background-color:#eeeded;text-align:right;margin-left:5px;padding-right:10px;border-bottom: #c3c3c3 solid 1px;" >{col5}</td>',
		    		'</tpl>',
		    	'</tr>',
	    	'</tpl>',
	    	'<tpl if="col2 == \'합계\'">',
		    	'<tr class="data-source" style="background-color:#c3c3c3;">',
		    		'<td style="background-color:#c3c3c3;;text-align:right;margin-left:5px;border-bottom: #c3c3c3 solid 2px;">{col2} : </td>',
		    		'<td style="background-color:#EFE4B0;text-align:right;margin-left:5px;border-bottom: #c3c3c3 solid 2px;">{col3}</td>',
		    		'<td style="background-color:#c3c3c3;;text-align:right;margin-left:5px;border-bottom: #c3c3c3 solid 2px;" >{col4}</td>',
		    		'<td style="background-color:#c3c3c3;;text-align:right;margin-left:5px;border-bottom: #c3c3c3 solid 2px;padding-right:10px;" >{col5}</td>',
		    	'</tr>',
	    	'</tpl>',
        '</tpl>' ,
        '</table>',
        '<div style="width:85%; margin-left:7%; margin-right:8%;height:35px;">',
	    '	<div style="margin-top:20px; margin-bottom:10px;font-size:10pt;font-weight:bold;color: #04408c;text-align:right;">보조부문 -> 제조부문으로 배부 기준 보기</div>',
	    '</div>'

	);
	var masterView2 = Ext.create('Ext.view.View', {
    	width: 500,
    	height:"100%",
    	style:{'background-color':'#fff'},
        autoScroll:true,
		tpl: masterGrid2Template,
        store: directMasterStore2,
        itemSelector: 'tr.data-source'
        /*,
        itemSelector: 'div.data-source'*/
        
    });
    var masterGrid3Template = new Ext.XTemplate(
    	 '<div style="width:85%; margin-left:7%; margin-right:8%;height:40px;">',
	    '	<div style="margin-top:10px; padding-top:5px; margin-bottom:10px;font-size:10pt;font-weight:bold;color: #04408c;border-top: #c3c3c3 solid 5px;">제품별 집계(직접비,간접비 제품별로 집계)</div>',
	    '</div>',
	    '<table cellspacing="0" cellpadding="4" style="width:85%; margin-left:7%; margin-right:8%;height:35px;" >' ,
	    	'<tr style="">',//부문	부문금액	보조배부금액	합계
	    		'<th width="120"  style="background-color:#DDEBF7;border-top: #c3c3c3 solid 2px;border-bottom: #c3c3c3 solid 1px;" >품&nbsp;&nbsp;&nbsp;&nbsp;목</th>',
	    		'<th width="100"  style="background-color:#DDEBF7;border-top: #c3c3c3 solid 2px;border-bottom: #c3c3c3 solid 1px;">직&nbsp;접&nbsp;비</th>',
	    		'<th width="100"  style="background-color:#DDEBF7;border-top: #c3c3c3 solid 2px;border-bottom: #c3c3c3 solid 1px;">간&nbsp;접&nbsp;비</th>',
	    		'<th width="100"  style="background-color:#DDEBF7;border-top: #c3c3c3 solid 2px;border-bottom: #c3c3c3 solid 1px;">합&nbsp;&nbsp;&nbsp;&nbsp;계</th>',
	    	'</tr>',
	    '<tpl for=".">' ,
	    	'<tpl if="g1 == 1 ">',
	    		'<tr style="background-color:#fff;border-bottom: #c3c3c3 solid 1px;">',
		    		'<td colspan="4" style="text-align:left;background-color:#FFF;border-bottom: #c3c3c3 solid 1px;"><strong>+{col1}</strong></td>',
		    	'</tr>',
	    	'</tpl>',
	    	'<tpl if="col2 != \'소계\' && col2 != \'합계\'">',
		    	'<tr class="data-source" style="background-color:#eeeded;border-bottom: #c3c3c3 solid 1px;">',
		    		'<td style="background-color:#FFF;border-bottom: #c3c3c3 solid 1px;padding-left:10px;">{col2}</td>',
		    		'<td style="background-color:#FFF;border-bottom: #c3c3c3 solid 1px;text-align:right;margin-left:5px;">{col3}</td>',
		    		'<td style="background-color:#FFF;border-bottom: #c3c3c3 solid 1px;text-align:right;margin-left:5px;">{col4}</td>',
		    		'<td style="background-color:#FFF;border-bottom: #c3c3c3 solid 1px;text-align:right;margin-left:5px;padding-right:10px;">{col5}</td>',
		    	'</tr>',
	    	'</tpl>',
	    	'<tpl if="col2 == \'소계\'">',
		    	'<tr class="data-source" style="background-color:#eeeded;">',
		    		'<td style="border-bottom: #c3c3c3 solid 1px;text-align:right;">{col2} : </td>',
		    		'<td style="background-color:#eeeded;border-bottom: #c3c3c3 solid 1px;;text-align:right;margin-left:5px;">{col3}</td>',
		    		'<td style="background-color:#eeeded;text-align:right;margin-left:5px;border-bottom: #c3c3c3 solid 1px;" >{col4}</td>',
		    		'<td style="background-color:#eeeded;text-align:right;margin-left:5px;border-bottom: #c3c3c3 solid 1px;padding-right:10px;" >{col5}</td>',
		    	'</tr>',
	    	'</tpl>',
	    	'<tpl if="col2 == \'합계\'">',
		    	'<tr class="data-source" style="background-color:#c3c3c3;">',
		    		'<td style="background-color:#c3c3c3;text-align:right;margin-left:5px;border-bottom: #c3c3c3 solid 2px;">{col2} : </td>',
		    		'<td style="background-color:#A0C07B;text-align:right;margin-left:5px;border-bottom: #c3c3c3 solid 2px;">{col3}</td>',
		    		'<td style="background-color:#EFE4B0;;text-align:right;margin-left:5px;border-bottom: #c3c3c3 solid 2px;" >{col4}</td>',
		    		'<td style="background-color:#F2A36D;text-align:right;margin-left:5px;border-bottom: #c3c3c3 solid 2px;padding-right:10px;" >{col5}</td>',
		    	'</tr>',
	    	'</tpl>',
        '</tpl>' ,
        '</table>'

	);
	var masterView3 = Ext.create('Ext.view.View', {
    	flex:1,
    	region:'center',
    	style:{'background-color':'#fff'},
        autoScroll:true,
		tpl: masterGrid3Template,
        store: directMasterStore3,
        itemSelector: 'tr.data-source'
        /*,
        itemSelector: 'div.data-source'*/
        
    });
    var detailGrid1 = Unilite.createGrid('detailGrid1', {
        layout : 'fit',
        flex:.3,
        title  : '비목별 집계',
        uniOpt:{
			expandLastColumn: false,
			useRowNumberer: false,		//번호 컬럼 사용 여부		
			useGroupSummary: true,		//그룹핑 버튼 사용 여부
			state: {
				useState: false,			//그리드 설정 버튼 사용 여부
				useStateList: false		//그리드 설정 목록 사용 여부
			},
			onLoadSelectFirst: false,
			userToolbar :true
		},
        features: [{
        	id: 'masterGridSubTotal', 
        	ftype: 'uniGroupingsummary', 
        	showSummaryRow: true 
        },{
        	id: 'masterGridTotal', 	
        	ftype: 'uniSummary', 	 
        	showSummaryRow: true
        }],
    	store: directMasterStore4,
        columns: [  
        	{ dataIndex: 'col1',    	width: 100},
        	{ dataIndex: 'col2',    	width: 100},
        	{ dataIndex: 'col3',    	width: 100}
          ] 
    });
    var detailGrid2 = Unilite.createGrid('detailGrid2', {
        layout : 'fit',
        flex:.5,
        title  : '부문별 집계',
        uniOpt:{
			expandLastColumn: false,
			useRowNumberer: false,		//번호 컬럼 사용 여부		
			useGroupSummary: true,		//그룹핑 버튼 사용 여부
			state: {
				useState: false,			//그리드 설정 버튼 사용 여부
				useStateList: false		//그리드 설정 목록 사용 여부
			},
			onLoadSelectFirst: false,
			userToolbar :true
		},
        features: [{
        	id: 'masterGridSubTotal2', 
        	ftype: 'uniGroupingsummary', 
        	showSummaryRow: true 
        },{
        	id: 'masterGridTotal2', 	
        	ftype: 'uniSummary', 	 
        	showSummaryRow: true
        }],
    	store: directMasterStore5,
        columns: [  
        	{ dataIndex: 'col1',    	width: 100},
        	{ dataIndex: 'col2',    	width: 100},
        	{ dataIndex: 'col3',    	width: 100},
        	{ dataIndex: 'col4',    	width: 100}
          ] 
    });
    var detailGrid3 = Unilite.createGrid('cdm200skrvDetailGrid3', {
        layout : 'fit',
        flex:.5,
        title  : '제품별 집계',
        uniOpt:{
			expandLastColumn: false,
			useRowNumberer: false,		//번호 컬럼 사용 여부		
			useGroupSummary: true,		//그룹핑 버튼 사용 여부
			state: {
				useState: false,			//그리드 설정 버튼 사용 여부
				useStateList: false		//그리드 설정 목록 사용 여부
			},
			onLoadSelectFirst: false,
			userToolbar :true
		},
        features: [{
        	id: 'masterGridSubTotal3', 
        	ftype: 'uniGroupingsummary', 
        	showSummaryRow: true 
        },{
        	id: 'masterGridTotal3', 	
        	ftype: 'uniSummary', 	 
        	showSummaryRow: true
        }],
    	store: directMasterStore6,
        columns: [  
        	{ dataIndex: 'col1',    	width: 100},
        	{ dataIndex: 'col2',    	width: 100},
        	{ dataIndex: 'col3',    	width: 100},
        	{ dataIndex: 'col4',    	width: 100},
        	{ dataIndex: 'col5',    	width: 100}
          ] 
    });
    var westContainer = {
    	xtype:'panel',
		region:'west',
		title:'작업실행',
		collapsible :true,
		collapseDirection : 'left',
		collapsed :true,
		width:300,
    	layout: {type:'vbox', align:'stretch'} ,
		items:[
			costPanel1, 
			costPanel2
		]
	}
    var centerContainer = {
    	xtype:'panel',
    	region:'center',
    	layout: 'border' ,
    	style:{'background-color':'#FFF'},
    	flex:1,
    	//title:'작업결과보기',
    	flex:1,
		items:[
			panelSearch,
			{
				xtype:'container',				
    			region:'west',
    			layout:{type:'vbox', align:'stretch'},
    			items:[
					masterView1,
					masterView2
				]
			},
			masterView3
			//masterGrid1,
			//masterGrid2,
			//masterGrid3
		]
	}
	var eastContainer = {
    	xtype:'panel',
    	region:'east',
    	layout: {type:'vbox', align:'stretch'} ,
    	title:'상세보기',
		collapsible :true,
		collapseDirection : 'right', 
		width:500,
		items:[
			detailGrid1,
			detailGrid2,
			detailGrid3
		]
	}
	/* 원가계산 */
    Unilite.Main( {
		id: 'cdm100ukrvApp',
		borderItems: [ westContainer, centerContainer, eastContainer],
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons(['detail', 'query', 'reset'], false);
		}
    });

};
</script>