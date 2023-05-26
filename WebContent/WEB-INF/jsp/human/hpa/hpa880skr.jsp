<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hpa880skr"  >
	<t:ExtComboStore comboType="AU" comboCode="H005" /> <!-- 직위 -->
	<t:ExtComboStore comboType="AU" comboCode="H031" /> <!-- 지급차수 -->
	<t:ExtComboStore comboType="AU" comboCode="H033" /> <!-- 근태 -->
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >


function appMain() {

	/* Model 정의
	 * @type
	 */
	Unilite.defineModel('Hpa880skrModel1', {
		fields: [
			{name: 'DIV_CODE'	 			,text:'<t:message code="system.label.human.division" default="사업장"/>'			,type:'string'		, comboType:'BOR120'},
			{name: 'DEPT_CODE'	 			,text:'DEPT_CODE'	,type:'string'},
			{name: 'DEPT_NAME'	 		,text:'<t:message code="system.label.human.department" default="부서"/>'			,type:'string'},
			{name: 'POST_CODE'	 			,text:'<t:message code="system.label.human.postcode" default="직위"/>'			,type:'string'		, comboType:'AU'	, comboCode:'H005'},
			{name: 'NAME'		 				,text:'<t:message code="system.label.human.name" default="성명"/>'			,type:'string'},
			{name: 'PERSON_NUMB' 		,text:'<t:message code="system.label.human.personnumb" default="사번"/>'			,type:'string'}

		]
	});

	Unilite.defineModel('Hpa880skrModel2', {
		fields: [
			{name: 'DUTY_CODE'	 		,text:'<t:message code="system.label.human.dutyhistory" default="근태내역"/>'		,type:'string'		, comboType:'AU'	, comboCode:'H033'},
			{name: 'DUTY_NUM'	 			,text:'<t:message code="system.label.human.days" default="일수"/>'			,type:'string'},
			{name: 'DUTY_TIME'	 			,text:'<t:message code="system.label.human.time" default="시간"/>'			,type:'string'}
		]
	});

	Unilite.defineModel('Hpa880skrModel3', {
		fields: [
			{name: 'NAME'		 				,text:'<t:message code="system.label.human.monyearprov" default="지급"/>/<t:message code="system.label.human.dedname" default="공제내역"/>'		,type:'string'},
			{name: 'AMOUNT'		 			,text:'<t:message code="system.label.human.amount" default="금액"/>'			,type:'uniPrice'}
		]
	});

	Unilite.defineModel('Hpa880skrModel4', {
		fields: [
			{name: 'JOIN_DATE'		 				,text:'<t:message code="system.label.human.joindate" default="입사일"/>'		,type:'string'},
			{name: 'RETR_DATE'						,text:'<t:message code="system.label.human.retrdate" default="퇴사일"/>'		,type:'string'},
			{name: 'WEEK_DAY'		 				,text:'<t:message code="system.label.human.totalworktime" default="총근무시간"/>'		,type:'number'},
			{name: 'DED_TIME'		 				,text:'<t:message code="system.label.human.dedtime" default="차감시간"/>'		,type:'number'},
			{name: 'WORK_TIME'		 			,text:'<t:message code="system.label.human.worktime" default="실근무시간"/>'		,type:'number'},
			{name: 'EXTEND_WORK_TIME'		,text:'<t:message code="system.label.human.extensionworktime" default="연장근무시간"/>'		,type:'number'},
			{name: 'WEEK_GIVE'		 				,text:'<t:message code="system.label.human.weekgive" default="주차지급일수"/>'		,type:'number'},
			{name: 'FULL_GIVE'					 	,text:'<t:message code="system.label.human.fullgive" default="만근지급일수"/>'		,type:'number'},
			{name: 'MONTH_GIVE'		 			,text:'<t:message code="system.label.human.monthgive1" default="월차지급일수"/>'		,type:'number'},
			{name: 'MENS_GIVE'		 				,text:'<t:message code="system.label.human.mensgive" default="보건지급일수"/>'		,type:'number'},
			{name: 'PAY_CODE'						,text:'<t:message code="system.label.human.paymethodcode" default="급여지급방식"/>'		,type:'string'},
			{name: 'PAY_PROV_FLAG'   			,text:'<t:message code="system.label.human.payprovflag2" default="지급차수"/>'		,type:'string'},
			{name: 'HIRE_INSUR_TYPE' 			,text:'<t:message code="system.label.human.hireinsurtype2" default="고용보험계산"/>'		,type:'string'},
			{name: 'COMP_TAX_I'			 		,text:'<t:message code="system.label.human.taxcalculation" default="세액계산"/>'		,type:'string'},
			{name: 'TAX_CODE'		 				,text:'<t:message code="system.label.human.taxtype" default="세액구분"/>'		,type:'string'},
			{name: 'MED_GRADE'		 			,text:'<t:message code="system.label.human.healthinsurrating" default="건강보험등급"/>' 	,type:'string'},
			{name: 'PENS_GRADE'		 			,text:'<t:message code="system.label.human.pensgrade" default="국민연금등급"/>' 	,type:'string'},
			{name: 'SPOUSE'		     				,text:'<t:message code="system.label.human.spouser" default="배우자"/>'		,type:'string'},
			{name: 'SUPP_AGED_NUM'	 		,text:'<t:message code="system.label.human.suppnum" default="부양자"/>'		,type:'number'}
		]
	});


	/* Store 정의(Service 정의)
	 * @type
	 */
	var masterStore1 = Unilite.createStore('hpa880skrMasterStore1',{
		model: 'Hpa880skrModel1',
		uniOpt : {
        	isMaster	: true,				// 상위 버튼 연결
        	editable	: false,			// 수정 모드 사용
        	deletable	: false,			// 삭제 가능 여부
            useNavi 	: false				// prev | newxt 버튼 사용
            	//비고(*) 사용않함
        },
        autoLoad: false,
        proxy: {
            type: 'direct',
            api: {
            	   read: 'hpa880skrService.selectList1'
            }
        },
        listeners: {
	        load: function(store, records) {
	            if (store.getCount() == 0) {
	            	if (masterStore2.getCount() > 0) masterStore2.loadStoreRecords('');
	            	if (masterStore3.getCount() > 0) masterStore3.loadStoreRecords('');
	            	if (masterStore4.getCount() > 0) {
	            		// not work...
	            		var form = Ext.getCmp('resultForm2');
	            		form.reset();

	            		Ext.each(panelView.getForm().getFields().items, function(field){
	                        field.setValue('');
	                 	});
	            	}
	            }
	        }
	    },
		loadStoreRecords : function()	{
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
		}
	});

	var masterStore2 = Unilite.createStore('hpa880skrMasterStore2',{
		model: 'Hpa880skrModel2',
		uniOpt : {
        	isMaster	: true,				// 상위 버튼 연결
        	editable	: false,			// 수정 모드 사용
        	deletable	: false,			// 삭제 가능 여부
            useNavi		: false				// prev | newxt 버튼 사용
            	//비고(*) 사용않함
        },
        autoLoad: false,
        proxy: {
            type: 'direct',
            api: {
            	   read: 'hpa880skrService.selectList2'
            }
        },
		loadStoreRecords : function(person_numb)	{
			var param= Ext.getCmp('searchForm').getValues();
			param.PERSON_NUMB = person_numb;
			console.log( param );
			this.load({
				params : param
			});
		}
	});

	var masterStore3 = Unilite.createStore('hpa880skrMasterStore3',{
		model: 'Hpa880skrModel3',
		uniOpt : {
        	isMaster	: true,				// 상위 버튼 연결
        	editable	: false,			// 수정 모드 사용
        	deletable	: false,			// 삭제 가능 여부
            useNavi		: false				// prev | newxt 버튼 사용
            	//비고(*) 사용않함
        },
        autoLoad: false,
        proxy: {
            type: 'direct',
            api: {
            	   read: 'hpa880skrService.selectList3'
            }
        }
		,loadStoreRecords : function(person_numb)	{
			var param= Ext.getCmp('searchForm').getValues();
			param.PERSON_NUMB = person_numb;
			console.log( param );
			this.load({
				params : param
			});
		}
	});

	var masterStore4 = Unilite.createStore('hpa880skrMasterStore4',{
		model: 'Hpa880skrModel4',
		uniOpt : {
        	isMaster	: true,				// 상위 버튼 연결
        	editable	: false,			// 수정 모드 사용
        	deletable	: false,			// 삭제 가능 여부
            useNavi		: false				// prev | newxt 버튼 사용
            	//비고(*) 사용않함
        },
        autoLoad: false,
        proxy: {
            type: 'direct',
            api: {
            	   read: 'hpa880skrService.selectList4'
            }
        },
        listeners: {
	        load: function(store, records) {
	            var form = Ext.getCmp('resultForm2');
	            if (store.getCount() > 0) {
	            	form.loadRecord(records[0]);
	            	if (records[0].data.RETR_DATE == '0000.00.00') {
	            		panelView.setValue('RETR_DATE','');
	            	}
	            	Ext.getCmp('EI_CAL').setReadOnly(true);
					Ext.getCmp('TA_CAL').setReadOnly(true);
					Ext.getCmp('PARTNER').setReadOnly(true);
	            	Ext.getCmp('EI_CAL').setValue({HIRE_INSUR_TYPE : records[0].data.HIRE_INSUR_TYPE});
					Ext.getCmp('TA_CAL').setValue({COMP_TAX_I : records[0].data.COMP_TAX_I});
					Ext.getCmp('PARTNER').setValue({SPOUSE : records[0].data.SPOUSE});
	            } else {
	            	form.reset();
	            	Ext.getCmp('EI_CAL').setReadOnly(false);
					Ext.getCmp('TA_CAL').setReadOnly(false);
					Ext.getCmp('PARTNER').setReadOnly(false);
	            }
	        }
	    },
		loadStoreRecords : function(person_numb)	{
			var param= Ext.getCmp('searchForm').getValues();
			param.PERSON_NUMB = person_numb;
			console.log( param );
			this.load({
				params : param
			});
		}
	});

	/* 검색조건 (Search Panel)
	 * @type
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title: '<t:message code="system.label.human.searchconditon" default="검색조건"/>',
		defaultType: 'uniSearchSubPanel',
		collapsed: UserInfo.appOption.collapseLeftSearch,
        listeners: {
	        collapse: function () {
	        	panelView.show();
	        },
	        expand: function() {
	        	panelView.hide();
	        }
	    },
		items: [{
			title: '<t:message code="system.label.human.basisinfo" default="기본정보"/>',
			itemId: 'search_panel1',
			layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
	        items: [{
				fieldLabel:'<t:message code="system.label.human.payyyyymm" default="급여년월"/>',
				name: 'DUTY_YYYYMM',
				xtype: 'uniMonthfield',
				value: UniDate.get('today'),
// 				value: new Date().getFullYear()+'.'+(new Date().getMonth()+1),
				allowBlank:false,
// 				fieldStyle:"text-align:center;"
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DUTY_YYYYMM', newValue);
					}
				}
			},{
		        fieldLabel: '<t:message code="system.label.human.division" default="사업장"/>',
			    name:'DIV_CODE',
			    xtype: 'uniCombobox',
				multiSelect: false,
				typeAhead: false,
				value:UserInfo.divCode,
				comboType:'BOR120',
//				allowBlank:false,
			    listeners: {
			    	change: function(field, newValue, oldValue, eOpts) {
			     		panelResult.setValue('DIV_CODE', newValue);
			   		}
	     		}
			},{
                fieldLabel: '<t:message code="system.label.human.payprovflag2" default="지급차수"/>',
                name:'PAY_PROV_FLAG',
                xtype: 'uniCombobox',
                comboType:'AU',
                comboCode:'H031',
			    listeners: {
			    	change: function(field, newValue, oldValue, eOpts) {
			    		panelResult.setValue('PAY_PROV_FLAG', newValue);
			    	}
	     		}
            },
		        Unilite.popup('DEPT',{
		        fieldLabel: '<t:message code="system.label.human.department" default="부서"/>',
			    valueFieldName:'DEPT_CODE_FR',
			    textFieldName:'DEPT_NAME_FR',
//		        validateBlank:false,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('DEPT_CODE_FR', panelSearch.getValue('DEPT_CODE_FR'));
							panelResult.setValue('DEPT_NAME_FR', panelSearch.getValue('DEPT_NAME_FR'));
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('DEPT_CODE_FR', '');
						panelResult.setValue('DEPT_NAME_FR', '');
						panelSearch.setValue('DEPT_CODE_FR', '');
                        panelSearch.setValue('DEPT_NAME_FR', '');
					}
				}
		    }),
		      	Unilite.popup('DEPT',{
		        fieldLabel: '~',
			    valueFieldName:'DEPT_CODE_TO',
			    textFieldName:'DEPT_NAME_TO',
//		        validateBlank:false,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('DEPT_CODE_TO', panelSearch.getValue('DEPT_CODE_TO'));
							panelResult.setValue('DEPT_NAME_TO', panelSearch.getValue('DEPT_NAME_TO'));
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('DEPT_CODE_TO', '');
						panelResult.setValue('DEPT_NAME_TO', '');
						panelSearch.setValue('DEPT_CODE_FR', '');
                        panelSearch.setValue('DEPT_NAME_FR', '');
					}
				}
		    })]
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
			   		alert(labelText+'<t:message code="system.message.human.message045" default="필수입력 항목입니다."/>');
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

	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{
			fieldLabel:'<t:message code="system.label.human.payyyyymm" default="급여년월"/>',
			name: 'DUTY_YYYYMM',
			xtype: 'uniMonthfield',
			value: UniDate.get('today'),
			allowBlank:false,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('DUTY_YYYYMM', newValue);
				}
			}
		},{
	        fieldLabel: '<t:message code="system.label.human.division" default="사업장"/>',
		    name:'DIV_CODE',
		    xtype: 'uniCombobox',
			multiSelect: false,
			typeAhead: false,
			value:UserInfo.divCode,
			comboType:'BOR120',
			colspan: 2,
		    listeners: {
		      change: function(field, newValue, oldValue, eOpts) {
		       panelSearch.setValue('DIV_CODE', newValue);
		      }
     		}
		},{
            fieldLabel: '<t:message code="system.label.human.payprovflag2" default="지급차수"/>',
            name:'PAY_PROV_FLAG',
            xtype: 'uniCombobox',
            comboType:'AU',
            comboCode:'H031',
		    listeners: {
		    	change: function(field, newValue, oldValue, eOpts) {
		    		panelSearch.setValue('PAY_PROV_FLAG', newValue);
		    	}
     		}
        },
	        Unilite.popup('DEPT',{
	        fieldLabel: '<t:message code="system.label.human.department" default="부서"/>',
		    valueFieldName:'DEPT_CODE_FR',
		    textFieldName:'DEPT_NAME_FR',
			listeners: {
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('DEPT_CODE_FR', panelResult.getValue('DEPT_CODE_FR'));
						panelSearch.setValue('DEPT_NAME_FR', panelResult.getValue('DEPT_NAME_FR'));
					},
					scope: this
				},
				onClear: function(type)	{
					panelSearch.setValue('DEPT_CODE_FR', '');
					panelSearch.setValue('DEPT_NAME_FR', '');
					panelResult.setValue('DEPT_CODE_FR', '');
                    panelResult.setValue('DEPT_NAME_FR', '');
				}
			}
	    }),
	      	Unilite.popup('DEPT',{
	        fieldLabel: '~',
		    valueFieldName:'DEPT_CODE_TO',
		    textFieldName:'DEPT_NAME_TO',
		    labelWidth: 13,
			listeners: {
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('DEPT_CODE_TO', panelResult.getValue('DEPT_CODE_TO'));
						panelSearch.setValue('DEPT_NAME_TO', panelResult.getValue('DEPT_NAME_TO'));
					},
					scope: this
				},
				onClear: function(type)	{
					panelSearch.setValue('DEPT_CODE_TO', '');
					panelSearch.setValue('DEPT_NAME_TO', '');
					panelResult.setValue('DEPT_CODE_FR', '');
                    panelResult.setValue('DEPT_NAME_FR', '');
				}
			}
	    })]
	});

	/* 데이터 보여주는 패널 (Search Panel)
	 * @type
	 */
	var panelView = Unilite.createSimpleForm('resultForm2',{
    	region: 'center',
	    height: '100%',
	    flex: 0.8,
	    border:true,

	    items: [{
	    	xtype:'panel',
	        defaultType: 'uniTextfield',
	        layout: {type: 'uniTable', columns : 1,
	        tableAttrs: {/*style: 'border : 1px solid #ced9e7;',*/ width: '100%'},
			tdAttrs: {/*style: 'border : 1px solid #ced9e7;',*/ align : 'center'}

	        },
    		padding: '10 0 0 0',
    		border: false,

	        defaults: { readOnly:true },
	        items: [
	        	{fieldLabel: '<t:message code="system.label.human.joindate" default="입사일"/>', name: 'JOIN_DATE', fieldStyle: 'text-align:center'},
	        	{fieldLabel: '<t:message code="system.label.human.retrdate" default="퇴사일"/>', name: 'RETR_DATE', fieldStyle: 'text-align:center'},
	        	{fieldLabel: '<t:message code="system.label.human.totalworktime" default="총근무시간"/>', name: 'WEEK_DAY', fieldStyle: 'text-align:right'},
	        	{fieldLabel: '<t:message code="system.label.human.dedtime" default="차감시간"/>', name: 'DED_TIME', fieldStyle: 'text-align:right'},
	        	{fieldLabel: '<t:message code="system.label.human.worktime" default="실근무시간"/>', name: 'WORK_TIME', fieldStyle: 'text-align:right'},
	        	{fieldLabel: '<t:message code="system.label.human.extensionworktime" default="연장근무시간"/>', name: 'EXTEND_WORK_TIME', fieldStyle: 'text-align:right'},
	        	{fieldLabel: '<t:message code="system.label.human.weekgive" default="주차지급일수"/>', name: 'WEEK_GIVE', fieldStyle: 'text-align:right'},
	        	{fieldLabel: '<t:message code="system.label.human.fullgive" default="만근지급일수"/>', name: 'FULL_GIVE', fieldStyle: 'text-align:right'},
	        	{fieldLabel: '<t:message code="system.label.human.monthgive1" default="월차지급일수"/>', name: 'MONTH_GIVE', fieldStyle: 'text-align:right'},
	        	{fieldLabel: '<t:message code="system.label.human.yeargive3" default="중간입사자연차개수"/>', name: 'YEAR_GIVE', fieldStyle: 'text-align:right'},
	        	{fieldLabel: '<t:message code="system.label.human.paymethodcode" default="급여지급방식"/>', name: 'PAY_CODE'},
	        	{fieldLabel: '<t:message code="system.label.human.payprovflag2" default="지급차수"/>', name: 'PAY_PROV_FLAG'},
	        	{
		        	xtype: 'radiogroup',
					fieldLabel: '<t:message code="system.label.human.hireinsurtype2" default="고용보험계산"/>',
					id: 'EI_CAL',
					name : 'HIRE_INSUR_TYPE',
					items : [{
						boxLabel: '<t:message code="system.label.human.do" default="한다"/>',
						width: 50,
						name : 'HIRE_INSUR_TYPE',
						inputValue: 'Y'
					},{
						boxLabel: '<t:message code="system.label.human.donot" default="안한다"/>',
						width: 60,
						name : 'HIRE_INSUR_TYPE',
						inputValue: 'N'
					}
				]},{
		        	xtype: 'radiogroup',
					fieldLabel: '<t:message code="system.label.human.taxcalculation" default="세액계산"/>',
					id: 'TA_CAL',
					name : 'COMP_TAX_I',
					items : [{
						boxLabel: '<t:message code="system.label.human.do" default="한다"/>',
						width: 50,
						name : 'COMP_TAX_I',
						inputValue: 'Y'
					},{
						boxLabel: '<t:message code="system.label.human.donot" default="안한다"/>',
						width: 60,
						name : 'COMP_TAX_I',
						inputValue: 'N'
					}
				]},
	        	{fieldLabel: '<t:message code="system.label.human.taxtype" default="세액구분"/>', name: 'TAX_CODE'},
	        	{fieldLabel: '<t:message code="system.label.human.healthinsurrating" default="건강보험등급"/>', name: 'MED_GRADE'},
	        	{fieldLabel: '<t:message code="system.label.human.pensgrade" default="국민연금등급"/>', name: 'PENS_GRADE'},
	        	{
		        	xtype: 'radiogroup',
					fieldLabel: '<t:message code="system.label.human.spouser" default="배우자"/>',
					id: 'PARTNER',
					name: 'SPOUSE',
					items : [{
						boxLabel: '<t:message code="system.label.human.have" default="유"/>',
						width: 50,
						name: 'SPOUSE',
						inputValue: 'Y'
					},{
						boxLabel: '<t:message code="system.label.human.havenot" default="무"/>',
						width: 60,
						name: 'SPOUSE',
						inputValue: 'N'
					}
				]},
	        	{fieldLabel: '<t:message code="system.label.human.suppnum" default="부양자"/>', name: 'SUPP_AGED_NUM', fieldStyle: 'text-align:right'}
			]
		}]
    });		//End of var panelView = Unilite.createSimpleForm('resultForm2',{

    /* Master Grid 정의(Grid Panel)
     * @type
     */
    var masterGrid1 = Unilite.createGrid('hpa880skrGrid1', {
    	// for tab
        layout : 'fit',
        region:'west',
        uniOpt:{
        	expandLastColumn: false,
			onLoadSelectFirst: true,
        	useRowNumberer: false,
        	userToolbar: false
        },
    	store: masterStore1,
    	flex: 2,
        columns: [
        	{dataIndex: 'DIV_CODE',    width: 96},
        	{dataIndex: 'DEPT_CODE',   width: 96, hidden: true},
        	{dataIndex: 'DEPT_NAME',   width: 96},
        	{dataIndex: 'POST_CODE',   width: 96},
        	{dataIndex: 'NAME', 	   width: 96},
        	{dataIndex: 'PERSON_NUMB', flex: 1}
		],
        selModel: 'rowmodel',		// 조회화면 selectionchange event 사용
		listeners: {
            selectionchange: function(grid, selNodes ){
           	   console.log(selNodes[0]);
            	if (typeof selNodes[0] != 'undefined') {
            	  console.log(selNodes[0].data.PERSON_NUMB);
                  var person_numb = selNodes[0].data.PERSON_NUMB;
                  masterStore2.loadStoreRecords(person_numb);
                  masterStore3.loadStoreRecords(person_numb);
                  masterStore4.loadStoreRecords(person_numb);
                }
            }
        }
    });

	var masterGrid2 = Unilite.createGrid('hpa880skrGrid2', {
    	// for tab
        layout : 'fit',
        region:'north',
        selModel	: 'rowmodel',
        uniOpt:{
        	expandLastColumn: false,
			onLoadSelectFirst: false,
        	useRowNumberer: false,
        	userToolbar: false
        },
    	store: masterStore2,
        columns: [
        	{dataIndex: 'DUTY_CODE',    width: 100},
        	{dataIndex: 'DUTY_NUM',   	width: 70, align: 'right'},
        	{dataIndex: 'DUTY_TIME',    flex: 1, align: 'right'}
		]
    });

	var masterGrid3 = Unilite.createGrid('hpa880skrGrid3', {
    	// for tab
        layout : 'fit',
        region:'center',
        flex: 0.6,
        selModel	: 'rowmodel',
        uniOpt:{
        	expandLastColumn: false,
			onLoadSelectFirst: false,
        	useRowNumberer: false,
        	userToolbar: false
        },
    	store: masterStore3,
        columns: [
        	{dataIndex: 'NAME',    width: 120},
        	{dataIndex: 'AMOUNT',  flex: 1}
		]
    });


    Unilite.Main( {
	 	border: false,
		borderItems:[{
			layout: 'border',
			region: 'center',
			height: '100%',
			flex: 2.5,
			items:[
				panelResult,
				masterGrid1,
				panelView,
				{
					layout: 'border',
					region: 'east',
					flex: 0.7,
					items:[
						masterGrid2,
						masterGrid3
					]
				}
			]
		},
			panelSearch
		],
		id  : 'hpa880skrApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('DUTY_YYYYMM',UniDate.get('today'));
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DUTY_YYYYMM',UniDate.get('today'));

			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			UniAppManager.setToolbarButtons('save',false);
		},
		checkForNewDetail:function() {
			return panelSearch.setAllFieldsReadOnly(true);
        },
		onQueryButtonDown : function()	{
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{
				var detailform = panelSearch.getForm();
				if (detailform.isValid()) {
					masterStore1.loadStoreRecords();
				} else {
					var invalid = panelSearch.getForm().getFields().filterBy(function(field) {
						return !field.validate();
					});
					if(invalid.length > 0)	{
						r = false;
						var labelText = ''

						if(Ext.isDefined(invalid.items[0]['fieldLabel']))	{
							var labelText = invalid.items[0]['fieldLabel']+'은(는)';
						}else if(Ext.isDefined(invalid.items[0].ownerCt))	{
							var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
						}
						Ext.Msg.alert('<t:message code="system.label.human.confirm" default="확인"/>', labelText+'<t:message code="system.message.human.message045" default="필수입력 항목입니다."/>');
						invalid.items[0].focus();
					}
				}
				UniAppManager.setToolbarButtons('reset', true);
			}
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			panelView.clearForm();

			masterGrid1.reset();
			masterGrid2.reset();
			masterGrid3.reset();

			masterStore1.clearData();
			masterStore2.clearData();
			masterStore3.clearData();
			masterStore4.clearData();
			this.fnInitBinding();
		}
	});
};
</script>
