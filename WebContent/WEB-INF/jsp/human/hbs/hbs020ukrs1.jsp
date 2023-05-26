<%@page language="java" contentType="text/html; charset=utf-8"%>
	{
		title:'<t:message code="system.label.human.paymanagement" default="급여관리기준등록"/>',
		itemId: 'hbs020ukrTab1',
		id: 'hbs020ukrTab1',
		xtype: 'uniDetailForm',
		layout: {type: 'vbox', align: 'stretch'},
		listeners:{ 
			uniOnChange:function( form, dirty, eOpts ) { 
				if (dirty) { 
					console.log(dirty); 
					UniAppManager.app.setToolbarButtons('save', true); 
				} 
			} 
		}, 
		items:[{
        	xtype: 'fieldset',
        	title: '1. <t:message code="system.label.human.calculationmethod" default="계산방식"/>',
        	layout: {type: 'uniTable', columns: 1},
        	items:[
//        		{
//				xtype: 'radiogroup',
//				labelWidth:200,
//				fieldLabel: '<t:message code="system.label.human.incometaxcalculate" default="소득세 계산을"/>',
//				id: 'rdo1',
//				items: [{
//					boxLabel: '<t:message code="system.label.human.taxcalcurule1" default="간이세율기준표로 한다."/>',
//					width: 200,
//					name: 'TAX_CALCU_RULE',
//					inputValue: '1'
////					checked: true 
//				}, {
//					boxLabel: '<t:message code="system.label.human.taxcalcurule2" default="연말정산방식으로 한다."/>',
//					width: 150,
//					name: 'TAX_CALCU_RULE',
//					inputValue: '2'
//				}]
//			}, 
				{
				xtype: 'radiogroup',
				labelWidth:200,
				fieldLabel: '<t:message code="system.label.human.inccalcurule" default="소액징수부 계산을"/>',
				id: 'rdo2',
				items: [{
					boxLabel: '<t:message code="system.label.human.inccalcurule1" default="사용한다."/>',
					width: 200,
					name: 'INC_CALCU_RULE',
					inputValue: '1'
				}, {
					boxLabel: '<t:message code="system.label.human.inccalcurule2" default="사용하지 않는다."/>',
					width: 150,
					name: 'INC_CALCU_RULE',
					inputValue: '2'
//					checked: true 
				}]
			},{
				xtype: 'radiogroup',
				labelWidth:200,
				fieldLabel: '<t:message code="system.label.human.hircalcurule" default="고용보험 계산을"/>',
				id: 'rdo3',
				items: [{
					boxLabel: '<t:message code="system.label.human.hircalcurule1" default="월평균보수액으로 한다."/>',
					width: 200,
					name: 'HIR_CALCU_RULE',
					inputValue: '1'
				}, {
					boxLabel: '<t:message code="system.label.human.hircalcurule2" default="총급여액으로 한다."/>',
					width: 150,
					name: 'HIR_CALCU_RULE',
					inputValue: '2'
//					checked: true 
				}]
			},{
				xtype: 'radiogroup',
				labelWidth:200,
				fieldLabel: '<t:message code="system.label.human.medinsurcalcurule" default="건강보험 계산을"/>',
//				id: '',
				items: [{
					boxLabel: '<t:message code="system.label.human.medinsurcalcurule1" default="월평균보수액으로 한다."/>',
					width: 200,
					name: 'MED_INSUR_CALCU_RULE',
					inputValue: '1'
				}, {
					boxLabel: '<t:message code="system.label.human.medinsurcalcurule2" default="총급여액으로 한다(장기노인요양보험도 총급여액 기준으로 계산)."/>',
					width: 400,
					name: 'MED_INSUR_CALCU_RULE',
					inputValue: '2'
//					checked: true 
				}]
			},{
				xtype: 'radiogroup',
				labelWidth:200,
				fieldLabel: '<t:message code="system.label.human.lcicalcurule" default="장기노인요양보험을"/>',
				//id: '',
				items: [{
					//boxLabel: '<t:message code="system.label.human.lcicalcurule1" default="고지금액으로 계산한다."/>',
					boxLabel: '건강보험과 분리한다.',
					width: 200,
					name: 'LCI_CALCU_RULE',
					inputValue: '1'
				}, {
					//boxLabel: '<t:message code="system.label.human.lcicalcurule2" default="계산하지 않는다."/>',
					boxLabel: '건강보험에 포함한다.',
					width: 150,
					name: 'LCI_CALCU_RULE',
					inputValue: '2'
//					checked: true 
				}]
			},{
				xtype: 'radiogroup',
				labelWidth:200,
				fieldLabel: '<t:message code="system.label.human.medcalcurule" default="건강보험 입사일자 월에"/>',
				//id: '',
				items: [{
					boxLabel: '<t:message code="system.label.human.medcalcurule1" default="계산한다."/>',
					width: 200,
					name: 'MED_CALCU_RULE',
					inputValue: '1'
				}, {
					boxLabel: '<t:message code="system.label.human.medcalcurule2" default="계산하지 않는다(1일 입사자는 계산됨)."/>',
					width: 400,
					name: 'MED_CALCU_RULE',
					inputValue: '2'
//					checked: true 
				}]
			},{
				xtype: 'radiogroup',
				labelWidth:200,
				fieldLabel: '<t:message code="system.label.human.anutcalcurule" default="국민연금 입사일자 월에"/>',
				//id: '',
				items: [{
					boxLabel: '<t:message code="system.label.human.medcalcurule1" default="계산한다."/>',
					width: 200,
					name: 'ANUT_CALCU_RULE',
					inputValue: '1'
				}, {
					boxLabel: '<t:message code="system.label.human.medcalcurule2" default="계산하지 않는다(1일 입사자는 계산됨)."/>',
					width: 400,
					name: 'ANUT_CALCU_RULE',
					inputValue: '2'
//					checked: true 
				}]
			},{
				xtype: 'radiogroup',
				labelWidth:200,
				fieldLabel: '<t:message code="system.label.human.yearendtaxcalcurule" default="12월 31일 퇴사자"/>',
				//id: '',
				items: [{
					boxLabel: '<t:message code="system.label.human.yearendtaxcalcurule1" default="연말정산으로 처리한다."/>',
					width: 200,
					name: 'YEARENDTAX_CALCU_RULE',
					inputValue: '1'
				}, {
					boxLabel: '<t:message code="system.label.human.yearendtaxcalcurule2" default="중도퇴사로 처리한다."/>',
					width: 400,
					name: 'YEARENDTAX_CALCU_RULE',
					inputValue: '2'
//					checked: true 
				}]
			},{
				xtype: 'radiogroup',
				labelWidth:200,
				fieldLabel: '<t:message code="system.label.human.daylaborrule" default="일용직사원등록"/>',
				//id: '',
				items: [{
					boxLabel: '<t:message code="system.label.human.daylaborrule1" default="별도 구분한다."/>',
					width: 200,
					name: 'DAY_LABOR_RULE',
					inputValue: '1'
				}, {
					boxLabel: '<t:message code="system.label.human.daylaborrule2" default="인사관리에 포함한다."/>',
					width: 400,
					name: 'DAY_LABOR_RULE',
					inputValue: '2'
//					checked: true 
				}]
			}]
		},{
			xtype: 'fieldset',
			title: '2. <t:message code="system.label.human.socialinsur" default="사회보험료 부담율"/>',
 			layout: {type: 'uniTable', columns: 2},
			items:[{
				xtype: 'uniTextfield',
				fieldLabel: '<t:message code="system.label.human.medprsnratecong" default="건강보험은 개인이"/>',
				labelWidth:200,
				name:'MED_PRSN_RATE',
				fieldStyle: 'text-align:right',
				suffixTpl: '<t:message code="system.label.human.centtopay" default="% 를 부담하고"/>',
				allowBlank:false
			},{
				xtype: 'uniTextfield',
				fieldLabel: '<t:message code="system.label.human.medcomprate1" default="회사가"/>',
				name:'MED_COMP_RATE',
				fieldStyle: 'text-align:right',
				suffixTpl: '<t:message code="system.label.human.centtopay1" default="% 를 부담한다."/>',
				allowBlank:false
			},{
				xtype: 'uniTextfield',
				fieldLabel: '<t:message code="system.label.human.anutprsnratecong" default="국민연금은 개인이"/>',
				labelWidth:200,
				name:'ANUT_PRSN_RATE1',
				fieldStyle: 'text-align:right',
				suffixTpl: '<t:message code="system.label.human.centtopay" default="% 를 부담하고"/>',
				allowBlank:false
			},{
				xtype: 'uniTextfield',
				fieldLabel: '<t:message code="system.label.human.medcomprate1" default="회사가"/>',
				name:'ANUT_COMP_RATE1',
				fieldStyle: 'text-align:right',
				suffixTpl: '<t:message code="system.label.human.centtopay1" default="% 를 부담한다."/>',
				allowBlank:false
			},{
				xtype: 'uniTextfield',
				fieldLabel: '<t:message code="system.label.human.employratecong" default="고용보험은 개인이"/>',
				labelWidth:200,
				name:'EMPLOY_RATE',
				fieldStyle: 'text-align:right',
				suffixTpl: '<t:message code="system.label.human.centtopay2" default="% 를 수당합계에서 공제한다."/>',
				width:435,
				allowBlank:false,
				colspan:2
			},{
                xtype: 'uniTextfield',
                fieldLabel: '<t:message code="system.label.human.busishareratecong" default="고용보험 회사부담금은"/>',
                labelWidth:200,
                name:'BUSI_SHARE_RATE',
                fieldStyle: 'text-align:right',
                suffixTpl: '<t:message code="system.label.human.centtopay1" default="% 를 부담한다."/>',
                width:360,
                allowBlank:false
            },{
                xtype: 'uniTextfield',
                fieldLabel: '<t:message code="system.label.human.busisharerate2cong" default="고안직능"/>',
                name:'BUSI_SHARE_RATE2',
                fieldStyle: 'text-align:right',
                suffixTpl: '<t:message code="system.label.human.centtopay1" default="% 를 부담한다."/>',
                allowBlank:false 
            },{
				xtype: 'uniTextfield',
				fieldLabel: '<t:message code="system.label.human.workercompenratecong" default="산재보험 회사부담금은"/>',
				labelWidth:200,
				name:'WORKER_COMPEN_RATE',
				fieldStyle: 'text-align:right',
				suffixTpl: '<t:message code="system.label.human.centtopay1" default="% 를 부담한다."/>',
				width:360,
				allowBlank:false,
				colspan:2
			}]         
		}, {
			xtype: 'fieldset',
			title: '3. <t:message code="system.label.human.dutydeadlineupdate" default="근태지급마감일등록"/>',
			layout: {type: 'uniTable', columns: 1},
			items:[{
				xtype: 'uniGridPanel',
				padding:'0 0 0 70',
				width:680,
				height:130,
				store : hbs020ukrsGrid1Store,
				uniOpt: {
					expandLastColumn: false,
					useRowNumberer: false,
					useMultipleSorting: false,
					state: {
						useState: false,
						useStateList: false
					},
					excel: {
						useExcel: false,
						exportGroup : false
					},
					onLoadSelectFirst: false
				},              
				columns: [
					{dataIndex: 'MAIN_CODE'          ,      width: 0 ,hidden:true},
					{dataIndex: 'SUB_CODE'           ,      width: 33 ,hidden:true},
					{dataIndex: 'CODE_NAME'          ,      width: 320 },
					{dataIndex: 'SYSTEM_CODE_YN'     ,      width: 33 ,hidden:true},
					{dataIndex: 'REF_CODE1'          ,      width: 140, align: 'center', flex: 1 },
					{dataIndex: 'REF_CODE2'          ,      width: 140, align: 'center', flex: 1},
					{dataIndex: 'REF_CODE3'          ,      width: 33 ,hidden:true},
					{dataIndex: 'REF_CODE4'          ,      width: 120 ,hidden:true },
					{dataIndex: 'REF_CODE5'          ,      width: 0 ,hidden:true},
					{dataIndex: 'SUB_LENGTH'         ,      width: 0 ,hidden:true},
					{dataIndex: 'USE_YN'             ,      width: 0 ,hidden:true},
					{dataIndex: 'SORT_SEQ'           ,      width: 0 ,hidden:true},
					{dataIndex: 'UPDATE_DB_USER'     ,      width: 0 ,hidden:true},
					{dataIndex: 'UPDATE_DB_TIME'     ,      width: 0 ,hidden:true},
					{dataIndex: 'COMP_CODE'          ,      width: 0 ,hidden:true}
				],
				listeners: {
					edit: function(editor, e) {
						if(e.value > 31){
							Ext.Msg.alert('<t:message code="system.label.human.confirm" default="확인"/>', '<t:message code="system.message.human.message104" default="마감일이 31일을 넘을수 없습니다."/>');
							e.record.set(e.field, e.originalValue);
							return false;
						}else if(e.value < 0){
							Ext.Msg.alert('<t:message code="system.label.human.confirm" default="확인"/>', '<t:message code="system.message.human.message049" default="양수만 입력가능합니다."/>');
							e.record.set(e.field, e.originalValue);
							return false;
						}else if(isNaN(e.value)){
							Ext.Msg.alert('<t:message code="system.label.human.confirm" default="확인"/>', '<t:message code="system.message.human.message046" default="숫자만 입력가능합니다."/>');
							e.record.set(e.field, e.originalValue);
							return false;
						}else if (e.originalValue != e.value) {
							UniAppManager.setToolbarButtons('save', true);							
						} 
// 						else { 
//							UniAppManager.setToolbarButtons('save', false); 
//						} 
					}
				}                 
			},{
				border: false,
				name: '',
				html: "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
					"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
					'<t:message code="system.message.human.message105" default="말일인 경우"/> '+'"00"'+'<t:message code="system.message.human.message106" default="으로 입력하십시오."/>',
				width: 350
			}]
		},{
			xtype: 'fieldset',
			title: '4. <t:message code="system.label.human.dutyinputrule" default="일근태등록방식"/>',
			layout: {type: 'uniTable', columns: 1},
			items:[{
				xtype: 'radiogroup',
				fieldLabel:'<t:message code="system.label.human.dutyinputrulecong" default="일근태 등록시"/>',
				labelWidth:200,
				id: 'rdo4',
				items: [{
					boxLabel: '<t:message code="system.label.human.dutyinputrulecong1" default="출퇴근 시각을 입력한다."/>',
					width: 150,
					name: 'DUTY_INPUT_RULE',
					inputValue: 'Y'
				}, {
					boxLabel: '<t:message code="system.label.human.dutyinputrulecong2" default="근무한 시간을 입력한다."/>',
					width: 150,
					name: 'DUTY_INPUT_RULE',
					inputValue: 'N',
					checked: true
				}]
			}]         
		}, {
			xtype: 'fieldset',
			title: '5. <t:message code="system.label.human.dutypayynselection" default="근태계산 여부선택"/>',
			layout: {type: 'uniTable', columns: 1},
			items:[{
				xtype: 'radiogroup',
				fieldLabel:'<t:message code="system.label.human.weekcalcuyncong" default="주차계산을"/>',
				labelWidth:200,
				id: 'rdo5',
				items: [{
					boxLabel: '<t:message code="system.label.human.do" default="한다"/>',
					width: 150,
					name: 'WEEK_CALCU_YN',
					inputValue: 'Y',
					checked: true
				}, {
					boxLabel: '<t:message code="system.label.human.donot" default="안한다"/>',
					width: 150,
					name: 'WEEK_CALCU_YN',
					inputValue: 'N'
				}]	
			},
//				{
//				xtype: 'radiogroup',
//				fieldLabel:'<t:message code="system.label.human.monthcalcuyncong" default="월차계산을"/>',
//				labelWidth:200,
//				id: 'rdo6',
//				items: [{
//					boxLabel: '<t:message code="system.label.human.do" default="한다"/>',
//					width: 150,
//					name: 'MONTH_CALCU_YN',
//					inputValue: 'Y'
//				}, {
//					boxLabel: '<t:message code="system.label.human.donot" default="안한다"/>',
//					width: 150,
//					name: 'MONTH_CALCU_YN',
//					inputValue: 'N',
//					checked: true
//				}]
//			},
				{
				xtype: 'radiogroup',
				fieldLabel:'<t:message code="system.label.human.menscalcuyncong" default="보건계산을"/>',
				labelWidth:200,
				id: 'rdo7',
				items: [{
					boxLabel: '<t:message code="system.label.human.do" default="한다"/>',
					width: 150,
					name: 'MENS_CALCU_YN',
					inputValue: 'Y'
				}, {
					boxLabel: '<t:message code="system.label.human.donot" default="안한다"/>',
					width: 150,
					name: 'MENS_CALCU_YN',
					inputValue: 'N',
					checked: true
				}]
			}]         
		},{
			xtype: 'fieldset',
			title: '6. <t:message code="system.label.human.overtimeuseynselection" default="조기출근계획 사용여부 선택"/>',
			layout: {type: 'uniTable', columns: 1},
			items:[{
				xtype: 'radiogroup',
				fieldLabel:'<t:message code="system.label.human.earlyplanyncong" default="조기출근계획을"/>',
				labelWidth:200,
				id: 'rdo8',
				items: [{
					boxLabel: '<t:message code="system.label.human.inccalcurule1" default="사용한다."/>',
					width: 150,
					name: 'EARLY_PLAN_YN',
					inputValue: 'Y'
				}, {
					boxLabel: '<t:message code="system.label.human.inccalcurule2" default="사용하지 않는다."/>',
					width: 150,
					name: 'EARLY_PLAN_YN',
					inputValue: 'N',
					checked: true
				}]
			}]         
		},
			{
			xtype: 'fieldset',
			hidden:true,
			title: '7. <t:message code="system.label.human.extendworkpremiumyn" default="연장근로 할증여부선택"/>',
			layout: {type: 'uniTable', columns: 1},
			items:[{
				xtype: 'radiogroup',
				fieldLabel:'<t:message code="system.label.human.atlest4hours" default="최초 4시간을 25%"/>',
				labelWidth:200,
				hidden: true,
				id: 'rdo9',
				items: [{
					boxLabel: '<t:message code="system.label.human.medcalcurule1" default="계산한다."/>',
					width: 150,
					name: 'EXTEND_WORK_YN',
					inputValue: 'Y'
				}, {
					boxLabel: '<t:message code="system.label.human.donot" default="안한다"/>.',
					width: 150,
					name: 'EXTEND_WORK_YN',
					inputValue: 'N',
					checked: true
				}]
			},{ 
				fieldLabel: '<t:message code="system.label.human.week40hours" default="주 40시간 적용일자"/>',
				labelWidth:200,
				hidden:true,
				name: 'FIVE_APPLY_DATE',
				xtype: 'uniDatefield'
//				is null? 
//				value: UniDate.get('today') 
			}]         
		},
		{
			xtype: 'fieldset',
			title: '7. <t:message code="system.label.human.worktime1" default="근무시간"/>',
			layout: {type: 'uniTable', columns: 1},
			items:[{
				xtype: 'uniTextfield',
				fieldLabel: '<t:message code="system.label.human.ondaywork" default="하루근무는"/>',
				labelWidth:200,
				name:'DAY_WORK_TIME',
				fieldStyle: 'text-align:right',
				suffixTpl: ' <t:message code="system.label.human.horsworked" default="시간을 일한다."/>',
				width:360,
				allowBlank:false
			},{
				xtype: 'uniGridPanel',
				title:'<t:message code="system.label.human.monthworktime" default="월근무시간"/>',
				padding:'0 0 0 70',
				width:680,
				height:150,
				store : hbs020ukrs1_3Store,
				uniOpt: {
					expandLastColumn: false,
					useRowNumberer: false,
					useMultipleSorting: false,
					state: {
						useState: false,
						useStateList: false
					},
					excel: {
						useExcel: false,
						exportGroup : false
					},
					onLoadSelectFirst: false
				},              
				columns: [
					{dataIndex: 'SUB_CODE'                  ,      width: 100},
					{dataIndex: 'REF_CODE2'                 ,      width: 100},
					{dataIndex: 'WORK_TIME_FORMULAR_DISPLAY'        ,      flex: 1,
					 renderer: function(value, metaData,record) {
					 	var worktimeLabel = '<t:message code="system.label.human.calendarWorkTime" default="달력근무시간"/>';
					 	
					 	if(record.get("REF_CODE1") == '3') {
					 		worktimeLabel = '<t:message code="system.label.human.duty" default="근태"/>' + '<t:message code="system.label.human.worktime1" default="근무시간"/>';
					 	}
					 	return Unilite.nvl(record.get("REF_CODE2"), worktimeLabel) + record.get("WORK_TIME_FORMULAR") ;
					 }
					}
				],
				listeners: {
					edit: function(editor, e) {
						if (e.originalValue != e.value) {
							UniAppManager.setToolbarButtons('save', true);
						} 
					}
				}                   
			}]
		},{
			xtype: 'fieldset',
			title: '8. <t:message code="system.label.human.yearcontrol" default="연차생성 및 연차지급방식"/>',
//			padding: '10 0 20 0',
			layout: {type: 'uniTable', columns: 7},
			items:[{
    			xtype: 'radiogroup',		            		
    			fieldLabel: '<t:message code="system.label.human.dutycalculatway" default="연차계산방식"/>',	
    			hidden:true,
    			colspan: 7,
    			id: 'yearCalc',
    			items : [{
    				boxLabel: '<t:message code="system.label.human.accountyearmanagement" default="회계연도기준"/>',
    				width:110 ,
    				name: 'YEAR_TYPE', 
    				inputValue: '1'
    			}, {
    				boxLabel: '<t:message code="system.label.human.joindaybase" default="입사일 기준"/>', 
    				width:110 ,
    				name: 'YEAR_TYPE' , 
    				inputValue: '2'
    			}
//    				{
//    				boxLabel: '<t:message code="system.label.human.halfyearbase" default="상하반기 기준"/>',
//    				width:110 , 
//    				name: 'YEAR_TYPE' ,
//    				inputValue: '3'
//    			}
    			],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						//panelResult.getField('SALE_YN').setValue({SALE_YN: newValue});
						if(newValue.YEAR_TYPE == "1"){//회기말 기준
							Ext.getCmp('hidefield2').hide();
							Ext.getCmp('hidefield1').show();
						}else if(newValue.YEAR_TYPE == "2"){//입사월 기준
                            Ext.getCmp('hidefield2').hide();
                            Ext.getCmp('hidefield1').hide();
                        }
//                        else{//상하반기 기준
//                            Ext.getCmp('hidefield1').hide();
//                            Ext.getCmp('hidefield2').show();
//                        }
					}
				}
            },{xtype: 'radiogroup',                          
                fieldLabel: '<t:message code="system.label.human.yeariwallyn" default="연차이월여부"/>',   
                colspan: 7,
                id: 'yearCalc1',
                items : [{
                    boxLabel: '<t:message code="system.label.human.yes" default="예"/>',
                    width:110 ,
                    name: 'IWALL_YN', 
                    inputValue: 'Y'
                }, {
                    boxLabel: '<t:message code="system.label.human.no" default="아니오"/>', 
                    width:110 ,
                    name: 'IWALL_YN' , 
                    inputValue: 'N'
                }]
            },{
            	xtype: 'container',
            	layout: {type: 'uniTable', columns: 7},
            	id: 'hidefield1',
            	colspan: 7,
            	items:[{
					border: false,
					html: '▶<t:message code="system.label.human.accountyearmanagement" default="회계연도기준"/>',
					padding: '0 0 0 30',
					colspan:7
				},{
					fieldLabel: '<t:message code="system.label.human.createdbasetime" default="생성할 기준기간"/>',
					labelWidth:150,
					width:300,
					name: 'YEAR_STD_FR_YYYY', 
					xtype: 'combo',
					store: tab01ComboStore1,
					queryMode: 'local',
					displayField: 'name',
					valueField: 'value'
				},{
					xtype: 'uniTextfield',
					name:'YEAR_STD_FR_MM',
	//				value: '01', 
					fieldStyle: 'text-align:left',
					suffixTpl: '<t:message code="system.label.human.month" default="월"/>',
					width:50,
					listeners: {
						blur: function(field) {	
							newValue = field.getValue();
							if(Ext.isEmpty(newValue)) return false;
							if(isNaN(newValue)){
								alert('<t:message code="system.message.human.message046" default="숫자만 입력가능합니다."/>');
								field.setValue('');
								return false;
							}
							if(parseInt(newValue) < 1 || parseInt(newValue) >12){						
								alert('<t:message code="system.message.human.message075" default="정확한 월을 입력하십시오."/>');
								field.setValue('');
								return false;
							}						
							if(newValue.length == 1){
								field.setValue('0' + newValue);													
							}					
						}
					}
				},{
					xtype: 'uniTextfield',
					name:'YEAR_STD_FR_DD',
	//				value: '01', 
					fieldStyle: 'text-align:left',
					suffixTpl: '<t:message code="system.label.human.day" default="일"/>',
					width:50,
					listeners: {
						blur: function(field) {	
							newValue = field.getValue();
							if(Ext.isEmpty(newValue)) return false;
							if(isNaN(newValue)){
								alert('<t:message code="system.message.human.message046" default="숫자만 입력가능합니다."/>');
								field.setValue('');
								return false;
							}
							if(parseInt(newValue) < 1 || parseInt(newValue) >31){						
								alert('<t:message code="system.message.human.message107" default="한달이 31일을 초과할수 없습니다."/>');
								field.setValue('');
								return false;
							}						
							if(newValue.length == 1){
								field.setValue('0' + newValue);													
							}					
						}
					}
				},{
					xtype:  'displayfield', 
					value:'&nbsp;&nbsp;&nbsp;~&nbsp;&nbsp;&nbsp;'
				},{
					name: 'YEAR_STD_TO_YYYY', 
					xtype: 'uniCombobox',
					store: tab01ComboStore1,
					queryMode: 'local',
					displayField: 'name',
					valueField: 'value',
					width:100
				},{
					xtype: 'uniTextfield',
					name:'YEAR_STD_TO_MM',
	//				value: '12', 
					fieldStyle: 'text-align:left',
					suffixTpl: '<t:message code="system.label.human.month" default="월"/>',
					width:50,
					listeners: {
						blur: function(field) {	
							newValue = field.getValue();
							if(Ext.isEmpty(newValue)) return false;
							if(isNaN(newValue)){
								alert('<t:message code="system.message.human.message046" default="숫자만 입력가능합니다."/>');
								field.setValue('');
								return false;
							}
							if(parseInt(newValue) < 1 || parseInt(newValue) >12){						
								alert('<t:message code="system.message.human.message075" default="정확한 월을 입력하십시오."/>');
								field.setValue('');
								return false;
							}						
							if(newValue.length == 1){
								field.setValue('0' + newValue);													
							}					
						}
					}
				},{
					xtype: 'uniTextfield',
					name:'YEAR_STD_TO_DD',
	//				value: '31', 
					fieldStyle: 'text-align:left',
					suffixTpl: '<t:message code="system.label.human.day" default="일"/>',
					width:50,
					listeners: {
						blur: function(field) {	
							newValue = field.getValue();
							if(Ext.isEmpty(newValue)) return false;
							if(isNaN(newValue)){
								alert('<t:message code="system.message.human.message046" default="숫자만 입력가능합니다."/>');
								field.setValue('');
								return false;
							}
							if(parseInt(newValue) < 1 || parseInt(newValue) >31){						
								alert('<t:message code="system.message.human.message107" default="한달이 31일을 초과할수 없습니다."/>');
								field.setValue('');
								return false;
							}						
							if(newValue.length == 1){
								field.setValue('0' + newValue);													
							}					
						}
					}
				},{
					fieldLabel: '	<t:message code="system.label.human.yearusefryyyycong" default="사용할 기준기간"/>',
					labelWidth:150,
					width:300,
					name: 'YEAR_USE_FR_YYYY', 
					xtype: 'uniCombobox',
					store: tab01ComboStore2,
					queryMode: 'local',
					displayField: 'name',
					valueField: 'value'
				},{
					xtype: 'uniTextfield',
					name:'YEAR_USE_FR_MM',
	//				value: '01', 
					fieldStyle: 'text-align:left',
					suffixTpl: '<t:message code="system.label.human.month" default="월"/>',
					width:50,
					listeners: {
						blur: function(field) {	
							newValue = field.getValue();
							if(Ext.isEmpty(newValue)) return false;
							if(isNaN(newValue)){
								alert('<t:message code="system.message.human.message046" default="숫자만 입력가능합니다."/>');
								field.setValue('');
								return false;
							}
							if(parseInt(newValue) < 1 || parseInt(newValue) >12){						
								alert('<t:message code="system.message.human.message075" default="정확한 월을 입력하십시오."/>');
								field.setValue('');
								return false;
							}						
							if(newValue.length == 1){
								field.setValue('0' + newValue);													
							}					
						}
					}
				},{
					xtype: 'uniTextfield',
					name:'YEAR_USE_FR_DD',
	//				value: '01', 
					fieldStyle: 'text-align:left',
					suffixTpl: '<t:message code="system.label.human.day" default="일"/>',
					width:50,
					listeners: {
						blur: function(field) {	
							newValue = field.getValue();
							if(Ext.isEmpty(newValue)) return false;
							if(isNaN(newValue)){
								alert('<t:message code="system.message.human.message046" default="숫자만 입력가능합니다."/>');
								field.setValue('');
								return false;
							}
							if(parseInt(newValue) < 1 || parseInt(newValue) >31){						
								alert('<t:message code="system.message.human.message107" default="한달이 31일을 초과할수 없습니다."/>');
								field.setValue('');
								return false;
							}						
							if(newValue.length == 1){
								field.setValue('0' + newValue);													
							}					
						}
					}
				},{
					xtype:  'displayfield', 
					value:'&nbsp;&nbsp;&nbsp;~&nbsp;&nbsp;&nbsp;'
				},{
					name: 'YEAR_USE_TO_YYYY', 
					xtype: 'uniCombobox',
					store: tab01ComboStore2,
					queryMode: 'local',
					displayField: 'name',
					valueField: 'value',
					width:100
				},{
					xtype: 'uniTextfield',
					name:'YEAR_USE_TO_MM',
	//				value: '12', 
					fieldStyle: 'text-align:left',
					suffixTpl: '<t:message code="system.label.human.month" default="월"/>',
					width:50,
					listeners: {
						blur: function(field) {	
							newValue = field.getValue();
							if(Ext.isEmpty(newValue)) return false;
							if(isNaN(newValue)){
								alert('<t:message code="system.message.human.message046" default="숫자만 입력가능합니다."/>');
								field.setValue('');
								return false;
							}
							if(parseInt(newValue) < 1 || parseInt(newValue) >12){						
								alert('<t:message code="system.message.human.message075" default="정확한 월을 입력하십시오."/>');
								field.setValue('');
								return false;
							}						
							if(newValue.length == 1){
								field.setValue('0' + newValue);													
							}					
						}
					}
				},{
					xtype: 'uniTextfield',
					name:'YEAR_USE_TO_DD',
	//				value: '31', 
					fieldStyle: 'text-align:left',
					suffixTpl: '<t:message code="system.label.human.day" default="일"/>',
					width:50,
					listeners: {
						blur: function(field) {	
							newValue = field.getValue();
							if(Ext.isEmpty(newValue)) return false;
							if(isNaN(newValue)){
								alert('<t:message code="system.message.human.message046" default="숫자만 입력가능합니다."/>');
								field.setValue('');
								return false;
							}
							if(parseInt(newValue) < 1 || parseInt(newValue) >31){						
								alert('<t:message code="system.message.human.message107" default="한달이 31일을 초과할수 없습니다."/>');
								field.setValue('');
								return false;
							}						
							if(newValue.length == 1){
								field.setValue('0' + newValue);													
							}					
						}
					}
				},{
					fieldLabel: '<t:message code="system.label.human.yearprovyyyycong" default="연차수당지급 년도"/>',
					labelWidth:150,
					width:300,
					name: 'YEAR_PROV_YYYY', 
					xtype: 'uniCombobox',
					store: tab01ComboStore1,
					queryMode: 'local',
					displayField: 'name',
					valueField: 'value'
				},{
					xtype : 'checkbox',
					boxLabel: '당해년도 퇴직자 연차수당 퇴직금계산에서 제외',
					name: 'RETR_YEAR_ALLOWANCE', 
					value : '1',
					checked : false,
					colspan:6
				},{
					border: false,
					name: '',
					padding: '0 0 10 0',
					html: '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'+'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'+'<t:message code="system.message.human.message108" default="(EX : 연차수당 지급년도를"/>'+'<t:message code="system.label.human.nowyear" default="당년도"/>'+'<t:message code="system.message.human.message110" default="로 셋팅, 계산년월이 2018-03 일때 연차수당은 2018년도의 잔여연차(연차수당대상)을 기준으로 지급한다)"/>',
					colspan:7
				}]
            },{
            	xtype: 'container',
            	layout: {type: 'uniTable', columns: 7},
            	colspan: 7,
            	id: 'hidefield2',
            	items:[{
					border: false,
					name: '',
					html: '▶ <t:message code="system.label.human.halfyearbase" default="상하반기 기준"/>',
					padding: '0 0 0 30',
					colspan:7
				}/*,{
					xtype: 'radiogroup',
					fieldLabel:'상하반기 구분',
					colspan:7,
					labelWidth:150,
					items: [{
						boxLabel: ' 상반기',
						name: 'YEAR_TYPE_GB',
						width: 80,
						inputValue: '1'
					}, {
						boxLabel: ' 하반기',
						name: 'YEAR_TYPE_GB',
						width: 80,
						inputValue: '2'
					}]
				}*/,{
					xtype: 'container',
					layout: {type: 'uniTable', columns: 5},
					colspan: 7,
					items: [{
						fieldLabel: '<t:message code="system.label.human.firsthalfyear" default="상반기"/>',
						labelWidth:150,
						width: 235,
						name: 'YEAR_STD_FR_YYYY_CO', 
						xtype: 'combo',
						store: tab01ComboStore1,
						queryMode: 'local',
						displayField: 'name',
						valueField: 'value',
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {						
								Ext.getCmp('hbs020ukrTab1').setValue('YEAR_STD_FR_YYYY', newValue);
							}
						}
					},{
						xtype: 'uniTextfield',
						name:'YEAR_STD_FR_MM_CO',
						fieldStyle: 'text-align:left',
						suffixTpl: '<t:message code="system.label.human.month" default="월"/>',
						padding: '0 0 0 10',
						width:50,
						enforceMaxLength: true,
						maxLength: 2,
						labelWidth:150,
						listeners: {
							blur: function(field) {	
								newValue = field.getValue();
								if(Ext.isEmpty(newValue)) return false;
								if(isNaN(newValue)){
									alert('<t:message code="system.message.human.message046" default="숫자만 입력가능합니다."/>');
									field.setValue('');
									return false;
								}
								if(parseInt(newValue) < 1 || parseInt(newValue) >12){						
									alert('<t:message code="system.message.human.message075" default="정확한 월을 입력하십시오."/>');
									field.setValue('');
									return false;
								}						
								if(newValue.length == 1){
									field.setValue('0' + newValue);													
								}					
							}
						}
					},{
						xtype:  'displayfield', 
						value:'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;~&nbsp;&nbsp;&nbsp;'
					},{
//						fieldLabel: '생성할 기준기간',
						labelWidth:150,
						name: 'YEAR_STD_TO_YYYY_CO', 
						xtype: 'combo',
						store: tab01ComboStore1,
						queryMode: 'local',
						displayField: 'name',
						valueField: 'value',
						width: 75,
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {						
								Ext.getCmp('hbs020ukrTab1').setValue('YEAR_STD_TO_YYYY', newValue);
							}
						}
					},{
						xtype: 'uniTextfield',
						name:'YEAR_STD_TO_MM_CO',
						fieldLabel: '',
						fieldStyle: 'text-align:left',
						suffixTpl: '<t:message code="system.label.human.month" default="월"/>',
						padding: '0 0 0 10',
						width:50,
						colspan:4,
						enforceMaxLength: true,
						maxLength: 2,
						listeners: {
							blur: function(field) {	
								newValue = field.getValue();
								if(Ext.isEmpty(newValue)) return false;
								if(isNaN(newValue)){
									alert('<t:message code="system.message.human.message046" default="숫자만 입력가능합니다."/>');
									field.setValue('');
									return false;
								}
								if(parseInt(newValue) < 1 || parseInt(newValue) >12){						
									alert('<t:message code="system.message.human.message075" default="정확한 월을 입력하십시오."/>');
									field.setValue('');
									return false;
								}						
								if(newValue.length == 1){
									field.setValue('0' + newValue);													
								}					
							}
						}
					}]
				},{
					
					xtype: 'container',
					layout: {type: 'uniTable', columns: 5},
					colspan: 7,
					items: [{
						fieldLabel: '<t:message code="system.label.human.secondhalfyear" default="하반기"/>',
						labelWidth:150,
						width: 235,
						name: 'YEAR_STD_FR_YYYY_2', 
						xtype: 'combo',
						store: tab01ComboStore1,
						queryMode: 'local',
						displayField: 'name',
						valueField: 'value'
					},{
						xtype: 'uniTextfield',
						name:'YEAR_STD_FR_MM_2',
//						fieldLabel: '하반기',
						fieldStyle: 'text-align:left',
						suffixTpl: '<t:message code="system.label.human.month" default="월"/>',
						padding: '0 0 0 10',
						width:50,
						enforceMaxLength: true,
						maxLength: 2,
						labelWidth:150,
						listeners: {
							blur: function(field) {	
								newValue = field.getValue();
								if(Ext.isEmpty(newValue)) return false;
								if(isNaN(newValue)){
									alert('<t:message code="system.message.human.message046" default="숫자만 입력가능합니다."/>');
									field.setValue('');
									return false;
								}
								if(parseInt(newValue) < 1 || parseInt(newValue) >12){						
									alert('<t:message code="system.message.human.message075" default="정확한 월을 입력하십시오."/>');
									field.setValue('');
									return false;
								}						
								if(newValue.length == 1){
									field.setValue('0' + newValue);													
								}					
							}
						}
					},{
						xtype:  'displayfield', 
						value:'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;~&nbsp;&nbsp;&nbsp;'
					},{
//						fieldLabel: '생성할 기준기간',
						labelWidth:150,
						name: 'YEAR_STD_TO_YYYY_2', 
						xtype: 'combo',
						store: tab01ComboStore1,
						queryMode: 'local',
						displayField: 'name',
						valueField: 'value',
						width: 75						
					},{
						xtype: 'uniTextfield',
						name:'YEAR_STD_TO_MM_2',
						fieldLabel: '',
						fieldStyle: 'text-align:left',
						suffixTpl: '<t:message code="system.label.human.month" default="월"/>',
						padding: '0 0 0 10',
						width:50,
						colspan:4,
						enforceMaxLength: true,
						maxLength: 2,
						listeners: {
							blur: function(field) {	
								newValue = field.getValue();
								if(Ext.isEmpty(newValue)) return false;
								if(isNaN(newValue)){
									alert('<t:message code="system.message.human.message046" default="숫자만 입력가능합니다."/>');
									field.setValue('');
									return false;
								}
								if(parseInt(newValue) < 1 || parseInt(newValue) >12){						
									alert('<t:message code="system.message.human.message075" default="정확한 월을 입력하십시오."/>');
									field.setValue('');
									return false;
								}						
								if(newValue.length == 1){
									field.setValue('0' + newValue);													
								}					
							}
						}
					}]
				}]			
			}]
		},{
			xtype: 'fieldset',
			title: '9. <t:message code="system.label.human.tenurecalcumethod" default="근속기간산정방식"/>',
			layout: {type: 'uniTable', columns: 1},
			items:[{
				xtype: 'uniTextfield',
				fieldLabel: '<t:message code="system.label.human.longworkdutyrulecong" default="근속수당의 근속기간 산정시"/>',
				labelWidth:200,
				width:430,
				name:'LONG_WORK_DUTY_RULE',
				fieldStyle: 'text-align:right',
				suffixTpl: '<t:message code="system.label.human.longworkdutyrulecong1" default="일 이상이면 1개월로 간주한다"/>',
				allowBlank:false
			},{
				xtype: 'uniTextfield',
				fieldLabel: '<t:message code="system.label.human.bonusdutyrulecong" default="상여금의 근속기간 산정시"/>',
				labelWidth:200,
				width:430,
				name:'BONUS_DUTY_RULE',
				fieldStyle: 'text-align:right',
				suffixTpl: '<t:message code="system.label.human.longworkdutyrulecong1" default="일 이상이면 1개월로 간주한다"/>',
				allowBlank:false
			},{
				xtype: 'uniTextfield',
				fieldLabel: '<t:message code="system.label.human.retrdutyrulecong" default="퇴직금의 근속기간 산정시"/>',
				labelWidth:200,
				width:430,
				name:'RETR_DUTY_RULE',
				fieldStyle: 'text-align:right',
				suffixTpl: '<t:message code="system.label.human.longworkdutyrulecong1" default="일 이상이면 1개월로 간주한다"/>'
			}]
		}, {
			xtype: 'fieldset',
			title: '10. <t:message code="system.label.human.retrcalcurule" default="퇴직금계산방식"/>',
			layout: {type: 'uniTable', columns: 2},
			items:[{
				xtype: 'radiogroup',
				fieldLabel:'<t:message code="system.label.human.retrcalcu" default="퇴직금계산"/>',
				labelWidth:200,
				columns:1,
				id: 'rdo10',
				colspan:2,
				items: [{
					boxLabel: '<t:message code="system.label.human.retrcalcurule1" default="평균임금(퇴직전날부터 91일치의 입금을 3으로 나눈금액) * 근속개월 / 12"/>',
					name: 'RETR_CALCU_RULE',
					inputValue: '1'
				}, {
					boxLabel: '<t:message code="system.label.human.retrcalcurule2" default="평균임금(퇴직전날부터 91일치의 임금을 3으로 나눈금액) * 근속일수 / 365"/>',
					name: 'RETR_CALCU_RULE',
					inputValue: '2'
				},{
					boxLabel: '<t:message code="system.label.human.retrcalcurule3" default="년/월/일 퇴직금(퇴직전날부터 91일치의 임금을 3으로 나눈금액 * 근속개월의 년월일수)"/>',
					name: 'RETR_CALCU_RULE',
					inputValue: '3'
				},{
					boxLabel: '<t:message code="system.label.human.retrcalcurule4" default="일평균임금(퇴직전날부터 91일치의 임금을 91으로 나눈금액) * 30 * 근속일수 / 365"/>',
					name: 'RETR_CALCU_RULE',
					inputValue: '4'
//					checked:true 
				}]
			},{
				xtype: 'radiogroup',
				fieldLabel:'<t:message code="system.label.human.reflectavgwagebonuse" default="상여금의 평균임금 반영"/>',
				labelWidth:200,
				columns:1,
				id: 'rdo11',
				colspan:2,
				items: [{
					boxLabel: '<t:message code="system.label.human.reflectavgwagebonuse1" default="지급금액 * 반영율"/>',
					name: 'BONUS_RETRAVG_FLAG',
					inputValue: '1'
//					checked:true 
				}, {
					boxLabel: '<t:message code="system.label.human.reflectavgwagebonuse2" default="상여기준금 * 반영율"/>',
					name: 'BONUS_RETRAVG_FLAG',
					inputValue: '2'
				},{
					boxLabel: '<t:message code="system.label.human.reflectavgwagebonuse3" default="지급금액 * 지급율 * 반영율"/>',
					name: 'BONUS_RETRAVG_FLAG',
					inputValue: '3'
				}]
			},{
				xtype: 'uniGridPanel',
				title:'<t:message code="system.label.human.retrcalcuaddition" default="퇴직추계액"/>',
				padding:'0 0 0 70',
				width:680,
				height:130,
				store : hbs020ukrsGrid2Store,
				uniOpt: {
					expandLastColumn: false,
					useRowNumberer: false,
					useMultipleSorting: false,
					state: {
						useState: false,
						useStateList: false
					},
					excel: {
						useExcel: false,
						exportGroup : false
					},
					onLoadSelectFirst: false
				},              
				columns: [
					{dataIndex: 'PAY_CODE'                  ,      width: 100},
					{dataIndex: 'PAY_DD'                  	,      width: 60,hidden:true},
					{dataIndex: 'AMASS_NUM'                 ,      width: 50,hidden:true},
					{dataIndex: 'SAVE_MONTH_NUM'            ,      width: 120,hidden:true},
					{dataIndex: 'ABSENCE_CNT'               ,      width: 120,hidden:true},
					{dataIndex: 'SUPP_YEAR_NUM_A'           ,      width: 120,hidden:true},
					{dataIndex: 'SUPP_YEAR_NUM_B'           ,      width: 0,hidden:true},
					{dataIndex: 'WAGES_TYPE'               	,      flex: 1},
					{dataIndex: 'FIVE_DAY_CHECK'            ,      width: 0,hidden:true},
					{dataIndex: 'JOIN_MID_CHECK'            ,      width: 0,hidden:true}
				],
				listeners: {
					edit: function(editor, e) {
						if (e.originalValue != e.value) {
							UniAppManager.setToolbarButtons('save', true);
						} 
// 		  				else { 
// 		  					UniAppManager.setToolbarButtons('save', false); 
// 		  				} 
					}
				}                   
			}]
			},{
				xtype: 'fieldset',
				title: '11. <t:message code="system.label.human.yearEndTaxInstallmentYn" default="연말정산분납신청"/>',
				layout: {type: 'uniTable', columns: 1},
				items:[{
					xtype: 'uniNumberfield',
					fieldLabel: '<t:message code="system.label.human.yearEndTaxInstallmentAmt" default="가능금액"/>',
					labelWidth:100,
					width:200,
					name:'YEARENDTAX_INSTALLMENTS_AMT',
					fieldStyle: 'text-align:right',
					allowBlank:true
				}
		]}
	]
}