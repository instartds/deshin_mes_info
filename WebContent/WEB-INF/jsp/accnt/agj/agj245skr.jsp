<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="agj245skr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->   
	<t:ExtComboStore comboType="AU" comboCode="A011" /> <!-- 입력경로 -->      
	<t:ExtComboStore comboType="AU" comboCode="A014" /> <!-- 승인상태 -->
	<t:ExtComboStore comboType="AU" comboCode="A023" /> <!--결의회계구분-->
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >
var baseInfo = {
    gsChargeDivi    : '${gsChargeDivi}'         // 1:회계부서, 2:현업부서
}
function appMain() {
var gsFocusFlag = false;	
var postitWindow;		// 각주팝업
	/* Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Agj245skrModel1', {
		fields: [
	    	{name: 'AC_DATE'			,text: '회계일' 		,type: 'uniDate'},
	    	{name: 'SLIP_NUM'			,text: '번호' 		,type: 'string'},
	    	{name: 'DR_AMT_I'			,text: '차변금액' 		,type: 'uniPrice'},
	    	{name: 'CR_AMT_I'			,text: '대변금액' 		,type: 'uniPrice'},
	    	{name: 'DIV_CODE'			,text: '사업장코드' 		,type: 'string'},
	    	{name: 'REMARK'				,text: '적요' 		,type: 'string'},
	    	{name: 'INPUT_PATH_NAME'	,text: '입력경로'		,type: 'string'},
	    	{name: 'EX_DATE'			,text: '결의일' 		,type: 'uniDate'},
	    	{name: 'EX_NUM'				,text: '번호' 		,type: 'string'},
	    	{name: 'CHARGE_CODE'		,text: '입력자' 		,type: 'string'},
	    	{name: 'CHARGE_NAME'		,text: '입력자' 		,type: 'string'},
	    	{name: 'INPUT_DATE'			,text: '입력일' 		,type: 'uniDate'},
	    	{name: 'AP_CHARGE_NAME'		,text: '승인자' 		,type: 'string'},
	    	{name: 'AP_DATE'			,text: '승인일' 		,type: 'uniDate'},
	    	{name: 'MOD_DIVI'			,text: '수정이력' 		,type: 'string'},
	    	{name: 'INPUT_DIVI'			,text: 'INPUT_DIVI' ,type: 'string'},
	    	{name: 'POSTIT_YN'			,text: 'POSTIT_YN'	,type: 'string'},
	    	{name: 'GUBUN'				,text: 'GUBUN' 		,type: 'string'},
	    	{name: 'SLIP_TYPE'			,text: '전표구분' ,type: 'string'}	,
	    	{name: 'AP_STS'			,text: '승인여부' ,type: 'string'}	     		  
		]
	});
	
	Unilite.defineModel('Agj245skrModel2', {
		fields: [
			{name: 'AC_DATE'		,text: '회계일' 			,type: 'uniDate'},
	    	{name: 'EX_SEQ'			,text: '순번' 			,type: 'string'},
	    	{name: 'SLIP_DIVI_NM'	,text: '구분' 			,type: 'string'},
	    	{name: 'ACCNT'			,text: '계정코드' 			,type: 'string'},
	    	{name: 'ACCNT_NAME'		,text: '계정과목명' 			,type: 'string'},
	    	{name: 'CUSTOM_CODE'	,text: '거래처' 			,type: 'string'},
	    	{name: 'CUSTOM_NAME'	,text: '거래처명' 			,type: 'string'},
	    	{name: 'AMT_I'			,text: '금액' 			,type: 'uniPrice'},
	    	{name: 'MONEY_UNIT'		,text: '화폐' 			,type: 'string'},
	    	{name: 'EXCHG_RATE_O'	,text: '환율' 			,type: 'uniER'},
	    	{name: 'FOR_AMT_I'		,text: '외화금액' 			,type: 'uniFC'},
	    	{name: 'REMARK'			,text: '적요' 			,type: 'string'},
	    	{name: 'DEPT_NAME'		,text: '귀속부서' 			,type: 'string'},
	    	{name: 'DIV_NAME'		,text: '귀속사업장' 			,type: 'string'},
	    	{name: 'PROOF_KIND_NM'	,text: '증빙유형' 			,type: 'string'},
	    	{name: 'CREDIT_NUM'		,text: '카드번호/현금영수증'	,type: 'string'},
	    	{name: 'CREDIT_NUM_EXPOS'   , text: '신용카드/현금영수증번호'  ,type: 'string', defaultValue:'***************'}, 
	    	{name: 'INPUT_PATH'		,text: '입력경로' 			,type: 'string'},
	    	{name: 'REASON_CODE'	,text: '불공제사유' 			,type: 'string'},  	    		  
	    	{name: 'AC_CODE1'		,text: 'AC_CODE1' 		,type: 'string'},
	    	{name: 'AC_NAME1'		,text: 'AC_NAME1' 		,type: 'string'},
	    	{name: 'AC_DATA1'		,text: 'AC_DATA1' 		,type: 'string'},
	    	{name: 'AC_DATA_NAME1'	,text: 'AC_DATA_NAME1' 	,type: 'string'},
	    	{name: 'AC_TYPE1'		,text: 'AC_TYPE1' 		,type: 'string'},
	    	{name: 'AC_FORMAT1'		,text: 'AC_FORMAT1' 	,type: 'string'},
	    	
	    	{name: 'POSTIT_YN'		,text: 'POSTIT_YN' 		,type: 'string'},
	    	{name: 'POSTIT'			,text: 'POSTIT' 		,type: 'string'},  	    		  
	    	{name: 'POSTIT_USER_ID'	,text: 'POSTIT_USER_ID' ,type: 'string'},
	    	{name: 'AUTO_NUM'		,text: 'AUTO_NUM' 		,type: 'string'},
	    	{name: 'AC_CODE2'		,text: 'AC_CODE2' 		,type: 'string'},
	    	{name: 'AC_CODE3'		,text: 'AC_CODE3' 		,type: 'string'},
	    	{name: 'AC_CODE4'		,text: 'AC_CODE4' 		,type: 'string'},
	    	{name: 'AC_CODE5'		,text: 'AC_CODE5' 		,type: 'string'},
	    	{name: 'AC_CODE6'		,text: 'AC_CODE6' 		,type: 'string'},
	    	{name: 'AC_NAME2'		,text: 'AC_NAME2' 		,type: 'string'},  	    		  
	    	{name: 'AC_NAME3'		,text: 'AC_NAME3' 		,type: 'string'},
	    	{name: 'AC_NAME4'		,text: 'AC_NAME4' 		,type: 'string'},
	    	{name: 'AC_NAME5'		,text: 'AC_NAME5' 		,type: 'string'},
	    	{name: 'AC_NAME6'		,text: 'AC_NAME6' 		,type: 'string'},
	    	{name: 'AC_DATA2'		,text: 'AC_DATA2' 		,type: 'string'},
	    	{name: 'AC_DATA3'		,text: 'AC_DATA3' 		,type: 'string'},
	    	{name: 'AC_DATA4'		,text: 'AC_DATA4' 		,type: 'string'},
	    	{name: 'AC_DATA5'		,text: 'AC_DATA5' 		,type: 'string'},  	    		  
	    	{name: 'AC_DATA6'		,text: 'AC_DATA6' 		,type: 'string'},
	    	{name: 'AC_DATA_NAME2'	,text: 'AC_DATA_NAME2' 	,type: 'string'},
	    	{name: 'AC_DATA_NAME3'	,text: 'AC_DATA_NAME3' 	,type: 'string'},
	    	{name: 'AC_DATA_NAME4'	,text: 'AC_DATA_NAME4' 	,type: 'string'},
	    	{name: 'AC_DATA_NAME5'	,text: 'AC_DATA_NAME5' 	,type: 'string'},
	    	{name: 'AC_DATA_NAME6'	,text: 'AC_DATA_NAME6' 	,type: 'string'},
	    	{name: 'AC_TYPE2'		,text: 'AC_TYPE2' 		,type: 'string'},
	    	{name: 'AC_TYPE3'		,text: 'AC_TYPE3' 		,type: 'string'},  	    		  
	    	{name: 'AC_TYPE4'		,text: 'AC_TYPE4' 		,type: 'string'},
	    	{name: 'AC_TYPE5'		,text: 'AC_TYPE5' 		,type: 'string'},
	    	{name: 'AC_TYPE6'		,text: 'AC_TYPE6' 		,type: 'string'},
	    	{name: 'AC_FORMAT2'		,text: 'AC_FORMAT2' 	,type: 'string'},
	    	{name: 'AC_FORMAT3'		,text: 'AC_FORMAT3' 	,type: 'string'},
	    	{name: 'AC_FORMAT4'		,text: 'AC_FORMAT4' 	,type: 'string'},
	    	{name: 'AC_FORMAT5'		,text: 'AC_FORMAT5' 	,type: 'string'},
	    	{name: 'AC_FORMAT6'		,text: 'AC_FORMAT6' 	,type: 'string'},	    		  
	    	{name: 'AC_POPUP1' 		,text:'관리항목1팝업여부'		,type : 'string'}, 
			{name: 'AC_POPUP2'   	,text:'관리항목2팝업여부'		,type : 'string'},
			{name: 'AC_POPUP3'   	,text:'관리항목3팝업여부'		,type : 'string'}, 
			{name: 'AC_POPUP4'   	,text:'관리항목4팝업여부'		,type : 'string'}, 
			{name: 'AC_POPUP5'   	,text:'관리항목5팝업여부'		,type : 'string'}, 
			{name: 'AC_POPUP6'   	,text:'관리항목6팝업여부'		,type : 'string'}, 

			{name: 'AP_DATE'		,text:'AP_DATE'			,type: 'string' },
			{name: 'AC_DATE_MASTER'	,text:'AC_DATE_MASTER'	,type: 'string' },
			{name: 'SLIP_NUM_MASTER',text:'SLIP_NUM_MASTER'	,type: 'string' },
			{name: 'EX_NUM_MASTER'	,text:'EX_NUM_MASTER'	,type: 'string'},
			{name: 'INPUT_PATH_MASTER',text:'INPUT_PATH_MASTER',type: 'string'}
		]
	});			

	/* Store 정의(Service 정의)
	 * @type 
	 */					
	var masterStore = Unilite.createStore('agj245skrDetailStore',{
		model: 'Agj245skrModel1',
		uniOpt : {
        	isMaster	:	true,			// 상위 버튼 연결 
        	editable	:	false,			// 수정 모드 사용 
        	deletable	:	false,			// 삭제 가능 여부 
            useNavi		:	false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
            type: 'direct',
            api: {			
            	   read: 'agj245skrService.selectList'                	
            }
        },
        loadStoreRecords : function()	{
			var form = Ext.getCmp('searchForm');
			var param= form.getValues();			
			console.log( param );
			if(form.isValid())	{
				detailForm.down('#formFieldArea1').removeAll();
				detailGrid.reset();
				this.load({
					params : param
				});
			}
		},
		listeners: {
          	load: function(store, records, successful, eOpts) {
				//조회된 데이터가 있을 때, 합계 보이게 설정 변경
				var viewNormal = masterGrid.getView();
				if(store.getCount() > 0){
		    		viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
				}else{
		    		viewNormal.getFeature('masterGridTotal').toggleSummaryRow(false);	
				}
          	}          		
      	}
//			groupField: 'CUSTOM_NAME'
	});
	
	var DetailStore = Unilite.createStore('agj245skrDetailStore',{
			model: 'Agj245skrModel2',
			uniOpt : {
            	isMaster	:	false,			// 상위 버튼 연결 
            	editable	:	false,			// 수정 모드 사용 
            	deletable	:	false,			// 삭제 가능 여부 
	            useNavi 	:	false			// prev | newxt 버튼 사용
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {			
                	   read: 'agj245skrService.selectList2'                	
                }
            },
            loadStoreRecords : function()	{
				var param= Ext.getCmp('searchForm').getValues();			
				console.log( param );
				this.load({
					params : param
				});
			},
			listeners:{
				beforeload:function(store, operation, eOpts)	{
					if (masterGrid.getSelectedRecords() == 0)	{
						return false;
					}
				},
				load: function(store, records, successful, eOpts) {
					if(!Ext.isEmpty(detailGrid.getSelectionModel())) {
						detailGrid.getSelectionModel().select(0);	
					}
					masterGrid.focus();
	          	}
			} 
//			groupField: 'CUSTOM_NAME'
	});	
	
	/* 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '검색조건',
        defaultType: 'uniSearchSubPanel',
        collapsed:true,
        listeners: {
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
		    items : [{ 
    			fieldLabel: '전표일',
		        xtype: 'uniDateRangefield',
		        startFieldName: 'AC_DATE_FR',
		        endFieldName: 'AC_DATE_TO',
		        width: 470,
		        startDate: UniDate.get('today'),
		        endDate: UniDate.get('today'),
		        allowBlank: false,
		        colspan: 2, 
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
						panelResult.setValue('AC_DATE_FR',newValue);
			    	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('AC_DATE_TO',newValue);
			    	}
			    }
	        }, { 
    			fieldLabel: '입력일',
		        xtype: 'uniDateRangefield',
		        startFieldName: 'INPUT_DATE_FR',
		        endFieldName: 'INPUT_DATE_TO',
		        width: 470,
		        startDate: UniDate.get(''),
		        endDate: UniDate.get(''),
		        colspan: 2, 
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
							panelResult.setValue('INPUT_DATE_FR',newValue);
	                	}
				    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('INPUT_DATE_TO',newValue);
			    	}
			    }
	        },{
		        fieldLabel: '사업장',
			    name:'DIV_CODE', 
			    xtype: 'uniCombobox',
				multiSelect: true, 
				typeAhead: false,
				value:UserInfo.divCode,
				comboType:'BOR120',
			    width: 325,
			    colspan:2,
			    listeners: {
					change: function(field, newValue, oldValue, eOpts) {      
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
		    },   
	        	Unilite.popup('DEPT',{
		        fieldLabel: '입력부서',
		        validateBlank:true,
		        autoPopup:true,
			    valueFieldName:'IN_DEPT_CODE',
			    textFieldName:'IN_DEPT_NAME',
		        colspan: 2, 
	        	listeners: {
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('IN_DEPT_CODE', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('IN_DEPT_NAME', newValue);				
					},
					applyextparam: function(popup){							
						popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					}
				}
		    }),
	        	//CUST 팝업 오류로 임시로 BCM100t [RETURN_CODE]컬럼 추가(추후 확인)
	        	Unilite.popup('CUST',{
		        fieldLabel: '거래처',
		        allowBlank:true,
				autoPopup:false,
				validateBlank:false,
			    valueFieldName:'CUSTOM_CODE',
			    textFieldName:'CUSTOM_NAME',
				extParam: {'CUSTOM_TYPE': ['1','2','3']},
		        colspan: 2, 
				listeners: {
					onValueFieldChange: function(field, newValue, oldValue){
						panelResult.setValue('CUSTOM_CODE', newValue);
						
						if(!Ext.isObject(oldValue)) {
							panelResult.setValue('CUSTOM_NAME', '');
							panelSearch.setValue('CUSTOM_NAME', '');
						}
					},
					onTextFieldChange: function(field, newValue, oldValue){
						panelResult.setValue('CUSTOM_NAME', newValue);
						
						if(!Ext.isObject(oldValue)) {
							panelResult.setValue('CUSTOM_CODE', '');
							panelSearch.setValue('CUSTOM_CODE', '');
						}
					},
					applyextparam: function(popup){							
						popup.setExtParam({'ACCNT_DIV_CODE': panelSearch.getValue('ACCNT_DIV_CODE')});
					}
				}		        
		    }),{
				xtype: 'container',
				layout: {type: 'uniTable', column: 2},
				items: [{
					fieldLabel: '전표구분',
					xtype: 'uniCombobox',
					name: 'SLIP_DIVI',
					comboType: 'AU',
					comboCode:'A023',
					width: 172,
		        	allowBlank: false,
		        	value: '1',
		        	listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('SLIP_DIVI', newValue);
						}
					}
				}, {
					fieldLabel: '승인여부',
					xtype: 'uniCombobox',
					name: 'AP_STS',
					comboType: 'AU',
					comboCode:'A014',
					labelWidth: 70,
					width: 153,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('AP_STS', newValue);
						}
					}
				}]
		    },	
		    	Unilite.popup('ACCNT',{
			    	fieldLabel: '계정과목',
			    	validateBlank:true,
		        	autoPopup:true,
			    	valueFieldName: 'ACCNT',
			    	textFieldName: 'ACCNT_NAME'
		    }),{
    			fieldLabel: '입력경로'	,
    			name:'INPUT_PATH', 
    			xtype: 'uniCombobox', 
    			comboType:'AU',
    			comboCode:'A011',
    			width:325
    		},{
			    xtype: 'container',
				layout: {type : 'uniTable', columns : 3},
				width:325,
				items :[{
					fieldLabel:'회계번호', 
					xtype: 'uniTextfield',
					name: 'SLIP_NUM_FR', 
					width:203
				},{
					xtype:'component', 
					html:'~',
					style: {
						marginTop: '3px !important',
						font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
					}
				},{
					fieldLabel:'', 
					xtype: 'uniTextfield',
					name: 'SLIP_NUM_TO', 
					width: 112
				}]
			}]
		}, {	
			title: '추가정보', 	
   			itemId: 'search_panel2',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items : [{
				fieldLabel: '조건',
				name: 'CHECK',
				xtype: 'checkboxgroup', 
				width: 400, 
				items: [{
		        	boxLabel: '수정삭제이력표시',
		        	name: 'INCLUDE_DELETE',
		        	uncheckedValue: 'N',
	        		inputValue: 'Y'
		        },{
		        	boxLabel: '각주',
		        	name: 'POSTIT_YN',
		        	uncheckedValue: 'N',
	        		inputValue: 'Y',
	        		listeners: {
       				 	change: function(field, newValue, oldValue, eOpts) {
       				 		if(panelSearch.getValue('POSTIT_YN')) {
								panelSearch.getField('POSTIT').setReadOnly(false);
       				 		} else {
								panelSearch.getField('POSTIT').setReadOnly(true);
       				 		}
						}
		        	}
				}]
			}, {
		    	xtype: 'uniTextfield',
		    	fieldLabel: '각주',
		    	width: 325,
		    	readOnly: true,
		    	name:'POSTIT'
		    }, {
			    xtype: 'container',
				layout: {type : 'uniTable', columns : 3},
				width:325,
				items :[{
					fieldLabel:'결의번호', 
					xtype: 'uniTextfield',
					name: 'EX_NUM_FR', 
					width:203
				},{
					xtype:'component', 
					html:'~',
					style: {
						marginTop: '3px !important',
						font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
					}
				},{
					fieldLabel:'', 
					xtype: 'uniTextfield',
					name: 'EX_NUM_TO', 
					width: 112
				}]
			}, {
			    xtype: 'container',
				layout: {type : 'uniTable', columns : 3},
				width:325,
				items :[{
					fieldLabel:'금액', 
					xtype: 'uniTextfield',
					name: 'AMT_I_FR', 
					width:203
				},{
					xtype:'component', 
					html:'~',
					style: {
						marginTop: '3px !important',
						font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
					}
				},{
					fieldLabel:'', 
					xtype: 'uniTextfield',
					name: 'AMT_I_TO', 
					width: 112
				}]
			}, {
			    xtype: 'container',
				layout: {type : 'uniTable', columns : 3},
				width:325,
				items :[{
					fieldLabel:'외화금액', 
					xtype: 'uniTextfield',
					name: 'FOR_AMT_I_FR', 
					width:203
				},{
					xtype:'component', 
					html:'~',
					style: {
						marginTop: '3px !important',
						font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
					}
				},{
					fieldLabel:'', 
					xtype: 'uniTextfield',
					name: 'FOR_AMT_I_TO', 
					width: 112
				}]
			},{
                xtype: 'uniTextfield',
                name: 'REMARK',
                fieldLabel: '적요',
                width: 325
            },
		    	Unilite.popup('ACCNT_PRSN',{
		    	fieldLabel: '입력자',
		    	validateBlank:true,
		        autoPopup:true,
		    	valueFieldName:'CHARGE_CODE',
			    textFieldName:'CHARGE_NAME'
		    }),		    
	        	Unilite.popup('DEPT',{
		        fieldLabel: '귀속부서',
		        validateBlank:true,
		        autoPopup:true,
			    valueFieldName:'DEPT_CODE',
			    textFieldName:'DEPT_NAME'
		    }),{
				fieldLabel: ' ',
				name: '',
				xtype: 'checkboxgroup', 
				width: 400, 
				items: [{
		        	boxLabel: '하위부서포함',
		        	name: 'INCLUD_YN',
		        	uncheckedValue: 'N',
	        		inputValue: 'Y'
		        }]
			}, {
		    	xtype: 'uniDatefield',
		    	fieldLabel: 'AC_DATE_마스터그리드',
		    	width: 325,
		    	editable: false,
		    	hidden: true,
		    	name:'AC_DATE_MASTER'
		    }, {
		    	xtype: 'uniTextfield',
		    	fieldLabel: 'SLIP_NUM_마스터그리드',
		    	width: 325,
		    	hidden: true,
		    	editable: false,
		    	name:'SLIP_NUM_MASTER'
		    }, {
		    	xtype: 'uniTextfield',
		    	fieldLabel: 'EX_NUM_마스터그리드',
		    	width: 325,
		    	hidden: true,
		    	editable: false,
		    	name:'EX_NUM_MASTER'
		    }, {
		    	xtype: 'uniTextfield',
		    	fieldLabel: 'AP_DATE_마스터그리드',
		    	width: 325,
		    	hidden: true,
		    	editable: false,
		    	name:'AP_DATE'
		    }, {
		    	xtype: 'uniTextfield',
		    	fieldLabel: '입력경로_마스터그리드',
		    	width: 325,
		    	hidden: true,
		    	editable: false,
		    	name:'INPUT_PATH_MASTER'
		    }]		
		}]
	}); 
	
	var panelResult = Unilite.createSearchForm('panelResultForm', {		
		region: 'north',
		layout : {type : 'uniTable', columns : 3
//		,tableAttrs: {style: 'border : 1px solid #ced9e7;'/*, width: '100%'*/},
//			tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
		},
		padding:'1 1 1 1',
		border:true,
		items : [{ 
			fieldLabel: '전표일',
	        xtype: 'uniDateRangefield',
	        startFieldName: 'AC_DATE_FR',
	        endFieldName: 'AC_DATE_TO',
	        //width: 470,
	        startDate: UniDate.get('today'),
	        endDate: UniDate.get('today'),
	        allowBlank: false,
	        tdAttrs: {width: 380},  
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
					panelSearch.setValue('AC_DATE_FR',newValue);
		    	}
		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('AC_DATE_TO',newValue);
		    	}
		    }
        },   
        	Unilite.popup('DEPT',{
	        fieldLabel: '입력부서',
	        validateBlank:true,
		    autoPopup:true,
		    valueFieldName:'IN_DEPT_CODE',
		    textFieldName:'IN_DEPT_NAME',
	        tdAttrs: {width: 380},  
        	listeners: {
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('IN_DEPT_CODE', newValue);								
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('IN_DEPT_NAME', newValue);				
				},
				applyextparam: function(popup){							
					popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
				}
			}
	    }),{
	        fieldLabel: '사업장',
		    name:'DIV_CODE', 
		    xtype: 'uniCombobox',
			multiSelect: true, 
			typeAhead: false,
			value:UserInfo.divCode,
			comboType:'BOR120',
		    width: 325,
		    listeners: {
				change: function(field, newValue, oldValue, eOpts) {      
				panelSearch.setValue('DIV_CODE', newValue);
				}
     		}
		}, { 
			fieldLabel: '입력일',
	        xtype: 'uniDateRangefield',
	        startFieldName: 'INPUT_DATE_FR',
	        endFieldName: 'INPUT_DATE_TO',
	        //width: 470,
	        startDate: UniDate.get(''),
	        endDate: UniDate.get(''),
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelSearch) {
						panelSearch.setValue('INPUT_DATE_FR',newValue);
                	}
			    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('INPUT_DATE_TO',newValue);
		    	}
		    }
        },
        	//CUST 팝업 오류로 임시로 BCM100t [RETURN_CODE]컬럼 추가(추후 확인)
        	Unilite.popup('CUST',{
	        fieldLabel: '거래처',
	        allowBlank:true,
			autoPopup:false,
			validateBlank:false,
	        /*extParam:{'CUSTOM_TYPE':'3'}*/
		    valueFieldName:'CUSTOM_CODE',
		    textFieldName:'CUSTOM_NAME',
			extParam: {'CUSTOM_TYPE': ['1','2','3']},
        	listeners: {
				onValueFieldChange:function( elm, newValue, oldValue) {						
					panelSearch.setValue('CUSTOM_CODE', newValue);
					
					if(!Ext.isObject(oldValue)) {
						panelResult.setValue('CUSTOM_NAME', '');
						panelSearch.setValue('CUSTOM_NAME', '');
					}
				},
				onTextFieldChange:function( elm, newValue, oldValue) {
					panelSearch.setValue('CUSTOM_NAME', newValue);
					
					if(!Ext.isObject(oldValue)) {
						panelResult.setValue('CUSTOM_CODE', '');
						panelSearch.setValue('CUSTOM_CODE', '');
					}
				},		
				applyextparam: function(popup){							
					popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
				}
			}		        
	    }),{
			xtype: 'container',
			layout: {type: 'uniTable', column: 2},
			items: [{
				fieldLabel: '전표구분',
				xtype: 'uniCombobox',
				name: 'SLIP_DIVI',
				comboType: 'AU',
				comboCode:'A023',
				width: 172,
	        	allowBlank: false,
	        	value: '1',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('SLIP_DIVI', newValue);
	                    if(newValue == '1'){
	                        masterGrid.getColumn('AC_DATE').setText('회계일');
	                        masterGrid.getColumn('EX_DATE').setText('결의일');
	                    }
	                    if(newValue == '2'){
	                        masterGrid.getColumn('AC_DATE').setText('결의일');
	                        masterGrid.getColumn('EX_DATE').setText('회계일');
	                    }
                    
					}
				}
			}, {
				fieldLabel: '승인여부',
				xtype: 'uniCombobox',
				name: 'AP_STS',
				comboType: 'AU',
				comboCode:'A014',
				labelWidth: 70,
				width: 152,
				listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('AP_STS', newValue);
					}
				}
			}]
	    },
        Unilite.popup('ACCNT',{
	    	fieldLabel: '계정과목',
	    	validateBlank:true,
		    autoPopup:true,
	    	valueFieldName: 'ACCNT',
	    	textFieldName: 'ACCNT_NAME',
            listeners: {
                onValueFieldChange: function(field, newValue){
                    panelSearch.setValue('ACCNT', newValue);                              
                },
                onTextFieldChange: function(field, newValue){
                    panelSearch.setValue('ACCNT_NAME', newValue);              
                }
            }		    	
	    }), {
			fieldLabel: '입력경로',
			name:'INPUT_PATH', 
			xtype: 'uniCombobox', 
			comboType:'AU',
			comboCode:'A011',
			width:325,
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {                        
                    panelSearch.setValue('INPUT_PATH', newValue);
                }
            }    			
		},{
		    xtype: 'container',
			layout: {type : 'uniTable', columns : 3},
			width:325,
			items :[{
				fieldLabel:'회계번호', 
				xtype: 'uniTextfield',
				name: 'SLIP_NUM_FR', 
				width:203,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('SLIP_NUM_FR', newValue);
					}
				}					
			},{
				xtype:'component', 
				html:'~',
				style: {
					marginTop: '3px !important',
					font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
				}
			},{
				fieldLabel:'', 
				xtype: 'uniTextfield',
				name: 'SLIP_NUM_TO', 
				width: 112,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('SLIP_NUM_TO', newValue);
					}
				}						
			}]        
		}]
	});    
    
	/* Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('agj245skrGrid', {
        layout : 'fit',
        region:'center',
//        flex: 0.65,
//        minHeight :100,
        flex: 3,
    	store: masterStore,
        selModel: 'rowmodel',		// 조회화면 selectionchange event 사용
    	uniOpt:{						
			useMultipleSorting	: true,			
		    useLiveSearch		: true,			
		    onLoadSelectFirst	: true,				
		    dblClickToEdit		: false,			
		    useGroupSummary		: true,			
			useContextMenu		: false,		
			useRowNumberer		: true,		
			expandLastColumn	: true,			
			useRowContext		: true,		
		    filter: {					
				useFilter		: false,	
				autoCreate		: false	
			}						
        },
    	features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
        columns:  [ 
	   		{ dataIndex:'AC_DATE'		 	, 		width:100,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
				       return Unilite.renderSummaryRow(summaryData, metaData, '합계', '합계');
		    	}
	   		}, 				
			{ dataIndex:'SLIP_NUM'			, 		width:50, 	align: 'center'},
			{ dataIndex:'DR_AMT_I'		 	, 		width:120,	summaryType: 'sum'}, 				
			{ dataIndex:'CR_AMT_I'		 	, 		width:120,	summaryType: 'sum'}, 				
/*			{ dataIndex:'DIV_CODE'			, 		width:66,	hidden:true},*/
			{ dataIndex:'REMARK'			, 		width:333//,
			/*  각주 추가 시 AUTO_NUM이 달라서 메인그리드에 차/대 구분되어서 출력 됨(UNILITE에서도 오류 발생)
				renderer:function(value, metaData, record)	{
					var r = value;
					if(record.get('POSTIT_YN') == 'Y') r ='<img src="'+CPATH+'/resources/images/PostIt.gif"/>'+value
					return r;
				}*/
			},
			{ dataIndex:'INPUT_PATH_NAME'	, 		width:140},
			{ dataIndex:'EX_DATE'			, 		width:100},
			{ dataIndex:'EX_NUM'			, 		width:46, 	align: 'center'},
			{ dataIndex:'CHARGE_NAME'		, 		width:80, 	align: 'center'},
			{ dataIndex:'INPUT_DATE'		, 		width:100},
			{ dataIndex:'AP_CHARGE_NAME'	, 		width:80, 	align: 'center'},
			{ dataIndex:'AP_DATE'			, 		width:100}
