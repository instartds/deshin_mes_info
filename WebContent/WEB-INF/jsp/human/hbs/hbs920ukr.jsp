<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hbs920ukr">
	<t:ExtComboStore comboType="AU" comboCode="H032" opts= '${gsList1}' />			<!-- 지급구분 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>

<script type="text/javascript">

function appMain() {
	var gsList1 = '${gsList1}';					//지급구분 '1'인 것만 콤보에서 보이도록 설정

//	var colData = "${colData}";					//fnInitBinding에서 처리(급여구분 변수값으로 넘어가야함)
//	console.log(colData);

	var panelSearch = Unilite.createForm('searchForm', {
		disabled :false,
    	flex:1,
    	layout: {type: 'uniTable', columns: 1, tdAttrs: {valign:'top'}},
		items : [{
			fieldLabel : '급여구분',
			name : 'CLOSE_TYPE',
			xtype : 'uniCombobox',
			comboType : 'AU',
			comboCode : 'H032',
			allowBlank : false,
			value : '1'
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
			name : 'NOW_YYYYMM'
		},{
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
			fieldLabel : '마감여부',
			id : 'PAY',
			name : 'PAY',
			items : [{
				boxLabel : '마감',
				width : 50,
				id : 'PAY_CLOSE',
				name : 'PAY',
				inputValue : 'Y',
				checked : true

			},{
				boxLabel : '취소',
				width : 60,
				id : 'PAY_CANCEL',
				name : 'PAY',
				inputValue : 'N'
			}],
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
			margin: '0 0 5 100',
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
		}
	]

	});
	function doBatch() {
		var detailform = panelSearch.getForm();
		if (detailform.isValid()) {
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

			var param = Ext.getCmp('searchForm').getValues();
			param.close_date = close_year + "" + close_mon;
			param.S_USER_ID = "${loginVO.userID}";
			console.log(param);
			
			if (Ext.getCmp('PAY').getValue().PAY == 'Y') {
				//마감 전 개인별 마감이 있는지 확인
				hbs920ukrService.personalCloseYn(param, function(provider, response)	{
					if (provider[0] != 0) {												//개인별 마감 데이터가 있는 경우
						//개인별 마감 데이터 같이 진행할지 여부 확인하여 처리 (확인: 진행 / 취소: 실행하지 않음)
						Ext.Msg.show({
						     title:'확인',
						     msg: "개인별 마감 작업된 데이터가 있습니다. 무시하고 일괄 마감하시겠습니까? " ,
						     buttons: Ext.Msg.YESNOCANCEL,
						     icon: Ext.Msg.QUESTION,
						     fn: function(res) {
						     	//console.log(res);
						     	if (res === 'yes' ) {
						     		hbs920ukrService.doBatch(param, function(provider, response)	{
						     			date(false, false, '');
						     			Ext.Msg.alert('확인', '작업이 완료되었습니다.');
						     		});
						     	}else if(res === 'no'){
						     		return false;
						     	}
						     }
						});
						
					} else {
						hbs920ukrService.doBatch(param, function(provider, response)	{
							date(false, false, '');
							Ext.Msg.alert('확인', '작업이 완료되었습니다.');
			     		});
					}
				});				
				
			} else {
				Ext.Msg.show({
				     title:'확인',
				     msg: "해당 월의 개인별 마감도 일괄 취소하시겠습니까? " ,
				     buttons: Ext.Msg.YESNOCANCEL,
				     icon: Ext.Msg.QUESTION,
				     fn: function(res) {
				     	//console.log(res);
				     	if (res === 'yes' ) {
				     		param.CANCLE_FLAG = 'Y';
				     		hbs920ukrService.doBatch(param, function(provider, response)	{
				     			Ext.Msg.alert('확인', '작업이 완료되었습니다.');
				     		});
				     		date(false, true, '');
				     	}else if(res === 'no'){
				     		param.CANCLE_FLAG = 'N';
				     		hbs920ukrService.doBatch(param, function(provider, response)	{
				     			Ext.Msg.alert('확인', '작업이 완료되었습니다.');
				     		});
				     		
				     		date(false, true, '');
				     	}
				     }
				});
			}
			
			/*if (Ext.getCmp('PAY').getValue().PAY == 'Y') {

				date(false, false, '');
			} else {

				
			}*/

		} else {														//필수값 누락 되었을 때
			var invalid = panelSearch.getForm().getFields().filterBy(
					function(field) {
						return !field.validate();
					});

			if (invalid.length > 0) {
				r = false;
				var labelText = ''

				if (Ext.isDefined(invalid.items[0]['fieldLabel'])) {
					var labelText = invalid.items[0]['fieldLabel'] + '은(는) ';
				} else if (Ext.isDefined(invalid.items[0].ownerCt)) {
					var labelText = invalid.items[0].ownerCt['fieldLabel']
							+ '은(는) ';
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
				} else {																	//초기화일 때
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
					//alert(mon);
					panelSearch.setValue('NOW_YYYYMM', year + '/'	+ (mon > 9 ? mon : '0' + mon));
					Ext.getCmp('searchForm').getForm().findField('NOW_YYYYMM').setReadOnly(true);
				}
			} else {																		//취소일 때
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
				panelSearch.setValue('OLD_YYYYMM', year + '/'	+ (mon > 9 ? mon : '0' + mon));

				var oldDate = new Date(date);
				oldDate.setMonth(oldDate.getMonth() + 1);
				var oldYear = oldDate.getFullYear();
				var oldMon = oldDate.getMonth() + 1;
				panelSearch.setValue('NOW_YYYYMM', oldYear + '/'		+ (oldMon > 9 ? oldMon : '0' + oldMon));
				Ext.getCmp('searchForm').getForm().findField('NOW_YYYYMM').setReadOnly(true);
			}

		} else {																		//마감일 때
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
			panelSearch.setValue('OLD_YYYYMM', year + '/'	+ (mon > 9 ? mon : '0' + mon));
			panelSearch.setValue('NOW_YYYYMM', Ext.getCmp('OLD_YYYYMM').getValue());
			Ext.getCmp('searchForm').getForm().findField('NOW_YYYYMM').setReadOnly(true);

		}
	}

	Unilite.Main({
		items : [ panelSearch ],
		id : 'hbs920ukrApp',
		fnInitBinding : function() {
			var param = Ext.getCmp('searchForm').getValues();
			hbs920ukrService.selectCloseyymm(param, function(provider, response)	{
				if (Ext.isEmpty(provider[0])){
					var colData = '';
				} else {
					var colData = provider[0];
				}
				date(true, false, colData);
				
			});

			Ext.getCmp('searchForm').getForm().findField('OLD_YYYYMM').setReadOnly(true);
			
			UniAppManager.setToolbarButtons('query',false);
			UniAppManager.setToolbarButtons('reset',false);

			panelSearch.onLoadSelectText('CLOSE_TYPE');

/*			panelSearch.setValue('OLD_YYYYMM',colData);
			date = new Date(Ext.getCmp('OLD_YYYYMM').getValue());	//2014.12
			date.setMonth(date.getMonth() + 1);
			var year = date.getFullYear();
			var mon = date.getMonth()+1;			
			panelSearch.setValue('NOW_YYYYMM',year+'0'+mon); */
		}
	});

};
</script>
