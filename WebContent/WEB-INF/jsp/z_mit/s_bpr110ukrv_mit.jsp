<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_bpr110ukrv_mit"  >
	
	<t:ExtComboStore comboType="BOR120" pgmId="s_sas100ukrv_mit"/>
	
</t:appConfig>
<script type="text/javascript" charset="UTF-8" src='<c:url value="/resources/plupload/plupload.full.js" />'></script>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

function appMain() {  


	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 's_bpr110ukrv_mitService.selectItem4'
		}
	});	
	
	Unilite.defineModel('s_bpr110ukrv_mitModel', {
	    fields: [  	  
	    	{name: 'DIV_CODE'			, text: '사업장'		, type: 'string', comboType: 'BOR120', editable:false},
	    	{name: 'PROD_ITEM_CODE'		, text: '모품목코드' 	, type: 'string', editable:false},
	    	{name: 'CHILD_ITEM_CODE'	, text: '품목코드' 	, type: 'string'},
	    	{name: 'ITEM_NAME'			, text: '품목명' 		, type: 'string'},
	    	{name: 'SPEC'				, text: '규격'		, type: 'string', editable:false},
	    	{name: 'STOCK_UNIT'			, text: '단위'		, type: 'string', editable:false},
	    	{name: 'UNIT_Q'				, text: '원단위량'		, type: 'float', format:'0,000.000000', decimalPrecision:6},
	    	{name: 'PROD_UNIT_Q'		, text: '모품목기준수'	, type: 'uniQty'},
	    	{name: 'START_DATE'			, text: '구성시작일'	, type: 'uniDate' , defaultValue: UniDate.get('startOfMonth')},
	    	{name: 'STOP_DATE'			, text: '구성종료일'	, type: 'uniDate' , defaultValue: '29991231'},
	    	{name: 'flag'				, text: 'flag'      , type: 'string'}
		]
	});
	
	var directMasterStore = Unilite.createStore('s_bpr110ukrv_mitMasterStore',{
		model: 's_bpr110ukrv_mitModel',
		uniOpt: {
            isMaster: false,			// 상위 버튼 연결 
            editable: true,			// 수정 모드 사용 
            deletable: true,			// 삭제 가능 여부 
	        useNavi: false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy:directProxy,
        loadStoreRecords: function() {
			var param= {
					'DIV_CODE' : panelResult.getValue("DIV_CODE"), 
					'PROD_ITEM_CODE':panelResult.getValue("ITEM_CODE"), 
					'START_DATE' : UniDate.getDbDateStr(panelResult.getValue("START_DATE")) 
			};			
			this.load({
				params : param
			});
		}
	});
	
	var bomProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			create: 's_bpr110ukrv_mitService.insertBOM',
			syncAll: 's_bpr110ukrv_mitService.saveAll'
		}
	});	
	var bomStore = Unilite.createStore('s_bpr110ukrv_mitBomStore',{
		model: 's_bpr110ukrv_mitModel',
		uniOpt: {
            isMaster: false,			// 상위 버튼 연결 
            editable: true,			// 수정 모드 사용 
            deletable: false,			// 삭제 가능 여부 
	        useNavi: false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy:bomProxy,
		saveStore : function()	{	
			var me = this;
			var checkParam = {
				'DIV_CODE'        : panelResult.getValue("DIV_CODE"),
				'PROD_ITEM_CODE'  : masterForm1.getValue("ITEM_CODE"),
				'START_DATE'      : UniDate.getDbDateStr(panelResult.getValue("START_DATE"))
			};
			s_bpr110ukrv_mitService.selectCheckBom(checkParam, function(responseText){
				var confirmYn = false;
				if(responseText && responseText.CNT > 0 )	{
					if(confirm("Bom 정보가 등록되어 있습니다. 삭제 하시겠습니까?")) {
						s_bpr110ukrv_mitService.deleteBom(checkParam, function(responseText){
							bomStore.saveBomData();
						});
					} 
					return;
				} else {
					me.saveBomData();
				}
				
			});
		},
		saveBomData : function()	{
			var me = this;
			me.loadData({});
			var startDate = UniDate.getDbDateStr(panelResult.getValue("START_DATE"));
			me.insert(0, [Ext.create('s_bpr110ukrv_mitModel', {
				'DIV_CODE'        : panelResult.getValue("DIV_CODE"),
				'PROD_ITEM_CODE'  : masterForm1.getValue("ITEM_CODE"),
				'CHILD_ITEM_CODE' : '$',
				'SEQ'             : 0,
				'UNIT_Q'          : Ext.isEmpty(masterForm1.getValue("UNIT_Q"))     ? 1 : masterForm1.getValue("UNIT_Q"),
				'PROD_UNIT_Q'     : Ext.isEmpty(masterForm1.getValue("PROD_UNIT_Q"))? 1 : masterForm1.getValue("PROD_UNIT_Q") ,
				'START_DATE'      : startDate, 
				'STOP_DATE'       : Ext.isEmpty(masterForm1.getValue("STOP_DATE"))  ? '29991231' : masterForm1.getValue("STOP_DATE")
			})]);

			me.insert(1, [Ext.create('s_bpr110ukrv_mitModel',{
				'DIV_CODE'        : panelResult.getValue("DIV_CODE"),
				'PROD_ITEM_CODE'  : masterForm1.getValue("ITEM_CODE"),
				'CHILD_ITEM_CODE' : masterForm2.getValue("ITEM_CODE"),
				'SEQ'             : 3,
				'UNIT_Q'          : Ext.isEmpty(masterForm2.getValue("UNIT_Q"))     ? 1 : masterForm2.getValue("UNIT_Q"),
				'PROD_UNIT_Q'     : Ext.isEmpty(masterForm2.getValue("PROD_UNIT_Q"))? 1 : masterForm2.getValue("PROD_UNIT_Q") ,
				'START_DATE'      : startDate, 
				'STOP_DATE'       : Ext.isEmpty(masterForm2.getValue("STOP_DATE"))  ? '29991231' : masterForm2.getValue("STOP_DATE")
			})]);
			me.insert(2, [Ext.create('s_bpr110ukrv_mitModel',{
				'DIV_CODE'        : panelResult.getValue("DIV_CODE"),
				'PROD_ITEM_CODE'  : masterForm1.getValue("ITEM_CODE"),
				'CHILD_ITEM_CODE' : masterForm3.getValue("ITEM_CODE"),
				'SEQ'             : 2,
				'UNIT_Q'          : Ext.isEmpty(masterForm3.getValue("UNIT_Q"))     ? 1 : masterForm3.getValue("UNIT_Q"),
				'PROD_UNIT_Q'     : Ext.isEmpty(masterForm3.getValue("PROD_UNIT_Q"))? 1 : masterForm3.getValue("PROD_UNIT_Q") ,
				'START_DATE'      : startDate, 
				'STOP_DATE'       : Ext.isEmpty(masterForm3.getValue("STOP_DATE"))  ? '29991231' : masterForm3.getValue("STOP_DATE")
			})]);
			var paramMaster= masterForm1.getValues();
			var inx = 3
			Ext.each(directMasterStore.getData().items, function(record, idx)	{
				inx = idx+3;
				me.insert(inx, [Ext.create('s_bpr110ukrv_mitModel',{
					'DIV_CODE'        : panelResult.getValue("DIV_CODE"),
					'PROD_ITEM_CODE'  : paramMaster.ITEM_CODE,
					'CHILD_ITEM_CODE' : record.get('CHILD_ITEM_CODE'),
					'UNIT_Q'          : record.get("UNIT_Q"),
					'SEQ'             : idx+4,
					'PROD_UNIT_Q'     : record.get("PROD_UNIT_Q"),
					'START_DATE'      : record.get("START_DATE"),
					'STOP_DATE'       : record.get("STOP_DATE")
				})]);
			})
			Ext.each(directMasterStore.getRemovedRecords(), function(record, idx)	{
				
				me.insert(inx+idx+1, [Ext.create('s_bpr110ukrv_mitModel',{
					'DIV_CODE'        : panelResult.getValue("DIV_CODE"),
					'PROD_ITEM_CODE'  : paramMaster.ITEM_CODE,
					'CHILD_ITEM_CODE' : record.get('CHILD_ITEM_CODE'),
					'UNIT_Q'          : record.get("UNIT_Q"),
					'SEQ'             : inx+idx+2,
					'PROD_UNIT_Q'     : record.get("PROD_UNIT_Q"),
					'START_DATE'      : record.get("START_DATE"),
					'STOP_DATE'       : record.get("STOP_DATE"),
					'flag'            : 'D'
				})]);
			})
			var inValidRecs = this.getInvalidRecords();
        	var rv = true;
			if(inValidRecs.length == 0 )	{
				directMasterStore.commitChanges();
				this.syncAllDirect();
			}else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 3, tableAttrs:{border : 0, width:'1210'}},
		padding:'0 0 0 0',
		border : 0,
		bodyStyle : {'background-color':'#fff;border-width: 0px;'},
		items: [{
				fieldLabel	: '<t:message code="system.label.sales.division" default="사업장"/>'  ,
				name		: 'DIV_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
				value		: UserInfo.divCode,
				allowBlank	: false,
				hidden      : true
			},Unilite.popup('DIV_PUMOK',{
				fieldLabel:'품목',
				valueFieldName:'ITEM_CODE',
				textFieldName:'ITEM_NAME',
				extraFieldsConfig:[{extraFieldName:'SPEC', extraFieldWidth:153}],
				autoPopup : true,
				listeners:{
					onSelected: {
						fn: function(records, type) {
							masterForm1.clearForm();
							masterForm2.clearForm();
							masterForm3.clearForm();
							directMasterStore.loadData({});
							if(records) {
								panelResult.setValue('ITEM_CODE', records[0]["ITEM_CODE"]);
								panelResult.setValue('ITEM_NAME', records[0]["ITEM_NAME"]);
								panelResult.setValue('SPEC', records[0]["SPEC"]);
 								masterForm1.loadData();
 								masterForm2.loadData();
 								masterForm3.loadData();
							}
						}
					},
					onClear: function(type) {
						panelResult.setValue('ITEM_CODE','');
						panelResult.setValue('ITEM_NAME','');
						panelResult.setValue('SPEC', '');
						masterForm1.clearForm();
						masterForm2.clearForm();
						masterForm3.clearForm();
						directMasterStore.loadData({});
					},
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': panelResult.getValue("DIV_CODE"), 'ITEM_ACCOUNT': '10'});
					}
	        	}
			}),{
				xtype:'uniDatefield',
				name : 'START_DATE',
				fieldLabel : 'BOM구성시작일',
				tdAttrs : {width : 500, align :'right'},
				hidden : false
			},{
				xtype:'button',
				text : 'BOM 생성',
				tdAttrs : {width : 100, align :'right'},
				handler : function()	{
					bomStore.saveStore();
				}
			}
		]
			
	});	
	
	
	var masterForm1 = Unilite.createForm('s_bpr110ukrv_mitmasterForm1',{		
    	region: 'north',		
    	autoScroll: true,  		
    	padding: '0 0 0 0' ,	
    	disabled : false,
    	bodyStyle : {'background-color':'#fff;border-width: 0px;'},
    	layout : {type : 'uniTable', columns : 1, tableAttrs:{border:0}},
    	api: {
    		load: 's_bpr110ukrv_mitService.selectItem1',
			submit: 's_bpr110ukrv_mitService.updateItem'				
		},
		items: [{
			xtype : 'fieldset',
			title : '1.제품',
			layout : {type : 'uniTable', columns : 5}, 
			style : {margin: '10px',  padding: '2px 20px 2px 2px',},
			items :[
					Unilite.popup('DIV_PUMOK',{
						fieldLabel:'품목',
						valueFieldName:'ITEM_CODE',
						textFieldName:'ITEM_NAME',
						allowInputData :true,
						validateBlank : false,
						extraFieldsConfig:[{extraFieldName:'SPEC', extraFieldWidth:153, readOnly:false}],
						allowInputData : true,
						autoPopup : true,
						colspan : 2,
						listeners:{
							onSelected: {
								fn: function(records, type) {
									if(records) {
										masterForm1.setValue('DIV_CODE', records[0]["DIV_CODE"]);
										masterForm1.setValue('ITEM_CODE', records[0]["ITEM_CODE"]);
										masterForm1.setValue('ITEM_NAME', records[0]["ITEM_NAME"]);
										masterForm1.setValue('SPEC', records[0]["SPEC"]);
										masterForm1.setValue('UNIT_Q', 1);
										masterForm1.setValue('PROD_UNIT_Q', 1);
									}
								}
							},
							onClear: function(type) {
								masterForm1.setValue('DIV_CODE', '');
								masterForm1.setValue('ITEM_CODE', '');
								masterForm1.setValue('ITEM_NAME', '');
								masterForm1.setValue('SPEC', '')
							},
							applyextparam: function(popup){
								popup.setExtParam({'DIV_CODE': panelResult.getValue("DIV_CODE"), 'ITEM_ACCOUNT': '10', 'ADD_QUERY3' : " AND (ISNULL( '"+masterForm1.getValue("SPEC")+"', '') = '' OR SPEC = '"+masterForm1.getValue("SPEC")+"' )"});
							}
			        	}
					}),{
						xtype:'button',
						text : '품목정보반영',
						width : 120,
						tdAttrs : {width:352, style:'padding-left:10px;'},
						handler : function()	{
							var param = {'ITEM_CODE' : masterForm1.getValue("ITEM_CODE")};
							s_bpr110ukrv_mitService.selectCheckItem (param , function(responseText){
								if(responseText)	{
									if(responseText.CNT > 0 )	{
										masterForm1.submit({
											success:function() {
												UniAppManager.updateStatus('저장되었습니다.');
											}
										});
									} else {
										if(Ext.isEmpty(panelResult.getValue("ITEM_CODE")))	{
											Unilite.messageBox("품목코드를 입력하세요.");
											panelResult.getField("ITEM_CODE").focus();
											return;
										}
										var params = masterForm1.getValues()
										params.DIV_CODE = panelResult.getValue("DIV_CODE");
										params.ORG_ITEM_CODE = panelResult.getValue("ITEM_CODE");
										s_bpr110ukrv_mitService.insertNewItem(params, function(responseText){
											if(responseText)	{
												UniAppManager.updateStatus("품목이 생성되었습니다.");
											}
										})
									}
								}
							})
							
						}
					},{
						xtype : 'component',
						html :'&nbsp;',
						width : 150
					} ,{
						xtype:'button',
						iconCls : 'icon-link'	,
						text : '품목추가정보연결',
						width : 140,
						height : 25,
						tdAttrs : {width:150, align :'right'},
						handler : function()	{
							if(!Ext.isEmpty(masterForm1.getValue("ITEM_CODE")))	{
								var params = {
									DIV_CODE : panelResult.getValue("DIV_CODE"),
									ITEM_CODE: masterForm1.getValue("ITEM_CODE"),
									ITEM_NAME: masterForm1.getValue("ITEM_NAME")
								}
								var rec = {data : {prgID : 's_bpr200ukrv_mit', 'text':''}};
								parent.openTab(rec, '/z_mit/s_bpr200ukrv_mit.do', params);
							} else {
								Unilite.messageBox("품목정보를 입력하세요.")
							}
						}
					},{
						xtype: 'uniTextfield',
			    		fieldLabel: '특이사항',
			    		name: 'REMARK1',
			    		width : 478
					},{
						xtype: 'uniTextfield',
			    		fieldLabel: '주요사항',
			    		name: 'REMARK2',
			    		labelWidth : 60,
			    		colspan :2,
			    		width : 350
					},{
						xtype: 'uniTextfield',
			    		fieldLabel: '라쏘',
			    		name: 'REMARK3',
			    		colspan : 2,
			    		labelWidth : 60,
			    		width : 350
					}, {
						xtype : 'uniTextfield',
						name  : 'PROD_ITEM_CODE',
						hidden : true,
					}, {
						xtype : 'uniNumberfield',
						name  : 'UNIT_Q',
						hidden : true,
					}, {
						xtype : 'uniNumberfield',
						name  : 'PROD_UNIT_Q',
						hidden : true,
					},{
						xtype : 'uniNumberfield',
						name  : 'SEQ',
						value : 0,
						hidden : true,
					},{
						xtype : 'uniDatefield',
						name  : 'START_DATE',
						hidden : true,
					},{
						xtype : 'uniDatefield',
						name  : 'STOP_DATE',
						hidden : true,
					}]
			}],
			loadData:function(){
				masterForm1.mask();
				panelResult.setValue(UniDate.get("startOfMonth"));
				masterForm1.getForm().load(
					{
						params : {
							'DIV_CODE':panelResult.getValue("DIV_CODE"), 
							'PROD_ITEM_CODE':panelResult.getValue("ITEM_CODE")
					 	}, 
					 	success:function(){
					 		masterForm1.unmask();
					 		panelResult.setValue("START_DATE", masterForm1.getValue("START_DATE"));
							//참조 품목의 구성시작일을 셋팅하기 위해 여기서 호출함
					 		directMasterStore.loadStoreRecords();
					 	}, 
					 	failure:function(){
					 		masterForm1.unmask();
					 	}
					 
				});
			}
	});
	
	var masterForm2 = Unilite.createForm('s_bpr110ukrv_mitmasterForm2',{		
    	region: 'north',		
    	autoScroll: true,  		
    	padding: '0 0 0 0' ,	
    	disabled : false,
    	bodyStyle : {'background-color':'#fff;border-width: 0px;'},
    	layout : {type : 'uniTable', columns : 1, tableAttrs:{border:0}},
    	api: {
    		load: 's_bpr110ukrv_mitService.selectItem2',
			submit: 's_bpr110ukrv_mitService.updateItem'				
		}, 
		items: [{
			xtype : 'fieldset',
			title : '2.삽입기구 ',
			layout : {type : 'uniTable', columns : 5, tableAttrs:{border:0}}, 
			style : {margin: '10px',  padding: '2px 20px 2px 2px'},
			items :[
					Unilite.popup('DIV_PUMOK',{
						fieldLabel:'품목',
						valueFieldName:'ITEM_CODE',
						textFieldName:'ITEM_NAME',
						extraFieldsConfig:[{extraFieldName:'SPEC', extraFieldWidth:153}],
						autoPopup : true,
						listeners:{
							onSelected: {
								fn: function(records, type) {
									if(records) {
										masterForm2.setValue('DIV_CODE', records[0]["DIV_CODE"]);
										masterForm2.setValue('ITEM_CODE', records[0]["ITEM_CODE"]);
										masterForm2.setValue('ITEM_NAME', records[0]["ITEM_NAME"]);
										masterForm2.setValue('SPEC', records[0]["SPEC"]);
										masterForm2.setValue('REMARK1', records[0]["REMARK1"]);
										masterForm2.setValue('REMARK2', records[0]["REMARK2"]);
										masterForm2.setValue('REMARK3', records[0]["REMARK3"]);
										masterForm2.setValue('UNIT_Q', 1);
										masterForm2.setValue('PROD_UNIT_Q', 1);
									}
								}
							},
							onClear: function(type) {
								masterForm2.setValue('DIV_CODE', '');
								masterForm2.setValue('ITEM_CODE', '');
								masterForm2.setValue('ITEM_NAME', '');
								masterForm2.setValue('SPEC', '');
								masterForm2.setValue('REMARK1', '');
								masterForm2.setValue('REMARK2', '');
								masterForm2.setValue('REMARK3', '');
								masterForm2.setValue('UNIT_Q', 0);
								masterForm2.setValue('PROD_UNIT_Q', 0);
							},
							applyextparam: function(popup){
								popup.setExtParam({'DIV_CODE': panelResult.getValue("DIV_CODE"), 'ITEM_ACCOUNT': '20'});
							}
			        	}
					}),{
						xtype:'button',
						text : '품목정보반영',
						width : 120,
						tdAttrs : {width:152, style:'padding-left:10px;'},
						handler : function()	{
							masterForm2.submit({
								success:function() {
									UniAppManager.updateStatus('저장되었습니다.');
								}
							});
						}
					},{
						xtype:'button',
						iconCls : 'icon-link'	,
						text : '반제품제작의뢰',
						width : 140,
						height : 25,
						tdAttrs : {width:200},
						handler : function()	{
							var params = masterForm2.getValues();
							params.DIV_CODE = panelResult.getValue("DIV_CODE");
							params.START_DATE = UniDate.getDbDateStr(params.START_DATE);
							params.STOP_DATE = UniDate.getDbDateStr(params.STOP_DATE);
					 		
							var rec = {data : {prgID : 's_bpr120ukrv_mit', 'text':''}};
							parent.openTab(rec, '/z_mit/s_bpr120ukrv_mit.do', params);
						}
					},{
						xtype:'button',
						iconCls : 'icon-link'	,
						text : '품목추가정보연결',
						width : 140,
						height : 25,
						colspan : 2,
						tdAttrs : {width:150, align :'right'},
						handler : function()	{
							if(!Ext.isEmpty(masterForm2.getValue("ITEM_CODE")))	{
								var params = {
									DIV_CODE: panelResult.getValue("DIV_CODE"),
									ITEM_CODE: masterForm2.getValue("ITEM_CODE"),
									ITEM_NAME: masterForm2.getValue("ITEM_NAME")
								}
								var rec = {data : {prgID : 's_bpr200ukrv_mit', 'text':''}};
								parent.openTab(rec, '/z_mit/s_bpr200ukrv_mit.do', params);
							} else {
								Unilite.messageBox("품목정보를 입력하세요.")
							}
						}
					},{
						xtype: 'uniTextfield',
			    		fieldLabel: '비고1',
			    		name: 'REMARK1',
			    		width : 478
					},{
						xtype: 'uniTextfield',
			    		fieldLabel: '비고2',
			    		name: 'REMARK2',
			    		labelWidth : 60,
			    		colspan:2,
			    		width : 350
					},{
						xtype: 'uniTextfield',
			    		fieldLabel: '비고3',
			    		name: 'REMARK3',
			    		labelWidth : 60,
			    		//colspan : 2,
			    		width : 350
					}, {
						xtype : 'uniTextfield',
						name  : 'PROD_ITEM_CODE',
						hidden : true,
					}, {
						xtype : 'uniNumberfield',
						name  : 'UNIT_Q',
						hidden : true,
					}, {
						xtype : 'uniNumberfield',
						name  : 'PROD_UNIT_Q',
						hidden : true,
					},{
						xtype : 'uniNumberfield',
						name  : 'SEQ',
						value : 1,
						hidden : true,
					},{
						xtype : 'uniDatefield',
						name  : 'START_DATE',
						hidden : true,
					},{
						xtype : 'uniDatefield',
						name  : 'STOP_DATE',
						hidden : true,
					},{
						xtype: 'uniTextfield',
			    		fieldLabel: '참조품목코드',
			    		name: 'ORG_ITEM_CODE',
						hidden : true,
					},{
						xtype: 'uniTextfield',
			    		fieldLabel: '참조품목코드명',
			    		name: 'ORG_ITEM_NAME',
						hidden : true,
					},{
						xtype: 'uniTextfield',
			    		fieldLabel: '참조품목규격',
			    		name: 'ORG_SPEC',
						hidden : true,
					}]
		}],
		loadData:function(){
			masterForm2.mask();
			masterForm2.getForm().load(
				{
					params : {
						'DIV_CODE':panelResult.getValue("DIV_CODE"), 
						'PROD_ITEM_CODE':panelResult.getValue("ITEM_CODE")
				 	}, 
				 	success:function(){
				 		masterForm2.unmask();
				 	}, 
				 	failure:function(){
				 		masterForm2.unmask();
				 	}
				 
			});
		}
	});
	
	var masterForm3 = Unilite.createForm('s_bpr110ukrv_mitmasterForm3',{		
    	region: 'north',		
    	autoScroll: true,  		
    	padding: '0 0 0 0' ,	
    	disabled : false,
    	bodyStyle : {'background-color':'#fff;border-width: 0px;'},
    	layout : {type : 'uniTable', columns : 1, tableAttrs:{border:0}},
    	api: {
    		load: 's_bpr110ukrv_mitService.selectItem3',
			submit: 's_bpr110ukrv_mitService.updateItem'				
		}, 
		items: [{
			xtype : 'fieldset',
			title : '3. 코팅 스텐트 / 베어스텐트',
			layout : {type : 'uniTable', columns : 5}, 
			style : {margin: '10px',  padding: '2px 20px 2px 2px'},
			items :[
					Unilite.popup('DIV_PUMOK',{
						fieldLabel:'품목',
						valueFieldName:'ITEM_CODE',
						textFieldName:'ITEM_NAME',
						extraFieldsConfig:[{extraFieldName:'SPEC', extraFieldWidth:153}],
						autoPopup : true,
						listeners:{
							onSelected: {
								fn: function(records, type) {
									if(records) {
										masterForm3.setValue('DIV_CODE', records[0]["DIV_CODE"]);
										masterForm3.setValue('ITEM_CODE', records[0]["ITEM_CODE"]);
										masterForm3.setValue('ITEM_NAME', records[0]["ITEM_NAME"]);
										masterForm3.setValue('SPEC', records[0]["SPEC"]);
										masterForm3.setValue('REMARK1', records[0]["REMARK1"]);
										masterForm3.setValue('REMARK2', records[0]["REMARK2"]);
										masterForm3.setValue('REMARK3', records[0]["REMARK3"]);
										masterForm3.setValue('UNIT_Q', 1);
										masterForm3.setValue('PROD_UNIT_Q', 1);
									}
								}
							},
							onClear: function(type) {
								masterForm3.setValue('DIV_CODE', '');
								masterForm3.setValue('ITEM_CODE', '');
								masterForm3.setValue('ITEM_NAME', '');
								masterForm3.setValue('SPEC', '');
								masterForm3.setValue('REMARK1', '');
								masterForm3.setValue('REMARK2', '');
								masterForm3.setValue('REMARK3', '');
								masterForm3.setValue('UNIT_Q', 0);
								masterForm3.setValue('PROD_UNIT_Q', 0);
							},
							applyextparam: function(popup){
								popup.setExtParam({'DIV_CODE': panelResult.getValue("DIV_CODE"), 'ITEM_ACCOUNT': '20'});
							}
			        	}
					}),{
						xtype:'button',
						text : '품목정보반영',
						width : 120,
						tdAttrs : {width:152, style:'padding-left:10px;'},
						handler : function()	{
							masterForm3.submit({
								success:function() {
									UniAppManager.updateStatus('저장되었습니다.');
								}
							});
						}
					},{
						xtype:'button',
						iconCls : 'icon-link'	,
						text : '반제품제작의뢰',
						width : 140,
						height : 25,
						tdAttrs : {width:200},
						handler : function()	{
							var params = masterForm3.getValues();
							params.DIV_CODE = panelResult.getValue("DIV_CODE");
							params.START_DATE = UniDate.getDbDateStr(params.START_DATE);
							params.STOP_DATE = UniDate.getDbDateStr(params.STOP_DATE);
					 		
							var rec = {data : {prgID : 's_bpr120ukrv_mit', 'text':''}};
							parent.openTab(rec, '/z_mit/s_bpr120ukrv_mit.do', params);
						}
					},{
						xtype:'button',
						iconCls : 'icon-link'	,
						text : '품목추가정보연결',
						width : 140,
						height : 25,
						colspan : 2,
						tdAttrs : {width:160, align :'right'},
						handler : function()	{
							if(!Ext.isEmpty(masterForm3.getValue("ITEM_CODE")))	{
						
								var params = {
									DIV_CODE: panelResult.getValue("DIV_CODE"),
									ITEM_CODE: masterForm3.getValue("ITEM_CODE"),
									ITEM_NAME: masterForm3.getValue("ITEM_NAME")
								}
								var rec = {data : {prgID : 's_bpr200ukrv_mit', 'text':''}};
								parent.openTab(rec, '/z_mit/s_bpr200ukrv_mit.do', params);
							} else {
								Unilite.messageBox("품목정보를 입력하세요.")
							}
						}
					},{
						xtype: 'uniTextfield',
			    		fieldLabel: '비고1',
			    		name: 'REMARK1',
			    		width : 478
					},{
						xtype: 'uniTextfield',
			    		fieldLabel: '비고2',
			    		labelWidth : 60,
			    		name: 'REMARK2',
			    		colspan:2,
			    		width : 350
					},{
						xtype: 'uniTextfield',
			    		fieldLabel: '비고3',
			    		name: 'REMARK3',
			    		labelWidth : 60,
			    		colspan : 2,
			    		width : 350
					}, {
						xtype : 'uniTextfield',
						name  : 'PROD_ITEM_CODE',
						hidden : true,
					}, {
						xtype : 'uniNumberfield',
						name  : 'UNIT_Q',
						hidden : true,
					}, {
						xtype : 'uniNumberfield',
						name  : 'PROD_UNIT_Q',
						hidden : true,
					},{
						xtype : 'uniNumberfield',
						name  : 'SEQ',
						value : 2,
						hidden : true,
					},{
						xtype : 'uniDatefield',
						name  : 'START_DATE',
						hidden : true,
					},{
						xtype : 'uniDatefield',
						name  : 'STOP_DATE',
						hidden : true,
					},{
						xtype: 'uniTextfield',
			    		fieldLabel: '참조품목코드',
			    		name: 'ORG_ITEM_CODE',
						hidden : true,
					},{
						xtype: 'uniTextfield',
			    		fieldLabel: '참조품목코드명',
			    		name: 'ORG_ITEM_NAME',
						hidden : true,
					},{
						xtype: 'uniTextfield',
			    		fieldLabel: '참조품목규격',
			    		name: 'ORG_SPEC',
						hidden : true,
					}]
		}],
		loadData:function(){
			masterForm3.mask();
			masterForm3.getForm().load(
				{
					params : {
						'DIV_CODE':panelResult.getValue("DIV_CODE"), 
						'PROD_ITEM_CODE':panelResult.getValue("ITEM_CODE")
				 	}, 
				 	success:function(){
				 		masterForm3.unmask();
				 	}, 
				 	failure:function(){
				 		masterForm3.unmask();
				 	}
				 
			});
		}
	});
    var masterGrid = Unilite.createGrid('s_bpr110ukrv_mitGrid', {
        store: directMasterStore,
        title : '4.원부자재',
    	region: 'center',
    	flex:1,
    	minHeight : 80,
    	columns:  [
        	{dataIndex: 'DIV_CODE'       	,		width: 70, hidden :true},
        	{dataIndex: 'CHILD_ITEM_CODE'	    	,		width: 100,
        	 editor:Unilite.popup('DIV_PUMOK_G', {
        		textFieldName:'CHILD_ITEM_CODE',
 				DBtextFieldName: 'ITEM_CODE',
 				autoPopup : true,
 				extParam:{'DIV_CODE': panelResult.getValue("DIV_CODE")},
        		 listeners:{
 	        		onSelected: {
 						fn: function(records, type) {
 							if(records) {
 								var record = masterGrid.uniOpt.currentRecord;
 								record.set('DIV_CODE', records[0]["DIV_CODE"]);
 								record.set('CHILD_ITEM_CODE', records[0]["ITEM_CODE"]);
 								record.set('ITEM_NAME', records[0]["ITEM_NAME"]);
 								record.set('SPEC', records[0]["SPEC"]);
 								record.set('STOCK_UNIT', records[0]["STOCK_UNIT"]);
 							}
 						},
 						scope: this
 					},
 					onClear: function(type) {
 						var record = masterGrid.uniOpt.currentRecord;
 						record.set('DIV_CODE', '');
 						record.set('CHILD_ITEM_CODE', '');
 						record.set('ITEM_NAME', '');
 						record.set('SPEC', '');
 						record.set('STOCK_UNIT', '');
 					},
 					applyextparam: function(popup){
 						var record = masterGrid.uniOpt.currentRecord;
 						popup.setExtParam({'DIV_CODE': record.get("DIV_CODE"), 'ITEM_ACCOUNT' : ['40','50','60'] , 'ITEM_ACCOUNT_FILTER': ['40','50','60']});
 					}
 	        	}
        	 })
        	},
        	{dataIndex: 'ITEM_NAME'	    	,		width: 100,
        		editor:Unilite.popup('DIV_PUMOK_G', {
     				autoPopup : true,
     				extParam:{'DIV_CODE': panelResult.getValue("DIV_CODE")},
            		 listeners:{
     	        		onSelected: {
     						fn: function(records, type) {
     							if(records) {
     								var record = masterGrid.uniOpt.currentRecord;
     								record.set('DIV_CODE', records[0]["DIV_CODE"]);
     								record.set('CHILD_ITEM_CODE', records[0]["ITEM_CODE"]);
     								record.set('ITEM_NAME', records[0]["ITEM_NAME"]);
     								record.set('SPEC', records[0]["SPEC"]);
     								record.set('STOCK_UNIT', records[0]["STOCK_UNIT"]);
     							}
     						},
     						scope: this
     					},
     					onClear: function(type) {
     						var record = masterGrid.uniOpt.currentRecord;
     						record.set('DIV_CODE', '');
     						record.set('CHILD_ITEM_CODE', '');
     						record.set('ITEM_NAME', '');
     						record.set('SPEC', '');
     						record.set('STOCK_UNIT', '');
     					},
     					applyextparam: function(popup){
     						var record = masterGrid.uniOpt.currentRecord;
     						popup.setExtParam({'DIV_CODE': record.get("DIV_CODE"), 'ITEM_ACCOUNT' : ['40','50','60'] , 'ITEM_ACCOUNT_FILTER': ['40','50','60']});
     					}
     	        	}
            	 })
        	},
        	{dataIndex: 'SPEC'	    		, width: 230},
        	{dataIndex: 'STOCK_UNIT'	    , width: 100},
    		{dataIndex: 'UNIT_Q'	    	, width: 80},
        	{dataIndex: 'PROD_UNIT_Q'	    , width: 110},
        	{dataIndex: 'START_DATE'	    , width:110},
        	{dataIndex: 'STOP_DATE'	    	, width: 110}
        	
		],
		listeners:{
			select : function( grid, selected ) {
				if(selected)	{
					UniAppManager.setToolbarButtons(['delete'],true);
				} else {
					UniAppManager.setToolbarButtons(['delete'],false);
				}
			},
			deselect  : function( grid, selected ) {
				UniAppManager.setToolbarButtons(['delete'],false);
			}
		}
    });  
    
	Unilite.Main( {
		borderItems:[
			{
				region:'center',
				layout: 'border',
				border: false,
				items:[
					panelResult, 
					masterForm1, 
					masterForm2,
					masterForm3,
					masterGrid
				]	
			}
		],
		id: 's_bpr110ukrv_mitApp',
		fnInitBinding : function(param) {
			masterForm1.clearForm();
			masterForm2.clearForm();
			masterForm3.clearForm();
			panelResult.clearForm();
			directMasterStore.loadData({});
			bomStore.loadData({});
			panelResult.setValue("DIV_CODE", UserInfo.divCode);
			UniAppManager.setToolbarButtons(['reset','newData'],true);
			UniAppManager.setToolbarButtons(['save'],false);
		},
		onQueryButtonDown: function()	{
			masterForm1.loadData();
			masterForm2.loadData();
			masterForm3.loadData();
		},
		onNewDataButtonDown: function()	{
            var r = {
            	'DIV_CODE': panelResult.getValue("DIV_CODE"),
        	 	'PROD_ITEM_CODE': masterForm1.getValue("ITEM_CODE"),
				'UNIT_Q'          : 1,
				'PROD_UNIT_Q'     : 1 ,
				'START_DATE'      : UniDate.getDbDateStr(panelResult.getValue("START_DATE")), 
				'STOP_DATE'       : '29991231'
	        };
			masterGrid.createRow(r);
		},
		onResetButtonDown: function() {		
			masterGrid.reset();
			masterForm1.clearForm();
			masterForm2.clearForm();
			masterForm3.clearForm();
			directMasterStore.clearData();
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function() {	
			
		},
		onDeleteDataButtonDown: function() {
			var selRow = masterGrid.getSelectedRecord();
			if(selRow.phantom === true)	{
				masterGrid.deleteSelectedRow();
			}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				masterGrid.deleteSelectedRow();
			}
		}
	});
};


</script>
