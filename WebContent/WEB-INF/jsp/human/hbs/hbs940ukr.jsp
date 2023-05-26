<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hbs940ukr">
	<t:ExtComboStore comboType="AU" comboCode="H032" />
	<t:ExtComboStore items="${payGubun}" storeId="payGubun" /><!--지급구분-->	
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {
	color: #333333;
	font-weight: normal;
	padding: 1px 2px;
}
</style>

<script type="text/javascript">
	function appMain() {

		var colData = '';
		console.log(colData);
		
		var panelSearch = Unilite.createForm('searchForm', {		
		disabled :false
    ,	flex:1        
    ,	layout: {type: 'uniTable', columns: 1, tdAttrs: {valign:'top'}}
	,	items: [{
        	fieldLabel: '<t:message code="system.label.human.type" default="구분"/>',
        	name: 'CLOSE_TYPE',
        	xtype:'uniCombobox',
        	store: Ext.data.StoreManager.lookup('payGubun'),
        	colspan: 1
        },
		{
			fieldLabel : '<t:message code="system.label.human.oldyyyymm" default="최종마감"/>',
			xtype : 'uniMonthfield',
			id : 'OLD_YYYYMM',
			name : 'OLD_YYYYMM',
			readonly : true
		},
		{
			fieldLabel : '<t:message code="system.label.human.deadline" default="마감"/>',
			xtype : 'uniMonthfield',
			allowBlank : false,
			id : 'NOW_YYYYMM',
			name : 'NOW_YYYYMM',
			listeners : {
				blur : function() {
					panelSearch.setValue('OLD_YYYYMM', Ext
							.getCmp('NOW_YYYYMM')
							.getValue());
				}
			}
		}, {
			xtype : 'radiogroup',
			/* 	listeners: {
					change : function(rb, newValue, oldValue, options) {
			//	 						UniAppManager.app.onQueryButtonDown();
						//console.log(newValue);
						if(newValue.PAY=='N')
							{
							date(false,false);
							}
						
						//newValue();
					}
				}, */
			fieldLabel : '<t:message code="system.label.human.deadlineyn" default="마감여부"/>',
			id : 'PAY',
			name : 'PAY',
			items : [ {
				boxLabel : '<t:message code="system.label.human.deadline" default="마감"/>',
				width : 50,
				id : 'PAY_CLOSE',
				name : 'PAY',
				inputValue : 'Y',
				checked : true

			}, {
				boxLabel : '<t:message code="system.label.human.cancel" default="취소"/>',
				width : 60,
				id : 'PAY_CANCEL',
				name : 'PAY',
				inputValue : 'N'
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					//panelResult.getField('SALE_YN').setValue({SALE_YN: newValue});
					if(newValue.PAY == 'Y'){
						panelSearch.setValue('NOW_YYYYMM', UniDate.add(panelSearch.getValue('OLD_YYYYMM') ,  {months: +1}));
					}else{
						panelSearch.setValue('NOW_YYYYMM', panelSearch.getValue('OLD_YYYYMM'));
					}
					
				}
			}
		}, {
			xtype : 'button',
			text : '<t:message code="system.label.human.execute" default="실행"/>',
			width : 100,
			margin : '0 0 5 100',
			handler : function(btn) {
				doBatch();
			}
		}/*, {
			xtype : 'button',
			text : '닫기',
			width : 100,
			margin : '0 0 5 100',
			handler : function(btn) {
				self.close();
			}
		}*/],
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
			   		alert(labelText+ '<t:message code="system.message.human.message045" default="필수입력 항목입니다."/>');
					invalid.items[0].focus();
				} else {
					//this.mask();		    
	   			}
		  	} else {
  				this.unmask();
  			}
			return r;
  		}
	});	
		function doBatch() {
			var detailform = panelSearch.getForm();
			if (detailform.isValid()) {
				var param = Ext.getCmp('searchForm').getValues();
				param.DIV_CODE = UserInfo.divCode;
//				param.close_date = UniDate.add(Ext.getCmp('NOW_YYYYMM').getValue(), {month: -1});
				//alert(close_year +""+close_mon);
				param.S_USER_ID = "${loginVO.userID}";
				console.log(param);
				Ext.Ajax.on("beforerequest", function() {
					Ext.getBody().mask('<t:message code="system.label.human.loading" default="로딩중..."/>', 'loading')
				}, Ext.getBody());
				Ext.Ajax.on("requestcomplete", Ext.getBody().unmask, Ext
						.getBody());
				Ext.Ajax.on("requestexception", Ext.getBody().unmask, Ext
						.getBody());
				Ext.Ajax.request({
					url : CPATH + '/human/doBatchHbs940ukr.do', //수정
					params : param,
					success : function(response) {
						data = Ext.decode(response.responseText);
						console.log(data);
						Ext.Msg.alert('<t:message code="system.label.human.confirm" default="확인"/>', '<t:message code="system.message.human.message044" default="작업이 완료되었습니다."/>');

					}/* ,
												failure: function(response){
													console.log(response);
													Ext.Msg.alert('실패', '실행이 실패되었습니다.');
																			} */
				});
				if (Ext.getCmp('PAY').getValue().PAY == 'Y') {
					date(false, false);
				} else {
					date(false, true);
				}
			} else {
				var invalid = panelSearch.getForm().getFields().filterBy(
						function(field) {
							return !field.validate();
						});

				if (invalid.length > 0) {
					r = false;
					var labelText = ''

					if (Ext.isDefined(invalid.items[0]['fieldLabel'])) {
						var labelText = invalid.items[0]['fieldLabel'] + '은(는)';
					} else if (Ext.isDefined(invalid.items[0].ownerCt)) {
						var labelText = invalid.items[0].ownerCt['fieldLabel']
								+ '은(는)';
					}

					// Ext.Msg.alert(타이틀, 표시문구); 
					Ext.Msg.alert('<t:message code="system.label.human.confirm" default="확인"/>', labelText + '<t:message code="system.message.human.message053" default="기준년월을 입력하여 주십시오."/>');
					// validation이 맞지 않는 필드 중 제일 처음 필드에 포커스를 줌
					invalid.items[0].focus();
				}
			}
		}

		function date(init, cancel) {
			if (!cancel) {
				if (init) {
					if (colData == "") {
						panelSearch.setValue('OLD_YYYYMM', "");
						panelSearch.setValue('NOW_YYYYMM', "");
					} else {
						panelSearch.setValue('OLD_YYYYMM', colData);
						var currentDate = Ext.getCmp('OLD_YYYYMM').getValue();
						if(Ext.isEmpty(currentDate)) return;
						var currentYear = currentDate.getFullYear();

						var currentMon = currentDate.getMonth() + 1;
						var currentString = currentYear + '/' + currentMon + '/01';
						var date = new Date(currentString);
						date.setMonth(date.getMonth() + 1);
						var year = date.getFullYear();
						var mon = date.getMonth() + 1;
						panelSearch.setValue('NOW_YYYYMM', year + '/'+ (mon > 9 ? mon : '0' + mon));
					}
				} else {
					var currentDate = Ext.getCmp('OLD_YYYYMM').getValue();
					var currentYear = currentDate.getFullYear();
					var currentMon = currentDate.getMonth() + 1;
					var currentString = currentYear + '/' + currentMon + '/01';
					var date = new Date(currentString);
					date.setMonth(date.getMonth() + 1);
					var year = date.getFullYear();
					var mon = date.getMonth() + 1;
					panelSearch.setValue('OLD_YYYYMM', year + '/'+ (mon > 9 ? mon : '0' + mon));
					var oldDate = new Date(date);
					oldDate.setMonth(oldDate.getMonth() + 1);
					var oldYear = oldDate.getFullYear();
					var oldMon = oldDate.getMonth() + 1;
					panelSearch.setValue('NOW_YYYYMM', oldYear + '/'+ (oldMon > 9 ? oldMon : '0' + oldMon));
				}

			} else {
				var currentDate = Ext.getCmp('OLD_YYYYMM').getValue();
				var currentYear = currentDate.getFullYear();
				var currentMon = currentDate.getMonth() + 1;
				var currentString = currentYear + '/' + currentMon + '/01';
				var date = new Date(currentString);
				date.setMonth(date.getMonth() - 1);
				var year = date.getFullYear();
				var mon = date.getMonth() + 1;
				panelSearch.setValue('OLD_YYYYMM', year + '/'	+ (mon > 9 ? mon : '0' + mon));
				panelSearch.setValue('NOW_YYYYMM', Ext.getCmp('OLD_YYYYMM').getValue());

			}
		}
		/**
		 * Master Grid1 정의(Grid Panel)
		 * @type 
		 */

		Unilite.Main({
			items : [ panelSearch ],
			id : 'hbs940ukrApp',
			fnInitBinding : function() {
				UniAppManager.setToolbarButtons(['reset', 'query'], false);	
				panelSearch.setValue('CLOSE_TYPE', Ext.data.StoreManager.lookup('payGubun').getAt(0).get('value'));
				var param = {COMP_CODE: UserInfo.compCode, CLOSE_TYPE: panelSearch.getValue('CLOSE_TYPE')}
				hbs940ukrService.selectCloseyymm(param, function(provider, response)	{
					colData = provider[0];
					panelSearch.setValue('OLD_YYYYMM', colData);
					date(true, false);	
				});
				
												
				Ext.getCmp('searchForm').getForm().findField('OLD_YYYYMM')
						.setReadOnly(true);
//				var store = Ext.getStore('CBS_AU_H032');
//				var selectedModel = store.getRange();
//				Ext.each(selectedModel, function(record, i) {
//					if (record.data.value == '1' || record.data.value == '2'
//							|| record.data.value == '3'
//							|| record.data.value == '4'
//							|| record.data.value == 'L'
//							|| record.data.value == 'M') {
//						//if (record.data.value != '2'||record.data.value != '3'||record.data.value != '4') {
//						store.remove(record);
//					}
//
//				});
//				var combo = Ext.getCmp('CLOSE_TYPE');
//				combo.bindStore('CBS_AU_H032');
			}
		});
	};
</script>
