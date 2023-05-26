<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="agb260skr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 --> 
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

var getStDt = Ext.isEmpty(${getStDt}) ? []: ${getStDt} ;								//당기시작월 관련 전역변수

function appMain() {    
	var columnName1 = ''; 
	var deptList 	= ${deptList};
	var fields		= createModelField(deptList);
	var columns		= createGridColumn();
	var columns2	= createGridColumn2();
	var columns3	= createGridColumn3();
	var columns4	= createGridColumn4();
	
	
	
	
	
	
	
	Unilite.defineModel('Agb260skrModel', {
	    fields: fields        
	});
	  
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('agb260skrMasterStore1',{
		model: 'Agb260skrModel',
		uniOpt: {
            isMaster: false,			// 상위 버튼 연결 
            editable: false,			// 수정 모드 사용 
            deletable:false,			// 삭제 가능 여부 
	        useNavi : false				// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
           type: 'direct',
            api: {			
                read: 'agb260skrService.selectList'                	
            }
        },
        loadStoreRecords: function(records) {
			var param= Ext.getCmp('searchForm').getValues();
			var startField = panelSearch.getField('FR_DATE');
			var startDateValue = startField.getStartDate();
			var endField = panelSearch.getField('TO_DATE');
			var endDateValue = endField.getEndDate();
			var deptList = [];
			for(i=0; i < records.length; i++) {
				deptList[i] = records[i].DEPT_CODE;
			}
			param.QUERY_TYPE = '1'
			param.FR_DATE = startDateValue
			param.TO_DATE = endDateValue
			param.deptInfoList = deptList;
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	
	var directMasterStore2 = Unilite.createStore('agb260skrMasterStore2',{
		model: 'Agb260skrModel',
		uniOpt: {
            isMaster: false,			// 상위 버튼 연결 
            editable: false,			// 수정 모드 사용 
            deletable:false,			// 삭제 가능 여부 
	        useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
           type: 'direct',
            api: {			
                read: 'agb260skrService.selectList'                	
            }
        },
        loadStoreRecords: function(records) {
			var param= Ext.getCmp('searchForm').getValues();
			var startField = panelSearch.getField('FR_DATE');
			var startDateValue = startField.getStartDate();
			var endField = panelSearch.getField('TO_DATE');
			var endDateValue = endField.getEndDate();
			var deptList = [];
			for(i=0; i < records.length; i++) {
				deptList[i] = records[i].DEPT_CODE;
			}
			param.QUERY_TYPE = '2'
			param.FR_DATE = startDateValue
			param.TO_DATE = endDateValue
			param.deptInfoList = deptList;
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	
	var directMasterStore3 = Unilite.createStore('agb260skrMasterStore3',{
		model: 'Agb260skrModel',
		uniOpt: {
            isMaster: false,			// 상위 버튼 연결 
            editable: false,			// 수정 모드 사용 
            deletable:false,			// 삭제 가능 여부 
	        useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
           type: 'direct',
            api: {			
                read: 'agb260skrService.selectList'                	
            }
        },
        loadStoreRecords: function(records) {
			var param= Ext.getCmp('searchForm').getValues();
			var startField = panelSearch.getField('FR_DATE');
			var startDateValue = startField.getStartDate();
			var endField = panelSearch.getField('TO_DATE');
			var endDateValue = endField.getEndDate();
			var deptList = [];
			for(i=0; i < records.length; i++) {
				deptList[i] = records[i].DEPT_CODE;
			}
			param.QUERY_TYPE = '3'
			param.FR_DATE = startDateValue
			param.TO_DATE = endDateValue
			param.deptInfoList = deptList;
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	
	var directMasterStore4 = Unilite.createStore('agb260skrMasterStore4',{
		model: 'Agb260skrModel',
		uniOpt: {
            isMaster: false,			// 상위 버튼 연결 
            editable: false,			// 수정 모드 사용 
            deletable:false,			// 삭제 가능 여부 
	        useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
           type: 'direct',
            api: {			
                read: 'agb260skrService.selectList'                	
            }
        },
        loadStoreRecords: function(records) {
			var param= Ext.getCmp('searchForm').getValues();
			var startField = panelSearch.getField('FR_DATE');
			var startDateValue = startField.getStartDate();
			var endField = panelSearch.getField('TO_DATE');
			var endDateValue = endField.getEndDate();
			var deptList = [];
			for(i=0; i < records.length; i++) {
				deptList[i] = records[i].DEPT_CODE;
			}
			param.QUERY_TYPE = '4'
			param.FR_DATE = startDateValue
			param.TO_DATE = endDateValue
			param.deptInfoList = deptList;
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '검색조건',
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
			title: '기본정보', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items: [{ 
				fieldLabel: '전표일',
	 		    xtype: 'uniMonthRangefield',
	            startFieldName: 'FR_DATE',
	            endFieldName: 'TO_DATE',
				holdable: 'hold',
		        startDD: 'first',
		        endDD: 'last',
	            allowBlank: false,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('FR_DATE',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('TO_DATE',newValue);
			    	}
			    }
			},{
				fieldLabel: '사업장',
				name:'ACCNT_DIV_CODE', 
				xtype: 'uniCombobox',
		        multiSelect: true, 
		        typeAhead: false,
		        value:UserInfo.divCode,
		        comboType:'BOR120',
				width: 325,
				colspan:2,
				listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('ACCNT_DIV_CODE', newValue);
						}
					}
			},
				Unilite.popup('DEPT',{ 
				    fieldLabel: '부서', 
				    popupWidth: 910,
				    valueFieldName: 'DEPT_CODE_FR',
					textFieldName: 'DEPT_NAME_FR',
					listeners: {
						onSelected: {
							fn: function(records, type) {
								panelResult.setValue('DEPT_CODE_FR', panelSearch.getValue('DEPT_CODE_FR'));
								panelResult.setValue('DEPT_NAME_FR', panelSearch.getValue('DEPT_NAME_FR'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('DEPT_CODE_FR', '');
							panelResult.setValue('DEPT_NAME_FR', '');
						},
						applyextparam: function(popup){							
							//popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
					}  
			}),   	
				Unilite.popup('DEPT',{ 
					fieldLabel: '~', 
					popupWidth: 910,
					valueFieldName: 'DEPT_CODE_TO',
					textFieldName: 'DEPT_NAME_TO',
					listeners: {
						onSelected: {
							fn: function(records, type) {
								panelResult.setValue('DEPT_CODE_TO', panelSearch.getValue('DEPT_CODE_TO'));
								panelResult.setValue('DEPT_NAME_TO', panelSearch.getValue('DEPT_NAME_TO'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('DEPT_CODE_TO', '');
							panelResult.setValue('DEPT_NAME_TO', '');
						},
						applyextparam: function(popup){							
							//popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
					}  
			}),{
				xtype: 'radiogroup',		            		
				fieldLabel: '과목구분',
				items: [{
					boxLabel: '과목', 
					width: 70, 
					name: 'ACCNT_DIVI',
					inputValue: '1',
					checked: true  
				},{
					boxLabel : '세목', 
					width: 70,
					name: 'ACCNT_DIVI',
					inputValue: '2'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.getField('ACCNT_DIVI').setValue(newValue.ACCNT_DIVI);
						UniAppManager.app.onQueryButtonDown();
					}
				}
			}]				
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
			          		var labelText = invalid.items[0]['fieldLabel']+'은(는)';
			        	} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
			          		var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
			        	}
						alert(labelText+Msg.sMB083);
			        	invalid.items[0].focus();
			     	} else {
			      		//this.mask();
			      		var fields = this.getForm().getFields();
			      		Ext.each(fields.items, function(item) {
			       			if(Ext.isDefined(item.holdable) ) {
			         			if (item.holdable == 'hold') {
			         				item.setReadOnly(true); 
			        			}
			       			} 
			       			if(item.isPopupField) {
			        			var popupFC = item.up('uniPopupField') ;       
			        			if(popupFC.holdable == 'hold') {
			         				popupFC.setReadOnly(true);
			        			}
			       			}
			      		})
			       	}
			    } else {
			    	//this.unmask();
			       	var fields = this.getForm().getFields();
			     	Ext.each(fields.items, function(item) {
			      		if(Ext.isDefined(item.holdable) ) {
			        		if (item.holdable == 'hold') {
			        			item.setReadOnly(false);
			       			}
			      		} 
			      		if(item.isPopupField) {
			       			var popupFC = item.up('uniPopupField') ; 
			       			if(popupFC.holdable == 'hold' ) {
			        			item.setReadOnly(false);
			      			}
			      		}
			     	})
			    }
			    return r;
			}
	});	 
	
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{ 
			fieldLabel: '계산서일',
 		    width: 315,
            xtype: 'uniMonthRangefield',
            startFieldName: 'FR_DATE',
            endFieldName: 'TO_DATE',
			holdable: 'hold',
	        startDD: 'first',
	        endDD: 'last',
            allowBlank: false,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelSearch) {
					panelSearch.setValue('FR_DATE',newValue);
            	}
		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('TO_DATE',newValue);
		    	}
		    }
     	},{
			fieldLabel: '사업장',
			name:'ACCNT_DIV_CODE', 
			xtype: 'uniCombobox',
	        multiSelect: true, 
	        typeAhead: false,
	        value:UserInfo.divCode,
	        comboType:'BOR120',
			width: 325,
			colspan:2,
			listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('ACCNT_DIV_CODE', newValue);
					}
				}
	    },
			Unilite.popup('DEPT',{ 
			    fieldLabel: '부서',
			    popupWidth: 910,
			    valueFieldName: 'DEPT_CODE_FR',
				textFieldName: 'DEPT_NAME_FR',
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('DEPT_CODE_FR', panelResult.getValue('DEPT_CODE_FR'));
							panelSearch.setValue('DEPT_NAME_FR', panelResult.getValue('DEPT_NAME_FR'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('DEPT_CODE_FR', '');
						panelSearch.setValue('DEPT_NAME_FR', '');
					},
					applyextparam: function(popup){							
						//popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					}
				}  
		}),   	
			Unilite.popup('DEPT',{ 
				fieldLabel: '~',
				labelWidth: 15,
				valueFieldName: 'DEPT_CODE_TO',
				textFieldName: 'DEPT_NAME_TO',
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('DEPT_CODE_TO', panelResult.getValue('DEPT_CODE_TO'));
							panelSearch.setValue('DEPT_NAME_TO', panelResult.getValue('DEPT_NAME_TO'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('DEPT_CODE_TO', '');
						panelSearch.setValue('DEPT_NAME_TO', '');
					},
					applyextparam: function(popup){							
						//popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					}
				}  
			}),{
				xtype: 'radiogroup',		            		
				fieldLabel: '과목구분',
				items: [{
					boxLabel: '과목', 
					width: 70, 
					name: 'ACCNT_DIVI',
					inputValue: '1',
					checked: true  
				},{
					boxLabel : '세목', 
					width: 70,
					name: 'ACCNT_DIVI',
					inputValue: '2'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.getField('ACCNT_DIVI').setValue(newValue.ACCNT_DIVI);
						UniAppManager.app.onQueryButtonDown();
				}
			}
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
			          		var labelText = invalid.items[0]['fieldLabel']+'은(는)';
			        	} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
			          		var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
			        	}
						alert(labelText+Msg.sMB083);
			        	invalid.items[0].focus();
			     	} else {
			      		//this.mask();
			      		var fields = this.getForm().getFields();
			      		Ext.each(fields.items, function(item) {
			       			if(Ext.isDefined(item.holdable) ) {
			         			if (item.holdable == 'hold') {
			         				item.setReadOnly(false); 	// true
			        			}
			       			} 
			       			if(item.isPopupField) {
			        			var popupFC = item.up('uniPopupField') ;       
			        			if(popupFC.holdable == 'hold') {
			         				popupFC.setReadOnly(false);	// true
			        			}
			       			}
			      		})
			       	}
			    } else {
			    	//this.unmask();
			       	var fields = this.getForm().getFields();
			     	Ext.each(fields.items, function(item) {
			      		if(Ext.isDefined(item.holdable) ) {
			        		if (item.holdable == 'hold') {
			        			item.setReadOnly(false);
			       			}
			      		} 
			      		if(item.isPopupField) {
			       			var popupFC = item.up('uniPopupField') ; 
			       			if(popupFC.holdable == 'hold' ) {
			        			item.setReadOnly(false);
			      			}
			      		}
			     	})
			    }
			    return r;
			}
	});	 
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('agb260skrGrid1', {
    	title : '판매비와관리비',
    	layout : 'fit',
//    	id: 'N1',
        store : directMasterStore, 
        uniOpt:{	expandLastColumn: true,
        			useRowNumberer: true,
                    useMultipleSorting: true
        },
    	features: [{
    		id: 'masterGridSubTotal',
    		ftype: 'uniGroupingsummary', 
    		showSummaryRow: false 
    		},{
    		id: 'masterGridTotal', 	
    		ftype: 'uniSummary', 	  
    		showSummaryRow: true
    	}],
        columns: columns,
		listeners: {
          	itemmouseenter:function(view, record, item, index, e, eOpts, column )	{ 
	        	view.ownerGrid.setCellPointer(view, item);
        	},
            onGridDblClick :function( grid, record, cellIndex, colName ) {
            	
            	if(grid.eventPosition.column.dataIndex != 'DIVI' &&
                    grid.eventPosition.column.dataIndex != 'ACCNT' &&
                    grid.eventPosition.column.dataIndex != 'ACCNT_NAME' &&
                    grid.eventPosition.column.dataIndex != 'AMT_TOT' &&
                    grid.eventPosition.column.dataIndex != '' 
                ){
                    columnName1=colName;
                    masterGrid.gotoAfb260(record);
                }
            }
        }, 
        onItemcontextmenu:function( menu, grid, record, item, index, event  )	{	

        	if(event.position.column.dataIndex != 'DIVI' &&
            	event.position.column.dataIndex != 'ACCNT' &&
            	event.position.column.dataIndex != 'ACCNT_NAME' &&
            	event.position.column.dataIndex != 'AMT_TOT' &&
            	event.position.column.dataIndex != '' 
        	){
        		columnName1 = grid.eventPosition.column.dataIndex;
	      	    return true;
        	}
      	},      
      	uniRowContextMenu:{
			items: [{	
	             	text: '보조부 이동',   
	             	itemId	: 'linkAgb110skr',
	            	handler: function(menuItem, event) {
	            		var param = menuItem.up('menu');
	            		masterGrid.gotoAfb260(param.record);
	            	}
	        	}
	        ]
	    },
	    gotoAfb260:function(record)	{
			if(record)	{
				var temp = UniDate.getDbDateStr(panelSearch.getValue('TO_DATE')).substring(0, 6) + '01';
				var lastDay = (new Date(temp.substring(0,4), temp.substring(4,6), 0)).getDate();   // 해당 날짜의 마지막날자 구하기 new Date('년도' , '월' , 0 ).getDate()
				var from_date = UniDate.getDbDateStr(panelSearch.getValue('FR_DATE')).substring(0, 6) + '01';
				var to_date   = UniDate.getDbDateStr(panelSearch.getValue('TO_DATE')).substring(0, 6) + lastDay;
				var startDay = UniDate.getDbDateStr(panelSearch.getValue('TO_DATE')).substring(0, 4) +  UniDate.getDbDateStr(getStDt[0].STDT).substring(4, 6);
				
				if(columnName1){
					var dept_code = columnName1.replace(/[^0-9]/g,'');  // 동적그리드 선택된 CODE
				}
				
				var param = {'DEPT_CODE' : dept_code, 'S_COMP_CODE' : UserInfo.compCode}
				
				agb260skrService.dept(param, function(provider, response) {
						if(!Ext.isEmpty(provider)){
							var params = {
								action:'select',
								'PGM_ID'	 : 'afb260skr',
								'START_DATE' : startDay,
								'FR_DATE' 	 : from_date,	   
								'TO_DATE' 	 : to_date,	   
								'ACCNT_CODE' : record.data['ACCNT'],
								'ACCNT_NAME' : record.data['ACCNT_NAME'],
								'DIV_CODE'   : panelSearch.getValue('DIV_CODE'),
								'DEPT_CODE' : dept_code,
								'DEPT_NAME' : provider[0].DEPT_NAME
							}
							var rec = {data : {prgID : 'agb110skr', 'text':''}};									
							parent.openTab(rec, '/accnt/agb110skr.do', params);
						}
					}
  			)};
	    },
    	viewConfig: {
	        getRowClass: function(record, rowIndex, rowParams, store){
	        	var cls = '';
	        	if(record.get('DIVI') == '2'){
					cls = 'x-change-celltext_red';	
				}
				return cls;
	        }
	    }           	        
    });
    
    var masterGrid2 = Unilite.createGrid('agb260skrGrid2', {
    	title : '제조경비',
    	layout : 'fit',
        store : directMasterStore2, 
        uniOpt:{	expandLastColumn: true,
        			useRowNumberer: true,
                    useMultipleSorting: true
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
        columns: columns2,
        listeners: {
            itemmouseenter:function(view, record, item, index, e, eOpts, column )   { 
                view.ownerGrid.setCellPointer(view, item);
            },
            onGridDblClick :function( grid, record, cellIndex, colName ) {
                
                if(grid.eventPosition.column.dataIndex != 'DIVI' &&
                    grid.eventPosition.column.dataIndex != 'ACCNT' &&
                    grid.eventPosition.column.dataIndex != 'ACCNT_NAME' &&
                    grid.eventPosition.column.dataIndex != 'AMT_TOT' &&
                    grid.eventPosition.column.dataIndex != '' 
                ){
                    columnName1=colName;
                    masterGrid2.gotoAfb260(record);
                }
            }
        }, 
        onItemcontextmenu:function( menu, grid, record, item, index, event  )   {   

            if(event.position.column.dataIndex != 'DIVI' &&
                event.position.column.dataIndex != 'ACCNT' &&
                event.position.column.dataIndex != 'ACCNT_NAME' &&
                event.position.column.dataIndex != 'AMT_TOT' &&
                event.position.column.dataIndex != '' 
            ){
                columnName1 = grid.eventPosition.column.dataIndex;
                return true;
            }
        },   
        uniRowContextMenu:{
            items: [{   
                    text: '보조부 이동',   
                    itemId  : 'linkAgb110skr',
                    handler: function(menuItem, event) {
                        var param = menuItem.up('menu');
                        masterGrid2.gotoAfb260(param.record);
                    }
                }
            ]
        },
        gotoAfb260:function(record) {
            if(record)  {
                var temp = UniDate.getDbDateStr(panelSearch.getValue('TO_DATE')).substring(0, 6) + '01';
                var lastDay = (new Date(temp.substring(0,4), temp.substring(4,6), 0)).getDate();   // 해당 날짜의 마지막날자 구하기 new Date('년도' , '월' , 0 ).getDate()
                var from_date = UniDate.getDbDateStr(panelSearch.getValue('FR_DATE')).substring(0, 6) + '01';
                var to_date   = UniDate.getDbDateStr(panelSearch.getValue('TO_DATE')).substring(0, 6) + lastDay;
                var startDay = UniDate.getDbDateStr(panelSearch.getValue('TO_DATE')).substring(0, 4) +  UniDate.getDbDateStr(getStDt[0].STDT).substring(4, 6);
                
                if(columnName1){
                    var dept_code = columnName1.replace(/[^0-9]/g,'');  // 동적그리드 선택된 CODE
                }
                
                var param = {'DEPT_CODE' : dept_code, 'S_COMP_CODE' : UserInfo.compCode}
                
                agb260skrService.dept(param, function(provider, response) {
                        if(!Ext.isEmpty(provider)){
                            var params = {
                                action:'select',
                                'PGM_ID'     : 'afb260skr',
                                'START_DATE' : startDay,
                                'FR_DATE'    : from_date,      
                                'TO_DATE'    : to_date,    
                                'ACCNT_CODE' : record.data['ACCNT'],
                                'ACCNT_NAME' : record.data['ACCNT_NAME'],
                                'DIV_CODE'   : panelSearch.getValue('DIV_CODE'),
                                'DEPT_CODE' : dept_code,
                                'DEPT_NAME' : provider[0].DEPT_NAME
                            }
                            var rec = {data : {prgID : 'agb110skr', 'text':''}};                                    
                            parent.openTab(rec, '/accnt/agb110skr.do', params);
                        }
                    }
            )};
        },
    	viewConfig: {
	        getRowClass: function(record, rowIndex, rowParams, store){
	        	var cls = '';
	        	if(record.get('DIVI') == '2'){
					cls = 'x-change-celltext_red';	
				}
				return cls;
	        }
	    }              	        
    });
    
    var masterGrid3 = Unilite.createGrid('agb260skrGrid3', {
    	title : '용역경비',
    	layout : 'fit',
        store : directMasterStore3, 
        uniOpt:{	expandLastColumn: true,
        			useRowNumberer: true,
                    useMultipleSorting: true
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
        columns: columns3,
        listeners: {
            itemmouseenter:function(view, record, item, index, e, eOpts, column )   { 
                view.ownerGrid.setCellPointer(view, item);
            },
            onGridDblClick :function( grid, record, cellIndex, colName ) {
                
                if(grid.eventPosition.column.dataIndex != 'DIVI' &&
                    grid.eventPosition.column.dataIndex != 'ACCNT' &&
                    grid.eventPosition.column.dataIndex != 'ACCNT_NAME' &&
                    grid.eventPosition.column.dataIndex != 'AMT_TOT' &&
                    grid.eventPosition.column.dataIndex != '' 
                ){
                    columnName1=colName;
                    masterGrid3.gotoAfb260(record);
                }
            }
        }, 
        onItemcontextmenu:function( menu, grid, record, item, index, event  )   {   

            if(event.position.column.dataIndex != 'DIVI' &&
                event.position.column.dataIndex != 'ACCNT' &&
                event.position.column.dataIndex != 'ACCNT_NAME' &&
                event.position.column.dataIndex != 'AMT_TOT' &&
                event.position.column.dataIndex != '' 
            ){
                columnName1 = grid.eventPosition.column.dataIndex;
                return true;
            }
        }, 
        uniRowContextMenu:{
            items: [{   
                    text: '보조부 이동',   
                    itemId  : 'linkAgb110skr',
                    handler: function(menuItem, event) {
                        var param = menuItem.up('menu');
                        masterGrid3.gotoAfb260(param.record);
                    }
                }
            ]
        },
        gotoAfb260:function(record) {
            if(record)  {
                var temp = UniDate.getDbDateStr(panelSearch.getValue('TO_DATE')).substring(0, 6) + '01';
                var lastDay = (new Date(temp.substring(0,4), temp.substring(4,6), 0)).getDate();   // 해당 날짜의 마지막날자 구하기 new Date('년도' , '월' , 0 ).getDate()
                var from_date = UniDate.getDbDateStr(panelSearch.getValue('FR_DATE')).substring(0, 6) + '01';
                var to_date   = UniDate.getDbDateStr(panelSearch.getValue('TO_DATE')).substring(0, 6) + lastDay;
                var startDay = UniDate.getDbDateStr(panelSearch.getValue('TO_DATE')).substring(0, 4) +  UniDate.getDbDateStr(getStDt[0].STDT).substring(4, 6);
                
                if(columnName1){
                    var dept_code = columnName1.replace(/[^0-9]/g,'');  // 동적그리드 선택된 CODE
                }
                
                var param = {'DEPT_CODE' : dept_code, 'S_COMP_CODE' : UserInfo.compCode}
                
                agb260skrService.dept(param, function(provider, response) {
                        if(!Ext.isEmpty(provider)){
                            var params = {
                                action:'select',
                                'PGM_ID'     : 'afb260skr',
                                'START_DATE' : startDay,
                                'FR_DATE'    : from_date,      
                                'TO_DATE'    : to_date,    
                                'ACCNT_CODE' : record.data['ACCNT'],
                                'ACCNT_NAME' : record.data['ACCNT_NAME'],
                                'DIV_CODE'   : panelSearch.getValue('DIV_CODE'),
                                'DEPT_CODE' : dept_code,
                                'DEPT_NAME' : provider[0].DEPT_NAME
                            }
                            var rec = {data : {prgID : 'agb110skr', 'text':''}};                                    
                            parent.openTab(rec, '/accnt/agb110skr.do', params);
                        }
                    }
            )};
        },
    	viewConfig: {
	        getRowClass: function(record, rowIndex, rowParams, store){
	        	var cls = '';
	        	if(record.get('DIVI') == '2'){
					cls = 'x-change-celltext_red';	
				}
				return cls;
	        }
	    }             	        
    });
    
    var masterGrid4 = Unilite.createGrid('agb260skrGrid4', {
    	title : '용역경비2',
    	layout : 'fit',
        store : directMasterStore4, 
        uniOpt:{	expandLastColumn: true,
        			useRowNumberer: true,
                    useMultipleSorting: true
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
        columns: columns4,
        listeners: {
            itemmouseenter:function(view, record, item, index, e, eOpts, column )   { 
                view.ownerGrid.setCellPointer(view, item);
            },
            onGridDblClick :function( grid, record, cellIndex, colName ) {
                
                if(grid.eventPosition.column.dataIndex != 'DIVI' &&
                    grid.eventPosition.column.dataIndex != 'ACCNT' &&
                    grid.eventPosition.column.dataIndex != 'ACCNT_NAME' &&
                    grid.eventPosition.column.dataIndex != 'AMT_TOT' &&
                    grid.eventPosition.column.dataIndex != '' 
                ){
                    columnName1=colName;
                    masterGrid4.gotoAfb260(record);
                }
            }
        }, 
        onItemcontextmenu:function( menu, grid, record, item, index, event  )   {   

            if(event.position.column.dataIndex != 'DIVI' &&
                event.position.column.dataIndex != 'ACCNT' &&
                event.position.column.dataIndex != 'ACCNT_NAME' &&
                event.position.column.dataIndex != 'AMT_TOT' &&
                event.position.column.dataIndex != '' 
            ){
                columnName1 = grid.eventPosition.column.dataIndex;
                return true;
            }
        },   
        uniRowContextMenu:{
            items: [{   
                    text: '보조부 이동',   
                    itemId  : 'linkAgb110skr',
                    handler: function(menuItem, event) {
                        var param = menuItem.up('menu');
                        masterGrid4.gotoAfb260(param.record);
                    }
                }
            ]
        },
        gotoAfb260:function(record) {
            if(record)  {
                var temp = UniDate.getDbDateStr(panelSearch.getValue('TO_DATE')).substring(0, 6) + '01';
                var lastDay = (new Date(temp.substring(0,4), temp.substring(4,6), 0)).getDate();   // 해당 날짜의 마지막날자 구하기 new Date('년도' , '월' , 0 ).getDate()
                var from_date = UniDate.getDbDateStr(panelSearch.getValue('FR_DATE')).substring(0, 6) + '01';
                var to_date   = UniDate.getDbDateStr(panelSearch.getValue('TO_DATE')).substring(0, 6) + lastDay;
                var startDay = UniDate.getDbDateStr(panelSearch.getValue('TO_DATE')).substring(0, 4) +  UniDate.getDbDateStr(getStDt[0].STDT).substring(4, 6);
                
                if(columnName1){
                    var dept_code = columnName1.replace(/[^0-9]/g,'');  // 동적그리드 선택된 CODE
                }
                
                var param = {'DEPT_CODE' : dept_code, 'S_COMP_CODE' : UserInfo.compCode}
                
                agb260skrService.dept(param, function(provider, response) {
                        if(!Ext.isEmpty(provider)){
                            var params = {
                                action:'select',
                                'PGM_ID'     : 'afb260skr',
                                'START_DATE' : startDay,
                                'FR_DATE'    : from_date,      
                                'TO_DATE'    : to_date,    
                                'ACCNT_CODE' : record.data['ACCNT'],
                                'ACCNT_NAME' : record.data['ACCNT_NAME'],
                                'DIV_CODE'   : panelSearch.getValue('DIV_CODE'),
                                'DEPT_CODE' : dept_code,
                                'DEPT_NAME' : provider[0].DEPT_NAME
                            }
                            var rec = {data : {prgID : 'agb110skr', 'text':''}};                                    
                            parent.openTab(rec, '/accnt/agb110skr.do', params);
                        }
                    }
            )};
        },
    	viewConfig: {
	        getRowClass: function(record, rowIndex, rowParams, store){
	        	var cls = '';
	        	if(record.get('DIVI') == '2'){
					cls = 'x-change-celltext_red';	
				}
				return cls;
	        }
	    }              	        
    });
    
    var tab = Unilite.createTabPanel('tabPanel',{
    	region:'center',
	    items: [
	         masterGrid,
	         masterGrid2,
	         masterGrid3,
	         masterGrid4
	    ],
	    listeners:  {
	    	tabchange:  function ( grouptabPanel , newCard , oldCard , eOpts ) {
	    		UniAppManager.app.onQueryButtonDown();
	    	}
	    	
	    	/*
	     	beforetabchange:  function ( tabPanel, newCard, oldCard, eOpts )  {
	     		var newTabId = newCard.getId();
				console.log("newCard:  " + newCard.getId());
				console.log("oldCard:  " + oldCard.getId());
				switch(newTabId)	{
					case 'agb260skrGrid1':
						var param= Ext.getCmp('searchForm').getValues();
						var startField = panelSearch.getField('FR_DATE');
						var startDateValue = startField.getStartDate();
						var endField = panelSearch.getField('TO_DATE');
						var endDateValue = endField.getEndDate();
						param.FR_DATE = startDateValue
						param.TO_DATE = endDateValue
						param.QUERY_TYPE = '1'
						agb260skrService.getDeptCodeColumn(param, function(provider, response) {
							var records = response.result;
							//그리드 컬럼명 조건에 맞게 재 조회하여 입력
							var newColumns = createGridColumn(records);
							masterGrid.setConfig('columns',newColumns);
							
//							var param= Ext.getCmp('searchForm').getValues();
//							var startField = panelSearch.getField('FR_DATE');
//							var startDateValue = startField.getStartDate();
//							var endField = panelSearch.getField('TO_DATE');
//							var endDateValue = endField.getEndDate();
//							var deptList = [];
//							for(i=0; i < records.length; i++) {
//								deptList[i] = records[i].DEPT_CODE;
//							}
//							param.QUERY_TYPE = '4'
//							param.FR_DATE = startDateValue
//							param.TO_DATE = endDateValue
//							param.deptInfoList = deptList;
//							agb260skrService.selectList(param);
						});
						break;
					
					case 'agb260skrGrid2':
						var param= Ext.getCmp('searchForm').getValues();
						var startField = panelSearch.getField('FR_DATE');
						var startDateValue = startField.getStartDate();
						var endField = panelSearch.getField('TO_DATE');
						var endDateValue = endField.getEndDate();
						param.FR_DATE = startDateValue
						param.TO_DATE = endDateValue
						param.QUERY_TYPE = '2'
						agb260skrService.getDeptCodeColumn(param, function(provider, response) {
							var records = response.result;
							//그리드 컬럼명 조건에 맞게 재 조회하여 입력
							var newColumns = createGridColumn2(records);
							masterGrid2.setConfig('columns',newColumns);
//							directMasterStore2.loadStoreRecords();	
						});
						break;
						
					case 'agb260skrGrid3':
						var param= Ext.getCmp('searchForm').getValues();
						var startField = panelSearch.getField('FR_DATE');
						var startDateValue = startField.getStartDate();
						var endField = panelSearch.getField('TO_DATE');
						var endDateValue = endField.getEndDate();
						param.FR_DATE = startDateValue
						param.TO_DATE = endDateValue
						param.QUERY_TYPE = '3'
						agb260skrService.getDeptCodeColumn(param, function(provider, response) {
							var records = response.result;
							//그리드 컬럼명 조건에 맞게 재 조회하여 입력
							var newColumns = createGridColumn3(records);
							masterGrid3.setConfig('columns',newColumns);
//							directMasterStore3.loadStoreRecords();	
						});
						break;
						
					case 'agb260skrGrid4':
						var param= Ext.getCmp('searchForm').getValues();
						var startField = panelSearch.getField('FR_DATE');
						var startDateValue = startField.getStartDate();
						var endField = panelSearch.getField('TO_DATE');
						var endDateValue = endField.getEndDate();
						param.FR_DATE = startDateValue
						param.TO_DATE = endDateValue
						param.QUERY_TYPE = '4'
						agb260skrService.getDeptCodeColumn(param, function(provider, response) {
							var records = response.result;
							//그리드 컬럼명 조건에 맞게 재 조회하여 입력
							var newColumns = createGridColumn4(records);
							masterGrid4.setConfig('columns',newColumns);
//							directMasterStore4.loadStoreRecords();	
						});	
						break;
						
					default:
						break;
				}
	     	}
	    */}
    });
    
    Unilite.Main( {
	 	border: false,
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
					tab, panelResult
				]
			},
			panelSearch  	
		],
		id : 'agb260skrApp',
		fnInitBinding : function() {
			var activeSForm;
			if(!UserInfo.appOption.collapseLeftSearch) {
				activeSForm = panelSearch;
			} else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('FR_DATE');
			panelSearch.setValue('ACCNT_DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('FR_DATE',UniDate.get('startOfMonth'));
			panelSearch.setValue('TO_DATE',UniDate.get('today'));
			panelResult.setValue('FR_DATE',UniDate.get('startOfMonth'));
			panelResult.setValue('TO_DATE',UniDate.get('today'));
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
		},
		onQueryButtonDown : function()	{
			if(panelSearch.setAllFieldsReadOnly(true) == false){
				return false;
			}
			if(panelResult.setAllFieldsReadOnly(true) == false){
				return false;
			}
			var activeTabId = tab.getActiveTab().getId();			
			if(activeTabId == 'agb260skrGrid1') {
				var param= Ext.getCmp('searchForm').getValues();
				var startField = panelSearch.getField('FR_DATE');
                var startDateValue = startField.getStartDate();
                var endField = panelSearch.getField('TO_DATE');
                var endDateValue = endField.getEndDate();
                param.FR_DATE = startDateValue
                param.TO_DATE = endDateValue
				param.QUERY_TYPE = '1'
				agb260skrService.getDeptCodeColumn(param, function(provider, response) {
					var records = response.result;
					//그리드 컬럼명 조건에 맞게 재 조회하여 입력
					var newColumns = createGridColumn(records);
					masterGrid.setConfig('columns',newColumns);
					directMasterStore.loadStoreRecords(records);	
				});
			} else if (activeTabId == 'agb260skrGrid2') {
				var param= Ext.getCmp('searchForm').getValues();
				var startField = panelSearch.getField('FR_DATE');
                var startDateValue = startField.getStartDate();
                var endField = panelSearch.getField('TO_DATE');
                var endDateValue = endField.getEndDate();
                param.FR_DATE = startDateValue
                param.TO_DATE = endDateValue
				param.QUERY_TYPE = '2'
				agb260skrService.getDeptCodeColumn(param, function(provider, response) {
					var records = response.result;
					//그리드 컬럼명 조건에 맞게 재 조회하여 입력
					var newColumns = createGridColumn2(records);
					masterGrid2.setConfig('columns',newColumns);
					directMasterStore2.loadStoreRecords(records);	
				});
			} else if (activeTabId == 'agb260skrGrid3') {
				var param= Ext.getCmp('searchForm').getValues();
				var startField = panelSearch.getField('FR_DATE');
                var startDateValue = startField.getStartDate();
                var endField = panelSearch.getField('TO_DATE');
                var endDateValue = endField.getEndDate();
                param.FR_DATE = startDateValue
                param.TO_DATE = endDateValue
				param.QUERY_TYPE = '3'
				agb260skrService.getDeptCodeColumn(param, function(provider, response) {
					var records = response.result;
					//그리드 컬럼명 조건에 맞게 재 조회하여 입력
					var newColumns = createGridColumn3(records);
					masterGrid3.setConfig('columns',newColumns);
					directMasterStore3.loadStoreRecords(records);	
				});
			} else if (activeTabId == 'agb260skrGrid4') {
				var param= Ext.getCmp('searchForm').getValues();
				var startField = panelSearch.getField('FR_DATE');
                var startDateValue = startField.getStartDate();
                var endField = panelSearch.getField('TO_DATE');
                var endDateValue = endField.getEndDate();
                param.FR_DATE = startDateValue
                param.TO_DATE = endDateValue
				param.QUERY_TYPE = '4'
				agb260skrService.getDeptCodeColumn(param, function(provider, response) {
					var records = response.result;
					//그리드 컬럼명 조건에 맞게 재 조회하여 입력
					var newColumns = createGridColumn4(records);
					masterGrid4.setConfig('columns',newColumns);
					directMasterStore4.loadStoreRecords(records);	
				});
			}
			UniAppManager.setToolbarButtons('reset',true);
		},
		onResetButtonDown: function() {
			return panelSearch.setAllFieldsReadOnly(false);
			return panelResult.setAllFieldsReadOnly(false);
			masterGrid.reset();
			masterGrid2.reset();
			masterGrid3.reset();
			masterGrid4.reset();
			directMasterStore.removeAll();
			this.fnInitBinding();
		}
	});
		
	// 모델필드 생성
	function createModelField(deptList) {
		var fields = [  	  
	    	{name: 'DIVI'			, text: '구분' 			,type: 'string'},
		    {name: 'ACCNT'			, text: '계정코드'		,type: 'string'},
		    {name: 'ACCNT_NAME'		, text: '계정명' 		,type: 'string'},
		    // 부서필드
		    {name: 'AMT_TOT'		, text: '합계' 		,type: 'uniPrice'}
		] ;
					
		Ext.each(deptList, function(item, index) {
			fields.push({name: item.DEPT_CODE, text:item.DEPT_NAME, type:'uniPrice'})
		});
		console.log(fields);
		return fields;
	}
	
    // 그리드 컬럼 생성1
	function createGridColumn(deptList) {
		var columns = [        
			{dataIndex: 'DIVI'			,	text: '구분', width: 70, hidden:true}, 				
			{dataIndex: 'ACCNT'			,	text: '계정코드', width: 86, style: 'text-align: center',
        		summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '소계', '합계');
            	}
            }, 				
			{dataIndex: 'ACCNT_NAME'	,	text: '계정명', width: 200, style: 'text-align: center'}		
		];
		// 쿼리읽어서 컬럼 셋팅
		Ext.each(deptList, function(item, index) {
			var deptCode = item.DEPT_CODE;
			columns.push(Ext.applyIf({dataIndex: deptCode,	text: item.DEPT_NAME,	width: 150, style: 'text-align: center'}, {align: 'right' , xtype:'uniNnumberColumn', format: UniFormat.Price, summaryType: 'sum'  }));	
		});
		columns.push(Ext.applyIf({dataIndex: 'AMT_TOT',	text: '합계',		width: 150, style: 'text-align: center'}, {align: 'right' , xtype:'uniNnumberColumn', format: UniFormat.Price, summaryType: 'sum'  })); 		
		return columns;
	}
    // 그리드 컬럼 생성2
    function createGridColumn2(deptList) {
        var columns2 = [        
            {dataIndex: 'DIVI'          ,   text: '구분', width: 70, hidden:true},                
            {dataIndex: 'ACCNT'         ,   text: '계정코드', width: 86, style: 'text-align: center',
                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                   return Unilite.renderSummaryRow(summaryData, metaData, '소계', '합계');
                }
            },              
            {dataIndex: 'ACCNT_NAME'    ,   text: '계정명', width: 200, style: 'text-align: center'}       
        ];
        // 쿼리읽어서 컬럼 셋팅
        Ext.each(deptList, function(item, index) {
            var deptCode = item.DEPT_CODE;
            columns2.push(Ext.applyIf({dataIndex: deptCode, text: item.DEPT_NAME,   width: 150, style: 'text-align: center'}, {align: 'right' , xtype:'uniNnumberColumn', format: UniFormat.Price, summaryType: 'sum'  })); 
        });
        columns2.push(Ext.applyIf({dataIndex: 'AMT_TOT', text: '합계',     width: 150, style: 'text-align: center'}, {align: 'right' , xtype:'uniNnumberColumn', format: UniFormat.Price, summaryType: 'sum'  }));         
        return columns2;
    }
	
    
	// 그리드 컬럼 생성3
	function createGridColumn3(deptList) {
		var columns3 = [        
			{dataIndex: 'DIVI'			,	text: '구분', width: 70, hidden:true}, 				
			{dataIndex: 'ACCNT'			,	text: '계정코드', width: 86, style: 'text-align: center',
        		summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '소계', '합계');
            	}
            }, 				
			{dataIndex: 'ACCNT_NAME'	,	text: '계정명', width: 200, style: 'text-align: center'}		
		];
		// 쿼리읽어서 컬럼 셋팅
		Ext.each(deptList, function(item, index) {
			var deptCode = item.DEPT_CODE;
			columns3.push(Ext.applyIf({dataIndex: deptCode,	text: item.DEPT_NAME,	width: 150, style: 'text-align: center'}, {align: 'right' , xtype:'uniNnumberColumn', format: UniFormat.Price, summaryType: 'sum'  }));	
		});
		columns3.push(Ext.applyIf({dataIndex: 'AMT_TOT',	text: '합계',		width: 150, style: 'text-align: center'}, {align: 'right' , xtype:'uniNnumberColumn', format: UniFormat.Price, summaryType: 'sum'  })); 		
		return columns3;
	}
    
    // 그리드 컬럼 생성
	function createGridColumn4(deptList) {
		var columns4 = [        
			{dataIndex: 'DIVI'			,	text: '구분', width: 70, hidden:true}, 				
			{dataIndex: 'ACCNT'			,	text: '계정코드', width: 86, style: 'text-align: center',
        		summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '소계', '합계');
            	}
            }, 				
			{dataIndex: 'ACCNT_NAME'	,	text: '계정명', width: 200, style: 'text-align: center'}		
		];
		// 쿼리읽어서 컬럼 셋팅
		Ext.each(deptList, function(item, index) {
			var deptCode = item.DEPT_CODE;
			columns4.push(Ext.applyIf({dataIndex: deptCode,	text: item.DEPT_NAME,	width: 150, style: 'text-align: center'}, {align: 'right' , xtype:'uniNnumberColumn', format: UniFormat.Price, summaryType: 'sum'  }));	
		});
		columns4.push(Ext.applyIf({dataIndex: 'AMT_TOT',	text: '합계',		width: 150, style: 'text-align: center'}, {align: 'right' , xtype:'uniNnumberColumn', format: UniFormat.Price, summaryType: 'sum'  })); 		
		return columns4;
	}
};


</script>
