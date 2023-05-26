<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_zbb600ukrv_kd"  >
    <t:ExtComboStore comboType="BOR120"  pgmId="s_zbb600ukrv_kd"  />             <!-- 사업장 -->
    <t:ExtComboStore comboType="AU" comboCode="WB04" />             <!-- 차종  -->
    <t:ExtComboStore comboType="AU" comboCode="WZ33" />             <!-- 거래처  -->
    <t:ExtComboStore comboType="AU" comboCode="B020" /> 			<!-- 품목계정 -->
</t:appConfig>
<script type="text/javascript" charset="UTF-8" src='<c:url value="/resources/plupload/plupload.full.js" />' >
</script>
<script type="text/javascript" >

var BsaCodeInfo = {     //컨트롤러에서 값을 받아옴.
    gsAutoType  :   '${gsAutoType}',

	gsAuthorityLevel: '${gsAuthorityLevel}'
};
var gsAuthLevel = ''
if(BsaCodeInfo.gsAuthorityLevel == '15' || UserInfo.deptName == '설계팀'){
	gsAuthLevel = 'ADMIN';
}

function appMain() {
	var addCnt = 0; //폼만 수정시 강제 저장 일으키기 위한 cnt
	var isAutoOrderNum = false;
    if(BsaCodeInfo.gsAutoType=='Y') {
        isAutoOrderNum = true;
    }

    var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read: 's_zbb600ukrv_kdService.selectList',
            update: 's_zbb600ukrv_kdService.updateList',
            syncAll: 's_zbb600ukrv_kdService.saveAll'
        }
    });

    /**
     *   Model 정의
     * @type
     */
    Unilite.defineModel('s_zbb600ukrv_kdModel', {
        fields: [
            {name: 'COMP_CODE'            ,text:'법인코드'         ,type: 'string'},
            {name: 'DIV_CODE'             ,text:'사업장'           ,type: 'string'},
            {name: 'CUSTOM_CODE'             ,text:'업체구분'           ,type: 'string', comboType:'AU', comboCode:'WZ33'},
            {name: 'ITEM_CODE'            ,text:'품목코드'         ,type: 'string'},
            {name: 'ITEM_NAME'            ,text:'품명'           ,type: 'string'},
            {name: 'SPEC'        			,text:'품번'             ,type: 'string'},
            {name: 'CAR_TYPE'             ,text:'차종'             ,type: 'string', comboType:'AU', comboCode:'WB04'},
            {name: 'DISTRIB_DATE'               ,text:'배포일'             ,type: 'uniDate'},
            {name: 'GUBUN_NUM'               ,text:'차수'             ,type: 'int'},
            {name: 'REVIS_DATE'               ,text:'개정일'             ,type: 'uniDate'},
            {name: 'LOCATION'               ,text:'위치'             ,type: 'string'},
            {name: 'ITEM_ACCOUNT'		    	, text: '품목계정'    	, type: 'string', comboType:'AU',comboCode:'B020'},
            {name: 'REMARK'               ,text:'비고'             ,type: 'string'},
            {name: 'ROW_NUM'               ,text:'순번'             ,type: 'int'},
            {name: 'MAIN_CUSTOM_CODE'               ,text:'주거래처코드'             ,type: 'string'},
            {name: 'MAIN_CUSTOM_NAME'               ,text:'주거래처'             ,type: 'string'}
        ]
    });

    /**
     * Store 정의(Service 정의)
     * @type
     */
    var directMasterStore = Unilite.createStore('s_zbb600ukrv_kdMasterStore1',{
        model: 's_zbb600ukrv_kdModel',
        uniOpt : {
            isMaster:  true,            // 상위 버튼 연결
            editable:  true,            // 수정 모드 사용
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
        saveStore: function(index) {
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
                        s_zbb600ukrv_kdService.getFileList({ITEM_CODE : master.ITEM_CODE},              //파일조회 메서드  호출(param - 파일번호)
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
        },
		listeners:{
			load:function(store, records, successful, eOpts)	{
				if(Ext.isEmpty(records)){
        			inputTable.down('xuploadpanel').loadData({}); 
        			inputTable.disable();
				}
			}
		}
    }); // End of var directMasterStore1

    /**
     * 검색조건 (Search Panel)
     * @type
     */
    var panelResult = Unilite.createSearchForm('resultForm',{
        region: 'north',
        layout : {type : 'uniTable', columns : 3},
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
            },{
				fieldLabel: '업체구분',
				name: 'CUSTOM_CODE',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'WZ33'
            },
            {
                fieldLabel: '품목계정',
                name: 'ITEM_ACCOUNT',
                xtype: 'uniCombobox',
                comboType: 'AU',
                comboCode: 'B020',
                allowBlank:true,
                value: '10',
                readOnly: false,
                holdable: 'hold'
            },
            Unilite.popup('DIV_PUMOK',{
                    fieldLabel: '품목코드',
                    valueFieldName:'ITEM_CODE',
                    textFieldName:'ITEM_NAME',
                    validateBlank:false,
                    autoPopup:true,
                    holdable: 'hold',
                    listeners: {
                    	onSelected: {
    						fn: function(records, type) {
    							console.log('records : ', records);
    							panelResult.setValue('OEM_ITEM_CODE', records[0].SPEC);

    						},
    						scope: this
    					},
    					onClear: function(type) {

    						panelResult.setValue('ITEM_CODE', '');
    						panelResult.setValue('ITEM_NAME', '');
    						panelResult.setValue('OEM_ITEM_CODE', '');

    					},
                    	applyextparam: function(popup){
                            popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
                        }
                    }
            }),{
                fieldLabel: '품번',
                name:'OEM_ITEM_CODE',
                xtype: 'uniTextfield',
                holdable: 'hold'
            },{
                xtype: 'radiogroup',
                fieldLabel: '등록여부',
                labelWidth: 100,
                id: 'radioSelect1',
                items : [{
                        boxLabel: '전체',
                        name: 'CHECK_YN',
                        inputValue: 'A',
                        width:50
                    },{
                        boxLabel: '등록',
                        name: 'CHECK_YN' ,
                        inputValue: 'Y',
                        width:50,
                        checked: true
                    },{
                        boxLabel: '미등록',
                        name: 'CHECK_YN' ,
                        inputValue: 'N',
                        width:70
                    }
                ]
            },{
				fieldLabel: '배포일',
				xtype: 'uniDateRangefield',
				startFieldName: 'DISTRIB_DATE_FR',
				endFieldName: 'DISTRIB_DATE_TO',
				width: 315,
				startDate: UniDate.get('startOfYear'),
				endDate: UniDate.get('today')
			},{
				fieldLabel: '차종',
				name: 'CAR_TYPE',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'WB04'
            }/*,{
                fieldLabel: '비고',
                name:'REMARK',
                xtype: 'textareafield',
                name: 'INIT_PAY',
                height : 40,
                width: 325,
                holdable: 'hold'
            }*/,{
                fieldLabel: '비고',
                name:'REMARK',
                xtype: 'uniTextfield',
                holdable: 'hold',
                width: 478
            },{
                fieldLabel: '삭제파일FID'   ,       //삭제 파일번호를 set하기 위한 hidden 필드
                name:'DEL_FID',
                readOnly:true,
                hidden:true
            },{
                fieldLabel: '등록파일FID'   ,       //등록 파일번호를 set하기 위한 hidden 필드
                name:'ADD_FID',
                readOnly:true,
                hidden:true
            }
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
        },
        setLoadRecord: function(record) {
            var me = this;
            me.uniOpt.inLoading=false;
            me.setAllFieldsReadOnly(true);
        }
    });

    var inputTable = Unilite.createSearchForm('detailForm', { //createForm
        layout : {type : 'uniTable', columns : 1},
        disabled: false,
        border:true,
        padding:'1 1 1 1',
        flex:1,
        autoScroll:true,
//        title: '파일업로드',
        region: 'center',
//        masterGrid: masterGrid,
        items: [{
                xtype: 'xuploadpanel',
                itemId:'upLoad',
                id	: 's_zbb600ukrvFileUploadPanel',
                height: 500,
                width: 800,
//                flex:1,
//                border:false,
                padding: '-5 0 0 0',
//                labelWidth: 100,
//                width: 800,
//                colspan: 2,
                listeners : {
                    change: function() {
                        if(directMasterStore.count() > 0){
        					if(BsaCodeInfo.gsAuthorityLevel == '15'){//관리자
                           		UniAppManager.app.setToolbarButtons('save', true);  //파일 추가or삭제시 저장버튼 on
        					}
                        }

                    }
                }
            }],
            loadForm: function(record)  {
                // window 오픈시 form에 Data load
                var count = masterGrid.getStore().getCount();
                if(count > 0) {
                    this.reset();
                    this.setActiveRecord(record[0] || null);
                    this.resetDirtyStatus();
                }
            }
    });

    var masterGrid = Unilite.createGrid('s_zbb600ukrv_kdmasterGrid', {
        layout : 'fit',
        region: 'west',
        flex:2,
        store: directMasterStore,
        split:true,
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
            { dataIndex: 'COMP_CODE'           ,           width: 80, hidden: true},
            { dataIndex: 'DIV_CODE'            ,           width: 80, hidden: true},
            { dataIndex: 'ROW_NUM'         	   ,           width: 50, align:'center'},
            { dataIndex: 'CUSTOM_CODE'         ,           width: 100},
            { dataIndex: 'ITEM_CODE'           ,           width: 100},
            { dataIndex: 'ITEM_NAME'           ,           width: 100},
            { dataIndex: 'SPEC'        	       ,           width: 100},
            { dataIndex: 'CAR_TYPE'            ,           width: 100},
            { dataIndex: 'DISTRIB_DATE'        ,           width: 100},
            { dataIndex: 'GUBUN_NUM'           ,           width: 100},
            { dataIndex: 'REVIS_DATE'          ,           width: 100},
            { dataIndex: 'LOCATION'            ,           width: 100},
            { dataIndex: 'ITEM_ACCOUNT'        ,           width: 100},
            { dataIndex: 'MAIN_CUSTOM_CODE'        ,           width: 80, hidden: true},
            { dataIndex: 'MAIN_CUSTOM_NAME'        ,           width: 120},
            { dataIndex: 'REMARK'              ,           width: 100},
            { dataIndex: 'TEMP'                ,           width: 80, hidden: true}
        ],
        listeners: {
        	beforeedit  : function( editor, e, eOpts ) {
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
            },
            beforeselect : function ( gird, record, index, eOpts ){
                var isNewCardShow = true;      //newCard 보여줄것인지?
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
            },
            selectionchange:function( model1, selected, eOpts ){
                var record = selected[0];
                inputTable.loadForm(selected);
                var fp = inputTable.down('xuploadpanel');                  //mask on
                if(directMasterStore.getCount() > 0 && record && !record.phantom){
                    fp.loadData({});
                    fp.getEl().mask('로딩중...','loading-indicator');
                    var itemCode = record.data.ITEM_CODE;
                    s_zbb600ukrv_kdService.getFileList({ITEM_CODE : itemCode},              //파일조회 메서드  호출(param - 파일번호)
                        function(provider, response) {
                            fp.loadData(response.result);                       //업로드 파일 load해서 보여주기
                            fp.getEl().unmask();                                //mask off
    //                        UniAppManager.setToolbarButtons('save',false);      //저장버튼 비활성화
                        }
                     );
                }
            }
        }
    });


    Unilite.Main( {
        borderItems:[{
                region:'center',
                layout: 'border',
                border: false,
                items:[
                    panelResult,masterGrid,inputTable

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
        id  : 's_zbb600ukrv_kdApp',
        fnInitBinding : function() {
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
            UniAppManager.setToolbarButtons(['save', 'newData', 'delete', 'deleteAll'],false);

            this.setDefault();
        },
        onQueryButtonDown : function()  {
//        	if(panelResult.setAllFieldsReadOnly(true) == false){
//                return false;
//            }
            directMasterStore.loadStoreRecords();
            UniAppManager.setToolbarButtons(['reset'], true);
        },
        onResetButtonDown: function() {
            panelResult.setAllFieldsReadOnly(false);
            panelResult.clearForm();
            masterGrid.reset();
            directMasterStore.clearData();
            this.setDefault();
            var fp = inputTable.down('xuploadpanel');
            fp.loadData({});
        },
        onSaveDataButtonDown: function () {
        	var fp = inputTable.down('xuploadpanel');
            var addFiles = fp.getAddFiles();
            var removeFiles = fp.getRemoveFiles();
            panelResult.setValue('ADD_FID', addFiles);                  //추가 파일 담기
            panelResult.setValue('DEL_FID', removeFiles);               //삭제 파일 담기

            if(masterGrid.getSelectedRecord() && !Ext.isEmpty(addFiles) || !Ext.isEmpty(removeFiles) ){   //파일변경이 있을시..
                masterGrid.getSelectedRecord().set('TEMP', addCnt);        //저장을 일으키기 위해 임의로 set...
                addCnt++
            }
            directMasterStore.saveStore();
        },
        setDefault: function() {
            panelResult.setValue('ITEM_ACCOUNT','10');
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
            UniAppManager.setToolbarButtons(['save'], false);
            inputTable.disable();
			panelResult.setValue('CHECK_YN', 'Y');
        	/* if(BsaCodeInfo.gsAuthorityLevel != '15'){//관리자
            	inputTable.down('#upLoad').setReadOnly(true);
        	} */
        	if(gsAuthLevel != 'ADMIN'){
        		inputTable.down('#upLoad').setReadOnly(true);
        		Ext.getCmp('s_zbb600ukrvFileUploadPanel').dockedItems.items[1].setDisabled(true);
        	}
        }
    });
}
</script>