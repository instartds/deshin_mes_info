<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="aep900ukr"  >
    <t:ExtComboStore comboType="AU" comboCode="J647" />         <!-- 유형 -->

</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

function appMain() {
    var mail_receve_url = '${mail_receve_url}'; //Email전송 receve확인 여부 호출 url
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            create: 'aep900ukrService.insertList',
            read: 'aep900ukrService.selectList',
            syncAll: 'aep900ukrService.saveAll'
        }
    }); 
   /**
    *   Model 정의 
    * @type 
    */        
	Unilite.defineModel('aep900ukrModel', {
		fields: [ 
		    {name: 'COMP_CODE'                   , text: '법인'        , type: 'string'},
            {name: 'SEND_DATE'                   , text: '발송일'       , type: 'string'},
            {name: 'SEND_TIME'                   , text: '발송시간'     , type: 'string'},
            {name: 'PERSON_NUMB'                 , text: '사번'        , type: 'string'},
            {name: 'PERSON_NAME'                 , text: '사원명'       , type: 'string'},
            {name: 'POSITION_NAME'               , text: '직위'        , type: 'string'},
            {name: 'EMAIL'                       , text: '이메일'       , type: 'string'},
            {name: 'CARD_CNT'                    , text: '법인카드'      , type: 'int'},
            {name: 'TAX_CNT'                     , text: '세금계산서'    , type: 'int'},
            {name: 'APPR_ING'                    , text: '결재중'       , type: 'int'},
            {name: 'APPR_RETURN'                 , text: '반려,삭제,회수' , type: 'int'},            
//            {name: 'A030_CNT'                    , text: '실물증빙'       , type: 'int'},
//            {name: 'A040_CNT'                    , text: '원천세'         , type: 'int'},
//            {name: 'APPR_CNT'                    , text: '전자결재'       , type: 'int'},
            {name: 'EMAIL_STATUS'                , text: '이메일상태'    , type: 'string'},
            {name: 'USE_FR_DATE'                 , text: '사용일자(FR)' , type: 'string'},
            {name: 'USE_TO_DATE'                 , text: '사용일자(TO)' , type: 'string'},
            {name: 'MAIL_RECV_URL'               , text: 'MAIL_RECV_URL' , type: 'string', defaultValue: mail_receve_url}
		]
	});
	
   /**
    * Store 정의(Service 정의)
    * @type 
    */               
    var directDetailStore = Unilite.createStore('aep900ukrDetailStore',{
        model: 'aep900ukrModel',
        uniOpt : {
            isMaster: true,         // 상위 버튼 연결 
            editable: false,         // 수정 모드 사용 
            deletable:false,         // 삭제 가능 여부 
            useNavi : false         // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy,
        loadStoreRecords : function()	{
        	var param= searchForm.getValues();			
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
                        params:[panelResult.getValues()],
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
    
	var panelResult = Unilite.createSearchForm('panelResultForm', {
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 2},
		padding:'1 1 1 1',
		border:true,
    	items: [{
    	   xtype: 'container',
    	   layout: {type: 'uniTable', columns: 2},
    	   colspan: 2,
    	   items:[{
    	   	    fieldLabel: '발송자',
                xtype: 'uniTextfield',
                name: 'FROM_NAME',
                allowBlank: false,
                width: 180
            },{
            	fieldLabel: '발송자 이메일',
                xtype: 'uniTextfield',
                name: 'FROM_EMAIL',
                allowBlank: false,
                width: 280
            }]    	
    	},{
           xtype: 'component',
           width: 20
       },{
    	   xtype: 'uniFieldset',    	   
    	   margin: '10 0 20 0',
    	   title: '메세지',
    	   items:[{
    	       xtype: 'button',
    	       text: '저장',
    	       id: 'saveBtn',
    	       width: 80,
    	       margin: '0 0 3 620',
    	       tdAttrs: {align: 'right'},
    	       handler: function(){
    	       	    var param = panelResult.getValues();
                    panelResult.getEl().mask('로딩중...','loading-indicator');
                    aep900ukrService.insertMaster(param, function(provider, response)  {
                        if(provider){
                            UniAppManager.updateStatus(Msg.sMB011);
                            Ext.getCmp('saveBtn').setDisabled(true);
                        }
                        panelResult.getEl().unmask();                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
                    });
    	       }
    	   },{
    	   	    padding: '0 0 8 0',
                name: 'EMAIL_REMARK',
                xtype:'textarea',
                width:700,
                height:200,
                listeners: {
                    change: function(){
                        Ext.getCmp('saveBtn').setDisabled(false);
                    }
                }
           }]
    	}],
    	api: {
            load: 'aep900ukrService.selectMaster'
        }
    });
    
    var searchForm = Unilite.createSearchForm('searchForm',{
        layout : {type : 'uniTable', columns : 3},
        padding:'1 1 0 1',
        border:true,
        items: [{
            fieldLabel: '사용일자',
            xtype: 'uniDateRangefield',
            startFieldName: 'USE_FR_DATE',
            endFieldName: 'USE_TO_DATE',
            startDate: UniDate.get('startOfMonth'),
            endDate: UniDate.get('today'),
            width: 370
        },{
           xtype: 'button',
           text: '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;검색&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;',
           handler: function(){
               UniAppManager.app.onQueryButtonDown();
           }               
       },{
           xtype: 'button',
           text: '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;발송&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;',
           margin: '0 0 0 5',
           handler: function(){
           	   if(!panelResult.getInvalidMessage()) return;
               directDetailStore.saveStore();
           }               
       }]
    });
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
	var detailGrid = Unilite.createGrid('aep900ukrGrid', {
        region: 'center',
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
//        	{dataIndex: 'COMP_CODE'                   ,           width: 100},
//            {dataIndex: 'SEND_DATE'                   ,           width: 100},
//            {dataIndex: 'SEND_TIME'                   ,           width: 100},
//            {dataIndex: 'PERSON_NUMB'                 ,           width: 100},
            {dataIndex: 'PERSON_NAME'                 ,           width: 100},
            {dataIndex: 'POSITION_NAME'               ,           width: 100},
            {dataIndex: 'EMAIL'                       ,           width: 200},
            {dataIndex: 'CARD_CNT'                    ,           width: 120},
            {dataIndex: 'TAX_CNT'                     ,           width: 120},
            {
                text: '그룹웨어 결재',
                columns:[
                    {dataIndex: 'APPR_ING'                ,           width: 120},
                    {dataIndex: 'APPR_RETURN'             ,           width: 120}    
                ]
            }
//            {dataIndex: 'A030_CNT'                    ,           width: 120},
//            {dataIndex: 'A040_CNT'                    ,           width: 120},
//            {dataIndex: 'APPR_CNT'                    ,           width: 120}
//            {dataIndex: 'EMAIL_STATUS'                ,           width: 100},
//            {dataIndex: 'USE_FR_DATE'                 ,           width: 100},
//            {dataIndex: 'USE_TO_DATE'                 ,           width: 100}
            
//            {dataIndex: 'MAIL_RECV_URL'                 ,           width: 100}
        ],
        listeners: {
        	beforeedit: function(editor, e){      		
        		
        	} 
    	}
    });
   
   
    Unilite.Main( {
        borderItems:[{
            region:'center',
            layout: 'border',
            border: false,
            items:[{
               region: 'center',
               xtype: 'container',
               layout: {type: 'vbox', align: 'stretch'},
               items: [
                   searchForm, detailGrid
               ]
            }, 
                panelResult
	     	]
        }
        ], 
    id  : 'aep900ukrApp',
    fnInitBinding : function() {
        UniAppManager.setToolbarButtons('reset',true);
        UniAppManager.setToolbarButtons(['newData', 'save', 'delete', 'query', 'reset'], false);        
		panelResult.onLoadSelectText('EMAIL_REMARK');
		var param = {PERSON_NUMB: UserInfo.personNumb}
		panelResult.getForm().load({
            params: param,
            success:function(form, action)  {
                Ext.getCmp('saveBtn').setDisabled(true); 
            },
            failure: function(form, action) {
            }
        });
        panelResult.setValue('FROM_NAME', UserInfo.userName);			
        },
        onQueryButtonDown : function()   {
//        	if(!panelResult.getInvalidMessage()) return;   //필수체크        	
        	directDetailStore.loadStoreRecords();
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