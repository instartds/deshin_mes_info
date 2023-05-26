<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="w_bsa000skrv_yp"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" /><!--창고-->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" />
    <t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" />
    <t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" />
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >


function appMain() {     
	var InfoBoardWindow;   //공지사항 상세창..
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('W_bsa000skrv_ypModel', {
	    fields: [
		    {name: 'SEQ'            ,text:'순번'        ,type:'string'},
		    {name: 'BULLETIN_ID'    ,text:'BULLETIN_ID'     ,type:'string'},
            {name: 'TITLE'          ,text:'제목'        ,type:'string'},
            {name: 'USER_NAME'      ,text:'게시자'        ,type:'string'},
            {name: 'ACCESS_CNT'     ,text:'조회'        ,type:'string'},
            {name: 'FROM_DATE'      ,text:'게시일'        ,type:'uniDate'},
            {name: 'TO_DATE'        ,text:'TO_DATE'        ,type:'string'},
            {name: 'USER_ID'        ,text:'USER_ID'        ,type:'string'},
            {name: 'TYPE_FLAG'      ,text:'TYPE_FLAG'        ,type:'string'},
            {name: 'AUTH_FLAG'      ,text:'AUTH_FLAG'        ,type:'string'},
            {name: 'CONTENTS'       ,text:'CONTENTS'        ,type:'string'}
		]
	});
	
	
	Unilite.defineModel('W_bsa000skrv_ypModel2', {
	    fields: [
		    {name: 'ORDER_NUM'        , text: '주문번호'  ,type: 'string'},
            {name: 'ORDER_DATE'       , text: '주문일자'  ,type: 'string'},
            {name: 'ORDER_QTY'        , text: '주문수량'  ,type: 'string'},
            {name: 'ORDER_AMT'        , text: '공급가액'  ,type: 'string'},
            {name: 'ORDER_TAX_AMT'    , text: '세액'     ,type: 'string'},
            {name: 'ORDER_TOT_AMT'    , text: '합계금액'  ,type: 'string'},
            {name: 'ORDER_STATUS'     , text: '상태'     ,type: 'string'}            
		]
	});
	
	Unilite.defineModel('W_bsa000skrv_ypModel3', {
        fields: [     
            {name: 'ITEM_CODE'        , text: '품목코드'   ,type: 'string'},
            {name: 'ITEM_NAME'        , text: '품목명'    ,type: 'string'},
            {name: 'SPEC'             , text: '규격'      ,type: 'string'},
            {name: 'SALE_P'           , text: '판매단가'   ,type: 'uniPrice'}
        ]
    });
	  
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('w_bsa000skrv_ypMasterStore1',{
		model: 'W_bsa000skrv_ypModel',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
            editable: false,				// 수정 모드 사용 
            deletable:false,			// 삭제 가능 여부 
	        useNavi : false				// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
           type: 'direct',
            api: {			
                read: 'w_bsa000skrv_ypService.selectList1'                	
            }
        },
        loadStoreRecords: function() {
			var param= panelResult.getValues();			
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	
	
	var directMasterStore2 = Unilite.createStore('w_bsa000skrv_ypMasterStore2',{
		model: 'W_bsa000skrv_ypModel2',
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
                read: 'w_bsa000skrv_ypService.selectList2'                	
            }
        },
        loadStoreRecords: function() {
			var param= panelResult.getValues();			
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	
	var directMasterStore3 = Unilite.createStore('w_bsa000skrv_ypMasterStore3',{
        model: 'W_bsa000skrv_ypModel3',
        uniOpt: {
            isMaster: true,         // 상위 버튼 연결 
            editable: false,            // 수정 모드 사용 
            deletable:false,            // 삭제 가능 여부 
            useNavi : false         // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
           type: 'direct',
            api: {          
                read: 'w_bsa000skrv_ypService.selectList3'                  
            }
        },
        loadStoreRecords: function() {
            var param= panelResult.getValues();            
            console.log( param );
            this.load({
                params : param
            });
        }
    });
	
    var blankForm = Unilite.createSearchForm('blankForm',{
        region: 'north',
        layout : {type : 'uniTable', columns : 3},
        padding:'1 1 1 1',
        height: 61,
        autoScroll: true,
        border:true,
        hidden: !UserInfo.appOption.collapseLeftSearch,
        items: [
        ]
    });  
    
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		height: 61,
		autoScroll: true,
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{
            xtype: 'uniTextfield',
            fieldLabel: '품목',
            name: 'ITEM',
            colspan: 2,
            width: 230
		},{                        
           width: 100,
           xtype: 'button',
           text: '조회',
           id: 'confirmBtn',
           margin: '0 0 0 55',           
           handler : function() {
            directMasterStore3.loadStoreRecords();
           }
        },{
            fieldLabel: '대분류',
            name: 'TXTLV_L1', 
            xtype: 'uniCombobox',
            store: Ext.data.StoreManager.lookup('itemLeve1Store'), 
            child: 'TXTLV_L2',
            width: 230
        }, {
            fieldLabel: '중분류',
            name: 'TXTLV_L2', 
            xtype: 'uniCombobox',  
            labelWidth: 50,
            width: 180,
            store: Ext.data.StoreManager.lookup('itemLeve2Store'), 
            child: 'TXTLV_L3'
        }, {
            fieldLabel: '소분류',
            name: 'TXTLV_L3', 
            xtype: 'uniCombobox',  
            labelWidth: 50,
            width: 180,
            store: Ext.data.StoreManager.lookup('itemLeve3Store'), 
            parentNames:['TXTLV_L1','TXTLV_L2'],
            levelType:'ITEM'                
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
	
	var detailForm = Unilite.createForm('w_bsa000skrv_ypDetailForm', {
        region:'south',
        weight:-100,
        height: 1000,
        layout : {type:'uniTable', columns:3},
        disabled: false,
        autoScroll:true,
        defaults: {readOnly: true},
        items:[{        
            fieldLabel: '게시유형',
            name: 'TYPE_FLAG',
            xtype:'uniCombobox',
            comboType:'AU',
            comboCode:'B602'    
        },{     
            fieldLabel: '게시시작일',
            xtype: 'uniDatefield',              
            name: 'FROM_DATE'
        },{     
            fieldLabel: '게시종료일',
            xtype: 'uniDatefield',              
            name: 'TO_DATE'
        },{
            xtype: 'uniTextfield',
            fieldLabel: '게시자',
            name: 'USER_ID'
        },{     
            fieldLabel: '게시대상',
            name: 'AUTH_FLAG',
            xtype:'uniCombobox',
            comboType:'AU',
            comboCode:'B603',
            colspan: 2
        },{     
            fieldLabel: '사업장',
            name: 'DIV_CODE',
            xtype:'uniCombobox',
            comboType:'BOR120',
            value: UserInfo.divCode,
            hidden: true
        },   
            Unilite.popup('DEPT',{
            fieldLabel: '부서',
            validateBlank:false,
            colspan:2,
            hidden: true
        }),{        
            fieldLabel: '영업소',
            name: 'OFFICE_CODE',
            xtype: 'uniCombobox',
            comboType:'AU', 
            comboCode:'GO01',
            hidden:true
        },{     
            fieldLabel: '제목',
            name: 'TITLE',
            xtype: 'uniTextfield',
            width: 980,         
            colspan: 4
        },{     
            fieldLabel: '내용',
            name: 'CONTENTS',
            xtype: 'textareafield',
            width: 980,
            height: 400,
            colspan: 4
        }]
    }); 
    
    function openInfoBoardWindow() {        //공지사항 row 더블 클릭시..
        if(!InfoBoardWindow) {
            InfoBoardWindow = Ext.create('widget.uniDetailWindow', {
                title: '공지사항',
                width: 1050,                             
                height: 580,
                layout: {type:'vbox', align:'stretch'},                 
                items: [detailForm],
                tbar:  ['->',
                    {
                        itemId : 'closeBtn',
                        text: '닫기',
                        handler: function() {
                            InfoBoardWindow.hide();
                        },
                        disabled: false
                    }
                                ],
                listeners : {beforehide: function(me, eOpt) {
                            },
                             beforeclose: function( panel, eOpts )  {
                            },
                             show: function( panel, eOpts ) {
                             	
                             }
                }       
            })
        }
        InfoBoardWindow.center();
        InfoBoardWindow.show();
    }
    /**
     * Master Grid 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('w_bsa000skrv_ypGrid1', {
    	layout : 'fit',
        region : 'center',
        title: '공지사항',
        uniOpt:{
			useMultipleSorting	: true,
    		useLiveSearch		: true,
    		onLoadSelectFirst	: true,
    		dblClickToEdit		: false,
    		useGroupSummary		: true,
			useContextMenu		: false,
			useRowNumberer		: true,
			expandLastColumn	: false,
			useRowContext		: true,
    		filter: {
				useFilter		: true,
				autoCreate		: true
			},
            state: {
                useState: false,         //그리드 설정 버튼 사용 여부
                useStateList: false      //그리드 설정 목록 사용 여부
            }
        },
        tbar: [
        
        ],
		store: directMasterStore,
		selModel : 'rowmodel',
        columns: [       
        	{dataIndex: 'SEQ'            , width: 100, align: 'center'},                
            {dataIndex: 'TITLE'          , width: 400, flex: 1},                 
            {dataIndex: 'USER_NAME'      , width: 150, align: 'center'},                 
            {dataIndex: 'ACCESS_CNT'     , width: 100, align: 'center'},                 
            {dataIndex: 'FROM_DATE'      , width: 100}  
		],
		listeners: {									
        	select: function(grid, record, index, eOpts ){
        		
          	},
			onGridDblClick:function(grid, record, cellIndex, colName, td)	{				
				openInfoBoardWindow();
				var param = record.data;
				w_bsa000skrv_ypService.updateCnt(param, function(provider, response)  {
                    if(provider){
//                        UniAppManager.updateStatus(Msg.sMB011);
                    }
                });
			},
			selectionchangerecord: function( selected ) {
                detailForm.setActiveRecord(selected);
            }
		}
    });
    
        /**
     * Master Grid2 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid2 = Unilite.createGrid('w_bsa000skrv_ypGrid2', {    	
    	layout : 'fit',
        region : 'south',
        title: '주문현황',
        uniOpt:{
			useMultipleSorting	: true,
    		useLiveSearch		: true,
    		onLoadSelectFirst	: true,
    		dblClickToEdit		: false,
    		useGroupSummary		: true,
			useContextMenu		: false,
			useRowNumberer		: true,
			expandLastColumn	: false,
			useRowContext		: true,
    		filter: {
				useFilter		: true,
				autoCreate		: true
			},
            state: {
                useState: false,         //그리드 설정 버튼 사용 여부
                useStateList: false      //그리드 설정 목록 사용 여부
            }
        },
		store: directMasterStore2,
		selModel : 'rowmodel',
        columns: [        
        	{dataIndex: 'ORDER_NUM'        , width: 120},   
            {dataIndex: 'ORDER_DATE'       , width: 120},   
            {dataIndex: 'ORDER_QTY'        , width: 120},   
            {dataIndex: 'ORDER_AMT'        , width: 120},   
            {dataIndex: 'ORDER_TAX_AMT'    , width: 120},   
            {dataIndex: 'ORDER_TOT_AMT'    , width: 120},   
            {dataIndex: 'ORDER_STATUS'     , width: 120, flex: 1}
		],
		listeners: {
			onGridDblClick:function(grid, record, cellIndex, colName) {
				var params = {
					action:'select',
					'PGM_ID'		: 'w_bsa000skrv_yp',
					'DIV_CODE' : record.data['DIV_CODE'],
					'AC_DATE' : record.data['AC_DATE'],
					'INPUT_PATH' : record.data['INPUT_PATH'],
					'SLIP_NUM' : record.data['SLIP_NUM'],
					'SLIP_SEQ' : record.data['SLIP_SEQ']
				}
				if(record.data['INPUT_PATH'] == 'Z3') {
					var rec1 = {data : {prgID : 'dgj100ukr', 'text':''}};							
					parent.openTab(rec1, '/accnt/dgj100ukr.do', params);
  				} else {
  					var rec2 = {data : {prgID : 'agj200ukr', 'text':''}};							
					parent.openTab(rec2, '/accnt/agj200ukr.do', params);
  				}
			}
		}            			
    });
    
    var masterGrid3 = Unilite.createGrid('w_bsa000skrv_ypGrid3', {      
        layout : 'fit',
        region : 'center',
        title: '단가조회',
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
            },
            state: {
                useState: false,         //그리드 설정 버튼 사용 여부
                useStateList: false      //그리드 설정 목록 사용 여부
            }
        },
        store: directMasterStore3,
        selModel : 'rowmodel',
        columns: [        
            {dataIndex: 'ITEM_CODE'        , width: 120},
            {dataIndex: 'ITEM_NAME'        , width: 300, flex: 1},
            {dataIndex: 'SPEC'             , width: 150},
            {dataIndex: 'SALE_P'           , width: 120}
        ],
        listeners: {
            onGridDblClick:function(grid, record, cellIndex, colName) {
                var params = {
                    action:'select',
                    'PGM_ID'        : 'w_bsa000skrv_yp',
                    'DIV_CODE' : record.data['DIV_CODE'],
                    'AC_DATE' : record.data['AC_DATE'],
                    'INPUT_PATH' : record.data['INPUT_PATH'],
                    'SLIP_NUM' : record.data['SLIP_NUM'],
                    'SLIP_SEQ' : record.data['SLIP_SEQ']
                }
                if(record.data['INPUT_PATH'] == 'Z3') {
                    var rec1 = {data : {prgID : 'dgj100ukr', 'text':''}};                           
                    parent.openTab(rec1, '/accnt/dgj100ukr.do', params);
                } else {
                    var rec2 = {data : {prgID : 'agj200ukr', 'text':''}};                           
                    parent.openTab(rec2, '/accnt/agj200ukr.do', params);
                }
            }
        }                       
    });
    
    Unilite.Main({
	 	border: false,
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				{
					region : 'west',
					xtype : 'container',
					flex: 1.5,
					layout : {type: 'vbox', align: 'stretch'},
					items : [ /*blankForm, */masterGrid,  masterGrid2]
				},{
					region : 'center',
					xtype : 'container',
					layout : {type: 'vbox', align: 'stretch'},
					items : [ panelResult, masterGrid3 ]
				}/*,panelResult*/
			]
		}], 
		id : 'w_bsa000skrv_ypApp',
		fnInitBinding : function() {
//			activeSForm = panelResult;
//			activeSForm.onLoadSelectText('FR_DATE');
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			UniAppManager.app.onQueryButtonDown();
//			panelResult.setValue('FR_DATE',UniDate.get('startOfMonth'));
//			panelResult.setValue('FR_DATE',UniDate.get('startOfMonth'));
//			panelResult.setValue('TO_DATE',UniDate.get('today'));
//			panelResult.setValue('TO_DATE',UniDate.get('today'));
			
		},
		onQueryButtonDown : function()	{		
//			if(!panelResult.setAllFieldsReadOnly(true)){
//                return false;
//            }
			directMasterStore.loadStoreRecords();
			directMasterStore2.loadStoreRecords();
			directMasterStore3.loadStoreRecords();
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		}
	});
};


</script>
