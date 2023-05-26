<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_mre100ukrv_kd"  >
	<t:ExtComboStore comboType="BOR120" pgmId="s_mre100ukrv_kd"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="M001" /> <!-- 발주형태 -->
	<t:ExtComboStore comboType="AU" comboCode="M201" /> <!-- 구매담당 -->
	<t:ExtComboStore comboType="AU" comboCode="M007" /> <!-- 승인여부 -->
	<t:ExtComboStore comboType="AU" comboCode="B038" /> <!-- 결제조건 -->

	<t:ExtComboStore comboType="AU" comboCode="M002" /> <!-- 진행상태 -->
    <t:ExtComboStore comboType="AU" comboCode="B020" /> <!-- 품목계정 -->
	<t:ExtComboStore comboType="AU" comboCode="B010" /> <!-- 구매요청여부 -->
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" /> <!--창고-->
	<t:ExtComboStore comboType="AU" comboCode="B004" /> <!-- 화폐 -->
	<t:ExtComboStore comboType="AU" comboCode="M301" /> <!-- 단가형태 -->
	<t:ExtComboStore comboType="AU" comboCode="B013" /> <!-- 단위 -->
    <t:ExtComboStore comboType="AU" comboCode="WB17" /> <!-- 기안 -->
    <t:ExtComboStore comboType="AU" comboCode="WB22" />             <!-- 의뢰서구분  -->
    <t:ExtComboStore comboType="AU" comboCode="B014" opts='1;2;3'/> <!-- 조달구분 -->
</t:appConfig>
<script type="text/javascript" >


var SearchInfoWindow;        //조회버튼 누르면 나오는 조회창

var BsaCodeInfo = {
	gsAutoType:     '${gsAutoType}',
	gsDefaultMoney: '${gsDefaultMoney}'
};


