<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="equ270skrv"  >
    <t:ExtComboStore comboType="BOR120"  pgmId="equ270skrv"  />             <!-- 사업장 -->
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

function appMain() {

    var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read: 'equ270skrvService.selectList'
//            update: 'equ270skrvService.updateList',
//            syncAll: 'equ270skrvService.saveAll'
        }
    });

    Unilite.defineModel('statusModel', {
        fields: [
            {name: 'GUBUN'            ,text:'조건'        ,type: 'string'},
            {name: 'EQU_TYPE'             ,text:'몰드타입'         ,type: 'string',comboType:'AU', comboCode:'I802'},
            {name: 'CORE_TYPE'             ,text:'게이트방식'        ,type: 'string', comboType:'AU', comboCode:'I806'}
        ]
    });
    
    Unilite.defineModel('equ270skrvModel', {
        fields: [
            {name: 'COMP_CODE'            ,text:'법인코드'        ,type: 'string'},
            {name: 'DIV_CODE'             ,text:'사업장'         ,type: 'string'},
            {name: 'EQU_CODE'             ,text:'몰드번호'        ,type: 'string'},
            {name: 'MODEL_CODE'           ,text:'모델코드'        ,type: 'string'},
            {name: 'CORE_CODE'            ,text:'코어번호'        ,type: 'string'},
            {name: 'CORE_NAME'            ,text:'품명'           ,type: 'string'},
            {name: 'CORE_SPEC'            ,text:'규격'           ,type: 'string'},
            {name: 'PRODT_TYPE'           ,text:'부품타입'        ,type: 'string', comboType:'AU', comboCode:'I808'},
            {name: 'EQU_TYPE'             ,text:'몰드타입'        ,type: 'string', comboType:'AU', comboCode:'I802'},
            {name: 'CORE_TYPE'            ,text:'게이트방식'       ,type: 'string', comboType:'AU', comboCode:'I806'},
            {name: 'CORE_FORM'            ,text:'코아형상'        ,type: 'string', comboType:'AU', comboCode:'I810'},
            {name: 'CORE_SIZE'            ,text:'코어치수'        ,type: 'string'},
            {name: 'CAVITY_Q'             ,text:'캐비티수'        ,type: 'string'},
            {name: 'CORE_METHOD'          ,text:'슬라이드유무'     ,type: 'string', comboType:'AU', comboCode:'I809'},
            {name: 'PRODT_MTRL'           ,text:'원료'           ,type: 'string'},
            {name: 'EQU_SIZE'             ,text:'몰드치수'        ,type: 'string'},
            {name: 'PRODT_SIZE'           ,text:'부품치수'        ,type: 'string'},
            {name: 'REMARK'               ,text:'비고'           ,type: 'string'}
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
    
    
    /**
     * Store 정의(Service 정의)
     * @type
     */
    var directMasterStore = Unilite.createStore('equ270skrvMasterStore1',{
        model: 'equ270skrvModel',
        uniOpt : {
            isMaster:  true,            // 상위 버튼 연결
            editable:  false,            // 수정 모드 사용
            deletable: false,           // 삭제 가능 여부
            useNavi :  false            // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy,
        loadStoreRecords : function()   {
            var param= panelResult.getValues();
            this.load({
                  params : param
            });
        },
 /*       saveStore: function(index) {
            var inValidRecs = this.getInvalidRecords();
            var paramMaster= panelResult.getValues();    //syncAll 수정
            if(inValidRecs.length == 0 )    {
                var config = {
                    params: [paramMaster],
                    success: function(batch, option) {
                        if(directMasterStore.getCount() == 0){
                            UniAppManager.app.onResetButtonDown();
                            return false;
                        }
                        var master = batch.operations[0].getResultSet();
                        var fp = inputTable.down('xuploadpanel');                  //mask on
                        fp.loadData({});
                        fp.getEl().mask('로딩중...','loading-indicator');
                        equ270skrvService.getFileList({ITEM_CODE : master.ITEM_CODE},              //파일조회 메서드  호출(param - 파일번호)
                            function(provider, response) {
                                fp.loadData(response.result);                       //업로드 파일 load해서 보여주기
                                fp.getEl().unmask();                                //mask off
                            }
                         );
                        UniAppManager.setToolbarButtons('save', false);
                        UniAppManager.setToolbarButtons('newData', false);
                        directMasterStore.loadStoreRecords();
                        if(index){
                            masterGrid.getSelectionModel().select(index);
                        }
                     }
                };
                this.syncAllDirect(config);
            }else {
                masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
            }
        },*/
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
            name:'DIV_CODE',
            xtype: 'uniCombobox',
            comboType:'BOR120',
            allowBlank:false,
            holdable: 'hold',
            value: UserInfo.divCode,
            colspan:5
        },{
			fieldLabel: '몰드타입',
			name: 'EQU_TYPE',
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'I802'
		},{
			fieldLabel: '게이트방식',
			name: 'CORE_TYPE',
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'I806'
		},{
			fieldLabel: '코아형상',
			name: 'CORE_FORM',
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'I810'
		},{
			fieldLabel: '슬라이드유무',
			name: 'CORE_METHOD',
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'I809'
		},{
        	fieldLabel: '원료',
			xtype: 'uniTextfield',
			name:'PRODT_MTRL'
	    },
	    {
			xtype: 'container',
			layout: { type: 'uniTable', columns: 2},
			defaults : {enforceMaxLength: true},
			items:[{
				fieldLabel: '(부품치수)가로',
				name: 'PRODT_SIZE_W',
				xtype: 'uniNumberfield',
				decimalPrecision: 0
			},{
				name: 'PRODT_SIZE_W_SUB',
				xtype: 'uniNumberfield',
				width: 50,
				decimalPrecision: 0
			}]
	    },{
			xtype: 'container',
			layout: { type: 'uniTable', columns: 2},
			defaults : {enforceMaxLength: true},
			items:[{
				fieldLabel: '세로',
				name: 'PRODT_SIZE_L',
				xtype: 'uniNumberfield',
				decimalPrecision: 0
			},{
				name: 'PRODT_SIZE_L_SUB',
				xtype: 'uniNumberfield',
				width: 50,
				decimalPrecision: 0
			}]
	    },{
			xtype: 'container',
			layout: { type: 'uniTable', columns: 2},
			defaults : {enforceMaxLength: true},
			items:[{
				fieldLabel: '높이',
				name: 'PRODT_SIZE_H',
				xtype: 'uniNumberfield',
				decimalPrecision: 0
			},{
				name: 'PRODT_SIZE_H_SUB',
				xtype: 'uniNumberfield',
				width: 50,
				decimalPrecision: 0
			}]
	    },{
			xtype: 'container',
			layout: { type: 'uniTable', columns: 2},
			defaults : {enforceMaxLength: true},
			items:[{
				fieldLabel: '직경',
				name: 'PRODT_SIZE_P',
				xtype: 'uniNumberfield',
				decimalPrecision: 0
			},{
				name: 'PRODT_SIZE_P_SUB',
				xtype: 'uniNumberfield',
				width: 50,
				decimalPrecision: 0
			}]
	    },{
			fieldLabel: '캐비티수',
			name: 'CAVITY_Q',
			xtype: 'uniNumberfield',
			decimalPrecision: 0
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
    

    var masterGrid = Unilite.createGrid('equ270skrvmasterGrid', {
        layout : 'fit',
        region: 'west',
        flex:2,
        store: directMasterStore,
        split:true,
        selModel: 'rowmodel',
        uniOpt: {
            expandLastColumn: false,
            useMultipleSorting: true,
            useGroupSummary: false,
            useLiveSearch: true,
            useContextMenu: true,
            useRowNumberer: false,
            filter: {
                useFilter: true,
                autoCreate: true
            }
        },
        columns:  [
            { dataIndex: 'COMP_CODE'           , width: 80, hidden: true},
            { dataIndex: 'DIV_CODE'            , width: 80, hidden: true},
            { dataIndex: 'EQU_CODE'            , width: 100},
            { dataIndex: 'MODEL_CODE'          , width: 100},
            { dataIndex: 'CORE_CODE'           , width: 100},
            { dataIndex: 'CORE_NAME'            , width: 150},
            { dataIndex: 'CORE_SPEC'            , width: 150},
            { dataIndex: 'PRODT_TYPE'          , width: 100},
            { dataIndex: 'EQU_TYPE'            , width: 100},
            { dataIndex: 'CORE_TYPE'           , width: 100},
            { dataIndex: 'CORE_FORM'           , width: 100},
            { dataIndex: 'CORE_SIZE'           , width: 120},
            { dataIndex: 'CAVITY_Q'            , width: 80,align:'center'},
            { dataIndex: 'CORE_METHOD'         , width: 100},
            { dataIndex: 'PRODT_MTRL'          , width: 100},
            { dataIndex: 'EQU_SIZE'            , width: 100},
            { dataIndex: 'PRODT_SIZE'          , width: 120},
            { dataIndex: 'REMARK'              , width: 100}
        ],
		viewConfig: {
	        getRowClass: function(record, rowIndex, rowParams, store){
	        	var cls = '';
	        	if(record.get('CORE_CODE').substring(record.get('CORE_CODE').length-1) != 0){
					cls = 'x-change-cell';	
				}
				return cls;
	        }
	    },
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
        /*	beforeedit  : function( editor, e, eOpts ) {
        		if(BsaCodeInfo.gsAuthorityLevel != '15'){//관리자
        			return false;
        		}else{
	                if(UniUtils.indexOf(e.field, ['CUSTOM_CODE','DISTRIB_DATE','GUBUN_NUM','REVIS_DATE','LOCATION','REMARK']))
                    {
                        return true;
                    } else {
                        return false;
                    }
        		}
            },*/
            beforeselect : function ( gird, record, index, eOpts ){
            	
            	
             /*   var isNewCardShow = true;      //newCard 보여줄것인지?
                var fp = inputTable.down('xuploadpanel');                  //mask on
                var addFiles = fp.getAddFiles();
                var removeFiles = fp.getRemoveFiles();

				if(BsaCodeInfo.gsAuthorityLevel == '15'){//관리자
	                if(!Ext.isEmpty(addFiles + removeFiles) && !record.phantom){
	                    isNewCardShow = false;
	                    Ext.Msg.show({
	                       title:'확인',
	                       msg: Msg.sMB017 + "\n" + Msg.sMB061,
	                       buttons: Ext.Msg.YESNOCANCEL,
	                       icon: Ext.Msg.QUESTION,
	                       fn: function(res) {
	                          if (res === 'yes' ) {
	                            UniAppManager.app.onSaveDataButtonDown(index);
	                          } else if(res === 'no') {
	                              UniAppManager.setToolbarButtons('save', false);
	                              fp.loadData({});
	                              masterGrid.getSelectionModel().select(index);
	                          }
	                       }
	                  });
	                }
				}
                return isNewCardShow;
                */
                
            },
            selectionchange:function( model1, selected, eOpts ){
        	
		      		if(selected.length > 0) {
						var record = selected[0];
						equInfoStore.loadData({});
						equInfoStore.loadStoreRecords(record);
						imageViewStore.loadData({});
						imageViewStore.loadStoreRecords(record);
					}

	      		
            	
/*                var record = selected[0];
                inputTable.loadForm(selected);
                var fp = inputTable.down('xuploadpanel');                  //mask on
                if(directMasterStore.getCount() > 0 && record && !record.phantom){
                    fp.loadData({});
                    fp.getEl().mask('로딩중...','loading-indicator');
                    var itemCode = record.data.ITEM_CODE;
                    equ270skrvService.getFileList({ITEM_CODE : itemCode},              //파일조회 메서드  호출(param - 파일번호)
                        function(provider, response) {
                            fp.loadData(response.result);                       //업로드 파일 load해서 보여주기
                            fp.getEl().unmask();                                //mask off
    //                        UniAppManager.setToolbarButtons('save',false);      //저장버튼 비활성화
                        }
                     );
                }
                */
                
            }
        }
    });

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

	//품목 정보 관련 파일 업로드
	var equInfoProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'equ270skrvService.getEquInfo'
		}
	});

	var equInfoStore = Unilite.createStore('equInfoStore',{
		model	: 'equInfoModel',
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,		// 상위 버튼 연결
			editable	: false,			// 수정 모드 사용
			deletable	: false,			// 삭제 가능 여부
			useNavi		: false			// prev | next 버튼 사용
		},

		proxy: equInfoProxy,

		loadStoreRecords : function(record){
			var searchParam = Ext.getCmp('resultForm').getValues();
			var param = {
				'DIV_CODE' : record.get('DIV_CODE'),
				'CORE_CODE' : record.get('CORE_CODE')
			};
			var params = Ext.merge(searchParam, param);
			console.log( param );
			this.load({
				params : params,
				callback : function(records,options,success)    {
					isItemGridUseChange = false;
				}
			});
		},

		listeners: {
			update:function( store, record, operation, modifiedFieldNames, eOpts ){
			},
			metachange:function( store, meta, eOpts ){
			}
		}
	});

	var equInfoGrid = Unilite.createGrid('equInfoGrid', {
		region:'north',
		store	: equInfoStore,
		border	: true,
		height	: 250,
//		flex:1,
		//width	: '100%',
		//padding	: '0 0 5 0',
		sortableColumns : false,
		selModel:'rowmodel',
		//excelTitle: '관련파일',
		uniOpt	:{
			onLoadSelectFirst	: false,
			expandLastColumn	: false,
			useRowNumberer		: true,
			useMultipleSorting	: false
//			enterKeyCreateRow: true							//마스터 그리드 추가기능 삭제
		},

		columns:[
				{ dataIndex	: 'COMP_CODE'			, width: 80			,hidden : true },
				{ dataIndex	: 'DIV_CODE'			, width: 80			,hidden : true },
				{ dataIndex	: 'EQU_CODE'			, width: 80			,hidden : true },
				{ dataIndex	: 'FILE_TYPE'			, width: 80, align: 'center'},
				{ dataIndex	: 'MANAGE_NO'			, width: 80, align: 'center'},
				{ dataIndex	: 'CERT_FILE'			, width: 400,
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
				}
		],
		listeners: {
			beforeedit: function( editor, e, eOpts ) {
		/*		if(!e.record.phantom) {
					if (UniUtils.indexOf(e.field, ['FILE_TYPE', 'MANAGE_NO', 'CERT_FILE','COMP_CODE','DIV_CODE','EQU_CODE','UPDATE_DB_TIME'])){
						return false;
					}

				} else {
					if (UniUtils.indexOf(e.field, ['CERT_FILE','COMP_CODE','DIV_CODE','EQU_CODE','UPDATE_DB_TIME'])){
						return false;
					}
				}*/
			},
			select: function(grid, selectRecord, index, rowIndex, eOpts ){
			},
			cellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
	/*			if( cellIndex == 6 &&  !Ext.isEmpty(record.get('CERT_FILE'))) {
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
				}*/
			}
		}
	});
	Unilite.defineModel('imageViewModel', {
	    fields: [ 
	    	{name: 'IMAGE_FID'		, text:'이미지id'	, type: 'string'},
	    	{name: 'IMG_TYPE'		, text:'이미지타입'	, type: 'string'},
	    	{name: 'IMG_NAME'		, text:'이미지명'	, type: 'string'}
		]
	});
	var imageViewStore = Unilite.createStore('imageViewStore', {
		model: 'imageViewModel',
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
            	   read : 'equ270skrvService.imagesList'
            }
        },
		loadStoreRecords: function(record) {
//			var param= panelResult.getValues();	
			var param = {
				'DIV_CODE' : record.get('DIV_CODE'),
				'EQU_CODE' : record.get('EQU_CODE')
			};
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
	var imagesView = Ext.create('Ext.view.View', {
		tpl: ['<tpl for=".">'+
         	
        		'<div class="thumb-wrap"><img src="'+ CPATH+'/equit/equPhoto/{IMAGE_FID}" height= "200" width="400"></div>'+
         	  '</tpl>'
         	  ],
//        itemSelector: 'div.data-source ',
//		height:320,
//		width:1000,
        flex:1,
        store: imageViewStore,
        frame:true,
		trackOver: true,
		itemSelector: 'div.thumb-wrap',
        overItemCls: 'x-item-over',
        scrollable:true
	});
	
	var panelImage = Unilite.createSearchForm('panelImage',{
        region: 'center',
        layout : {type : 'uniTable', columns : 1},
        padding:'1 1 1 1',
        border:true,
        height	: 400,
        split:true,
//		flex:4,
        items: [imagesView
        	
        		
     /*   			{	
			xtype:'uniFieldset',
	        layout: {type: 'vbox', align:'stretch'},
//	        padding: '5 5 5 5',
	        flex:1,
			width:1000,
//            height:300,
	        items :[
	        	imagesView
	        
	        ]
	    }*/
	    
	    
	    ]
	});
	
	
    
    Unilite.Main( {
        borderItems:[{
                region:'center',
                layout: 'border',
                border: false,
                items:[
                	panelResult,masterGrid,
                	
                	{
	                    region: 'center',
	                    xtype: 'container',
	                    layout: 'fit',
	                    layout: {type:'vbox', align:'stretch'},
	                    flex: 1,
	                    items: [ equInfoGrid,panelImage]
	                }
                	
                	
                	
//                    statusForm,masterGrid,inputTable

//                    {
//                    region: 'center',
//                    xtype: 'container',
//                    layout: 'fit',
//                    layout: {type:'vbox', align:'stretch'},
////                    flex: 4,
//                    items: [  inputTable]
//                }
//

                ]
            }
        ],
        id  : 'equ270skrvApp',
        fnInitBinding : function() {
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
            UniAppManager.setToolbarButtons(['save', 'newData', 'delete', 'deleteAll'],false);

            this.setDefault();
        },
        onQueryButtonDown : function()  {
            if(!panelResult.getInvalidMessage()) return;   //필수체크
            directMasterStore.loadStoreRecords();
            UniAppManager.setToolbarButtons(['reset'], true);
        },
        onResetButtonDown: function() {
            panelResult.setAllFieldsReadOnly(false);
            panelResult.clearForm();
            masterGrid.reset();
            directMasterStore.clearData();
            this.setDefault();
        },
        setDefault: function() {
//            panelResult.setValue('ITEM_ACCOUNT','10');
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
            UniAppManager.setToolbarButtons(['save'], false);
        
//			panelResult.setValue('CHECK_YN', 'Y');
        	/* if(BsaCodeInfo.gsAuthorityLevel != '15'){//관리자
            	inputTable.down('#upLoad').setReadOnly(true);
        	} */
 
        	
        	
//        	statusGrid.createRow({GUBUN: "값",EQU_TYPE:"01",CORE_TYPE: "01"});

        }
    });
}
</script>