<%@page language="java" contentType="text/html; charset=utf-8"%>
<%@ page import="foren.framework.utils.*" %>
<%
	String extjsVersion = ConfigUtil.getString("extjs.version", "4.2.2");
	request.setAttribute("ext_root", "extjs_"+extjsVersion);
%>
<t:appConfig pgmId="cam110ukrv"  >
	<t:ExtComboStore comboType="BOR120"/> 				<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="CD03" />	<!-- 원가담당자 -->
	<t:ExtComboStore comboType="AU" comboCode="CC05" />	<!-- 재료비적용단가 -->
	<t:ExtComboStore comboType="AU" comboCode="C101" />	<!-- 간접재료비 배부유형 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
.cam100-td {
	background-color:#FFF;
	border-bottom: #c3c3c3 solid 1px;
}
.outer-container1 {
	position: absolute;	
	top: 0;
	left: 20px;
	right: 20px;
	bottom:80px;
	overflow: visible;
}
.inner-container1 {
	width: 100%;
	height: 100%;
	position: relative;
}
#headerdiv1.table-header {
	float:left;
	width: 100%;
	overflow:hidden;
}
#bodydiv1.table-body {
	float:left;
	height: 210px;
	width: inherit;
	overflow-y: auto;
	overflow-x: hidden;
	padding-right: 0px;
}
#footerdiv1.table-footer {
	float:left;
	width: 100%;
	overflow-y: hidden;
	overflow-x: auto;
}
#headerdiv2.table-header {
	float:left;
	width: 100%;
	overflow:hidden;
}
#bodydiv2.table-body {
	float:left;
	height: 190px;
	width: inherit;
	overflow-y: auto;
	overflow-x: hidden;
	padding-right: 0px;
}
#footerdiv2.table-footer {
	float:left;
	width: 100%;
	overflow-y: hidden;
	overflow-x: auto;
}
</style>
<script type="text/javascript" >
var costPoolCode = ${COST_POOL_LIST};
var nProduct = ${NUM_PRODUCT};
var nSupport = ${NUM_SUPPORT};
var nProductDiv=nProduct;
var nSupportDiv=nSupport;
var yearEvaluationYN = '${YEAR_EVALUATION_YN}';
var frMonth = '${FR_MONTH}';

var lastWorkInfo = ${lastWorkInfo}; //원가 최종 계산 정보
var lastCloseInfo = ${lastCloseInfo}; //원가 최종 마감 정보



