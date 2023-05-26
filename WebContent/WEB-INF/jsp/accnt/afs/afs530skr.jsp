<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="afs530skr"  >
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
	Unilite.defineModel('afs530skrModel', {
	    fields: [  	  
	        {name: 'ACCNT_CODE'             , text: '계정과목코드'  ,type: 'string'},
	        {name: 'ACCNT_NAME'             , text: '계정과목'      ,type: 'string'},
	    	{name: 'BANK_CODE'				, text: '은행코드' 	    ,type: 'string'},
		    {name: 'BANK_NAME'				, text: '은행명'		,type: 'string'},
            {name: 'BANK_ACCOUNT'           , text: '계좌번호(DB)'  ,type: 'string'},
            {name: 'BANK_ACCOUNT_EXPOS'     , text: '계좌번호'  ,type: 'string', defaultValue:'***************'},
		    {name: 'SAVE_CODE'				, text: '통장코드' 	    ,type: 'string'},
		    {name: 'SAVE_NAME'				, text: '통장명' 		,type: 'string'},
            {name: 'IWALL_AMT_I'              , text: '이월금액'      ,type: 'uniPrice'},
		    {name: 'DR_AMT_I'				, text: '차변' 		    ,type: 'uniPrice'},
            {name: 'CR_AMT_I'               , text: '대변'          ,type: 'uniPrice'},
		    {name: 'JAN_AMT_I'				, text: '잔액' 		    ,type: 'uniPrice'}
            
		]          	
	});
	  
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('afs530skrMasterStore1',{
		model: 'afs530skrModel',
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
                read: 'afs530skrService.selectList'                	
            }
        },
        loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		},
		listeners: {
            load: function(store, records, successful, eOpts) {
                if(store.count() == 0) {
                    UniAppManager.setToolbarButtons('print',false);
                }else{
                    UniAppManager.setToolbarButtons('print',true);
                }
            }
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
                xtype: 'uniDateRangefield',  
                startFieldName: 'AC_DATE_FR',
                endFieldName: 'AC_DATE_TO',
                allowBlank:false,
                width: 315,
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelResult) {
                        panelResult.setValue('AC_DATE_FR',newValue);
                        UniAppManager.app.fnSetStDate(newValue);
                    }
                },
                onEndDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelResult) {
                        panelResult.setValue('AC_DATE_TO',newValue);
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
						applyextparam: function(popup){							
							popup.setExtParam({'CHARGE_CODE': (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE});
							popup.setExtParam({'ADD_QUERY': "SUBSTRING(SPEC_DIVI,1,1) IN ('B','C')"});
							
						}
					}
			}),
			Unilite.popup('BANK_BOOK',{ 
				    fieldLabel: '통장',  
				    valueFieldName: 'BANK_BOOK_CODE',
					textFieldName: 'BANK_BOOK_NAME',
					autoPopup:true,
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
			})
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
//					value: UniDate.get('today'),
//					holdable:'hold',
					allowBlank:false,
					width: 200
				}]				
			}, {               
                //복호화 플래그(복호화 버튼 누를시 플래그 'Y')
                name:'DEC_FLAG', 
                xtype: 'uniTextfield',
                hidden: true
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
		layout : {type : 'uniTable', columns : 2},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{ 
            fieldLabel: '전표일',
            xtype: 'uniDateRangefield',  
            startFieldName: 'AC_DATE_FR',
            endFieldName: 'AC_DATE_TO',
            allowBlank:false,
            width: 315,
            onStartDateChange: function(field, newValue, oldValue, eOpts) {
                if(panelSearch) {
                    panelSearch.setValue('AC_DATE_FR',newValue);
                    UniAppManager.app.fnSetStDate(newValue);
                }
            },
            onEndDateChange: function(field, newValue, oldValue, eOpts) {
                if(panelSearch) {
                    panelSearch.setValue('AC_DATE_TO',newValue);
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
						applyextparam: function(popup){							
							popup.setExtParam({'CHARGE_CODE': (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE});
                            popup.setExtParam({'ADD_QUERY': "SUBSTRING(SPEC_DIVI,1,1) IN ('B','C')"});
						}
					}
			}),
			Unilite.popup('BANK_BOOK',{ 
				    fieldLabel: '통장',	
				    colspan: 2,					    
				    valueFieldName: 'BANK_BOOK_CODE',
					textFieldName: 'BANK_BOOK_NAME',
					autoPopup:true,
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
    
    var masterGrid = Unilite.createGrid('afs530skrGrid1', {
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
    	tbar: [
        
        ],
        columns: [        
        	{dataIndex: 'ACCNT_CODE'         		, width: 90, hidden: true},
            {dataIndex: 'ACCNT_NAME'                , width: 170
                ,summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                    return Unilite.renderSummaryRow(summaryData, metaData, '소계', '총계');
            }},
            {dataIndex: 'BANK_CODE'			        , width: 80, hidden: true},
            {dataIndex: 'BANK_NAME'			        , width: 150},
            {dataIndex: 'BANK_ACCOUNT_EXPOS'        , width: 150},
            {dataIndex: 'BANK_ACCOUNT'              , width: 150,hidden: true},
            {dataIndex: 'SAVE_CODE'			        , width: 90, hidden: true},
            {dataIndex: 'SAVE_NAME'			        , width: 150},
            {dataIndex: 'IWALL_AMT_I'               , width: 110, summaryType: 'sum'},
            {dataIndex: 'DR_AMT_I'			        , width: 110, summaryType: 'sum'},
            {dataIndex: 'CR_AMT_I'                  , width: 110, summaryType: 'sum'},
            {dataIndex: 'JAN_AMT_I'			        , width: 110, summaryType: 'sum'}
		] ,
        selModel: 'rowmodel',
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
					'PGM_ID'			: 'afs530skr',
					'AC_DATE_FR' 		: panelSearch.getValue('AC_DATE_FR'),
					'AC_DATE_TO'        : panelSearch.getValue('AC_DATE_TO'),
					
					'ST_DATE' 			: UniDate.getDbDateStr( panelSearch.getValue('ST_DATE')).substring(0, 6) + '01',
					'DIV_CODE' 			: UserInfo.divCode,
					'BANK_CODE' 		: record.data['BANK_CODE'],
					'BANK_NAME' 		: record.data['BANK_NAME'],
					'BANK_BOOK_CODE' 	: record.data['SAVE_CODE'],
					'BANK_BOOK_NAME' 	: record.data['SAVE_NAME']
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
		id : 'afs530skrApp',
		fnInitBinding : function() {
			//복호화버튼 그리드 툴바에 추가
            var tbar = masterGrid._getToolBar();
            tbar[0].insert(tbar.length + 1, decrypBtn);
            
			if(!UserInfo.appOption.collapseLeftSearch) {
				activeSForm = panelSearch;
			} else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('AC_DATE_FR');
			UniAppManager.setToolbarButtons('reset','print',false);
			
			panelSearch.setValue('ST_DATE',getStDt[0].STDT);
			
			panelSearch.setValue('AC_DATE_FR',UniDate.get('startOfMonth'));
            panelResult.setValue('AC_DATE_FR',UniDate.get('startOfMonth'));
            panelSearch.setValue('AC_DATE_TO',UniDate.get('today'));
            panelResult.setValue('AC_DATE_TO',UniDate.get('today'));
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
		onPrintButtonDown: function() {
            var param= Ext.getCmp('searchForm').getValues();
            var win = Ext.create('widget.PDFPrintWindow', {
                url: CPATH+'/afs/afs530rkrPrint.do',
                prgID: 'afs530rkr',
                    extParam: param
                });
            win.center();
            win.show();                 
        },
        fnSetStDate:function(newValue) {
        	if(newValue == null){
				return false;
			}else{
		    	if(UniDate.getDbDateStr(newValue).substring(0, 6) < (UniDate.getDbDateStr(newValue).substring(0, 4) + UniDate.getDbDateStr(getStDt[0].STDT).substring(4, 6))){
					panelSearch.setValue('ST_DATE', UniDate.getDbDateStr(newValue).substring(0, 4)-1 + UniDate.getDbDateStr(getStDt[0].STDT).substring(4, 6));
				}else{
					panelSearch.setValue('ST_DATE', UniDate.getDbDateStr(newValue).substring(0, 4) + UniDate.getDbDateStr(getStDt[0].STDT).substring(4, 6));
				}
			}
        }
	});
};


</script>
