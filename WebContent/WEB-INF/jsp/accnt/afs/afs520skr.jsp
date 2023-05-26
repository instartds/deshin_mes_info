<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="afs520skr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B004" /> <!-- 화폐유형-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

var getStDt = ${getStDt};
var gsChargeCode  = Ext.isEmpty(${getChargeCode}) ? ['']: ${getChargeCode};   //ChargeCode 관련 전역변수

function appMain() {     
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Afs520skrModel', {
	    fields: [  	  
	    	{name: 'BANK_CODE'				, text: '은행코드' 	,type: 'string'},
		    {name: 'BANK_NAME'				, text: '은행명'		,type: 'string'},
		    {name: 'SAVE_CODE'				, text: '통장코드' 	,type: 'string'},
		    {name: 'SAVE_NAME'				, text: '통장명' 		,type: 'string'},
		    {name: 'BANK_ACCOUNT'			, text: '계좌번호' 	,type: 'string'},
		    {name: 'BANK_ACCOUNT_EXPOS'		, text: '계좌번호' 	,type: 'string', defaultValue:'***************'},
		    {name: 'MONEY_UNIT'				, text: '화폐' 		,type: 'string'},
		    {name: 'JAN_AMT_I'				, text: '잔액' 		,type: 'uniPrice'},
		    {name: 'JAN_FOR_AMT_I'			, text: '외화잔액' 	,type: 'uniFC'}
		]          	
	});
	  
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('afs520skrMasterStore1',{
		model: 'Afs520skrModel',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
            editable: false,			// 수정 모드 사용 
            deletable:false,			// 삭제 가능 여부 
	        useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
           type: 'direct',
            api: {			
                read: 'afs520skrService.selectList'                	
            }
        },
        loadStoreRecords: function() {
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
		 		fieldLabel: '일자',
		 		xtype: 'uniDatefield',
		 		name: 'AC_DATE',
		 		value: UniDate.get('today'),
		 		allowBlank:false,
		 		listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('AC_DATE', newValue);
						UniAppManager.app.fnSetStDate(newValue);
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
				listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('ACCNT_DIV_CODE', newValue);
						}
					}
			},
				Unilite.popup('ACCNT',{ 
				    fieldLabel: '계정과목', 
				    valueFieldName: 'ACCNT_CODE',
					textFieldName: 'ACCNT_NAME',
		    		autoPopup:true,
					listeners: {
						onSelected: {
							fn: function(records, type) {
								panelResult.setValue('ACCNT_CODE', panelSearch.getValue('ACCNT_CODE'));
								panelResult.setValue('ACCNT_NAME', panelSearch.getValue('ACCNT_NAME'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('ACCNT_CODE', '');
							panelResult.setValue('ACCNT_NAME', '');
						},
                        applyExtParam:{
                            scope:this,
                            fn:function(popup){
                                var param = {
                                    'ADD_QUERY' : "SUBSTRING(SPEC_DIVI,1,1) IN ('B','C')",
                                    'CHARGE_CODE': (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE
                                }
                                popup.setExtParam(param);
                            }
                        }
					}
			}),
				Unilite.popup('BANK_BOOK',{ 
				    fieldLabel: '통장',  
				    valueFieldName: 'BANK_BOOK_CODE',
					textFieldName: 'BANK_BOOK_NAME',
					listeners: {
						onSelected: {
							fn: function(records, type) {
								panelResult.setValue('BANK_BOOK_CODE', panelSearch.getValue('BANK_BOOK_CODE'));
								panelResult.setValue('BANK_BOOK_NAME', panelSearch.getValue('BANK_BOOK_NAME'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('BANK_BOOK_CODE', '');
							panelResult.setValue('BANK_BOOK_NAME', '');
						},
						applyextparam: function(popup){							
							//popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
					}
			}),{
		 		fieldLabel: '화폐',
		 		name:'MONEY_UNIT', 
		 		xtype: 'uniCombobox',
		 		comboType:'AU',
		 		comboCode:'B004', 
		 		displayField: 'value',
		 		listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('MONEY_UNIT', newValue);
					}
				}
			},
				Unilite.popup('BANK',{ 
				    fieldLabel: '은행',				    
				    valueFieldName: 'BANK_CODE',
					textFieldName: 'BANK_NAME',
					listeners: {
						onSelected: {
							fn: function(records, type) {
								panelResult.setValue('BANK_CODE', panelSearch.getValue('BANK_CODE'));
								panelResult.setValue('BANK_NAME', panelSearch.getValue('BANK_NAME'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('BANK_CODE', '');
							panelResult.setValue('BANK_NAME', '');
						},
						applyextparam: function(popup){							
							//popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
					}
				}), {               
                    //복호화 플래그(복호화 버튼 누를시 플래그 'Y')
                    name:'DEC_FLAG', 
                    xtype: 'uniTextfield',
                    hidden: true
                }
			]},{
				title:'추가정보',
   				id: 'search_panel2',
				itemId:'search_panel2',
        		defaultType: 'uniTextfield',
        		layout : {type : 'uniTable', columns : 1},
        		defaultType: 'uniTextfield',
        		
        		items:[{ 
	    			fieldLabel: '당기시작년월',
	    			name:'ST_DATE',
					xtype: 'uniMonthfield',
	//				value: UniDate.get('today'),
					allowBlank:false,
					width: 200
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
		 		fieldLabel: '일자',
		 		xtype: 'uniDatefield',
		 		name: 'AC_DATE',
		 		value: UniDate.get('today'),
		 		allowBlank:false,
		 		listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('AC_DATE', newValue);
						UniAppManager.app.fnSetStDate(newValue);
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
				Unilite.popup('ACCNT',{ 
				    fieldLabel: '계정과목',		    
				    valueFieldName: 'ACCNT_CODE',
					textFieldName: 'ACCNT_NAME',
					autoPopup:true,
					listeners: {
						onSelected: {
							fn: function(records, type) {
								panelSearch.setValue('ACCNT_CODE', panelResult.getValue('ACCNT_CODE'));
								panelSearch.setValue('ACCNT_NAME', panelResult.getValue('ACCNT_NAME'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelSearch.setValue('ACCNT_CODE', '');
							panelSearch.setValue('ACCNT_NAME', '');
						},
                        applyExtParam:{
                            scope:this,
                            fn:function(popup){
                                var param = {
                                    'ADD_QUERY' : "SUBSTRING(SPEC_DIVI,1,1) IN ('B','C')",
                                    'CHARGE_CODE': (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE
                                }
                                popup.setExtParam(param);
                            }
                        }
					}
			}),
				Unilite.popup('BANK_BOOK',{ 
				    fieldLabel: '통장',	
				    colspan: 2,					    
				    valueFieldName: 'BANK_BOOK_CODE',
					textFieldName: 'BANK_BOOK_NAME',
					listeners: {
						onSelected: {
							fn: function(records, type) {
								panelSearch.setValue('BANK_BOOK_CODE', panelResult.getValue('BANK_BOOK_CODE'));
								panelSearch.setValue('BANK_BOOK_NAME', panelResult.getValue('BANK_BOOK_NAME'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelSearch.setValue('BANK_BOOK_CODE', '');
							panelSearch.setValue('BANK_BOOK_NAME', '');
						},
						applyextparam: function(popup){							
							//popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
					}
			}),{
		 		fieldLabel: '화폐',
		 		name:'MONEY_UNIT', 
		 		xtype: 'uniCombobox',
		 		comboType:'AU',
		 		comboCode:'B004',
		 		displayField: 'value',
		 		listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('MONEY_UNIT', newValue);
					}
				}
			},
				Unilite.popup('BANK',{ 
				    fieldLabel: '은행',	
				    valueFieldName: 'BANK_CODE',
					textFieldName: 'BANK_NAME',
					listeners: {
						onSelected: {
							fn: function(records, type) {
								panelSearch.setValue('BANK_CODE', panelResult.getValue('BANK_CODE'));
								panelSearch.setValue('BANK_NAME', panelResult.getValue('BANK_NAME'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelSearch.setValue('BANK_CODE', '');
							panelSearch.setValue('BANK_NAME', '');
						},
						applyextparam: function(popup){							
							//popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
					}
				})
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
	
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('afs520skrGrid1', {
    	layout : 'fit',
        region : 'center',
        store : directMasterStore, 
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
        columns: [        
        	{dataIndex: 'BANK_CODE'			, width: 86
				,summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			        return Unilite.renderSummaryRow(summaryData, metaData, '소계', '총계');
            }},
			{dataIndex: 'BANK_NAME'			, width: 133}, 				
			{dataIndex: 'SAVE_CODE'			, width: 86},
			{dataIndex: 'SAVE_NAME'			, width: 133},
			{dataIndex: 'BANK_ACCOUNT_EXPOS'	, width: 133},
			{dataIndex: 'BANK_ACCOUNT'		, width: 133,hidden: true},
			{dataIndex: 'MONEY_UNIT'		, width: 86},
			{dataIndex: 'JAN_AMT_I'			, width: 166 , summaryType: 'sum'},
			{dataIndex: 'JAN_FOR_AMT_I'		, width: 166 , summaryType: 'sum'}
		] ,
        selModel: 'rowmodel',
        tbar: [
        
        ],
		listeners: {
			itemmouseenter:function(view, record, item, index, e, eOpts )	{          		
	        	view.ownerGrid.setCellPointer(view, item);
        	},
			onGridDblClick:function(grid, record, cellIndex, colName) {
				if(colName =="BANK_ACCOUNT_EXPOS") {
					grid.ownerGrid.openCryptAcntNumPopup(record);
				}else{
					masterGrid.gotoAgj(record);
				}
				
  			}
		},
		onItemcontextmenu:function( menu, grid, record, item, index, event  )	{   
			return true;
      	},
		openCryptAcntNumPopup:function( record )	{
			if(record)	{
				var params = {'BANK_ACCOUNT': record.get('BANK_ACCOUNT'), 'GUBUN_FLAG': '2', 'INPUT_YN': 'N'}
				Unilite.popupCipherComm('grid', record, 'BANK_ACCOUNT_EXPOS', 'BANK_ACCOUNT', params);
			}
				
		},
        uniRowContextMenu:{
			items: [
	            {	text: '예적금현황조회 이동',  
	            	handler: function(menuItem, event) {
	            		var param = menuItem.up('menu');
	            		masterGrid.gotoAgj(param.record);
	            	}
	        	}
	        ]
	    },
		gotoAgj:function(record)	{
			if(record)	{
		    	var params = {
					action:'select',
					'PGM_ID'			: 'afs520skr',
					//'AC_DATE_FR' 		: UniDate.getDbDateStr(panelSearch.getValue('AC_DATE')),
					'AC_DATE_FR' 		: UniDate.getDbDateStr( panelSearch.getValue('ST_DATE')).substring(0, 6) + '01',
					'AC_DATE_TO' 		: UniDate.getDbDateStr(panelSearch.getValue('AC_DATE')),
					'ST_DATE' 			: UniDate.getDbDateStr( panelSearch.getValue('ST_DATE')).substring(0, 6) + '01',
					'DIV_CODE' 			: panelSearch.getValue('ACCNT_DIV_CODE'),
					'BANK_CODE' 		: record.data['BANK_CODE'],
					'BANK_NAME' 		: record.data['BANK_NAME'],
					'BANK_BOOK_CODE' 	: record.data['SAVE_CODE'],
					'BANK_BOOK_NAME' 	: record.data['SAVE_NAME'],
					'MONEY_UNIT' 		: record.data['MONEY_UNIT']
				}
				var rec3 = {data : {prgID : 'afs510skr', 'text':''}};							
				parent.openTab(rec3, '/accnt/afs510skr.do', params);
			}
    	}          	        
    });                          
    
    //복호화 버튼 정의
    var decrypBtn = Ext.create('Ext.Button',{
        text:'복호화',
        width: 80,
        handler: function() {
            var needSave = !UniAppManager.app.getTopToolbar().getComponent('save').isDisabled();
            if(needSave){
               alert(Msg.sMB154); //먼저 저장하십시오.
               return false;
            }
            panelSearch.setValue('DEC_FLAG', 'Y');
            UniAppManager.app.onQueryButtonDown();
            panelSearch.setValue('DEC_FLAG', '');
        }
    });
    
	 Unilite.Main( {
	 	border: false,
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
		id : 'afs520skrApp',
		fnInitBinding : function(params) {
			//복호화버튼 그리드 툴바에 추가
            var tbar = masterGrid._getToolBar();
            tbar[0].insert(tbar.length + 1, decrypBtn);
             
			if(!UserInfo.appOption.collapseLeftSearch) {
				activeSForm = panelSearch;
			} else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('AC_DATE');
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			panelSearch.setValue('ST_DATE',getStDt[0].STDT);
			panelSearch.setValue('AC_DATE',UniDate.get('today'));
			panelResult.setValue('AC_DATE',UniDate.get('today'));	

			//20210521 추가: 링크 받는 로직 추가
			if(!Ext.isEmpty(params && params.PGM_ID)){
				if(params.PGM_ID == 's_ssa700skrv_wm') {
					panelSearch.setValue('ACCNT_DIV_CODE'	, params.DIV_CODE);
					panelResult.setValue('ACCNT_DIV_CODE'	, params.DIV_CODE);
					panelSearch.setValue('AC_DATE'			, params.BASIS_DATE);
					panelResult.setValue('AC_DATE'			, params.BASIS_DATE);
					UniAppManager.app.onQueryButtonDown();
				}
			}
		},
		onQueryButtonDown : function()	{		
			if(panelSearch.setAllFieldsReadOnly(true) == false){
				return false;
			}
			if(panelResult.setAllFieldsReadOnly(true) == false){
				return false;
			}			
			directMasterStore.loadStoreRecords();				
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		},
        fnSetStDate:function(newValue) {
        	if(newValue == null){
				return false;
			}else{
		    	if(UniDate.getDbDateStr(newValue).substring(0, 6) <  UniDate.getDbDateStr(getStDt[0].STDT).substring(0, 6)){
					panelSearch.setValue('ST_DATE', UniDate.getDbDateStr(newValue).substring(0, 4) + UniDate.getDbDateStr(getStDt[0].STDT).substring(4, 6));
				}else {
					panelSearch.setValue('ST_DATE',UniDate.getDbDateStr(getStDt[0].STDT).substring(0, 6));
				}
			}
        }
	});
};


</script>
