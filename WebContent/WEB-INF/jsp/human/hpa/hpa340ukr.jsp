<%@page language="java" contentType="text/html; charset=utf-8"%>

<t:appConfig pgmId="hpa340ukr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="H028" /> <!-- 급여지급방식 -->
	<t:ExtComboStore comboType="AU" comboCode="H031" /> <!-- 지급차수 -->
	<t:ExtComboStore comboType="AU" comboCode="H032" opts= '${gsList1}' />			<!-- 지급구분 -->
</t:appConfig>
<script type="text/javascript" >

function appMain() {
	var gsList1 = '${gsList1}';					//지급구분 '1'인 것만 콤보에서 보이도록 설정
	
	/* Model 정의 
	 * @type 
	 */
	/*Unilite.defineModel('Hpa340ukrModel', {		
	    fields: [{name: 'WORK_TYPE' 		,text: '작업항목'	,type: 'string'},			  
				 {name: 'WORK_START_TIME'	,text: '시작시간'	,type: 'string'},			  
				 {name: 'WORK_END_TIME'		,text: '종료시간'	,type: 'string'},
				 {name: 'WORK_TOTAL_TIME'	,text: '작업시간'	,type: 'string'},
				 {name: 'WORK_CONTENT'		,text: '작업내용'	,type: 'string'},			  
				 {name: 'WORK_REMARK'		,text: '비고' 	,type: 'string'}
			]
	});*/

	/* Store 정의(Service 정의)
	 * @type 
	 */					
	/*var directMasterStore1 = Unilite.createStore('hpa340ukrMasterStore1',{
			model: 'Hpa340ukrModel',
			uniOpt : {
            	isMaster: false,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi : false			// prev | newxt 버튼 사용
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {			
                	  read: 'hpa340ukrService.calcPay'                	
                }
            }
			,loadStoreRecords : function()	{
				var param= Ext.getCmp('searchForm').getValues();			
				console.log( param );
				this.load({
					params : param
				});				
			},
			groupField: 'CUSTOM_NAME'
			
	});*/
	
	/* 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createForm('searchForm', {		
		disabled :false,
    	flex:1,
    	layout: {type: 'uniTable', columns: 1, tdAttrs: {valign:'top'}},
		items: [{
    		fieldLabel		: '<t:message code="system.label.human.payyyyymm" default="급여년월"/>', 
    		xtype			: 'uniMonthfield',
    		value			: UniDate.get('today'),
    		name 			: 'PAY_YYYYMM',
        	id 				: 'PAY_YYYYMM',
    		allowBlank		: false
    	},{
			fieldLabel		: '<t:message code="system.label.human.suppdate" default="지급일"/>',
			id				: 'SUPP_DATE',
			xtype			: 'uniDatefield',
			name			: 'SUPP_DATE',                  
			allowBlank		: false
		},{
			fieldLabel		: '<t:message code="system.label.human.supptype" default="지급구분"/>',
			id				: 'SUPP_TYPE',
			name			: 'SUPP_TYPE', 
			xtype 			: 'uniCombobox',
			comboType 		: 'AU',
			comboCode 		: 'H032',
			allowBlank 		: false,
			value 			: '1'
		},{
			fieldLabel		: '<t:message code="system.label.human.division" default="사업장"/>',
			name			: 'DIV_CODE', 
			xtype			: 'uniCombobox',
			comboType		: 'BOR120'
		},
		Unilite.popup('DEPT', { 
			fieldLabel		: '<t:message code="system.label.human.department" default="부서"/>', 
			valueFieldName	: 'DEPT_CODE_FR',
			textFieldName	: 'DEPT_NAME_FR',
			autoPopup		: true,
			holdable		: 'hold'
		}),Unilite.popup('DEPT', { 
			fieldLabel		: ' ~ ', 
			valueFieldName	: 'DEPT_CODE_TO',
			textFieldName	: 'DEPT_NAME_TO',
			autoPopup		: true,
			holdable		: 'hold'
		}),{
			fieldLabel		: '<t:message code="system.label.human.paymethodcode" default="급여지급방식"/>',
			name			: 'PAY_CODE', 
			xtype			: 'uniCombobox',
			comboType		: 'AU',
			comboCode		: 'H028'
		},{
			fieldLabel		: '<t:message code="system.label.human.payprovflag2" default="지급차수"/>',
			name			: 'PAY_PROV_FLAG', 
			xtype			: 'uniCombobox',
			comboType		: 'AU',
			comboCode		: 'H031'
		},
	      	Unilite.popup('Employee',{
	      	fieldLabel 		: '<t:message code="system.label.human.employee" default="사원"/>',
		    valueFieldName	: 'PERSON_NUMB',
		    textFieldName	: 'NAME',
		    autoPopup		: true,
			listeners:{
				onTextSpecialKey: function(elm, e){
                    if (e.getKey() == e.ENTER) {
                    	panelSearch.getField('PERSON_NUMB').focus();  
                	}
                },
                applyextparam: function(popup){
                }
			}
  		})
  		,{
		    	xtype: 'container',
		    	padding: '10 0 0 0',
		    	layout: {
		    		type: 'hbox',
					align: 'center',
					pack:'center'
		    	}
		    }
  		,{
	    	xtype: 'container',
//	    	padding: '10 0 0 0',
/*	    	layout: {
	    		type	: 'vbox',
				align	: 'center',
				pack	: 'center'
	    	},*/
	    	tdAttrs: {align: 'center'},
	    	items:[{
	    		xtype	: 'button',
	    		text	: '<t:message code="system.label.human.execute" default="실행"/>',
	    		width	: 70,
	    		handler	: function(){
	    			if(!panelSearch.getInvalidMessage()) {
	    				return false;
	    			}
        			var param= Ext.getCmp('searchForm').getValues();
        			param.BASEDATA_YN	= 'Y';
        			param.CALC_HIR 		= 'N'
					panelSearch.getEl().mask('<t:message code="system.message.human.message063" default="급여계산 중..."/>','loading-indicator');
					hpa340ukrService.spCalcPay(param, function(provider, response)	{
	        			console.log("response", response);
	        			console.log("provider", provider);
	        			if(!Ext.isEmpty(provider))	{
        					alert('<t:message code="system.message.human.message064" default="급여계산작업이 완료되었습니다."/>')										//급여작업이 완료되었습니다.
	        			}
	        			panelSearch.getEl().unmask();						
					});

	    		}
	    	},{
				xtype: 'button',
				//margin: '0, 50, 0, 0',
				text: '취소',
				width: 70,	
				handler: function() {
	    			if(!panelSearch.getInvalidMessage()) {
	    				return false;
	    			}
	    			
	    			if(confirm('취소를 하면 급여데이터가 모두 삭제됩니다.\n 취소를 하시겠습니까?'))	{
	        			var param= Ext.getCmp('searchForm').getValues();
	        			param.BASEDATA_YN	= 'N';
	        			param.CALC_HIR 		= 'N'
						panelSearch.getEl().mask('급여취소 중...','loading-indicator');
						hpa340ukrService.spCalcCancel(param, function(provider, response)	{
		        			console.log("response", response);
		        			console.log("provider", provider);
		        			if(!Ext.isEmpty(provider))	{
	        					alert('급여취소 작업이 완료되었습니다.')										//급여작업이 완료되었습니다.
		        			}
		        			panelSearch.getEl().unmask();						
						});
					}
					
				}
			}]
	    }]
	});

	
    Unilite.Main( {
		id				: 'hpa340ukrApp',
		items			: [ panelSearch ],

		fnInitBinding : function(params) {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);

			UniAppManager.setToolbarButtons('query',false);
			UniAppManager.setToolbarButtons('reset',false);
			
			//초기화 시 전표일로 포커스 이동
			panelSearch.onLoadSelectText('PAY_YYYYMM');
			
			if(!Ext.isEmpty(params && params.PGM_ID)){
				this.processParams(params);
			}
		},
        //링크로 넘어오는 params 받는 부분 
        processParams: function(params) {
			this.uniOpt.appParams = params;
			if(params.PGM_ID == 'hpa330ukr') {
				panelSearch.setValue('PAY_YYYYMM',	params.PAY_YYYYMM);
				panelSearch.setValue('NAME',		params.NAME);
				panelSearch.setValue('PERSON_NUMB',	params.PERSON_NUMB);
				panelSearch.setValue('SUPP_TYPE',	params.SUPP_TYPE);
				
			} else if(params.PGM_ID == 'agc110skr') {
			
			
			} else if(params.PGM_ID == 'agb150skr'){
			
			}	
		}
	});

};


</script>
