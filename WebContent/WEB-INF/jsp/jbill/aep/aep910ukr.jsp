<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="aep910ukr"  >
    <t:ExtComboStore comboType="AU" comboCode="J647" />         <!-- 유형 -->

</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

function appMain() {    
	var mail_receve_url = '${mail_receve_url}'; //Email전송 receve확인 여부 호출 url
	var directMasterProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read: 'aep910ukrService.selectMasterList'
        }
    });    
    
	var directDetailProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
        	create: 'aep900ukrService.insertList',
            read: 'aep910ukrService.selectDetailList',
            syncAll: 'aep900ukrService.saveAll'
        }
    });
   /**
    *   Model 정의 
    * @type 
    */        
	Unilite.defineModel('aep910ukrMasterModel', {
		fields: [ 
		    {name: 'COMP_CODE'                        , text: 'COMP_CODE'   , type: 'string'},
            {name: 'SEND_DATE'                        , text: '발송일'        , type: 'uniDate'},
            {name: 'SEND_TIME'                        , text: '발송시간'       , type: 'string'},
            {name: 'TOTAL'                            , text: '총발송건수'      , type: 'int'},
            {name: 'RECV'                             , text: '수신확인'       , type: 'int'},
            {name: 'SEND'                             , text: '발송완료'       , type: 'int'},
            {name: 'WAIT'                             , text: '발송대기'       , type: 'int'},
            {name: 'ERR'                              , text: '오류'          , type: 'int'},
            {name: 'INSERT_DB_TIME'                   , text: 'INSERT_DB_TIME' , type: 'int'}
		]
	});
	
	Unilite.defineModel('aep910ukrDetailModel', {
        fields: [ 
            {name: 'COMP_CODE'	                      , text: 'COMP_CODE'  , type: 'string'},
            {name: 'SEND_DATE'                        , text: '발송일'       , type: 'uniDate'},
            {name: 'SEND_TIME'                        , text: '발송시간'      , type: 'string'},
            {name: 'PERSON_NAME'                      , text: '사원명'        , type: 'string'},
            {name: 'POSITION_NAME'                    , text: '직위'        , type: 'string'},
            {name: 'EMAIL'                            , text: '이메일'       , type: 'string'},
            {name: 'CARD_CNT'		                  , text: '법인카드'     , type: 'int'},
            {name: 'TAX_CNT'		                  , text: '세금계산서'    , type: 'int'},
            {name: 'APPR_ING'		                  , text: '실물증빙'     , type: 'int'},
            {name: 'APPR_RETURN'		              , text: '원천세'      , type: 'int'},
            {name: 'STATUS'		                      , text: '전자결재'     , type: 'int'},
            {name: 'MAIL_RECV_URL'                    , text: 'MAIL_RECV_URL' , type: 'string', defaultValue: mail_receve_url}
//            {name: 'EMAIL_STATUS'	                  , text: '이메일상태'    , type: 'string'},
//            {name: 'USE_FR_DATE'	                  , text: '발송일자(FR)' , type: 'string'},
//            {name: 'USE_TO_DATE'	                  , text: '발송일자(TO)' , type: 'string'}
        ]
    });
   
    /**
    * Store 정의(Service 정의)
    * @type 
    */               
    var directMasterStore = Unilite.createStore('aep910ukrMasterStore',{
        model: 'aep910ukrMasterModel',
        uniOpt : {
            isMaster: true,         // 상위 버튼 연결 
            editable: false,         // 수정 모드 사용 
            deletable:false,         // 삭제 가능 여부 
            useNavi : false         // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directMasterProxy,
        loadStoreRecords : function()   {
            var param= panelSearch.getValues();          
            console.log( param );
            this.load({
                params : param
            });
        }
   });
   /**
    * Store 정의(Service 정의)
    * @type 
    */               
    var directDetailStore = Unilite.createStore('aep910ukrDetailStore',{
        model: 'aep910ukrDetailModel',
        uniOpt : {
            isMaster: true,         // 상위 버튼 연결 
            editable: false,         // 수정 모드 사용 
            deletable:false,         // 삭제 가능 여부 
            useNavi : false         // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directDetailProxy,
        loadStoreRecords : function(record)	{
        	var param= record.data;			
        	param.SEND_DATE = UniDate.getDbDateStr(param.SEND_DATE);
        	console.log( param );
        	this.load({
        		params : param
        	});
        },
        saveStore : function()  {
            var saveRecord = detailGrid.getSelectedRecords();
            var sCnt = 0;
            var fCnt = 0;
            Ext.each(saveRecord, function(rec, i){
                if(!Ext.isEmpty(rec.get('EMAIL'))){ //이메일 존재 레코드
                   sCnt++;
                   rec.phantom = true;
                }else{
                   fCnt++;
                }                
            });
            if(confirm('발송가능: ' + sCnt + '건' + ' / 발송불가능: ' +  fCnt + '건' + '\n발송 하시겠습니까?')){
                var inValidRecs = this.getInvalidRecords();
                if(inValidRecs.length == 0 )    {
                    var config = {
                        params:[panelSearch.getValues()],
                        success : function()    {
                            alert('처리되었습니다. 결과는 메일발송현황 화면에서 확인하세요.');
                        }
                    }
                    this.syncAllDirect(config);         
                }else {
                    masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
                }
            }            
        }
   });
   /* 검색조건 (Search Panel)
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
                fieldLabel: '발송일자',
                xtype: 'uniDateRangefield',
                startFieldName: 'SEND_FR_DATE',
                endFieldName: 'SEND_TO_DATE',
                startDate: UniDate.get('startOfMonth'),
                endDate: UniDate.get('today'),
                width: 370,                 
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelResult) {
                        panelResult.setValue('SEND_FR_DATE', newValue);                      
                    }
                },
                onEndDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelResult) {
                        panelResult.setValue('SEND_TO_DATE', newValue);                          
                    }
                }
            },{
                fieldLabel: '발송자',
                xtype: 'uniTextfield',
                name: 'FROM_NAME',
                allowBlank: false,
                hidden: true,
                width: 180
            },{
                fieldLabel: '발송자 이메일',
                xtype: 'uniTextfield',
                name: 'FROM_EMAIL',
                allowBlank: false,
                hidden: true,
                width: 280
            },{
                padding: '0 0 8 0',
                name: 'EMAIL_REMARK',
                xtype:'textarea',
                width:700,
                hidden: true,
                height:200
           }]
        }],
        api: {
            load: 'aep900ukrService.selectMaster'
        }
    });
    
	var panelResult = Unilite.createSearchForm('panelResultForm', {
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 2},
		padding:'1 1 1 1',
		border:true,
    	items: [{
            fieldLabel: '발송일자',
            xtype: 'uniDateRangefield',
            startFieldName: 'SEND_FR_DATE',
            endFieldName: 'SEND_TO_DATE',
            startDate: UniDate.get('startOfMonth'),
            endDate: UniDate.get('today'),
            width: 370,                 
            onStartDateChange: function(field, newValue, oldValue, eOpts) {
                if(panelSearch) {
                    panelSearch.setValue('SEND_FR_DATE', newValue);                      
                }
            },
            onEndDateChange: function(field, newValue, oldValue, eOpts) {
                if(panelSearch) {
                    panelSearch.setValue('SEND_TO_DATE', newValue);                          
                }
            }
        }]
    });
    
//    var searchForm = Unilite.createSearchForm('searchForm',{
//        layout : {type : 'uniTable', columns : 3, tableAttrs: {width: '99.8%'}},
//        padding:'1 1 0 1',
//        border:true,
//        items: [{
//           xtype: 'button',
//           text: '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;발송&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;',
//           margin: '0 0 2 0',
//           tdAttrs: {align: 'right', width: 115},
//           handler: function(){
//               directDetailStore.saveStore();
//           }               
//       }]
//    });
    var masterGrid = Unilite.createGrid('aep910ukrGrid1', {
        region: 'center',
        layout: 'fit',
        uniOpt: {
            useGroupSummary: false,
            useLiveSearch: true,
            useContextMenu: false,
            useMultipleSorting: true,
            useRowNumberer: false,
            expandLastColumn: false,
            useRowContext: true,
            state: {
                useState: true,         
                useStateList: true      
            }
        },
        selModel : 'rowmodel',
        features: [{
            id: 'detailGridSubTotal',
            ftype: 'uniGroupingsummary',
            showSummaryRow: false                       
        },{
            id: 'detailGridTotal',
            ftype: 'uniSummary',
            showSummaryRow: false
        }],
        store: directMasterStore,
        columns: [
//            {dataIndex: 'COMP_CODE'                        ,           width: 100},
            {dataIndex: 'SEND_DATE'                        ,           width: 100},
            {dataIndex: 'SEND_TIME'                        ,           width: 100, align: 'center'},
            {dataIndex: 'TOTAL'                            ,           width: 120},
            {dataIndex: 'RECV'                             ,           width: 120},
            {dataIndex: 'SEND'                             ,           width: 120},
            {dataIndex: 'WAIT'                             ,           width: 120},
            {dataIndex: 'ERR'                              ,           width: 120}
        ],        
        listeners: {
            selectionchange:function( model1, selected, eOpts ){
                if(selected.length > 0) {
                	var record = masterGrid.getSelectedRecord();
                	directDetailStore.loadStoreRecords(record);
                }
            }
       }
    });
    
	var detailGrid = Unilite.createGrid('aep910ukrGrid2', {
        region: 'south',
        layout: 'fit',
    	uniOpt: {
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: false,
			useMultipleSorting: true,
			onLoadSelectFirst: false,
			useRowNumberer: false,
			expandLastColumn: false,
			useRowContext: true,
    		state: {
				useState: true,			
				useStateList: true		
			}
        },
        tbar: [{
//            id:'nationButton',
//            iconCls : 'icon-referance'  ,
            text:'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;발송&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;',
            handler: function() {
            	directDetailStore.saveStore();
            }
        }],
		features: [{
			id: 'detailGridSubTotal',
			ftype: 'uniGroupingsummary',
			showSummaryRow: false						
		},{
			id: 'detailGridTotal',
			ftype: 'uniSummary',
			showSummaryRow: false
		}],
		store: directDetailStore,
		selModel: Ext.create('Ext.selection.CheckboxModel', {checkOnly: true,
			listeners: {  
				select: function(grid, selectRecord, index, rowIndex, eOpts ){	

				},
				deselect:  function(grid, selectRecord, index, eOpts ){
				}
        	}
        }),
        columns: [
//            {dataIndex: 'COMP_CODE'	                        ,           width: 100},
            {dataIndex: 'SEND_DATE'                             ,           width: 100},
            {dataIndex: 'SEND_TIME'                             ,           width: 100, align: 'center'},
            {dataIndex: 'PERSON_NAME'                           ,           width: 100},
            {dataIndex: 'POSITION_NAME'                         ,           width: 100},
            {dataIndex: 'EMAIL'                                 ,           width: 200},
            {dataIndex: 'CARD_CNT'		                        ,           width: 120},
            {dataIndex: 'TAX_CNT'		                        ,           width: 120},
            {dataIndex: 'APPR_ING'		                        ,           width: 120},
            {dataIndex: 'APPR_RETURN'		                    ,           width: 120},
            {dataIndex: 'STATUS'		                        ,           width: 120}
//            {dataIndex: 'USE_FR_DATE'	                        ,           width: 100},
//            {dataIndex: 'USE_TO_DATE'	                        ,           width: 100}
        ],
        listeners: {
        	beforeedit: function(editor, e){      		
        	} 
    	}
    });
   
   
    Unilite.Main( {
        borderItems:[{
               region: 'center',
               xtype: 'container',
               layout: {type: 'vbox', align: 'stretch'},
               items: [ panelResult, masterGrid, 
                   {
                        xtype: 'container',
                        layout:{type:'vbox', align:'stretch'},
                        region:'south',
                        flex: 1,
                        items:[
                            detailGrid
                        ]
                   }
               ]
            }, 
            panelSearch
        ], 
    id  : 'aep910ukrApp',
    fnInitBinding : function() {
        UniAppManager.setToolbarButtons('reset',true);
        UniAppManager.setToolbarButtons(['newData', 'save', 'delete', 'reset'], false);        
		if(!UserInfo.appOption.collapseLeftSearch)    {
            activeSForm = panelSearch;
        }else {
            activeSForm = panelResult;
        }
        activeSForm.onLoadSelectText('SEND_FR_DATE');
		var param = {PERSON_NUMB: UserInfo.personNumb}
        panelSearch.getForm().load({
            params: param,
            success:function(form, action)  {
            },
            failure: function(form, action) {
            }
        });
        panelSearch.setValue('FROM_NAME', UserInfo.userName);
    },
    onQueryButtonDown : function()   {
    	if(!panelResult.getInvalidMessage()) return;   //필수체크        	
    	directMasterStore.loadStoreRecords();
    }
		/*onNewDataButtonDown : function() {			
			var r = {
				JOIN_DATE: UniDate.get('today')	
			};
			detailGrid.createRow(r, '');
		},*/
//		onSaveDataButtonDown : function() {
//			directDetailStore.saveStore();
//		},
		/*onDeleteDataButtonDown : function()	{
			var selRow = detailGrid.getSelectedRecord();
			if(selRow.phantom === true)	{
				detailGrid.deleteSelectedRow();
			}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				detailGrid.deleteSelectedRow();
			}
		},*/
//		onResetButtonDown : function() {			
//			panelResult.clearForm();
//			detailGrid.reset();
//			directDetailStore.clearData();
//			this.fnInitBinding();
//		}
   });
};
</script>