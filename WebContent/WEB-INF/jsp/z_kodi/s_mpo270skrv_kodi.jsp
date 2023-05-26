<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_mpo270skrv_kodi"  >
	<t:ExtComboStore comboType="BOR120" pgmId="s_mpo270skrv_kodi" /> 					  <!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B020" opts='10;60;70' /> 		  <!-- 품목계정 -->
<style type="text/css">
	.x-change-cell_year1 { //녹색
		//background-color: #288C28;
		color: #288C28
	}
	.x-change-cell_year2 { //파란색
		//background-color: #0000FF;
		color: #0000FF
	}
	.x-change-cell_year3 {//주황색
		//background-color: #FFA500;
		color: #FFA500
	}
	.x-change-cell_year4 {//빨간색
		//background-color: #F3E2A9;
		color: #FF0000
	}

</style>	
</t:appConfig>
<link rel="stylesheet" type="text/css"  href='<c:url value="/extjs_6.2.0/charts/classic/charts-all.css"/>'>
<script type="text/javascript" charset="UTF-8" src='<c:url value="/extjs_6.2.0/charts/ext-charts.js" />'></script>
<script type="text/javascript" >


var gYear1 = '';
var gYear2 = '';
var BsaCodeInfo = {
	 gsDateFr		: '${gsDateFr}'
};