//			{ dataIndex:'MOD_DIVI'			, 		width:66,	hidden:true},
			//{ dataIndex:'GUBUN'				, 		width:66,	hidden:true},
			//{ dataIndex:'INPUT_DIVI'		, 		width:66,	hidden:true},
//			{ dataIndex:'SLIP_TYPE'			, 		width:66,	hidden:true},
//			{ dataIndex:'AP_STS'			, 		width:66,	hidden:true}
			//{ dataIndex:'POSTIT_YN'			, 		width:66,	hidden:true}
        ], 
        listeners: {
			selectionchange:function( model1, selected, eOpts ){
       			if(selected.length > 0)	{
	        		var record = selected[0];
	        		this.returnCell(record);  
	        		DetailStore.loadData({})
					DetailStore.loadStoreRecords(record);
       			}
          	},
	      	itemmouseenter:function(view, record, item, index, e, eOpts )	{          		
//	        	view.ownerGrid.setCellPointer(view, item);
    		},
    		render:function(grid, eOpt)	{
    			grid.getEl().on('click', function(e, t, eOpt) {
			    	activeGrid = grid.getItemId();
			    });
//			    var b = isTbar;
			    var i=0;
//			    if(b)	{
//			    	i=0;
//			    }
    			var tbar = grid._getToolBar();
    			tbar[0].insert(i++,{
		        	xtype: 'uniBaseButton',
		        	iconCls: 'icon-postit',
		        	width: 26, height: 26,
		        	tooltip:'각주',
		        	handler:function()	{
		        		openPostIt(grid);
		        	}
		        });
    		},
        	onGridDblClick :function( grid, record, cellIndex, colName ) {
				var modDivi		= record.data['MOD_DIVI'];
				var slipType	= record.data['SLIP_TYPE'];
				var inputDivi	= record.data['INPUT_DIVI'];
				var inputPath	= record.data['INPUT_PATH'];
				var apSts		= record.data['AP_STS'];
	
				if (Ext.isEmpty(modDivi)){	//수정삭제여부  빈값이 정상
					if (slipType == '1'){	//회계전표일떄
						if(inputDivi == '2' ){		//번호별 회계전표 화면 관련
							masterGrid.gotoAgj205ukr();
						} else {	//일반 회계전표 화면 관련
							masterGrid.gotoAgj200ukr();
						}
					} else {		//결의전표일때
						if(apSts == '2'){		//  승인
							if(inputDivi == '2' ){			//번호별 회계전표 화면 관련
								masterGrid.gotoAgj205ukr();
							} else if (inputDivi == '3'){	//INPUT_DIVI가 '3'일 경우 결의미결반제입력으로 이동
	            				masterGrid.gotoAgj110ukr();
							} else {						//일반 회계전표 화면 관련
								masterGrid.gotoAgj200ukr();
							}
						} else {			//	미승인
							if(inputDivi == '2' ){			//번호별 결의전표 화면 관련
								masterGrid.gotoAgj105ukr();
							} else if (inputDivi == '3'){	//INPUT_DIVI가 '3'일 경우 결의미결반제입력으로 이동
	            				masterGrid.gotoAgj110ukr();
							} else {						//일반 결의전표 화면 관련
								masterGrid.gotoAgj100ukr();
							}
						}
					}
				}
			}
	  		
		},
		gotoAgj100ukr:function()	{
    		var record = masterGrid.getSelectedRecord();
    		var param = {
    			'PGM_ID'			: 'agj245skr',
				'AC_DATE_FR'		: record.data['AC_DATE'],
				'AC_DATE_TO'		: record.data['AC_DATE'],
				
				'INPUT_PATH'		: record.data['INPUT_PATH'],
				'SLIP_NUM'			: record.data['EX_NUM'],
				'EX_NUM'			: record.data['SLIP_NUM'],
			
				'AP_STS'			: record.data['AP_STS'],
				'CHARGE_CODE'		: record.data['CHARGE_CODE'],
				'CHARGE_NAME'		: record.data['CHARGE_NAME'],
				'DEPT_CODE'			: record.data['DEPT_CODE'],
				'DEPT_NAME'			: record.data['DEPT_NAME'],
				'ACCNT_DIV_CODE'	: panelSearch.getValue('ACCNT_DIV_CODE')
    		};
	  		var rec1 = {data : {prgID : 'agj100ukr', 'text':''}};							
			parent.openTab(rec1, '/accnt/agj100ukr.do', param);
    	},
		gotoAgj105ukr:function()	{
    		var record = masterGrid.getSelectedRecord();
    		var param = {
    			'PGM_ID'			: 'agj245skr',
				'AC_DATE'		: record.data['AC_DATE'],
				'EX_NUM'			: record.data['SLIP_NUM'],
				'INPUT_PATH'		: record.data['INPUT_PATH'],
				'AP_STS'			: record.data['AP_STS'],
				'CHARGE_CODE'		: record.data['CHARGE_CODE']
    		};
    		
	  		var rec1 = {data : {prgID : 'agj105ukr', 'text':''}};							
			parent.openTab(rec1, '/accnt/agj105ukr.do', param);
    	},
		gotoAgj110ukr:function()	{
    		var record = masterGrid.getSelectedRecord();
    		var param = {
    			'PGM_ID'			: 'agj245skr',
				'AC_DATE_FR'		: record.data['AC_DATE'],
				'AC_DATE_TO'		: record.data['AC_DATE'],
				'EX_DATE_FR'		: record.data['EX_DATE'],
				'EX_DATE_TO'		: record.data['EX_DATE'],
				'INPUT_PATH'		: record.data['INPUT_PATH'],
				'SLIP_NUM'			: record.data['SLIP_NUM'],
				'EX_NUM'			: record.data['SLIP_NUM'],
				'SLIP_SEQ'			: record.data['SLIP_SEQ'],
				'AP_STS'			: panelSearch.getValue('AP_STS'),
				'CHARGE_CODE'		: record.data['CHARGE_CODE'],
				'CHARGE_NAME'		: record.data['CHARGE_NAME'],
				'DEPT_CODE'			: record.data['DEPT_CODE'],
				'DEPT_NAME'			: record.data['DEPT_NAME'],
				'DIV_CODE'			: panelSearch.getValue('ACCNT_DIV_CODE'),
				'SLIP_DIVI'			: panelSearch.getValue('ACCNT_DIV_CODE')
    		};
	  		var rec1 = {data : {prgID : 'agj110ukr', 'text':''}};							
			parent.openTab(rec1, '/accnt/agj110ukr.do', param);
    	},    	
		gotoAgj200ukr:function()	{
    		var record = masterGrid.getSelectedRecord();
    		if(record.data['SLIP_TYPE'] == '1'){
    			var param = {
	    			'PGM_ID'			: 'agj245skr',
					'AC_DATE_FR'		: record.data['AC_DATE'],
					'AC_DATE_TO'		: record.data['AC_DATE'],
					'EX_DATE_FR'		: record.data['EX_DATE'],
					'EX_DATE_TO'		: record.data['EX_DATE'],
					'INPUT_PATH'		: record.data['INPUT_PATH'],
					'SLIP_NUM'			: record.data['SLIP_NUM'],
//					'EX_NUM'			: record.data['EX_NUM'],
					'CHARGE_CODE'		: record.data['CHARGE_CODE'],
					'CHARGE_NAME'		: record.data['CHARGE_NAME'],
					'SLIP_TYPE'			: record.data['SLIP_TYPE']
	    		};
    		}else{
	    		var param = {
	    			'PGM_ID'			: 'agj245skr',
					'AC_DATE_FR'		: record.data['EX_DATE'],
					'AC_DATE_TO'		: record.data['EX_DATE'],
					'EX_DATE_FR'		: record.data['AC_DATE'],
					'EX_DATE_TO'		: record.data['AC_DATE'],
					'INPUT_PATH'		: record.data['INPUT_PATH'],
					'SLIP_NUM'			: record.data['EX_NUM'],
//					'EX_NUM'			: record.data['SLIP_NUM'],
					'CHARGE_CODE'		: record.data['CHARGE_CODE'],
					'CHARGE_NAME'		: record.data['CHARGE_NAME'],
					'SLIP_TYPE'			: record.data['SLIP_TYPE']
	    		};
    		}
	  		var rec1 = {data : {prgID : 'agj200ukr', 'text':''}};							
			parent.openTab(rec1, '/accnt/agj200ukr.do', param);
    	},
		gotoAgj205ukr:function()	{
    		var record = masterGrid.getSelectedRecord();
    		
    		if(record.data['SLIP_TYPE'] == '1'){
	    		var param = {
	    			'PGM_ID'			: 'agj245skr',
					'AC_DATE'		: record.data['AC_DATE'],
					'SLIP_NUM'			: record.data['SLIP_NUM'],
					'INPUT_PATH'		: record.data['INPUT_PATH'],
					'AP_STS'			: record.data['AP_STS'],
					'CHARGE_CODE'		: record.data['CHARGE_CODE']
	    		};
    		
    		}else{
	    		var param = {
	    			'PGM_ID'			: 'agj245skr',
					'AC_DATE'		: record.data['EX_DATE'],
					'SLIP_NUM'			: record.data['EX_NUM'],
					'INPUT_PATH'		: record.data['INPUT_PATH'],
					'AP_STS'			: record.data['AP_STS'],
					'CHARGE_CODE'		: record.data['CHARGE_CODE']
	    		};
    		}
	  		var rec1 = {data : {prgID : 'agj205ukr', 'text':''}};							
			parent.openTab(rec1, '/accnt/agj205ukr.do', param);
    	},
		returnCell: function(record){
        	var AC_DATE			= record.get("AC_DATE");
        	var SLIP_NUM		= record.get("SLIP_NUM");
        	var EX_NUM			= record.get("EX_NUM");
        	var AP_DATE			= record.get("AP_DATE");
        	var INPUT_PATH		= record.get("INPUT_PATH");
			panelSearch.setValues({'AC_DATE_MASTER':AC_DATE});
            panelSearch.setValues({'SLIP_NUM_MASTER':SLIP_NUM});
            panelSearch.setValues({'EX_NUM_MASTER':EX_NUM});
            panelSearch.setValues({'AP_DATE':AP_DATE});
            panelSearch.setValues({'INPUT_PATH_MASTER':INPUT_PATH});
		}        
	});
    
    var detailGrid = Unilite.createGrid('agj245skrGrid2', {
    	// for tab    	
    	uniOpt:{
			useMultipleSorting	: true,			 
	    	useLiveSearch		: false,			
	    	onLoadSelectFirst	: false,		
	    	dblClickToEdit		: false,		
	    	useGroupSummary		: false,			
			useContextMenu		: false,		
			useRowNumberer		: false,			
			expandLastColumn	: false,		
			useRowContext		: false,			
            userToolbar			: false,
	    	filter: {
				useFilter	: false,		
				autoCreate	: false		
			}
		},
        selModel: 'rowmodel',		// 조회화면 selectionchange event 사용
        layout : 'fit',
//        flex: 1,
//        minHeight :85,
        flex: 2,
    	split: true,
    	store: DetailStore,
    	features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
        columns:  [  
        	{ dataIndex:'EX_SEQ'		, 		width:50, 	align: 'center'},
			{ dataIndex:'SLIP_DIVI_NM'	, 		width:50, 	align: 'center'},
			{ dataIndex:'ACCNT'			, 		width:100},
			{ dataIndex:'ACCNT_NAME'	, 		width:160},
/*			{ dataIndex:'CUSTOM_CODE'	, 		width:80,	hidden:true},*/
			{ dataIndex:'CUSTOM_NAME'	, 		width:180},
			{ dataIndex:'AMT_I'			, 		width:86},
			{ dataIndex:'MONEY_UNIT'	, 		width:53},
			{ dataIndex:'EXCHG_RATE_O'	, 		width:60},
			{ dataIndex:'FOR_AMT_I'		, 		width:80},
			{ dataIndex:'REMARK'		, 		width:333},
			{ dataIndex:'DEPT_NAME'		, 		width:80 },
			{ dataIndex:'DIV_NAME'		, 		width:130 },
			{ dataIndex:'PROOF_KIND_NM'	, 		width:126},
//			{ dataIndex:'CREDIT_NUM'	, 		width:140,	hidden:true },
			{ dataIndex:'CREDIT_NUM_EXPOS'  ,	width:120  , align:'center'},
			{ dataIndex:'REASON_CODE'	, 		flex: 1	, minWidth:100 }
			//hidden 컬럼 보이지 않게 설정
/*			{ dataIndex:'AP_DATE'		, 		width:100,	hidden:true },
  			{ dataIndex:'AC_DATE_MASTER', 		width:80,	hidden:true },
			{ dataIndex:'SLIP_NUM_MASTER', 		width:80,	hidden:true },
			{ dataIndex:'EX_NUM_MASTER'	, 		width:106,	hidden:true},
			{ dataIndex:'INPUT_PATH_MASTER'	, 	width:126,	hidden:true}
			{ dataIndex:'AC_DATE',				width:100,	hidden:true },
			{ dataIndex:'INPUT_PATH',			width:80,	hidden:true },
			{ dataIndex:'AC_CODE1', 			width:80,	hidden:true },
			{ dataIndex:'AC_NAME1',				width:106,	hidden:true},
			{ dataIndex:'AC_DATA1',				width:80,	hidden:true },
			{ dataIndex:'AC_DATA_NAME1',		width:80,	hidden:true },
			{ dataIndex:'AC_TYPE1', 			width:80,	hidden:true },
			{ dataIndex:'AC_FORMAT1',			width:106,	hidden:true},

			
			{ dataIndex:'POSTIT_YN',			width:80,	hidden:true },
			{ dataIndex:'POSTIT', 				width:80,	hidden:true },
			{ dataIndex:'POSTIT_USER_ID',		width:106,	hidden:true},
			{ dataIndex:'AUTO_NUM',				width:80,	hidden:true },
			{ dataIndex:'AC_CODE2',				width:80,	hidden:true },
			{ dataIndex:'AC_CODE3', 			width:80,	hidden:true },
			{ dataIndex:'AC_CODE4',				width:106,	hidden:true},
			{ dataIndex:'AC_CODE5',				width:80,	hidden:true },
			{ dataIndex:'AC_CODE6',				width:80,	hidden:true },
			{ dataIndex:'AC_NAME2', 			width:80,	hidden:true },
			{ dataIndex:'AC_NAME3',				width:106,	hidden:true},
			{ dataIndex:'AC_NAME4',				width:80,	hidden:true },
			{ dataIndex:'AC_NAME5',				width:80,	hidden:true },
			{ dataIndex:'AC_NAME6', 			width:80,	hidden:true },
			{ dataIndex:'AC_DATA2',				width:106,	hidden:true},
			{ dataIndex:'AC_DATA3',				width:80,	hidden:true },
			{ dataIndex:'AC_DATA4',				width:80,	hidden:true },
			{ dataIndex:'AC_DATA5', 			width:80,	hidden:true },
			{ dataIndex:'AC_DATA6',				width:106,	hidden:true},
			{ dataIndex:'AC_DATA_NAME2',		width:80,	hidden:true },
			{ dataIndex:'AC_DATA_NAME3',		width:80,	hidden:true },
			{ dataIndex:'AC_DATA_NAME4', 		width:80,	hidden:true },
			{ dataIndex:'AC_DATA_NAME5',		width:106,	hidden:true},
			{ dataIndex:'AC_DATA_NAME6',		width:80,	hidden:true },
			{ dataIndex:'AC_TYPE2',				width:80,	hidden:true },
			{ dataIndex:'AC_TYPE3', 			width:80,	hidden:true },
			{ dataIndex:'AC_TYPE4',				width:106,	hidden:true},
			{ dataIndex:'AC_TYPE5',				width:80,	hidden:true },
			{ dataIndex:'AC_TYPE6',				width:80,	hidden:true },
			{ dataIndex:'AC_FORMAT2', 			width:80,	hidden:true },
			{ dataIndex:'AC_FORMAT3',			width:106,	hidden:true},
			{ dataIndex:'AC_FORMAT4',			width:80,	hidden:true },
			{ dataIndex:'AC_FORMAT5',			width:80,	hidden:true },
			{ dataIndex:'AC_FORMAT6', 			width:80,	hidden:true }*/

        ],
        listeners:{
	       	selectionchange:function(grid, selected, eOpt)	{
        		if(selected && selected.length > 0)	{
	        		var dataMap = selected[selected.length-1].data;
		    		UniAccnt.addMadeFields(detailForm, dataMap, detailForm, '', Ext.isEmpty(selected)?null:selected[selected.length-1]);
		    		detailForm.setActiveRecord(selected[selected.length-1]);
	    		}
	     	},
    		//신용카드/현금영수증 번호 확인을 위해 해당 컬럼은 번호보기, 나머지는 링크이동 시 이용
        	beforecelldblclick : function( view, td, cellIndex, record, tr, rowIndex, e, eOpts )	{
        		var columnName = view.eventPosition.column.dataIndex;

        		if(columnName == 'CREDIT_NUM_EXPOS'){
        			view.ownerGrid.openCryptCardNoPopup(record);    
        		}      	
	        }	     	
        },
		openCryptCardNoPopup:function( record )	{
			if(record)	{
				var params = {'CRDT_FULL_NUM': record.get('CREDIT_NUM'), 'GUBUN_FLAG': '1', 'INPUT_YN': 'N'}
				Unilite.popupCipherComm('grid', record, 'CREDIT_NUM_EXPOS', 'CREDIT_NUM', params);
			}
				
		}        
    });

    var detailForm = Unilite.createForm('agj245ukrDetailForm',  {	
        itemId: 'agj245ukrDetailForm',
		masterGrid: detailGrid,
		minHeight :85,
		height: 85,
		disabled: false,
		border: true,
		padding: '1',
		layout : 'hbox',
		items:[{
			xtype: 'container',
			itemId: 'formFieldArea1',
			layout: {
				type: 'uniTable', 
				columns:3
			},
			defaults:{
				width:365,
				labelWidth: 130,
				readOnly: 'true',
				editable: false
			}
		}]
    });
    
 	//각주
 	function openPostIt(grid)	{
		var record = grid.getSelectedRecord();
		if(record){
		    if(!postitWindow) {
				postitWindow = Ext.create('widget.uniDetailWindow', {
	                title: '각주',
	                width: 350,				                
	                height:100,
	            	
	                layout: {type:'vbox', align:'stretch'},	                
	                items: [{
	                	itemId:'remarkSearch',
	                	xtype:'uniSearchForm',
	                	items:[{	
                			fieldLabel:'각주',
                			labelWidth:60,
                			name : 'POSTIT',
                			width:300
                		}]
               		}],
	                tbar:  [
				         '->',{
							itemId : 'submitBtn',
							text: '확인',
							handler: function() {
								var postIt = postitWindow.down('#remarkSearch').getValue('POSTIT');
								var aGrid =grid;
								var record = aGrid.getSelectedRecord();
								var record2 = detailGrid.getSelectedRecord();
								var param = {
					 				SLIP_DIVI	: panelSearch.getValue('SLIP_DIVI'),
						 			 AUTO_NUM	: record2.get('AUTO_NUM'),
									 EX_NUM		: record.get('SLIP_NUM'),
									 EX_SEQ		: record2.get('EX_SEQ'),
									 SLIP_NUM	: record.get('SLIP_NUM'),
									 SLIP_SEQ	: record2.get('EX_SEQ'),
									 EX_DATE	: UniDate.getDbDateStr(record.get('AC_DATE')),
									 POSTIT		: postIt
								};
								agj240skrService.updatePostIt(param, function(provider, response){});
								postitWindow.hide();
								UniAppManager.app.onQueryButtonDown();
							},
							disabled: false
						},{
							itemId : 'closeBtn',
							text: '닫기',
							handler: function() {
								postitWindow.hide();
							},
							disabled: false
						},{
							itemId : 'deleteBtn',
							text: '삭제',
							handler: function() {
								var aGrid =grid;
								var record = aGrid.getSelectedRecord();
								var record2 = detailGrid.getSelectedRecord();
								var param = {
					 				SLIP_DIVI	: panelSearch.getValue('SLIP_DIVI'),
						 			 AUTO_NUM	: record2.get('AUTO_NUM'),
									 EX_NUM		: record.get('SLIP_NUM'),
									 EX_SEQ		: record2.get('EX_SEQ'),
									 SLIP_NUM	: record.get('SLIP_NUM'),
									 SLIP_SEQ	: record2.get('EX_SEQ'),
									 EX_DATE	: UniDate.getDbDateStr(record.get('AC_DATE'))
								};
								agj240skrService.deletePostIt(param, function(provider, response){});
								postitWindow.hide();
								UniAppManager.app.onQueryButtonDown();
							},
							disabled: false
						}
				    ],
					listeners : {
						beforehide: function(me, eOpt)	{
							postitWindow.down('#remarkSearch').clearForm();
	        			},
	        			beforeclose: function( panel, eOpts )	{
							postitWindow.down('#remarkSearch').clearForm();
	        			},
	        			show: function( panel, eOpts )	{
	        			 	var aGrid = grid
							var record = aGrid.getSelectedRecord();
							var record2 = detailGrid.getSelectedRecord();
							var param = {
					 			 SLIP_DIVI	: panelSearch.getValue('SLIP_DIVI'),
					 			 AUTO_NUM	: record2.get('AUTO_NUM'),
								 EX_NUM		: record.get('SLIP_NUM'),
								 EX_SEQ		: record2.get('EX_SEQ'),
								 SLIP_NUM	: record.get('SLIP_NUM'),
								 SLIP_SEQ	: record2.get('EX_SEQ'),
								 EX_DATE	: UniDate.getDbDateStr(record.get('AC_DATE'))
							};
							agj240skrService.getPostIt(param, function(provider, response){
						
								var form = postitWindow.down('#remarkSearch');
								form.setValue('POSTIT', provider['POSTIT']);
//								form.setValue('POSTIT_YN', provider['POSTIT_YN']);
//								form.setValue('POSTIT_USER_ID', provider['POSTIT_USER_ID']);
							});
	        			}
					}		
				});
			}	
			postitWindow.center();
			postitWindow.show();
		}
	}
		
    Unilite.Main( {
		borderItems:[{
			border: false,
			region:'center',
			layout: 'border',
			items:[
			 	panelResult,
				masterGrid, 
				{
					region:'south',
					xtype:'container',
//					minHeight :135,
					minHeight :220,
					flex:0.35,
					layout:{type:'vbox', align:'stretch'},
					items:[
						detailGrid, detailForm
					]
				}
			]	
		}		
		,panelSearch
		],
		id  : 'agj245skrApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('AC_DATE_FR', UniDate.get('today'));	
			panelSearch.setValue('AC_DATE_TO', UniDate.get('today'));	
			panelResult.setValue('AC_DATE_FR', UniDate.get('today'));	
			panelResult.setValue('AC_DATE_TO', UniDate.get('today'));
			panelSearch.setValue('SLIP_DIVI', '1');
            masterGrid.getColumn('AC_DATE').setText('회계일');
			masterGrid.getColumn('EX_DATE').setText('결의일');
			
            if(baseInfo.gsChargeDivi == '1'){
                panelSearch.getField('IN_DEPT_CODE').setReadOnly(false);
                panelSearch.getField('IN_DEPT_NAME').setReadOnly(false);
                panelResult.getField('IN_DEPT_CODE').setReadOnly(false);
                panelResult.getField('IN_DEPT_NAME').setReadOnly(false);
	            
            }else{
                panelSearch.getField('IN_DEPT_CODE').setReadOnly(true);
                panelSearch.getField('IN_DEPT_NAME').setReadOnly(true);
                panelResult.getField('IN_DEPT_CODE').setReadOnly(true);
                panelResult.getField('IN_DEPT_NAME').setReadOnly(true);
			
				panelSearch.setValue('IN_DEPT_CODE',UserInfo.deptCode);
	            panelSearch.setValue('IN_DEPT_NAME',UserInfo.deptName);
	            panelResult.setValue('IN_DEPT_CODE',UserInfo.deptCode);
	            panelResult.setValue('IN_DEPT_NAME',UserInfo.deptName);
            }
            
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			UniAppManager.setToolbarButtons('save',false);

			var viewNormal = masterGrid.getView();;
		    viewNormal.getFeature('masterGridTotal').toggleSummaryRow(false);
		    
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('AC_DATE_FR');
		},
		onQueryButtonDown : function()	{		
			if(!this.isValidSearchForm()){
				return false;
			}
			masterGrid.reset();
			detailGrid.reset();
			detailForm.clearForm();
			
			var viewNormal = masterGrid.getView();
			viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);

			masterGrid.getStore().loadStoreRecords();
			UniAppManager.setToolbarButtons('reset', true);
		},
		onResetButtonDown: function() {			
			this.suspendEvents();
			panelSearch.clearForm();
			panelResult.clearForm();
			detailForm.clearForm();
			masterGrid.reset();
			detailGrid.reset();
			masterStore.clearData();
			this.fnInitBinding();
		}
	});

};


</script>
