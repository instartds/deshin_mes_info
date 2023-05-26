<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="equ201ukrv"  >
    <t:ExtComboStore comboType="BOR120"  pgmId="equ201ukrv"  />             <!-- 사업장 -->
    <t:ExtComboStore comboType="AU" comboCode="WB04" />             <!-- 차종  -->
    <t:ExtComboStore comboType="AU" comboCode="WZ33" />             <!-- 거래처  -->
    <t:ExtComboStore comboType="AU" comboCode="B020" /> 			<!-- 품목계정 -->
</t:appConfig>
<script type="text/javascript" charset="UTF-8" src='<c:url value="/resources/plupload/plupload.full.js" />' >
</script>
<style type="text/css">

.x-change-cell {
background-color: #fed9fe;
}
</style>

<script type="text/javascript" >

var equWindow; // 금형등록팝업
var coreWindow; // 코어등록팝업
var activeGridId = 'dummyGrid';
var uploadWin;				//업로드 윈도우
var photoWin;			// 이미지 보여줄 윈도우
var gsNeedPhotoSave	= false;

function appMain() {

	var directProxyMaster = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read: 'equ201ukrvService.selectMaster',
            create: 'equ201ukrvService.insertMaster',
            update: 'equ201ukrvService.updateMaster',
            destroy: 'equ201ukrvService.deleteMaster',
            syncAll: 'equ201ukrvService.saveAllMaster'
        }
    });

    var directProxySub = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read: 'equ201ukrvService.selectSub',
            create: 'equ201ukrvService.insertSub',
            update: 'equ201ukrvService.updateSub',
            destroy: 'equ201ukrvService.deleteSub',
            syncAll: 'equ201ukrvService.saveAllSub'
        }
    });

    Unilite.defineModel('statusModel', {
        fields: [
            {name: 'GUBUN'            ,text:'조건'        ,type: 'string'},
            {name: 'EQU_TYPE'             ,text:'몰드타입'         ,type: 'string',comboType:'AU', comboCode:'I802'},
            {name: 'CORE_TYPE'             ,text:'게이트방식'        ,type: 'string', comboType:'AU', comboCode:'I806'}
        ]
    });

    Unilite.defineModel('mainModel', {
        fields: [
            {name: 'COMP_CODE'            ,text:'법인코드'        ,type: 'string',allowBlank:false},
            {name: 'DIV_CODE'             ,text:'사업장'         ,type: 'string',allowBlank:false},
            {name: 'EQU_CODE'             ,text:'금형번호'        ,type: 'string'},
            {name: 'EQU_NAME'             ,text:'금형명'        ,type: 'string'},
            {name: 'PRODT_TYPE'           ,text:'부품타입'        ,type: 'string', comboType:'AU', comboCode:'I808'},
            {name: 'MODEL_CODE'           ,text:'모델'        ,type: 'string'},
            {name: 'EQU_TYPE'             ,text:'몰드타입'        ,type: 'string', comboType:'AU', comboCode:'I802'},
            {name: 'EQU_SIZE'             ,text:'몰드치수'        ,type: 'string'},
            {name: 'LOCATION'             ,text:'금형위치'        ,type: 'string', comboType:'AU', comboCode:'I806'},
            {name: 'CUSTOM_NAME'          ,text:'제작처'        ,type: 'string'},
            {name: 'USE_YN'             	,text:'사용여부'        ,type: 'string', comboType:'AU', comboCode:'A004'},
//            {name: 'LINK'             		,text:'수리이력'        ,type: 'string'},

            {name: 'EQU_CODE_1'             ,text:'금형코드'        ,type: 'string',allowBlank:false},
            {name: 'EQU_CODE_2'             ,text:'금형코드'        ,type: 'string',allowBlank:false},
            {name: 'EQU_GRADE'          	,text:'금형상태'        ,type: 'string', comboType:'AU', comboCode:'I801'},
            {name: 'EQU_SIZE_W'             ,text:'몰드치수가로'        ,type: 'string'},
            {name: 'EQU_SIZE_L'             ,text:'몰드치수세로'        ,type: 'string'},
            {name: 'EQU_SIZE_H'             ,text:'몰드치수높이'        ,type: 'string'},
            {name: 'CUSTOM_CODE'            ,text:'제작처'        ,type: 'string'},
            {name: 'PRODT_DATE'             ,text:'제작일'        ,type: 'uniDate'},
            {name: 'PRODT_O'             	,text:'제작금액'        ,type: 'string'},
            {name: 'ASSETS_NO'              ,text:'자산번호'        ,type: 'string'},
            {name: 'MT_DEPR'             	,text:'상각방법'        ,type: 'string'},
            {name: 'WORK_Q'             	,text:'사용SHOT'        ,type: 'string'},
            {name: 'USE_CUSTOM_CODE'        ,text:'보관처'        ,type: 'string'},
            {name: 'USE_CUSTOM_NAME'        ,text:'보관처'        ,type: 'string'},

            {name: 'COMP_OWN'             	,text:'소유처'        ,type: 'string'},
            {name: 'COMP_OWN_NAME'          ,text:'소유처'        ,type: 'string'},

            {name: 'ABOL_DATE'              ,text:'폐기일자'        ,type: 'uniDate'},
            {name: 'DISP_REASON'           	,text:'폐기사유'        ,type: 'string'},
            {name: 'REMARK'             	,text:'비고'        ,type: 'string'}

        ]
    });


    Unilite.defineModel('subModel', {
        fields: [
            {name: 'COMP_CODE'            ,text:'법인코드'        ,type: 'string',allowBlank:false},
            {name: 'DIV_CODE'             ,text:'사업장'         ,type: 'string',allowBlank:false},
            {name: 'EQU_CODE'             ,text:'금형번호'        ,type: 'string',allowBlank:false},
            {name: 'CORE_CODE'            ,text:'코어번호'        ,type: 'string',allowBlank:false},
            {name: 'MODEL_CODE'           ,text:'모델코드'        ,type: 'string'},
            {name: 'CORE_NAME'            ,text:'품명'           ,type: 'string'},
            {name: 'CORE_SPEC'            ,text:'규격'           ,type: 'string'},
            {name: 'PRODT_TYPE'           ,text:'부품타입'        ,type: 'string', comboType:'AU', comboCode:'I808'},
            {name: 'CORE_TYPE'            ,text:'게이트방식'       ,type: 'string', comboType:'AU', comboCode:'I806'},
            {name: 'CORE_FORM'            ,text:'코아형상'        ,type: 'string', comboType:'AU', comboCode:'I810'},
            {name: 'CORE_SIZE'            ,text:'코어치수'        ,type: 'string'},
            {name: 'CAVITY_Q'             ,text:'캐비티수'        ,type: 'string'},
            {name: 'PRODT_MTRL'           ,text:'원료'           ,type: 'string'},
//            {name: 'LINK'           	  ,text:'수리이력 '        ,type: 'string'},
            {name: 'CORE_STATUS'          ,text:'코어상태'        ,type: 'string', comboType:'AU', comboCode:'I801'},
            {name: 'CORE_MTRL'            ,text:'코어재질'        ,type: 'string', comboType:'AU', comboCode:'I807'},
            {name: 'CORE_SIZE_W'          ,text:'코어치수가로'        ,type: 'string'},
            {name: 'CORE_SIZE_L'          ,text:'코어치수세로'        ,type: 'string'},
            {name: 'CORE_SIZE_H'          ,text:'코어치수높이'        ,type: 'string'},
            {name: 'CORE_SIZE_P'          ,text:'코어치수직경'        ,type: 'string'},
            {name: 'PRODT_WEIGHT'         ,text:'부품중량'        ,type: 'string'},
            {name: 'RUNNER_WEIGHT'        ,text:'런너중량'        ,type: 'string'},
            {name: 'PRODT_SIZE_W'         ,text:'제품치수가로'        ,type: 'string'},
            {name: 'PRODT_SIZE_L'         ,text:'제품치수세로'        ,type: 'string'},
            {name: 'PRODT_SIZE_H'         ,text:'제품치수높이'        ,type: 'string'},
            {name: 'PRODT_SIZE_P'         ,text:'제품치수직경'        ,type: 'string'},
            {name: 'CORE_METHOD'          ,text:'슬라이드유무'        ,type: 'string', comboType:'AU', comboCode:'I809'},
            {name: 'WORK_Q'           	  ,text:'사용SHOT'        ,type: 'string'},
            {name: 'CYCLE_TIME'           ,text:'가공시간'        ,type: 'string'},
            {name: 'CAPA_Q'           	  ,text:'한도SHOT'        ,type: 'string'},
            {name: 'CORE_LOCATION'        ,text:'보관위치'        ,type: 'string'},
            {name: 'PRODT_O'           	  ,text:'제작금액'        ,type: 'string'},
            {name: 'TOTAL_Q'           	  ,text:'누적SHOT'        ,type: 'string'},
            {name: 'PRODT_CUSTOM'         ,text:'제작처'        ,type: 'string'},
            {name: 'PRODT_CUSTOM_NAME'    ,text:'제작처'        ,type: 'string'},
            {name: 'PRODT_DATE'           ,text:'제작일'        ,type: 'uniDate'},
            {name: 'AUDIT_Q'           	  ,text:'점검SHOT'        ,type: 'string'},
            {name: 'USE_CUSTOM_CODE'      ,text:'보관처'        ,type: 'string'},
            {name: 'USE_CUSTOM_NAME'      ,text:'보관처'        ,type: 'string'},
            {name: 'COMP_OWN'             ,text:'소유처'        ,type: 'string'},
            {name: 'COMP_OWN_NAME'        ,text:'소유처'        ,type: 'string'},
            {name: 'MAX_Q'           	  ,text:'최대SHOT'        ,type: 'string'},
            {name: 'ABOL_DATE'            ,text:'폐기일'        ,type: 'uniDate'},
            {name: 'ABOL_REASON'          ,text:'폐기사유'        ,type: 'string'},
            {name: 'USE_YN'           	  ,text:'사용여부'        ,type: 'string'},
            {name: 'ASSETS_NO'            ,text:'자산번호'        ,type: 'string'},
            {name: 'REMARK'           	  ,text:'비고'        ,type: 'string'}

        ]
    });

    var statusStore = Unilite.createStore('statusStore', {
        model: 'statusModel',
        uniOpt : {
            isMaster:  false,            // 상위 버튼 연결
            editable:  true,            // 수정 모드 사용
            deletable: false,           // 삭제 가능 여부
            useNavi :  false            // prev | newxt 버튼 사용
        },
        autoLoad: false
    });

    var masterStore = Unilite.createStore('masterStore',{
        model: 'mainModel',
        uniOpt : {
            isMaster:  true,            // 상위 버튼 연결
            editable:  false,            // 수정 모드 사용
            deletable: true,           // 삭제 가능 여부
            useNavi :  false            // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directProxyMaster,
        loadStoreRecords : function()   {
            var param= panelResult.getValues();
            this.load({
                  params : param
            });
        },
        saveStore: function(/*index*/) {
            var inValidRecs = this.getInvalidRecords();
            var paramMaster= panelResult.getValues();    //syncAll 수정
            if(inValidRecs.length == 0 )    {
                var config = {
                    params: [paramMaster],
                    success: function(batch, option) {
                 //		masterStore.loadStoreRecords(); 저장후 재조회시 현재 저장한 데이터 다시 찾아야하는 이유로 제거
                  /*
                        if(subStore.getCount() == 0){
                            UniAppManager.app.onResetButtonDown();
                            return false;
                        }
                        var master = batch.operations[0].getResultSet();
                        var fp = inputTable.down('xuploadpanel');                  //mask on
                        fp.loadData({});
                        fp.getEl().mask('로딩중...','loading-indicator');
                        equ201ukrvService.getFileList({ITEM_CODE : master.ITEM_CODE},              //파일조회 메서드  호출(param - 파일번호)
                            function(provider, response) {
                                fp.loadData(response.result);                       //업로드 파일 load해서 보여주기
                                fp.getEl().unmask();                                //mask off
                            }
                         );
                        UniAppManager.setToolbarButtons('save', false);
                        UniAppManager.setToolbarButtons('newData', false);

                        if(index){
                            subGrid.getSelectionModel().select(index);
                        }*/
                     }
                };
                this.syncAllDirect(config);
            }else {
                masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
            }
        },
		listeners:{
			load:function(store, records, successful, eOpts)	{
				/*if(Ext.isEmpty(records)){
        			inputTable.down('xuploadpanel').loadData({});
        			inputTable.disable();
				}*/
			}
		}
    });


    var subStore = Unilite.createStore('subStore',{
        model: 'subModel',
        uniOpt : {
            isMaster:  true,            // 상위 버튼 연결
            editable:  false,            // 수정 모드 사용
            deletable: true,           // 삭제 가능 여부
            useNavi :  false            // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directProxySub,
        loadStoreRecords : function(param)   {
//            var param= panelResult.getValues();
            /*
            var param = {
				'DIV_CODE' : record.get('DIV_CODE'),
				'EQU_CODE' : record.get('EQU_CODE')
			};*/
            this.load({
                  params : param
            });
        },
        saveStore: function(index) {
            var inValidRecs = this.getInvalidRecords();
            var paramMaster= panelResult.getValues();    //syncAll 수정
            if(inValidRecs.length == 0 )    {
                var config = {
                    params: [paramMaster],
                    success: function(batch, option) {

						var record = masterGrid.getSelectedRecord();
						var param = {
							DIV_CODE : record.get('DIV_CODE'),
							EQU_CODE : record.get('EQU_CODE')
						};
                 		subStore.loadStoreRecords(param);



    /*                    if(subStore.getCount() == 0){
                            UniAppManager.app.onResetButtonDown();
                            return false;
                        }
                        var master = batch.operations[0].getResultSet();
                        var fp = inputTable.down('xuploadpanel');                  //mask on
                        fp.loadData({});
                        fp.getEl().mask('로딩중...','loading-indicator');
                        equ201ukrvService.getFileList({ITEM_CODE : master.ITEM_CODE},              //파일조회 메서드  호출(param - 파일번호)
                            function(provider, response) {
                                fp.loadData(response.result);                       //업로드 파일 load해서 보여주기
                                fp.getEl().unmask();                                //mask off
                            }
                         );
                        UniAppManager.setToolbarButtons('save', false);
                        UniAppManager.setToolbarButtons('newData', false);
                        subStore.loadStoreRecords();
                        if(index){
                            subGrid.getSelectionModel().select(index);
                        }*/

                     }



                };
                this.syncAllDirect(config);
            }else {
                subGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
            }
        },
		listeners:{
			load:function(store, records, successful, eOpts)	{
				/*if(Ext.isEmpty(records)){
        			inputTable.down('xuploadpanel').loadData({});
        			inputTable.disable();
				}*/
			}
		}
    });

    var panelResult = Unilite.createSearchForm('resultForm',{
        region: 'north',
        layout : {type : 'uniTable', columns : 5},
        padding:'1 1 1 1',
        border:true,
        items: [{
			fieldLabel: '사업장',
			name: 'DIV_CODE',
			xtype: 'uniCombobox' ,
			allowBlank:false,
			comboType: 'BOR120'
	    },{
        	fieldLabel: '금형번호',
			xtype: 'uniTextfield',
			name:'EQU_CODE'
	    },{
        	fieldLabel: '금형명',
			xtype: 'uniTextfield',
			name:'EQU_NAME'
	    },{
        	fieldLabel: '모델',
			xtype: 'uniTextfield',
			name:'MODEL_CODE'
	    }]
    });

    var statusGrid = Unilite.createGrid('statusGrid', {
        layout: 'fit',
        region: 'center',
        width:1000,
        height:75,
//        colspan:4,
        uniOpt: {
            userToolbar:false,
            useGroupSummary: false,
            useLiveSearch: true,
            useContextMenu: false,
            useMultipleSorting: true,
            onLoadSelectFirst: true,
            useRowNumberer: false,
            expandLastColumn: false,
            useRowContext: false,
            state: {
                useState: false,
                useStateList: false
            }
        },
        store: statusStore,
        selModel:'rowmodel',
        columns: [
             { dataIndex: 'GUBUN'         ,width:100},
            { dataIndex: 'EQU_TYPE'         ,width:100},
            { dataIndex: 'CORE_TYPE'         ,width:100}
        ],
        listeners: {
            beforeedit  : function( editor, e, eOpts ) {/*

                if(UniUtils.indexOf(e.field, ['SERIAL_NO'])){
                	if(Ext.getCmp('rePrint').getValue().RE_PRINT == '1'){
                	    return true;
                	}else{
                		return false;
                	}
                }


                if(UniUtils.indexOf(e.field, ['COMP_CODE','DIV_CODE','PRODT_NUM','KS_MARK_NAME','CNT'])){
                    return false;
                }
            */}
        }
    });

    var masterGrid = Unilite.createGrid('masterGrid', {
        layout : 'fit',
        region: 'north',
        store: masterStore,
        split:true,
        selModel: 'rowmodel',
        flex:3,
        uniOpt: {
            expandLastColumn: false,
            useMultipleSorting: true,
            useGroupSummary: false,
            useLiveSearch: true,
            useContextMenu: true,
            useRowNumberer: false,
            onLoadSelectFirst: true,
            filter: {
                useFilter: true,
                autoCreate: true
            }
        },
        columns:  [
            { dataIndex: 'COMP_CODE'           , width: 80, hidden: true},
            { dataIndex: 'DIV_CODE'            , width: 80, hidden: true},
            { dataIndex: 'EQU_CODE'               , width: 100},
            { dataIndex: 'EQU_NAME'               , width: 200},
            { dataIndex: 'PRODT_TYPE'             , width: 100},
            { dataIndex: 'MODEL_CODE'             , width: 80, align:'center'},
            { dataIndex: 'EQU_TYPE'               , width: 100},
            { dataIndex: 'EQU_SIZE'               , width: 100},
            { dataIndex: 'LOCATION'               , width: 100},
            { dataIndex: 'CUSTOM_NAME'            , width: 150},
            { dataIndex: 'USE_YN'                 , width: 80, align:'center'},
//            { dataIndex: 'LINK'                   , width: 100},
            {       text: '수리이력',
		            width: 100,
		            xtype: 'widgetcolumn',
		            widget: {
		                xtype: 'button',
		                text: '상세보기',
		                listeners: {
		                	buffer:1,
		                	click: function(button, event, eOpts) {

		                		var selectRecord = event.record.data;

		                		var params = {
									'DIV_CODE': selectRecord.DIV_CODE,
									'EQU_CODE': selectRecord.EQU_CODE,
									'EQU_NAME': selectRecord.EQU_NAME
								}
								var rec = {data : {prgID : 'eqt210skrv', 'text':'장비이력현황조회'}};
								parent.openTab(rec, '/equit/eqt210skrv.do', params);
		                	}
		                }
		            }
		    },

            { dataIndex: 'EQU_CODE_1'              , width: 100, hidden: true},
            { dataIndex: 'EQU_CODE_2'              , width: 100, hidden: true},
            { dataIndex: 'EQU_CODE_TYPE'           , width: 100, hidden: true},
            { dataIndex: 'EQU_SIZE_W'              , width: 100, hidden: true},
            { dataIndex: 'EQU_SIZE_L'              , width: 100, hidden: true},
            { dataIndex: 'EQU_SIZE_H'              , width: 100, hidden: true},
            { dataIndex: 'CUSTOM_CODE'             , width: 100, hidden: true},
            { dataIndex: 'PRODT_DATE'              , width: 100, hidden: true},
            { dataIndex: 'PRODT_O'                 , width: 100, hidden: true},
            { dataIndex: 'ASSETS_NO'               , width: 100, hidden: true},
            { dataIndex: 'MT_DEPR'                 , width: 100, hidden: true},
            { dataIndex: 'WORK_Q'                  , width: 100, hidden: true},
            { dataIndex: 'USE_CUSTOM_CODE'         , width: 100, hidden: true},
            { dataIndex: 'USE_CUSTOM_NAME'         , width: 100, hidden: true},
            { dataIndex: 'COMP_OWN'                , width: 100, hidden: true},
            { dataIndex: 'COMP_OWN_NAME'                , width: 100, hidden: true},
            { dataIndex: 'ABOL_DATE'               , width: 100, hidden: true},
            { dataIndex: 'DISP_REASON'             , width: 100, hidden: true},
            { dataIndex: 'REMARK'                  , width: 100, hidden: true}

        ],
	/*	viewConfig: {
	        getRowClass: function(record, rowIndex, rowParams, store){
	        	var cls = '';
	        	if(record.get('CORE_CODE').substring(record.get('CORE_CODE').length-1) != 0){
					cls = 'x-change-cell';
				}
				return cls;
	        }
	    },*/
        listeners: {
        	beforeedit  : function( editor, e, eOpts ) {
            },

        	beforeselect: function(){
		    	if(subStore.isDirty()){
//		    		Unilite.messageBox('코어정보를 입력중입니다..');
		    		return false;
		    	}
        	},
            selectionchange:function( model1, selected, eOpts ){

	      		if(selected.length > 0) {
					var record = selected[0];

						var param = {
							DIV_CODE : record.get('DIV_CODE'),
							EQU_CODE : record.get('EQU_CODE')
						};


					if(record.phantom == true){
//						equInfoGrid.setDisabled(true);
						subStore.loadData({});
                	}else{
//						equInfoGrid.setDisabled(false);

						subStore.loadStoreRecords(param);
                	}

//					equInfoStore.loadData({});
//					equInfoStore.loadStoreRecords(param);
//
//					imageViewStore1.loadData({});
//					imageViewStore1.loadStoreRecords(param);
//					imageViewStore2.loadData({});
//					imageViewStore2.loadStoreRecords(param);


				}
            },
            onGridDblClick:function(grid, record, cellIndex, colName) {

//				if(!Ext.isEmpty(record.get('EQU_CODE'))) {
				if(record.phantom == false){
	   				 openEquWindow();
	   				 equForm.getField('EQU_CODE_1').setReadOnly(true);
	   				 equForm.getField('EQU_CODE_2').setReadOnly(true);
				}
			},
			cellclick :function(grid, td, cellIndex, record, tr, rowIndex, e, eOpts ) {

                UniAppManager.setToolbarButtons(['delete'], true);
//				if(Ext.isEmpty(record.get('EQU_CODE'))) {
				if(record.phantom == true){
	   				 openEquWindow();
	   				 equForm.getField('EQU_CODE_1').setReadOnly(false);
	   				 equForm.getField('EQU_CODE_2').setReadOnly(false);
				}
			},

			render: function(grid, eOpts){
			 	var girdNm = grid.getItemId();
			    grid.getEl().on('click', function(e, t, eOpt) {
			    	var oldGrid = Ext.getCmp(activeGridId);
			    	if(subStore.isDirty()){
						Unilite.messageBox('코어정보를 입력중입니다..');
			    		return false;
			    	}
			    	grid.changeFocusCls(oldGrid);
			    	activeGridId = girdNm;
//	    			UniAppManager.setToolbarButtons(['newData','delete'],false);
			    });
			 }
        }
    });


    var subGrid = Unilite.createGrid('subGrid', {
        layout : 'fit',
        region: 'center',
        store: subStore,
        split:true,
        selModel: 'rowmodel',
        flex:2,
        uniOpt: {
            expandLastColumn: false,
            useMultipleSorting: true,
            useGroupSummary: false,
            useLiveSearch: true,
            useContextMenu: true,
            useRowNumberer: false,
            onLoadSelectFirst:true,
            filter: {
                useFilter: true,
                autoCreate: true
            }
        },
        columns:  [
            { dataIndex: 'COMP_CODE'                   , width: 100,hidden:true},
            { dataIndex: 'DIV_CODE'                    , width: 100,hidden:true},
            { dataIndex: 'EQU_CODE'                    , width: 100,hidden:true},
            { dataIndex: 'CORE_CODE'                   , width: 100},
            { dataIndex: 'MODEL_CODE'                  , width: 100},
            { dataIndex: 'CORE_NAME'                   , width: 200},
            { dataIndex: 'CORE_SPEC'                   , width: 100},
            { dataIndex: 'PRODT_TYPE'                  , width: 100},
            { dataIndex: 'CORE_TYPE'                   , width: 100},
            { dataIndex: 'CORE_FORM'                   , width: 100},
            { dataIndex: 'CORE_SIZE'                   , width: 100},
            { dataIndex: 'CAVITY_Q'                    , width: 100},
            { dataIndex: 'PRODT_MTRL'                  , width: 100},
//            { dataIndex: 'LINK'           	           , width: 100},
            {       text: '수리이력',
		            width: 100,
		            xtype: 'widgetcolumn',
		            widget: {
		                xtype: 'button',
		                text: '상세보기',
		                listeners: {
		                	buffer:1,
		                	click: function(button, event, eOpts) {

		                		var selectRecord = event.record.data;

		                		var params = {
									'DIV_CODE': selectRecord.DIV_CODE,
									'EQU_CODE': selectRecord.CORE_CODE,
									'EQU_NAME': selectRecord.CORE_NAME
								}
								var rec = {data : {prgID : 'eqt210skrv', 'text':'장비이력현황조회'}};
								parent.openTab(rec, '/equit/eqt210skrv.do', params);
		                	}
		                }
		            }
		    },

            { dataIndex: 'CORE_STATUS'                 , width: 100,hidden:true},
            { dataIndex: 'CORE_MTRL'                   , width: 100,hidden:true},
            { dataIndex: 'CORE_SIZE_W'                 , width: 100,hidden:true},
            { dataIndex: 'CORE_SIZE_L'                 , width: 100,hidden:true},
            { dataIndex: 'CORE_SIZE_H'                 , width: 100,hidden:true},
            { dataIndex: 'CORE_SIZE_P'                 , width: 100,hidden:true},
            { dataIndex: 'PRODT_WEIGHT'                , width: 100,hidden:true},
            { dataIndex: 'RUNNER_WEIGHT'               , width: 100,hidden:true},
            { dataIndex: 'PRODT_SIZE_W'                , width: 100,hidden:true},
            { dataIndex: 'PRODT_SIZE_L'                , width: 100,hidden:true},
            { dataIndex: 'PRODT_SIZE_H'                , width: 100,hidden:true},
            { dataIndex: 'PRODT_SIZE_P'                , width: 100,hidden:true},
            { dataIndex: 'CORE_METHOD'                 , width: 100,hidden:true},
            { dataIndex: 'WORK_Q'                      , width: 100,hidden:true},
            { dataIndex: 'CYCLE_TIME'                  , width: 100,hidden:true},
            { dataIndex: 'CAPA_Q'                      , width: 100,hidden:true},
            { dataIndex: 'CORE_LOCATION'               , width: 100,hidden:true},
            { dataIndex: 'PRODT_O'                     , width: 100,hidden:true},
            { dataIndex: 'TOTAL_Q'                     , width: 100,hidden:true},
            { dataIndex: 'PRODT_CUSTOM'                , width: 100,hidden:true},
            { dataIndex: 'PRODT_CUSTOM_NAME'           , width: 100,hidden:true},
            { dataIndex: 'PRODT_DATE'                  , width: 100,hidden:true},
            { dataIndex: 'AUDIT_Q'                     , width: 100,hidden:true},
            { dataIndex: 'USE_CUSTOM_CODE'             , width: 100,hidden:true},
            { dataIndex: 'USE_CUSTOM_NAME'             , width: 100,hidden:true},
            { dataIndex: 'COMP_OWN'                    , width: 100,hidden:true},
            { dataIndex: 'COMP_OWN_NAME'               , width: 100,hidden:true},
            { dataIndex: 'MAX_Q'           	           , width: 100,hidden:true},
            { dataIndex: 'ABOL_DATE'                   , width: 100,hidden:true},
            { dataIndex: 'ABOL_REASON'                 , width: 100,hidden:true},
            { dataIndex: 'USE_YN'                      , width: 100,hidden:true},
            { dataIndex: 'ASSETS_NO'                   , width: 100,hidden:true},
            { dataIndex: 'REMARK'                      , width: 100,hidden:true}
        ],
	/*	viewConfig: {
	        getRowClass: function(record, rowIndex, rowParams, store){
	        	var cls = '';
	        	if(record.get('CORE_CODE').substring(record.get('CORE_CODE').length-1) != 0){
					cls = 'x-change-cell';
				}
				return cls;
	        }
	    },*/
/*		plugins: {
	        gridfilters: true,
	        gridexporter: true,
	        rowexpander: {
	            // dblclick invokes the row editor
	            expandOnDblClick: false,
	            rowBodyTpl: '<img src="'+ CPATH+'/EquipmentPhoto/{IMAGE_FID}.{IMG_TYPE}" height="100px" '
	            //+'style="float:left;margin:0 10px 5px 0"><b>{name}<br></b>{dob:date}'
	        }
	    },*/
//	    plugins: [{
//	        ptype: 'rowexpander',
//	        rowBodyTpl : new Ext.XTemplate(
//	//        '<img src="'+ CPATH+'/EquipmentPhoto/{IMAGE_FID}.{IMG_TYPE}" height="100px" ',
//	        '<img src="'+ CPATH+'/EquipmentPhoto/MASTER01IN-0001.png" height="100px" ',
//
//	            '<p><b>Company:</b>abc</p>',
//	            '<p><b>Change:</b> ddd</p>',
//	        {
//	            formatChange: function(v){
//	                var color = v >= 0 ? 'green' : 'red';
//	                return '<span style="color: ' + color + ';">' + Ext.util.Format.usMoney(v) + '</span>';
//	            }
//	        })
//	    }],
        listeners: {
        	beforeedit  : function( editor, e, eOpts ) {
            },
            beforeselect : function ( gird, record, index, eOpts ){
		    	if(masterStore.isDirty()){
//		    		Unilite.messageBox('금형정보를 입력중입니다..');
		    		return false;
		    	}
            },
            selectionchange:function( model1, selected, eOpts ){

	      		if(selected.length > 0) {
					var record = selected[0];

					var param = {
						DIV_CODE : record.get('DIV_CODE'),
						EQU_CODE : record.get('CORE_CODE')
					};


					if(record.phantom == true){
						equInfoGrid.setDisabled(true);
                	}else{
						equInfoGrid.setDisabled(false);

                	}

					equInfoStore.loadData({});
					equInfoStore.loadStoreRecords(param);

					imageViewStore1.loadData({});
					imageViewStore1.loadStoreRecords(param);
					imageViewStore2.loadData({});
					imageViewStore2.loadStoreRecords(param);
				}else{
					equInfoStore.loadData({});
					imageViewStore1.loadData({});
					imageViewStore2.loadData({});

					equInfoGrid.setDisabled(true);
				}

            },
            onGridDblClick:function(grid, record, cellIndex, colName) {

//				if(!Ext.isEmpty(record.get('CORE_CODE'))) {
				if(record.phantom == false){
	   				 openCoreWindow();
	   				 coreForm.getField('CORE_CODE').setReadOnly(true);
//	   				 equForm.getField('EQU_CODE_1').setReadOnly(true);
//	   				 equForm.getField('EQU_CODE_2').setReadOnly(true);
				}
			},
			cellclick :function(grid, td, cellIndex, record, tr, rowIndex, e, eOpts ) {

//				if(Ext.isEmpty(record.get('CORE_CODE'))) {
				if(record.phantom == true){
	   				openCoreWindow();
	   				var param= {
						DIV_CODE : record.get("DIV_CODE"),
						EQU_CODE: record.get("EQU_CODE")
					}
					equ201ukrvService.autoCoreCode(param , function(provider, response){
						if(!Ext.isEmpty(provider))	{
							coreForm.setValue('CORE_CODE',provider.CORE_CODE);
						}else{
							coreForm.setValue('CORE_CODE',record.get("EQU_CODE")+ '-0');
						}
					})
	   				 coreForm.getField('CORE_CODE').setReadOnly(false);

//	   				 equForm.getField('EQU_CODE_1').setReadOnly(false);
//	   				 equForm.getField('EQU_CODE_2').setReadOnly(false);
				}
			},

			render: function(grid, eOpts){
			 	var girdNm = grid.getItemId();
			    grid.getEl().on('click', function(e, t, eOpt) {
			    	var oldGrid = Ext.getCmp(activeGridId);
			    	var masterRecord = masterGrid.getSelectedRecord();
			    	if(Ext.isEmpty(masterRecord)){
						Unilite.messageBox('선택된 금형정보가 없습니다.');
			    		return false;
			    	}else if(masterStore.isDirty()){
						Unilite.messageBox('금형정보를 입력중입니다.. 먼저 저장해주세요.');
			    		return false;
			    	}

			    	grid.changeFocusCls(oldGrid);
			    	activeGridId = girdNm;
//	    			UniAppManager.setToolbarButtons(['newData','delete'],false);
			    });
			 }
        }
    });


    var equForm = Unilite.createSearchForm('equForm', {       // 금형 등록팝업
        layout: {type : 'uniTable', columns : 3},
        height:320,
        width: 1110,
		region: 'center',
		autoScroll: false,
		border: true,
		padding: '1 1 1 1',
		layout: {type: 'uniTable', columns: 1, tdAttrs: {valign:'top'}},
		xtype: 'container',
		defaultType: 'container',
        items:[{
			layout: {type: 'uniTable', columns: 1, tableAttrs:{cellpadding:5}, tdAttrs: {valign:'top'}},
			defaultType: 'uniFieldset',
			defaults: { padding: '10 15 15 15'},
			items: [{
				title: '금형 상세정보',
				layout: { type: 'uniTable', columns: 3},
				margin: '10 0 15 15',
				width:1010,
				items: [{
					xtype: 'container',
					layout: { type: 'uniTable', columns: 2},
//					defaults : {enforceMaxLength: true},
					items:[{
						fieldLabel: '금형번호',
						name: 'EQU_CODE_1',
						xtype: 'uniTextfield',
						width: 165,
						listeners: {
							blur: function(field, event, eOpts) {
								if(!field.readOnly){
									var param= {
										DIV_CODE : panelResult.getValue("DIV_CODE"),
										EQU_CODE_1:	equForm.getValue("EQU_CODE_1")
									}
									equ201ukrvService.autoEquCode(param , function(provider, response){
										if(!Ext.isEmpty(provider))	{
											equForm.setValue('EQU_CODE_2',provider.EQU_CODE_2);

										}
									})
								}
							}
						}
					},{
						name: 'EQU_CODE_2',
						xtype: 'uniTextfield'
					}]
	    		},{
					fieldLabel: '금형명',
					name: 'EQU_NAME',
					xtype: 'uniTextfield'
				},{
					fieldLabel: '금형상태',
					name: 'EQU_GRADE',
					xtype: 'uniCombobox',
					comboType: 'AU',
					comboCode: 'I801'
				},{
					fieldLabel: '몰드타입',
					name: 'EQU_TYPE',
					xtype: 'uniCombobox',
					comboType: 'AU',
					comboCode: 'I802'
				},{
		        	fieldLabel: '모델',
					xtype: 'uniTextfield',
					name:'MODEL_CODE'
			    },{
					xtype: 'container',
					layout: { type: 'uniTable', columns: 3},
					defaults : {enforceMaxLength: true},
					items:[{
						fieldLabel: '몰드치수',
						name: 'EQU_SIZE_W',
						xtype: 'uniNumberfield',
						decimalPrecision: 0,
						width: 165,
						emptyText:'가로'
					},{
						fieldLabel: '',
						name: 'EQU_SIZE_L',
						xtype: 'uniNumberfield',
						decimalPrecision: 0,
						width: 75,
						emptyText:'세로'
					},{
						fieldLabel: '',
						name: 'EQU_SIZE_H',
						xtype: 'uniNumberfield',
						decimalPrecision: 0,
						width: 75,
						emptyText:'높이'
					}]
			    },
			    Unilite.popup('CUST', {
					fieldLabel: '제작처',
					valueFieldName: 'CUSTOM_CODE',
			   	 	textFieldName: 'CUSTOM_NAME',
//			   	 	allowBlank:false,
			   	 	autoPopup:true
				}),
				{
					fieldLabel: '제작일' ,
					xtype:'uniDatefield',
					name: 'PRODT_DATE',
           			value: UniDate.get('today')
				},{
					fieldLabel: '제작금액' ,
					xtype:'uniNumberfield' ,
					name: 'PRODT_O',
					decimalPrecision:2
				},{
					fieldLabel: '자산번호' ,
					xtype:'uniTextfield' ,
					name: 'ASSETS_NO'
				},{
					fieldLabel: '상각방법' ,
					xtype:'uniCombobox' ,
					name: 'MT_DEPR',
					comboType:'AU',
					comboCode:'A036'
				},{
					fieldLabel: '사용SHOT' ,
					xtype:'uniNumberfield' ,
					name: 'WORK_Q',
					decimalPrecision:0
				},{
					fieldLabel: '금형위치' ,
					xtype:'uniCombobox' ,
					name: 'LOCATION',
					comboType:'AU',
					comboCode:'I806'
				},
				Unilite.popup('CUST', {
					fieldLabel: '보관처',
					valueFieldName: 'USE_CUSTOM_CODE',
			   	 	textFieldName: 'USE_CUSTOM_NAME'
				}),
				Unilite.popup('CUST', {
					fieldLabel: '소유업체',
					valueFieldName: 'COMP_OWN',
			   	 	textFieldName: 'COMP_OWN_NAME'
				}),
				{
					fieldLabel: '사용여부' ,
					xtype:'uniCombobox' ,
					name: 'USE_YN',
					comboType:'AU',
					comboCode:'A004'
				},{
					fieldLabel: '폐기일자' ,
					xtype:'uniDatefield' ,
					name: 'ABOL_DATE',
           			value: UniDate.get('today')
				},{
					fieldLabel: '폐기사유',
					xtype:'uniTextfield',
					name: 'DISP_REASON'
				},{
					fieldLabel: '비고' ,
					xtype:'textareafield' ,
					name: 'REMARK',
					width: 950,
					height: 50,
					colspan:3
				}]
			}]
		}]
    });


    function openEquWindow() {   // 금형대장등록 금형등록 팝업창
		if(!equWindow) {
			equWindow = Ext.create('widget.uniDetailWindow', {
				title: '금형등록',
				width: 1070,
				minWidth:1070,
				maxWidth:1070,
				height: 380,
				minHeight: 380,
				maxHeight: 380,
				tabDirection: 'left-right',
				resizable:true,
				layout: {type:'vbox', align:'stretch'},
				items: [equForm],
				tbar:  ['->', {
						id : 'equSaveBtn',
						width: 100,
						text: '<t:message code="system.label.product.save" default="저장"/>',
						handler: function() {

							var masterRecord = masterGrid.getSelectedRecord();

//							masterRecord.set('EQU_CODE'				,equForm.getValue('EQU_CODE'));
							masterRecord.set('EQU_CODE_1'				,equForm.getValue('EQU_CODE_1'));
							masterRecord.set('EQU_CODE_2'				,equForm.getValue('EQU_CODE_2'));
							masterRecord.set('EQU_NAME'					,equForm.getValue('EQU_NAME'));
							masterRecord.set('EQU_GRADE'			,equForm.getValue('EQU_GRADE'));
							masterRecord.set('EQU_TYPE'					,equForm.getValue('EQU_TYPE'));
							masterRecord.set('MODEL_CODE'				,equForm.getValue('MODEL_CODE'));
							masterRecord.set('EQU_SIZE_W'				,equForm.getValue('EQU_SIZE_W'));
							masterRecord.set('EQU_SIZE_L'				,equForm.getValue('EQU_SIZE_L'));
							masterRecord.set('EQU_SIZE_H'				,equForm.getValue('EQU_SIZE_H'));
							masterRecord.set('CUSTOM_CODE'				,equForm.getValue('CUSTOM_CODE'));
							masterRecord.set('CUSTOM_NAME'				,equForm.getValue('CUSTOM_NAME'));
							masterRecord.set('PRODT_DATE'				,equForm.getValue('PRODT_DATE'));
							masterRecord.set('PRODT_O'					,equForm.getValue('PRODT_O'));
							masterRecord.set('ASSETS_NO'				,equForm.getValue('ASSETS_NO'));
							masterRecord.set('MT_DEPR'					,equForm.getValue('MT_DEPR'));
							masterRecord.set('WORK_Q'					,equForm.getValue('WORK_Q'));
							masterRecord.set('LOCATION'					,equForm.getValue('LOCATION'));
							masterRecord.set('USE_CUSTOM_CODE'			,equForm.getValue('USE_CUSTOM_CODE'));
							masterRecord.set('USE_CUSTOM_NAME'			,equForm.getValue('USE_CUSTOM_NAME'));
							masterRecord.set('COMP_OWN'					,equForm.getValue('COMP_OWN'));
							masterRecord.set('COMP_OWN_NAME'					,equForm.getValue('COMP_OWN_NAME'));
							masterRecord.set('USE_YN'					,equForm.getValue('USE_YN'));
							masterRecord.set('ABOL_DATE'				,equForm.getValue('ABOL_DATE'));
							masterRecord.set('DISP_REASON'				,equForm.getValue('DISP_REASON'));
							masterRecord.set('REMARK'					,equForm.getValue('REMARK'));

							equForm.clearForm();
							equWindow.hide();
							masterStore.saveStore();
						},
						disabled: false

					},{


						id : 'equCloseBtn',
						width: 100,
						text: '닫기',
						handler: function() {
							equWindow.hide();
						},

						disabled: false
					}
				],
				listeners: {
					beforehide: function(me, eOpt) {
					},
					beforeclose: function( panel, eOpts ) {
					},
					beforeshow: function( panel, eOpts )	{

						var masterRecord = masterGrid.getSelectedRecord();

						equForm.setValue('EQU_CODE_1'		,masterRecord.get('EQU_CODE_1'));
						equForm.setValue('EQU_CODE_2'		,masterRecord.get('EQU_CODE_2'));
						equForm.setValue('EQU_NAME'			,masterRecord.get('EQU_NAME'));
						equForm.setValue('EQU_GRADE'	,masterRecord.get('EQU_GRADE'));
						equForm.setValue('EQU_TYPE'			,masterRecord.get('EQU_TYPE'));
						equForm.setValue('MODEL_CODE'		,masterRecord.get('MODEL_CODE'));
						equForm.setValue('EQU_SIZE_W'		,masterRecord.get('EQU_SIZE_W'));
						equForm.setValue('EQU_SIZE_L'		,masterRecord.get('EQU_SIZE_L'));
						equForm.setValue('EQU_SIZE_H'		,masterRecord.get('EQU_SIZE_H'));
						equForm.setValue('CUSTOM_CODE'		,masterRecord.get('CUSTOM_CODE'));
						equForm.setValue('CUSTOM_NAME'		,masterRecord.get('CUSTOM_NAME'));
						equForm.setValue('PRODT_DATE'		,masterRecord.get('PRODT_DATE'));
						equForm.setValue('PRODT_O'			,masterRecord.get('PRODT_O'));
						equForm.setValue('ASSETS_NO'		,masterRecord.get('ASSETS_NO'));
						equForm.setValue('MT_DEPR'			,masterRecord.get('MT_DEPR'));
						equForm.setValue('WORK_Q'			,masterRecord.get('WORK_Q'));
						equForm.setValue('LOCATION'			,masterRecord.get('LOCATION'));
						equForm.setValue('USE_CUSTOM_CODE'	,masterRecord.get('USE_CUSTOM_CODE'));
						equForm.setValue('USE_CUSTOM_NAME'	,masterRecord.get('USE_CUSTOM_NAME'));
						equForm.setValue('COMP_OWN'			,masterRecord.get('COMP_OWN'));
						equForm.setValue('COMP_OWN_NAME'	,masterRecord.get('COMP_OWN_NAME'));
						equForm.setValue('USE_YN'			,masterRecord.get('USE_YN'));
						equForm.setValue('ABOL_DATE'		,masterRecord.get('ABOL_DATE'));
						equForm.setValue('DISP_REASON'		,masterRecord.get('DISP_REASON'));
						equForm.setValue('REMARK'			,masterRecord.get('REMARK'));
					}
				}
			})
		}
		equWindow.center();
		equWindow.show();
	}


    var coreForm = Unilite.createSearchForm('coreForm', {       // 코어 등록팝업
        layout: {type : 'uniTable', columns : 3},
        height:450,
        width: 1110,
		region: 'center',
		autoScroll: false,
		border: true,
		padding: '1 1 1 1',
		layout: {type: 'uniTable', columns: 1, tdAttrs: {valign:'top'}},
		xtype: 'container',
		defaultType: 'container',
        items:[{
			layout: {type: 'uniTable', columns: 1, tableAttrs:{cellpadding:5}, tdAttrs: {valign:'top'}},
			defaultType: 'uniFieldset',
			defaults: { padding: '10 15 15 15'},
			items: [{
				title: '코어 상세정보',
				layout: { type: 'uniTable', columns: 3},
				margin: '10 0 15 15',
				width:1010,
				items: [


						/*	{
					xtype: 'container',
					layout: { type: 'uniTable', columns: 2},
//					defaults : {enforceMaxLength: true},
					items:[



		/*							{
						fieldLabel: '금형번호',
						name: 'EQU_CODE_1',
						xtype: 'uniTextfield',
						width: 165,
						listeners: {
							blur: function(field, event, eOpts) {
								if(!field.readOnly){
									var param= {
										DIV_CODE : panelResult.getValue("DIV_CODE"),
										EQU_CODE_1:	equForm.getValue("EQU_CODE_1")
									}
									equ201ukrvService.autoEquCode(param , function(provider, response){
										if(!Ext.isEmpty(provider))	{
											equForm.setValue('EQU_CODE_2',provider.EQU_CODE_2);

										}
									})
								}
							}
						}
					},{
						name: 'EQU_CODE_2',
						xtype: 'uniTextfield'
					}]
	    		}

	    		*/

		    		{
						fieldLabel: '코어번호',
						name: 'CORE_CODE',
						xtype: 'uniTextfield'
					},{
						fieldLabel: '코어명',
						name: 'CORE_NAME',
						xtype: 'uniTextfield'
					},{
						fieldLabel: '코어상태',
						name: 'CORE_STATUS',
						xtype: 'uniCombobox',
						comboType: 'AU',
						comboCode: 'I801'
					},{
						fieldLabel: '부품타입',
						name: 'PRODT_TYPE',
						xtype: 'uniCombobox',
						comboType: 'AU',
						comboCode: 'I808'
					},

					{
						fieldLabel: '게이트방식',
						name: 'CORE_TYPE',
						xtype: 'uniCombobox',
						comboType: 'AU',
						comboCode: 'I806'
					},{
			        	fieldLabel: '모델',
						xtype: 'uniTextfield',
						name:'MODEL_CODE'
				    },{
			        	fieldLabel: '규격',
						xtype: 'uniTextfield',
						name:'CORE_SPEC'
				    },{
						fieldLabel: '코어재질',
						name: 'CORE_MTRL',
						xtype: 'uniCombobox',
						comboType: 'AU',
						comboCode: 'I807'
					},{
			        	fieldLabel: '주원료',
						xtype: 'uniTextfield',
						name:'PRODT_MTRL'
				    },{
						xtype: 'container',
						layout: { type: 'uniTable', columns: 4},
						defaults : {enforceMaxLength: true},
						items:[{
							fieldLabel: '코어치수',
							name: 'CORE_SIZE_W',
							xtype: 'uniNumberfield',
							decimalPrecision: 0,
							width: 143,
							emptyText:'가로'
						},{
							fieldLabel: '',
							name: 'CORE_SIZE_L',
							xtype: 'uniNumberfield',
							decimalPrecision: 0,
							width: 58,
							emptyText:'세로'
						},{
							fieldLabel: '',
							name: 'CORE_SIZE_H',
							xtype: 'uniNumberfield',
							decimalPrecision: 0,
							width: 58,
							emptyText:'높이'
						},{
							fieldLabel: '',
							name: 'CORE_SIZE_P',
							xtype: 'uniNumberfield',
							decimalPrecision: 0,
							width: 58,
							emptyText:'직경'
						}]
				    },{
						fieldLabel: '부품중량',
						name: 'PRODT_WEIGHT',
						xtype: 'uniNumberfield',
						decimalPrecision: 0
					},{
						fieldLabel: '런너중량',
						name: 'RUNNER_WEIGHT',
						xtype: 'uniNumberfield',
						decimalPrecision: 0
					},{
						xtype: 'container',
						layout: { type: 'uniTable', columns: 4},
						defaults : {enforceMaxLength: true},
						items:[{
							fieldLabel: '제품치수',
							name: 'PRODT_SIZE_W',
							xtype: 'uniNumberfield',
							decimalPrecision: 0,
							width: 143,
							emptyText:'가로'
						},{
							fieldLabel: '',
							name: 'PRODT_SIZE_L',
							xtype: 'uniNumberfield',
							decimalPrecision: 0,
							width: 58,
							emptyText:'세로'
						},{
							fieldLabel: '',
							name: 'PRODT_SIZE_H',
							xtype: 'uniNumberfield',
							decimalPrecision: 0,
							width: 58,
							emptyText:'높이'
						},{
							fieldLabel: '',
							name: 'PRODT_SIZE_P',
							xtype: 'uniNumberfield',
							decimalPrecision: 0,
							width: 58,
							emptyText:'직경'
						}]
				    },{
						fieldLabel: '슬라이드유무',
						name: 'CORE_METHOD',
						xtype: 'uniCombobox',
						comboType: 'AU',
						comboCode: 'I809'
					},{
						fieldLabel: '캐비티',
						name: 'CAVITY_Q',
						xtype: 'uniNumberfield',
						decimalPrecision: 0
					},{
						fieldLabel: '사용SHOT' ,
						xtype:'uniNumberfield' ,
						name: 'WORK_Q',
						decimalPrecision:0
					},{
						fieldLabel: '코어형상',
						name: 'CORE_FORM',
						xtype: 'uniCombobox',
						comboType: 'AU',
						comboCode: 'I810'
					},{
						fieldLabel: '가공시간 ' ,
						xtype:'uniNumberfield' ,
						name: 'CYCLE_TIME',
						decimalPrecision:0
					},{
						fieldLabel: '한도SHOT' ,
						xtype:'uniNumberfield' ,
						name: 'CAPA_Q',
						decimalPrecision:0
					},{
			        	fieldLabel: '보관위치',
						xtype: 'uniTextfield',
						name:'CORE_LOCATION'
				    },{
						fieldLabel: '제작금액' ,
						xtype:'uniNumberfield' ,
						name: 'PRODT_O',
						decimalPrecision:0
					},{
						fieldLabel: '누적SHOT' ,
						xtype:'uniNumberfield' ,
						name: 'TOTAL_Q',
						decimalPrecision:0
					},
				    Unilite.popup('CUST', {
						fieldLabel: '제작처',
						valueFieldName: 'PRODT_CUSTOM',
				   	 	textFieldName: 'PRODT_CUSTOM_NAME',
	//			   	 	allowBlank:false,
				   	 	autoPopup:true
					}),
					{
						fieldLabel: '제작일' ,
						xtype:'uniDatefield',
						name: 'PRODT_DATE',
           				value: UniDate.get('today')
					},{
						fieldLabel: '점검SHOT' ,
						xtype:'uniNumberfield' ,
						name: 'AUDIT_Q',
						decimalPrecision:0
					},
				    Unilite.popup('CUST', {
						fieldLabel: '보관처',
						valueFieldName: 'USE_CUSTOM_CODE',
				   	 	textFieldName: 'USE_CUSTOM_NAME',
	//			   	 	allowBlank:false,
				   	 	autoPopup:true
					}),
				    Unilite.popup('CUST', {
						fieldLabel: '소유처',
						valueFieldName: 'COMP_OWN',
				   	 	textFieldName: 'COMP_OWN_NAME',
	//			   	 	allowBlank:false,
				   	 	autoPopup:true
					}),
				    {
						fieldLabel: '최대SHOT' ,
						xtype:'uniNumberfield' ,
						name: 'MAX_Q',
						decimalPrecision:0
					},{
						fieldLabel: '폐기일' ,
						xtype:'uniDatefield',
						name: 'ABOL_DATE',
           				value: UniDate.get('today')
					},{
			        	fieldLabel: '폐기사유',
						xtype: 'uniTextfield',
						name:'ABOL_REASON'
				    },{
						fieldLabel: '사용여부' ,
						xtype:'uniCombobox' ,
						name: 'USE_YN',
						comboType:'AU',
						comboCode:'A004'
					},{
			        	fieldLabel: '자산번호',
						xtype: 'uniTextfield',
						name:'ASSETS_NO',
						colspan:3
				    },{
						fieldLabel: '비고' ,
						xtype:'textareafield' ,
						name: 'REMARK',
						width: 950,
						height: 50,
						colspan:3
					}]

			}]
		}]
    });


    function openCoreWindow() {   // 금형대장등록 금형등록 팝업창
		if(!coreWindow) {
			coreWindow = Ext.create('widget.uniDetailWindow', {
				title: '코어등록',
				width: 1070,
				minWidth:1070,
				maxWidth:1070,
				height: 510,
				minHeight: 510,
				maxHeight: 510,
				tabDirection: 'left-right',
				resizable:true,
				layout: {type:'vbox', align:'stretch'},
				items: [coreForm],
				tbar:  ['->', {
						id : 'coreSaveBtn',
						width: 100,
						text: '<t:message code="system.label.product.save" default="저장"/>',
						handler: function() {

							var subRecord = subGrid.getSelectedRecord();

							subRecord.set('CORE_CODE'        				,coreForm.getValue('CORE_CODE'        ));
							subRecord.set('MODEL_CODE'       				,coreForm.getValue('MODEL_CODE'       ));
							subRecord.set('CORE_NAME'        				,coreForm.getValue('CORE_NAME'        ));
							subRecord.set('CORE_SPEC'        				,coreForm.getValue('CORE_SPEC'        ));
							subRecord.set('PRODT_TYPE'       				,coreForm.getValue('PRODT_TYPE'       ));
							subRecord.set('CORE_TYPE'        				,coreForm.getValue('CORE_TYPE'        ));
							subRecord.set('CORE_FORM'        				,coreForm.getValue('CORE_FORM'        ));
							subRecord.set('CORE_SIZE'        				,coreForm.getValue('CORE_SIZE'        ));
							subRecord.set('CAVITY_Q'         				,coreForm.getValue('CAVITY_Q'         ));
							subRecord.set('PRODT_MTRL'       				,coreForm.getValue('PRODT_MTRL'       ));

							subRecord.set('CORE_STATUS'      				,coreForm.getValue('CORE_STATUS'      ));
							subRecord.set('CORE_MTRL'        				,coreForm.getValue('CORE_MTRL'        ));
							subRecord.set('CORE_SIZE_W'      				,coreForm.getValue('CORE_SIZE_W'      ));
							subRecord.set('CORE_SIZE_L'      				,coreForm.getValue('CORE_SIZE_L'      ));
							subRecord.set('CORE_SIZE_H'      				,coreForm.getValue('CORE_SIZE_H'      ));
							subRecord.set('CORE_SIZE_P'      				,coreForm.getValue('CORE_SIZE_P'      ));
							subRecord.set('PRODT_WEIGHT'     				,coreForm.getValue('PRODT_WEIGHT'     ));
							subRecord.set('RUNNER_WEIGHT'    				,coreForm.getValue('RUNNER_WEIGHT'    ));
							subRecord.set('PRODT_SIZE_W'     				,coreForm.getValue('PRODT_SIZE_W'     ));
							subRecord.set('PRODT_SIZE_L'     				,coreForm.getValue('PRODT_SIZE_L'     ));
							subRecord.set('PRODT_SIZE_H'     				,coreForm.getValue('PRODT_SIZE_H'     ));
							subRecord.set('PRODT_SIZE_P'     				,coreForm.getValue('PRODT_SIZE_P'     ));
							subRecord.set('CORE_METHOD'      				,coreForm.getValue('CORE_METHOD'      ));
							subRecord.set('WORK_Q'           				,coreForm.getValue('WORK_Q'           ));
							subRecord.set('CYCLE_TIME'       				,coreForm.getValue('CYCLE_TIME'       ));
							subRecord.set('CAPA_Q'           				,coreForm.getValue('CAPA_Q'           ));
							subRecord.set('CORE_LOCATION'    				,coreForm.getValue('CORE_LOCATION'    ));
							subRecord.set('PRODT_O'          				,coreForm.getValue('PRODT_O'          ));
							subRecord.set('TOTAL_Q'          				,coreForm.getValue('TOTAL_Q'          ));
							subRecord.set('PRODT_CUSTOM'     				,coreForm.getValue('PRODT_CUSTOM'     ));
							subRecord.set('PRODT_CUSTOM_NAME'				,coreForm.getValue('PRODT_CUSTOM_NAME'));
							subRecord.set('PRODT_DATE'       				,coreForm.getValue('PRODT_DATE'       ));
							subRecord.set('AUDIT_Q'          				,coreForm.getValue('AUDIT_Q'          ));
							subRecord.set('USE_CUSTOM_CODE'  				,coreForm.getValue('USE_CUSTOM_CODE'  ));
							subRecord.set('USE_CUSTOM_NAME'  				,coreForm.getValue('USE_CUSTOM_NAME'  ));
							subRecord.set('COMP_OWN'         				,coreForm.getValue('COMP_OWN'         ));
							subRecord.set('COMP_OWN_NAME'    				,coreForm.getValue('COMP_OWN_NAME'    ));
							subRecord.set('MAX_Q'           				,coreForm.getValue('MAX_Q'           	));
							subRecord.set('ABOL_DATE'        				,coreForm.getValue('ABOL_DATE'        ));
							subRecord.set('ABOL_REASON'      				,coreForm.getValue('ABOL_REASON'      ));
							subRecord.set('USE_YN'           				,coreForm.getValue('USE_YN'           ));
							subRecord.set('ASSETS_NO'        				,coreForm.getValue('ASSETS_NO'        ));
							subRecord.set('REMARK'           				,coreForm.getValue('REMARK'           ));

							coreForm.clearForm();
							coreWindow.hide();
							subStore.saveStore();
						},
						disabled: false

					},{


						id : 'coreCloseBtn',
						width: 100,
						text: '닫기',
						handler: function() {
							coreWindow.hide();
						},

						disabled: false
					}
				],
				listeners: {
					beforehide: function(me, eOpt) {
					},
					beforeclose: function( panel, eOpts ) {
					},
					beforeshow: function( panel, eOpts )	{

						var subRecord = subGrid.getSelectedRecord();

						coreForm.setValue('CORE_CODE'        		,subRecord.get('CORE_CODE'        ));
						coreForm.setValue('MODEL_CODE'       		,subRecord.get('MODEL_CODE'       ));
						coreForm.setValue('CORE_NAME'        		,subRecord.get('CORE_NAME'        ));
						coreForm.setValue('CORE_SPEC'        		,subRecord.get('CORE_SPEC'        ));
						coreForm.setValue('PRODT_TYPE'       		,subRecord.get('PRODT_TYPE'       ));
						coreForm.setValue('CORE_TYPE'        		,subRecord.get('CORE_TYPE'        ));
						coreForm.setValue('CORE_FORM'        		,subRecord.get('CORE_FORM'        ));
						coreForm.setValue('CORE_SIZE'        		,subRecord.get('CORE_SIZE'        ));
						coreForm.setValue('CAVITY_Q'         		,subRecord.get('CAVITY_Q'         ));
						coreForm.setValue('PRODT_MTRL'       		,subRecord.get('PRODT_MTRL'       ));

						coreForm.setValue('CORE_STATUS'      		,subRecord.get('CORE_STATUS'      ));
						coreForm.setValue('CORE_MTRL'        		,subRecord.get('CORE_MTRL'        ));
						coreForm.setValue('CORE_SIZE_W'      		,subRecord.get('CORE_SIZE_W'      ));
						coreForm.setValue('CORE_SIZE_L'      		,subRecord.get('CORE_SIZE_L'      ));
						coreForm.setValue('CORE_SIZE_H'      		,subRecord.get('CORE_SIZE_H'      ));
						coreForm.setValue('CORE_SIZE_P'      		,subRecord.get('CORE_SIZE_P'      ));
						coreForm.setValue('PRODT_WEIGHT'     		,subRecord.get('PRODT_WEIGHT'     ));
						coreForm.setValue('RUNNER_WEIGHT'    		,subRecord.get('RUNNER_WEIGHT'    ));
						coreForm.setValue('PRODT_SIZE_W'     		,subRecord.get('PRODT_SIZE_W'     ));
						coreForm.setValue('PRODT_SIZE_L'     		,subRecord.get('PRODT_SIZE_L'     ));
						coreForm.setValue('PRODT_SIZE_H'     		,subRecord.get('PRODT_SIZE_H'     ));
						coreForm.setValue('PRODT_SIZE_P'     		,subRecord.get('PRODT_SIZE_P'     ));
						coreForm.setValue('CORE_METHOD'      		,subRecord.get('CORE_METHOD'      ));
						coreForm.setValue('WORK_Q'           		,subRecord.get('WORK_Q'           ));
						coreForm.setValue('CYCLE_TIME'       		,subRecord.get('CYCLE_TIME'       ));
						coreForm.setValue('CAPA_Q'           		,subRecord.get('CAPA_Q'           ));
						coreForm.setValue('CORE_LOCATION'    		,subRecord.get('CORE_LOCATION'    ));
						coreForm.setValue('PRODT_O'          		,subRecord.get('PRODT_O'          ));
						coreForm.setValue('TOTAL_Q'          		,subRecord.get('TOTAL_Q'          ));
						coreForm.setValue('PRODT_CUSTOM'     		,subRecord.get('PRODT_CUSTOM'     ));
						coreForm.setValue('PRODT_CUSTOM_NAME'		,subRecord.get('PRODT_CUSTOM_NAME'));
						coreForm.setValue('PRODT_DATE'       		,subRecord.get('PRODT_DATE'       ));
						coreForm.setValue('AUDIT_Q'          		,subRecord.get('AUDIT_Q'          ));
						coreForm.setValue('USE_CUSTOM_CODE'  		,subRecord.get('USE_CUSTOM_CODE'  ));
						coreForm.setValue('USE_CUSTOM_NAME'  		,subRecord.get('USE_CUSTOM_NAME'  ));
						coreForm.setValue('COMP_OWN'         		,subRecord.get('COMP_OWN'         ));
						coreForm.setValue('COMP_OWN_NAME'    		,subRecord.get('COMP_OWN_NAME'    ));
						coreForm.setValue('MAX_Q'           		,subRecord.get('MAX_Q'           	));
						coreForm.setValue('ABOL_DATE'        		,subRecord.get('ABOL_DATE'        ));
						coreForm.setValue('ABOL_REASON'      		,subRecord.get('ABOL_REASON'      ));
						coreForm.setValue('USE_YN'           		,subRecord.get('USE_YN'           ));
						coreForm.setValue('ASSETS_NO'        		,subRecord.get('ASSETS_NO'        ));
						coreForm.setValue('REMARK'           		,subRecord.get('REMARK'           ));
					}
				}
			})
		}
		coreWindow.center();
		coreWindow.show();
	}








	var statusForm = Unilite.createSearchForm('statusForm',{
        region: 'north',
        layout : {type : 'uniTable', columns : 1},
        padding:'1 1 1 1',
        border:true,
        items: [{
            fieldLabel: '사업장',
            name:'DIV_CODE',
            xtype: 'uniCombobox',
            comboType:'BOR120',
            allowBlank:false,
            holdable: 'hold',
            value: UserInfo.divCode
    	},
        	statusGrid
        ]
    });


    Unilite.defineModel('equInfoModel', {
		fields: [
			{name: 'COMP_CODE'			,text: '법인코드'			,type: 'string'},
			{name: 'DIV_CODE'			,text: '사업장코드'			,type: 'string'},
			{name: 'EQU_CODE'			,text: '장비코드'			,type: 'string'},
			{name: 'FILE_TYPE'			,text: '도면종류'			,type: 'string', 	allowBlank: false,		comboType:'AU', comboCode:'I805' },
			{name: 'MANAGE_NO'			,text: '관리번호'			,type: 'string', 	allowBlank: false},
			{name: 'UPDATE_DB_TIME'		,text: '수정일'			,type: 'uniDate'},
			{name: 'REMARK'				,text: '비고'				,type: 'string'},
			{name: 'CERT_FILE'			,text: '파일명'			,type: 'string'},
			{name: 'FILE_ID'			,text: '저장된 파일명'		,type: 'string'},
			{name: 'FILE_PATH'			,text: '저장된 파일경로'		,type: 'string'},
			{name: 'FILE_EXT'			,text: '저장된 파일확장자'		,type: 'string'}
		]
	});

	//금형,코어 정보 관련 파일 업로드
	var equInfoProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'equ201ukrvService.getEquInfo',
			update	: 'equ201ukrvService.equInfoUpdate',
			create	: 'equ201ukrvService.equInfoInsert',
			destroy : 'equ201ukrvService.equInfoDelete',
			syncAll : 'equ201ukrvService.saveAll2'
		}
	});

	var equInfoStore = Unilite.createStore('equInfoStore',{
		model	: 'equInfoModel',
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,		// 상위 버튼 연결
			editable	: true,			// 수정 모드 사용
			deletable	: true,			// 삭제 가능 여부
			useNavi		: false			// prev | next 버튼 사용
		},

		proxy: equInfoProxy,

		loadStoreRecords : function(param){

		/*	var param = null;
			if(activeGridId == 'masterGrid'){
				param = {
					'DIV_CODE' : record.get('DIV_CODE'),
					'EQU_CODE' : record.get('EQU_CODE')
				};
			}else if(activeGridId == 'subGrid'){
				param = {
					'DIV_CODE' : record.get('DIV_CODE'),
					'EQU_CODE' : record.get('CORE_CODE')
				};
			}*/

//			var searchParam = Ext.getCmp('resultForm').getValues();
//			var param = {
//				'DIV_CODE' : record.get('DIV_CODE'),
//				'CORE_CODE' : record.get('CORE_CODE')
//			};
//			var params = Ext.merge(searchParam, param);
			console.log( param );
			this.load({
				params : param,
				callback : function(records,options,success)    {
					isItemGridUseChange = false;
				}
			});
		},
		saveStore : function(config) {
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);
			if(inValidRecs.length == 0 )	 {
				config = {
					success	: function(batch, option) {
						if(gsNeedPhotoSave){
							fnPhotoSave();
						}

						// 파일저장시 뷰 재조회 시켜야함
						//record = masterGrid.getSelectedRecord();

						var record	= subGrid.getSelectedRecord();
						var param = {
							DIV_CODE : record.get('DIV_CODE'),
							EQU_CODE : record.get('CORE_CODE')
						};
						equInfoStore.loadStoreRecords(param);

						imageViewStore1.loadData({});
						imageViewStore1.loadStoreRecords(param);
						imageViewStore2.loadData({});
						imageViewStore2.loadStoreRecords(param);


					}
				};
				this.syncAllDirect(config);
			}else {
				equInfoGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},

		listeners: {
			update:function( store, record, operation, modifiedFieldNames, eOpts ){
			},
			metachange:function( store, meta, eOpts ){
			}
		},

		_onStoreUpdate: function (store, eOpt) {
			console.log("Store data updated save btn enabled !");
			this.setToolbarButtons('sub_save4', true);
		}, // onStoreUpdate

		_onStoreLoad: function ( store, records, successful, eOpts ) {
			console.log("onStoreLoad");
			if (records) {
				this.setToolbarButtons('sub_save4', false);
			}
		},
		_onStoreDataChanged: function( store, eOpts ) {
			console.log("_onStoreDataChanged store.count() : ", store.count());
			if(store.count() == 0){
				this.setToolbarButtons(['sub_delete4'], false);
				Ext.apply(this.uniOpt.state, {'btn':{'sub_delete4':false}});
			}else {
				if(this.uniOpt.deletable)	{
					this.setToolbarButtons(['sub_delete4'], true);
					Ext.apply(this.uniOpt.state, {'btn':{'sub_delete4':true}});
				}
			}
			if(store.isDirty()) {
				this.setToolbarButtons(['sub_save4'], true);
			}else {
				this.setToolbarButtons(['sub_save4'], false);
			}
		},

		setToolbarButtons: function( btnName, state)	 {
			var toolbar = equInfoGrid.getDockedItems('toolbar[dock="top"]');
			var obj = toolbar[0].getComponent(btnName);
			if(obj) {
				(state) ? obj.enable():obj.disable();
			}
		}
	});

	var equInfoGrid = Unilite.createGrid('equInfoGrid', {
		region:'north',
		store	: equInfoStore,
		border	: true,
//		height	: 250,

		flex:2,
		//width	: '100%',
		//padding	: '0 0 5 0',
		sortableColumns : false,
//		selModel:'rowmodel',
		//excelTitle: '관련파일',
		uniOpt	:{
			onLoadSelectFirst	: false,
			expandLastColumn	: false,
			useRowNumberer		: true,
			useMultipleSorting	: false,
			state: {
				useState: false,			//그리드 설정 버튼 사용 여부
				useStateList: false		//그리드 설정 목록 사용 여부
			}
//			enterKeyCreateRow: true							//마스터 그리드 추가기능 삭제
		},
dockedItems : [{
			xtype	: 'toolbar',
			dock	: 'top',
			items	: [{
				xtype	: 'uniBaseButton',
				text	: '조회',
				tooltip	: '조회',
				iconCls	: 'icon-query',
				width	: 26,
				height	: 26,
				itemId	: 'sub_query4',
				handler: function() {
					//if( me._needSave()) {
					var toolbar	= equInfoGrid.getDockedItems('toolbar[dock="top"]');
					var needSave= !toolbar[0].getComponent('sub_save4').isDisabled();
					var record	= subGrid.getSelectedRecord();
					var param = {
						DIV_CODE : record.get('DIV_CODE'),
						EQU_CODE : record.get('CORE_CODE')
					};
					if (needSave) {
						Ext.Msg.show({
							title	: '확인',
							msg		: Msg.sMB017 + "\n" + Msg.sMB061,
							buttons	: Ext.Msg.YESNOCANCEL,
							icon	: Ext.Msg.QUESTION,
							fn		: function(res) {
								//console.log(res);
								if (res === 'yes' ) {
									var saveTask =Ext.create('Ext.util.DelayedTask', function(){
										equInfoStore.saveStore();
									});
									saveTask.delay(500);
								} else if(res === 'no') {
										equInfoStore.loadStoreRecords(param);
								}
							}
						});
					} else {
						equInfoStore.loadStoreRecords(param);
					}
				}
			},{
				xtype	: 'uniBaseButton',
				text	: '신규',
				tooltip	: '초기화',
				iconCls	: 'icon-reset',
				width	: 26,
				height	: 26,
				itemId	: 'sub_reset4',
				handler: function() {
					var toolbar	= equInfoGrid.getDockedItems('toolbar[dock="top"]');
					var needSave= !toolbar[0].getComponent('sub_save4').isDisabled();
					if(needSave) {
							Ext.Msg.show({
								title:'<t:message code="system.label.base.confirm" default="확인"/>',
								msg: Msg.sMB017 + "\n" + Msg.sMB061,
								buttons: Ext.Msg.YESNOCANCEL,
								icon: Ext.Msg.QUESTION,
								fn: function(res) {
									console.log(res);
									if (res === 'yes' ) {
											var saveTask =Ext.create('Ext.util.DelayedTask', function(){
												equInfoStore.saveStore();
											});
											saveTask.delay(500);
									} else if(res === 'no') {
											equInfoGrid.reset();
											equInfoStore.clearData();
											equInfoStore.setToolbarButtons('sub_save4', false);
											equInfoStore.setToolbarButtons('sub_delete4', false);
									}
								}
							});
					} else {
							equInfoGrid.reset();
							equInfoStore.clearData();
							equInfoStore.setToolbarButtons('sub_save4', false);
							equInfoStore.setToolbarButtons('sub_delete4', false);
					}
				}
			},{
				xtype	: 'uniBaseButton',
				text	: '추가',
				tooltip	: '추가',
				iconCls	: 'icon-new',
				width	: 26,
				height	: 26,
				itemId	: 'sub_newData4',
				handler: function() {
					var record = subGrid.getSelectedRecord();

					var r = {
						DIV_CODE		:	record.get('DIV_CODE'),
						EQU_CODE		:	record.get('CORE_CODE')
					};
					equInfoGrid.createRow(r);
				}
			},{
				xtype		: 'uniBaseButton',
				text		: '삭제',
				tooltip		: '삭제',
				iconCls		: 'icon-delete',
				disabled	: true,
				width		: 26,
				height		: 26,
				itemId		: 'sub_delete4',
				handler	: function() {
					var selRow = equInfoGrid.getSelectedRecord();
					if(!Ext.isEmpty(selRow)) {
						if(selRow.phantom === true) {
							equInfoGrid.deleteSelectedRow();
						}else if(confirm('<t:message code="system.message.base.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
							equInfoGrid.deleteSelectedRow();
						}
					} else {
						alert(Msg.sMA0256);
						return false;
					}
				}
			},{
				xtype		: 'uniBaseButton',
				text		: '저장',
				tooltip		: '저장',
				iconCls		: 'icon-save',
				disabled	: true,
				width		: 26,
				height		: 26,
				itemId		: 'sub_save4',
				handler	: function() {
					var inValidRecs = equInfoStore.getInvalidRecords();
					if(inValidRecs.length == 0 )	 {
						var saveTask =Ext.create('Ext.util.DelayedTask', function(){
							equInfoStore.saveStore();
						});
						saveTask.delay(500);
					} else {
						equInfoGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
					}
				}
			}]
		}],
		columns:[
				{ dataIndex	: 'COMP_CODE'			, width: 80			,hidden : true },
				{ dataIndex	: 'DIV_CODE'			, width: 80			,hidden : true },
				{ dataIndex	: 'EQU_CODE'			, width: 80			,hidden : true },
				{ dataIndex	: 'FILE_TYPE'			, width: 80},
				{ dataIndex	: 'MANAGE_NO'			, width: 80},
				{ text		: '품목 관련파일',
				 	columns:[
						{ dataIndex	: 'CERT_FILE'	, width: 300		, align: 'center'	,
							renderer: function (val, meta, record) {
								if (!Ext.isEmpty(record.data.CERT_FILE)) {
								  if(record.data.FILE_EXT == 'jpg' || record.data.FILE_EXT == 'png' || record.data.FILE_EXT == 'pdf'){
									  return '<font color = "blue" >' + val + '</font>';
								  }else{
									  var fileName = record.data.FILE_ID + '.' +  record.data.FILE_EXT;
									  var originFile = record.data.CERT_FILE;
									  var divCode = record.data.DIV_CODE;
									  var EquCode = record.data.EQU_CODE;
									  var fileType = record.data.FILE_TYPE;
									  var manageNo = record.data.MANAGE_NO;
									  return  '<A href="'+ CHOST + CPATH + '/fileman/downloadEquFile/' + PGM_ID + '/' + divCode + '/' + EquCode + '/' + fileType + '/' + manageNo  +'">' + val + '</A>';
								  }
								} else {
									return '';
								}
							}
						},{
							text		: '',
							dataIndex	: 'REG_IMG',
							xtype		: 'actioncolumn',
							align		: 'center',
							padding		: '-2 0 2 0',
							width		: 30,
							items		: [{
								icon	: CPATH+'/resources/css/theme_01/barcodetest.png',
								handler	: function(grid, rowIndex, colIndex, item, e, record) {
									equInfoGrid.getSelectionModel().select(record);
									openUploadWindow();
								}
							}]
						}
					]
				},
				{ dataIndex	: 'UPDATE_DB_TIME'				, width: 100,hidden : true},
				{ dataIndex	: 'REMARK'			, flex: 1	, minWidth: 50}
		],
		listeners: {
			beforeedit: function( editor, e, eOpts ) {
				if(!e.record.phantom) {
					if (UniUtils.indexOf(e.field, ['FILE_TYPE', 'MANAGE_NO', 'CERT_FILE','COMP_CODE','DIV_CODE','EQU_CODE','UPDATE_DB_TIME'])){
						return false;
					}

				} else {
					if (UniUtils.indexOf(e.field, ['CERT_FILE','COMP_CODE','DIV_CODE','EQU_CODE','UPDATE_DB_TIME'])){
						return false;
					}
				}
			},
			select: function(grid, selectRecord, index, rowIndex, eOpts ){
			},
			cellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
				if( cellIndex == 6 &&  !Ext.isEmpty(record.get('CERT_FILE'))) {
					fid = record.data.FILE_ID
					var fileExtension	= record.get('CERT_FILE').lastIndexOf( "." );
					var fileExt			= record.get('CERT_FILE').substring( fileExtension + 1 );

					if(fileExt == 'pdf') {
						var win = Ext.create('widget.CrystalReport', {
							url		: CPATH+'/fileman/downloadEquInfoImage/' + fid,
							prgID	: 'equ200ukrv'
						});
						win.center();
						win.show();

					} else if(fileExt == 'jpg' || fileExt == 'png') {
						openPhotoWindow();
					} else {

					}
				}
			}
		}
	});

	function openPhotoWindow() {
		photoWin = Ext.create('widget.uniDetailWindow', {
			title		: '<t:message code="system.label.base.preview" default="미리보기"/>',
			modal		: true,
			resizable	: true,
			closable	: false,
			width		: '80%',
			height		: '100%',
			layout		: {
				type	: 'fit'
			},
			closeAction	: 'destroy',
			items		: [{
				xtype		: 'uniDetailForm',
				itemId		: 'downForm',
				url			: CPATH + "/fileman/downloadEquInfoImage/" + fid,
				layout		: {type: 'uniTable', columns:'1'},
				standardSubmit: true,
				disabled	: false,
				autoScroll	: true,
				items		: [{
					xtype	: 'image',
					itemId	: 'photView',
					autoEl	: {
						tag: 'img',
						src: CPATH+'/resources/images/human/noPhoto.png'
					}
	  			}]
			}],
			listeners : {
				beforeshow: function( window, eOpts)	{
					window.down('#photView').setSrc(CPATH+'/fileman/downloadEquInfoImage/' + fid);
				},
				show: function( window, eOpts)	{
					window.center();
				}
			},
			tbar:['->',{
				xtype	: 'button',
				text	: '<t:message code="system.label.base.download" default="다운로드"/>',
				handler	: function() {
					photoWin.down('#downForm').submit({
						success:function(comp, action)  {
							Ext.getBody().unmask();
						},
						failure: function(form, action){
							Ext.getBody().unmask();
						}
					});
				}
			},{
				xtype	: 'button',
				text	: '<t:message code="system.label.base.close" default="닫기"/>',
				handler	: function()	{
					photoWin.down('#downForm').clearForm();
					photoWin.close();
					photoWin.hide();
				}
			}]
		});
		photoWin.show();
	}



	function openUploadWindow() {
		if(!uploadWin) {
			uploadWin = Ext.create('Ext.window.Window', {
				title		: '<t:message code="system.label.base.file" default="파일"/> <t:message code="system.label.base.entry" default="등록"/>',
				closable	: false,
				closeAction	: 'hide',
				modal		: true,
				resizable	: true,
				width		: 300,
				height		: 90,
				layout		: {
					type	: 'fit'
				},
				items		: [
					photoForm
					/*{
						xtype		: 'uniDetailForm',
						itemId		: 'photoForm',
						disabled	: false,
						fileUpload	: true,
						api			: {
							submit: equ201ukrvService.photoUploadFile
						},
						items		:[{
						 	xtype		: 'filefield',
							fieldLabel	: '<t:message code="system.label.base.file" default="파일"/>',
							name		: 'photoFile',
							buttonText	: '<t:message code="system.label.base.selectfile" default="파일선택"/>',
							buttonOnly	: false,
							labelWidth	: 70,
							flex		: 1,
							width		: 270
						}]
					}*/
				],
				listeners : {
					beforeshow: function( window, eOpts)	{
 						var toolbar	= equInfoGrid.getDockedItems('toolbar[dock="top"]');
						var needSave= !toolbar[0].getComponent('sub_save4').isDisabled();
						var record	= equInfoGrid.getSelectedRecord();

						if (needSave) {
							if(Ext.isEmpty(record.data.FILE_TYPE) || Ext.isEmpty(record.data.MANAGE_NO)){
								alert('필수입력사항을 입력하신 후 파일을 올려주세요.');
								return false;
							}
						} else {
							if (Ext.isEmpty(record)) {
								alert('장비 관련 정보를 입력하신 후, 파일을 업로드 하시기 바랍니다.');
								return false;
							}
						}
					},
					show: function( window, eOpts)	{
						window.center();
					}
				},
				afterSuccess: function()	{
					var record	= subGrid.getSelectedRecord();
					var param = {
						DIV_CODE : record.get('DIV_CODE'),
						EQU_CODE : record.get('CORE_CODE')
					};
					equInfoStore.loadStoreRecords(param);

					imageViewStore1.loadData({});
					imageViewStore1.loadStoreRecords(param);
					imageViewStore2.loadData({});
					imageViewStore2.loadStoreRecords(param);
					this.afterSavePhoto();
				},
				afterSavePhoto: function()	{
					var photoForm = uploadWin.down('#photoForm');
					photoForm.clearForm();
					uploadWin.hide();
				},
				tbar:['->',{
					xtype	: 'button',
					text	: '<t:message code="system.label.base.upload" default="올리기"/>',
					handler	: function()	{
						var photoForm	= uploadWin.down('#photoForm');
						var toolbar		= equInfoGrid.getDockedItems('toolbar[dock="top"]');
						var needSave	= !toolbar[0].getComponent('sub_save4').isDisabled();

						if (Ext.isEmpty(photoForm.getValue('photoFile'))) {
							alert('<t:message code="system.message.base.message002" default="업로드 할 파일을 선택하십시오."/>');
							return false;
						}

						//jpg파일만 등록 가능
						var filePath		= photoForm.getValue('photoFile');
						var fileExtension	= filePath.lastIndexOf( "." );
						var fileExt			= filePath.substring( fileExtension + 1 );

						/* if(fileExt != 'jpg' && fileExt != 'png' && fileExt != 'bmp' && fileExt != 'pdf') {
							alert('<t:message code="system.message.base.message001" default="이미지 파일(jpg, png, bmp) 또는 pdf파일만 업로드 할 수 있습니다."/>');
							return false;
						} */


						if(needSave)	{
							gsNeedPhotoSave = needSave;
							equInfoStore.saveStore();

						} else {
							fnPhotoSave();
						}
					}
				},{
					xtype	: 'button',
					text	: '<t:message code="system.label.base.close" default="닫기"/>',
					handler	: function()	{
//						var photoForm = uploadWin.down('#photoForm').getForm();
//						if(photoForm.isDirty())	{
//							if(confirm('사진이 변경되었습니다. 저장하시겠습니까?'))	{
//								var config = {
//									success : function()	{
//										// TODO: fix it!!!
//										uploadWin.afterSavePhoto();
//									}
//								}
//								UniAppManager.app.onSaveDataButtonDown(config);
//
//							}else{
								// TODO: fix it!!!
								uploadWin.afterSavePhoto();
//							}
//
//						} else {
							uploadWin.hide();
//						}
					}
				}]
			});
		}
		uploadWin.show();
	}

	var photoForm = Ext.create('Unilite.com.form.UniDetailForm',{
//		xtype		: 'uniDetailForm',
		disabled	: false,
		fileUpload	: true,
		itemId		: 'photoForm',
        layout : {type : 'uniTable', columns : 1},
        padding:'1 1 1 1',
		api			: {
			submit	: equ201ukrvService.photoUploadFile
		},
		items		: [{
				xtype		: 'filefield',
				buttonOnly	: false,
				fieldLabel	: '<t:message code="system.label.base.file" default="파일"/>',
				flex		: 1,
				name		: 'photoFile',
				id			: 'photoFile',
				buttonText	: '<t:message code="system.label.base.selectfile" default="파일선택"/>',
				width		: 270,
				labelWidth	: 70
			}
		]
	});
	function fnPhotoSave() {				//이미지 등록
		//조건에 맞는 내용은 적용 되는 로직
		var record		= equInfoGrid.getSelectedRecord();
		var photoForm	= uploadWin.down('#photoForm').getForm();
		var param		= {
			DIV_CODE	: record.data.DIV_CODE,
			EQU_CODE	: record.data.EQU_CODE,
			FILE_TYPE	: record.data.FILE_TYPE,
			MANAGE_NO	: record.data.MANAGE_NO
		}
		photoForm.submit({
			params	: param,
			waitMsg	: 'Uploading your files...',
			success	: function(form, action)	{
				uploadWin.afterSuccess();
				gsNeedPhotoSave = false;
			}
		});
	}


	/*
	var itemImageForm = Unilite.createForm('eqt200ImageForm' +'itemImageForm', {
		region: 'center',
		fileUpload: true,
 //url:  CPATH+'/fileman/upload.do',
		api:{ submit: equ201ukrvService.uploadPhoto},
		disabled:false,
		flex:3,
		border:true,
//		layout: {type: 'uniTable', columns: 1},
	        layout: {type: 'vbox', align:'stretch'},
		items: [{
			xtype:'uniFieldset',
			layout: {
	            type: 'uniTable',
	            columns: 2,
	            tdAttrs: {valign:'top'}
	        },
	        padding: '5 5 5 5',
			width:430,
//            height:250,
	        items :[{
				xtype: 'filefield',
				buttonOnly: false,
				fieldLabel: '사진',
				hideLabel:true,
				width:350,
				name: 'fileUpload',
				buttonText: '파일선택',
				listeners: {
					change : function( filefield, value, eOpts )	{
						itemImageForm.setValue('_fileChange', 'true');
					}
				}
			},{
				xtype: 'button',
				text:'사진저장',
				margin:'0 0 0 2',
				handler:function()	{

					var record = null;
					var param = null;
					if(activeGridId == 'masterGrid'){
						record = masterGrid.getSelectedRecord();
						param = {
							'DIV_CODE' : record.get('DIV_CODE'),
							'EQU_CODE' : record.get('EQU_CODE'),
							'CTRL_TYPE' : record.get('EQU_GRADE')
						};
					}else if(activeGridId == 'subGrid'){
						record = subGrid.getSelectedRecord();
						param = {
							'DIV_CODE' : record.get('DIV_CODE'),
							'EQU_CODE' : record.get('CORE_CODE'),
							'CTRL_TYPE' : record.get('CORE_STATUS')
						};
					}



					if(Ext.isEmpty(record.get('EQU_CODE')))	{
						alert('금형 번호가 없습니다. 저장 후 사진을 올려주세요.');
						return;
					}
					itemImageForm.submit( {
						params :param,
						success : function(){
//							var selRecord = masterGrid.getSelectedRecord();
//							UniAppManager.app.onQueryButtonDown();
//							UniAppManager.app.onQueryButtonDown();
						}
		    		});
				}
			},{
				name: '_fileChange',
				fieldLabel: '사진수정여부',
				hidden:true
			}]
		}]
	});
	*/

	Unilite.defineModel('imageViewModel1', {
	    fields: [
	    	{name: 'FILE_ID'		, text:'이미지id'	, type: 'string'},
	    	{name: 'FILE_EXT'		, text:'이미지타입'	, type: 'string'}
//	    	{name: 'IMG_NAME'		, text:'이미지명'	, type: 'string'}
		]
	});
	var imageViewStore1 = Unilite.createStore('imageViewStore1', {
		model: 'imageViewModel1',
		autoLoad: false,
		uniOpt: {
			isMaster:	false,			// 상위 버튼 연결
			editable:	false,			// 수정 모드 사용
			deletable:	false,			// 삭제 가능 여부
			useNavi:	false			// prev | next 버튼 사용
		},
		proxy: {
            type: 'direct',
            api: {
            	   read : 'equ201ukrvService.imagesList1'
            }
        },
		loadStoreRecords: function(param) {
//			var param= panelResult.getValues();

/*			var param = null;
			if(activeGridId == 'masterGrid'){
				param = {
					'DIV_CODE' : record.get('DIV_CODE'),
					'EQU_CODE' : record.get('EQU_CODE')
				};
			}else if(activeGridId == 'subGrid'){
				param = {
					'DIV_CODE' : record.get('DIV_CODE'),
					'EQU_CODE' : record.get('CORE_CODE')
				};
			}*/
		/*	if(Ext.isEmpty(masterForm.getValue('EQU_GRADE'))){
				param.CTRL_TYPE = '';
			}else{
				param.CTRL_TYPE = masterForm.getValue('EQU_GRADE');
			}*/
			this.load({
				params : param
//				callback : function(records,options,success)	{
//					if(success)	{
//							UniAppManager.setToolbarButtons(['delete', 'newData'], true);
//					}
//				}
			});
		},
		listeners: {
           	load: function(store, records, successful, eOpts) {


           	}/*,
           	add: function(store, records, index, eOpts) {
           	},
           	update: function(store, record, operation, modifiedFieldNames, eOpts) {
           	},
           	remove: function(store, record, index, isMove, eOpts) {
           	}*/
		}
	});

	var viewTpl = new Ext.XTemplate(
		'<tpl for=".">'+

        			'<div class="thumb-wrap"><img src="'+ CPATH+'/equit/equ201Photo/{FILE_ID}.{FILE_EXT}" height= "200" width="250"></div>'+
//     			'<tpl if="IMAGE_FID == null"  || IMAGE_FID == \"\">'+
//     			     '<div class="thumb-wrap"><img src="'+ CPATH+'/equit/equPhoto/Noimage.png" height= "200" width="400"></div>'+
//    			'<tpl else>'+
//        			'<div class="thumb-wrap"><img src="'+ CPATH+'/equit/equPhoto/{IMAGE_FID}.{IMG_TYPE}" height= "200" width="400"></div>'+
//    			'</tpl>'+
         	  '</tpl>'

	)

	var imagesView1 = Ext.create('Ext.view.View', {
		tpl: viewTpl,

	/*
		['<tpl for=".">'+

        			'<div class="thumb-wrap"><img src="'+ CPATH+'/equit/equPhoto/{FILE_ID}.{FILE_EXT}" height= "200" width="400"></div>'+
//     			'<tpl if="IMAGE_FID == null"  || IMAGE_FID == \"\">'+
//     			     '<div class="thumb-wrap"><img src="'+ CPATH+'/equit/equPhoto/Noimage.png" height= "200" width="400"></div>'+
//    			'<tpl else>'+
//        			'<div class="thumb-wrap"><img src="'+ CPATH+'/equit/equPhoto/{IMAGE_FID}.{IMG_TYPE}" height= "200" width="400"></div>'+
//    			'</tpl>'+
         	  '</tpl>'
         	  ],*/
//        itemSelector: 'div.data-source ',
//		height:320,
        flex:1,
		width:300,
//        region: 'center',
        store: imageViewStore1,
        frame:true,
		trackOver: true,
		itemSelector: 'div.thumb-wrap',
        overItemCls: 'x-item-over',
        scrollable:true,
        border:true,
        style:{
        		'background-color': '#fff' ,
        		'border': '1px solid #9598a8; '
        }
//        border:true
	});

	Unilite.defineModel('imageViewModel2', {
	    fields: [
	    	{name: 'FILE_ID'		, text:'이미지id'	, type: 'string'},
	    	{name: 'FILE_EXT'		, text:'이미지타입'	, type: 'string'}
//	    	{name: 'IMG_NAME'		, text:'이미지명'	, type: 'string'}
		]
	});
	var imageViewStore2 = Unilite.createStore('imageViewStore2', {
		model: 'imageViewModel2',
		autoLoad: false,
		uniOpt: {
			isMaster:	false,			// 상위 버튼 연결
			editable:	false,			// 수정 모드 사용
			deletable:	false,			// 삭제 가능 여부
			useNavi:	false			// prev | next 버튼 사용
		},
		proxy: {
            type: 'direct',
            api: {
            	   read : 'equ201ukrvService.imagesList2'
            }
        },
		loadStoreRecords: function(param) {
//			var param= panelResult.getValues();
/*
			var param = null;
			if(activeGridId == 'masterGrid'){
				param = {
					'DIV_CODE' : record.get('DIV_CODE'),
					'EQU_CODE' : record.get('EQU_CODE')
				};
			}else if(activeGridId == 'subGrid'){
				param = {
					'DIV_CODE' : record.get('DIV_CODE'),
					'EQU_CODE' : record.get('CORE_CODE')
				};
			}*/
		/*	if(Ext.isEmpty(masterForm.getValue('EQU_GRADE'))){
				param.CTRL_TYPE = '';
			}else{
				param.CTRL_TYPE = masterForm.getValue('EQU_GRADE');
			}*/
			this.load({
				params : param
//				callback : function(records,options,success)	{
//					if(success)	{
//							UniAppManager.setToolbarButtons(['delete', 'newData'], true);
//					}
//				}
			});
		},
		listeners: {
           	load: function(store, records, successful, eOpts) {


           	}/*,
           	add: function(store, records, index, eOpts) {
           	},
           	update: function(store, record, operation, modifiedFieldNames, eOpts) {
           	},
           	remove: function(store, record, index, isMove, eOpts) {
           	}*/
		}
	});
	var imagesView2 = Ext.create('Ext.view.View', {
		tpl: viewTpl,

	/*
		['<tpl for=".">'+

        			'<div class="thumb-wrap"><img src="'+ CPATH+'/equit/equPhoto/{FILE_ID}.{FILE_EXT}" height= "200" width="400"></div>'+
//     			'<tpl if="IMAGE_FID == null"  || IMAGE_FID == \"\">'+
//     			     '<div class="thumb-wrap"><img src="'+ CPATH+'/equit/equPhoto/Noimage.png" height= "200" width="400"></div>'+
//    			'<tpl else>'+
//        			'<div class="thumb-wrap"><img src="'+ CPATH+'/equit/equPhoto/{IMAGE_FID}.{IMG_TYPE}" height= "200" width="400"></div>'+
//    			'</tpl>'+
         	  '</tpl>'
         	  ],*/
//        itemSelector: 'div.data-source ',
//		height:320,
        flex:1,
		width:300,
//        region: 'center',
        store: imageViewStore2,
        frame:true,
		trackOver: true,
		itemSelector: 'div.thumb-wrap',
        overItemCls: 'x-item-over',
        scrollable:true,
        border:true,
        style:{
        		'background-color': '#fff' ,
        		'border': '1px solid #9598a8; '
        }
//        border:true
	});
	var panelImage = Unilite.createSearchForm('panelImage',{
        region: 'center',
        layout : {type : 'uniTable', columns : 2},
        padding:'1 1 1 1',
        border:true,
        height	: 500,
        split:true,
//		flex:4,
        items: [
        imagesView1,
        	imagesView2

    /*
        {
			xtype:'uniFieldset',
	        layout: {type: 'vbox', align:'stretch'},
//	        padding: '5 5 5 5',
	        flex:1,
			width:'100%',
//            height:300,
	        items :[
	        	imagesView1

	        ]
	    },{
			xtype:'uniFieldset',
	        layout: {type: 'vbox', align:'stretch'},
//	        padding: '5 5 5 5',
	        flex:1,
//			width:500,
//            height:300,
	        items :[
	        	imagesView2

	        ]
	    }*/


//        imagesView1,
//        	imagesView2
	    ]
	});



    Unilite.Main( {
        borderItems:[{
                region:'center',
                layout: 'border',
                border: false,
                items:[
                	panelResult,
                	{
	                    region: 'center',
	                    xtype: 'container',
	                    layout: 'fit',
	                    layout: {type:'vbox', align:'stretch'},
	                    split:true,
	                    flex: 1,
	                    items: [ masterGrid,subGrid]
	                },
                	{
	                    region: 'east',
	                    xtype: 'container',
	                    layout: 'fit',
	                    layout: {type:'vbox', align:'stretch'},
	                    split:true,
	                    width:580,
//	                    flex: 3,
	                    items: [ equInfoGrid//,panelImage/*itemImageForm,*/
	                    	,{
			                    region: 'east',
			                    xtype: 'container',
			                    layout: 'fit',
			                    layout: {type:'hbox', align:'stretch'},
			                    split:true,
			                    flex: 3,
//			                    title:'금형사진/부품사진',
			                    items: [imagesView1,imagesView2//,panelImage/*itemImageForm,*/

								]
							}
						]
					}
/*	                    		{

			xtype:'uniFieldset',
//			layout: {
//	            type: 'uniTable',
//	            columns: 1,
//	            tdAttrs: {valign:'top'}
//	        },

	        layout: {type: 'vbox', align:'stretch'},
	        padding: '5 5 5 5',
//			width:430,
            height:500,
	        items :[
	        	imagesView
	        ]

		}*/



                ]
            }
        ],
        id  : 'equ201ukrvApp',
        fnInitBinding : function() {
            this.setDefault();
        },
        onQueryButtonDown : function()  {
            if(!panelResult.getInvalidMessage()) return;   //필수체크
            masterStore.loadStoreRecords();
	    	activeGridId = masterGrid.getItemId();
        },
        onResetButtonDown: function() {
            panelResult.clearForm();
            masterGrid.reset();
            masterStore.clearData();
            subGrid.reset();
            subStore.clearData();
            this.setDefault();
        },

        onNewDataButtonDown: function()	{
			if(!panelResult.getInvalidMessage()) return;   // 필수체크
			if(activeGridId == 'masterGrid'){
				if(masterStore.isDirty()){
					Unilite.messageBox('금형정보에 이미 작업중인 데이터가 있습니다.');
				}else{
		        	var r = {
		        		'COMP_CODE':UserInfo.compCode,
		        		'DIV_CODE':panelResult.getValue("DIV_CODE")

		        	};

	//	            subGrid.reset();
	//	            subStore.clearData();
		        	masterGrid.createRow(r);
				}
			}else if(activeGridId == 'subGrid'){
				var record = masterGrid.getSelectedRecord();
				if(Ext.isEmpty(record) || record.phantom == true){
					Unilite.messageBox('저장된 금형정보를 먼저 선택해주세요.');
//                   ,'<t:message code="system.message.human.message003" default="미입력항목: "/>'+invalidFieldNames);

				}else{

					if(subStore.isDirty()){
						Unilite.messageBox('코어정보에 이미 작업중인 데이터가 있습니다.');
					}else{
			        	var r = {
			        		'COMP_CODE':UserInfo.compCode,
			        		'DIV_CODE':panelResult.getValue("DIV_CODE"),
							'EQU_CODE':record.get("EQU_CODE")
			        	};
			        	subGrid.createRow(r);
					}
				}
			}

//			equInfoGrid.setDisabled(true);
//    		detailForm.setDisabled(false);
//    		equInfoGrid.setDisabled(true);
//        	panelResult.getField('DIV_CODE').setReadOnly(true);
//        	detailForm.getField('EQU_CODE').setReadOnly(false);
        },

        onSaveDataButtonDown: function() {
			if(!panelResult.getInvalidMessage()) return;   // 필수체크

            if(masterStore.isDirty()) {
                masterStore.saveStore();
            }
            if(subStore.isDirty()) {
                subStore.saveStore();
            }

        },
        onDeleteDataButtonDown: function() {
            var param = panelResult.getValues();

            if(activeGridId == 'masterGrid') {
                var record = masterGrid.getSelectedRecord();
                var count = subGrid.getStore().getCount();

                if(record.phantom == true) {
                    masterGrid.deleteSelectedRow();
                } else {
                	if(count != 0) {
                	   alert('코어정보가 존재합니다. 코어정보를 먼저 삭제하시기 바랍니다.');
                        return false;
                	} else {
                        if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
                            masterGrid.deleteSelectedRow();
                			masterStore.saveStore();
                        }
                	}
                }
            } else if(activeGridId == 'subGrid') {
                var record = subGrid.getSelectedRecord();

                if(record.phantom == true) {
                    subGrid.deleteSelectedRow();
                } else {
                    if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
                        subGrid.deleteSelectedRow();
                    }
                }
            }

            if(masterStore.isDirty() || subStore.isDirty()) {
                UniAppManager.setToolbarButtons(['save'], true);
            } else if(!masterStore.isDirty() && !subStore.isDirty()) {
                UniAppManager.setToolbarButtons(['save'], false);
            }
        },
        setDefault: function() {
//            panelResult.setValue('ITEM_ACCOUNT','10');
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
            UniAppManager.setToolbarButtons(['save', 'delete', 'deleteAll'],false);
            UniAppManager.setToolbarButtons(['reset','newData'], true);

	    	masterGrid.changeFocusCls(Ext.getCmp('subGrid'));
	    	activeGridId = masterGrid.getItemId();
	    	equInfoGrid.setDisabled(true);
//			panelResult.setValue('CHECK_YN', 'Y');
        	/* if(BsaCodeInfo.gsAuthorityLevel != '15'){//관리자
            	inputTable.down('#upLoad').setReadOnly(true);
        	} */



//        	statusGrid.createRow({GUBUN: "값",EQU_TYPE:"01",CORE_TYPE: "01"});

        }
    });
}
</script>