<%@page language="java" contentType="text/html; charset=utf-8"%> 
<t:appConfig pgmId="s_ass300ukr_KOCIS"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 --> 
	<t:ExtComboStore comboType="AU" comboCode="B013" /> <!-- 단위 -->
	<t:ExtComboStore comboType="AU" comboCode="A038" /> <!-- 상각상태 -->
	<t:ExtComboStore comboType="AU" comboCode="B004" /> <!-- 화폐단위 -->
	<t:ExtComboStore comboType="AU" comboCode="A035" /> <!-- 완료여부 -->
	<t:ExtComboStore comboType="AU" comboCode="A140" /> <!-- 결제유형 -->
	<t:ExtComboStore comboType="AU" comboCode="A022" /> <!-- 증빙유형(매입) -->
	<t:ExtComboStore comboType="AU" comboCode="A070" /> <!-- 불공제사유 -->
	<t:ExtComboStore comboType="AU" comboCode="A149" /> <!-- 전자발행여부 -->
	<t:ExtComboStore comboType="AU" comboCode="A042" /> <!-- 자산구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A" 	 /> <!-- Cost Pool -->
	<t:ExtComboStore comboType="AU" comboCode="ZA14" /> 					<!--10품종-->
	<t:ExtComboStore comboType="AU" comboCode="A392" /> 					<!-- 처리구분-->
	<t:ExtComboStore comboType="AU" comboCode="A393" /> 					<!-- 물품상태-->
    <t:ExtComboStore items="${COMBO_DEPT_KOCIS}" storeId="deptKocis" /> 	<!--기관-->

