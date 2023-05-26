<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="bsa920skrv"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="J641" /> <!-- 회사코드-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >


function appMain() {     
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Bsa920skrvModel', {
	    fields: [  	  
	    	{name: 'BANK_CODE'   		  , text: '은행코드' 	 ,type: 'string'},
	    	{name: 'BANK_NAME'            , text: '은행'      ,type: 'string'},
	    	{name: 'ACCNT_GUBUN'          , text: '<t:message code="system.label.base.classfication" default="구분"/>'      ,type: 'string'},
	    	{name: 'ACCNT_CNT'            , text: '건수'      ,type: 'uniQty'},
	    	{name: 'ACCNT_PRICE'          , text: '금액'      ,type: 'uniPrice'},
	    	{name: 'RELAY_GUBUN'          , text: '<t:message code="system.label.base.classfication" default="구분"/>'      ,type: 'string'},
            {name: 'RELAY_CNT'            , text: '건수'      ,type: 'uniQty'},
            {name: 'RELAY_PRICE'          , text: '금액'      ,type: 'uniPrice'}
		]          	
	});
	
	Unilite.defineModel('Bsa920skrvModel2', {
	    fields: [  	  
	    	{name: 'COMPANY_CODE'         , text: '회사코드'      ,type: 'string'},
            {name: 'COMPANY_NAME'         , text: '회사'          ,type: 'string'},
            {name: 'GUBUN'                , text: '<t:message code="system.label.base.classfication" default="구분"/>'          ,type: 'string'},
            {name: 'OK_CNT'               , text: '성공건수'      ,type: 'uniQty'},
            {name: 'ERR_CNT'              , text: '실패건수'      ,type: 'uniQty'},
            {name: 'UN_CNT'               , text: '미처리건수'    ,type: 'uniQty'},
            {name: 'REGS_DATE'            , text: '일자'          ,type: 'string'}
		]          	
	});
	
	Unilite.defineModel('Bsa920skrvModel3', {
	    fields: [  	  
	    	{name: 'BANK_CODE'            , text: '은행코드'   ,type: 'string'},
            {name: 'BANK_NAME'            , text: '은행'      ,type: 'string'},
            {name: 'ACCNT_GUBUN'          , text: '<t:message code="system.label.base.classfication" default="구분"/>'      ,type: 'string'},
            {name: 'ACCNT_CNT'            , text: '건수'      ,type: 'uniQty'},
            {name: 'ACCNT_PRICE'          , text: '금액'      ,type: 'uniPrice'},
            {name: 'RELAY_GUBUN'          , text: '<t:message code="system.label.base.classfication" default="구분"/>'      ,type: 'string'},
            {name: 'RELAY_CNT'            , text: '건수'      ,type: 'uniQty'},
            {name: 'RELAY_PRICE'          , text: '금액'      ,type: 'uniPrice'}
		]          	
	});
	
	Unilite.defineModel('Bsa920skrvModel4', {
	    fields: [  	  
	    	{name: 'COMPANY_CODE'         , text: '회사코드'    ,type: 'string'},
            {name: 'COMPANY_NAME'         , text: '회사'       ,type: 'string'},
            {name: 'APP_ID'               , text: 'APP_ID'    ,type: 'string'},
            {name: 'REC_CNT'              , text: '수신건수'    ,type: 'uniQty'},
            {name: 'WAIT_CNT'             , text: '대기건수'    ,type: 'uniQty'},
            {name: 'UN_PROC_CNT'          , text: '미처리건수'   ,type: 'uniQty'}
		]          	
	});
	
	// GroupField string type으로 변환
	function dateToString(v, record){
		return UniDate.safeFormat(v);
	  }
	  
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('bsa920skrvMasterStore1',{
		model: 'Bsa920skrvModel',
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
                read: 'bsa920skrvService.selectList'                	
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
	
	var directMasterStore2 = Unilite.createStore('bsa920skrvMasterStore2',{
		model: 'Bsa920skrvModel2',
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
                read: 'bsa920skrvService.selectList2'
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
	
	var directMasterStore3 = Unilite.createStore('bsa920skrvMasterStore3',{
		model: 'Bsa920skrvModel3',
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
                read: 'bsa920skrvService.selectList3'                	
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
	
	var directMasterStore4 = Unilite.createStore('bsa920skrvMasterStore4',{
		model: 'Bsa920skrvModel4',
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
                read: 'bsa920skrvService.selectList4'                	
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
		title: '<t:message code="system.label.base.searchconditon" default="검색조건"/>',
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
			title: '<t:message code="system.label.base.basisinfo2" default="기본정보"/>', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items: [{
                fieldLabel: '회사',
                name: 'COMPANY_CODE',
                xtype: 'uniCombobox',
                comboType: 'AU',
                comboCode: 'J641',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelResult.setValue('COMPANY_CODE', newValue);
                    }
                }
            },{
		 		fieldLabel: '일자',
		 		xtype: 'uniDatefield',
		 		name: 'DATE',
		 		allowBlank:false,
		 		value: UniDate.get('today'),
		 		listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DATE', newValue);						
					}
				}
			},
    		    Unilite.popup('BANK',{ 
    		    	fieldLabel: '은행',   
    //    		    	popupWidth: 710,
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
    		     })
			]}
		]	
	});	//end panelSearch  
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{
            fieldLabel: '회사',
            name: 'COMPANY_CODE',
            xtype: 'uniCombobox',
            comboType: 'AU',
            comboCode: 'J641',
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {                        
                    panelSearch.setValue('COMPANY_CODE', newValue);
                }
            }
        },{
            fieldLabel: '일자',
            xtype: 'uniDatefield',
            name: 'DATE',
            allowBlank:false,
            value: UniDate.get('today'),
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {                        
                    panelSearch.setValue('DATE', newValue);                     
                }
            }
        },
            Unilite.popup('BANK',{ 
                fieldLabel: '은행',   
//                  popupWidth: 710,
                listeners: {
                    onSelected: {
                        fn: function(records, type) {
                            panelSearch.setValue('BANK_CODE', panelResult.getValue('BANK_CODE'));
                            panelSearch.setValue('BANK_NAME', panelResult.getValue('BANK_NAME'));                                                                                                           
                        },
                        scope: this
                    },
                    onClear: function(type) {
                        panelSearch.setValue('BANK_CODE', '');
                        panelSearch.setValue('BANK_NAME', '');
                    },
                    applyextparam: function(popup){                         
                        //popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
                    }
                }
             })
        ]
    });
	
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('bsa920skrvGrid1', {
    	layout : 'fit',
    	title : '이체',
        store : directMasterStore, 
        uniOpt:{
			useMultipleSorting	: true,
    		useLiveSearch		: true,
    		onLoadSelectFirst	: false,
    		dblClickToEdit		: false,
    		useGroupSummary		: true,
			useContextMenu		: false,
			useRowNumberer		: true,
			expandLastColumn	: false,
			useRowContext		: true,
    		filter: {
				useFilter		: true,
				autoCreate		: true
			}
        },
        columns: [
//            {dataIndex: 'BANK_CODE',        width: 120},
            {dataIndex: 'BANK_NAME',        width: 120},
            {
                text: '회계',
                columns:[
                    {dataIndex: 'ACCNT_GUBUN',        width: 120},
                    {dataIndex: 'ACCNT_CNT',        width: 120},
                    {dataIndex: 'ACCNT_PRICE',        width: 120}
                ]
            },
            {
                text: '중계',
                columns:[
                    {dataIndex: 'RELAY_GUBUN',        width: 120},
                    {dataIndex: 'RELAY_CNT',        width: 120},
                    {dataIndex: 'RELAY_PRICE',        width: 120}
                ]
            }
		],
		listeners: {
			
		}            	        
    });       
    
    var masterGrid2 = Unilite.createGrid('bsa920skrvGrid2', {
    	layout : 'fit',
    	title : 'etax',
        store : directMasterStore2, 
        uniOpt:{
			useMultipleSorting	: true,
    		useLiveSearch		: true,
    		onLoadSelectFirst	: false,
    		dblClickToEdit		: false,
    		useGroupSummary		: true,
			useContextMenu		: false,
			useRowNumberer		: true,
			expandLastColumn	: false,
			useRowContext		: true,
    		filter: {
				useFilter		: true,
				autoCreate		: true
			}
        },
        columns: [        
        	{dataIndex: 'COMPANY_CODE'       , width: 120},   
//            {dataIndex: 'COMPANY_NAME'       , width: 120},   
            {dataIndex: 'GUBUN'              , width: 120},   
            {dataIndex: 'OK_CNT'             , width: 120},
            {dataIndex: 'ERR_CNT'            , width: 120},
            {dataIndex: 'UN_CNT'             , width: 120},
            {dataIndex: 'REGS_DATE'          , width: 120}
		]             	        
    });                       
    
    var masterGrid3 = Unilite.createGrid('bsa920skrvGrid3', {
        layout : 'fit',
        title : '법인카드',
        store : directMasterStore3, 
        uniOpt:{
            useMultipleSorting  : true,
            useLiveSearch       : true,
            onLoadSelectFirst   : false,
            dblClickToEdit      : false,
            useGroupSummary     : true,
            useContextMenu      : false,
            useRowNumberer      : true,
            expandLastColumn    : false,
            useRowContext       : true,
            filter: {
                useFilter       : true,
                autoCreate      : true
            }
        },
        columns: [            
//            {dataIndex: 'BANK_CODE',        width: 120},
            {dataIndex: 'BANK_NAME',        width: 120},
            {
                text: '회계',
                columns:[
                    {dataIndex: 'ACCNT_GUBUN',        width: 120},
                    {dataIndex: 'ACCNT_CNT',        width: 120},
                    {dataIndex: 'ACCNT_PRICE',        width: 120}
                ]
            },
            {
                text: '중계',
                columns:[
                    {dataIndex: 'RELAY_GUBUN',        width: 120},
                    {dataIndex: 'RELAY_CNT',        width: 120},
                    {dataIndex: 'RELAY_PRICE',        width: 120}
                ]
            }
        ],
        listeners: {
            
        }                       
    });
    
    var masterGrid4 = Unilite.createGrid('bsa920skrvGrid4', {
        layout : 'fit',
        title : '자동기표현황',
        store : directMasterStore4, 
        uniOpt:{
            useMultipleSorting  : true,
            useLiveSearch       : true,
            onLoadSelectFirst   : false,
            dblClickToEdit      : false,
            useGroupSummary     : true,
            useContextMenu      : false,
            useRowNumberer      : true,
            expandLastColumn    : false,
            useRowContext       : true,
            filter: {
                useFilter       : true,
                autoCreate      : true
            }
        },
        columns: [
//            {dataIndex: 'COMPANY_CODE',        width: 120},
            {dataIndex: 'COMPANY_NAME',        width: 120},
            {dataIndex: 'APP_ID',              width: 120},
            {dataIndex: 'REC_CNT',             width: 120},
            {dataIndex: 'WAIT_CNT',            width: 120},
            {dataIndex: 'UN_PROC_CNT',         width: 120}
            
        ],
        listeners: {
            
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
	     	beforetabchange:  function ( tabPanel, newCard, oldCard, eOpts )  {
	     		var newTabId = newCard.getId();
					console.log("newCard:  " + newCard.getId());
					console.log("oldCard:  " + oldCard.getId());
					
				switch(newTabId)	{
					case 'bsa920skrvGrid1':
						panelSearch.setValue('QUERY_TYPE', '1');
						directMasterStore.loadStoreRecords();
						break;
						
					case 'bsa920skrvGrid2':
						panelSearch.setValue('QUERY_TYPE', '2');
						directMasterStore2.loadStoreRecords();
						break;
						
					case 'bsa920skrvGrid3':
						panelSearch.setValue('QUERY_TYPE', '3');
						directMasterStore3.loadStoreRecords();
						break;
						
					case 'bsa920skrvGrid4':
						panelSearch.setValue('QUERY_TYPE', '4');
						directMasterStore4.loadStoreRecords();
						break;
						
					default:
						break;
				}
	     	}
	     }
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
		id : 'bsa920skrvApp',
		fnInitBinding : function() {
			if(!UserInfo.appOption.collapseLeftSearch) {
				activeSForm = panelSearch;
			} else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('COMPANY_CODE');
			
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
		},
		onQueryButtonDown : function()	{		
			var activeTabId = tab.getActiveTab().getId();			
			if(activeTabId == 'bsa920skrvGrid1'){
				var param= Ext.getCmp('searchForm').getValues();
				panelSearch.getForm().load({
					params : param,
					success: function(form, action) {
						directMasterStore.loadStoreRecords();
					}
				});					
			} else if(activeTabId == 'bsa920skrvGrid2'){	
				var param= Ext.getCmp('searchForm').getValues();
				panelSearch.getForm().load({
					params : param,
					success: function(form, action) {
						directMasterStore2.loadStoreRecords();
					}
				});									
			} else if(activeTabId == 'bsa920skrvGrid3'){	
				var param= Ext.getCmp('searchForm').getValues();
				panelSearch.getForm().load({
					params : param,
					success: function(form, action) {
						directMasterStore3.loadStoreRecords();
					}
				});					
			} else if(activeTabId == 'bsa920skrvGrid4'){	
				var param= Ext.getCmp('searchForm').getValues();
				panelSearch.getForm().load({
					params : param,
					success: function(form, action) {
						directMasterStore4.loadStoreRecords();
					}
				});					
			}
		}
	});
};


</script>
