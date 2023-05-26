<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="aiss500skrv"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->  
	<t:ExtComboStore comboType="AU" comboCode="A042" /> <!--자산구분-->
	<t:ExtComboStore comboType="AU" comboCode="A141" /> <!--변동여부-->
	<t:ExtComboStore comboType="AU" comboCode="B013" /> <!--화폐단위-->
	<t:ExtComboStore comboType="AU" comboCode="A036" /> <!--상각방법-->
	<t:ExtComboStore comboType="AU" comboCode="A020" /> <!--분할여부(예/아니오)-->
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >
var getChargeCode = '${getChargeCode}';
function appMain() {
	
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Aiss500skrModel', {
	    fields: [
			{name: 'ALTER_DIVI'		 			,text:'변동구분' 			,type: 'string', comboType:'AU', comboCode:'A141'},
	    	{name: 'ALTER_DATE'	 				,text:'변동일' 			,type: 'uniDate'},
	    	{name: 'ASST'			 			,text:'자산코드' 			,type: 'string'},
	   		{name: 'ASST_NAME'		 			,text:'자산명' 			,type: 'string'},
	   		{name: 'ASST_DIVI'			 		,text:'자산구분' 			,type: 'string' , comboType:'AU', comboCode:'A042'},
	   		{name: 'ACCNT_NAME'		 			,text:'계정과목' 			,type: 'string'},
	   		{name: 'ACQ_DATE'		 			,text:'취득일' 			,type: 'uniDate'},
	   		{name: 'ACQ_AMT_I'		 			,text:'취득가액' 			,type: 'uniPrice'},
	   		{name: 'ALTER_Q'					,text:'변동수량' 			,type: 'uniQty'},
	   		{name: 'ALTER_AMT_I'				,text:'변동금액' 			,type: 'uniPrice'},
	   		{name: 'ALTER_REASON'				,text:'변동사유' 			,type: 'string'},
	   		{name: 'MONEY_UNIT'					,text:'화폐단위' 			,type: 'string'},
	   		{name: 'EXCHG_RATE_O'				,text:'환율' 				,type: 'uniER'},
	   		{name: 'FOR_ALTER_AMT_I'			,text:'외화변동금액' 		,type: 'uniER'},
	   		{name: 'BF_DEP_CTL'					,text:'상각방법' 			,type: 'string' , comboType:'AU', comboCode:'A036'},
	   		{name: 'BF_DRB_YEAR'				,text:'내용년수' 			,type: 'string' , comboType:'BOR120'},
	   		{name: 'BF_DIV_CODE'				,text:'사업장' 			,type: 'string'},
	   		{name: 'BF_DEPT_NAME'				,text:'부서' 				,type: 'string'},
	   		{name: 'AF_DEP_CTL'					,text:'상각방법' 			,type: 'string' , comboType:'AU', comboCode:'A036'},
	   		{name: 'AF_DRB_YEAR'				,text:'내용년수' 			,type: 'string' , comboType:'BOR120'},
	   		{name: 'AF_DIV_CODE'				,text:'사업장' 			,type: 'string'},
	   		{name: 'AF_DEPT_NAME'				,text:'부서' 				,type: 'string'},
	   		{name: 'PAT_ASST'					,text:'분할자산코드' 		,type: 'string'},
	   		{name: 'PAT_YN'						,text:'분할여부' 			,type: 'string' , comboType:'AU', comboCode:'A020'},
	   		{name: 'EX_DATE'					,text:'결의일자' 			,type: 'uniDate'},
	   		{name: 'EX_NUM'						,text:'결의번호' 			,type: 'string'}
		]
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('aiss500skrvMasterStore1',{
		model: 'Aiss500skrModel',
		uniOpt : {
        	isMaster: true,			// 상위 버튼 연결 
        	editable: false,		// 수정 모드 사용 
        	deletable:false,		// 삭제 가능 여부 
            useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
			type: 'direct',
            api: {			
				read: 'aiss500skrvService.selectList'                	
            }
        },
        loadStoreRecords : function()	{
			var param= Ext.getCmp('searchForm').getValues();			
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
        collapsed: UserInfo.appOption.collapseLeftSearch,
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
		    items : [{ 
    			fieldLabel: '변동일',
		        xtype: 'uniDateRangefield',
		        startFieldName: 'FR_DATE',
		        endFieldName: 'TO_DATE',
		        //startDate: UniDate.get('startOfMonth'),
		        //endDate: UniDate.get('today'),
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
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				multiSelect: true, 
		        typeAhead: false,
				comboType: 'BOR120',
				width: 325,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},{
				fieldLabel: '자산구분'	,
				name:'ASST_DIVI', 
				xtype: 'uniCombobox', 
				comboType:'AU',
				comboCode:'A042',
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {	
						panelResult.setValue('ASST_DIVI', newValue);
					}
				} 
			},{
    			fieldLabel: '변동구분'	,
    			name:'ALTER_DIVI', 
    			xtype: 'uniCombobox', 
    			comboType:'AU',
    			comboCode:'A141',
    			listeners: {
					change: function(combo, newValue, oldValue, eOpts) {	
						panelResult.setValue('ALTER_DIVI', newValue);
					}
				} 
    		},
			Unilite.popup('ACCNT', {
				fieldLabel: '계정과목', 
				valueFieldName: 'FR_ACCNT_CODE', 
				textFieldName: 'FR_ACCNT_NAME',
				autoPopup: true,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('FR_ACCNT_CODE', panelSearch.getValue('FR_ACCNT_CODE'));
							panelResult.setValue('FR_ACCNT_NAME', panelSearch.getValue('FR_ACCNT_NAME'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('FR_ACCNT_CODE', '');
						panelResult.setValue('FR_ACCNT_NAME', '');
					},
					applyextparam: function(popup){
						popup.setExtParam({'ADD_QUERY': "SPEC_DIVI IN ('K', 'K2')"});	//WHERE절 추카 쿼리
						popup.setExtParam({'CHARGE_CODE': getChargeCode});				//bParam(3)			
					}
				}
			}),
			Unilite.popup('ACCNT', {
				fieldLabel: '~', 
				valueFieldName: 'TO_ACCNT_CODE', 
				textFieldName: 'TO_ACCNT_NAME',
				autoPopup: true,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('TO_ACCNT_CODE', panelSearch.getValue('TO_ACCNT_CODE'));
							panelResult.setValue('TO_ACCNT_NAME', panelSearch.getValue('TO_ACCNT_NAME'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('TO_ACCNT_CODE', '');
						panelResult.setValue('TO_ACCNT_NAME', '');
					},
					applyextparam: function(popup){
						popup.setExtParam({'ADD_QUERY': "SPEC_DIVI IN ('K', 'K2')"});	//WHERE절 추카 쿼리
						popup.setExtParam({'CHARGE_CODE': getChargeCode});				//bParam(3)			
					}
				}
			}),
			Unilite.popup('IFRS_ASSET', {
				fieldLabel: '자산코드', 
				valueFieldName: 'FR_ASST_CODE', 
				textFieldName: 'FR_ASST_NAME', 
				autoPopup: true,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('FR_ASST_CODE', panelSearch.getValue('FR_ASST_CODE'));
							panelResult.setValue('FR_ASST_NAME', panelSearch.getValue('FR_ASST_NAME'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('FR_ASST_CODE', '');
						panelResult.setValue('FR_ASST_NAME', '');
					}
				}
			}),
			Unilite.popup('IFRS_ASSET',{ 
				fieldLabel: '~', 
				valueFieldName: 'TO_ASST_CODE', 
				textFieldName: 'TO_ASST_NAME', 
				autoPopup: true,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('TO_ASST_CODE', panelSearch.getValue('TO_ASST_CODE'));
							panelResult.setValue('TO_ASST_NAME', panelSearch.getValue('TO_ASST_NAME'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('TO_ASST_CODE', '');
						panelResult.setValue('TO_ASST_NAME', '');
					}
				}
			})]
    	},{
			title: '추가정보',
   			itemId: 'search_panel2',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items : [
			    Unilite.popup('AC_PROJECT', {
					fieldLabel: '사업코드', 
					valueFieldName: 'FR_PJT_CODE', 
					textFieldName: 'FR_PJT_NAME', 
					autoPopup: true
					/*listeners: {
						onSelected: {
							fn: function(records, type) {
								panelResult.setValue('FR_PJT_CODE', panelSearch.getValue('FR_PJT_CODE'));
								panelResult.setValue('FR_PJT_NAME', panelSearch.getValue('FR_PJT_NAME'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('FR_PJT_CODE', '');
							panelResult.setValue('FR_PJT_NAME', '');
						}
					}*/
				}),
				Unilite.popup('AC_PROJECT',{ 
					fieldLabel: '~', 
					valueFieldName: 'TO_PJT_CODE', 
					textFieldName: 'TO_PJT_NAME', 
					autoPopup: true
					/*listeners: {
						onSelected: {
							fn: function(records, type) {
								panelResult.setValue('TO_PJT_CODE', panelSearch.getValue('TO_PJT_CODE'));
								panelResult.setValue('TO_PJT_NAME', panelSearch.getValue('TO_PJT_NAME'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('TO_PJT_CODE', '');
							panelResult.setValue('TO_PJT_NAME', '');
						}
					}*/
				}),
				Unilite.popup('DEPT', {
					fieldLabel: '부서', 
					valueFieldName: 'FR_DEPT_CODE', 
					textFieldName: 'FR_DEPT_NAME', 
					autoPopup: true,
					listeners: {
						onSelected: {
							fn: function(records, type) {
								panelResult.setValue('FR_DEPT_CODE', panelSearch.getValue('FR_DEPT_CODE'));
								panelResult.setValue('FR_DEPT_NAME', panelSearch.getValue('FR_DEPT_NAME'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('FR_DEPT_CODE', '');
							panelResult.setValue('FR_DEPT_NAME', '');
						}
					}
				}),
				Unilite.popup('DEPT',{ 
					fieldLabel: '~', 
					valueFieldName: 'TO_DEPT_CODE', 
					textFieldName: 'TO_DEPT_NAME', 
					autoPopup: true
					/*listeners: {
						onSelected: {
							fn: function(records, type) {
								panelResult.setValue('TO_DEPT_CODE', panelSearch.getValue('TO_DEPT_CODE'));
								panelResult.setValue('TO_DEPT_NAME', panelSearch.getValue('TO_DEPT_NAME'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('TO_DEPT_CODE', '');
							panelResult.setValue('TO_DEPT_NAME', '');
						}
					}*/
				})]
		}]
	});    
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		layout : {type : 'uniTable', columns : 2},
		padding:'1 1 1 1',
		border:true,
		items: [{ 
			fieldLabel: '변동일',
	        xtype: 'uniDateRangefield',
	        startFieldName: 'FR_DATE',
	        endFieldName: 'TO_DATE',
	        //startDate: UniDate.get('startOfMonth'),
	        //endDate: UniDate.get('today'),
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
			name: 'DIV_CODE',
			xtype: 'uniCombobox',
			multiSelect: true, 
	        typeAhead: false,
			comboType: 'BOR120',
			width: 325,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},{
			fieldLabel: '자산구분'	,
			name:'ASST_DIVI', 
			xtype: 'uniCombobox', 
			comboType:'AU',
			comboCode:'A042',
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {	
					panelSearch.setValue('ASST_DIVI', newValue);
				}
			} 
		},{
			fieldLabel: '변동구분'	,
			name:'ALTER_DIVI', 
			xtype: 'uniCombobox', 
			comboType:'AU',
			comboCode:'A141',
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {	
					panelSearch.setValue('ALTER_DIVI', newValue);
				}
			} 
		},
		Unilite.popup('ACCNT', {
			fieldLabel: '계정과목', 
			valueFieldName: 'FR_ACCNT_CODE', 
			textFieldName: 'FR_ACCNT_NAME',
			autoPopup: true,
			listeners: {
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('FR_ACCNT_CODE', panelResult.getValue('FR_ACCNT_CODE'));
						panelSearch.setValue('FR_ACCNT_NAME', panelResult.getValue('FR_ACCNT_NAME'));				 																							
					},
					scope: this
				},
				onClear: function(type)	{
					panelSearch.setValue('FR_ACCNT_CODE', '');
					panelSearch.setValue('FR_ACCNT_NAME', '');
				},
				applyextparam: function(popup){
					popup.setExtParam({'ADD_QUERY': "SPEC_DIVI IN ('K', 'K2')"});	//WHERE절 추카 쿼리
					popup.setExtParam({'CHARGE_CODE': getChargeCode});				//bParam(3)			
				}
			}
		}),
		Unilite.popup('ACCNT',{ 
			fieldLabel: '~', 
			valueFieldName: 'TO_ACCNT_CODE', 
			textFieldName: 'TO_ACCNT_NAME', 
			labelWidth:10,
			popupWidth: 710,
			autoPopup: true,
			listeners: {
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('TO_ACCNT_CODE', panelResult.getValue('TO_ACCNT_CODE'));
						panelSearch.setValue('TO_ACCNT_NAME', panelResult.getValue('TO_ACCNT_NAME'));				 																							
					},
					scope: this
				},
				onClear: function(type)	{
					panelSearch.setValue('TO_ACCNT_CODE', '');
					panelSearch.setValue('TO_ACCNT_NAME', '');
				},
				applyextparam: function(popup){
					popup.setExtParam({'ADD_QUERY': "SPEC_DIVI IN ('K', 'K2')"});	//WHERE절 추카 쿼리
					popup.setExtParam({'CHARGE_CODE': getChargeCode});				//bParam(3)			
				}
			}
		}),
		Unilite.popup('IFRS_ASSET', {
			fieldLabel: '자산코드', 
			valueFieldName: 'FR_ASST_CODE', 
			textFieldName: 'FR_ASST_NAME', 
			popupWidth: 710,
			autoPopup: true,
			listeners: {
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('FR_ASST_CODE', panelResult.getValue('FR_ASST_CODE'));
						panelSearch.setValue('FR_ASST_NAME', panelResult.getValue('FR_ASST_NAME'));				 																							
					},
					scope: this
				},
				onClear: function(type)	{
					panelSearch.setValue('FR_ASST_CODE', '');
					panelSearch.setValue('FR_ASST_NAME', '');
				}
			}
		}),
		Unilite.popup('IFRS_ASSET',{ 
			fieldLabel: '~', 
			valueFieldName: 'TO_ASST_CODE', 
			textFieldName: 'TO_ASST_NAME', 
			labelWidth:10,
			popupWidth: 710,
			autoPopup: true,
			listeners: {
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('TO_ASST_CODE', panelResult.getValue('TO_ASST_CODE'));
						panelSearch.setValue('TO_ASST_NAME', panelResult.getValue('TO_ASST_NAME'));				 																							
					},
					scope: this
				},
				onClear: function(type)	{
					panelSearch.setValue('TO_ASST_CODE', '');
					panelSearch.setValue('TO_ASST_NAME', '');
				}
			}
		})]
	});	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('aiss500skrvGrid1', {
    	// for tab    	
//        layout : 'fit',
        region:'center',
    	store : directMasterStore, 
        excelTitle: '자산변동내역조회',
        uniOpt: {
			useMultipleSorting	: true,
    		useLiveSearch		: true,
    		onLoadSelectFirst	: true,
    		dblClickToEdit		: false,
    		useGroupSummary		: true,
			useContextMenu		: false,
			useRowNumberer		: true,
			expandLastColumn	: true,
			useRowContext		: false,
    		filter: {
				useFilter		: true,
				autoCreate		: true
			}
        },
    	features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
        columns:  [        
			{ dataIndex: 'ALTER_DIVI'			, 					width: 100},
			{ dataIndex: 'ALTER_DATE'	 		, 					width: 100},
			{ dataIndex: 'ASST'					, 					width: 100},
			{ dataIndex: 'ASST_NAME'			, 					width: 250},
			{ dataIndex: 'ASST_DIVI'			, 					width: 100},
			{ dataIndex: 'ACCNT_NAME'			, 					width: 100},
			{ dataIndex: 'ACQ_DATE'				, 					width: 100},
			{ dataIndex: 'ACQ_AMT_I'			, 					width: 100},
			{ dataIndex: 'ALTER_Q'				, 					width: 100},
			{ dataIndex: 'ALTER_AMT_I'			, 					width: 100},
			{ dataIndex: 'ALTER_REASON'			, 					width: 100},
			{ dataIndex: 'MONEY_UNIT'			, 					width: 100},
			{ dataIndex: 'EXCHG_RATE_O'			, 					width: 100},
			{ dataIndex: 'FOR_ALTER_AMT_I'		, 					width: 100},
			{text: '변경 전 정보',
				columns: [
					{ dataIndex: 'BF_DEP_CTL'			, 					width: 100},
					{ dataIndex: 'BF_DRB_YEAR'			, 					width: 100},
					{ dataIndex: 'BF_DIV_CODE'			, 					width: 100},
					{ dataIndex: 'BF_DEPT_NAME'			, 					width: 100}
				]
			},
			{text: '변경 후 정보',
				columns: [
					{ dataIndex: 'AF_DEP_CTL'			, 					width: 100},
					{ dataIndex: 'AF_DRB_YEAR'			, 					width: 100},
					{ dataIndex: 'AF_DIV_CODE'			, 					width: 100},
					{ dataIndex: 'AF_DEPT_NAME'			, 					width: 100}
				]
			},
			{ dataIndex: 'PAT_ASST'				, 					width: 100},
			{ dataIndex: 'PAT_YN'				, 					width: 100},
			{ dataIndex: 'EX_DATE'				, 					width: 100},
			{ dataIndex: 'EX_NUM'				, 					width: 100}
        ],
        listeners: {
        	itemmouseenter:function(view, record, item, index, e, eOpts )	{          		
	        	view.ownerGrid.setCellPointer(view, item);
        	}
        },
        onItemcontextmenu:function( menu, grid, record, item, index, event  )	{          		
      		//menu.showAt(event.getXY());
        	var alterDivi = record.data['ALTER_DIVI'];
        	
        	if(alterDivi == '1' || alterDivi == '2' || alterDivi == '5' || alterDivi == '6' || alterDivi == '7' || alterDivi == '8'){
        		menu.down('#linkAiss500ukrv').show();  //	변동내역등록
	      		menu.down('#linkAiss510ukrv').hide();
	      		menu.down('#linkAiss520ukrv').hide();
        	}else if(alterDivi == '3'){
        		menu.down('#linkAiss500ukrv').hide();
	      		menu.down('#linkAiss510ukrv').show();  //	재평가
	      		menu.down('#linkAiss520ukrv').hide();	
        	}else if(alterDivi == '4'){
        		menu.down('#linkAiss500ukrv').hide();
	      		menu.down('#linkAiss510ukrv').hide();
	      		menu.down('#linkAiss520ukrv').show();  //	손상처리
        	} else {
        		menu.down('#linkAiss500ukrv').show();  //	변동내역등록
	      		menu.down('#linkAiss510ukrv').hide();
	      		menu.down('#linkAiss520ukrv').hide();
        	}
        	
        	
      		return true;
      	},
      	uniRowContextMenu:{
			items: [
	            {	text	: '자산변동내역등록',   
	            	itemId  : 'linkAiss500ukrv',
	            	handler	: function(menuItem, event) {
	            		var record = masterGrid.getSelectedRecord();
	            		var param = {
	            			'PGM_ID' 	 : 'aiss500skrv',
	            			'ALTER_DIVI' : record.data['ALTER_DIVI'],
	            			'ASST' 		 : record.data['ASST'],
	            			'ASST_NAME'  : record.data['ASST_NAME'],
	            			'ASST_DIVI'  : record.data['ASST_DIVI']
	            		}
	            		masterGrid.gotoAiss500ukrv(param);
	            	}
	        	},{	text	: '자산재평가등록',   
	            	itemId  : 'linkAiss510ukrv',
	            	handler	: function(menuItem, event) {
	            		var record = masterGrid.getSelectedRecord();
	            		var param = {
	            			'PGM_ID' 	 : 'aiss500skrv',
	            			'ALTER_DATE' : record.data['ALTER_DATE'],
	            			'ASST' 		 : record.data['ASST'],
	            			'ASST_NAME'  : record.data['ASST_NAME'],
	            			'ACCNT'  	 : record.data['ACCNT'],
	            			'ACCNT_NAME' : record.data['ACCNT_NAME']
	            		}
	            		masterGrid.gotoAiss510ukrv(param);
	            	}
	        	},{	text	: '자산손상등록',   
	            	itemId  : 'linkAiss520ukrv',
	            	handler	: function(menuItem, event) {
	            		var record = masterGrid.getSelectedRecord();
	            		var param = {
	            			'PGM_ID' 	 : 'aiss500skrv',
	            			'ALTER_DATE' : record.data['ALTER_DATE'],
	            			'ASST' 		 : record.data['ASST'],
	            			'ASST_NAME'  : record.data['ASST_NAME'],
	            			'ACCNT'  	 : record.data['ACCNT'],
	            			'ACCNT_NAME' : record.data['ACCNT_NAME']
	            		}
	            		masterGrid.gotoAiss520ukrv(param);
	            	}
	        	}
	        ]
	    },
	    gotoAiss500ukrv:function(record)	{
			if(record)	{
		    	var params = record;
			}
	  		var rec1 = {data : {prgID : 'aiss500ukrv', 'text':''}};							
			parent.openTab(rec1, '/accnt/aiss500ukrv.do', params);
    	},
    	gotoAiss510ukrv:function(record)	{
			if(record)	{
		    	var params = record;
			}
	  		var rec1 = {data : {prgID : 'aiss510ukrv', 'text':''}};							
			parent.openTab(rec1, '/accnt/aiss510ukrv.do', params);
    	},
    	gotoAiss520ukrv:function(record)	{
			if(record)	{
		    	var params = record;
			}
	  		var rec1 = {data : {prgID : 'aiss520ukrv', 'text':''}};							
			parent.openTab(rec1, '/accnt/aiss520ukrv.do', params);
    	}
    });   
	
    Unilite.Main( {
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
		id  : 'aiss500skrvApp',
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons('save',false);
			
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('FR_DATE');
		},
		onQueryButtonDown : function()	{
			if(!this.isValidSearchForm()){
				return false;
			}else{
				
				masterGrid.getStore().loadStoreRecords();
			}
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.reset();
			this.fnInitBinding();
		}
	});
};


</script>