function appMain() {
	

	Unilite.defineModel('s_mpo270skrv_kodiModelC', {
		fields: [
            { name: 'DIV_CODE'          ,text:'DIV_CODE'        ,type: 'string'},
            { name: 'CUSTOM_CODE'       ,text:'거래처'             ,type: 'string'},
            { name: 'CUSTOM_NAME'       ,text:'거래처명'            ,type: 'string'},
            { name: 'ORDER_COUNT'       ,text:'수/발주건수'            ,type: 'uniQty'},
            { name: 'ORDER_UNIT_Q_SUM'  ,text:'수/발주수량'            ,type: 'uniQty'},
            { name: 'ITEM_COUNT'        ,text:'품목건수'            ,type: 'uniQty'},
            { name: 'INSTOCK_Q_SUM'     ,text:'대응수량'            ,type: 'uniQty'},
            { name: 'C_RESP_RATE'       ,text:'품목대응율(%)'        ,type: 'uniER'},
            { name: 'Q_RESP_RATE'       ,text:'수량대응율(%)'        ,type: 'uniER'}

		]
	});
	
	Unilite.defineModel('s_mpo270skrv_kodiModelL', {
		fields: [
            { name: 'DIV_CODE'          ,text:'DIV_CODE'        ,type: 'string'},
            { name: 'ITEM_LEVEL1'       ,text:'품목대분류'             ,type: 'string'},
            { name: 'LEVEL_NAME'        ,text:'품목대분류명'            ,type: 'string'},
            { name: 'ORDER_COUNT'       ,text:'수/발주건수'            ,type: 'uniQty'},
            { name: 'ORDER_UNIT_Q_SUM'  ,text:'수/발주수량'            ,type: 'uniQty'},
            { name: 'ITEM_COUNT'        ,text:'품목건수'            ,type: 'uniQty'},
            { name: 'INSTOCK_Q_SUM'     ,text:'대응수량'            ,type: 'uniQty'},
            { name: 'C_RESP_RATE'       ,text:'품목대응율(%)'        ,type: 'uniER'},
            { name: 'Q_RESP_RATE'       ,text:'수량대응율(%)'        ,type: 'uniER'}

		]
	});	
	

	Unilite.defineModel('s_mpo270skrv_kodiModel2', {
		fields: [
		    {name: 'DIV_CODE'	    ,text: 'DIV_CODE'		,type: 'string'},
			{name: 'CUSTOM_CODE'	,text: 'CUSTOM_CODE'	,type: 'string'},
			{name: 'ORDER_DATE'	    ,text: '수/발주일'		    ,type: 'uniDate'},
			{name: 'ORDER_NUM'	    ,text: '수/발주번호'		    ,type: 'string'},
			{name: 'ORDER_SEQ'	    ,text: '순번'		        ,type: 'string'},			
			{name: 'ITEM_CODE'	    ,text: '품번'		        ,type: 'string'},
			{name: 'ITEM_NAME'	    ,text: '품명'		        ,type: 'string'},
			{name: 'SPEC'	        ,text: '규격'		        ,type: 'string'},
			{name: 'ORDER_UNIT'	    ,text: '단위'		        ,type: 'string',comboType:'AU', comboCode:'B013'},
			{name: 'ITEM_ACCOUNT'	,text: '품목계정'		    ,type: 'string',comboType:'AU', comboCode:'B020'},
			{name: 'LEVEL_NAME'	    ,text: '품목(대)분류'		,type: 'string'},
			{name: 'ORDER_UNIT_Q'	,text: '수/발주량'	        ,type: 'uniQty'},
			{name: 'INSTOCK_Q'	    ,text: '입/출고량'	        ,type: 'uniQty'},
			{name: 'UNDVRY_Q'	    ,text: '미납량'	        ,type: 'uniQty'},
			{name: 'INIT_DVRY_DATE'	,text: '(최초)납기일'	    ,type: 'uniDate'},
			{name: 'DVRY_DATE'	    ,text: '(변경)납기일'	    ,type: 'uniDate'},
			{name: 'GUBUN'	        ,text: '구분'	            ,type: 'string'}
		]
	});
	

	/** Store 정의(Service 정의)
	 * @type
	 */
	var MasterStoreC = Unilite.createStore('s_mpo270skrv_kodiMasterStoreC',{
		model: 's_mpo270skrv_kodiModelC',
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결
			editable: false,			// 수정 모드 사용
			deletable: false,			// 삭제 가능 여부
			useNavi: false			// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {
				read: 's_mpo270skrv_kodiService.selectListC'
			}
		},
		loadStoreRecords : function()	{
			var param= Ext.getCmp('searchForm').getValues();
			console.log(param);
			this.load({
				params : param
			});
		},		
		listeners: {
			load: function(store, records, successful, eOpts) {
			}
		}
	});	
	
	var MasterStoreL = Unilite.createStore('s_mpo270skrv_kodiMasterStoreL',{
		model: 's_mpo270skrv_kodiModelL',
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결
			editable: false,			// 수정 모드 사용
			deletable: false,			// 삭제 가능 여부
			useNavi: false			// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {
				read: 's_mpo270skrv_kodiService.selectListL'
			}
		},
		loadStoreRecords : function()	{
			var param= Ext.getCmp('searchForm').getValues();
			console.log(param);
			this.load({
				params : param
			});
		},		
		listeners: {
			load: function(store, records, successful, eOpts) {
			}
		}
	});		
	
	var MasterStore2 = Unilite.createStore('s_mpo270skrv_kodiMasterStore2',{
		model: 's_mpo270skrv_kodiModel2',
		uniOpt : {
			isMaster: false,			// 상위 버튼 연결
			editable: false,			// 수정 모드 사용
			deletable: false,			// 삭제 가능 여부
			useNavi: false			// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {
				read: 's_mpo270skrv_kodiService.selectList1'
			}
		},
		loadStoreRecords: function(record){
			var param= Ext.getCmp('searchForm').getValues();
			var recordc	= masterGridC.getSelectedRecord();
			var recordl	= masterGridL.getSelectedRecord();
			if(!Ext.isEmpty(recordc)) {
				param.CUSTOM_CODE	= recordc.get('CUSTOM_CODE');
			}
			if(!Ext.isEmpty(recordl)) {
				param.ITEM_LEVEL1	= recordl.get('ITEM_LEVEL1');
			}				
			this.load({
					params : param
			});
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				if(records[0] != null){
					var minDate = records[0].data.MIN_DATE;
					var maxDate = records[0].data.MAX_DATE;
				}	
				tab.down('#autoDvryMin').setValue(minDate);
				tab.down('#autoDvryMax').setValue(maxDate);		
				
			}
		}		
	});
	

	Unilite.defineModel('viewAllChartModel', {
		fields: [
			{name: 'MONTH'				, text:'월'					,type:'string'},
			{name: 'YEAR1'				, text:'YEAR1'				,type: 'float'		, decimalPrecision: 2 , format:'0,000.00'},
			{name: 'YEAR2'				, text:'YEAR2'				,type: 'float'		, decimalPrecision: 2 , format:'0,000.00'}
		]
	});

	var viewAllChartStore = Unilite.createStore('viewAllChartStore',{
		model	: 'viewAllChartModel',
		proxy: {
	           type: 'direct',
	            api: {
	                read: 's_mpo270skrv_kodiService.selectCalList'
	            }
	        },
			loadStoreRecords: function(record){
				var param= Ext.getCmp('searchForm').getValues();
				var recordc	= masterGridC.getSelectedRecord();
				var recordl	= masterGridL.getSelectedRecord();
				var sChartGubun =  tab.down('#autoChartGubun').getValue().CHART_GUBUN;
				if(!Ext.isEmpty(recordc)) {
					param.CUSTOM_CODE	= recordc.get('CUSTOM_CODE');					
				}	
				
				if(!Ext.isEmpty(recordl)) {
					param.ITEM_LEVEL1	= recordl.get('ITEM_LEVEL1');
				}
				param.CHART_GUBUN  = sChartGubun;
				this.load({
						params : param
				});
			},
		uniOpt	: {
			isMaster	: false,		// 상위 버튼 연결
			editable	: false,		// 수정 모드 사용
			deletable	: false,		// 삭제 가능 여부
			useNavi		: false			// prev | newxt 버튼 사용
		},
//		autoLoad: false,
		listeners: {
			load: function(store, records, successful, eOpts) {						

			}
		}		
	});


	var viewAllChartPanel = Unilite.createSearchForm('viewAllChartPanel', {

//		renderTo	: Ext.getBody(),
		title		: '',
		region		: 'center',
		border		: true,
		layout		: 'fit',
//		height		: '100%',
		flex		: 1,
		items		: [{
			xtype		: 'cartesian',					//chart, cartesian, axis
			store		: viewAllChartStore,
			interactions: 'crosszoom',					// 크로스줌 인터랙션을 주면 블록을 잡아 확대 가능, 더블클릭시 이전 배율로 돌아감
			animate		: true,
			shadow		: true,
			innerPadding: '10 40 0 30',					//간격조정2
			legend		: {								//범례 위치 설정 (top, bottom, right, left)
				docked	: 'top'
			},
			axes		: [{							//위치
					title	: '',
			       	type: 'numeric3d',
			       	position: 'left',
			       	grid: true,
			        minimum	: 0,	//표시되는 최소치
					maximum : 100,	//표시되는 최대치
					majorTickSteps: 20,
				    renderer: function (axis,label,layoutContext,lastLabel   ){
						return  label +' %';
				    }

			}, {
//				title	: '월',
				type	: 'category3d',
				position: 'bottom',						//X축
//				grid	: true,							//그리드 선 표시 여부
				label	: {								//label 속성

				}
			}],
			series: [{
				type		: 'line',					//line, bar, scatter(점), area(영역)
				axis		: 'left',
				stacked		: false,					//합칠지 여부
				xField		: 'MONTH',
				title		: ['품목대응율(%)'],					//범례에 변수에 대한 명칭설정
				colors		: ['#008000'],				//#008000 : 녹색
				yField		: ['YEAR1'],
				label		: {
					field	: ['YEAR1'],
					display	: 'insideEnd',				//outside, insideStart, insideEnd
					orientation : 'horizontal',
					renderer	: function (v) {		//라벨 표시 형식 설정
						return Ext.util.Format.number(v, '0,000.00');
					}
				},
				tooltip: {
					trackMouse: true,
					width	: 140,
					height	: 40,
					renderer: function (toolTip, record, ctx) {
						if(!Ext.isEmpty(record)){
							toolTip.setHtml('품목대응율(%)' + record.get('MONTH') + ': ' + record.get('YEAR1'));
						}
					}
				}, style: {
			           stroke: '#008000',
			           lineWidth: 2
			    },marker: {
			            type: 'circle',
			            stroke: '#008000',
			            lineWidth: 2,
			            fill: 'white'
			     }
			},{
				type		: 'line',					//line, bar, scatter(점), area(영역)
				axis		: 'left',
				stacked		: false,					//합칠지 여부
				xField		: 'MONTH',
				title		: ['수량대응율(%)'],					//범례에 변수에 대한 명칭설정
				yField		: ['YEAR2'],
				colors		: ['#0000ff'],				//0000ff : 파랑
				style: {
			           stroke: '#0000ff',
			           lineWidth: 2
			    },marker: {
			            type: 'circle',
			            stroke: '#0000ff',
			            lineWidth: 2,
			            fill: 'white'
			     },
				label		: {
					field	: ['YEAR2'],
					display	: 'over',					//over, under, rotate
					color	: '#0000ff',
					renderer	: function (v) {		//라벨 표시 형식 설정
						return Ext.util.Format.number(v, '0,000.00');
					}
				},
				tooltip: {
					trackMouse: true,
					width	: 140,
					height	: 40,
					renderer: function (toolTip, record, ctx) {
						if(!Ext.isEmpty(record)){
							toolTip.setHtml('수량대응율(%)' + record.get('MONTH')+ ': ' + record.get('YEAR2'));
						}
					}
				}
			}]
		}]
	});
		

	/** 검색조건 (Search Panel)
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
				id: 'search_panel1',
				itemId: 'search_panel1',
				layout: {type: 'uniTable', columns: 1},
				defaultType: 'uniTextfield',
			items: [{
				fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
				name:'DIV_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				allowBlank: false,
				value: UserInfo.divCode,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},{
					fieldLabel: '<t:message code="system.label.product.itemaccount" default="품목게정"/>',
					name: 'ITEM_ACCOUNT',
					xtype: 'uniCombobox',
            		comboType:'AU',
            		comboCode:'B020',
            		allowBlank: false,
            		value		: '10',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('ITEM_ACCOUNT', newValue);
						}						
					}
				},{
				fieldLabel: '수/발주일',
				xtype: 'uniDateRangefield',
				allowBlank: false,
				startFieldName: 'DATE_FR',
				endFieldName:'DATE_TO',
				width: 315,
				startDate: BsaCodeInfo.gsDateFr,
				endDate: UniDate.get('today'),
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
						if(panelResult) {
							panelResult.setValue('DATE_FR',newValue);

						}
					},
					onEndDateChange: function(field, newValue, oldValue, eOpts) {
						if(panelResult) {
							panelResult.setValue('DATE_TO',newValue);
						}
					}
			},{
				xtype: 'radiogroup',
			    fieldLabel: '집계구분',
			    labelWidth: 90,
				items: [{
					boxLabel : '거래처별',
		    		width: 80,
		    		name: 'SELECT_GUBUN',
		    		inputValue: 'C',
		    		checked: true
				},{
					boxLabel: '품목분류별',
					width: 80,
					name: 'SELECT_GUBUN',
					inputValue: 'L'
				}],
				listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							UniAppManager.app.onQueryButtonDown();	
							if(newValue.SELECT_GUBUN == 'C'){								
								masterGridC.show();
//								masterGrid2.show();
//								viewAllChartPanel.show();
								masterGridL.hide();
							};
							if(newValue.SELECT_GUBUN == 'L'){								
								masterGridC.hide();
//								masterGrid2.hide();
//								viewAllChartPanel.hide();
								masterGridL.show();
							};							
							panelResult.getField('SELECT_GUBUN').setValue(newValue.SELECT_GUBUN);
						}
					}
				},{
				xtype: 'radiogroup',
			    fieldLabel: '납기구분',
			    labelWidth: 90,
				items: [{
					boxLabel : '납기변경일',
		    		width: 90,
		    		name: 'DVRY_GUBUN',
		    		inputValue: 'D',
		    		checked: true
				},{
					boxLabel: '(최초)납기일',
					width: 90,
					name: 'DVRY_GUBUN',
					inputValue: 'I'
				}],
				listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							UniAppManager.app.onQueryButtonDown();
							panelResult.getField('DVRY_GUBUN').setValue(newValue.DVRY_GUBUN);
						}
					}
				}
			]}
			],
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

						Unilite.messageBox(labelText+Msg.sMB083);
						invalid.items[0].focus();
					} else {
					//	this.mask();
					}
		  		} else {
  					this.unmask();
  				}
				return r;
  			}
	});//End of var panelSearch = Unilite.createSearchForm('searchForm',{

	var panelResult = Unilite.createSimpleForm('panelResultForm', {
		hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{
			fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
			name:'DIV_CODE',
			xtype: 'uniCombobox',
			comboType: 'BOR120',
			allowBlank: false,
			value: UserInfo.divCode,
			listeners: {
			change: function(field, newValue, oldValue, eOpts) {
				panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},{
				fieldLabel: '<t:message code="system.label.product.itemaccount" default="품목계정"/>',
				name: 'ITEM_ACCOUNT',
				xtype: 'uniCombobox',
        		comboType:'AU',
        		comboCode:'B020',	
        		allowBlank: false,
        		value		: '10',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('ITEM_ACCOUNT', newValue);
					}
				}
			},{
			fieldLabel: '수/발주일',
			xtype: 'uniDateRangefield',
			allowBlank: false,
			startFieldName: 'DATE_FR',
			endFieldName:'DATE_TO',
			colspan:3,
			width: 315,
			startDate: BsaCodeInfo.gsDateFr,
			endDate: UniDate.get('today'),
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('DATE_FR',newValue);

				}
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('DATE_TO',newValue);
				}
			}
		},{
				xtype: 'radiogroup',
			    fieldLabel: '집계구분',
			    labelWidth: 90,
				items: [{
					boxLabel : '거래처별',
		    		width: 80,
		    		name: 'SELECT_GUBUN',
		    		inputValue: 'C',
		    		checked: true
				},{
					boxLabel: '품목분류별',
					width: 80,
					name: 'SELECT_GUBUN',
					inputValue: 'L'
				}],
				listeners: {
						change: function(field, newValue, oldValue, eOpts) {					
							UniAppManager.app.onQueryButtonDown();			
							if(newValue.SELECT_GUBUN == 'C'){								
								masterGridC.show();
//								masterGrid2.show();
//								viewAllChartPanel.show();
								masterGridL.hide();
							};
							if(newValue.SELECT_GUBUN == 'L'){								
								masterGridC.hide();
//								masterGrid2.hide();
//								viewAllChartPanel.hide();
								masterGridL.show();
							};								
							panelSearch.getField('SELECT_GUBUN').setValue(newValue.SELECT_GUBUN);
						}
					}
			},{
				xtype: 'radiogroup',
			    fieldLabel: '납기구분',
			    labelWidth: 90,
				items: [{
					boxLabel : '납기변경일',
		    		width: 90,
		    		name: 'DVRY_GUBUN',
		    		inputValue: 'D',
		    		checked: true
				},{
					boxLabel: '(최초)납기일',
					width: 90,
					name: 'DVRY_GUBUN',
					inputValue: 'I'
				}],
				listeners: {
						change: function(field, newValue, oldValue, eOpts) {							
							UniAppManager.app.onQueryButtonDown();
							panelSearch.getField('DVRY_GUBUN').setValue(newValue.DVRY_GUBUN);
						}
					}
			}
		]
	});

	/** Master Grid1 정의(Grid Panel)
	 * @type
	 */
	var masterGridC = Unilite.createGrid('s_mpo270skrv_kodiGridC', {
		layout : 'fit',
		border		: true,		
		region:'north',
		width		: '100%',
		height		: '45%',		
		store : MasterStoreC,
		uniOpt:{
			expandLastColumn: true,
			useLiveSearch: false,
			useContextMenu: false,
			useMultipleSorting: false,
			useGroupSummary: false,
			useRowNumberer: false,
			onLoadSelectFirst: true,
			filter: {
				useFilter: true,
				autoCreate: true
			}
		},
		features: [
			{id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true},
			{id : 'masterGridTotal' ,   ftype: 'uniSummary', 		 showSummaryRow: true}
		],
		columns:  [
             { dataIndex: 'CUSTOM_CODE'                 ,  width: 100 },
             { dataIndex: 'CUSTOM_NAME'                 ,  width: 250 },
             { dataIndex: 'ORDER_COUNT'                 ,  width: 100 , summaryType: 'sum'},
             { dataIndex: 'ORDER_UNIT_Q_SUM'            ,  width: 120 , summaryType: 'sum'},
             { dataIndex: 'ITEM_COUNT'                  ,  width: 100 , summaryType: 'sum'},
             { dataIndex: 'INSTOCK_Q_SUM'               ,  width: 120 , summaryType: 'sum'},
             { dataIndex: 'C_RESP_RATE'                 ,  width: 120 , summaryType: 'average'},
             { dataIndex: 'Q_RESP_RATE'                 ,  width: 120 , summaryType: 'average'}
		],
		selModel: 'rowmodel',		// 조회화면 selectionchange event 사용
		listeners: {
   		  selectionchange:function( model1, selected, eOpts ){
				if(selected.length > 0)	{
					var record = selected[0];
					MasterStore2.loadStoreRecords(record);
					
	    			var viewAllChartStore = Ext.data.StoreManager.lookup("viewAllChartStore");
	    			viewAllChartStore.loadStoreRecords(); 

				}
		  	}
		}

	});	

		var masterGridL = Unilite.createGrid('s_mpo270skrv_kodiGridL', {
		layout : 'fit',
		border		: true,		
		region:'north',
		width		: '100%',
		height		: '45%',		
		store : MasterStoreL,
		uniOpt:{
			expandLastColumn: true,
			useLiveSearch: false,
			useContextMenu: false,
			useMultipleSorting: false,
			useGroupSummary: false,
			useRowNumberer: false,
			onLoadSelectFirst: true,
			filter: {
				useFilter: true,
				autoCreate: true
			}
		},
		features: [
			{id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true},
			{id : 'masterGridTotal' ,   ftype: 'uniSummary', 		 showSummaryRow: true}
		],
		columns:  [
             { dataIndex: 'ITEM_LEVEL1'                 ,  width: 100 },
             { dataIndex: 'LEVEL_NAME'                  ,  width: 250 },
             { dataIndex: 'ORDER_COUNT'                 ,  width: 100 , summaryType: 'sum'},
             { dataIndex: 'ORDER_UNIT_Q_SUM'            ,  width: 120 , summaryType: 'sum'},
             { dataIndex: 'ITEM_COUNT'                  ,  width: 100 , summaryType: 'sum'},
             { dataIndex: 'INSTOCK_Q_SUM'               ,  width: 120 , summaryType: 'sum'},
             { dataIndex: 'C_RESP_RATE'                 ,  width: 120 , summaryType: 'average'},
             { dataIndex: 'Q_RESP_RATE'                 ,  width: 120 , summaryType: 'average'}
		],
		selModel: 'rowmodel',		// 조회화면 selectionchange event 사용
		listeners: {
   		  selectionchange:function( model1, selected, eOpts ){
				if(selected.length > 0)	{
					var record = selected[0];
					MasterStore2.loadStoreRecords(record);
					
	    			var viewAllChartStore = Ext.data.StoreManager.lookup("viewAllChartStore");
	    			viewAllChartStore.loadStoreRecords(); 

				}
		  	}
		}

	});	

	/**
	 * Master Grid2 정의(Grid Panel)
	 * @type
	 */
	var masterGrid2 = Unilite.createGrid('s_mpo270skrv_kodiGrid2', {
		layout : 'fit',
		region:'center',
		store : MasterStore2,
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
			}
		},
			features: [
			{id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true},
			{id : 'masterGridTotal' ,   ftype: 'uniSummary', 		 showSummaryRow: true}
		],
		columns:  [
		    {dataIndex: 'DIV_CODE'	    , width: 100, hidden:true },
			{dataIndex: 'CUSTOM_CODE'	, width: 100, hidden:true },			
			{dataIndex: 'ORDER_DATE'	, width: 120 },
			{dataIndex: 'ORDER_NUM'	    , width: 120 },
			{dataIndex: 'ORDER_SEQ'	    , width: 60 , align:'center' },		
			{dataIndex: 'ITEM_CODE'	    , width: 150 },
			{dataIndex: 'ITEM_NAME'	    , width: 200 },
			{dataIndex: 'SPEC'	        , width: 150 },
			{dataIndex: 'ORDER_UNIT'	, width: 80, align:'center' },
			{dataIndex: 'ITEM_ACCOUNT'	, width: 100 },
			{dataIndex: 'LEVEL_NAME'	, width: 100 },
			{dataIndex: 'ORDER_UNIT_Q'	, width: 120, summaryType: 'sum' },		
			{dataIndex: 'UNDVRY_Q'	    , width: 120, summaryType: 'sum' },		
			{dataIndex: 'INIT_DVRY_DATE', width: 120 },
			{dataIndex: 'DVRY_DATE'	    , width: 120 },
			{dataIndex: 'GUBUN'	        , width: 60 , align:'center' }

		]
	});	
	
	var tab = Unilite.createTabPanel('tabPanel',{
		activeTab: 0,
		region: 'center',
		items: [{
			title: '실적(Chart)',
			xtype:'container',
			layout:{type:'vbox', align:'stretch'},
			items:[viewAllChartPanel]
		},{
			title: '데이터',
			xtype:'container',
			layout:{type:'vbox', align:'stretch'},
			items:[masterGrid2]
		}],
		tbar: [
		  {xtype:'container',
				layout : {type : 'uniTable', columns : 2},
				padding:'1 1',
				border:true,
				items: [{					
					xtype: 'radiogroup',
				    fieldLabel: '구분',
				    itemId:'autoChartGubun',
				    name: 'CHART_GUBUN',
				    labelWidth: 30,
					items: [{
						boxLabel : '주별',
			    		width: 60,
			    		name: 'CHART_GUBUN',
			    		inputValue: '1'
			    		
					},{
						boxLabel: '월별',
						width: 60,
						name: 'CHART_GUBUN',
						inputValue: '2',
						checked: true
					}],
					listeners: {
							change: function(field, newValue, oldValue, eOpts) {
			    			var viewAllChartStore = Ext.data.StoreManager.lookup("viewAllChartStore");
			    			viewAllChartStore.loadStoreRecords(); 									
		
							}
						}
					
					}]
				
		  }, {
		    text: '납기기간',
		    width: 80,
		    readOnly: true
				
		  },{
		  	xtype:'uniDatefield',
		  	itemId:'autoDvryMin',
			readOnly: true				
		  }, {
		    text: '~',
		    width: 20,
		    readOnly: true
				
		  }, {
		  	xtype:'uniDatefield',
		  	itemId  : 'autoDvryMax',
			readOnly: true				
		  }]
	
	});	
	

	Unilite.Main({
		borderItems:[{
		 region:'center',
		 layout: 'border',
		 border: false,
		items	: [
			panelResult,
			masterGridC,
			masterGridL,
			tab
		]
	  },	 
		 panelSearch
	  ],
		id: 's_mpo270skrv_kodiApp',
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			UniAppManager.setToolbarButtons('save',false);

			panelSearch.setValue('DIV_CODE', UserInfo.divCode);
			panelResult.setValue('DIV_CODE', UserInfo.divCode);

			panelSearch.setValue('DATE_FR', BsaCodeInfo.gsDateFr);
			panelResult.setValue('DATE_FR', BsaCodeInfo.gsDateFr);

			panelSearch.setValue('DATE_TO', UniDate.get('today'));
			panelResult.setValue('DATE_TO', UniDate.get('today'));
			
			viewAllChartPanel.down('cartesian').getLegend().refresh();			
						
			masterGridC.show();
			masterGrid2.show();
			viewAllChartPanel.show();	
			
			masterGridL.hide();

			
		},
		onQueryButtonDown : function()	{
			if(!UniAppManager.app.checkForNewDetail()){
				return false;	
			}else{		

			MasterStoreC.loadStoreRecords();
			MasterStoreL.loadStoreRecords();
			beforeRowIndex = -1;
			
			viewAllChartPanel.down('cartesian').getLegend().refresh();			
//			UniAppManager.setToolbarButtons('reset', true);
			}
		},
//		onResetButtonDown: function() {		// 초기화
//			this.suspendEvents();
//			panelSearch.reset();
//			masterGridC.reset();
//			masterGridL.reset();
//			masterGrid2.reset();
//			panelResult.reset();
//
//			this.fnInitBinding();
//		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		},
		checkForNewDetail:function() {
			return panelSearch.setAllFieldsReadOnly(true);
		}
	});		//End of Unilite.Main({
};
</script>