<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
</t:appConfig>
<script type="text/javascript" >
//var validateFlag = '2';	//업데이트시 validate를 타서 임시로 사용. 
var BsaCodeInfo = {
	gsAutoType: '${gsAutoType}',	
	gsAccntBasicInfo : '${getAccntBasicInfo}',
	gsMoneyUnit : '${gsMoneyUnit}'
};
var gsChargeCode =  Ext.isEmpty('${getChargeCode}') ? ['']: '${getChargeCode}';
function appMain() {
	isAutoAssetNum = false;
	if(BsaCodeInfo.gsAutoType == "Y"){
		isAutoAssetNum = true;
	}

	
	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title		: '검색조건',
        defaultType	: 'uniSearchSubPanel',
        collapsed	: true,
        listeners	: {
	        collapse: function () {
	            panelResult.show();
	        },
	        expand: function() {
	        	panelResult.hide();
	        }
        },
		items: [{	
			title: '기본정보', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items :[
		    	Unilite.popup('ASSET',{
			    fieldLabel: '자산코드', 
			    autoPopup: true,
//			    validateBlank: false,
			    allowBlank:false,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('ASSET_CODE', panelSearch.getValue('ASSET_CODE'));
							panelResult.setValue('ASSET_NAME', panelSearch.getValue('ASSET_NAME'));
                    	},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('ASSET_CODE', '');
						panelResult.setValue('ASSET_NAME', '');
						
						UniAppManager.app.onResetButtonDown();
						UniAppManager.setToolbarButtons('save', false);
					},
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('ASSET_CODE', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('ASSET_NAME', newValue);				
					}
				}
		   	})]
		}]
	});
		
	var panelResult = Unilite.createSearchForm('panelResultForm', {		
    	hidden	: !UserInfo.appOption.collapseLeftSearch,
		region	: 'north',
		layout	: {type : 'uniTable', columns : 3, tdAttrs: {/*style: 'border : 1px solid #ced9e7;',*/ width: '100%'}},
		padding	: '1 1 1 1',
		border	: true,
	    items	: [
	    	Unilite.popup('ASSET',{
		    fieldLabel	: '자산코드',  
//		    validateBlank: false, 
		    allowBlank	: false,
		    labelWidth	: 140,
			listeners	: {
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('ASSET_CODE', panelResult.getValue('ASSET_CODE'));
						panelSearch.setValue('ASSET_NAME', panelResult.getValue('ASSET_NAME'));
                	},
					scope: this
				},
				onClear: function(type)	{
					panelSearch.setValue('ASSET_CODE', '');
					panelSearch.setValue('ASSET_NAME', '');
					
					UniAppManager.app.onResetButtonDown();
					UniAppManager.setToolbarButtons('save', false);
				},
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('ASSET_CODE', newValue);								
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('ASSET_NAME', newValue);				
				}
			}
	   	})/*,{
			xtype	: 'container',
			layout	: {type : 'uniTable'},
			tdAttrs	: {align: 'right'},
	 		padding	: '0 0 5 0',
			items	: [{ 
	            xtype	: 'button',
//				itemId	: 'resetButton',
	            text	: '엑셀업로드',
		 		width	: 100, 
	            handler	: function() {
            
        	    }
        	}]
		}*/]
	});

	
	
	/** 물품신청등록  Master Form
	 * 
	 * @type
	 */     
	var detailForm = Unilite.createForm('ass300ukrDetail', {
    	disabled	: false,
    	border		: true,
    	region		: 'center',
    	padding		: '0 1 0 1',
    	layout		: {type: 'uniTable', columns: 2,tdAttrs: {valign:'top'}},
    	items		: [{
			//////////////////////////////////////////////////왼쪽 화면 시작
	    	xtype	: 'container',
	    	layout	: {type: 'uniTable', columns: 1,tdAttrs: {valign:'top'}},
	    	items	: [{
			 	fieldLabel	: '자산코드',
			 	xtype		: 'uniTextfield',
			 	name		: 'ASST',	
			 	allowBlank	: isAutoAssetNum,
			    labelWidth	: 140,
			    width		: 375,
			    margin		: '10 0 0 0',
			    readOnly	: isAutoAssetNum
			},{
			 	fieldLabel	: '디브레인 자산코드',
			 	xtype		: 'uniTextfield',
			 	name		: 'REMARK',	
			    labelWidth	: 140,
			    width		: 375
			},{
			 	fieldLabel	: '자산명(모델명)',
			 	xtype		: 'uniTextfield',
			 	name		: 'ASST_NAME',	
			 	allowBlank	: false,
			    labelWidth	: 140,
			    width		: 375
			},{
			 	fieldLabel	: '품명',
			 	xtype		: 'uniTextfield',
			 	name		: 'ITEM_NM',	
			 	allowBlank	: false,
			    labelWidth	: 140,
			    width		: 375
			},{
			 	fieldLabel	: '규격',
			 	xtype		: 'uniTextfield',
			 	name		: 'SPEC',
			    labelWidth	: 140,
			    width		: 375	
			},
			Unilite.popup('CUST_KOCIS',{
			    fieldLabel		: '제조사',
			    valueFieldName	: 'PURCHASE_DEPT_CODE', 
				textFieldName	: 'PURCHASE_DEPT_NAME', 
			    allowBlank		: false,
		   		labelWidth		: 140,
				listeners		: {
					onValueFieldChange: function(field, newValue){							
					},
					onTextFieldChange: function(field, newValue){;				
					}
				}
			}),{
				fieldLabel	: '수량',			 	
			 	xtype		: 'uniNumberfield',
			 	name		: 'ACQ_Q',
			    allowBlank	: false,
			    readOnly	: true,
			    value		: 1,
			    labelWidth	: 140,
			    width		: 375	
			},{
			 	fieldLabel	: '취득금액(원)',			 	
			 	xtype		: 'uniNumberfield',
			 	name		: 'ACQ_AMT_I',
			    labelWidth	: 140,
			    width		: 375,
			    decimalPrecision: 2,
				allowBlank	: false
			},{
				fieldLabel	: '취득일자',
			 	xtype		: 'uniDatefield',
			 	name		: 'ACQ_DATE',	
			 	allowBlank	: false,
		    	labelWidth	: 140,
		    	width		: 266,
		    	listeners	: {
		    		change: function(combo, newValue, oldValue, eOpts) {
						detailForm.setValue('USE_DATE', newValue)					
					}
		    	}
			},{
				fieldLabel	: '사용위치',			 	
			 	xtype		: 'uniTextfield',
			 	name		: 'PLACE_INFO',	
			 	allowBlank	: false,
			    labelWidth	: 140,
			    width		: 375	
			}]
		},{
		//////////////////////////////////////////////////오른쪽 화면 시작
	    	xtype: 'container',
	    	layout: {type: 'uniTable', columns: 1,tdAttrs: {valign:'top'}},
	    	items: [{
					fieldLabel	: '기관',
					name		: 'DEPT_CODE', 
					xtype		: 'uniCombobox',
	                store		: Ext.data.StoreManager.lookup('deptKocis'),
			   		margin		: '10 0 0 0',
			   		labelWidth	: 140,
					listeners	: {
						change: function(field, newValue, oldValue, eOpts) {						
	//						panelResult.setValue('DEPT_CODE', newValue);
						}
					}
				},{
	    			fieldLabel	: '10품종'	,
	    			name		: 'ITEM_CD', 
	    			xtype		: 'uniCombobox', 
	    			comboType	: 'AU',
	    			comboCode	: 'ZA14',	
			 		allowBlank	: false,
			    	labelWidth	: 140,
	    			listeners	: {
						change: function(combo, newValue, oldValue, eOpts) {	
							panelResult.setValue('ALTER_DIVI', newValue);
						}
					} 
	    		},{
	    			fieldLabel	: '물품상태'	,
	    			name		: 'ASS_STATE', 
	    			xtype		: 'uniCombobox', 
	    			comboType	: 'AU',
	    			comboCode	: 'A393',
			    	labelWidth	: 140,
	    			listeners	: {
						change: function(combo, newValue, oldValue, eOpts) {	
							panelResult.setValue('ALTER_DIVI', newValue);
						}
					} 
	    		},
				Unilite.popup('USER_SINGLE',{
				    fieldLabel	: '담당자',
					textFieldName	: 'NAME', 
//				    allowBlank	: false,
			   		labelWidth	: 140,
					listeners	: {
						onValueFieldChange: function(field, newValue){
//							detailForm.setValue('INSERT_DB_USER', newValue);								
						},
						onTextFieldChange: function(field, newValue){
//							detailForm.setValue('PURCHASE_DEPT_NAME', newValue);				
						}
					}
				}),{
					fieldLabel	: '관련근거',
					name		: 'REASON_NM',
					xtype		: 'uniTextfield',
					allowBlank	: false,
			    	labelWidth	: 140,
					width		: 258
				},{
					fieldLabel	: '물품용도',
					name		: 'ITEM_USE',
					xtype		: 'uniTextfield',
					allowBlank	: false,
			    	labelWidth	: 140,
					width		: 258
				},{
					fieldLabel	: '내용년수',
					name		: 'DRB_YEAR',
					xtype		: 'uniTextfield',
					allowBlank	: false,
			    	labelWidth	: 140,
					width		: 258
				},{
					xtype	: 'uniTextfield',
					name	: 'SAVE_FLAG',
					hidden	: true
				},{
					xtype	: 'uniTextfield',
					name	: 'AUTO_TYPE',
					value	: BsaCodeInfo.gsAutoType,
					hidden	: true
				},{
					xtype	: 'uniTextfield',
					name	: 'MONEY_UNIT',
					value	: BsaCodeInfo.gsMoneyUnit,
					hidden	: true
				},{
	    			fieldLabel	: '상각상태'	,
	    			name		: 'DPR_STS', 
	    			xtype		: 'uniCombobox', 
	    			comboType	: 'AU',
	    			comboCode	: 'A038',
					value		: '1',
					hidden		: true
	    		},{
					fieldLabel	: '사용일자',
				 	xtype		: 'uniDatefield',
				 	name		: 'USE_DATE',
					hidden		: true
				},{
					fieldLabel	: '사업장',
				 	xtype		: 'uniTextfield',
				 	name		: 'DIV_CODE',
				 	value		: UserInfo.divCode,
					hidden		: true
				},{
					fieldLabel	: '담당자',
				 	xtype		: 'uniTextfield',
				 	name		: 'INSERT_DB_USER',
					hidden		: true
				},{
					fieldLabel	: '입력자',
				 	xtype		: 'uniTextfield',
				 	name		: 'UPDATE_DB_USER',
				 	value		: UserInfo.userID,
					hidden		: true
				},{
					fieldLabel	: '판매비율',
				 	xtype		: 'uniNumberfield',
				 	name		: 'SALE_MANAGE_COST',
				 	value		: 0,
					hidden		: true
				},{
					fieldLabel	: '제조원가비율',
				 	xtype		: 'uniNumberfield',
				 	name		: 'PRODUCE_COST',
				 	value		: 0,
					hidden		: true
				},{
					fieldLabel	: '영업외비용비율',
				 	xtype		: 'uniNumberfield',
				 	name		: 'SALE_COST',
				 	value		: 0,
					hidden		: true
				},{
					fieldLabel	: '재고수량',
				 	xtype		: 'uniNumberfield',
				 	name		: 'STOCK_Q',
				 	value		: 0,
					hidden		: true
				}
			]
		}],
		listeners : {
			uniOnChange:function( basicForm, field, newValue, oldValue ) {
				console.log("onDirtyChange");
				if(basicForm.isDirty()/* && validateFlag == "1"*/ && newValue != oldValue)	{
					UniAppManager.setToolbarButtons('save', true);
					
				}else {
					UniAppManager.setToolbarButtons('save', false);
				}
//				validateFlag = '1';
			},
			beforeaction:function(basicForm, action, eOpts)	{
				
//				if(action.type =='directsubmit')	{
//					var invalid = this.getForm().getFields().filterBy(function(field) {
//					            return !field.validate();
//					    });
//		         	if(invalid.length > 0)	{
//			        	r=false;
//			        	var labelText = ''
//			        	
//			        	if(Ext.isDefined(invalid.items[0]['fieldLabel']))	{
//			        		var labelText = invalid.items[0]['fieldLabel']+'은(는)';
//			        	}else if(Ext.isDefined(invalid.items[0].ownerCt))	{
//			        		var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
//			        	}
//			        	alert(labelText+Msg.sMB083);
//			        	invalid.items[0].focus();
//			        }																									
//				}
			}
		},
		api: {
 		 load	: 's_ass300ukrService_KOCIS.selectMaster',
		 submit	: 's_ass300ukrService_KOCIS.syncMaster'				
		},		
	    setAllFieldsReadOnly: function(b) {
			var r= true
			if(b) {
//				validateFlag = '2';
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
				}
	  		}
//	  		validateFlag = '1';
			return r;
  		}
	});

         
    
	

    /** main app
	 */
    Unilite.Main({
		id			: 'ass300ukrApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				detailForm, panelResult
			]	
		},
			panelSearch
		],
		
		fnInitBinding : function(params) {
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('ASSET_CODE');
			
			this.setDefault();
			if(params) {
				this.processParams(params);
			}
		},
		
		processParams: function(params) {
//			this.uniOpt.appParams = params;			
			if(params && params.ASST && params.ASST_NAME) {
				if(params.PGM_ID == 'agd320ukr' || params.PGM_ID == 'ass500ukr' || params.PGM_ID == 'ass600skr'){//고정자산변동내역조회, 고정자산취득자동기표, 고정자산대장조회
					panelSearch.setValue('ASSET_CODE', params.ASST);
					panelSearch.setValue('ASSET_NAME', params.ASST_NAME);
					panelResult.setValue('ASSET_CODE', params.ASST);
					panelResult.setValue('ASSET_NAME', params.ASST_NAME);
				}
				UniAppManager.app.onQueryButtonDown(params);
			}
		},
		
		onQueryButtonDown:function (params) {
			if(!this.isValidSearchForm()){
				return false;
			}
			detailForm.clearForm();
			var param= panelSearch.getValues();
			if(Ext.isEmpty(params)){
				detailForm.getEl().mask('로딩중...','loading-indicator');
			}
			detailForm.uniOpt.inLoading=true; 
			detailForm.getForm().load({
				params: param,
				success:function()	{					
					detailForm.getEl().unmask();
					UniAppManager.setToolbarButtons('delete',true);					
//					detailForm.getField("ASST").setReadOnly(true);
					detailForm.setValue('SAVE_FLAG','U');
					detailForm.setDisabled(false);
					UniAppManager.setToolbarButtons('save',false);
					detailForm.uniOpt.inLoading=false;
				},
				failure: function(form, action) {
                    detailForm.getEl().unmask();
					UniAppManager.app.onResetButtonDown();
					UniAppManager.setToolbarButtons('save',false);
                }
			});
		},
		
		onResetButtonDown:function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			detailForm.clearForm();
			
			this.fnInitBinding();
			detailForm.setDisabled(false);
		},
		
		onDeleteDataButtonDown: function() {
//			if(!Ext.isEmpty(detailForm.getValue('EX_DATE'))){
//				alert('고정자산취득자동기표에서 기표취소 후 작업이 가능합니다.');
//				return false;
//			}
			if(confirm('현재 데이터를 삭제 합니다.\n 삭제 하시겠습니까?')) {
				detailForm.setValue('SAVE_FLAG','D');
				var param = detailForm.getValues();
				detailForm.getEl().mask('로딩중...','loading-indicator');				
				detailForm.submit({
					params: param,
					success:function(comp, action)	{
						UniAppManager.setToolbarButtons('save', false);
						UniAppManager.updateStatus(Msg.sMB011);
						detailForm.getEl().unmask();
						UniAppManager.app.onResetButtonDown();
					},
					failure: function(form, action){
						detailForm.getEl().unmask();
					}
				});	
			}
		},
		
		onSaveDataButtonDown: function (config) {
			if(!detailForm.setAllFieldsReadOnly(true)){
	    		return false;
	    	}
			var param= detailForm.getValues();	
			detailForm.getEl().mask('로딩중...','loading-indicator');	
			detailForm.submit({
				 params : param,
				 success : function(form, action) {
	 					detailForm.getForm().wasDirty = false;
						detailForm.resetDirtyStatus();											
						UniAppManager.setToolbarButtons('save', false);	
	            		UniAppManager.updateStatus(Msg.sMB011);// "저장되었습니다.
	            		detailForm.getEl().unmask();
	            		detailForm.setValue('SAVE_FLAG', 'U');
//	            		detailForm.getField("ASST").setReadOnly(true);
	            		if(detailForm.getValue('AUTO_TYPE') == "Y"){
	            			if(Ext.isEmpty(action.result.AUTO_ASST)){
	            				panelSearch.setValue('ASSET_CODE', detailForm.getValue("ASST"));
								panelResult.setValue('ASSET_CODE', detailForm.getValue("ASST"));
	            			}else{
	            				panelSearch.setValue('ASSET_CODE', action.result.AUTO_ASST);
	            				panelResult.setValue('ASSET_CODE', action.result.AUTO_ASST);
	            			}	            			
	            		}else{
	            			panelSearch.setValue('ASSET_CODE', detailForm.getValue("ASST"));
							panelResult.setValue('ASSET_CODE', detailForm.getValue("ASST"));
	            		} 
						panelSearch.setValue('ASSET_NAME', detailForm.getValue("ASST_NAME"));
						panelResult.setValue('ASSET_NAME', detailForm.getValue("ASST_NAME"));
						UniAppManager.app.onQueryButtonDown();
				 },
				failure: function(form, action) {
                    detailForm.getEl().unmask();
                }	
			});
		},		
		
		setDefault: function() {
			detailForm.setValue('SAVE_FLAG'	, 'N');						//저장flag
			detailForm.setValue('ACQ_Q'		, 1);						//수량
			detailForm.setValue('MONEY_UNIT', BsaCodeInfo.gsMoneyUnit);	//화폐단위
			detailForm.setValue('EXCHG_RATE_O', '1');					//환율:1
			detailForm.setValue('DPR_STS', '1');						//상각상태:정상상각
//			detailForm.setValue('WASTE_SW', 'N');						//매각/폐기여부:미완료
//			detailForm.setValue('DPR_STS2', 'N');						//상각완료여부:미완료
			detailForm.setValue('ACQ_DATE', UniDate.get('today'));		//취득일자
			detailForm.setValue('USE_DATE', UniDate.get('today'));		//사용일자
			detailForm.setValue('DIV_CODE'		, UserInfo.divCode);	//사업장
			detailForm.setValue('UPDATE_DB_USER', UserInfo.userID);		//입력자
			detailForm.setValue('INSERT_DB_USER', UserInfo.userID);		//담당자
			detailForm.setValue('NAME', UserInfo.userName);				//담당자명
			detailForm.getField('NAME').setReadOnly(true);
			detailForm.setValue('PRODUCE_COST'		, 0);				//제조원가비율
			detailForm.setValue('SALE_COST'			, 0);				//영업외비용비율
			detailForm.setValue('STOCK_Q'			, 0);				//재고수량

			detailForm.setValue('AUTO_TYPE', BsaCodeInfo.gsAutoType);	//자동채번 여부		


			detailForm.setValue('DEPT_CODE', UserInfo.deptCode);
			
            if(!Ext.isEmpty(UserInfo.deptCode)){
				if(UserInfo.deptCode == '01') {
					detailForm.getField('DEPT_CODE').setReadOnly(false);
					
				} else {
					detailForm.getField('DEPT_CODE').setReadOnly(true);
				}
				
            } else {
                detailForm.getField('DEPT_CODE').setReadOnly(true);
                //부서정보가 없을 경우, 조회버튼 비활성화
			    UniAppManager.setToolbarButtons('query',false);
            }
            UniAppManager.setToolbarButtons('save'	, false);
			UniAppManager.setToolbarButtons('delete', false);
			UniAppManager.setToolbarButtons('reset'	, true);
		}
	});
 
	Unilite.createValidator('validator03', {
//		store : directMasterStore,
//		grid: masterGrid,
		forms: {'formA:':detailForm},
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {			
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
//			if(newValue == oldValue || validateFlag == "2"){
//				if(fieldName == "DEPT_NAME"){
//					validateFlag = '1';
//				}
//				return true;				
//			}
//			if(detailForm.uniOpt.inLoading) return false;
//			if(validateFlag == "2"){return false;}
			switch(fieldName) {
				case "DRB_YEAR" :		//내용년수
					if(Ext.isEmpty(newValue)) {
						detailForm.setValue('DPR_RATE', '');
						break;
					}
					if(isNaN(newValue)){
						rv = Msg.sMB074;	//숫자만 입력가능합니다.
						break;
					}
					if(newValue < 0 && !Ext.isEmpty(newValue))	{
						rv=Msg.sMB076;	//양수만 입력 가능합니다.
						break;
					}
					if(newValue < 2 || newValue > 60){
						rv= '내용년수는 2~60 사이의 정수만 입력 가능합니다.';
						break;
					}
					var drbYear = '000' + detailForm.getValue('DRB_YEAR') 
					drbYear = drbYear.substring(drbYear.length-3)
				break;
				
				
				case "ACQ_AMT_I" :		//취득가액
					if(isNaN(newValue)){
						rv = Msg.sMB074;	//숫자만 입력가능합니다.
						break;
					}
					if(newValue < 0 && !Ext.isEmpty(newValue))	{
						rv=Msg.sMB076;	//양수만 입력 가능합니다.
						break;
					}
				break;
				
				case "ACQ_Q" :	//취득수량
					detailForm.setValue('STOCK_Q', newValue);
				break;
			}
			return rv;
		} // validator
	});
};

</script>
