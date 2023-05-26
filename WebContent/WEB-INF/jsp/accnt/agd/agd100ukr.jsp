<%@page language="java" contentType="text/html; charset=utf-8"%> 
	<t:appConfig pgmId="agd100ukr"  >
	<t:ExtComboStore comboType="BOR120"  /> 									<!-- 사업장 -->
	<!--제약조건-->
	<!--<t:ExtComboStore comboType="AU" comboCode="H032" opts='1;2;3;4'/>--> 	<!--지급구분 -->
	<t:ExtComboStore comboType="AU" comboCode="H032" />				 			<!-- 지급구분 -->
	<t:ExtComboStore comboType="AU" comboCode="H031" /> 						<!-- 지급일구분 -->
	<t:ExtComboStore comboType="AU" comboCode="H011" /> 
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >

function appMain() {
var getChargeCode = ${getChargeCode};

	/* 모델 및 스토어 주석 처리
	Unilite.defineModel('agd100ukrModel', {		
	    fields: [{name: 'WORK_TYPE' 		,text: '작업항목'	,type: 'string'},			  
				 {name: 'WORK_START_TIME'	,text: '시작시간'	,type: 'string'},			  
				 {name: 'WORK_END_TIME'		,text: '종료시간'	,type: 'string'},
				 {name: 'WORK_TOTAL_TIME'	,text: '작업시간'	,type: 'string'},
				 {name: 'WORK_CONTENT'		,text: '작업내용'	,type: 'string'},			  
				 {name: 'WORK_REMARK'		,text: '비고' 	,type: 'string'}
			]
	});
	
	 Store 정의(Service 정의)
	 * @type 
	 					
	var MasterStore = Unilite.createStore('agd100ukrMasterStore',{
			model: 'agd100ukrModel',
			uniOpt : {
            	isMaster:	false,			// 상위 버튼 연결 
            	editable:	false,			// 수정 모드 사용 
            	deletable:	false,			// 삭제 가능 여부 
	            useNavi :	false			// prev | newxt 버튼 사용
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {			
                	   read: 'agd100ukrService.selectList'                	
                }
            }
			,loadStoreRecords : function()	{
				var param= Ext.getCmp('searchForm').getValues();			
				console.log( param );
				this.load({
					params : param
				});
			}
			//,groupField: 'CUSTOM_NAME'
	});
	*/

	/* 급상여자동기표 Master Form
	 * 
	 * @type
	 */     
	var panelSearch = Unilite.createForm('searchForm', {	
		disabled :false,
		flex:1,
		layout: {type: 'uniTable', columns: 1, tdAttrs: {valign:'top'}},
		items :[{
			 	fieldLabel: '급여년월',
			 	xtype: 'uniMonthfield',
			 	name: 'PAY_YYYYMM',
		        value: UniDate.get('today'),
			 	allowBlank:false
			},{
		 		fieldLabel: '급여구분',
		 		name:'SUPP_TYPE', 
		 		xtype: 'uniCombobox',
		 		comboType:'AU',
		 		comboCode:'H032',
		 		allowBlank:false,
		 		value:'1'
	 		},{ 
		 		fieldLabel: '지급차수',
		 		name:'PAY_PROV_FLAG', 
		 		xtype: 'uniCombobox',
		 		comboType:'AU',
		 		comboCode:'H031'
	 		},{ 
		 		fieldLabel: '고용형태',
		 		name:'PAY_GUBUN', 
		 		xtype: 'uniCombobox',
		 		comboType:'AU',
		 		comboCode:'H011'
	 		},{ 
				fieldLabel: '사업장',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
//				multiSelect: true, 
				typeAhead: false,
				//value : UserInfo.divCode,
				comboType: 'BOR120',
				allowBlank:false
			},		    
	        	Unilite.popup('DEPT',{
		        fieldLabel: '부서',
		        validateBlank:false,
			    valueFieldName:'DEPT_CODE_FR',
			    textFieldName:'DEPT_NAME_FR'
		    }),		    
	        	Unilite.popup('DEPT',{
		        fieldLabel: '~',
		        validateBlank:false,
			    valueFieldName:'DEPT_CODE_TO',
			    textFieldName:'DEPT_NAME_TO'
		    }),{
			 	fieldLabel: '전표일',
			 	xtype: 'uniDatefield',
			 	name: 'WORK_DATE',
		        value: UniDate.get('today'),
			 	allowBlank:false
			},{
                fieldLabel: '작업일',
                xtype: 'uniDatefield',
                name: 'INPUT_DATE',
                value: UniDate.get('today'),
                hidden: true
			}, 	
				Unilite.popup('REMARK_SINGLE',{ 
				name: 'REMARK',
				validateBlank:false,
                autoPopup: false,
		    	fieldLabel: '적요',
		    	popupWidth: 500
			}), 
			Unilite.popup('ACCNT',{
		    	fieldLabel: '지급계정',
				allowBlank:false,
				autoPopup: true,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							/* 계정과목 동적 팝업
							 * 생성된 필드가 팝업일시 필드name은 아래와 같음		
							 * 			opt: '1' 미결항목용							opt: '2' 계정잔액1,2용					opt: '3' 관리항목 1~6용				
							 *  valueFieldName    textFieldName 		valueFieldName     textFieldName		 	valueFieldName    textFieldName
							 *    PEND_CODE			PEND_NAME			 BOOK_CODE1(~2)	   BOOK_NAME1(~2)			 AC_DATA1(~6)	 AC_DATA_NAME1(~6)
							 * ---------------------------------------------------------------------------------------------------------------------------
							 * 생성된 필드가 uniTextfield, uniNumberfield, uniDatefield일시 필드 name은 아래와 같음	
							 * opt: '1' 미결항목용			opt: '2' 계정잔액1,2용			opt: '3' 관리항목 1~6용							 
							 *    PEND_CODE					BOOK_CODE1(~2)				AC_DATA1(~6)		
							 * */
							panelSearch.down('#result_ViewPopup').setVisible(false);
							var param = {ACCNT_CD : panelSearch.getValue('ACCNT_CODE')};
							accntCommonService.fnGetAccntInfo(param, function(provider, response)	{
								var dataMap = provider;
								var opt = '2'	//opt: '1' 미결항목용		opt: '2' 계정잔액1,2용		opt: '3' 관리항목 1~6용
								UniAccnt.addMadeFields(panelSearch, dataMap, null, opt);								
/*								UniAccnt.addMadeFields(panelResult, dataMap, panelSearch, opt);
*/							});
						},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.down('#result_ViewPopup').setVisible(true);
						/* onClear시 removeField..
						 */
						UniAccnt.removeField(panelSearch);
					}
				},
				
		    }),
		    {fieldName : 'BOOK_DATA1', hidden:true},
			{fieldName : 'BOOK_DATA2', hidden:true},
			{
				xtype: 'container',
//				it: 'formFieldArea1', 
				itemId: 'formFieldArea1', 
				layout: {
					type: 'table', 
					columns:1,
					itemCls:'table_td_in_uniTable',
					tdAttrs: {
						width: 350
					}	
				}
			},{
				xtype:'container',
				itemId:'result_ViewPopup',
				colspan: 3,
				layout: {
					type: 'table', 
			   		columns:2,
			   		itemCls:'table_td_in_uniTable',
					tdAttrs: {
						width: 350
					}
				},
				items:[
					Unilite.popup('ACCNT_PRSN',{
					readOnly:true,
			    	fieldLabel: '계정잔액1',
			    	validateBlank:false,
					colspan: 2
			    }),
			    Unilite.popup('ACCNT_PRSN',{
					readOnly:true,
			    	fieldLabel: '계정잔액2',
			    	validateBlank:false
			    })
			]},{
				xtype: 'container',
		    	items:[{
		    		xtype: 'button',
		    		text: '실행',
		    		width: 60,
		    		margin: '0 0 0 120',	
					handler : function() {
						if(panelSearch.setAllFieldsReadOnly(true)){
							var param = panelSearch.getValues();
							panelSearch.getEl().mask('로딩중...','loading-indicator');
							agd100ukrService.procButton(param, 
								function(provider, response) {
									if(provider) {	
										UniAppManager.updateStatus("자동기표가 완료 되었습니다.");
									}
									console.log("response",response)
									panelSearch.getEl().unmask();
								}
							)
						return panelSearch.setAllFieldsReadOnly(true);
						}
					}
		    	},{
		    		xtype: 'button',
		    		text: '취소',
		    		width: 60,
		    		margin: '0 0 0 0',                                                       
					handler : function() {
						if(panelSearch.setAllFieldsReadOnly(true)){
							var param = panelSearch.getValues();
							panelSearch.getEl().mask('로딩중...','loading-indicator');
							agd100ukrService.cancButton(param, 
								function(provider, response) {
									if(provider) {	
										UniAppManager.updateStatus("취소 되었습니다.");
									}
									console.log("response",response)
									panelSearch.getEl().unmask();
								}
							)
							return panelSearch.setAllFieldsReadOnly(true);
						}
					}
	    		}]
			}
		],
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
			   		alert(labelText+Msg.sMB083);
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
	
    Unilite.Main( {
		items:[panelSearch],
		id  : 'agd100ukrApp',
		fnInitBinding : function() {
			//panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.getField('PAY_YYYYMM').focus();
			UniAppManager.setToolbarButtons('query',false);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);

			var activeSForm = panelSearch;
			activeSForm.onLoadSelectText('PAY_YYYYMM');
		}/*,		onQueryButtonDown : function()	{			
				masterGrid1.getStore().loadStoreRecords();
				var viewLocked = masterGrid1.lockedGrid.getView();
				var viewNormal = masterGrid1.normalGrid.getView();
				console.log("viewLocked : ",viewLocked);
				console.log("viewNormal : ",viewNormal);
			    viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
			    viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
			    viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
			    viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);				
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		}*/
	});
};
</script>
