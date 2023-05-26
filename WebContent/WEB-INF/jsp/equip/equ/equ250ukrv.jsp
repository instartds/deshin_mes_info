<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="equ250ukrv" >
    <t:ExtComboStore comboType="BOR120" pgmId="bcm120ukrv"/>                <!-- 사업장 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>

<script type="text/javascript" >

var BsaCodeInfo = {
	gsCoreUse		: '${gsCoreUse}'		// 코어사용여부
};
    function appMain() {
/*    	var masterSelectedGrid = 'bcm120ukrvGrid1';*/

    	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
            api: {
                read: 'equ250ukrvServiceImpl.selectList',
                create: 'equ250ukrvServiceImpl.insertMaster',
                update: 'equ250ukrvServiceImpl.updateMaster',
                destroy: 'equ250ukrvServiceImpl.deleteMaster',
    			syncAll:	'equ250ukrvServiceImpl.saveAll'
            }
        });

        Unilite.defineModel('equ250ukrvModel', {
            fields: [
                {name: 'DIV_CODE'                       , text: '사업장코드'             , type: 'string'},
                {name: 'EQU_CODE'                       , text: '금형번호'               , type: 'string',  allowBlank: false,    maxLength: 60},
                {name: 'EQU_NAME'                       , text: '금형명'                , type: 'string'},
                {name: 'EQU_SPEC'                       , text: '규격'                 , type: 'string'},
                {name: 'SEQ'                            , text: '순번'                 , type: 'int',     allowBlank: false},
                {name: 'ITEM_CODE'                      , text: '품목'                 , type: 'string',  allowBlank: false,    maxLength: 20 },
                {name: 'ITEM_NAME'                      , text: '품목명'                , type: 'string'},
                {name: 'CUSTOM_CODE'                    , text: '주거래처'              , type: 'string'},
                {name: 'CUSTOM_NAME'                    , text: '주거래처명'             , type: 'string'},
                {name: 'SPEED'                          , text: '사출속도'              , typee: 'string'},
                {name: 'PRESS'                          , text: '사출압력'              , typee: 'string'},
                {name: 'LOCATION'                       , text: '사출위치'              , typee: 'string'},
                {name: 'SHOT_TIME'                      , text: '사출시간'              , typee: 'string'},
                {name: 'COOL_TIME'                      , text: '냉각시간'              , typee: 'string'},
                {name: 'TEMPER'                         , text: '사출온도'              , typee: 'string'},
                {name: 'REMARK'                         , text: '비고'                 , typee: 'string'},
                {name: 'UPDATE_DB_USER'                 , text: '작성자'                , type: 'string' , defaultValue: UserInfo.userID},
                {name: 'UPDATE_DB_TIME'                 , text: '작성시간'              , type: 'uniDate'},
                {name: 'COMP_CODE'                      , text: '법인코드'              , type: 'string' , defaultValue: UserInfo.compCode}
            ]
        });


        /** Store 정의(Service 정의)
    	 * @type
    	 */
    	var directMasterStore = Unilite.createStore('equ250urkvMasterStore1', {
    		model: 'equ250ukrvModel',
    		uniOpt: {
    			isMaster	: true,		// 상위 버튼 연결
    			editable	: true,		// 수정 모드 사용
    			deletable	: true,		// 삭제 가능 여부
    			useNavi		: false		// prev | next 버튼 사용
    		},
    		autoLoad : false,
    		proxy: directProxy,

    		loadStoreRecords: function(){
    			var param = Ext.getCmp('resultForm').getValues();
    			console.log( param );
    			/* var whList2ComboStore =  Ext.data.StoreManager.lookup('whList'); */
          	  //whList2ComboStore.clearFilter();
          	  //whList2ComboStore.getFilters().removeAll();
    			this.load({
    				params: param,
    				callback : function(records,options,success)    {
                        if(success) {


                        }
                    }
    			});
    		},
    		saveStore : function()	{
    			var inValidRecs = this.getInvalidRecords();
    			console.log("inValidRecords : ", inValidRecs);
    			var toCreate = this.getNewRecords();
    		    var toUpdate = this.getUpdatedRecords();
    		    var toDelete = this.getRemovedRecords();

    		    var list = [].concat(toUpdate, toCreate);
    		   console.log("list:", list);
    			if(inValidRecs.length == 0 ) {
    				config = {
    					params: [panelResult.getValues()],
   						success: function(batch, option) {
   							directMasterStore.loadStoreRecords();
					 	}
    				}
    				this.syncAllDirect(config);
    			}else {
    				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
    			}
    		},
    		groupField: 'EQU_CODE'
    	});


     /**
     * 검색조건 (Search Panel)
     * @type
     */
        /* var panelSearch = Unilite.createSearchPanel('searchForm', {
            title: '검색조건',
            defaultType: 'uniSearchSubPanel',
            listeners: {
                collapse: function () {
                    panelResult.show();
                },
                expand: function() {
                    panelResult.hide();
                }
            },
            defaults: {
                autoScroll:true
            },
            items: [{
                title: '기본정보',
                itemId: 'search_panel1',
                layout: {type: 'uniTable', columns: 1},
                defaultType: 'uniTextfield',
                items: [{
                    fieldLabel: '사업장',
                    value : UserInfo.divCode,
                    name: 'DIV_CODE',
                    xtype: 'uniCombobox',
                    comboType: 'BOR120',
                    allowBlank:false,
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {
                            panelResult.setValue('DIV_CODE', newValue);
                        }
                    }
                },{
                    fieldLabel: '금형번호',
                    name: 'EQU_CODE',
                    xtype: 'uniTextfield',
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {
                            panelResult.setValue('EQU_CODE', newValue);
                        }
                    }
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
         */

        var panelResult = Unilite.createSearchForm('resultForm', {
    		region: 'north',
    		layout : {type : 'uniTable', columns : 5},
    		padding:'1 1 1 1',
    		border:true,
    		items: [{
                fieldLabel: '사업장',
                value : UserInfo.divCode,
                name: 'DIV_CODE',
                xtype: 'uniCombobox',
                comboType: 'BOR120',
                allowBlank:false,
                holdable : 'hold',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        /* panelResult.setValue('DIV_CODE', newValue); */
                    }
                }
            },{
                fieldLabel: '금형번호',
                name: 'EQU_CODE',
                xtype: 'uniTextfield',

                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        /* panelResult.setValue('EQU_CODE', newValue); */
                    }
                }
            },
    		Unilite.popup('DIV_PUMOK',{
    			fieldLabel		: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>',
    			valueFieldName	: 'ITEM_CODE',
    			textFieldName	: 'ITEM_NAME',
    			validateBlank	: false,
    			colspan			: 2,				//20200520 추가
    			listeners		: {
    				applyextparam: function(popup){
    					popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
    				},
    				onValueFieldChange: function(field, newValue){
    					panelResult.setValue('ITEM_CODE', newValue);
    				},
    				onTextFieldChange: function(field, newValue){
    					panelResult.setValue('ITEM_NAME', newValue);
    				}
    			}
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

        var masterGrid = Unilite.createGrid('equ250ukrvGrid1', {
    		store	: directMasterStore,
    		region	: 'center',
    		layout	: 'fit',
    		uniOpt	:{
    			expandLastColumn: true,
    			useMultipleSorting: true
    		},
            features: [{
                id: 'masterGridSubTotal',
                ftype: 'uniGroupingsummary',
                showSummaryRow: false
            },{
                id: 'masterGridTotal',
                ftype: 'uniSummary',
                showSummaryRow: false
            }],
    		border: true,
    		columns: [
    		
    		{dataIndex: 'EQU_CODE'			, width: 80, tdCls:'x-change-cell',id:'moldCodeCol',
				'editor' : Unilite.popup('EQU_MOLD_CODE_G',{
					textFieldName:'EQU_MOLD_NAME',
					DBtextFieldName: 'EQU_MOLD_NAME',
					autoPopup: true,
					listeners: {
						'onSelected': {
							fn: function(records, type) {
								var grdRecord = masterGrid.uniOpt.currentRecord;
								grdRecord.set('EQU_CODE',records[0]['EQU_MOLD_CODE']);
								grdRecord.set('EQU_NAME',records[0]['EQU_MOLD_NAME']);
								grdRecord.set('EQU_SPEC', records[0]['EQU_SPEC']);
							},
							scope: this
						},
						'onClear': function(type) {
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('EQU_CODE', '');
							grdRecord.set('EQU_NAME', '');
							grdRecord.set('EQU_SPEC', '');
						},
						applyextparam: function(popup){
							var grdRecord = masterGrid.uniOpt.currentRecord;
							popup.setExtParam({'DIV_CODE': grdRecord.get('DIV_CODE')});
							//popup.setExtParam({'ITEM_CODE': grdRecord.get('ITEM_CODE')});
						}
					}
				})
			},
			{dataIndex: 'EQU_NAME'			, width: 120, tdCls:'x-change-cell',id:'moldNameCol',
				'editor' : Unilite.popup('EQU_MOLD_CODE_G',{
					textFieldName:'EQU_MOLD_NAME',
					DBtextFieldName: 'EQU_MOLD_NAME',
					autoPopup: true,
					listeners: {
						'onSelected': {
							fn: function(records, type) {
									var grdRecord = masterGrid.uniOpt.currentRecord;
									grdRecord.set('EQU_CODE',records[0]['EQU_MOLD_CODE']);
									grdRecord.set('EQU_NAME',records[0]['EQU_MOLD_NAME']);
									grdRecord.set('EQU_SPEC', records[0]['EQU_SPEC']);
								},
							scope: this
						},
						'onClear': function(type) {
									var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('EQU_CODE', '');
							grdRecord.set('EQU_NAME', '');
							grdRecord.set('EQU_SPEC', '');
						},
						applyextparam: function(popup){
							var grdRecord = masterGrid.uniOpt.currentRecord;
							popup.setExtParam({'DIV_CODE': grdRecord.get('DIV_CODE')});
							//popup.setExtParam({'ITEM_CODE': grdRecord.get('ITEM_CODE')});
						}
					}
				})
			},
				{dataIndex: 'EQU_SPEC'                  , width : 120 },
				{dataIndex: 'SEQ'                       , width : 70 },
				{dataIndex: 'ITEM_CODE'                 , width : 120
					,editor : Unilite.popup('DIV_PUMOK_G',{
						DBtextFieldName:'ITEM_CODE',
	    				autoPopup:true,
	    				listeners: {
			                'onSelected':  function(records, type  ){
			                    	var grdRecord = masterGrid.uniOpt.currentRecord;
			                    	grdRecord.set('ITEM_CODE',records[0]['ITEM_CODE']);
			                    	grdRecord.set('ITEM_NAME',records[0]['ITEM_NAME']);

			                }
			                ,'onClear':  function( type  ){
			                    	var grdRecord = masterGrid.uniOpt.currentRecord;
			                    	grdRecord.set('ITEM_CODE','');
			                    	grdRecord.set('ITEM_NAME','');

			                },applyextparam: function(popup){
								popup.setExtParam({'DIV_CODE':panelResult.getValue('DIV_CODE')});
							}
			            }
					})
				},
				{dataIndex: 'ITEM_NAME'                 , width : 250
					,editor : Unilite.popup('DIV_PUMOK_G',{
						DBtextFieldName:'ITEM_NAME',
	    				autoPopup:true,
	    				listeners: {
			                'onSelected':  function(records, type  ){
			                    	var grdRecord = masterGrid.uniOpt.currentRecord;
			                    	grdRecord.set('ITEM_CODE',records[0]['ITEM_CODE']);
			                    	grdRecord.set('ITEM_NAME',records[0]['ITEM_NAME']);

			                }
			                ,'onClear':  function( type  ){
			                    	var grdRecord = masterGrid.uniOpt.currentRecord;
			                    	grdRecord.set('ITEM_CODE','');
			                    	grdRecord.set('ITEM_NAME','');

			                },applyextparam: function(popup){
								popup.setExtParam({'DIV_CODE':panelResult.getValue('DIV_CODE')});
							}
			            }
					})
				},
				{dataIndex: 'CUSTOM_CODE'               , width : 120
					,editor : Unilite.popup('CUST_G',{
						DBtextFieldName:'CUSTOM_CODE',
	    				autoPopup:true,
	    				listeners: {
			                'onSelected': {
			                	fn : function(records, type  ){
				                    	var grdRecord = masterGrid.uniOpt.currentRecord;
				                    	grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
				                    	grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
			                		}
								,scope: this

			                }
			                ,'onClear':  function( type  ){
			                    	var grdRecord = masterGrid.uniOpt.currentRecord;
			                    	grdRecord.set('CUSTOM_CODE','');
			                    	grdRecord.set('CUSTOM_NAME','');

			                }
			            }
					})

				},
				{dataIndex: 'CUSTOM_NAME'               , width : 120
					,editor : Unilite.popup('CUST_G',{
						DBtextFieldName:'CUSTOM_NAME',
	    				autoPopup:true,
	    				listeners: {
			                'onSelected':  function(records, type  ){
			                    	var grdRecord = masterGrid.uniOpt.currentRecord;
			                    	grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
			                    	grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);

			                }
			                ,'onClear':  function( type  ){
			                    	var grdRecord = masterGrid.uniOpt.currentRecord;
			                    	grdRecord.set('CUSTOM_CODE','');
			                    	grdRecord.set('CUSTOM_NAME','');

			                }
			            }
					})
				},
				{dataIndex: 'SPEED'                     , width : 80 , hidden : true},
				{dataIndex: 'PRESS'                     , width : 80 , hidden : true},
				{dataIndex: 'LOCATION'                  , width : 80 , hidden : true},
				{dataIndex: 'SHOT_TIME'                 , width : 80 , hidden : true},
				{dataIndex: 'COOL_TIME'                 , width : 80 , hidden : true},
				{dataIndex: 'TEMPER'                    , width : 80 , hidden : true},
				{dataIndex: 'REMARK'                    , width : 180 },
				{dataIndex: 'UPDATE_DB_USER'            , width : 100 , hidden : true},
				{dataIndex: 'UPDATE_DB_TIME'            , width : 100 , hidden : true},
				{dataIndex: 'COMP_CODE'                 , width : 100 , hidden : true}

    		],
    		listeners : {
    			beforeedit  : function( editor, e, eOpts ) {
    				if(e.record.phantom == false || !e.record.phantom == false) {
    					if(UniUtils.indexOf(e.field, ['EQU_SPEC', 'UPDATE_DB_TIME', 'UPDATE_DB_USER']))
    					{
    						return false;
    					}
    				}
    				if(e.record.phantom == false) {
    					if(UniUtils.indexOf(e.field, ['EQU_CODE', 'EQU_NAME', 'SEQ', 'ITEM_CODE', 'ITEM_NAME']))
    					{
    						return false;
    					}
    				}
    			},
    			afterrender: function(grid) {
				if(BsaCodeInfo.gsCoreUse == 'Y'){
					Ext.getCmp('moldCodeCol').setConfig('editor',Unilite.popup('CORE_CODE_G',{
						textFieldName:'CORE_NAME',
						DBtextFieldName: 'CORE_NAME',
						autoPopup: true,
						listeners: {
							'onSelected': {
								fn: function(records, type) {
									var grdRecord = masterGrid.uniOpt.currentRecord;
									grdRecord.set('EQU_CODE',records[0]['CORE_CODE']);
									grdRecord.set('EQU_NAME',records[0]['CORE_NAME']);
									grdRecord.set('EQU_SPEC', records[0]['CORE_SPEC']);
								},
								scope: this
							},
							'onClear': function(type) {
								var grdRecord = masterGrid.uniOpt.currentRecord;
								grdRecord.set('EQU_CODE', '');
								grdRecord.set('EQU_NAME', '');
								grdRecord.set('EQU_SPEC', '');
							},
							applyextparam: function(popup){
								var grdRecord = masterGrid.uniOpt.currentRecord;
								popup.setExtParam({'DIV_CODE': grdRecord.get('DIV_CODE')});
								//popup.setExtParam({'ITEM_CODE': grdRecord.get('ITEM_CODE')});
							}
						}
					}));
					
					Ext.getCmp('moldNameCol').setConfig('editor',Unilite.popup('CORE_CODE_G',{
						textFieldName:'CORE_NAME',
						DBtextFieldName: 'CORE_NAME',
						autoPopup: true,
						listeners: {
							'onSelected': {
								fn: function(records, type) {
									var grdRecord = masterGrid.uniOpt.currentRecord;
									grdRecord.set('EQU_CODE',records[0]['CORE_CODE']);
									grdRecord.set('EQU_NAME',records[0]['CORE_NAME']);
									grdRecord.set('EQU_SPEC', records[0]['CORE_SPEC']);
								},
								scope: this
							},
							'onClear': function(type) {
								var grdRecord = masterGrid.uniOpt.currentRecord;
								grdRecord.set('EQU_CODE', '');
								grdRecord.set('EQU_NAME', '');
								grdRecord.set('EQU_SPEC', '');
							},
							applyextparam: function(popup){
								var grdRecord = masterGrid.uniOpt.currentRecord;
								popup.setExtParam({'DIV_CODE': grdRecord.get('DIV_CODE')});
								//popup.setExtParam({'ITEM_CODE': grdRecord.get('ITEM_CODE')});
							}
						}
					}));
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
				   masterGrid, panelResult
				]
            }],
            id: 'equ250ukrvApp',

            fnInitBinding : function() {
                panelResult.setValue('DIV_CODE',UserInfo.divCode);
                UniAppManager.setToolbarButtons(['reset','newData'],true);
                UniAppManager.setToolbarButtons(['save'],false);
            },
            onQueryButtonDown: function()   {

                if(!UniAppManager.app.checkForNewDetail()){
                    return false;
                }else{
                    directMasterStore.loadStoreRecords();
                    beforeRowIndex = -1;
                    panelResult.setAllFieldsReadOnly(false);
                }
            },
            onNewDataButtonDown : function()    {
                if(!this.checkForNewDetail()) return false;
                    /**
                     * Detail Grid Default 값 설정
                     */
                    var compCode  = UserInfo.compCode;
                  	var divCode = panelResult.getValue('DIV_CODE');
                    var r = {
                        COMP_CODE     	: compCode,
                        DIV_CODE		: divCode
                    };
                    masterGrid.createRow(r);

            },
            checkForNewDetail:function() {
                return panelResult.setAllFieldsReadOnly(true);
            },
            setDefault: function() {
            	panelResult.setValue('DIV_CODE',UserInfo.divCode);
            	panelResult.getForm().wasDirty = false;
            	panelResult.resetDirtyStatus();
                UniAppManager.setToolbarButtons('save', false);
            },
            onSaveDataButtonDown: function (config) {

                directMasterStore.saveStore(config);

            },
            onDeleteDataButtonDown: function() {
                var selRow = masterGrid.getSelectedRecord();
                if(selRow.phantom === true) {
                    masterGrid.deleteSelectedRow();
                }else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
                    masterGrid.deleteSelectedRow();
                }
            },
            onResetButtonDown: function() {
            	panelResult.clearForm();
            	panelResult.setAllFieldsReadOnly(false);
                masterGrid.reset();
                directMasterStore.clearData();
                this.fnInitBinding();
            },
            onDetailButtonDown:function() {
                var as = Ext.getCmp('AdvanceSerch');
                if(as.isHidden()) {
                    as.show();
                }else {
                    as.hide()
                }
            }
        });
        Unilite.createValidator('validator01', {
            store : directMasterStore,
            grid: masterGrid,
            validate: function( type, fieldName, newValue, oldValue, record, eopt) {
                console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
                var rv = true;

                if(fieldName == "SEQ" )   {
                	if(!Ext.isNumeric(newValue)){
                        rv='<t:message code="unilite.msg.sMB074" default="숫자만 입력가능합니다."/>';
                        record.set('SEQ',oldValue);
                    }

               		if(newValue < 0 ) {
                        rv='<t:message code="unilite.msg.sMB076" default="양수만 입력가능합니다."/>';
                        record.set('SEQ',oldValue);
                    }
                }
                return rv;
            }
        });
    }

</script>