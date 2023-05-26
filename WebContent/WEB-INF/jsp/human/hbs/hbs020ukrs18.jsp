<%@page language="java" contentType="text/html; charset=utf-8"%>
	 {
		title:'<t:message code="system.label.human.bonusprovupdate" default="상여지급기준등록"/>',
		border: false,
		id:'hbs020ukrTab18',
		xtype: 'uniDetailForm',
		flex: 0.2,
		layout: {type: 'vbox', align: 'stretch'},
		items:[{
<!-- 			xtype: 'container', -->
			xtype: 'uniDetailFormSimple',
			id:'hbs020ukrTab18_inner',
			layout: {type: 'uniTable'},
			items:[{
				fieldLabel: '<t:message code="system.label.human.bonusprov" default="상여지급"/>',
				name: 'BONUS_TYPE', 
				id: 'BONUS_TYPE',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('bonusTypeList'),
				value: value18_1,
				allowBlank: false,
				itemId: 'tabFocus18'
			},{
				fieldLabel: '<t:message code="system.label.human.bonuspaytyper" default="상여계산구분자"/>',
				name: 'BONUS_KIND',
				id: 'BONUS_KIND',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'H037',
				allowBlank: false,
				value: value18_2
			}]			
		}, {
         xtype: 'container',         
         flex: 1,
         layout: {type: 'hbox', align: 'stretch'},
         items:[
            {
                  xtype: 'uniGridPanel',
//                  padding: '0 0 0 30',
//                  width: 1000,
//                  height: 350,
                  title: '<t:message code="system.label.human.bonusibaseupdate" default="상여금 지급 기준등록"/>',
                  flex: 1,
                  itemId: 'bonusGrid01',
                  id: 'bonusGrid01',
                   store : hbs020ukrs18Store,
                   uniOpt: {
                       expandLastColumn: false,
                       useRowNumberer: false,
                       useMultipleSorting: false,
					   state: {
						   useState: false,
						   useStateList: false
					   }
                  },              
                  columns: [
                     {dataIndex: 'BONUS_KIND'		 ,      width: 133, hidden: true},
                     {dataIndex: 'BONUS_TYPE'		 ,      width: 166, hidden: true},
                     {dataIndex: 'STRT_MONTH'		 ,      width: 186},
                     {dataIndex: 'LAST_MONTH'		 ,      width: 186},
                     {dataIndex: 'SUPP_RATE'		 ,      width: 180, 
					 		editor: {
						        xtype: 'numberfield',
						        decimalPrecision: 5
						    }	
					 },
                     {dataIndex: 'SUPP_TOTAL_I'      ,      width: 200,	flex: 1}
                  ],
                  listeners: {
                  	containerclick: function() {
                  		selectedGrid = 'bonusGrid01';
                  	}, select: function() {
                  		selectedGrid = 'bonusGrid01';
                  	}, cellclick: function() {
                  		selectedGrid = 'bonusGrid01';
                  	}, beforeedit: function(editor, e) {
						if (!e.record.phantom) {
							return false;
						}
					}, edit: function(editor, e) {
						var fieldName = e.field;
						if((fieldName == 'STRT_MONTH' || fieldName == 'LAST_MONTH') && isNaN(e.value)){
							Ext.Msg.alert('<t:message code="system.label.human.confirm" default="확인"/>', '<t:message code="system.message.human.message033" default="숫자형식이 잘못되었습니다."/>');
							e.record.set(fieldName, e.originalValue);
							return false;
						}
					}
                  }                    
            }]
         },{
         xtype: 'container',         
		 flex: 1,
         layout: {type: 'hbox', align: 'stretch'},
         items:[
            {
                  xtype: 'uniGridPanel',
                  title: '<t:message code="system.label.human.bonuskindchangeupdate" default="상여구분자 변경기준등록"/>',
//                  padding:'0 0 0 30',
                  width:700,
                  height: 350,
                  itemId:'bonusGrid02',
                  id: 'bonusGrid02',
                  store : hbs020ukrs18_1Store,
                  uniOpt: {
                      expandLastColumn: false,
                      useRowNumberer: false,
                      useMultipleSorting: false,
					  state: {
						  useState: false,
						  useStateList: false
					  }
                 },              
                 columns: [
                    {dataIndex: 'BE_BONUS_KIND'	 ,      width: 146},
                    {dataIndex: 'AF_BONUS_KIND'	 ,      width: 146},
                    {dataIndex: 'STD_MONTH'		 ,      width: 133,	flex: 1}
                 ],
                 listeners: {
                  	containerclick: function() {
                  		selectedGrid = 'bonusGrid02';
                  	}, select: function() {
                  		selectedGrid = 'bonusGrid02';
                  	}, cellclick: function() {
                  		selectedGrid = 'bonusGrid02';
                  	}, beforeedit: function(editor, e) {
						if (!e.record.phantom) {
							return false;
						}
					}, edit: function(editor, e) {
						var fieldName = e.field;
						if((fieldName == 'STD_MONTH') && isNaN(e.value)){
							Ext.Msg.alert('<t:message code="system.label.human.confirm" default="확인"/>', '<t:message code="system.message.human.message033" default="숫자형식이 잘못되었습니다."/>');
							e.record.set(fieldName, e.originalValue);
							return false;
						}
					}
                 }                                    
            },{
               border: false,
               name: '',
               html: "<font size='3'><t:message code="system.message.human.message095" default="[참고사항]"/><br>" +
               		 "&nbsp;&nbsp;<t:message code="system.message.human.message096" default="상여구분자가 신입사원(변경전)이었는데 근속개월"/> <br>" +
               		 "&nbsp;&nbsp;<t:message code="system.message.human.message097" default="수가 6개월이 경과한 후에는 경력사원(변경후)으로 변경된다."/><br>" +
               		 "&nbsp;&nbsp;<t:message code="system.message.human.message098" default="변경되는 시점은 상여기초자료일괄등록 에서 근속"/><br>" +
               		 "&nbsp;&nbsp;<t:message code="system.message.human.message099" default="개월수를 계산해 자동으로 변경된다."/><br>" +
               		 "&nbsp;&nbsp;<t:message code="system.message.human.message100" default="근속개월수의 시작일은 입사일이고 종료일은 상여기"/><br>" +
               		 "&nbsp;&nbsp;<t:message code="system.message.human.message101" default="초자료일괄등록에서 입력하는 지급기준일이 된다."/><br></font>",
               width: 600,
               padding: '20 0 180 20'
            }]
         }]
	}