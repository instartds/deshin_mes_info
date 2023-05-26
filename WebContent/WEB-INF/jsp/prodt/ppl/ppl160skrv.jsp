<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="ppl160skrv"  >
	<t:ExtComboStore comboType="BOR120"  /> 					 	<!-- 사업장 -->  
	<t:ExtComboStore comboType="WU" />                  <!-- 작업장  -->
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
 <style type="text/css">
	.x-grid-row-yellow table{
    background-color:'#yellow';
	}
</style>
<script type="text/javascript" >


function appMain() {     
	/**
	 *   Model 정의 
	 * @type 
	 */
	
	
	Unilite.defineModel('Ppl160skrvModel', {
		fields: [
		


			{name: 'DIV_CODE'      	, text: '<t:message code="system.label.product.division" default="사업장"/>'		, type: 'string'},
			{name: 'SPEC'     		, text: '<t:message code="system.label.product.spec" default="규격"/>'		, type: 'string'},
			{name: 'PROJECT_NO' 	, text: '<t:message code="system.label.product.projectname" default="프로젝트명"/>' 	, type: 'string'},
			{name: 'ORDER_Q'     	, text: '<t:message code="system.label.product.deliverydate" default="납기일"/>'		, type: 'string'},
			{name: 'STOCK_Q'     	, text: '<t:message code="system.label.product.onhandstock" default="현재고"/>'		, type: 'uniQty'},
			{name: 'STOCK_RATE'     , text: '<t:message code="system.label.product.inventoryrate" default="재고율"/>' 		, type: 'uniPercent'},
			{name: 'TOT_Q'     		, text: '<t:message code="system.label.product.resultsqty" default="실적수량"/>' 	, type: 'uniQty'},
			{name: 'WK_PLAN_A'		, text: '<t:message code="system.label.product.resultsamount" default="실적액"/>' 	, type: 'uniPrice'},
			{name: 'PL_A'          	, text: '<t:message code="system.label.product.pla" default="실행예가"/>'   	, type: 'uniPrice'},
			{name: 'ITEM_CODE'      , text: '<t:message code="system.label.product.plunitprice" default="PL단가"/>'   	, type: 'string'},
			{name: 'PRICE_A'        , text: '<t:message code="system.label.product.receiptamount" default="입고액"/>'   	, type: 'uniPrice'},
			{name: 'GUBUN'          , text: '<t:message code="system.label.product.classfication" default="구분"/>'   		, type: 'string'},
		
			{name: 'DAY1_Q'         , text: '1<t:message code="system.label.product.day" default="일"/>' 	, type: 'uniQty'},
			{name: 'DAY2_Q'        	, text: '2<t:message code="system.label.product.day" default="일"/>' 	, type: 'uniQty'},
			{name: 'DAY3_Q'        	, text: '3<t:message code="system.label.product.day" default="일"/>' 	, type: 'uniQty'},
			{name: 'DAY4_Q'        	, text: '4<t:message code="system.label.product.day" default="일"/>' 	, type: 'uniQty'},
			{name: 'DAY5_Q'        	, text: '5<t:message code="system.label.product.day" default="일"/>' 	, type: 'uniQty'},
			{name: 'DAY6_Q'        	, text: '6<t:message code="system.label.product.day" default="일"/>' 	, type: 'uniQty'},
			{name: 'DAY7_Q'        	, text: '7<t:message code="system.label.product.day" default="일"/>' 	, type: 'uniQty'},
			{name: 'DAY8_Q'        	, text: '8<t:message code="system.label.product.day" default="일"/>' 	, type: 'uniQty'},
			{name: 'DAY9_Q'         , text: '9<t:message code="system.label.product.day" default="일"/>' 	, type: 'uniQty'},
			{name: 'DAY10_Q'        , text: '10<t:message code="system.label.product.day" default="일"/>' 	, type: 'uniQty'},
			{name: 'DAY11_Q'        , text: '11<t:message code="system.label.product.day" default="일"/>' 	, type: 'uniQty'},
			{name: 'DAY12_Q'        , text: '12<t:message code="system.label.product.day" default="일"/>' 	, type: 'uniQty'},
			{name: 'DAY13_Q'        , text: '13<t:message code="system.label.product.day" default="일"/>' 	, type: 'uniQty'},
			{name: 'DAY14_Q'        , text: '14<t:message code="system.label.product.day" default="일"/>' 	, type: 'uniQty'},
			{name: 'DAY15_Q'        , text: '15<t:message code="system.label.product.day" default="일"/>' 	, type: 'uniQty'},
			{name: 'DAY16_Q'        , text: '16<t:message code="system.label.product.day" default="일"/>' 	, type: 'uniQty'},
			{name: 'DAY17_Q'        , text: '17<t:message code="system.label.product.day" default="일"/>' 	, type: 'uniQty'},
			{name: 'DAY18_Q'        , text: '18<t:message code="system.label.product.day" default="일"/>' 	, type: 'uniQty'},
			{name: 'DAY19_Q'        , text: '19<t:message code="system.label.product.day" default="일"/>' 	, type: 'uniQty'},
			{name: 'DAY20_Q'        , text: '20<t:message code="system.label.product.day" default="일"/>' 	, type: 'uniQty'},
			{name: 'DAY21_Q'        , text: '21<t:message code="system.label.product.day" default="일"/>' 	, type: 'uniQty'},
			{name: 'DAY22_Q'        , text: '22<t:message code="system.label.product.day" default="일"/>' 	, type: 'uniQty'},
			{name: 'DAY23_Q'        , text: '23<t:message code="system.label.product.day" default="일"/>' 	, type: 'uniQty'},
			{name: 'DAY24_Q'        , text: '24<t:message code="system.label.product.day" default="일"/>' 	, type: 'uniQty'},
			{name: 'DAY25_Q'        , text: '25<t:message code="system.label.product.day" default="일"/>' 	, type: 'uniQty'},
			{name: 'DAY26_Q'        , text: '26<t:message code="system.label.product.day" default="일"/>' 	, type: 'uniQty'},
			{name: 'DAY27_Q'        , text: '27<t:message code="system.label.product.day" default="일"/>' 	, type: 'uniQty'},
			{name: 'DAY28_Q'       	, text: '28<t:message code="system.label.product.day" default="일"/>' 	, type: 'uniQty'},
			{name: 'DAY29_Q'       	, text: '29<t:message code="system.label.product.day" default="일"/>' 	, type: 'uniQty'},
			{name: 'DAY30_Q'       	, text: '30<t:message code="system.label.product.day" default="일"/>' 	, type: 'uniQty'},
			{name: 'DAY31_Q'       	, text: '31<t:message code="system.label.product.day" default="일"/>' 	, type: 'uniQty'},
			{name: 'ITEM'       	, text: '<t:message code="system.label.product.code" default="코드"/>' 	, type: 'string'}
		] , setColumnHeader:function(record, grid, indexName, def) {
				var d = record.get(indexName);
				var column = grid.getColumn(indexName);
				alert(column)
				if(Ext.isEmpty(column))  {
					return ;
				}
				if(!Ext.isEmpty(d)) {
					column.setText(d);
				} else {
					column.setText(def);
				}
			}                          
	});
	
	// GroupField string type으로 변환
	function dateToString(v, record){
		return UniDate.safeFormat(v);
	  }
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var MasterStore = Unilite.createStore('ppl160skrvMasterStore',{
		model: 'Ppl160skrvModel',
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결 
			editable: false,			// 수정 모드 사용 
    		deletable:false,			// 삭제 가능 여부 
        	useNavi : false			// prev | next 버튼 사용
		},
		autoLoad: false,
 		proxy: {
			type: 'direct',
			api: {			
				read: 'ppl160skrvService.selectList'                	
				 }
            },
            loadStoreRecords: function(){
				var param= Ext.getCmp('searchForm').getValues();	
				param.FIRST_DATE = param.FR_DATE+"01";
				param.LAST_DATE = param.FR_DATE+"31";
					console.log( param );
					param.QUERY_TYPE='3';
					this.load({
						params : param
					});
				},
				groupField: ''
	});		//End of var directMasterStore1 = Unilite.createStore('ppl160skrvMasterStore1',{
	
	
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm',{
		title: '<t:message code="system.label.product.searchconditon" default="검색조건"/>',
        defaultType: 'uniSearchSubPanel',
        collapsed:true,
        listeners: {
	        collapse: function () {
	            panelResult.show();
	        },
	        expand: function() {
	        	panelResult.hide();
	        }
        },
		items: [{	
			title: '<t:message code="system.label.product.basisinfo" default="기본정보"/>', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items: [{
		 		fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
		 		name:'DIV_CODE', 
		 		xtype: 'uniCombobox',
		 		comboType:'BOR120',
		 		allowBlank:false,
		 		value : UserInfo.divCode,
		 		listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('DIV_CODE', newValue);
						}
					}
		 	},{
            	fieldLabel: '<t:message code="system.label.product.planmonth" default="계획월"/>',
            	name: 'FR_DATE',
            	xtype: 'uniMonthfield',
		 		value: UniDate.get('startOfMonth'),
				holdable: 'hold', 
            	allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('FR_DATE', newValue);
						/*var date=Ext.util.Format.date(panelSearch.getValue('FR_DATE'), 'Y-m-d');
						getDate(date);*/
					}
				}
            },
				Unilite.popup('DIV_PUMOK',{ // 20210825 추가: 품목 팝업창 정규화 작업
					fieldLabel: '<t:message code="system.label.product.item" default="품목"/>',
					validateBlank:false,
					valueFieldName:'ITEM_CODE',
	        		textFieldName:'ITEM_NAME', 
					listeners: {
						onValueFieldChange: function( elm, newValue, oldValue ) {
							panelResult.setValue('ITEM_CODE', newValue);
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('ITEM_NAME', '');
								panelSearch.setValue('ITEM_NAME', '');
							}
						},
						onTextFieldChange: function( elm, newValue, oldValue ) {
							panelResult.setValue('ITEM_NAME', newValue);
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('ITEM_CODE', '');
								panelSearch.setValue('ITEM_CODE', '');
							}
						},
						applyextparam: function(popup){							
							popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
					}					
			})]
		}],
		
		setAllFieldsReadOnly: function(b) {
				var r= true
				if(b) {
					var invalid = this.getForm().getFields().filterBy(function(field) {
																		return !field.validate();
																	});
   	
	   				if(invalid.length > 0) {
						r=false;
	   					var labelText = ''
	   	
						if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
	   						var labelText = invalid.items[0]['fieldLabel']+' : ';
	   					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
	   						var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
	   					}
	
					   	alert(labelText+Msg.sMB083);
					   	invalid.items[0].focus();
					} else {
					//	this.mask();		    
	   				}
		  		} else {
  					this.unmask();
  				}
				return r;
  			}
	});
	
	
	var panelResult = Unilite.createSearchForm('panelResultForm', {
		region: 'north',
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
	    	items: [{
		 		fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
		 		name:'DIV_CODE', 
		 		xtype: 'uniCombobox',
		 		comboType:'BOR120',
		 		allowBlank:false,
		 		value : UserInfo.divCode,
		 		listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('DIV_CODE', newValue);
					}
				}
		 	},{
		 		fieldLabel: '<t:message code="system.label.product.planmonth" default="계획월"/>',
		 		xtype: 'uniMonthfield',
		 		name: 'FR_DATE',
		 		value: UniDate.get('startOfMonth'),
		 		allowBlank:false,
		 		listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('FR_DATE', newValue);
					/*var date=Ext.util.Format.date(panelSearch.getValue('FR_DATE'), 'Y-m-d');
					getDate(date);*/
					}
				}
			},
				Unilite.popup('DIV_PUMOK',{ // 20210825 추가: 품목 팝업창 정규화 작업
					fieldLabel: '<t:message code="system.label.product.item" default="품목"/>',
					validateBlank:false,
					valueFieldName:'ITEM_CODE',
	        		textFieldName:'ITEM_NAME', 					
					listeners: {
						onValueFieldChange: function( elm, newValue, oldValue ) {
							panelSearch.setValue('ITEM_CODE', newValue);
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('ITEM_NAME', '');
								panelSearch.setValue('ITEM_NAME', '');
							}
						},
						onTextFieldChange: function( elm, newValue, oldValue ) {
							panelSearch.setValue('ITEM_NAME', newValue);
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('ITEM_CODE', '');
								panelSearch.setValue('ITEM_CODE', '');
							}
						},
						applyextparam: function(popup){							
							popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
						}
					}		
			})],
		
		setAllFieldsReadOnly: function(b) {
				var r= true
				if(b) {
					var invalid = this.getForm().getFields().filterBy(function(field) {
																		return !field.validate();
																	});
   	
	   				if(invalid.length > 0) {
						r=false;
	   					var labelText = ''
	   	
						if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
	   						var labelText = invalid.items[0]['fieldLabel']+' : ';
	   					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
	   						var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
	   					}
	
					   	alert(labelText+Msg.sMB083);
					   	invalid.items[0].focus();
					} else {
					//	this.mask();		    
	   				}
		  		} else {
  					this.unmask();
  				}
				return r;
  			}
    });
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
	var masterGrid = Unilite.createGrid('ppl160skrvGrid', {
        region: 'center' ,
        layout : 'fit',
        store : MasterStore,
        uniOpt:{
        	expandLastColumn: true,
    		useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
    		useGroupSummary: false,
			useRowNumberer: false,
			filter: {
				useFilter: true,
				autoCreate: true
			},
			state: {
				useState: false,			//그리드 설정 버튼 사용 여부
				useStateList: false		//그리드 설정 목록 사용 여부
			}
        },listeners:{
        	render: function(p,p2) { 
        			
				}
        },viewConfig:{
        		forceFit : true,
                stripeRows: false,//是否隔行换色
                getRowClass : function(record,rowIndex,rowParams,store){
                	var cls = '';
                    if(record.get('GUBUN')=="계획"){
                    	cls = 'x-change-cell_Background_essRow';	
                    }
                    return cls;
                }
            },
    	features: [
    		{id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true},
    	    {id : 'masterGridTotal' ,   ftype: 'uniSummary', 	     showSummaryRow: false}
    	],
        	columns: [
        	
		    
	       	
        		{dataIndex:'DIV_CODE'        , width: 100,	hidden: true},
        		{text :'<t:message code="system.label.product.itemname" default="품목명"/>',locked: true,
	        			columns:[ 
	        				{dataIndex:'SPEC'	 , width: 120}
	        			]
        		},
        		{text :'<t:message code="system.label.product.sono" default="수주번호"/>',locked: true,
	        			columns:[ 
	        				{dataIndex:'PROJECT_NO'	 , width: 100}
	        			]
        		},
        		{text :'<t:message code="system.label.product.soqty" default="수주량"/>',locked: true,
	        			columns:[ 
	        				{dataIndex:'ORDER_Q'	 , width: 66}
	        			]
        		},
        		{text :'<t:message code="system.label.product.safetystock" default="안전재고"/>',locked: true,
	        			columns:[ 
	        				{dataIndex:'STOCK_Q'	 , width: 66}
	        			]
        		},
        		{text :'<t:message code="system.label.product.resultsrate" default="실적율"/>',locked: true,
	        			columns:[ 
	        				{dataIndex:'STOCK_RATE'	 , width: 66}
	        			]
        		},
        		
        		{text :'<t:message code="system.label.product.planqty" default="계획량"/>',
	        			columns:[ 
	        				{dataIndex:'TOT_Q'	 , width: 76}
	        			]
        		},
        		{text :'<t:message code="system.label.product.planamount" default="계획액"/>',
	        			columns:[ 
	        				{dataIndex:'WK_PLAN_A'	 , width: 120}
	        			]
        		},
        		{text :'<t:message code="system.label.product.plamount" default="PL액"/>',
	        			columns:[ 
	        				{dataIndex:'PL_A'	 , width: 120}
	        			]
        		},
        		{text :'<t:message code="system.label.product.item" default="품목"/>',
	        			columns:[ 
	        				{dataIndex:'ITEM_CODE'	 , width: 100}
	        			]
        		},
        		{text :'<t:message code="system.label.product.poamount" default="발주액"/>',
	        			columns:[ 
	        				{dataIndex:'PRICE_A'	 , width: 120}
	        			]
        		},
        		
	        	{dataIndex:'GUBUN'	 , width: 66},
        		
	        	{dataIndex:'DAY1_Q'	 , width: 66, summaryType: 'sum' , align: 'center'},
	        	{dataIndex:'DAY2_Q'	 , width: 66, summaryType: 'sum' , align: 'center'},
	        	{dataIndex:'DAY3_Q'	 , width: 66, summaryType: 'sum' , align: 'center'},
	        	{dataIndex:'DAY4_Q'	 , width: 66, summaryType: 'sum' , align: 'center'},
	        	{dataIndex:'DAY5_Q'	 , width: 66, summaryType: 'sum' , align: 'center'},
	        	{dataIndex:'DAY6_Q'	 , width: 66, summaryType: 'sum' , align: 'center'},
	        	{dataIndex:'DAY7_Q'	 , width: 66, summaryType: 'sum' , align: 'center'},
	        	{dataIndex:'DAY8_Q'	 , width: 66, summaryType: 'sum' , align: 'center'},
	        	{dataIndex:'DAY9_Q'	 , width: 66, summaryType: 'sum' , align: 'center'},
	        	{dataIndex:'DAY10_Q'	 , width: 66, summaryType: 'sum' , align: 'center'},
	        	{dataIndex:'DAY11_Q'	 , width: 66, summaryType: 'sum' , align: 'center'},
	        	{dataIndex:'DAY12_Q'	 , width: 66, summaryType: 'sum' , align: 'center'},
	        	{dataIndex:'DAY13_Q'	 , width: 66, summaryType: 'sum' , align: 'center'},
	        	{dataIndex:'DAY14_Q'	 , width: 66, summaryType: 'sum' , align: 'center'},
	        	{dataIndex:'DAY15_Q'	 , width: 66, summaryType: 'sum' , align: 'center'},
	        	{dataIndex:'DAY16_Q'	 , width: 66, summaryType: 'sum' , align: 'center'},
	        	{dataIndex:'DAY17_Q'	 , width: 66, summaryType: 'sum' , align: 'center'},
	        	{dataIndex:'DAY18_Q'	 , width: 66, summaryType: 'sum' , align: 'center'},
	        	{dataIndex:'DAY19_Q'	 , width: 66, summaryType: 'sum' , align: 'center'},
	        	{dataIndex:'DAY20_Q'	 , width: 66, summaryType: 'sum' , align: 'center'},
	        	{dataIndex:'DAY21_Q'	 , width: 66, summaryType: 'sum' , align: 'center'},
	        	{dataIndex:'DAY22_Q'	 , width: 66, summaryType: 'sum' , align: 'center'},
	        	{dataIndex:'DAY23_Q'	 , width: 66, summaryType: 'sum' , align: 'center'},
	        	{dataIndex:'DAY24_Q'	 , width: 66, summaryType: 'sum' , align: 'center'},
	        	{dataIndex:'DAY25_Q'	 , width: 66, summaryType: 'sum' , align: 'center'},
	        	{dataIndex:'DAY26_Q'	 , width: 66, summaryType: 'sum' , align: 'center'},
	        	{dataIndex:'DAY27_Q'	 , width: 66, summaryType: 'sum' , align: 'center'},
	        	{dataIndex:'DAY28_Q'	 , width: 66, summaryType: 'sum' , align: 'center'},
	        	{dataIndex:'DAY29_Q'	 , width: 66, summaryType: 'sum' , align: 'center'},
	        	{dataIndex:'DAY30_Q'	 , width: 66, summaryType: 'sum' , align: 'center'},
	        	{dataIndex:'DAY31_Q'	 , width: 66, summaryType: 'sum' , align: 'center'},

        		{dataIndex:'ITEM'         	 , width: 66,hidden:true}
        		
		]                                    
    });		//End of var masterGrid1 = Unilite.createGrid('ppl160skrvGrid1', {

   
    function day_change()
    {
    	//var date=new Date(d);
    	for (var i = 1; i <= 31; i++) {
    		var column1=masterGrid.getColumn("DAY"+i+"_Q");
    		console.log("column1.text",column1);
    		if(column1.text=="일"){
	    		column1.style="color:#ff0000";
	    	}else if(column1.text=="토"){
	    		column1.style="color:#0000ff";
	    	}else{
	    		column1.style="color:#000";
	    	}
    	}
    }
    function getDate(d)
	{
	var weekday=new Array(7);
	weekday[0]="일";
	weekday[1]="월";
	weekday[2]="화";
	weekday[3]="수";
	weekday[4]="목";
	weekday[5]="금";
	weekday[6]="토";
	var date=new Date(d);
	//获取年份
    var year = date.getFullYear();
    //获取当前月份
    var mouth = date.getMonth() + 1;
    date.setMonth(date.getMonth() + 1);
	date.setDate(0);
    //定义当月的最后一天；
    var days=date.getDate();
     if(days==31){
     	var column=masterGrid.getColumn("DAY31_Q");
     	var column2=masterGrid.getColumn("DAY30_Q");
     	var column3=masterGrid.getColumn("DAY29_Q");
    	column.show();
    	column2.show();
    	column3.show();
     }
    if(days<31&&days==30){
    	var column=masterGrid.getColumn("DAY31_Q");
    	column.hide();
    }
    if(days<30&&days==29){
    	var column=masterGrid.getColumn("DAY30_Q");
    	var column2=masterGrid.getColumn("DAY31_Q");
    	column.hide();
    	column2.hide();
    }
    if(days<29&&days==28){
    	var column=masterGrid.getColumn("DAY31_Q");
     	var column2=masterGrid.getColumn("DAY30_Q");
     	var column3=masterGrid.getColumn("DAY29_Q");
    	column.hide();
    	column2.hide();
    	column3.hide();
    }
    for(var i=1;i<=days;i++){
    	date.setDate(i);
    	var column1=masterGrid.getColumn("DAY"+i+"_Q");
    	column1.setText(weekday[date.getDay()]);
    }
	return weekday[date.getDay()];
	}
    Unilite.Main({
		borderItems:[{
         region:'center',
         layout: 'border',
         border: false,
         items:[
            masterGrid, panelResult
         ]
      },
         panelSearch
      ],
		id : 'ppl160skrvApp',
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
//			var date=Ext.util.Format.date(panelSearch.getValue('FR_DATE'), 'Y-m-d');
//			getDate(date);
			day_change();
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
		},
		onQueryButtonDown: function() {
			if(!panelSearch.getInvalidMessage()) return;    //필수체크
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{
				var date=Ext.util.Format.date(panelSearch.getValue('FR_DATE'), 'Y-m-d');
//            	getDate(date);
            	day_change();
            	panelResult.setAllFieldsReadOnly(false);
		        masterGrid.getStore().loadStoreRecords();
		        UniAppManager.setToolbarButtons('excel',true);
//				var activeTabId = tab.getActiveTab().getId();  
//				if(activeTabId == 'ppl160skrvGridTab'){
//					panelResult.setAllFieldsReadOnly(false);
//			         masterGrid.getStore().loadStoreRecords();
//			         UniAppManager.setToolbarButtons('excel',true);
//				}
//				if(activeTabId == 'ppl160skrvGridTab2' ){
//					panelResult.setAllFieldsReadOnly(false);
//					 masterGrid2.getStore().loadStoreRecords();
//					 UniAppManager.setToolbarButtons('excel',true);
//				} 
/*			masterGrid.getStore().loadStoreRecords();
			var viewLocked = masterGrid.lockedGrid.getView();
			var viewNormal = masterGrid.normalGrid.getView();
			console.log("viewLocked: ", viewLocked);
			console.log("viewNormal: ", viewNormal);
		    viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
		    viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
		    viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
		    viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
		    UniAppManager.setToolbarButtons('excel',true);
*/			}
		},
		
		checkForNewDetail:function() { 			
			return panelSearch.setAllFieldsReadOnly(true);
        }
	});		// End of Unilite.Main
};
</script>