var outDivCode = UserInfo.divCode;
var aa = 0;
var oldDeptName = "";
var oldPersonName = "";
function appMain() {
    var groupUrl = '${groupUrl}'; //그룹웨어 호출 url

	var isAutoOrderNum = false;
	if(BsaCodeInfo.gsAutoType=='Y')	{
		isAutoOrderNum = true;
	}

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 's_mre100ukrv_kdService.selectList',
			update: 's_mre100ukrv_kdService.updateDetail',
			create: 's_mre100ukrv_kdService.insertDetail',
			destroy: 's_mre100ukrv_kdService.deleteDetail',
			syncAll: 's_mre100ukrv_kdService.saveAll'
		}
	});
	/**
	 * Model 정의
	 * @type
	 */
	Unilite.defineModel('s_mre100ukrv_kdModel', {
	    fields: [
	        {name: 'COMP_CODE'             , text: '법인코드'             , type: 'string'},
            {name: 'DIV_CODE'              , text: '사업장'               , type: 'string'},
            {name: 'ITEM_REQ_NUM'          , text: '품목의뢰번호'         , type: 'string'},
            {name: 'ITEM_REQ_SEQ'          , text: '의뢰순번'             , type: 'int', allowBlank: false},
            {name: 'ITEM_CODE'             , text: '품목코드'             , type: 'string'},
            {name: 'ITEM_NAME'             , text: '품목명'               , type: 'string'},
            {name: 'SPEC'                  , text: '규격'                 , type: 'string'},
            {name: 'STOCK_UNIT'            , text: '재고단위'             , type: 'string',comboType:'AU', comboCode:'B013', displayField: 'value'},
            {name: 'REQ_Q'                 , text: '의뢰량'               , type: 'uniQty', allowBlank: false},
            {name: 'DEPT_CODE'             , text: '의뢰부서코드'             , type: 'string'},
            {name: 'DEPT_NAME'             , text: '의뢰부서'                 , type: 'string'},
            {name: 'PERSON_NUMB'           , text: '사원'                 , type: 'string'},
            {name: 'ITEM_REQ_DATE'         , text: '의뢰일'               , type: 'uniDate'},
            {name: 'MONEY_UNIT'            , text: '화폐단위'             , type: 'string'},
            {name: 'EXCHG_RATE_O'          , text: '환율'                 , type: 'uniER'},
            {name: 'DELIVERY_DATE'         , text: '납기일'               , type: 'uniDate', allowBlank: false},
            {name: 'USE_REMARK'            , text: '용도'                 , type: 'string'},
            {name: 'GW_DOCU_NUM'           , text: '기안문서번호'           , type: 'string'},
            {name: 'GW_FLAG'               , text: '기안여부'           , type: 'string',comboType:'AU', comboCode:'WB17'},
            {name: 'NEXT_YN'               , text: '진행상태'             , type: 'string',comboType:'AU', comboCode:'B010'},
            {name: 'REMARK'                , text: '비고'                 , type: 'string'},
            {name: 'P_REQ_TYPE'                , text: '의뢰서구분'                  , type: 'string',comboType:'AU', comboCode:'WB22'},
            {name: 'SUPPLY_TYPE'                , text: '조달구분'                 , type: 'string',comboType:'AU', comboCode:'B014'},
            {name: 'SAVE_FLAG'               , text: 'SAVE_FLAG'             , type: 'string'},
        ]
	});

	/**
	 * Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore1 = Unilite.createStore('s_mre100ukrv_kdMasterStore1',{
		model: 's_mre100ukrv_kdModel',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결
           	editable: true,			// 수정 모드 사용
           	deletable: true,			// 삭제 가능 여부
           	allDeletable: true,
	        useNavi: false				// prev | newxt 버튼 사용
		},
			autoLoad: false,
		proxy: directProxy,
		listeners: {
           	load: function(store, records, successful, eOpts) {
           		this.fnSumOrderO();
           	},
           	add: function(store, records, index, eOpts) {
           		this.fnSumOrderO();
           	},
           	update: function(store, record, operation, modifiedFieldNames, eOpts) {
           		this.fnSumOrderO();
           	},
           	remove: function(store, record, index, isMove, eOpts) {
           		this.fnSumOrderO();
           	}
		},
		loadStoreRecords: function() {
			var param= panelResult.getValues();
			console.log(param);
			this.load({
				params : param,
				// NEW ADD
				callback: function(records, operation, success){
					console.log(records);
					if(success){
						if(!Ext.isEmpty(directMasterStore1.data.items[0])){
							panelResult.setValue("P_REQ_TYPE", directMasterStore1.data.items[0].data.P_REQ_TYPE);
							panelResult.setValue("SUPPLY_TYPE", directMasterStore1.data.items[0].data.SUPPLY_TYPE);
							panelResult.setValue("REMARK", directMasterStore1.data.items[0].data.REMARK);
							panelResult.setValue("PERSON_NAME", directMasterStore1.data.items[0].data.PERSON_NAME);
							panelResult.setValue("DEPT_NAME", directMasterStore1.data.items[0].data.DEPT_NAME);
							panelResult.setValue("DEPT_CODE", directMasterStore1.data.items[0].data.DEPT_CODE);
							panelResult.setValue("PERSON_NUMB", directMasterStore1.data.items[0].data.PERSON_NUMB);
							oldDeptName = directMasterStore1.data.items[0].data.DEPT_NAME;
							oldPersonName = directMasterStore1.data.items[0].data.PERSON_NAME;
						}
						panelResult.getField("ITEM_REQ_NUM").setReadOnly(true);
						panelResult.getField("ITEM_REQ_DATE").setReadOnly(true);
						panelResult.getField("DIV_CODE").setReadOnly(true);
						UniAppManager.setToolbarButtons(['save'], false);

						if(masterGrid.getStore().getCount() == 0){
							Ext.getCmp('GW').setDisabled(true);
						}else if(masterGrid.getStore().getCount() != 0){
							UniBase.fnGwBtnControl('GW',directMasterStore1.data.items[0].data.GW_FLAG);
						}
					}
				}
				//END
			});
		},
		saveStore: function() {
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);
			var toCreate = this.getNewRecords();
       		var toUpdate = this.getUpdatedRecords();
       		var toDelete = this.getRemovedRecords();
       		var list = [].concat(toUpdate, toCreate);
			console.log("list:", list);
			var paramMaster= panelResult.getValues();
			var record = masterGrid.getSelectedRecord();
			if(inValidRecs.length == 0) {

				config = {
					params: [paramMaster],
					success: function(batch, option) {
						var master = batch.operations[0].getResultSet();
						panelResult.setValue("ITEM_REQ_NUM", master.ITEM_REQ_NUM);
						panelResult.setValue("ITEM_REQ_NUM", master.ITEM_REQ_NUM);
						panelResult.getForm().wasDirty = false;
						panelResult.resetDirtyStatus();
						console.log("set was dirty to false");
						UniAppManager.setToolbarButtons('save', false);
						if(masterGrid.getStore().getCount() == 0 || record.get('GW_FLAG')== 3) {
                		    Ext.getCmp('GW').setDisabled(true);
                		} else if(masterGrid.getStore().getCount() != 0) {
                    		Ext.getCmp('GW').setDisabled(false);
                		}
						 UniAppManager.app.onQueryButtonDown();
					}
				};
				this.syncAllDirect(config);
			} else {
				var grid = Ext.getCmp('s_mre100ukrv_kdGrid');
                grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		fnSumOrderO: function() {
			console.log("=============Exec fnOrderAmtSum()");
			var sSumOrderO = Ext.isNumeric(this.sum('ORDER_O')) ? this.sum('ORDER_O'):0;
			var sSumOrderLocO = Ext.isNumeric(this.sum('ORDER_LOC_O')) ? this.sum('ORDER_LOC_O'):0;
			//panelResult.setValue('SumOrderO',sSumOrderO);
			//panelResult.setValue('SumOrderLocO',sSumOrderLocO);
		},
        listeners:{
            load: function(store, records, successful, eOpts) {
              /*   if(masterGrid.getStore().getCount() == 0) {
                    Ext.getCmp('GW').setDisabled(true);

                } else if(masterGrid.getStore().getCount() != 0) {
                    //Ext.getCmp('GW').setDisabled(false);
                     if(directMasterStore1.data.items[0].data.GW_FLAG == 'Y' || directMasterStore1.data.items[0].data.GW_FLAG == '1' || directMasterStore1.data.items[0].data.GW_FLAG == '3') {
                        UniAppManager.setToolbarButtons(['save', 'newData', 'delete'], false);
                        Ext.getCmp('GW').setDisabled(true);

                    } else {
                        UniAppManager.setToolbarButtons(['save', 'newData', 'delete'], true);
                        Ext.getCmp('GW').setDisabled(false);

                    }
                } else {
                    if(directMasterStore1.data.items[0].data.GW_FLAG == 'Y' || directMasterStore1.data.items[0].data.GW_FLAG == '1' || directMasterStore1.data.items[0].data.GW_FLAG == '3') {
                        UniAppManager.setToolbarButtons(['save', 'newData', 'delete'], false);
                        Ext.getCmp('GW').setDisabled(true);

                    } else {
                        UniAppManager.setToolbarButtons(['save', 'newData', 'delete'], true);
                        Ext.getCmp('GW').setDisabled(false);

                    }
                } */
            }
        }
	});

	/**
	 * 검색조건 (Search Panel)
	 * @type
	 */
    var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
		layout : {type : 'uniTable', columns : 2},
		padding:'1 1 1 1',
		border:true,
		items: [{
			xtype: 'container',
			layout: { type: 'uniTable', columns:3},
			defaultType: 'uniTextfield',
			defaults : {enforceMaxLength: true},
			colspan:3,
			items:[{
			fieldLabel: '사업장',
			name:'DIV_CODE',
			xtype: 'uniCombobox',
			comboType:'BOR120',
			allowBlank:false,
			holdable: 'hold',
			value: UserInfo.divCode
		},
        {
            fieldLabel:'품목의뢰번호',
            name: 'ITEM_REQ_NUM',
            xtype: 'uniTextfield',
            holdable: 'hold',
            readOnly: true
        },{
	 		fieldLabel: '의뢰일자',
	 		xtype: 'uniDatefield',
	 		name: 'ITEM_REQ_DATE',
	 		value: UniDate.get('today'),
	 		allowBlank:false,
	 		holdable: 'hold'
		}]
		},{
            xtype: 'component',
            colspan: 2,
            tdAttrs: {style: 'border-top: 1px solid #cccccc;  padding-top: 3px;' }
        },{
			xtype: 'container',
			layout: { type: 'uniTable', columns: 2},
			defaultType: 'uniTextfield',
			defaults : {enforceMaxLength: true},
			colspan:2,
			items:[

				Unilite.popup('DEPT', {
					fieldLabel: '부서',
					valueFieldName: 'DEPT_CODE',
			   	 	textFieldName: 'DEPT_NAME',
					holdable: 'hold',
					allowBlank:false,
					listeners: {
						applyextparam: function(popup){

							var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
							var deptCode = UserInfo.deptCode;	//부서정보
							var divCode = '';					//사업장
							if(authoInfo == "A"){	//자기사업장
								popup.setExtParam({'TREE_CODE': ""});
								popup.setExtParam({'DIV_CODE': UserInfo.divCode});
							}else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){	//전체권한
								popup.setExtParam({'TREE_CODE': ""});
								popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
							}else if(authoInfo == "5"){		//부서권한
								popup.setExtParam({'TREE_CODE': UserInfo.deptCode});
								popup.setExtParam({'DIV_CODE': UserInfo.divCode});
							}
						}
					}
				}),
				Unilite.popup('Employee',{
					fieldLabel: '사원',
				  	valueFieldName:'PERSON_NUMB',
				    textFieldName:'PERSON_NAME',
		            holdable: 'hold',
					autoPopup:true,
					allowBlank:false,
					 listeners: {
		                 onSelected: {
		                     fn: function(records, type) {
		                         var param= panelResult.getValues();
		                         s_mre090ukrv_kdService.selectPersonDept(param, function(provider, response)  {

		                        	 if(!Ext.isEmpty(provider)){
		                            	 panelResult.setValue('DEPT_CODE', provider[0].DEPT_CODE);
		                                 panelResult.setValue('DEPT_NAME', provider[0].DEPT_NAME);
		                             }
		                         });
		                     },
		                     scope: this
		                 }

		             }
				}),
				{
					fieldLabel: '화폐',
					name:'MONEY_UNIT1',
					fieldStyle: 'text-align: center;',
					xtype: 'uniCombobox',
					comboType:'AU',
					comboCode:'B004',
					displayField: 'value',
					allowBlank:false,
					holdable: 'hold',
					hidden:true,
					listeners: {
						blur: function( field, The, eOpts )    {
		                   UniAppManager.app.fnExchngRateO();
		                }
					}
				},
		        {
		            fieldLabel:'환율',
		            name: 'EXCHG_RATE_O1',
		            xtype: 'uniNumberfield',
		            allowBlank:false,
		            hidden:true,
		            decimalPrecision: 4,
		            value: 1,
		            holdable: 'hold'
		        },{
		            fieldLabel: '기안여부TEMP',
		            name:'GW_TEMP',
		            xtype: 'uniTextfield',
		            hidden: true
		        },{
		            fieldLabel: '의뢰서구분',
		            name:'P_REQ_TYPE',
		            xtype: 'uniCombobox',
		            comboType:'AU',
		            comboCode:'WB22',
		            holdable: 'hold',
		            allowBlank:false
		        },
		        {
		            fieldLabel: '<t:message code="Mpo501.label.SUPPLY_TYPE" default="조달구분"/>',
		            name: 'SUPPLY_TYPE',
		            xtype: 'uniCombobox',
		            comboType: 'AU',
		            comboCode: 'B014',
		            allowBlank:false,
		            value: '1'
		        },{
		            xtype: 'textareafield',
		            fieldLabel: '비고',
		            name:'REMARK',
		            grow : true,
		            holdable: 'hold',
		            width : 650,
		            height : 50,
		            colspan : 2
		        }]
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
					var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) )	{
						 	if (item.holdable == 'hold') {
								item.setReadOnly(true);
							}
						}
						if(item.isPopupField)	{
							var popupFC = item.up('uniPopupField')	;
							if(popupFC.holdable == 'hold') {
								popupFC.setReadOnly(true);
							}
						}
					})
				}
	  		} else {
	  			var fields = this.getForm().getFields();
				Ext.each(fields.items, function(item) {
					if(Ext.isDefined(item.holdable) )	{
					 	if (item.holdable == 'hold') {
							item.setReadOnly(false);
						}
					}
					if(item.isPopupField)	{
						var popupFC = item.up('uniPopupField')	;
						if(popupFC.holdable == 'hold' ) {
							item.setReadOnly(false);
						}
					}
				})
			}
			return r;
		},
        listeners: {
            uniOnChange: function(basicForm, dirty, eOpts) {
                var record = masterGrid.getSelectedRecord();
                var curDepName =  panelResult.getValue('DEPT_NAME');
                var curPersonName = panelResult.getValue('PERSON_NAME');
                	 if(!Ext.isEmpty(record) && !Ext.isEmpty(directMasterStore1.data.items)){
                	     if(directMasterStore1.data.items[0].data.GW_FLAG != '3'){
                 	    	 //if(oldDeptName != curDepName || oldPersonName != curPersonName ){
                 	    			UniAppManager.setToolbarButtons('save', true);
                                 	record.set('SAVE_FLAG', 'Y');
                 	  		 // }
                 	      }else{
                 	    	  UniAppManager.setToolbarButtons('save', false);
                 	    	  UniAppManager.setToolbarButtons('deleteAll', false);
                 	      }
                     }else{
                         UniAppManager.setToolbarButtons('save', false);
                     }
            }
        }
    });

    /**
     * Master Grid1 정의(Grid Panel)
     * @type
     */
    var masterGrid= Unilite.createGrid('s_mre100ukrv_kdGrid', {
    	region: 'center' ,
        layout: 'fit',
        excelTitle: '품목의뢰등록',
        uniOpt: {
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: false,
			useMultipleSorting: true,
			useRowNumberer: false,
			expandLastColumn: true,
    		filter: {
				useFilter: false,
				autoCreate: false
			}
        },
    	store: directMasterStore1,
    	features: [{
    		id: 'masterGridSubTotal',
    		ftype: 'uniGroupingsummary',
    		showSummaryRow: false
    	},{
    		id: 'masterGridTotal',
    		ftype: 'uniSummary',
    		showSummaryRow: false
    	}],
    	tbar: [
    	   {
                itemId : 'GWBtn',
                id:'GW',
                iconCls : 'icon-referance'  ,
                text:'기안',
                handler: function() {
                    var param = panelResult.getValues();
                    param.DRAFT_NO = UserInfo.compCode + panelResult.getValue('ITEM_REQ_NUM');
                    if(confirm('기안 하시겠습니까?')) {
                        s_mre100ukrv_kdService.selectGwData(param, function(provider, response) {
                            if(Ext.isEmpty(provider[0]) || provider[0].GW_FLAG != '1' || provider[0].GW_FLAG != '3') {
                                panelResult.setValue('GW_TEMP', '기안중');
                                s_mre100ukrv_kdService.makeDraftNum(param, function(provider2, response)   {
                                    UniAppManager.app.requestApprove();
                                });
                            } else {
                                alert('이미 기안된 자료입니다.');
                                return false;
                            }
                        });
                    }
                    UniAppManager.app.onQueryButtonDown();
                }
            }
    	],
        columns: [
            { dataIndex: 'COMP_CODE'            ,  width: 100, hidden: true},
            { dataIndex: 'DIV_CODE'             ,  width: 100, hidden: true},
            { dataIndex: 'ITEM_REQ_NUM'         ,  width: 100, hidden: true},
            { dataIndex: 'ITEM_REQ_SEQ'         ,  width: 80},
            {dataIndex: 'ITEM_CODE'                 ,       width: 110,
                    editor: Unilite.popup('DIV_PUMOK_G', {
                        textFieldName: 'ITEM_CODE',
                        DBtextFieldName: 'ITEM_CODE',
                        extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode, POPUP_TYPE: 'GRID_CODE'},
			    		autoPopup: true,
                        listeners: {'onSelected': {
                                fn: function(records, type) {
                                    console.log('records : ', records);
                                    Ext.each(records, function(record,i) {
                                        console.log('record',record);
                                        if(i==0) {
                                            masterGrid.setItemData(record,false, masterGrid.uniOpt.currentRecord);
                                        } else {
                                            UniAppManager.app.onNewDataButtonDown();
                                            masterGrid.setItemData(record,false, masterGrid.getSelectedRecord());
                                        }
                                    });
                                },
                                scope: this
                            },
                            'onClear': function(type) {
                                masterGrid.setItemData(null,true, masterGrid.uniOpt.currentRecord);
                            },
                            applyextparam: function(popup){
                                popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
                            }
                        }
                    })
            },
            { dataIndex: 'ITEM_NAME'            ,  width: 200},
            { dataIndex: 'SPEC'                 ,  width: 90},
            { dataIndex: 'STOCK_UNIT'           ,  width: 80,align:'center'},
            { dataIndex: 'REQ_Q'                ,  width: 80},
            { dataIndex: 'DEPT_CODE'            ,  width: 100, hidden: true},
            { dataIndex: 'PERSON_NUMB'          ,  width: 100, hidden: true},
            { dataIndex: 'ITEM_REQ_DATE'        ,  width: 100, hidden: true},
            { dataIndex: 'MONEY_UNIT'           ,  width: 100, hidden: true,align:'center'},
            { dataIndex: 'EXCHG_RATE_O'         ,  width: 100, hidden: true},
            { dataIndex: 'DELIVERY_DATE'        ,  width: 80},
            { dataIndex: 'USE_REMARK'           ,  width: 100},
            { dataIndex: 'GW_DOCU_NUM'          ,  width: 100},
            { dataIndex: 'GW_FLAG'              ,  width: 100},
            { dataIndex: 'NEXT_YN'              ,  width: 100, hidden: true},
            { dataIndex: 'P_REQ_TYPE'              ,  width: 100, hidden: true},
            { dataIndex: 'SUPPLY_TYPE'              ,  width: 100, hidden: true},
            { dataIndex: 'SAVE_FLAG'              ,  width: 100, hidden: true}
        ],
        listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				if(!e.record.phantom) {
                    if(Ext.isEmpty(e.record.data.ITEM_CODE)) {
                    	if(UniUtils.indexOf(e.field, [ 'SPEC', 'REQ_Q', 'DELIVERY_DATE', 'USE_REMARK', 'NEXT_YN']))
                        {
                            return true;
                        } else {
                            return false;
                        }
                    } else if(!Ext.isEmpty(e.record.data.ITEM_CODE)) {
                    	if(UniUtils.indexOf(e.field, [ 'REQ_Q', 'DELIVERY_DATE', 'USE_REMARK', 'NEXT_YN','STOCK_UNIT']))
                        {
                            return true;
                        } else {
                        	return false;
                        }
                    } else if(e.record.data.NEXT_YN == 'Y') {
                    	if(UniUtils.indexOf(e.field, ['REQ_Q', 'DELIVERY_DATE', 'USE_REMARK', 'NEXT_YN']))
                        {
                            return true;
                        } else {
                            return false;
                        }
                    } else {
                    	if(UniUtils.indexOf(e.field, [ 'SPEC', 'REQ_Q', 'DELIVERY_DATE', 'USE_REMARK', 'NEXT_YN']))
                        {
                            return true;
                        } else {
                            return false;
                        }
                    }
                } else {
                    if(UniUtils.indexOf(e.field, ['ITEM_CODE', 'ITEM_NAME', 'SPEC', 'REQ_Q', 'DELIVERY_DATE', 'USE_REMARK', 'NEXT_YN','STOCK_UNIT']))
                    {
                        return true;
                    } else {
                        return false;
                    }
                }
			}
		},
		setItemData: function(record, dataClear, grdRecord) {
       		if(dataClear) {
       			grdRecord.set('ITEM_CODE'			,"");
       		} else {
       			grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
       			grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);;
				grdRecord.set('SPEC'				, record['SPEC']);
				grdRecord.set('STOCK_UNIT'			, record['STOCK_UNIT']);
				grdRecord.set('DELIVERY_DATE'       , moment().add('day',record['PURCH_LDTIME']).format('YYYYMMDD'));

				//UniSales.fnStockQ(grdRecord, UserInfo.compCode, grdRecord.get('OUT_DIV_CODE'), null, grdRecord.get('ITEM_CODE'),  grdRecord.get('REF_WH_CODE'));
       		}
		}
    });

    var orderNoMasterStore = Unilite.createStore('orderNoMasterStore', {    //조회버튼 누르면 나오는 조회창(구매요청번호)
        model: 's_mre100ukrv_kdModel',
        autoLoad: false,
        uniOpt: {
            isMaster: false,            // 상위 버튼 연결
            editable: false,            // 수정 모드 사용
            deletable:false,            // 삭제 가능 여부
            useNavi : false         // prev | newxt 버튼 사용
        },
        proxy: {
            type: 'direct',
            api: {
                read    : 's_mre100ukrv_kdService.selectItemReqNumList'
            }
        },
        loadStoreRecords : function()   {
            var param= orderNoSearch.getValues();
            var authoInfo = pgmInfo.authoUser;              //권한정보(N-전체,A-자기사업장>5-자기부서)
            var deptCode = UserInfo.deptCode;   //부서코드
            if(authoInfo == "5" && Ext.isEmpty(orderNoSearch.getValue('DEPT_CODE'))){
                param.DEPT_CODE = deptCode;
            }
            console.log( param );
            this.load({
                params : param
            });
        }
    });

    var orderNoSearch = Unilite.createSearchForm('orderNoSearchForm', {     //조회버튼 누르면 나오는 조회창
        layout: {type: 'uniTable', columns : 3},
        trackResetOnLoad: true,
        items: [{
            fieldLabel: '사업장',
            name:'DIV_CODE',
            xtype: 'uniCombobox',
            comboType:'BOR120',
            allowBlank:false,
            value: UserInfo.divCode
        },
        {
            fieldLabel:'품목의뢰번호',
            name: 'ITEM_REQ_NUM',
            xtype: 'uniTextfield'
        },
        {
            fieldLabel: '의뢰일',
            xtype: 'uniDateRangefield',
            startFieldName: 'ITEM_REQ_DATE_FR',
            endFieldName: 'ITEM_REQ_DATE_TO',
            allowBlank: false,
            startDate: UniDate.get('startOfMonth'),
            endDate: UniDate.get('today')
        },
        Unilite.popup('DEPT', {
            fieldLabel: '부서',
            valueFieldName: 'DEPT_CODE',
            textFieldName: 'DEPT_NAME',
            listeners: {
                applyextparam: function(popup){
                    var authoInfo = pgmInfo.authoUser;              //권한정보(N-전체,A-자기사업장>5-자기부서)
                    var deptCode = UserInfo.deptCode;   //부서정보
                    var divCode = '';                   //사업장
                    if(authoInfo == "A"){   //자기사업장
                        popup.setExtParam({'TREE_CODE': ""});
                        popup.setExtParam({'DIV_CODE': UserInfo.divCode});
                    }else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){   //전체권한
                        popup.setExtParam({'TREE_CODE': ""});
                        popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
                    }else if(authoInfo == "5"){     //부서권한
                        popup.setExtParam({'TREE_CODE': UserInfo.deptCode});
                        popup.setExtParam({'DIV_CODE': UserInfo.divCode});
                    }
                }
            }
        }),
        Unilite.popup('Employee',{
            fieldLabel: '사원',
            valueFieldName:'PERSON_NUMB',
            textFieldName:'PERSON_NAME',
            autoPopup:true
        })],
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
                    var fields = this.getForm().getFields();
                    Ext.each(fields.items, function(item) {
                        if(Ext.isDefined(item.holdable) )   {
                            if (item.holdable == 'hold') {
                                item.setReadOnly(true);
                            }
                        }
                        if(item.isPopupField)   {
                            var popupFC = item.up('uniPopupField')  ;
                            if(popupFC.holdable == 'hold') {
                                popupFC.setReadOnly(true);
                            }
                        }
                    })
                }
            } else {
                var fields = this.getForm().getFields();
                Ext.each(fields.items, function(item) {
                    if(Ext.isDefined(item.holdable) )   {
                        if (item.holdable == 'hold') {
                            item.setReadOnly(false);
                        }
                    }
                    if(item.isPopupField)   {
                        var popupFC = item.up('uniPopupField')  ;
                        if(popupFC.holdable == 'hold' ) {
                            item.setReadOnly(false);
                        }
                    }
                })
            }
            return r;
        }
    });

    var orderNoMasterGrid = Unilite.createGrid('s_mre101ukrv_kdOrderNoMasterGrid', {        //조회버튼 누르면 나오는 조회창 (구매요청번호)
        layout : 'fit',
        store: orderNoMasterStore,
        uniOpt:{
            expandLastColumn: false,
            useRowNumberer: false
        },
        columns: [
            { dataIndex: 'COMP_CODE'            ,  width: 100, hidden: true},
            { dataIndex: 'DIV_CODE'             ,  width: 100, hidden: true},
            { dataIndex: 'ITEM_REQ_NUM'         ,  width: 100, hidden: false},
            { dataIndex: 'ITEM_REQ_SEQ'         ,  width: 80, hidden: true},
            { dataIndex: 'ITEM_CODE'            ,  width: 110},
            { dataIndex: 'ITEM_NAME'            ,  width: 150},
            { dataIndex: 'SPEC'                 ,  width: 100},
            { dataIndex: 'STOCK_UNIT'           ,  width: 80,align:'center'},
            { dataIndex: 'REQ_Q'                ,  width: 80},
            { dataIndex: 'DEPT_CODE'            ,  width: 100, hidden: true},
            { dataIndex: 'DEPT_NAME'            ,  width: 100},
            { dataIndex: 'PERSON_NUMB'          ,  width: 100, hidden: true},
            { dataIndex: 'ITEM_REQ_DATE'        ,  width: 100, hidden: true},
            { dataIndex: 'MONEY_UNIT'           ,  width: 100, hidden: true,align:'center'},
            { dataIndex: 'EXCHG_RATE_O'         ,  width: 100, hidden: true},
            { dataIndex: 'DELIVERY_DATE'        ,  width: 80, hidden: true},
            { dataIndex: 'USE_REMARK'           ,  width: 120, hidden: false},
            { dataIndex: 'REMARK'               ,  width: 120},
            { dataIndex: 'GW_DOCU_NUM'          ,  width: 100, hidden: true},
            { dataIndex: 'GW_FLAG'              ,  width: 100, hidden: false},
            { dataIndex: 'NEXT_YN'              ,  width: 100, hidden: true},
            { dataIndex: 'P_REQ_TYPE'              ,  width: 100, hidden: true},
            { dataIndex: 'SUPPLY_TYPE'              ,  width: 100, hidden: true}
        ],
        listeners: {
            onGridDblClick: function(grid, record, cellIndex, colName) {
                orderNoMasterGrid.returnData(record);
                //UniAppManager.app.onQueryButtonDown();
                SearchInfoWindow.hide();
            }
        },
        returnData: function(record)    {
            if(Ext.isEmpty(record)) {
                record = this.getSelectedRecord();
            }
            panelResult.setValues({
                'DIV_CODE'      :record.get('DIV_CODE'),
                'ITEM_REQ_NUM'  :record.get('ITEM_REQ_NUM'),
                'ITEM_REQ_DATE' :record.get('ITEM_REQ_DATE'),
                'DEPT_CODE'     :record.get('DEPT_CODE'),
                'DEPT_NAME'     :record.get('DEPT_NAME'),
                'PERSON_NUMB'   :record.get('PERSON_NUMB'),
                'PERSON_NAME'   :record.get('PERSON_NAME'),
                'MONEY_UNIT1'    :record.get('MONEY_UNIT'),
                'EXCHG_RATE_O1'  :record.get('EXCHG_RATE_O'),
                'REMARK'        :record.get('REMARK')
            });
          //  panelResult.setAllFieldsReadOnly(true);
            directMasterStore1.loadStoreRecords();
        }
    });

    function openSearchInfoWindow() {           //조회버튼 누르면 나오는 조회창
        if(!SearchInfoWindow) {
            SearchInfoWindow = Ext.create('widget.uniDetailWindow', {
                title: '품목의뢰번호검색',
                width: 1080,
                height: 580,
                layout: {type:'vbox', align:'stretch'},
                items: [orderNoSearch, orderNoMasterGrid], //orderNoDetailGrid],
                tbar:  ['->',{
                    itemId : 'saveBtn',
                    text: '조회',
                    handler: function() {
                        orderNoMasterStore.loadStoreRecords();
                    },
                    disabled: false
                }, {
                    itemId : 'OrderNoCloseBtn',
                    text: '닫기',
                    handler: function() {
                        SearchInfoWindow.hide();
                    },
                    disabled: false
                }],
                listeners : {
                    beforehide: function(me, eOpt)  {
                        orderNoSearch.clearForm();
                        orderNoMasterGrid.reset();
                    },
                    beforeclose: function( panel, eOpts )   {
                        orderNoSearch.clearForm();
                        orderNoMasterGrid.reset();
                    },
                    show: function( panel, eOpts )  {
                        orderNoSearch.setValue('DIV_CODE',              panelResult.getValue('DIV_CODE'));
                        orderNoSearch.setValue('ITEM_REQ_DATE_FR',      UniDate.get('startOfMonth'));
                        orderNoSearch.setValue('ITEM_REQ_DATE_TO',      UniDate.get('today'));
                        orderNoSearch.setValue('DEPT_CODE',             panelResult.getValue('DEPT_CODE'));
                        orderNoSearch.setValue('DEPT_NAME',             panelResult.getValue('DEPT_NAME'));
                        orderNoSearch.setValue('PERSON_NUMB',           panelResult.getValue('PERSON_NUMB'));
                        orderNoSearch.setValue('PERSON_NAME',           panelResult.getValue('PERSON_NAME'));
                     }
                }
            })
        }
        SearchInfoWindow.center();
        SearchInfoWindow.show();
    }

    Unilite.Main({
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid, panelResult
			]
		  }
		],
		id: 's_mre100ukrv_kdApp',
		fnInitBinding: function() {
//			panelResult.setValue('DEPT_CODE',UserInfo.deptCode);
//			panelResult.setValue('DEPT_NAME',UserInfo.deptName);
//			panelResult.setValue('DEPT_CODE',UserInfo.deptCode);
//			panelResult.setValue('DEPT_NAME',UserInfo.deptName);
//			panelResult.setValue('PERSON_NUMB',UserInfo.userID);
//			panelResult.setValue('PERSON_NAME',UserInfo.userName);
//			panelResult.setValue('PERSON_NUMB',UserInfo.userID);
//			panelResult.setValue('PERSON_NAME',UserInfo.userName);

			UniAppManager.setToolbarButtons(['reset','newData', 'prev', 'next'], true);
			this.setDefault();
            Ext.getCmp('GW').setDisabled(true);
		},
		onQueryButtonDown: function()	{ //조회

            panelResult.setValue('GW_TEMP', '');
			panelResult.setAllFieldsReadOnly(false);
			panelResult.getField("ITEM_REQ_NUM").setReadOnly(true);
            var orderNo = panelResult.getValue('ITEM_REQ_NUM');
            if(Ext.isEmpty(orderNo)) {
                openSearchInfoWindow()
            } else {

            	directMasterStore1.loadStoreRecords();
                //panelResult.setAllFieldsReadOnly(true);
            }
		},
		onNewDataButtonDown: function()	{ //추가
            if(!this.checkForNewDetail()) return false;
			var param = panelResult.getValues();
            s_bco100ukrv_kdService.selectGwData(param, function(provider, response) {
                if(Ext.isEmpty(provider[0]) || provider[0].GW_FLAG != '1' || provider[0].GW_FLAG != '3') {
        				/**
        				 * Detail Grid Default 값 설정
        				 */
        			 var itemReqNum = panelResult.getValue('ITEM_REQ_NUM');
        			 var seq = directMasterStore1.max('ITEM_REQ_SEQ');
                	 if(!seq) seq = 1;
                	 else  seq += 1;
                	 var divCode = panelResult.getValue('DIV_CODE');
                	 var moneyUnit = panelResult.getValue('MONEY_UNIT1'); // MoneyUnit
                	 var exchgRateO = panelResult.getValue('EXCHG_RATE_O1');
                     var reqQ = '0';
                	 var dvryDate = UniDate.get('today');
                	 var useRemark = '';
                	 var gwDocuNum = '';
                	 var gwFlag = 'N';
                	 var nextYn = 'N';
                	 var compCode = UserInfo.compCode;
                	 var itemReqDate = panelResult.getValue('ITEM_REQ_DATE');
                	 var deptCode = panelResult.getValue('DEPT_CODE');
                     var personNumb = panelResult.getValue('PERSON_NUMB');
                	 var gwFlag = 'N';
                	 var pReqType = panelResult.getValue('P_REQ_TYPE');
                	 var supplyType = panelResult.getValue('SUPPLY_TYPE');

                	 var r = {
        				ITEM_REQ_NUM: itemReqNum,
        				ITEM_REQ_SEQ: seq,
        				DIV_CODE: divCode,
                        MONEY_UNIT: moneyUnit,
                        EXCHG_RATE_O: exchgRateO,
                        REQ_Q: reqQ,
                        DELIVERY_DATE: dvryDate,
                        USE_REMARK: useRemark,
                        GW_DOCU_NUM: gwDocuNum,
                        GW_FLAG: gwFlag,
                        NEXT_YN: nextYn,
                        ITEM_REQ_DATE: itemReqDate,
                        DEPT_CODE: deptCode,
                        PERSON_NUMB: personNumb,
                        GW_FLAG: gwFlag,
                        P_REQ_TYPE: pReqType,
                        SUPPLY_TYPE: supplyType
        	        };
        			masterGrid.createRow(r);
        			panelResult.setAllFieldsReadOnly(true);
        			panelResult.getField('DEPT_CODE').setReadOnly(false);
        			panelResult.getField('DEPT_NAME').setReadOnly(false);
        			panelResult.getField('PERSON_NUMB').setReadOnly(false);
        			panelResult.getField('PERSON_NAME').setReadOnly(false);
        			panelResult.getField('MONEY_UNIT1').setReadOnly(false);
        			panelResult.getField('EXCHG_RATE_O1').setReadOnly(false);
        			panelResult.getField('REMARK').setReadOnly(false);
        			panelResult.getField('P_REQ_TYPE').setReadOnly(false);
        			panelResult.getField('SUPPLY_TYPE').setReadOnly(false);
        			panelResult.getField('ITEM_REQ_DATE').setReadOnly(false);
    			} else {
                    alert('이미 기안된 자료입니다.');
                    return false;
                }
            });
		},
		onResetButtonDown: function() { //신규
			panelResult.clearForm();
			panelResult.setAllFieldsReadOnly(false);
			masterGrid.reset();
			panelResult.clearForm();
			directMasterStore1.clearData();
			Ext.getCmp('GW').setDisabled(true);
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function(config) { //저장
			if(directMasterStore1.isDirty())	{
				directMasterStore1.saveStore();
			}
		},
		onDeleteDataButtonDown: function() {
            var param = panelResult.getValues();
            if(!Ext.isEmpty(param.ITEM_REQ_NUM)) {
                s_bco100ukrv_kdService.selectGwData(param, function(provider, response) {
                    if(Ext.isEmpty(provider[0]) || provider[0].GW_FLAG != '1' || provider[0].GW_FLAG != '3') {
                        var record = masterGrid.getSelectedRecord();
//                        if(record.get('GW_FLAG') == 'Y') {
//                            alert('기안된 데이터는 삭제가 불가능합니다.');
//                            return false;
//                        }
                        if(record.get('GW_FLAG') == 3){
                        	alert('결재완료된 문서는 삭제할 수 없습니다.');
                        	return false;
                        }
                        else {
                			var selRow = masterGrid.getSelectedRecord();
                			if(selRow.phantom === true)	{
                				masterGrid.deleteSelectedRow();
                			}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
                				masterGrid.deleteSelectedRow();
                			}
                        }
                    } else {
                        alert('기안된 데이터는 삭제가 불가능합니다.');
                        return false;
                    }
                })
            } else {
                var selRow = masterGrid.getSelectedRecord();
                if(selRow.phantom === true) {
                    masterGrid.deleteSelectedRow();
                }else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
                    masterGrid.deleteSelectedRow();
                }
            }
		},
		onDeleteAllButtonDown: function() {
			var records = directMasterStore1.data.items;
			var isNewData = false;
			Ext.each(records, function(record,i) {
				if(record.phantom){						//신규 레코드일시 isNewData에 true를 반환
					isNewData = true;
				}else{									//신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
					if(confirm('전체삭제 하시겠습니까?')) {
						if(record.get('INSPEC_Q') > 1){
								alert('<t:message code="unilite.msg.sMM435"/>');
						}else{
							var deletable = true;
							if(deletable){
								masterGrid.reset();
								UniAppManager.app.onSaveDataButtonDown();
							}
							isNewData = false;
						}
					}
					return false;
				}
			});
			if(isNewData){								//신규 레코드들만 있을시 그리드 리셋
				masterGrid.reset();
				UniAppManager.app.onResetButtonDown();	//삭제후 RESET..
			}
		},
		setDefault: function() {
			panelResult.getField("ITEM_REQ_NUM").setReadOnly(true);
			panelResult.getField("ITEM_REQ_DATE").setReadOnly(false);
			panelResult.getField("DIV_CODE").setReadOnly(false);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
        	panelResult.setValue('ITEM_REQ_DATE',new Date());
        	panelResult.setValue('SUPPLY_TYPE', '1');
            panelResult.setValue('MONEY_UNIT1', BsaCodeInfo.gsDefaultMoney);
        	// panelResult.setValue('DIV_CODE',UserInfo.divCode);
            UniAppManager.app.fnExchngRateO();

            panelResult.getForm().wasDirty = false;
			panelResult.resetDirtyStatus();

			UniAppManager.setToolbarButtons('save', false);

		},
        fnExchngRateO:function() {
        	var param = {
        		"AC_DATE"    : UniDate.getDbDateStr(panelResult.getValue('ITEM_REQ_DATE')),
                "MONEY_UNIT" : panelResult.getValue('MONEY_UNIT1')
        	};
            s_mre100ukrv_kdService.fnExchgRateO(param, function(provider, response) {
                panelResult.setValue('EXCHG_RATE_O1', provider[0].BASE_EXCHG);
                panelResult.setValue('EXCHG_RATE_O1', provider[0].BASE_EXCHG);
            });
        },
		checkForNewDetail:function() {
			if(BsaCodeInfo.gsAutoType=='N' && Ext.isEmpty(panelResult.getValue('PO_REQ_NUM')))	{
				alert('구매요청번호는 필수입력값이고 수동입력입니다 먼저 입력후 진행하십시오');
				return false;
			}
			return panelResult.setAllFieldsReadOnly(true);
        },
        requestApprove: function(){     //결재 요청
            var gsWin = window.open('about:blank','payviewer','width=500,height=500');

            var frm         = document.f1;
            var compCode    = UserInfo.compCode;
            var divCode     = panelResult.getValue('DIV_CODE');
            var itemReqNum  = panelResult.getValue('ITEM_REQ_NUM');
            var spText      = 'EXEC omegaplus_kdg.unilite.USP_GW_S_MRE100UKRV_KD ' + "'" + compCode + "'" + ', ' + "'" + divCode + "'" + ', ' + "'" + itemReqNum + "'";
            var spCall      = encodeURIComponent(spText);

            /* frm.action   = groupUrl + "viewMode=docuDraft" + "&prg_no=s_mre100ukrv_kd&draft_no=" + UserInfo.compCode + panelResult.getValue('ITEM_REQ_NUM') + "&sp=" + spCall/* + Base64.encode();
            frm.target   = "payviewer";
            frm.method   = "post";
            frm.submit(); */
            var gwurl = groupUrl + "viewMode=docuDraft" + "&prg_no=s_mre100ukrv_kd&draft_no=" + UserInfo.compCode + panelResult.getValue('ITEM_REQ_NUM') + "&sp=" + spCall/* + Base64.encode()*/;
            UniBase.fnGw_Call(gwurl,frm,'GW');
        }
	});

	Unilite.createValidator('validator01', {
		store: directMasterStore1,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
		console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "PO_SER_NO" : //발주순번
					if(newValue <= 0){
						rv='<t:message code="unilite.msg.sMB076"/>';
						break;
					}

				case "MONEY_UNIT" :
					if(newValue == BsaCodeInfo.gsDefaultMoney){
						record.set('EXCHG_RATE_O', '1');
					}
					UniAppManager.app.fnCalOrderAmt(record, "X");
					directMasterStore1.fnSumOrderO();
					break;

				case "EXCHG_RATE_O":
					if(newValue <= 0){
						rv='<t:message code="unilite.msg.sMB076"/>';
						break;
					}
					UniAppManager.app.fnCalOrderAmt(record, "X", newValue);
					directMasterStore1.fnSumOrderO();
					break;

				case "DELIVERY_DATE":
					if(newValue < panelResult.getValue('ITEM_REQ_DATE')){
						rv='<t:message code="unilite.msg.sMM374"/>';
								break;
					}
					break;


			}
			return rv;
		}
	});
};
</script>

<form id="f1" name="f1" action="" method="post" onSubmit="return false;" >
<input type="hidden" id="loginid" name="loginid" value="superadmin" />
<input type="hidden" id="fmpf" name="fmpf" value="" />
<input type="hidden" id="fmbd" name="fmbd" runat="server" />
</form>
