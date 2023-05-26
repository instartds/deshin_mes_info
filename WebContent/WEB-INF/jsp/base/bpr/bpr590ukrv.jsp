<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="bpr590ukrv"  >
	<t:ExtComboStore comboType="BOR120"  />					<!-- 사업장 -->
	<t:ExtComboStore comboType="OU" />						<!-- 창고-->
	<t:ExtComboStore comboType="WU" />						<!-- 작업장  -->
	<t:ExtComboStore comboType="AU" comboCode="B140"  />	<!-- 공정그룹 -->

</t:appConfig>

<style type="text/css">
.x-change-cell {
background-color: #FFFFC6;
}
</style>

<script type="text/javascript" >

function appMain() {
	var gubunStore = Unilite.createStore('gubunComboStore', {  
        fields: ['text', 'value'],
        data :  [
            {'text':'<t:message code="system.label.purchase.confirm" default="확인"/>'  , 'value':'Y'},
            {'text':'<t:message code="system.label.purchase.notconfirm" default="미확인"/>'  , 'value':'N'}
        ]
    });
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy', {
		api: {
			read	: 'bpr590ukrvService.selectList',
//			create	: 'bpr590ukrvService.insertDetail',
			update	: 'bpr590ukrvService.updateDetail',
//			destroy	: 'bpr590ukrvService.deleteDetail',
			syncAll	: 'bpr590ukrvService.saveAll'
		}
	});
	
	Unilite.defineModel('detailModel', {
		fields: [
			{name: 'DIV_CODE'			,text: '사업장' 		,type: 'string',comboType:'BOR120'},
			{name: 'SEQ'				,text: '순번' 		,type: 'int'},
			{name: 'START_DATE'			,text: 'START_DATE' ,type: 'string'},
			{name: 'PATH_CODE'			,text: 'PATH_CODE' 	,type: 'string'},
			{name: 'PROD_ITEM_CODE'		,text: '모품목코드' 	,type: 'string'},
			{name: 'PROD_ITEM_NAME'	,text: '<t:message code="system.label.base.parentitemname" default="모품목명"/>'	,type: 'string'},
			// 20210323 추가
			{name: 'UNIT_Q'			,text: '<t:message code="system.label.base.content" default="함량"/>'				,type: 'float',defaultValue:1, decimalPrecision: 6, format:'0,000.000000'},
			{name: 'CHILD_ITEM_CODE'	,text: '자품목코드' 	,type: 'string'},
			{name: 'ITEM_NAME'			,text: '자품목명' 		,type: 'string'},
			//20190530 추가: GROUP_CODE
			{name: 'GROUP_CODE'			,text: '<t:message code="system.label.base.routinggroup" default="공정그룹"/>'	,type: 'string'  , comboType: 'AU', comboCode:'B140'},
			{name: 'PROC_DRAW'			,text: '공정도' 		,type: 'string'}
		]
	});	

	var detailStore = Unilite.createStore('detailStore',{
		model: 'detailModel',
		proxy: directProxy,
		autoLoad: false,
		uniOpt	: {
			isMaster	: true,	// 상위 버튼 연결 
			editable	: true,		// 수정 모드 사용 
			deletable	: false,		// 삭제 가능 여부 
			useNavi		: false		// prev | next 버튼 사용
		},
		loadStoreRecords : function()	{
			var param= panelSearch.getValues();
			this.load({
				params : param
			});
		},
		saveStore : function(config)	{
			var inValidRecs = this.getInvalidRecords();
			if(inValidRecs.length == 0 ) {
				config = {
					success: function(batch, option) {
						detailStore.loadStoreRecords();
					}
				};
				this.syncAllDirect(config);
				
			} else {
				detailGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		
		listeners: {
           	load: function(store, records, successful, eOpts) {
           		var procDraw = '';
           		var seq = '';
           		
           		Ext.each(records,function(record,i){
           			seq = seq + record.get('SEQ') + '\n';
           			procDraw = procDraw + record.get('PROC_DRAW') + '\n';
           		})
           		
           		panelProcDraw.setValue('SEQ',seq);
           		panelProcDraw.setValue('PROC_DRAW',procDraw);
           	}
		}
	});

	var panelSearch = Unilite.createSearchForm('panelSearch', {
		region:'north',
		layout: {type : 'uniTable', columns :5,
			
			tableAttrs: {width: '100%'}
//			tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
		
		
		},
		padding: '1 1 1 1',
		border: true,
		items: [{
			fieldLabel: '<t:message code="system.label.base.division" default="사업장"/>',
			name: 'DIV_CODE',
			xtype: 'uniCombobox',
			comboType: 'BOR120',
			allowBlank: false,
			value : UserInfo.divCode,
//			colspan:2,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		}, {
			xtype: 'container',
            layout: {type: 'uniTable', columns: 5},
            width:130,
//            margin:'0 0 0 100',
            rowspan:2,
			items:[{
				xtype:'button',
				text:'┌',
	            handler:function(){
	            	var selectRecord = detailGrid.getSelectedRecord();
	            	if(!Ext.isEmpty(selectRecord)){
	            		selectRecord.set('PROC_DRAW',selectRecord.get('PROC_DRAW') + '┌');
//	            		selectRecord.set('PROC_DRAW','┌');
	            	}
	            }
			},{
				xtype:'button',
				text:'┬',
	            handler:function(){
	            	var selectRecord = detailGrid.getSelectedRecord();
	            	if(!Ext.isEmpty(selectRecord)){
	            		selectRecord.set('PROC_DRAW',selectRecord.get('PROC_DRAW') + '┬');
	            	}
	            }
			},{
				xtype:'button',
				text:'┐',
	            handler:function(){
	            	var selectRecord = detailGrid.getSelectedRecord();
	            	if(!Ext.isEmpty(selectRecord)){
		            	selectRecord.set('PROC_DRAW',selectRecord.get('PROC_DRAW') + '┐');
	            	}
	            }
			},{
				xtype:'button',
				text:'─',
	            handler:function(){
	            	var selectRecord = detailGrid.getSelectedRecord();
	            	if(!Ext.isEmpty(selectRecord)){
		            	selectRecord.set('PROC_DRAW',selectRecord.get('PROC_DRAW') + '─');
	            	}
	            }
			},{
				xtype:'button',
				text:'▽',
	            handler:function(){
	            	var selectRecord = detailGrid.getSelectedRecord();
	            	if(!Ext.isEmpty(selectRecord)){
	            		selectRecord.set('PROC_DRAW',selectRecord.get('PROC_DRAW') + '▽');
	            	}
	            }
			},{
				xtype:'button',
				text:'├',
	            handler:function(){
	            	var selectRecord = detailGrid.getSelectedRecord();
	            	if(!Ext.isEmpty(selectRecord)){
	            		selectRecord.set('PROC_DRAW',selectRecord.get('PROC_DRAW') + '├');
	            	}
	            }
			},{
				xtype:'button',
				text:'┼',
	            handler:function(){
	            	var selectRecord = detailGrid.getSelectedRecord();
	            	if(!Ext.isEmpty(selectRecord)){
	            		selectRecord.set('PROC_DRAW',selectRecord.get('PROC_DRAW') + '┼');
	            	}
	            }
			},{
				xtype:'button',
				text:'┤',
	            handler:function(){
	            	var selectRecord = detailGrid.getSelectedRecord();
	            	if(!Ext.isEmpty(selectRecord)){
	            		selectRecord.set('PROC_DRAW',selectRecord.get('PROC_DRAW') + '┤');
	            	}
	            }
			},{
				xtype:'button',
				text:'│',
	            handler:function(){
	            	var selectRecord = detailGrid.getSelectedRecord();
	            	if(!Ext.isEmpty(selectRecord)){
	            		selectRecord.set('PROC_DRAW',selectRecord.get('PROC_DRAW') + '│');
	            	}
	            }
			},{
				xtype:'button',
				text:'▷',
	            handler:function(){
	            	var selectRecord = detailGrid.getSelectedRecord();
	            	if(!Ext.isEmpty(selectRecord)){
	            		selectRecord.set('PROC_DRAW',selectRecord.get('PROC_DRAW') + '▷');
	            	}
	            }
			},{
				xtype:'button',
				text:'└',
	            handler:function(){
	            	var selectRecord = detailGrid.getSelectedRecord();
	            	if(!Ext.isEmpty(selectRecord)){
	            		selectRecord.set('PROC_DRAW',selectRecord.get('PROC_DRAW') + '└');
	            	}
	            }
			},{
				xtype:'button',
				text:'┴',
	            handler:function(){
	            	var selectRecord = detailGrid.getSelectedRecord();
	            	if(!Ext.isEmpty(selectRecord)){
	            		selectRecord.set('PROC_DRAW',selectRecord.get('PROC_DRAW') + '┴');
	            	}
	            }
			},{
				xtype:'button',
				text:'┘',
	            handler:function(){
	            	var selectRecord = detailGrid.getSelectedRecord();
	            	if(!Ext.isEmpty(selectRecord)){
		            	selectRecord.set('PROC_DRAW',selectRecord.get('PROC_DRAW') + '┘');
	            	}
	            }
			},{
				xtype:'button',
				text:'SPACE',
				colspan:2,
	            handler:function(){
	            	var selectRecord = detailGrid.getSelectedRecord();
	            	if(!Ext.isEmpty(selectRecord)){
	            		selectRecord.set('PROC_DRAW',selectRecord.get('PROC_DRAW') + '　');
	            	}
	            }
			}]
		},{
			xtype: 'container',
            layout: {type: 'uniTable', columns: 1},
            width:80,
            rowspan:2,
			items:[{
				xtype:'component',
				html:'Q  W  E  R  T </br></br> A  S  D  F  G </br></br> Z  X  C  V',
			    tdAttrs: {style: 'border : 0px solid #ced9e7; font: normal 13px "굴림",Gulim,tahoma, arial, verdana, sans-serif; color:red;', align : 'left'}
			}]
		},{
			xtype: 'radiogroup',
			fieldLabel: '키보드 사용유무',
//            margin:'0 0 0 100',
			name: 'KEYBOARD', 
			items: [{
				boxLabel: '미사용' ,
				width: 80, 
				name: 'KEYBOARD', 
				inputValue: 'N', 
				checked: true
			},{
				boxLabel: '사용' , 
				width: 80, 
				name: 'KEYBOARD', 
				inputValue: 'Y'
			}]
		},{
			xtype:'component',
			html:'* 키보드 사용시 반드시 영문으로 바꾸신뒤 사용하시면 됩니다.',
		    tdAttrs: {style: 'border : 0px solid #ced9e7; font: normal 13px "굴림",Gulim,tahoma, arial, verdana, sans-serif; color:red;', align : 'left'}
		},	
		Unilite.popup('DIV_PUMOK',{
			fieldLabel: '<t:message code="system.label.base.parentitemcode" default="모품목코드"/>',
			valueFieldName: 'PROD_ITEM_CODE',
			textFieldName: 'ITEM_NAME',
			//autoPopup:true,
			//validateBlank: false,
//			extraFieldsConfig:[{extraFieldName:'SPEC', extraFieldWidth:153}],
//			textFieldWidth:   320,
			allowBlank:false,
//			colspan:4,
			listeners: {
				onValueFieldChange: function(field, newValue){},
				onTextFieldChange: function(field, newValue){},
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					//popup.setExtParam({'ITEM_ACCOUNT_FILTER': ['10','20']});
					popup.setExtParam({'DEFAULT_ITEM_ACCOUNT': '30'});
				}
			}
		})]
	});

	var detailGrid = Unilite.createGrid('detailGrid', {
		layout: 'fit',
		region:'west',
		flex:2,
		split:true,
		uniOpt: {
//            userToolbar:false,
			expandLastColumn: true,
			useLiveSearch: false,
			useContextMenu: false,
			useMultipleSorting: false,
			useGroupSummary: false,
			useRowNumberer: false,
			onLoadSelectFirst: true,
			filter: {
				useFilter: false,
				autoCreate: false
			},
			state: {
				useState: false,
				useStateList: false
			}
		},
		store: detailStore,
		columns: [
			{ dataIndex: 'DIV_CODE'			, width: 120,hidden:true},
			{ dataIndex: 'SEQ'				, width: 60,align:'center'},
			{ dataIndex: 'PROD_ITEM_CODE'	, width: 100},
			{ dataIndex: 'PROD_ITEM_NAME'	, width: 200},
			{ dataIndex: 'CHILD_ITEM_CODE'	, width: 100},
			{ dataIndex: 'ITEM_NAME'		, width: 250},
			// 20210323 추가
			{ dataIndex: 'UNIT_Q'			, width: 80},
			//20190530 추가: GROUP_CODE
			{ dataIndex: 'GROUP_CODE'		, width: 80, align: 'center'},
			{ dataIndex: 'PROC_DRAW'		, width: 450,
			editor: {
				xtype:'textfield',
				enableKeyEvents:true,
				getCaretPosition: function() {
			        var el = this.inputEl.dom;
			        if (typeof(el.selectionStart) === "number") {
			            return el.selectionStart;
			        } else if (document.selection && el.createTextRange){
			            var range = document.selection.createRange();
			            range.collapse(true);
			            range.moveStart("character", -el.value.length);
			            return range.text.length;
			        } else {
			            throw 'getCaretPosition() not supported';
			        }
			    },
				listeners: {
					keydown:function(field, event)	{
						if(panelSearch.getValue('KEYBOARD').KEYBOARD == 'Y'){
							if(event.getKey() == 81)	{  // q
								var value = field.getValue();
								var position = field.getCaretPosition();
								var value1 = value.substring(0,position);
								var value2 = value.substring(position,value.length);
								field.setValue(value1 + '┌'+value2);
								field.selectText(position+1,position+1);
								event.stopEvent();
							}else if(event.getKey() == 87)	{  // w
								var value = field.getValue();
								var position = field.getCaretPosition();
								var value1 = value.substring(0,position);
								var value2 = value.substring(position,value.length);
								field.setValue(value1 + '┬'+value2);
								field.selectText(position+1,position+1);
								event.stopEvent();
							}else if(event.getKey() == 69)	{  // e
								var value = field.getValue();
								var position = field.getCaretPosition();
								var value1 = value.substring(0,position);
								var value2 = value.substring(position,value.length);
								field.setValue(value1 + '┐'+value2);
								field.selectText(position+1,position+1);
								event.stopEvent();
							}else if(event.getKey() == 82)	{  // r
								var value = field.getValue();
								var position = field.getCaretPosition();
								var value1 = value.substring(0,position);
								var value2 = value.substring(position,value.length);
								field.setValue(value1 + '─'+value2);
								field.selectText(position+1,position+1);
								event.stopEvent();
							}else if(event.getKey() == 84)	{  // t
								var value = field.getValue();
								var position = field.getCaretPosition();
								var value1 = value.substring(0,position);
								var value2 = value.substring(position,value.length);
								field.setValue(value1 + '▽'+value2);
								field.selectText(position+1,position+1);
								event.stopEvent();
							}else if(event.getKey() == 65)	{  // a
								var value = field.getValue();
								var position = field.getCaretPosition();
								var value1 = value.substring(0,position);
								var value2 = value.substring(position,value.length);
								field.setValue(value1 + '├'+value2);
								field.selectText(position+1,position+1);
								event.stopEvent();
							}else if(event.getKey() == 83)	{  // s
								var value = field.getValue();
								var position = field.getCaretPosition();
								var value1 = value.substring(0,position);
								var value2 = value.substring(position,value.length);
								field.setValue(value1 + '┼'+value2);
								field.selectText(position+1,position+1);
								event.stopEvent();
							}else if(event.getKey() == 68)	{  // d
								var value = field.getValue();
								var position = field.getCaretPosition();
								var value1 = value.substring(0,position);
								var value2 = value.substring(position,value.length);
								field.setValue(value1 + '┤'+value2);
								field.selectText(position+1,position+1);
								event.stopEvent();
							}else if(event.getKey() == 70)	{  // f
								var value = field.getValue();
								var position = field.getCaretPosition();
								var value1 = value.substring(0,position);
								var value2 = value.substring(position,value.length);
								field.setValue(value1 + '│'+value2);
								field.selectText(position+1,position+1);
								event.stopEvent();
							}else if(event.getKey() == 71)	{  // g
								var value = field.getValue();
								var position = field.getCaretPosition();
								var value1 = value.substring(0,position);
								var value2 = value.substring(position,value.length);
								field.setValue(value1 + '▷'+value2);
								field.selectText(position+1,position+1);
								event.stopEvent();
							}else if(event.getKey() == 90)	{  // z
								var value = field.getValue();
								var position = field.getCaretPosition();
								var value1 = value.substring(0,position);
								var value2 = value.substring(position,value.length);
								field.setValue(value1 + '└'+value2);
								field.selectText(position+1,position+1);
								event.stopEvent();
							}else if(event.getKey() == 88)	{  // x
								var value = field.getValue();
								var position = field.getCaretPosition();
								var value1 = value.substring(0,position);
								var value2 = value.substring(position,value.length);
								field.setValue(value1 + '┴'+value2);
								field.selectText(position+1,position+1);
								event.stopEvent();
							}else if(event.getKey() == 67)	{  // c
								var value = field.getValue();
								var position = field.getCaretPosition();
								var value1 = value.substring(0,position);
								var value2 = value.substring(position,value.length);
								field.setValue(value1 + '┘'+value2);
								field.selectText(position+1,position+1);
								event.stopEvent();
							}else if(event.getKey() == 86)	{  // v
								var value = field.getValue();
								var position = field.getCaretPosition();
								var value1 = value.substring(0,position);
								var value2 = value.substring(position,value.length);
								field.setValue(value1 + '　'+value2);
								field.selectText(position+1,position+1);
								event.stopEvent();
							} 
						}
					}
				}
			}
		}],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				if (UniUtils.indexOf(e.field, ['PROC_DRAW'])) {
					return true;
				} else {
					return false;
				}
			}
		}
	});

	var panelProcDraw = Unilite.createForm('panelProcDraw', {
		title:'공정도',
		flex:1,
		region:'center',
		layout: {type : 'uniTable', columns : 2},
		padding: '1 1 1 1',
		disabled :false,
		border: true,
		items: [{
			xtype:'button',
			text:'<div style="color: red"><- 공정도복사</div>',
			margin:'0 0 0 10',
			colspan:2,
            handler:function(){
            	var procDraw = '';
            	procDraw= panelProcDraw.getValue('PROC_DRAW');
            	var procDrawArr='';
            	procDrawArr = procDraw.split('\n');
            	var records = detailStore.data.items;
           		Ext.each(records,function(record,i){
           			record.set('PROC_DRAW',procDrawArr[i]);
           		})
            }
		},{
			fieldLabel:'순번',
			labelAlign: 'top',
			fieldStyle: 'text-align: right;',
			xtype:'textarea',
			name:'SEQ',
			width:50,
			height:1000,
			readOnly:true
		},{
			fieldLabel:'공정도',
			labelAlign: 'top',
			xtype:'textarea',
			name:'PROC_DRAW',
			width:1000,
			height:1000,
			readOnly:false,
			enableKeyEvents:true,
			getCaretPosition: function() {
		        var el = this.inputEl.dom;
		        if (typeof(el.selectionStart) === "number") {
		            return el.selectionStart;
		        } else if (document.selection && el.createTextRange){
		            var range = document.selection.createRange();
		            range.collapse(true);
		            range.moveStart("character", -el.value.length);
		            return range.text.length;
		        } else {
		            throw 'getCaretPosition() not supported';
		        }
		    },
			listeners: {
				keydown:function(field, event)	{
					if(panelSearch.getValue('KEYBOARD').KEYBOARD == 'Y'){
						if(event.getKey() == 81)	{  // q
							var value = field.getValue();
							var position = field.getCaretPosition();
							var value1 = value.substring(0,position);
							var value2 = value.substring(position,value.length);
							field.setValue(value1 + '┌'+value2);
							field.selectText(position+1,position+1);
							event.stopEvent();
						}else if(event.getKey() == 87)	{  // w
							var value = field.getValue();
							var position = field.getCaretPosition();
							var value1 = value.substring(0,position);
							var value2 = value.substring(position,value.length);
							field.setValue(value1 + '┬'+value2);
							field.selectText(position+1,position+1);
							event.stopEvent();
						}else if(event.getKey() == 69)	{  // e
							var value = field.getValue();
							var position = field.getCaretPosition();
							var value1 = value.substring(0,position);
							var value2 = value.substring(position,value.length);
							field.setValue(value1 + '┐'+value2);
							field.selectText(position+1,position+1);
							event.stopEvent();
						}else if(event.getKey() == 82)	{  // r
							var value = field.getValue();
							var position = field.getCaretPosition();
							var value1 = value.substring(0,position);
							var value2 = value.substring(position,value.length);
							field.setValue(value1 + '─'+value2);
							field.selectText(position+1,position+1);
							event.stopEvent();
						}else if(event.getKey() == 84)	{  // t
							var value = field.getValue();
							var position = field.getCaretPosition();
							var value1 = value.substring(0,position);
							var value2 = value.substring(position,value.length);
							field.setValue(value1 + '▽'+value2);
							field.selectText(position+1,position+1);
							event.stopEvent();
						}else if(event.getKey() == 65)	{  // a
							var value = field.getValue();
							var position = field.getCaretPosition();
							var value1 = value.substring(0,position);
							var value2 = value.substring(position,value.length);
							field.setValue(value1 + '├'+value2);
							field.selectText(position+1,position+1);
							event.stopEvent();
						}else if(event.getKey() == 83)	{  // s
							var value = field.getValue();
							var position = field.getCaretPosition();
							var value1 = value.substring(0,position);
							var value2 = value.substring(position,value.length);
							field.setValue(value1 + '┼'+value2);
							field.selectText(position+1,position+1);
							event.stopEvent();
						}else if(event.getKey() == 68)	{  // d
							var value = field.getValue();
							var position = field.getCaretPosition();
							var value1 = value.substring(0,position);
							var value2 = value.substring(position,value.length);
							field.setValue(value1 + '┤'+value2);
							field.selectText(position+1,position+1);
							event.stopEvent();
						}else if(event.getKey() == 70)	{  // f
							var value = field.getValue();
							var position = field.getCaretPosition();
							var value1 = value.substring(0,position);
							var value2 = value.substring(position,value.length);
							field.setValue(value1 + '│'+value2);
							field.selectText(position+1,position+1);
							event.stopEvent();
						}else if(event.getKey() == 71)	{  // g
							var value = field.getValue();
							var position = field.getCaretPosition();
							var value1 = value.substring(0,position);
							var value2 = value.substring(position,value.length);
							field.setValue(value1 + '▷'+value2);
							field.selectText(position+1,position+1);
							event.stopEvent();
						}else if(event.getKey() == 90)	{  // z
							var value = field.getValue();
							var position = field.getCaretPosition();
							var value1 = value.substring(0,position);
							var value2 = value.substring(position,value.length);
							field.setValue(value1 + '└'+value2);
							field.selectText(position+1,position+1);
							event.stopEvent();
						}else if(event.getKey() == 88)	{  // x
							var value = field.getValue();
							var position = field.getCaretPosition();
							var value1 = value.substring(0,position);
							var value2 = value.substring(position,value.length);
							field.setValue(value1 + '┴'+value2);
							field.selectText(position+1,position+1);
							event.stopEvent();
						}else if(event.getKey() == 67)	{  // c
							var value = field.getValue();
							var position = field.getCaretPosition();
							var value1 = value.substring(0,position);
							var value2 = value.substring(position,value.length);
							field.setValue(value1 + '┘'+value2);
							field.selectText(position+1,position+1);
							event.stopEvent();
						}else if(event.getKey() == 86)	{  // v
							var value = field.getValue();
							var position = field.getCaretPosition();
							var value1 = value.substring(0,position);
							var value2 = value.substring(position,value.length);
							field.setValue(value1 + '　'+value2);
							field.selectText(position+1,position+1);
							event.stopEvent();
						} 
					}
				}
			}
		}
		]
	});
	Unilite.Main({
		borderItems: [{
			id: 'pageAll',
			region: 'center',
			layout: 'border',
			border: false,
			items: [
				panelSearch, detailGrid,panelProcDraw
			]
		}],
		id: 'bpr590ukrvApp',
		fnInitBinding: function() {
			this.fnInitInputFields();
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			detailGrid.reset();
			detailStore.clearData();
			
			this.fnInitInputFields();
		},
		onQueryButtonDown: function() {
            if(!panelSearch.getInvalidMessage()) return;   //필수체크
			panelSearch.getField('DIV_CODE').setReadOnly(true);
			detailStore.loadStoreRecords();
		},
		onSaveDataButtonDown: function(config) {
            if(!panelSearch.getInvalidMessage()) return;   //필수체크
		
			detailStore.saveStore();
		},
		fnInitInputFields: function(){
			panelSearch.setValue('DIV_CODE', UserInfo.divCode);
			panelSearch.getField('DIV_CODE').setReadOnly(false);
			panelProcDraw.setValue('SEQ', '');
			panelProcDraw.setValue('PROC_DRAW', '');
			
			UniAppManager.setToolbarButtons(['reset'], true);
			UniAppManager.setToolbarButtons(['print','newData','delete','save'], false);
		}
	});
};
</script>