function appMain() {
	function numberFormat(value) {
		return Ext.util.Format.number(value,UniFormat.Price);
	}
	
	function countCostPool(divCode)	{
		if(!divCode)	{
			divCode = Ext.isEmpty(panelSearch.getValue("DIV_CODE")) ? UserInfo.divCode : panelSearch.getValue("DIV_CODE");
		}
		var tmpProductDiv = 0;
		var tmpSupportDiv = 0;
		Ext.each(costPoolCode, function(costPool)	{
			if(divCode == costPool.DIV_CODE)	{
				if(costPool.ALLOCATION_YN == "Y")	{
					tmpProductDiv++;
				}
				if(costPool.ALLOCATION_YN == "N")	{
					tmpSupportDiv++
				}
			}
		})
		if(tmpProductDiv!=0) {
			nProductDiv = tmpProductDiv;
		} else {
			nProductDiv = nProduct;
		}
		if(tmpSupportDiv!=0) {
			nSupportDiv = tmpSupportDiv;
		} else {
			nSupportDiv = nSupport;
		}
					
	}
	countCostPool(UserInfo.divCode);
	
	Unilite.defineModel('cam110ukrvModel1', {
		fields: [ 
			{name: 'ID_GB_NAME',		text: '구분',		type: 'string'},
			{name: 'COST_GB_NAME',		text: '비목',		type: 'string'},
			{name: 'AMT',				text: '금액',		type: 'uniPrice', convert:numberFormat}
		]
	});
	//부문	부문금액	보조배부금액	합계
	Unilite.defineModel('cam110ukrvModel2', {
		fields: [  	 
			{name: 'ID_GB_NAME',		text: '구분',		type: 'string'},
			{name: 'COST_GB_NAME',		text: '비목',		type: 'string'},
			{name: 'AMT',				text: '금액',		type: 'uniPrice', convert:numberFormat}
			
		]
	}); //품목	직접비	간접비	합계
	
	
	var directMasterStore1 = Unilite.createStore('cam110ukrvMasterStore1',{
		model: 'cam110ukrvModel1',
		uniOpt : {
			isMaster  : false,
			editable  : false,
			deletable : false,
			useNavi   : false	
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {			
				read: 'cam110ukrvService.selectIDGb'
			}
		},
		loadStoreRecords : function()	{
			if(!costPoolCode || costPoolCode.length == 0)	{
        		alert("등록된 부문이 없습니다.")
        		return;
        	} else {
        		var checkCnt = 0
        		Ext.each(costPoolCode , function(item){
        			if(item.DIV_CODE == panelSearch.getValue("DIV_CODE"))	{
        				checkCnt = 1;
        			}
        		})
        		if(checkCnt == 0)	{
        			alert("해당 사업장에 등록된 부문이 없습니다.")
        			return;
        		}
        	}
			var param= panelSearch.getValues();	
			countCostPool(panelSearch.getValue("DIV_CODE"));
			if(panelSearch.isValid())	{
				console.log("param", param);
				/*this.loadData([
						 {"COST_GB_NAME":"재료비","ID_GB_NAME":"직접비","SEQ":"1","AMT":0}
						,{"COST_GB_NAME":"노무비","ID_GB_NAME":"","SEQ":"2","AMT":0}
						,{"COST_GB_NAME":"경비","ID_GB_NAME":"","SEQ":"3","AMT":0}
						,{"COST_GB_NAME":"소계","ID_GB_NAME":"직접비","SEQ":"4","AMT":0}
						,{"COST_GB_NAME":"재료비","ID_GB_NAME":"간접비","SEQ":"5","AMT":0}
						,{"COST_GB_NAME":"노무비","ID_GB_NAME":"","AMT":0.0000,"SEQ":"6"}
						,{"COST_GB_NAME":"경비","ID_GB_NAME":"","AMT":0.0000,"SEQ":"7"}
						,{"COST_GB_NAME":"소계","ID_GB_NAME":"간접비","AMT":0.0000,"SEQ":"8"}
						,{"COST_GB_NAME":"합계","ID_GB_NAME":"직접비,간접비","AMT":0.0000,"SEQ":"9"}
					]);*/
				this.load({
					params : param,
					success:function()	{
						masterView1.refresh();
					}
				});
			}
		}
	});
	var directMasterStore2 = Unilite.createStore('cam110ukrvMasterStore2',{
		model: 'cam110ukrvModel2',
		uniOpt : {
			isMaster  : false,
			editable  : false,
			deletable : false,
			useNavi   : false	
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {			
				read: 'cam110ukrvService.selectProdItem'
			}
		},
		loadStoreRecords : function()	{
			if(!costPoolCode || costPoolCode.length == 0)	{
        		return;
        	} else {
        		var checkCnt = 0
        		Ext.each(costPoolCode , function(item){
        			if(item.DIV_CODE == panelSearch.getValue("DIV_CODE"))	{
        				checkCnt = 1;
        			}
        		})
        		if(checkCnt == 0)	{
        			return;
        		}
        	}
			var param= panelSearch.getValues();	
			countCostPool(panelSearch.getValue("DIV_CODE"));
			if(panelSearch.isValid())	{
				console.log("param", param);
				this.load({
					params : param,
					success:function()	{
						masterView1.refresh();
					}
				});
				/*this.loadData([
						 {"COST_GB_NAME":"재료비","ID_GB_NAME":"직접비","SEQ":"1","AMT":0}
						,{"COST_GB_NAME":"노무비","ID_GB_NAME":"","SEQ":"2","AMT":0}
						,{"COST_GB_NAME":"경비","ID_GB_NAME":"","SEQ":"3","AMT":0}
						,{"COST_GB_NAME":"소계","ID_GB_NAME":"직접비","SEQ":"4","AMT":0}
						,{"COST_GB_NAME":"재료비","ID_GB_NAME":"간접비","SEQ":"5","AMT":0}
						,{"COST_GB_NAME":"노무비","ID_GB_NAME":"","AMT":0.0000,"SEQ":"6"}
						,{"COST_GB_NAME":"경비","ID_GB_NAME":"","AMT":0.0000,"SEQ":"7"}
						,{"COST_GB_NAME":"소계","ID_GB_NAME":"간접비","AMT":0.0000,"SEQ":"8"}
						,{"COST_GB_NAME":"간접비 시간당 원가","ID_GB_NAME":"","AMT":0.0000,"SEQ":"9"}
						,{"COST_GB_NAME":"합계","ID_GB_NAME":"직접비,간접비","AMT":0.0000,"SEQ":"10"}
					]);*/
			}
		}
	});
	
	Unilite.defineModel('cam110ukrvMasterModel3', {
	    fields: [ 
	    	{name: 'COST_GB_SEQ',	text: '순서',		type: 'string'},
	    	{name: 'COST_GB',		text: '구분',		type: 'string'},
	    	{name: 'COST_CONTENT',	text: '항목',		type: 'string'},
	    	{name: 'STATE',			text: '상태',		type: 'string'},
	    	{name: 'REMARK1',		text: '참고사항',		type: 'string'},
	    	{name: 'REMARK2',		text: '참고사항',		type: 'string'}
		]
	});
	
	
	var directMasterStore3 = Unilite.createStore('cam110ukrvMasterModel3',{
		model: 'cam110ukrvMasterModel3',
		groupField : 'COST_GB',
		uniOpt : {
        	isMaster  : false,
        	editable  : false,
        	deletable : false,
            useNavi   : false	
        },
        autoLoad: false,
        proxy: {
            type: 'direct',
            api: {			
                read: 'cam110ukrvService.selectStatusList'                	
            }
        },
		loadStoreRecords : function()	{
			var searchForm = Ext.getCmp('statusForm');
			var param= searchForm.getValues();	
			if(searchForm.isValid())	{
				console.log("param", param);
				
				this.load({
					params : param
				});
			}
		}
	});
	/**
	 * 작업조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createForm('cam110ukrv', {
		disabled: false,
		region:'north',
		padding:'10 0 5 0',
		style:{'background-color':'#FFF'},
		layout: {type: 'uniTable', columns: 3, tdAttrs: {valign:'top'}},
		items: [{
			name: 'DIV_CODE',
			fieldLabel: '사업장',
			xtype: 'uniCombobox',
      		comboType: 'BOR120',
      		value: UserInfo.divCode,
      		hidden: false,
      		allowBlank: false,
      		maxLength: 20,
      		width:230,
      		listeners:{
      			change:function(field, newValue, oldValue)	{
					countCostPool(newValue);
      			}
      		}
		},{
			name: 'WORK_MONTH',
		 	fieldLabel: '조회년월',
		 	xtype: 'uniMonthfield',
		  	value: UniDate.get('startOfMonth'),
		  	hidden: false,
		  	allowBlank: false,
		  	maxLength: 200,
	  		width:230
		},{
			xtype : 'button',
			text  : '조회',
			width : 60,
			tdAttrs : { width : 120, align : 'right'},
			handler : function() {
				directMasterStore1.loadStoreRecords();
				directMasterStore2.loadStoreRecords();
			}
		}]
	});	
	
	var costPanel1 = Unilite.createForm('cam110ukrvCostPanel1', {
		disabled: false,
		title:'원가계산',
		collapsible :true,
		collapseDirection  : 'top',
		padding:0,
		width:270,
		height:245,
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
	  		width:270,
	  		labelWidth:120,
	  		listeners:{
	  			change:function(field, newValue, oldValue,eOpt)	{
	  				if(newValue!="" && newValue != oldValue){
		  				Ext.getBody().mask();
		  				costCommonService.selectDivYearEvaluation({'DIV_CODE':newValue}, function(reponseText, response){
		  					if(reponseText && reponseText.YEAR_EVALUATION_YN)	{
		  						yearEvaluationYN = reponseText.YEAR_EVALUATION_YN;
		  						frMonth = reponseText.FR_MONTH;	  						
		  						costPanel1.setValue("YEAR_EVALUATION_YN", yearEvaluationYN)
		  						
		  						var workDate = costPanel1.getValue("WORK_MONTH");
		  						var frYear = Ext.isDate(workDate) ? Ext.Date.format(workDate, "Y") : workDate.substring(0,4);
		  						
		  						var workMonthFrField = costPanel1.getField("WORK_MONTH_FR");
		  						if(yearEvaluationYN == 'Y' )	{
		  							workMonthFrField.setValue(frYear+frMonth)
		  							workMonthFrField.setReadOnly(false);
		  						} else {
		  							workMonthFrField.setValue(workDate)
		  							workMonthFrField.setReadOnly(true);
		  						}
		  						Ext.getBody().unmask();
		  						UniAppManager.app.getLastWorkInfo(newValue);
		  					}
		  				})
	  				}
	  			}
	  		}
		},{ 
	 		name: 'COST_PRSN', 
	 		fieldLabel: '원가담당자',
	 		xtype: 'uniCombobox',
	 		comboType: 'AU',
	 		comboCode: 'CD03',
	 		allowBlank: true,
	  		width:270,
	  		labelWidth:120
		},{
			name: 'WORK_MONTH_FR',
		 	fieldLabel: '작업년월(시작)',
		 	xtype: 'uniMonthfield',
		  	value: yearEvaluationYN == 'Y' ? Ext.Date.format(UniDate.today(), 'Y')+frMonth : UniDate.get('startOfMonth'),
		    readOnly : yearEvaluationYN == 'Y' ? false : true,
		  	hidden: false,
		  	allowBlank: false,
	  		width:270,
	  		labelWidth:120
		},{
			name: 'YEAR_EVALUATION_YN',
		 	fieldLabel: '년누적계산여부',
		  	value: yearEvaluationYN,
		  	hidden: true,
		  	allowBlank: false,
	  		width:270,
	  		labelWidth:120
		},{
			name: 'WORK_MONTH',
		 	fieldLabel: '기준월',
		 	xtype: 'uniMonthfield',
		  	value: UniDate.get('startOfMonth'),
		  	hidden: false,
	  		width:270,
	  		labelWidth:120,
	  		listeners:{
	  			blur:function(field, eOpt)	{
	  				if(yearEvaluationYN != 'Y' )	{
	  					if( field.isValid()){
	  						costPanel1.setValue("WORK_MONTH_FR", field.getValue());
	  					}
	  				}
	  			}
	  		}
		},{
			name: 'WORK_PERIOD',
		 	fieldLabel: '최종작업년월',
		  	readOnly:true,
		  	value : lastWorkInfo.WORK_PERIOD,
	  		width:270,
	  		labelWidth:120
		},{ 
	 		name: 'LAST_COST_PRSN', 
	 		fieldLabel: '최종작업자',
	 		readOnly:true,
	 		value : lastWorkInfo.COST_PRSN,
	  		width:270,
	  		labelWidth:120
		},{
			name: 'LAST_WORK_DATE',
		 	fieldLabel: '최종실행일',
	 		value : lastWorkInfo.UPDATE_DB_TIME,
	 		readOnly:true,
	  		width:270,
	  		labelWidth:120
		},{
			xtype: 'container',
			padding: '0 0 0 0',
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
					if(costPanel1.isValid())	{
						if(confirm('원가를 계산하시겠습니까?'))	{
							var param = costPanel1.getValues();
							Ext.getBody().mask('실행중...','loading-indicator');
							if(costPanel1.isValid()){
								cam110ukrvService.executeProcessCost(param, 
									function(provider, response) {
										Ext.getBody().unmask();
										if(provider) {	
											UniAppManager.updateStatus("원가계산이 완료되었습니다.");
											UniAppManager.app.getLastWorkInfo(costPanel1.getValue("DIV_CODE"));
										}
										console.log("response",response)
										
									}
								)
							}
						}
					}
				}
			}]
		}]
	})
	var costPanel2 = Unilite.createForm('cam110ukrvCostPanel2', {
		disabled: false,
		title:'원가마감',
		collapsible :true,
		collapseDirection  : 'top',
		padding:0,
		width:300,
		height:220,
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
	  		width:270,
	  		labelWidth:120,
	  		listeners:{
	  			change:function(field, newValue, oldValue){
	  				UniAppManager.app.getLastCloseInfo(newValue);
	  			}
	  		}
		},{ 
	 		name: 'COST_PRSN', 
	 		fieldLabel: '원가담당자',
	 		xtype: 'uniCombobox',
	 		comboType: 'AU',
	 		comboCode: 'CD03',
	 		allowBlank: true,
	  		width:270,
	  		labelWidth:120
		},{
			name: 'WORK_MONTH',
		 	fieldLabel: '기준월',
		 	xtype: 'uniMonthfield',
		  	value: UniDate.get('startOfMonth'),
		  	hidden: false,
		  	allowBlank: false,
	  		width:270,
	  		labelWidth:120
		},{
			name: 'LAST_WORK_MONTH',
		 	fieldLabel: '최종마감년월',
		 	xtype: 'uniMonthfield',
		  	readOnly:true,
	 		value : lastCloseInfo.WORK_MONTH,
	  		width:270,
	  		labelWidth:120
		},{ 
	 		name: 'LAST_COST_PRSN', 
	 		fieldLabel: '최종작업자',
	 		readOnly:true,
	 		value : lastCloseInfo.COST_PRSN,
	  		width:270,
	  		labelWidth:120
		},{
			name: 'LAST_WORK_DATE',
		 	fieldLabel: '최종실행일',
	 		readOnly:true,
	 		value : lastCloseInfo.UPDATE_DB_TIME,
	  		width:270,
	  		labelWidth:120
		},{
			xtype: 'container',
			padding: '0 0 0 0',
			layout: {
				type: 'hbox',
				align: 'center',
				pack:'center'
			},
			items: [{
				xtype: 'button',
				text: '마감',
				width: 60,
				handler: function() {
					if(costPanel2.isValid())	{
						if(confirm('원가마감을 진행하시겠습니까?'))	{
							var param = costPanel2.getValues();
							param.WORK_GUBUN = 'P';
							Ext.getBody().mask('실행중...','loading-indicator');
							cam110ukrvService.executeCloseCost(param, 
								function(provider, response) {
									Ext.getBody().unmask();
									if(provider) {	
										UniAppManager.updateStatus("원가 마감 처리 되었습니다.");
										UniAppManager.app.getLastCloseInfo(costPanel2.getValue("DIV_CODE"));
									}
									console.log("response",response);
								}
							)
						}
					}
				}
			},{xtype:'component', html:'&nbsp;&nbsp;&nbsp;&nbsp;'},{
				xtype: 'button',
				text: '취소',
				width: 60,
				handler: function() {
					if(costPanel2.isValid())	{
						if(confirm('원가마감을 취소하시겠습니까?'))	{
							var param = costPanel2.getValues();
							param.WORK_GUBUN = 'C';
							Ext.getBody().mask('실행중...','loading-indicator');
							cam110ukrvService.executeCloseCost(param, 
								function(provider, response) {
									if(provider) {	
										UniAppManager.updateStatus("원가 마감 취소 되었습니다.");
										UniAppManager.app.getLastCloseInfo(costPanel2.getValue("DIV_CODE"));
									}
									console.log("response",response)
									Ext.getBody().unmask();
								}
							)
						}
					}
				}
		    }]
		}]
	});
	
	var statusGrid = Unilite.createGrid('statusGrid', {
    	region : 'center',
        store : directMasterStore3, 
        selModel : 'rowmodel',
        layout :'fit',
        uniOpt :{
        	expandLastColumn	: false,
			useRowNumberer		: false,
			onLoadSelectFirst	: false,
			userToolbar			: false,
			useLoadFocus		: false		
        },
        features: [ {id : 'masterGridSubTotal2', ftype: 'uniGroupingsummary', showSummaryRow: false },
       		{id : 'masterGridTotal2', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
        columns:  [ 
        	{dataIndex  : 'COST_GB'        	, width: 70 , hidden :true },
        	{dataIndex  : 'COST_CONTENT'    , flex: 1},
        	{dataIndex  : 'STATE'        	, width: 55	},
        	{dataIndex  : 'REMARK1'         , width: 115	}
        ]
    });   
	
	var masterGrid1Template = new Ext.XTemplate(
		'<div class="outer-container1">',
		'<div style="margin-right:0px;height:40px;">',
		'	<div style="margin-top:10px; padding-top:5px; margin-bottom:10px;font-size:10pt;font-weight:bold;color: #04408c;border-top: #c3c3c3 solid 3px;">비목별집계(직접비,간접비)</div>',
		'</div>',
		
		'<div class="inner-container1">',
		'<div class="table-header" id="headerdiv1">',
	    '<table cellspacing="0" cellpadding="4" width="100%" style="margin-right:20px;" >' ,
	    	'<tr style="">',
	    		'<th width="150"  style="min-width:150px;background-color:#DDEBF7;border-top: #c3c3c3 solid 2px;border-bottom: #c3c3c3 solid 1px;" rowspan="2">구&nbsp;&nbsp;&nbsp;&nbsp;분</th>',
	    		'<th width="180"  style="min-width:180px;background-color:#DDEBF7;border-top: #c3c3c3 solid 2px;border-bottom: #c3c3c3 solid 1px;" rowspan="2">비&nbsp;&nbsp;&nbsp;&nbsp;목</th>',
	    		'<th width="180"  style="min-width:180px;background-color:#DDEBF7;border-top: #c3c3c3 solid 2px;border-bottom: #c3c3c3 solid 1px;" rowspan="2">계&nbsp;&nbsp;&nbsp;&nbsp;정</th>',
	    		'<th width="{[this.getProductWidth()]}"  style="background-color:#DDEBF7;border-top: #c3c3c3 solid 2px;border-left: #c3c3c3 solid 1px;border-right: #c3c3c3 solid 1px;" colspan="{[this.getCountProduct()]}">제조부문</th>',
	    		'<th width="{[this.getSupportWidth()]}"  style="background-color:#DDEBF7;border-top: #c3c3c3 solid 2px;"  colspan="{[this.getCountSupport()]}">보조부문</th>',
	    		'<th width="15%"  style="min-width:100px;background-color:#DDEBF7;border-top: #c3c3c3 solid 2px;border-bottom: #c3c3c3 solid 1px;border-left: #c3c3c3 solid 1px" rowspan="2">합&nbsp;&nbsp;&nbsp;&nbsp;계</th>',
	    	'</tr>',
	    	'<tr style="">',
	    		'<tpl for="this.COST_POOL()">',
	    			'<th width="150"  style="min-width:100px;background-color:#DDEBF7;border-top: #c3c3c3 solid 1px;border-left: #c3c3c3 solid 1px;border-bottom: #c3c3c3 solid 1px;">{COST_POOL_NAME}</th>',
	    		'</tpl>',
	    		//'<th width="180"  style="background-color:#DDEBF7;border-top: #c3c3c3 solid 1px;border-left: #c3c3c3 solid 1px;border-bottom: #c3c3c3 solid 1px;">혼합부문</th>',
	    		//'<th width="180"  style="background-color:#DDEBF7;border-top: #c3c3c3 solid 1px;border-bottom: #c3c3c3 solid 1px;">중진부문</th>',
	    		//'<th width="180"  style="background-color:#DDEBF7;border-top: #c3c3c3 solid 1px;border-right: #c3c3c3 solid 1px;border-bottom: #c3c3c3 solid 1px;">포장부문</th>',
	    		//'<th width="180"  style="background-color:#DDEBF7;border-top: #c3c3c3 solid 1px;border-right: #c3c3c3 solid 1px;border-bottom: #c3c3c3 solid 1px;">구매관리</th>',
	    	'</tr>',
	    '</table>',
	    '</div>',
	    '<div class="table-body" id="bodydiv1" >',
	    '<table cellspacing="0" cellpadding="4" width="100%" style="margin-right:0px;height:210px;" >' ,
	    '<tpl for=".">' ,
	    	'<tpl if="COST_GB_NAME != \'소계\' && ID_GB_NAME != \'합계\'">',
		    	'<tr class="data-source" style="background-color:#eeeded;border-bottom: #c3c3c3 solid 1px;height:20px;">',
		    		'<td width="150" class="cam100-td" style="min-width:150px;padding-left:10px;">{ID_GB_NAME}</td>',
		    		'<td width="180" style="min-width:180px;background-color:#FFF;border-bottom: #c3c3c3 solid 1px;">{COST_GB_NAME}</td>',
		    		'<td width="180" style="min-width:180px;background-color:#FFF;border-bottom: #c3c3c3 solid 1px;">{ACCNT_NAME}</td>',
		    		'<tpl for="this.COST_POOL()">',
		    		'<td width="150" style="min-width:100px;background-color:#FFF;border-bottom: #c3c3c3 solid 1px;text-align:right;padding-right:10px;">{[this.getName(parent,xindex)]}</td>',
					'</tpl>',
					'<td width="15%" style="min-width:100px;background-color:#FFF;border-bottom: #c3c3c3 solid 1px;text-align:right;padding-right:10px;">{[this.format(values.SUM_AMT)]}</td>',
		    	'</tr>',
	    	'</tpl>',
	    	'<tpl if="COST_GB_NAME == \'소계\'">',
		    	'<tr class="data-source" style="background-color:#eeeded;">',
		    		'<td width="150" style="min-width:150px;border-bottom: #c3c3c3 solid 1px;">&nbsp;</td>',
		    		'<td width="180" style="min-width:180px;border-bottom: #c3c3c3 solid 1px;">&nbsp;</td>',
		    		'<td width="180" style="min-width:180px;background-color:#eeeded;border-bottom: #c3c3c3 solid 1px;text-align:right;">{COST_GB_NAME} : </td>',
		    		'<tpl if="ID_GB_NAME == \'직접비\'">',
		    		'<tpl for="this.COST_POOL()">',
		    		'<td width="150" style="min-width:100px;background-color:#A0C07B;text-align:right;padding-right:10px" >{[this.getName(parent,xindex)]}</td>',
					'</tpl>',
					'<td width="15%" style="min-width:100px;background-color:#A0C07B;text-align:right;padding-right:10px" >{[this.format(values.SUM_AMT)]}</td>',
		    		'</tpl>',
		    		'<tpl if="ID_GB_NAME == \'간접비\'">',
		    		'<tpl for="this.COST_POOL()">',
		    		'<td width="150" style="min-width:100px;background-color:#EFE4B0;text-align:right;padding-right:10px" >{[this.getName(parent,xindex)]}</td>',
					'</tpl>',
					'<td width="15%" style="min-width:100px;background-color:#EFE4B0;text-align:right;padding-right:10px" >{[this.format(values.SUM_AMT)]}</td>',
		    		'</tpl>',
		    	'</tr>',
	    	'</tpl>',
	    	'<tpl if="ID_GB_NAME == \'합계\'">',
	    	'</table>',
	    	'</div>',
	    	'<div class="table-footer" id="footerdiv1" onscroll="document.getElementById(\'headerdiv1\').scrollLeft = this.scrollLeft;document.getElementById(\'bodydiv1\').scrollLeft = this.scrollLeft;">',
	    	'<table cellspacing="0" cellpadding="4" width="100%" style="margin-right:20px;height:25px;" >' ,
	    	'<tfoot>',
		    	'<tr class="data-source" style="background-color:#c3c3c3;">',
		    		'<td width="150" style="min-width:150px;border-bottom: #c3c3c3 solid 2px;">&nbsp;</td>',
		    		'<td width="180" style="min-width:180px;border-bottom: #c3c3c3 solid 2px;">&nbsp;</td>',
		    		'<td width="180" style="min-width:180px;border-bottom: #c3c3c3 solid 2px;text-align:right;">{ID_GB_NAME} : </td>',
		    		'<tpl for="this.COST_POOL()">',
		    		'<td width="150" style="min-width:100px;background-color:#F2A36D;text-align:right;padding-right:10px;border-bottom: #c3c3c3 solid 2px;" >{[this.getName(parent,xindex)]}</td>',
					'</tpl>',
					'<td width="15%" style="min-width:100px;background-color:#F2A36D;text-align:right;padding-right:10px;border-bottom: #c3c3c3 solid 2px;" >{[this.format(values.SUM_AMT)]}</td>',
		    	'</tr>',
		    '</tfoot>',
	    	'</tpl>',
        '</tpl>' ,
        '</table>',
        '</div>',
        '</div>',
        '</div>',
	    {
	    	COST_POOL : function()	{
	    		var divCode = Ext.isEmpty(panelSearch.getValue("DIV_CODE")) ? UserInfo.divCode:panelSearch.getValue("DIV_CODE");
	    		var divCostPool = [];
	    		Ext.each(costPoolCode, function(costPool, idx){
		    		if(divCode == costPool.DIV_CODE)	{
		    			divCostPool.push(costPool);
		    		}
	    		});
	    		return Ext.isEmpty(divCostPool) ? costPoolCode: divCostPool;
	    	},
	    	getCountProduct :function ()	{
	    		var divCode = Ext.isEmpty(panelSearch.getValue("DIV_CODE")) ? UserInfo.divCode:panelSearch.getValue("DIV_CODE");
	    		countCostPool(divCode);
	    		return 	nProductDiv
	    	},
	    	
	    	getProductWidth :function ()	{
	    		var divCode = Ext.isEmpty(panelSearch.getValue("DIV_CODE")) ? UserInfo.divCode:panelSearch.getValue("DIV_CODE");
	    		countCostPool(divCode);
	    		return 	150*nProductDiv
	    	},
	    	getCountSupport :function ()	{
	    		var divCode = Ext.isEmpty(panelSearch.getValue("DIV_CODE")) ? UserInfo.divCode:panelSearch.getValue("DIV_CODE");
	    		countCostPool(divCode);
	    		return 	nSupportDiv;
	    	},
	    	getSupportWidth :function ()	{
	    		var divCode = Ext.isEmpty(panelSearch.getValue("DIV_CODE")) ? UserInfo.divCode:panelSearch.getValue("DIV_CODE");
	    		countCostPool(divCode);
	    		return 150*	nSupportDiv;
	    	},
	    	getName : function(record, index)	{
	    		console.log("getName : ", "COSTPOOL"+(index-1), " : ", record["COSTPOOL"+(index-1)]);
	    		return Ext.util.Format.number(record["COSTPOOL"+(index-1)],"0,000");
	    	},
	    	format : function(value)	{
	    		return Ext.util.Format.number(value,"0,000");
	    	}
	    }
	);
	var masterView1 = Ext.create('Ext.view.View', {
    	height:365,
        autoScroll:false,
		tpl: masterGrid1Template,
        store: directMasterStore1,
        itemSelector: 'tr.data-source'  ,      
    	style:{'background-color':'#fff'}
    });
    
    var masterGrid2Template = new Ext.XTemplate(
    	'<div class="outer-container1">',
	    '<div style="margin-right:0px;height:40px;">',
	    '	<div style="margin-top:10px; padding-top:5px; margin-bottom:10px;font-size:10pt;font-weight:bold;color: #04408c;border-top: #c3c3c3 solid 3px;">제조부문별 집계</div>',
	    '</div>',
		'<div class="inner-container1">',
		'<div class="table-header" id="headerdiv2">',
	    '<table cellspacing="0" cellpadding="4" width="100%" style="margin-right:20px;" >' ,
	    	'<tr style="">',
	    		'<th width="150"  style="min-width:150px;background-color:#DDEBF7;border-top: #c3c3c3 solid 2px;border-bottom: #c3c3c3 solid 1px;" rowspan="2">구&nbsp;&nbsp;&nbsp;&nbsp;분</th>',
	    		'<th width="180"  style="min-width:180px;background-color:#DDEBF7;border-top: #c3c3c3 solid 2px;border-bottom: #c3c3c3 solid 1px;" rowspan="2">비&nbsp;&nbsp;&nbsp;&nbsp;목</th>',
	    		'<th width="180"  style="min-width:180px;background-color:#DDEBF7;border-top: #c3c3c3 solid 2px;border-bottom: #c3c3c3 solid 1px;" rowspan="2">계&nbsp;&nbsp;&nbsp;&nbsp;정</th>',
	    		'<th width="{[this.getProductWidth()]}"  style="background-color:#DDEBF7;border-top: #c3c3c3 solid 2px;border-left: #c3c3c3 solid 1px;border-right: #c3c3c3 solid 1px;" colspan="{[this.getCountProduct()]}">제조부문</th>',
	    		'<th width="{[this.getCountSupport()]}"  style="background-color:#DDEBF7;border-top: #c3c3c3 solid 2px;"  colspan="{[this.getCountSupport()]}">보조부문</th>',
	    		'<th width="15%"  style="min-width:100px;background-color:#DDEBF7;border-top: #c3c3c3 solid 2px;border-bottom: #c3c3c3 solid 1px;border-left: #c3c3c3 solid 1px" rowspan="2">합&nbsp;&nbsp;&nbsp;&nbsp;계</th>',
	    	'</tr>',
	    	'<tr style="">',
	    		'<tpl for="this.COST_POOL()">',
	    			'<th width="150"  style="min-width:100px;background-color:#DDEBF7;border-top: #c3c3c3 solid 1px;border-left: #c3c3c3 solid 1px;border-bottom: #c3c3c3 solid 1px;">{COST_POOL_NAME}</th>',
	    		'</tpl>',
	    	'</tr>',
	    '</table>',
	    '</div>',
	    '<div class="table-body" id="bodydiv2" >',
	    '<table cellspacing="0" cellpadding="4" width="100%" style="margin-right:0px;height:190px;" >' ,
	    '<tpl for=".">' ,
	    	'<tpl if="COST_GB_NAME != \'소계\' && ID_GB_NAME != \'합계\' && ID_GB_NAME != \'간접비 시간당 원가\'">',
		    	'<tr class="data-source2" style="background-color:#eeeded;border-bottom: #c3c3c3 solid 1px;height:20px;">',
		    		'<td width="150" class="cam100-td" style="min-width:150px;padding-left:10px;">{ID_GB_NAME}</td>',
		    		'<td width="180" style="min-width:180px;background-color:#FFF;border-bottom: #c3c3c3 solid 1px;">{COST_GB_NAME}</td>',
		    		'<td width="180" style="min-width:180px;background-color:#FFF;border-bottom: #c3c3c3 solid 1px;">{ACCNT_NAME}</td>',
		    		'<tpl for="this.COST_POOL()">',
		    		'<td width="150" style="min-width:100px;background-color:#FFF;border-bottom: #c3c3c3 solid 1px;text-align:right;padding-right:10px;">{[this.getName(parent,xindex)]}</td>',
					'</tpl>',
					'<td width="15%" style="min-width:100px;background-color:#FFF;border-bottom: #c3c3c3 solid 1px;text-align:right;padding-right:10px;">{[this.format(values.SUM_AMT)]}</td>',
		    	'</tr>',
	    	'</tpl>',
	    	'<tpl if="COST_GB_NAME == \'소계\'">',
		    	'<tr class="data-source2" style="background-color:#eeeded;">',
		    		'<td width="150" style="min-width:150px;border-bottom: #c3c3c3 solid 1px;">&nbsp;</td>',
		    		'<td width="180" style="min-width:180px;border-bottom: #c3c3c3 solid 1px;">&nbsp;</td>',
		    		'<td width="180" style="min-width:180px;background-color:#eeeded;border-bottom: #c3c3c3 solid 1px;text-align:right;">{COST_GB_NAME} : </td>',
		    		'<tpl if="ID_GB_NAME == \'직접비\'">',
		    		'<tpl for="this.COST_POOL()">',
		    		'<td width="150" style="min-width:100px;background-color:#A0C07B;text-align:right;padding-right:10px" >{[this.getName(parent,xindex)]}</td>',
					'</tpl>',
					'<td width="15%" style="min-width:100px;background-color:#A0C07B;text-align:right;padding-right:10px" >{[this.format(values.SUM_AMT)]}</td>',
		    		'</tpl>',
		    		'<tpl if="ID_GB_NAME == \'간접비\'">',
		    		'<tpl for="this.COST_POOL()">',
		    		'<td width="150" style="min-width:100px;background-color:#EFE4B0;text-align:right;padding-right:10px" >{[this.getName(parent,xindex)]}</td>',
					'</tpl>',
					'<td width="15%" style="min-width:100px;background-color:#EFE4B0;text-align:right;padding-right:10px" >{[this.format(values.SUM_AMT)]}</td>',
		    		'</tpl>',
		    	'</tr>',
	    	'</tpl>',
			'<tpl if="ID_GB_NAME == \'간접비 시간당 원가\'">',
		    '</table>',
	    	'</div>',
	    	'<div class="table-footer" id="footerdiv2" onscroll="document.getElementById(\'headerdiv2\').scrollLeft = this.scrollLeft;document.getElementById(\'bodydiv2\').scrollLeft = this.scrollLeft;">',
	    	'<table cellspacing="0" cellpadding="4" width="100%" style="margin-right:20px;height:50px;" >' ,
	    	'<tfoot>',
				'<tr class="data-source2" style="background-color:#eeeded;">',
		    		'<td width="150" style="border-bottom: #c3c3c3 solid 1px;">&nbsp;</td>',
		    		'<td width="180" style="border-bottom: #c3c3c3 solid 1px;">&nbsp;</td>',
		    		'<td width="180" style="border-bottom: #c3c3c3 solid 1px;text-align:right;">{ID_GB_NAME} : </td>',
		    		'<tpl for="this.COST_POOL()">',
		    		'<td width="150" style="min-width:100px;background-color:#EBBE54;text-align:right;padding-right:10px;border-bottom: #c3c3c3 solid 2px;" >{[this.getName(parent,xindex)]}</td>',
					'</tpl>',
					'<td width="15%" style="min-width:100px;background-color:#EBBE54;text-align:right;padding-right:10px;border-bottom: #c3c3c3 solid 2px;" >{[this.format(values.SUM_AMT)]}</td>',
		    	'</tr>',
	    	'</tpl>',
	    	'<tpl if="ID_GB_NAME == \'합계\'">',
		    	'<tr class="data-source2" style="background-color:#c3c3c3;">',
		    		'<td width="150" style="min-width:150px;border-bottom: #c3c3c3 solid 2px;">&nbsp;</td>',
		    		'<td width="180" style="min-width:180px;border-bottom: #c3c3c3 solid 2px;">&nbsp;</td>',
		    		'<td width="180" style="min-width:180px;border-bottom: #c3c3c3 solid 2px;text-align:right;">{ID_GB_NAME} : </td>',
		    		'<tpl for="this.COST_POOL()">',
		    		'<td width="150" style="min-width:100px;background-color:#F2A36D;text-align:right;padding-right:10px;border-bottom: #c3c3c3 solid 2px;" >{[this.getName(parent,xindex)]}</td>',
					'</tpl>',
					'<td width="15%" style="min-width:100px;background-color:#F2A36D;text-align:right;padding-right:10px;border-bottom: #c3c3c3 solid 2px;" >{[this.format(values.SUM_AMT)]}</td>',
		    	'</tr>',
		    '</tfoot>',
	    	'</tpl>',
        '</tpl>' ,
        '</table>',
        '</div>',
        '</div>',
        '</div>',
	    {
	    	COST_POOL : function()	{
	    		var divCode = Ext.isEmpty(panelSearch.getValue("DIV_CODE")) ? UserInfo.divCode:panelSearch.getValue("DIV_CODE");
	    		var divCostPool = [];
	    		Ext.each(costPoolCode, function(costPool, idx){
		    		if(divCode == costPool.DIV_CODE)	{
		    			divCostPool.push(costPool);
		    		}
	    		});
	    		return Ext.isEmpty(divCostPool) ? costPoolCode: divCostPool;
	    	},
	    	getCountProduct :function ()	{
	    		var divCode = Ext.isEmpty(panelSearch.getValue("DIV_CODE")) ? UserInfo.divCode:panelSearch.getValue("DIV_CODE");
	    		countCostPool(divCode);
	    		return 	nProductDiv
	    	},
	    	
	    	getProductWidth :function ()	{
	    		var divCode = Ext.isEmpty(panelSearch.getValue("DIV_CODE")) ? UserInfo.divCode:panelSearch.getValue("DIV_CODE");
	    		countCostPool(divCode);
	    		return 	150*nProductDiv
	    	},
	    	getCountSupport :function ()	{
	    		var divCode = Ext.isEmpty(panelSearch.getValue("DIV_CODE")) ? UserInfo.divCode:panelSearch.getValue("DIV_CODE");
	    		countCostPool(divCode);
	    		return 	nSupportDiv;
	    	},
	    	getName : function(record, index)	{
	    		console.log("getName : ", "COSTPOOL"+(index-1), " : ", record["COSTPOOL"+(index-1)]);
	    		return Ext.util.Format.number(record["COSTPOOL"+(index-1)],"0,000");
	    	},
	    	format : function(value)	{
	    		return Ext.util.Format.number(value,"0,000");
	    	}
	    }

	);
	var masterView2 = Ext.create('Ext.view.View', {
    	height:360,
    	style:{'background-color':'#fff'},
        autoScroll:false,
		tpl: masterGrid2Template,
        store: directMasterStore2,
        itemSelector: 'tr.data-source2'
    });
    
    var westContainer = {
    	xtype:'panel',
		region:'west',
		//title:'작업실행',
		collapsible :false,
		//collapseDirection : 'left',
		collapsed :false,
		width:350,
    	layout: {type:'vbox', align:'stretch'} ,
		items:[
			costPanel1, 
			costPanel2,
			{
				xtype :'panel',
		        title : '원가계산기준등록 및 작업현황 ',
		        layout : 'border',
				collapsible :true,
				collapseDirection  : 'top',
		        flex : .5,
				items :[
					 {
						xtype :'uniSearchForm',
						style:{'background-color':'#FFF'},
						dsiabled :false,
						region : 'north',
						id     : 'statusForm',
						height : 60,
						layout: {type: 'uniTable', columns: 2, tdAttrs: {valign:'top'}, tableAttrs : {'border' : 0}},
						items: [{
							name: 'DIV_CODE',
							fieldLabel: '사업장',
							xtype: 'uniCombobox',
				      		comboType: 'BOR120',
				      		value: UserInfo.divCode,
				      		width:265,
					  		labelWidth:115,
				      		hidden: false,
				      		allowBlank: false,
				      		colspan: 2
						},{
							name: 'WORK_MONTH',
						 	fieldLabel: '조회년월',
						 	xtype: 'uniMonthfield',
						  	value: UniDate.get('startOfMonth'),
						  	width:210,
					  		labelWidth:115,
						  	hidden: false,
						  	allowBlank: false
						},{
							xtype:'button',
							text : '조회',
							width : 50,
							handler : function() {
								directMasterStore3.loadStoreRecords();
							}
						}]
					},
					statusGrid
				]
			}
			
		]
	}
    var centerContainer = {
    	xtype:'panel',
    	region:'center',
    	layout: 'border' ,
    	style:{'background-color':'#FFF'},
    	flex:1,
    	//title:'작업결과보기',
    	
		items:[
			panelSearch,
			{
				xtype:'container',				
    			region:'center',
    			autoScroll:true,
    			flex:1,
    			width:"100%",
    			style:{'background-color':'#FFF'},
    			layout:{type:'vbox', align:'stretch'},
    			//layout:{type:'table', columns:1},
    			items:[
					masterView1,
					masterView2
				]
			}
		]
	}
	
	/* 원가계산 */
    Unilite.Main( {
		id: 'cam101ukrvApp',
		borderItems: [ westContainer, centerContainer],
		fnInitBinding : function() {
			countCostPool(UserInfo.divCode);
			UniAppManager.setToolbarButtons(['query', 'detail',  'reset'], false);
			directMasterStore1.loadStoreRecords();
			directMasterStore2.loadStoreRecords();
			directMasterStore3.loadStoreRecords();
		},
		onQueryButtonDown:function(){
			
		},
		getLastWorkInfo:function(divCode)	{
			cam110ukrvService.selectLastWorkInfo({'DIV_CODE':divCode}, function(reponseText){
				if(reponseText) {
					//costPanel1.setValue("LAST_WORK_MONTH", reponseText.WORK_MONTH)
					costPanel1.setValue("LAST_COST_PRSN", reponseText.COST_PRSN)
					costPanel1.setValue("LAST_WORK_DATE", reponseText.UPDATE_DB_TIME)
					costPanel1.setValue("WORK_PERIOD", responserText.WORK_PERIOD)
				} else {
					//costPanel1.setValue("LAST_WORK_MONTH", '');
					costPanel1.setValue("LAST_COST_PRSN", '');
					costPanel1.setValue("LAST_WORK_DATE", '');
					costPanel1.setValue("WORK_PERIOD", '');
				}
			})
		},
		getLastCloseInfo:function(divCode)	{
			cam110ukrvService.selectLastCloseInfo({'DIV_CODE':divCode}, function(reponseText){
				if(reponseText) {
					costPanel2.setValue("LAST_WORK_MONTH", reponseText.WORK_MONTH)
					costPanel2.setValue("LAST_COST_PRSN", reponseText.COST_PRSN)
					costPanel2.setValue("LAST_WORK_DATE", reponseText.UPDATE_DB_TIME)
				}else {
					costPanel2.setValue("LAST_WORK_MONTH", '');
					costPanel2.setValue("LAST_COST_PRSN", '');
					costPanel2.setValue("LAST_WORK_DATE", '');
				}
			})
		}
    });

};
</script>