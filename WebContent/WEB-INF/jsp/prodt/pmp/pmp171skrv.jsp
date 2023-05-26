<%--
'   프로그램명 : 작업지시현황(공정달력) (생산)
'   작  성  자 : (주)포렌 개발실
'   작  성  일 :
'   최종수정자 :
'   최종수정일 :
'   버      전 : OMEGA Plus V6.0.0
--%>

<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="pmp171skrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="pmp171skrv" /> 					  	<!-- 사업장 -->
    <t:ExtComboStore comboType="AU" comboCode="P001"  />									<!-- 진행상태 -->  
    <t:ExtComboStore items="${COMBO_WS_LIST}" storeId="wsList" /> 						<!-- 작업장 -->  
    <t:ExtComboStore comboType="W" />     <!--작업장(전체) -->
</t:appConfig>
<style type="text/css"> 
.x-change-cell_blue {
background-color: #3BA6CE;
}

</style>
<script type="text/javascript" >

function appMain() {
	//시작일과 끝날의 일 차
	var interval			= null;
	//		
	var addModel = null;
	var columns		= createGridColumn();
	var fields = createModelField();

	Unilite.defineModel('Pmp171skrvModel', {
		fields: fields
	});
				
	var directMasterStore1 = Unilite.createStore('pmp171skrvMasterStore1',{
		model: 'Pmp171skrvModel',
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결 
			editable: false,			// 수정 모드 사용 
			deletable: false,			// 삭제 가능 여부 
			useNavi: false				// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {			
				read: 'pmp171skrvService.selectList'                	
			}
		},
		loadStoreRecords: function() {
			var param= panelResult.getValues();
			console.log( param );
			this.load({
				params: param
			});
		},
		groupField: 'ITEM_CODE',
		listeners: {
           	load: function(store, records, successful, eOpts) {
           	 Ext.each(records, function(record,i) {	
           		var wkordQ = record.data.WKORD_Q;
    			var prodtQ = record.data.PRODT_Q;
             	 record.set('TARGET_RATE',Number.parseInt((prodtQ/wkordQ)*100) + '%');
				}); 
         	store.commitChanges(); 
           	},
           	add: function(store, records, index, eOpts) {
           	},
           	update: function(store, record, operation, modifiedFieldNames, eOpts) {
           	},
           	remove: function(store, record, index, isMove, eOpts) {
           	}
		}
	});//End of var directMasterStore1
	
	 var panelSearch = Unilite.createSearchPanel('searchForm', {
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
		    items:[{	
				title: '<t:message code="system.label.product.basisinfo" default="기본정보"/>', 	
	   			itemId: 'search_panel1',
	           	layout: {type: 'uniTable', columns: 1},
	           	defaultType: 'uniTextfield',
				items:[   
				       {
			        		fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
			        		name: 'DIV_CODE',
			        		value : UserInfo.divCode,
			        		xtype: 'uniCombobox',
			        		comboType: 'BOR120',
			        		allowBlank: false,
			        		colspan:1,
			        		listeners: {
								change: function(field, newValue, oldValue, eOpts) {		
									panelResult.setValue('DIV_CODE',newValue);
								}
			        		}
						},{
				        	fieldLabel: '<t:message code="system.label.product.plannedstartdate" default="착수예정일"/>',
				        	xtype: 'uniDateRangefield',
				        	startFieldName: 'PRODT_START_DATE_FR',
				        	endFieldName: 'PRODT_START_DATE_TO',
				        	width: 315,
				        	startDate: UniDate.get('today'),
				        	endDate: UniDate.get('todayForMonth'),
				        	onStartDateChange: function(field, newValue, oldValue, eOpts) {
				        		if(panelResult) {
				        			panelResult.setValue('PRODT_START_DATE_FR',newValue);
				        		}
						    },
						    onEndDateChange: function(field, newValue, oldValue, eOpts) {
						    	if(panelResult) {
				        			panelResult.setValue('PRODT_START_DATE_TO',newValue);
				        		}
						    }
						},{
							fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
							name: 'WORK_SHOP_CODE',
							xtype: 'uniCombobox',
							comboType: 'W',
							allowBlank: false,
							listeners: {
								change: function(field, newValue, oldValue, eOpts) {			
									panelResult.setValue('WORK_SHOP_CODE',newValue);
								}
							}
						},Unilite.popup('PROG_WORK_CODE',{
								fieldLabel: '<t:message code="system.label.product.routingcode" default="공정코드"/>', 
				        		listeners: {
									onSelected: {
										fn: function(records, type) {
											panelResult.setValue('PROG_WORK_CODE',panelSearch.getValue('PROG_WORK_CODE'));
										},
										scope: this
									},
									onClear: function(type)	{
										panelResult.setValue('PROG_WORK_CODE','');
									},
									applyextparam: function(popup){	
												popup.setExtParam({'DIV_CODE'					: panelSearch.getValue('DIV_CODE')});
												popup.setExtParam({'WORK_SHOP_CODE'	: panelSearch.getValue('WORK_SHOP_CODE')});
									}
								}
						}),Unilite.popup('DIV_PUMOK',{
							fieldLabel: '<t:message code="system.label.product.item" default="품목"/>',
			        		listeners: {
								onSelected: {
									fn: function(records, type) {
										panelResult.setValue('ITEM_CODE', panelSearch.getValue('ITEM_CODE'));
										panelResult.setValue('ITEM_NAME', panelSearch.getValue('ITEM_NAME'));				 																							
									},
									scope: this
								},
								onClear: function(type)	{
									panelSearch.setValue('ITEM_CODE', '');
									panelSearch.setValue('ITEM_NAME', '');
								}
							}
						}),{	
							xtype: 'radiogroup',		            		
							fieldLabel: '진행상태',					            		
							labelWidth:90,
							items: [{
								boxLabel: '<t:message code="system.label.product.whole" default="전체"/>',
								width: 60,
								name: 'WORK_END_YN',
								inputValue: '',
								checked: true
							},{
								boxLabel: '<t:message code="system.label.product.process" default="진행"/>',
								width: 60,
								name: 'WORK_END_YN' ,
								inputValue: 'N'
							},{
								boxLabel: '<t:message code="system.label.product.completion" default="완료"/>',
								width: 60,
								name: 'WORK_END_YN' ,
								inputValue: 'Y'
							},{
								boxLabel: '<t:message code="system.label.product.closing" default="마감"/>',
								width: 60,
								name: 'WORK_END_YN' ,
								inputValue: 'F'
							}],
							listeners: {
									change: function(field, newValue, oldValue, eOpts) {						
										panelResult.getField('WORK_END_YN').setValue(newValue.WORK_END_YN);
									}
								}
						}
					] 
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
						   	Unilite.messageBox(labelText+Msg.sMB083);
						   	invalid.items[0].focus();
						} else {
		   				}
			  		} else {
	  					this.unmask();
	  				}
					return r;
	  			}
    });		// end of var panelResult 
    
		var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 2},
		padding:'2 2 2 2',
		border:true,
		items:[{
        		fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
        		name: 'DIV_CODE',
        		value : UserInfo.divCode,
        		xtype: 'uniCombobox',
        		comboType: 'BOR120',
        		allowBlank: false,
        		colspan:1,
        		listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('DIV_CODE',newValue);
					}
        		}
			},{
	        	fieldLabel: '<t:message code="system.label.product.plannedstartdate" default="착수예정일"/>',
	        	xtype: 'uniDateRangefield',
	        	startFieldName: 'PRODT_START_DATE_FR',
	        	endFieldName: 'PRODT_START_DATE_TO',
	        	width: 315,
	        	startDate: UniDate.get('today'),
	        	endDate: UniDate.get('todayForMonth'),
	        	onStartDateChange: function(field, newValue, oldValue, eOpts) {
	        		if(panelSearch) {
	        			panelSearch.setValue('PRODT_START_DATE_FR',newValue);
	        		}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelSearch.setValue('PRODT_START_DATE_TO',newValue);
	        		}
			    }
			},{
				fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
				name: 'WORK_SHOP_CODE',
				xtype: 'uniCombobox',
				comboType: 'W',
				allowBlank: false,				
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {		
						panelSearch.setValue('WORK_SHOP_CODE',newValue);
					}
				}
			},
				Unilite.popup('PROG_WORK_CODE',{ 
					fieldLabel: '<t:message code="system.label.product.routingcode" default="공정코드"/>', 
	        		listeners: {
						onSelected: {
							fn: function(records, type) {
								panelSearch.setValue('PROG_WORK_CODE',panelResult.gettValue('PROG_WORK_CODE'));
							},
							scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('PROG_WORK_CODE','');
						},
						applyextparam: function(popup){	
									popup.setExtParam({'DIV_CODE'		: panelResult.getValue('DIV_CODE')});
									popup.setExtParam({'WORK_SHOP_CODE' : panelResult.getValue('WORK_SHOP_CODE')});
						}
					}
				}),Unilite.popup('DIV_PUMOK',{ 
					fieldLabel: '<t:message code="system.label.product.item" default="품목"/>', 
	        		listeners: {
						onSelected: {
							fn: function(records, type) {
								panelSearch.setValue('ITEM_CODE', panelResult.getValue('ITEM_CODE'));
								panelSearch.setValue('ITEM_NAME', panelResult.getValue('ITEM_NAME'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelSearch.setValue('ITEM_CODE', '');
							panelSearch.setValue('ITEM_NAME', '');
						}
					}
			}),{	
				xtype: 'radiogroup',		            		
				fieldLabel: '진행상태',						            		
				labelWidth:90,
				items: [{
					boxLabel: '<t:message code="system.label.product.whole" default="전체"/>',
					width: 60,
					name: 'WORK_END_YN',
					inputValue: '',
					checked: true
				},{
					boxLabel: '<t:message code="system.label.product.process" default="진행"/>',
					width: 60,
					name: 'WORK_END_YN' ,
					inputValue: 'N'
				},{
					boxLabel: '<t:message code="system.label.product.completion" default="완료"/>',
					width: 60,
					name: 'WORK_END_YN' ,
					inputValue: 'Y'
				},{
					boxLabel: '<t:message code="system.label.product.closing" default="마감"/>',
					width: 60,
					name: 'WORK_END_YN' ,
					inputValue: 'F'
				}],
				listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.getField('WORK_END_YN').setValue(newValue.WORK_END_YN);
					}
				}
			}
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
		   				}
			  		} else {
	  					this.unmask();
	  				}
					return r;
	  			}
    });		// end of var panelResult 

	var masterGrid = Unilite.createGrid('pmp171skrvGrid1', {
		layout: 'fit',
		region: 'center',
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
		    	useState: false,	//그리드 설정 버튼 사용 여부 
		   		useStateList: false	//그리드 설정 목록 사용 여부 
			}
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
		columns:  columns
	});//End of var masterGrid
	
	Unilite.Main( {
			borderItems:[{
				region:'center',
				layout: 'border',
				border: false,
				items:[
					masterGrid, panelResult
				]
			},panelSearch
		],	
		id: 'pmp170rkrvApp',
		fnInitBinding: function(){
			UniAppManager.setToolbarButtons(['reset','detail', 'save'], false);
			panelResult.setValue('DIV_CODE', UserInfo.divCode);
			panelResult.setValue('PRODT_START_DATE_FR', UniDate.get('today'));
			panelResult.setValue('PRODT_START_DATE_TO', UniDate.get('todayForMonth'));
			day_change(masterGrid);
		},
		onQueryButtonDown: function() {
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{
		        addModel = null;
		        createModelStore();
		        
			    UniAppManager.setToolbarButtons('excel',true);
			    UniAppManager.setToolbarButtons('reset', true);
			}
		},
		onResetButtonDown: function() {
			panelResult.clearForm();
			panelResult.setValue('BASIS_YYYYMM',UniDate.get('startOfMonth'));
			masterGrid.reset();
			directMasterStore1.clearData();
			this.fnInitBinding();
		},
		checkForNewDetail:function() {
			if(panelResult.setAllFieldsReadOnly(true))
				return panelResult.setAllFieldsReadOnly(true);
			else return false;
        }
	});//End of Unilite.Main

	function createGridColumn() {
		if(panelResult){
			var beforeConvertFr = UniDate.getDbDateStr(panelResult.getValue('PRODT_START_DATE_FR')).substring(0,4) + '/' + UniDate.getDbDateStr(panelResult.getValue('PRODT_START_DATE_FR')).substring(4,6) + '/' + UniDate.getDbDateStr(panelResult.getValue('PRODT_START_DATE_FR')).substring(6,8);
			var beforeConvertTO = UniDate.getDbDateStr(panelResult.getValue('PRODT_START_DATE_TO')).substring(0,4) + '/' + UniDate.getDbDateStr(panelResult.getValue('PRODT_START_DATE_TO')).substring(4,6) + '/' + UniDate.getDbDateStr(panelResult.getValue('PRODT_START_DATE_TO')).substring(6,8);
		}else{
			var beforeConvertFr = UniDate.getDbDateStr(UniDate.get('today')).substring(0,4) + '/' + UniDate.getDbDateStr(UniDate.get('today')).substring(4,6) + '/' + UniDate.getDbDateStr(UniDate.get('today')).substring(6,8);
			var beforeConvertTO = UniDate.getDbDateStr(UniDate.get('todayForMonth')).substring(0,4) + '/' + UniDate.getDbDateStr(UniDate.get('todayForMonth')).substring(4,6) + '/' + UniDate.getDbDateStr(UniDate.get('todayForMonth')).substring(6,8);
		}
		var startDateT	= new Date(beforeConvertFr);
		var endDateT		= new Date(beforeConvertTO);
		var sDate = startDateT;
		var eDate = endDateT;
		var columns = [        
			{dataIndex: 'WORK_END_YN'     	, width: 40		, locked: false , hidden: true}, 	  			
			{dataIndex: 'PROG_WORK_CODE'  	, width: 70 , hidden: true}, 	  			 			
			{dataIndex: 'PROG_WORK_NAME'  	, width: 100	, locked: true,  style: {textAlign: 'center' },
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.product.subtotal" default="소계"/>', '<t:message code="system.label.product.total" default="총계"/>');
			}}, 	  		
			{dataIndex: 'ITEM_CODE'       	, width: 90	, locked: true,  style: {textAlign: 'center' }}, 	  			
			{dataIndex: 'ITEM_NAME'       	, width: 146	, locked: true,  style: {textAlign: 'center' }}, 	
			{dataIndex: 'WKORD_NUM'       	, width: 130	, locked: true,  style: {textAlign: 'center' }}, 	  						
			{dataIndex: 'PRODT_START_DATE'	, width: 100 	 , hidden: true , locked: true}, 	  			 			
			{dataIndex: 'PRODT_END_DATE'  	, width: 100 	 , hidden: true , locked: true}, 	  			
			{dataIndex: 'WKORD_Q'         	, width: 90, locked: true  , align: 'right'  ,summaryType: 'sum' ,  style: {textAlign: 'center' }}, 	  			 	 		
			{dataIndex: 'PRODT_Q'        	, width: 73, locked: true , align: 'right' , summaryType: 'sum' ,  style: {textAlign: 'center' }}, 
			{dataIndex: 'TARGET_RATE' , width: 90, locked: true  , align: 'right' , summaryType: 'sum' ,  style: {textAlign: 'center' }},
			{dataIndex: 'ORDER_NUM' , width: 130, locked: true   , hidden: true, align: 'right' ,  style: {textAlign: 'center' }},
			{dataIndex: 'CUSTOM_NAME' , width: 100, locked: true   , hidden: true, align: 'right' ,  style: {textAlign: 'center' }}
		];
		var i=0; 
		while((eDate.getTime()-sDate.getTime())>=0){
				var year = sDate.getFullYear();
				var month = (sDate.getMonth()+1).toString().length==1?"0"+(sDate.getMonth()+1).toString():(sDate.getMonth()+1);
				var day = sDate.getDate().toString().length==1?"0"+sDate.getDate():sDate.getDate();
				var weekDay = getDate(sDate.toDateString().substring(0,3));
				columns.push(
						{text :month + '월' + day + '일',
		        			columns:[
				              {dataIndex: 'WKORD_DATE' +year+month+day    , text: weekDay,      width: 76  , style: 'text-align: center' , xtype:'uniNnumberColumn'  , format: 'string', 
				                  renderer: function(value, metaData, record) { 
				                  	var today = UniDate.getDateStr(UniDate.today());
				                  	/* if(metaData.column.dataIndex == 'WKORD_DATE'+today){
				                  		metaData.tdCls = 'data-selected';	
				                  	} */
				                  	if(metaData.column.dataIndex == 'WKORD_DATE'+record.data.PRODT_START_DATE){
				                  		metaData.tdCls = 'x-change-cell_blue';	
				                  	}else if(metaData.column.dataIndex.substring(10,19) >= record.data.PRODT_START_DATE && metaData.column.dataIndex.substring(10,19) < record.data.PRODT_END_DATE){
				                  		var beforeConvertFrT = UniDate.getDbDateStr(record.data.PRODT_START_DATE).substring(0,4) + '/' + UniDate.getDbDateStr(record.data.PRODT_START_DATE).substring(4,6) + '/' + UniDate.getDbDateStr(record.data.PRODT_START_DATE).substring(6,8);
				           			var beforeConvertTOT = UniDate.getDbDateStr(record.data.PRODT_END_DATE).substring(0,4) + '/' + UniDate.getDbDateStr(record.data.PRODT_END_DATE).substring(4,6) + '/' + UniDate.getDbDateStr(record.data.PRODT_END_DATE).substring(6,8);
				           			var startDateTT	= new Date(beforeConvertFrT);
				           			var endDateTT		= new Date(beforeConvertTOT);
				           			var sDateT = startDateTT;
				           			var eDateT = endDateTT;
				                   	var j=0;
				                   	while((eDateT.getTime()-sDateT.getTime())>=0){
				               			var yearT = sDateT.getFullYear();
				               			var monthT = (sDateT.getMonth()+1).toString().length==1?"0"+(sDateT.getMonth()+1).toString():(sDateT.getMonth()+1);
				               			var dayT = sDateT.getDate().toString().length==1?"0"+sDateT.getDate():sDateT.getDate();
				               			if('WKORD_DATE' +yearT+monthT+dayT == 'WKORD_DATE'+record.data.PRODT_END_DATE){
				                    		metaData.tdCls = 'x-change-cell_blue';	
				                    	}
				               			sDateT.setDate(sDateT.getDate()+1);
				              			  j++;
				              			}
				                  	}
				                  	if(metaData.column.dataIndex == 'WKORD_DATE'+record.data.PRODT_END_DATE){
				                  		metaData.tdCls = 'x-change-cell_blue';	
				                  	}
				                      return value; 
				                  }
				              }
		    		]
	    		}
				  );
				  sDate.setDate(sDate.getDate()+1);
				  i++;
			}
		
		return columns;
	};

