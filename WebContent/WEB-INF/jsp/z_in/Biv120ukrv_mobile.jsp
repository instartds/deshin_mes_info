<%--
'   프로그램명 : 실사등록(모바일)
'
'   작  성  자 : (주)포렌 개발실
'   작  성  일 : 2019.04.02
'
'   최종수정자 :
'   최종수정일 :
'
'   버	  전 : OMEGA Plus V6.0.0
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<t:appConfig pgmId="Biv120ukrv_mobile"  >
	<t:ExtComboStore comboType="BOR120" pgmId="Biv120ukrv_mobile"  /> 			<!-- 사업장 -->
    <t:ExtComboStore comboType="OU" />   <!--창고(사용여부 Y) -->
</t:appConfig>

<script type="text/javascript">

function appMain() {
	var bChange = false;
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 1},
		padding:'1 1 1 1',
		border:true,
		//hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{
					fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
					labelWidth:60,
					name:'DIV_CODE',
					xtype: 'uniCombobox',
					comboType:'BOR120',
					allowBlank:false
				},{
					fieldLabel: '창고',
					labelWidth:60,
					name:'WH_CODE',
					xtype: 'uniCombobox',
					comboType:'OU',
					allowBlank:false
				},
				Unilite.popup('COUNT_DATE', {
					fieldLabel: '선별일자',
					labelWidth:60,
					allowBlank: false,
					listeners: {
						onSelected: {
							fn: function(records, type) {
								var countDATE = UniDate.getDbDateStr(records[0]['COUNT_DATE']).substring(0, 8);
								countDATE = countDATE.substring(0,4) + '.' + countDATE.substring(4,6) + '.' + countDATE.substring(6,8);
								panelResult.setValue('COUNT_DATE', countDATE);
								panelResult.setValue('WH_CODE', records[0]['WH_CODE']);
								
								panelResult.getField('BARCODE').focus();
							},
							scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('COUNT_DATE', '');
							panelResult.setValue('WH_CODE', '');
						},
						applyextparam: function(popup){
							popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
							popup.setExtParam({'WH_CODE': panelResult.getValue('WH_CODE')});
						}
					}
				}),{
					fieldLabel: '바코드',
					labelWidth: 60,
					name: 'BARCODE',
					xtype: 'uniTextfield',
					allowBlank: true,
					fieldStyle: 'IME-MODE: inactive',
					width: 300,
					listeners: {
						//blur : function(type) {
						//	setTimeout(function(){
						//		if(bChange && type && type.value)
						//			fnGetItemCountInfo(type.value);
						//	}, 1000);
						//},
						change : function(element, newValue, oldValue, eOpts) {
							if(newValue == "")
								UniAppManager.app.onResetButtonDown();
							else {
								if(bChange)
									return;
								
								if(newValue != oldValue) {
									bChange = true;
									UniAppManager.setToolbarButtons('save', true);
								}
							}
						},
						specialkey : function(field, event) {
							if(event.getKey() == event.ENTER) {
								setTimeout(function(){
									var val = panelResult.getValue('BARCODE');
									fnGetItemCountInfo(val);
								}, 1000);
								
							}
						},
						focus : function(el, ev, eOpts) {
							
						}
					}
				},{
					xtype: 'container',
	                layout: {type: 'uniTable', columns: 2},
	                margin: '-3 0 0 0',
	                items: [{
								fieldLabel: '품목',
								labelWidth:60,
								name:'ITEM_CODE',
								xtype: 'uniTextfield',
								allowBlank:true,
								readOnly:true,
								width:150
							},{
								fieldLabel: '',
								name:'ITEM_NAME',
								xtype: 'uniTextfield',
								allowBlank:true,
								readOnly:true,
								width:150
							}]
				},{
					fieldLabel: 'LOT NO',
					labelWidth:60,
					name:'LOT_NO',
					xtype: 'uniTextfield',
					allowBlank:true,
					readOnly:true
				},{
					fieldLabel: '장부재고',
					labelWidth:60,
					name:'GOOD_STOCK_BOOK_Q',
					xtype: 'uniNumberfield',
					allowBlank:true,
					readOnly:true
				},{
					fieldLabel: '실사재고',
					labelWidth:60,
					name:'GOOD_STOCK_Q',
					xtype: 'uniNumberfield',
					allowBlank:true,
					readOnly:true
				},{
					fieldLabel: '수량',
					labelWidth:60,
					name:'GOOD_STOCK_COUNT_Q',
					xtype: 'uniNumberfield',
					allowBlank:false
				},{
	                xtype: 'container',
	                layout: {type: 'uniTable', columns: 2},
	                tdAttrs:{width:300},
	                margin: '0 0 8 60',
	                items: [{
					    text: '확인',
					    itemId:'btnConfirm',
					   	width: 100,
					   	height: 50,
					    xtype: 'button',
					    handler: function(){
					    	UniAppManager.app.onSaveDataButtonDown();
						}
					},{
					    text: '취소',
					    itemId:'btnCancel',
					   	width: 100,
					   	height: 50,
					    xtype: 'button',
					    handler: function(){
					    	UniAppManager.app.onResetButtonDown();					
						}
					}]
	            },{
					fieldLabel: 'S_COMP_CODE',
					labelWidth:60,
					name:'S_COMP_CODE',
					xtype: 'uniTextfield',
					allowBlank:true,
					hidden:true
				},{
					fieldLabel: 'S_DIV_CODE',
					labelWidth:60,
					name:'S_DIV_CODE',
					xtype: 'uniTextfield',
					allowBlank:true,
					hidden:true
				},{
					fieldLabel: 'S_USER_ID',
					labelWidth:60,
					name:'S_USER_ID',
					xtype: 'uniTextfield',
					allowBlank:true,
					hidden:true
				}
		],
		api: {
	 		submit: 'biv120ukrv_mobileService.updateStockInfo'	
		}
    });
    
    function fnGetItemCountInfo(barcode) {
    	bChange = false;
    	
    	if(barcode == "")
    		UniAppManager.app.onResetButtonDown();
    	else {
    		var barcodeInfo = barcode.split('|');
    		
    		if(barcodeInfo.length != 3) {
    			Ext.Msg.alert('확인', '<t:message code="unilite.msg.sMB180" default="잘못된 바코드를 입력하셨습니다."/>');
    			panelResult.getField('BARCODE').focus();
    			
    			return;
    		}
    		
    		panelResult.setValue("ITEM_CODE", barcodeInfo[0]);
    		panelResult.setValue("LOT_NO", barcodeInfo[1]);
    		panelResult.setValue("GOOD_STOCK_COUNT_Q", barcodeInfo[2]);
    		
    		var param = panelResult.getValues();
    		param['COUNT_DATE'] = param['COUNT_DATE'].replace(/\./gi, "");
    		
    		biv120ukrv_mobileService.selectStockInfo(param, function(provider, request)	{
				if(provider.length < 1) {
					Ext.Msg.alert('확인', "실사정보를 확인할 수 없습니다.");
					UniAppManager.app.onResetButtonDown();
					
					return;
				}
				
				var record = provider[0];
				
				if(!Ext.isEmpty(record)) {
    				panelResult.setValue("ITEM_NAME"		, record['ITEM_NAME']);
					panelResult.setValue("GOOD_STOCK_BOOK_Q", record['GOOD_STOCK_BOOK_Q']);
					panelResult.setValue("GOOD_STOCK_Q"		, record['GOOD_STOCK_Q']);
				}
			});
    	}
    }

    function fnSetItemCountInfo() {
    	if(UniAppManager.app.getTopToolbar().getComponent('save').disabled)	//저장버튼 활성화 여부 확인.
    		return;
    	
    	if(panelResult.getValue('GOOD_STOCK_COUNT_Q') == "" || panelResult.getValue('GOOD_STOCK_COUNT_Q') == "0") {
    		Ext.Msg.alert('확인', "수량이 0이거나 데이터가 없습니다.");
    		return;
    	}
    		
    	if(panelResult.getValue('GOOD_STOCK_Q') > 0 || panelResult.getValue('GOOD_STOCK_Q') < 0) {
    		if(confirm("이전 수량이 존재합니다. 추가하시겠습니까?")) {
    			var param = panelResult.getValues();
    			
    			panelResult.getForm().submit({
    				params : param,
    				success : function(form, action) {
    					UniAppManager.setToolbarButtons('save',false);
    					Ext.Msg.alert('확인', '수량 등록되었습니다.');
    					
    					fnGetItemCountInfo(panelResult.getValue('BARCODE'));
    				}
    			});
    		}
    	}
    }
    
    Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				panelResult
			]
		}
			
		],
		uniOpt: {
			showToolbar: false,
			forceToolbarbutton: true
		},
		id  : 'Biv120ukrv_mobileApp',
		fnInitBinding : function() {
			//	자료수정권한 부여
			MODIFY_AUTH = true;
			
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('save',false);
			
			panelResult.setValue('BARCODE', '');
			panelResult.setValue('ITEM_CODE', '');
			panelResult.setValue('ITEM_NAME', '');
			panelResult.setValue('LOT_NO', '');
			panelResult.setValue('GOOD_STOCK_BOOK_Q', '0');
			panelResult.setValue('GOOD_STOCK_Q', '0');
			//panelResult.setValue('GOOD_STOCK_COUNT_Q', '0');
			
			panelResult.setValue('S_COMP_CODE', UserInfo.compCode);
			panelResult.setValue('S_DIV_CODE' , UserInfo.divCode);
			panelResult.setValue('S_USER_ID'  , UserInfo.userID);
		},
		onQueryButtonDown : function()	{
		},
		onResetButtonDown: function() {
			UniAppManager.setToolbarButtons('save',false);
			
			panelResult.setValue('BARCODE', '');
			panelResult.setValue('ITEM_CODE', '');
			panelResult.setValue('ITEM_NAME', '');
			panelResult.setValue('LOT_NO', '');
			panelResult.setValue('GOOD_STOCK_BOOK_Q', '0');
			panelResult.setValue('GOOD_STOCK_Q', '0');
			panelResult.setValue('GOOD_STOCK_COUNT_Q', '0');
			
			panelResult.getField('BARCODE').focus();
		},
		onSaveDataButtonDown: function(config) {
			fnSetItemCountInfo();
		},
		onDeleteDataButtonDown: function() {
		},
		onNewDataButtonDown: function()	{
		}
	});
};


</script>
