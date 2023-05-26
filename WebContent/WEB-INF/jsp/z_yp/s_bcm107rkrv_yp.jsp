<%@page language="java" contentType="text/html; charset=utf-8"%>

<t:appConfig pgmId="s_bcm107rkrv_yp"  >
<t:ExtComboStore comboType="BOR120" pgmId="s_bcm107rkrv_yp"  /> 			<!-- 사업장 -->
<t:ExtComboStore comboType="AU" comboCode="B055" />                <!-- 거래처분류 -->
<t:ExtComboStore comboType="AU" comboCode="B013" />                <!-- 단위 -->
</t:appConfig>

<script type="text/javascript" >
var settingWindow;
function appMain() {

/*	var directButtonProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			create	: 's_bcm107rkrv_ypService.savePrinted',
			syncAll	: 's_bcm107rkrv_ypService.savePrintedData'
		}
	}); 21.09.01 양평농폅에서 사용함에 따라 CLIP으로 변경하면서 기존 로직은 주석*/

		var directButtonProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			create	: 's_bcm107rkrv_ypService.savePrinted',
			syncAll	: 's_bcm107rkrv_ypService.savePrintedDataClip'
		}
	});
	/**
	 *   Model 정의
	 * @type
	 */
	Unilite.defineModel('s_bcm107rkrv_ypModel1', {
	    fields: [
	        {name: 'COMP_CODE',       text: 'COMP_CODE'         ,type: 'string', editable: true, defaultValue: UserInfo.compCode},
	    	{name: 'CUSTOM_CODE',     text: '거래처코드'	        ,type: 'string', editable: true},
	    	{name: 'CUSTOM_NAME',     text: '거래처명'            ,type: 'string', editable: true},
	    	{name: 'CERT_NO',         text: '인증번호'            ,type: 'string', editable: true},
	    	{name: 'TELEPHON',        text: '전화번호'            ,type: 'string'},
            {name: 'WORK_ADDR',       text: '작업장주소'          ,type: 'string'},
            {name: 'ITEM_NAME',       text: '품목명'             ,type: 'string'},
            {name: 'ORIGIN',          text: '산지'              ,type: 'string'},
            {name: 'PRDT_YEAR',       text: '생산년도'           ,type: 'string', maxLength: 4},
            {name: 'ORDER_UNIT',      text: '단위'              ,type: 'string'},
            {name: 'PRDCER_CERT_NO',  text: '생산자인증번호'       ,type: 'string', editable: true},
            {name: 'ANT_NUM',         text: '이력번호'           ,type: 'string'},
            {name: 'CONFIRM_CENTER',  text: '친환경인증센터'       ,type: 'string'},
            {name: 'PRINT_CNT',       text: '출력매수'           ,type: 'int', allowBlank: true, defaultValue: 1}

		]
	});
	/**
	 * Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore = Unilite.createStore('s_bcm107rkrv_ypMasterStore1',{
		model: 's_bcm107rkrv_ypModel1',
		uniOpt: {
        	isMaster: false,			// 상위 버튼 연결
        	editable: true,			// 수정 모드 사용
        	deletable: true,			// 삭제 가능 여부
            useNavi: false			// prev | newxt 버튼 사용
        },
        proxy: {
            type: 'direct',
            api: {
                read: 's_bcm107rkrv_ypService.selectList'
            }
        },
        loadStoreRecords : function() {
            var param= panelResult.getValues();
            console.log( param );
            this.load({ params : param});
        },
        autoLoad: false,
		_onStoreDataChanged: function( store, eOpts )	{
       		console.log("_onStoreDataChanged store.count() : ", store.count());
       		if(store.count() == 0)	{
       			UniApp.setToolbarButtons(['delete'], false);
	    		Ext.apply(this.uniOpt.state, {'btn':{'delete':false}});
	    		if(this.uniOpt.useNavi) {
	       			UniApp.setToolbarButtons(['prev','next'], false);
	    		}
       		}else {
       			if(this.uniOpt.deletable)	{
	       			UniApp.setToolbarButtons(['delete'], true);
		    		Ext.apply(this.uniOpt.state, {'btn':{'delete':true}});
       			}
	    		if(this.uniOpt.useNavi) {
	       			UniApp.setToolbarButtons(['prev','next'], true);
	    		}
       		}
	    },

    /**
     *
     * @param {} options
     * @return {}
     */
	    listeners: {
	    	datachanged: function(store){
	    		store.commitChanges();
	    	},
	    	update: function(store){
	    		store.commitChanges();
	    	}
	    }
	});
	var panelPrint = Unilite.createForm('printForm', {
		url: CPATH+'/z_yp/printBarcode',
		colspan: 2,
		layout: {type: 'uniTable', columns: 2},
		height: 30,
		padding: '0 0 0 195',
		disabled:false,
		autoScroll: false,
		standardSubmit: true,
		items:[{
			xtype: 'uniTextfield',
			name: 'data',
			hidden: true
		},{
        	xtype: 'button',
			id: 'printBtnNew',
			width: 120,
			text: '(New)바코드 출력',
			handler : function() {
				if(directMasterStore.getCount() == 0) return false;
				var inValidRecs = directMasterStore.getInvalidRecords();
				if(inValidRecs.length == 0){

					var records =  masterGrid1.getSelectionModel().getSelection();
					Ext.each(records, function(rec, i){
						rec.phantom = true;
						buttonStore.insert(i, rec);
					});
					buttonStore.saveStore();

				}else{
					masterGrid1.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			}
		},{
        	xtype: 'button',
			id: 'printBtn',
			width: 90,
			text: '바코드 출력',
			handler : function() {
				if(directMasterStore.getCount() == 0) return false;
				var inValidRecs = directMasterStore.getInvalidRecords();
				if(inValidRecs.length == 0){
					var form = this.up('uniDetailForm');
					var data = new Array();
					var records = masterGrid1.getSelectedRecords();
					var txt = '';
					Ext.each(records, function(record, index){
					   txt = txt +
					   record.get('CUSTOM_NAME')	+ '|' +
					   record.get('CERT_NO')		+ '|' +
					   record.get('TELEPHON')		+ '|' +
					   record.get('WORK_ADDR')		+ '|' +
					   record.get('ITEM_NAME')		+ '|' +
					   record.get('ORIGIN')			+ '|' +
					   record.get('PRDT_YEAR')		+ '|' +
					   record.get('ORDER_UNIT')		+ '|' +
					   record.get('PRDCER_CERT_NO')	+ '|' +
					   record.get('PRDCER_CERT_NO')	+ '|' +
					   record.get('ANT_NUM')		+ '|' +
					   record.get('CONFIRM_CENTER')	+ '|' +
					   '' 							+ '|' +		//매출처는 공백으로 넘김
					   record.get('PRINT_CNT');

					   if(records.length != index +1){
					       txt = txt + '\r\n';
					   }
					});
					var agent = navigator.userAgent.toLowerCase();
					if ( (navigator.appName == 'Netscape' && navigator.userAgent.search('Trident') != -1) || (agent.indexOf("msie") != -1) /*|| (agent.indexOf("edge/") != -1)*/ ) {
					    var fso=new ActiveXObject('Scripting.FileSystemObject');
                        var fileObj=fso.CreateTextFile("C:\\LABEL\\GREEN01\\omegapluslabel.txt",true,true);
                        fileObj.WriteLine(txt);
                        fileObj.Close();
                        var WshShell = new ActiveXObject("WScript.Shell");
                        WshShell.Run("C:\\LABEL\\GREEN01\\LABEL_GREEN01.EXE", 1);
					} else{
				        alert('라벨 출력은 Internet Explorer를 이용하여 작업하시기 바랍니다.');
                        return false;
					}

//					if(!Ext.isEmpty(window.ActiveXObject)) {
//					    var fso=new ActiveXObject('Scripting.FileSystemObject');
//                        var fileObj=fso.CreateTextFile("C:\\LABEL\\GREEN01\\omegapluslabel.txt",true,true);
//                        fileObj.WriteLine(txt);
//                        fileObj.Close();
//                        var WshShell = new ActiveXObject("WScript.Shell");
//                        WshShell.Run("C:\\LABEL\\GREEN01\\LABEL_GREEN01.EXE", 1);
//					}else{
//				        alert('라벨 출력은 Internet Explorer를 이용하여 작업하시기 바랍니다.');
//                        return false;
//					}


//					form.setValue('data',Ext.encode(data)); // Ext.encode(jJsonData));
//					form.submit();
//					setTimeout(function(){
//							directMasterStore.commitChanges();
//							Ext.Msg.show({
//							    title:'바코드 출력',
//							    message: '파일 다운로드가 완료되면 확인버튼을 클릭하세요',
//							    buttons: Ext.Msg.OKCANCEL,
//							    icon: Ext.Msg.QUESTION,
//							    fn: function(btn) {
//							        if (btn === 'ok') {
//							            try{
//											var WshShell = new ActiveXObject("WScript.Shell");
//											WshShell.Run("C:\\OmegaPlusLabel\\Label.exe", 1);
//										} catch(e) {
//											alert('바코드 출력 프로그램의 정상작동 여부를 확인 후 바코드 버튼을 재실행하세요.');
//										}
//							        } else if (btn === 'cancel') {
//							            alert('바코드 출력이 취소되었습니다.');
//							        } else {
//							            console.log('Cancel pressed');
//							        }
//							    }
//							});
//							/*
//							if(confirm('파일 다운로드가 완료되면 확인버튼을 클릭하세요.'))	{
//								try{
//									var WshShell = new ActiveXObject("WScript.Shell");
//									WshShell.Run("C:\\Windows\\System32\\notepad.exe", 1);
//		//							WshShell.Run("C:\\OmegaPlusLabel\\Label.exe", 1);
//								} catch(e) {
//									alert('바코드 버튼을 재실행하세요.')
//								}
//							}*/
//
//						}
//						, 2000
//					)
				}else{
					masterGrid1.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			}
		}]
	});
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 5},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [
            Unilite.popup('AGENT_CUST',{
            fieldLabel: '거래처',
            valueFieldName: 'CUSTOM_CODE',
            textFieldName: 'CUSTOM_NAME',
            validateBlank: false,
            listeners: {
                applyextparam: function(popup){
                    popup.setExtParam({'AGENT_CUST_FILTER':  ['1','2']});
                    popup.setExtParam({'CUSTOM_TYPE':  ['1','2']});
                }
            }
        }),{
            fieldLabel: '거래처분류',
            name:'AGENT_TYPE',
            xtype: 'uniCombobox',
            comboType:'AU',
            comboCode:'B055'
        },{
            fieldLabel: '기준일자'  ,
            name: 'BASIS_DATE',
            xtype:'uniDatefield',
            allowBlank:false
         },panelPrint
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
		}
    });
    /**
     * Master Grid1 정의(Grid Panel)
     * @type
     */

    var masterGrid1 = Unilite.createGrid('s_bcm107rkrv_ypGrid1', {
    	layout: 'fit',
    	flex: 1,
    	region:'west',
		uniOpt: {
		 	expandLastColumn: false,
		 	useRowNumberer: false,
		 	useContextMenu: true,
		 	onLoadSelectFirst: false
        },
    	store: directMasterStore,
        selModel: Ext.create('Ext.selection.CheckboxModel', {checkOnly: true,
            listeners: {
                beforedeselect: function(rowSelection, record, index, eOpts) {
//                    if(!Ext.isEmpty(record.get('EX_DATE'))){
//                        return false;
//                    }
//
                },
                select: function(grid, selectRecord, index, rowIndex, eOpts ){


//                    selectRecord.set('CHECK_VALUE','Y');
//
//                    var masterRecord = directMasterStore.data.items[0];
//
//                    if(queryButtonFlag != 'M'){
//
//                        masterRecord.set('TOT_AMT_I',masterRecord.get('TOT_AMT_I') + selectRecord.get('J_AMT_I'));
//                    }
//
//                    if(queryButtonFlag2 == 'M'){
//                        selectRecord.set('CHECK_VALUE2','');
//                    }

                },
                deselect:  function(grid, selectRecord, index, eOpts ){
//                  if(selectRecord.get('CONFIRM_YN') == 'N'){
//                      selectRecord.set('SEND_J_AMT_I',selectRecord.get('SEND_J_AMT_I_DUMMY'));
//                  }

//                        selectRecord.set('CHECK_VALUE','');
//
//                        var masterRecord = directMasterStore.data.items[0];
//                        masterRecord.set('TOT_AMT_I',masterRecord.get('TOT_AMT_I') - selectRecord.get('J_AMT_I'));
//    //                  selectRecord.set('CONFIRM_YN',selectRecord.get('CONFIRM_YN_DUMMY'));
//
//                        if(queryButtonFlag2 == 'M'|| !Ext.isEmpty(subForm1.getValue('SEND_NUM'))){
//                        selectRecord.set('CHECK_VALUE2','Y');
//                    }

                    }

            }
        }),
        columns:  [
            { dataIndex: 'CUSTOM_CODE',              width: 80},
            { dataIndex: 'CUSTOM_NAME',              width: 120},
            { dataIndex: 'CERT_NO',                  width: 100},
            { dataIndex: 'TELEPHON',                 width: 100, align: 'center'},
            { dataIndex: 'WORK_ADDR',                width: 180},
            { dataIndex: 'ITEM_NAME',                width: 100},
            { dataIndex: 'ORIGIN',                   width: 180},
            { dataIndex: 'PRDT_YEAR',                width: 70, align: 'center'},
            { dataIndex: 'ORDER_UNIT',               width: 80, align: 'center'},
            { dataIndex: 'PRDCER_CERT_NO',           width: 100},
            { dataIndex: 'ANT_NUM',                  width: 100},
            { dataIndex: 'CONFIRM_CENTER',           width: 100},
            { dataIndex: 'PRINT_CNT',                minWidth: 80, flex: 1}
        ],
		listeners: {
      		beforeedit  : function( editor, e, eOpts ) {
      			/* if (UniUtils.indexOf(e.field, 'SALE_BASIS_P')){
      				return false;
  				} */
			}
		}
    });

    var describedPanel = Unilite.createSearchForm('s_bcm107rkrv_ypDescribedPanel',{
    	region: 'center',
    	padding: '1 1 1 1',
    	flex: 0.3,
    	autoScroll: true,
		layout: {type: 'uniTable', columns: 1,tdAttrs: {valign:'top'}},
		defaults:{labelWidth: 100, margin:'5 0 0 20', width: 600},
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{
			margin:'15 0 0 20',
			xtype:'container',
			html: '<b>◆ 확인사항</b>',
			style: {
				color: 'blue'
			}},{
				xtype:'container',
				margin: '10 0 10 20',
				html: '&nbsp;&nbsp;&nbsp;<b>바코드 라벨출력을 위해서는 다음과 같은 설정을 해야 합니다.</b>'
			},{
				xtype:'container',
				layout: {type: 'uniTable', columns: 2},
				items:[{
					xtype:'container',
					html: '&nbsp;&nbsp;&nbsp;1. Internet Explorer 보안설정 하기.'
				},{
		        	margin: '0 0 0 6',
					xtype: 'button',
					width: 90,
					text: '보안설정 방법',
					handler : function() {
						openSettingWindow();
					}
				}]
			}/*,{
				xtype:'container',
				layout: {type: 'uniTable', columns: 2},
				items:[{
					xtype:'container',
					html: '&nbsp;&nbsp;&nbsp;2.&nbsp;라벨출력프로그램을 C:\omegapluslabel 폴더에 압축을 푼다.'
				},{
		        	margin: '0 0 0 6',
					xtype: 'button',
					text: '출력 프로그램 다운로드',
					handler : function() {

					}
				}]
			}*/,{
				xtype:'container',
				margin: '10 0 0 20',
				html: '&nbsp;&nbsp;&nbsp;3.&nbsp;위 사항이 준비되었으면 [바코드 출력] 버튼을 클릭하여 출력한다.'
			}]
    });


  //라벨 출력을 위한 store
	var buttonStore = Unilite.createStore('s_bcm107rkrv_ypButtonStore',{
		uniOpt: {
			isMaster	: false,		// 상위 버튼 연결
			editable	: false,		// 수정 모드 사용
			deletable	: false,		// 삭제 가능 여부
			useNavi		: false			// prev | newxt 버튼 사용

		},
		proxy		: directButtonProxy,
		saveStore	: function(buttonFlag) {
			var inValidRecs = this.getInvalidRecords();
			var toCreate = this.getNewRecords();
			var paramMaster	= panelResult.getValues();

			if(inValidRecs.length == 0) {
				config = {
					params	: [paramMaster],
					useSavedMessage : false,
					success : function(batch, option) {
						buttonStore.clearData();
					 },

					 failure: function(batch, option) {
						buttonStore.clearData();
					 }
				};
				this.syncAllDirect(config);
			} else {
				var grid = Ext.getCmp('s_bcm107rkrv_ypGrid1');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
			},
			add: function(store, records, index, eOpts) {
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
			},
			remove: function(store, record, index, isMove, eOpts) {
			}
		}
	});

	function openSettingWindow() {
	if(!settingWindow) {
		settingWindow = Ext.create('widget.uniDetailWindow', {
            title: '바코드 출력전 보안 설정',
            resizable:false,
            width: 1200,
            height:1000,
            autoScroll: true,
            layout: {type:'uniTable', columns: 1},
            items: [{
            	xtype: 'image',
            	src:CPATH+'/resources/images/barcodeSetting1.png',
            	overflow:'auto'
            }, {
            	xtype: 'image',
            	src:CPATH+'/resources/images/barcodeSetting2.png',
            	overflow:'auto'
            }],
            tbar:  ['->',{
					itemId : 'closeBtn',
					text: '닫기',
					handler: function() {
						settingWindow.hide();
					},
					disabled: false
				}
			]})
		}
		settingWindow.show();
	}
	Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid1, panelResult, describedPanel
			]
		}
		],
		fnInitBinding: function(params) {
			panelResult.setValue('BASIS_DATE', UniDate.get('today'));
			UniAppManager.setToolbarButtons('newData',true);
			UniAppManager.setToolbarButtons('reset',true);
			this.processParams(params);
		},
        onQueryButtonDown: function()   {
            if(!panelResult.setAllFieldsReadOnly(true)){
                return false;
            }
            masterGrid1.getStore().loadStoreRecords();
        },
		onNewDataButtonDown : function(additemCode)	{
			if(!this.checkForNewDetail()) return false;
			if(additemCode){
				 var r = {
					SALE_BASIS_P: Ext.util.Format.number(additemCode.SALE_BASIS_P,'0,000' ),
					ITEM_CODE: additemCode.ITEM_CODE,
					ITEM_NAME: additemCode.ITEM_NAME
		        };

			}
			masterGrid1.createRow(r);
			panelResult.setAllFieldsReadOnly(true);
		},
		onDeleteDataButtonDown: function() {
			var selRow = masterGrid1.getSelectedRecord();
			if(! Ext.isEmpty(selRow)){
				if(selRow.phantom === true)	{
						masterGrid1.deleteSelectedRow();
				}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
						masterGrid1.deleteSelectedRow();
				}
			}
		},
		onResetButtonDown: function() {
			panelResult.setAllFieldsReadOnly(false);
			panelResult.clearForm();
			masterGrid1.reset();
			directMasterStore.clearData();
			this.fnInitBinding();
		},
		processParams: function(params) {
			if(params && params.ITEM_CODE) {
				UniAppManager.app.onNewDataButtonDown(params);
			}
		},
		checkForNewDetail:function() {
			return panelResult.setAllFieldsReadOnly(true);
        }
	});
    /**
     * Validation
     */
    Unilite.createValidator('validator01', {
        store: directMasterStore,
        grid: masterGrid1,
        validate: function( type, fieldName, newValue, oldValue, record, eopt, editor, e) {
            if(newValue == oldValue){
                return false;
            }
            var rv = true;
            switch(fieldName) {
                case "PRDT_YEAR" :
                    if(isNaN(newValue)) {
                        rv=Msg.sMB074;
                        break;
                    }
                    break;

            }

            return rv;
        }
    }); // validator
};

</script>
