<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hbs930ukr">
	<t:ExtComboStore comboType="AU" comboCode="H032" />			<!-- 지급구분 -->
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

//	var colData = "${colData}";
//	console.log(colData);

	var panelSearch = Unilite.createForm('searchForm', {
		disabled :false,
    	flex:1,
    	layout: {type: 'uniTable', columns: 1, tdAttrs: {valign:'top'}},
		items : [{
			fieldLabel : '급여구분',
			name : 'CLOSE_TYPE',
			id : 'CLOSE_TYPE',
			xtype : 'uniCombobox',
			comboType : 'AU',
			comboCode : 'H032',
			allowBlank : false,
			value : '2'
		},{
			fieldLabel : '최종마감',
			xtype : 'uniMonthfield',
			id : 'OLD_YYYYMM',
			name : 'OLD_YYYYMM',
			readonly : true
		},{
			fieldLabel : '마감',
			xtype : 'uniMonthfield',
			allowBlank : false,
			id : 'NOW_YYYYMM',
			name : 'NOW_YYYYMM',
			listeners : {/*
				blur : function() {
					panelSearch.setValue('OLD_YYYYMM', Ext
							.getCmp('NOW_YYYYMM')
							.getValue());
				}
			*/}
		},{
			xtype : 'radiogroup',
			fieldLabel : '마감여부',
			id : 'PAY',
			name : 'PAY',
			items : [ {
				boxLabel : '마감',
				width : 50,
				id : 'PAY_CLOSE',
				name : 'PAY',
				inputValue : 'Y',
				checked : true

			}, {
				boxLabel : '취소',
				width : 60,
				id : 'PAY_CANCEL',
				name : 'PAY',
				inputValue : 'N'
			} ],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					if(newValue.PAY == 'Y'){
						if(!Ext.isEmpty(panelSearch.getValue('OLD_YYYYMM'))){
							panelSearch.setValue('NOW_YYYYMM', UniDate.add(panelSearch.getValue('OLD_YYYYMM') ,  {months: +1}));
						}
					}else{
						panelSearch.setValue('NOW_YYYYMM', panelSearch.getValue('OLD_YYYYMM'));
					}
					
				}
			}
		},{
			xtype : 'button',
			text : '실행',
			width : 100,
			margin : '0 0 5 100',
			handler : function(btn) {
				if(Ext.getCmp('PAY').getValue().PAY =='Y'){
					if(confirm('마감을 실행 하시겠습니까?')) {
						doBatch();		
					}
				}else{
					if (Ext.isEmpty(Ext.getCmp('OLD_YYYYMM').getValue())){
		     			Ext.Msg.alert('확인', Msg.sMB382);
					} else {
						if(confirm('마감을 취소 하시겠습니까?')) {
							doBatch();		
						}
					}
				}
			}
		}]
	});
		function doBatch() {
			var detailform = panelSearch.getForm();
			if (detailform.isValid()) {
				var param = Ext.getCmp('searchForm').getValues();
				if (Ext.isEmpty(Ext.getCmp('OLD_YYYYMM').getValue())){
					var currentDate = UniDate.add((Ext.getCmp('NOW_YYYYMM').getValue()), {months:-1});
				} else {
					var currentDate = Ext.getCmp('OLD_YYYYMM').getValue();
				}
				var currentYear = currentDate.getFullYear();
				var currentMon = currentDate.getMonth() + 1;
				var currentString = currentYear + '/' + currentMon + '/01';
				var close_date = new Date(currentString);
				close_date.setMonth(close_date.getMonth() - 1);
				var close_year = close_date.getFullYear();
				var close_mon = close_date.getMonth() + 1;
				close_mon = (close_mon > 9 ? close_mon : '0' + close_mon)
				param.close_date = close_year + "" + close_mon;
				param.S_USER_ID = "${loginVO.userID}";
				console.log(param);

				hbs930ukrService.doBatch(param, function(provider, response)	{
	     			Ext.Msg.alert('확인', '작업이 완료되었습니다.');
				});

				if (Ext.getCmp('PAY').getValue().PAY == 'Y') {
					date(false, false, '');
				} else {
					date(false, true, '');
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
					Ext.Msg.alert('확인', labelText + Msg.sHHH000T061);
					// validation이 맞지 않는 필드 중 제일 처음 필드에 포커스를 줌
					invalid.items[0].focus();
				}
			}
		}

		function date(init, cancel, colData) {
			if (!cancel) {
				if (init) {
					if (colData == "") {
						panelSearch.setValue('OLD_YYYYMM', "");
						panelSearch.setValue('NOW_YYYYMM', "");
					} else {
						panelSearch.setValue('OLD_YYYYMM', colData);
						if (Ext.isEmpty(Ext.getCmp('OLD_YYYYMM').getValue())){
							var currentDate = UniDate.add((Ext.getCmp('NOW_YYYYMM').getValue()), {months:-1});
						} else {
							var currentDate = Ext.getCmp('OLD_YYYYMM').getValue();
						}
						var currentYear = currentDate.getFullYear();

						var currentMon = currentDate.getMonth() + 1;
						var currentString = currentYear + '/' + currentMon	+ '/01';
						var date = new Date(currentString);
						date.setMonth(date.getMonth() + 1);
						var year = date.getFullYear();
						var mon = date.getMonth() + 1;
						panelSearch.setValue('NOW_YYYYMM', year + '/'	+ (mon > 9 ? mon : '0' + mon));
						Ext.getCmp('searchForm').getForm().findField('NOW_YYYYMM').setReadOnly(true);
					}
				} else {
					if (Ext.isEmpty(Ext.getCmp('OLD_YYYYMM').getValue())){
						var currentDate = UniDate.add((Ext.getCmp('NOW_YYYYMM').getValue()), {months:-1});
					} else {
						var currentDate = Ext.getCmp('OLD_YYYYMM').getValue();
					}
					var currentYear = currentDate.getFullYear();
					var currentMon = currentDate.getMonth() + 1;
					var currentString = currentYear + '/' + currentMon + '/01';
					var date = new Date(currentString);
					date.setMonth(date.getMonth() + 1);
					var year = date.getFullYear();
					var mon = date.getMonth() + 1;
					panelSearch.setValue('OLD_YYYYMM', year + '/' + (mon > 9 ? mon : '0' + mon));

					var oldDate = new Date(date);
					oldDate.setMonth(oldDate.getMonth() + 1);
					var oldYear = oldDate.getFullYear();
					var oldMon = oldDate.getMonth() + 1;
					panelSearch.setValue('NOW_YYYYMM', oldYear + '/' + (oldMon > 9 ? oldMon : '0' + oldMon));
					Ext.getCmp('searchForm').getForm().findField('NOW_YYYYMM').setReadOnly(true);
				}

			} else {
				if (Ext.isEmpty(Ext.getCmp('OLD_YYYYMM').getValue())){
					var currentDate = UniDate.add((Ext.getCmp('NOW_YYYYMM').getValue()), {months:-1});
				} else {
					var currentDate = Ext.getCmp('OLD_YYYYMM').getValue();
				}
				var currentYear = currentDate.getFullYear();
				var currentMon = currentDate.getMonth() + 1;
				var currentString = currentYear + '/' + currentMon + '/01';
				var date = new Date(currentString);
				date.setMonth(date.getMonth() - 1);
				var year = date.getFullYear();
				var mon = date.getMonth() + 1;
				panelSearch.setValue('OLD_YYYYMM', year + '/' + (mon > 9 ? mon : '0' + mon));
				panelSearch.setValue('NOW_YYYYMM', Ext.getCmp('OLD_YYYYMM').getValue());
				Ext.getCmp('searchForm').getForm().findField('NOW_YYYYMM').setReadOnly(true);
			}
		}

	Unilite.Main({
		items : [ panelSearch ],
		id : 'hbs930ukrApp',
		fnInitBinding : function() {
			var param = Ext.getCmp('searchForm').getValues();
			hbs930ukrService.selectCloseyymm(param, function(provider, response)	{
				if (Ext.isEmpty(provider[0])){
					var colData = '';
				} else {
					var colData = provider[0];
				}
				date(true, false, colData);
				
			});
			
			//급여구분이 1보다 크고 'E'보다 작은 것만 가져와서 콤보박스에 SET
			var store = Ext.getStore('CBS_AU_H032');
			var selectedModel = store.getRange();
			Ext.each(selectedModel, function(record, i) {
				if (record.data.value == '1' || record.data.value > 'E') {
					store.remove(record);
				}
/*					if (record.data.value == '1' || record.data.value == 'F'
							|| record.data.value == 'G'
							|| record.data.value == 'L'
							|| record.data.value == 'M') {
						//if (record.data.value != '2'||record.data.value != '3'||record.data.value != '4') {
						//store.removeAt(i);
						store.remove(record);
						//alert(i+"      "+record.data.value);
					}*/
			});
			var combo = Ext.getCmp('CLOSE_TYPE');
			combo.bindStore('CBS_AU_H032');
			
			Ext.getCmp('searchForm').getForm().findField('OLD_YYYYMM').setReadOnly(true);

			//초기화 시 버튼 컨트롤
			UniAppManager.setToolbarButtons('query',false);
			UniAppManager.setToolbarButtons('reset',false);
			
			panelSearch.onLoadSelectText('CLOSE_TYPE');
		}
	});

};
</script>