function createModelField() {
		if(panelResult){
			var beforeConvertFr = UniDate.getDbDateStr(panelResult.getValue('PRODT_START_DATE_FR')).substring(0,4) + '/' + UniDate.getDbDateStr(panelResult.getValue('PRODT_START_DATE_FR')).substring(4,6) + '/' + UniDate.getDbDateStr(panelResult.getValue('PRODT_START_DATE_FR')).substring(6,8);
			var beforeConvertTO = UniDate.getDbDateStr(panelResult.getValue('PRODT_START_DATE_TO')).substring(0,4) + '/' + UniDate.getDbDateStr(panelResult.getValue('PRODT_START_DATE_TO')).substring(4,6) + '/' + UniDate.getDbDateStr(panelResult.getValue('PRODT_START_DATE_TO')).substring(6,8);
		}else{
			var beforeConvertFr = UniDate.getDbDateStr(UniDate.get('today')).substring(0,4) + '/' + UniDate.getDbDateStr(UniDate.get('today')).substring(4,6) + '/' + UniDate.getDbDateStr(UniDate.get('today')).substring(6,8);
			var beforeConvertTO = UniDate.getDbDateStr(UniDate.get('todayForMonth')).substring(0,4) + '/' + UniDate.getDbDateStr(UniDate.get('todayForMonth')).substring(4,6) + '/' + UniDate.getDbDateStr(UniDate.get('todayForMonth')).substring(6,8);
		}
		var startDateT	= new Date(beforeConvertFr);
		var endDateT		= new Date(beforeConvertTO);
		var sDate = startDateT;
		var eDate = endDateT;
		var fields = [
						{name: 'WORK_END_YN'     			, text: '<t:message code="system.label.product.status" default="상태"/>'								, type: 'string' 	, comboType:'AU'	, comboCode:'P001'},
						{name: 'PROG_WORK_CODE'  		, text: '<t:message code="system.label.product.routingcode" default="공정코드"/>'				, type: 'string'},
						{name: 'PROG_WORK_NAME'  	, text: '<t:message code="system.label.product.routingname" default="공정명"/>'					, type: 'string'},
						{name: 'WKORD_NUM'       			, text: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>'  		, type: 'string'},
						{name: 'ITEM_CODE'       				, text: '<t:message code="system.label.product.item" default="품목"/>'									, type: 'string'},
						{name: 'ITEM_NAME'       				, text: '<t:message code="system.label.product.itemname" default="품목명"/>'						, type: 'string'},
						{name: 'PRODT_START_DATE'		, text: '<t:message code="system.label.product.plannedstartdate" default="착수예정일"/>'	, type: 'string'},
						{name: 'PRODT_END_DATE'  		, text: '<t:message code="system.label.product.completiondate" default="완료예정일"/>'		, type: 'string'},
						{name: 'WKORD_Q'         				, text: '<t:message code="system.label.product.workorderqty" default="작업지시량"/>'			, type: 'uniQty'},
						{name: 'PRODT_Q'         				, text: '<t:message code="system.label.product.productionqty" default="생산량"/>'				, type: 'uniQty'},
						{name: 'TARGET_RATE'					, text: '달성율(%)'						, type: 'uniQty'},
						{name: 'ORDER_NUM'					, text: '수주번호'						, type: 'string'},
						{name: 'CUSTOM_NAME'				, text: '거래처'						, type: 'string'}
				 ];
		var j=0; 
		while((eDate.getTime()-sDate.getTime())>=0){
			var year = sDate.getFullYear();
			var month = (sDate.getMonth()+1).toString().length==1?"0"+(sDate.getMonth()+1).toString():(sDate.getMonth()+1);
			var day = sDate.getDate().toString().length==1?"0"+sDate.getDate():sDate.getDate();
			fields.push({name: 'WKORD_DATE'+year+month+day    , text: month + '월' + day + '일',     type : 'string'});
			sDate.setDate(sDate.getDate()+1);
			j++;
		}
		console.log(fields);
		return fields;
	};

function createModelStore() {
		var beforeConvertFr = UniDate.getDbDateStr(panelResult.getValue('PRODT_START_DATE_FR')).substring(0,4) + '/' + UniDate.getDbDateStr(panelResult.getValue('PRODT_START_DATE_FR')).substring(4,6) + '/' + UniDate.getDbDateStr(panelResult.getValue('PRODT_START_DATE_FR')).substring(6,8);
		var beforeConvertTO = UniDate.getDbDateStr(panelResult.getValue('PRODT_START_DATE_TO')).substring(0,4) + '/' + UniDate.getDbDateStr(panelResult.getValue('PRODT_START_DATE_TO')).substring(4,6) + '/' + UniDate.getDbDateStr(panelResult.getValue('PRODT_START_DATE_TO')).substring(6,8);
		var startDate	= new Date(beforeConvertFr);
		var endDate		= new Date(beforeConvertTO);
	
		var fields = createModelField();
		var addColumn = createGridColumn();
		var tempModelName = new Date().toString();
		
		addModel = Unilite.defineModel(tempModelName, {
			fields: fields
		});
		var addStore = Unilite.createStore('pmp171skrvaddStore', {
			model: tempModelName,
			uniOpt: {
				isMaster: true,			// 상위 버튼 연결 
				editable: false,			// 수정 모드 사용 
				deletable: false,			// 삭제 가능 여부 
				useNavi: false			// prev | newxt 버튼 사용
			},
			autoLoad: false,
			proxy: {
				type: 'direct',
				api: {			
					read: 'pmp171skrvService.selectList'                	
				}
			},
			loadStoreRecords: function(){
				var param= panelResult.getValues();
				console.log(param);
				this.load({
					params: param
				});
			},
			listeners: {
		          	load: function(store, records, successful, eOpts) {
		          		setColumnText();
		          		day_change(masterGrid);
		          	},
		          	add: function(store, records, index, eOpts) {
		          	},
		          	update: function(store, record, operation, modifiedFieldNames, eOpts) {
		          	},
		          	remove: function(store, record, index, isMove, eOpts) {
		          	}
			},
			groupField: 'PROG_WORK_NAME'
		});
		addStore.loadStoreRecords();
		masterGrid.setColumnInfo(masterGrid, addColumn, fields);
		masterGrid.reconfigure(addStore, addColumn);
	};
	
	function setColumnText() {
		masterGrid.getColumn("WORK_END_YN").setText("상태");    	
		masterGrid.getColumn("PROG_WORK_CODE").setText("공정코드");  	
		masterGrid.getColumn("PROG_WORK_NAME").setText("공정명"); 	
		masterGrid.getColumn("WKORD_NUM").setText("작업지시번호");      	
		masterGrid.getColumn("ITEM_CODE").setText("픔목코드");      	
		masterGrid.getColumn("ITEM_NAME").setText("품명");      	
		masterGrid.getColumn("PRODT_START_DATE").setText("착수예정일");
		masterGrid.getColumn("PRODT_END_DATE").setText("완료예정일"); 	
		masterGrid.getColumn("WKORD_Q").setText("작업지시량");        	
		masterGrid.getColumn("PRODT_Q").setText("생산량");       	
		masterGrid.getColumn("TARGET_RATE").setText("달성율(%)");	 
		masterGrid.getColumn("ORDER_NUM").setText("수주번호");	 
		masterGrid.getColumn("CUSTOM_NAME").setText("거래처");	 
	};
	
	function getDate(weekDay){
		var weekdays=new Array(7);
		weekdays[0]='<t:message code="system.label.product.sunday" default="일"/>';
		weekdays[1]='<t:message code="system.label.product.monday" default="월"/>';
		weekdays[2]='<t:message code="system.label.product.tuesday" default="화"/>';
		weekdays[3]='<t:message code="system.label.product.wednesday" default="수"/>';
		weekdays[4]='<t:message code="system.label.product.Thursday" default="목"/>';
		weekdays[5]='<t:message code="system.label.product.Friday" default="금"/>';
		weekdays[6]='<t:message code="system.label.product.saturday" default="토"/>';
		switch(weekDay){
		case "Sun" :
			weekDay = weekdays[0];
		break;
		case "Mon" :
			weekDay = weekdays[1];
		break;
		case "Tue" :
			weekDay = weekdays[2];
		break;
		case "Wed" :
			weekDay = weekdays[3];
		break;
		case "Thu" :
			weekDay = weekdays[4];
		break;
		case "Fri" :
			weekDay = weekdays[5];
		break;
		case "Sat" :
			weekDay = weekdays[6];
		break;
		}
		return weekDay;
	};
	
	function day_change(masterGrid){
    	if(panelResult){
			var beforeConvertFr = UniDate.getDbDateStr(panelResult.getValue('PRODT_START_DATE_FR')).substring(0,4) + '/' + UniDate.getDbDateStr(panelResult.getValue('PRODT_START_DATE_FR')).substring(4,6) + '/' + UniDate.getDbDateStr(panelResult.getValue('PRODT_START_DATE_FR')).substring(6,8);
			var beforeConvertTO = UniDate.getDbDateStr(panelResult.getValue('PRODT_START_DATE_TO')).substring(0,4) + '/' + UniDate.getDbDateStr(panelResult.getValue('PRODT_START_DATE_TO')).substring(4,6) + '/' + UniDate.getDbDateStr(panelResult.getValue('PRODT_START_DATE_TO')).substring(6,8);
		}else{
			var beforeConvertFr = UniDate.getDbDateStr(UniDate.get('today')).substring(0,4) + '/' + UniDate.getDbDateStr(UniDate.get('today')).substring(4,6) + '/' + UniDate.getDbDateStr(UniDate.get('today')).substring(6,8);
			var beforeConvertTO = UniDate.getDbDateStr(UniDate.get('todayForMonth')).substring(0,4) + '/' + UniDate.getDbDateStr(UniDate.get('todayForMonth')).substring(4,6) + '/' + UniDate.getDbDateStr(UniDate.get('todayForMonth')).substring(6,8);
		}
		var startDateT	= new Date(beforeConvertFr);
		var endDateT		= new Date(beforeConvertTO);
		var sDate = startDateT;
		var eDate = endDateT;
		var k = 0;
    	while((eDate.getTime()-sDate.getTime())>=0){
			var year = sDate.getFullYear();
			var month = (sDate.getMonth()+1).toString().length==1?"0"+(sDate.getMonth()+1).toString():(sDate.getMonth()+1);
			var day = sDate.getDate().toString().length==1?"0"+sDate.getDate():sDate.getDate();
			var today = UniDate.getDateStr(UniDate.today());
			if(masterGrid.getColumn("WKORD_DATE"+year+month+day).text == "일"){
				masterGrid.getColumn("WKORD_DATE"+year+month+day).setStyle('color', 'red');
			}
			if(masterGrid.getColumn("WKORD_DATE"+year+month+day).text == "토"){
				masterGrid.getColumn("WKORD_DATE"+year+month+day).setStyle('color', 'blue');
			}
			masterGrid.getColumn("WKORD_DATE"+today).setStyle('background-color', '#62CEDB');
			sDate.setDate(sDate.getDate()+1);
			k++;
		}
    	
    	
    	
    };
}
</script>
