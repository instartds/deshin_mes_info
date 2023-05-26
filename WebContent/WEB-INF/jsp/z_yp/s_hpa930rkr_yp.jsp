<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_hpa930rkr_yp"  >
		<t:ExtComboStore comboType="AU" comboCode="H011" /> <!-- 고용형태 -->
		<t:ExtComboStore comboType="AU" comboCode="H024" /> <!-- 사원구분 -->
		<t:ExtComboStore comboType="AU" comboCode="H028" /> <!-- 급여지급방식 -->
		<t:ExtComboStore comboType="AU" comboCode="H031" /> <!-- 지급차수 -->
		<t:ExtComboStore comboType="AU" comboCode="H032" /> <!-- 지급구분 -->
		<t:ExtComboStore comboType="AU" comboCode="H181" /> <!-- 사원그룹 -->
		<t:ExtComboStore comboType="CBM600" comboCode="0"/>   		   <!--  Cost Pool        --> 
		<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 --> 
		<t:ExtComboStore items="${costPoolCombo}" storeId="costPoolCombo"/>              <!--  Cost Pool        -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

function appMain() {
	
	/* Store 정의(Service 정의)
	 * @type 
	 */					
//	var masterStore = Unilite.createStore('hpa900rkrMasterStore',{
//		uniOpt: {
//            isMaster	: true,			// 상위 버튼 연결 
//            editable	: false,		// 수정 모드 사용 
//            deletable	: false,		// 삭제 가능 여부 
//	        useNavi		: false			// prev | newxt 버튼 사용
//	        //비고(*) 사용않함
//        },
//        autoLoad: false,
//        proxy: {
//            type: 'direct',
//            api: {			
//                read: 'hpa900rkrService.selectList'                	
//            }
//        }/*, //(사용 안 함 : 쿼리에서 처리)
//        listeners : {
//	        load : function(store) {
//	            if (store.getCount() > 0) {
//	            	setGridSummary(true);
//	            } else {
//	            	setGridSummary(false);
//	            }
//	        }
//	    }*/,
//		loadStoreRecords: function() {
//			var param= Ext.getCmp('searchForm').getValues();			
//			console.log( param );
//			this.load({
//				params : param
//			});
//		},
//		groupField: 'PAY_YYYYMM'
//	}); //End of var masterStore = Unilite.createStore('hpa900rkrMasterStore',{

    var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'west',
		layout : {type : 'uniTable', columns : 1
		},
		padding:'1 1 1 1',
		border:true,
		items: [{
				fieldLabel: '지급년월',
				id: 'PAY_YYYYMM',
				xtype: 'uniMonthfield',
				name: 'PAY_YYYYMM',                    
				value: new Date(),                    
				allowBlank: false
			},{
		        fieldLabel: '급상여구분',
		        name:'SUPP_TYPE', 	
		        xtype: 'uniCombobox',
		        comboType: 'AU',
		        comboCode:'H032',
		        value: '1',                    
                allowBlank: false
		    },{
				fieldLabel	: '사업장',
				name		: 'DIV_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
				comboCode	: 'BILL'
			},
			Unilite.treePopup('DEPTTREE',{
				fieldLabel: '부서',
				valueFieldName:'DEPT_CODE',
				textFieldName:'DEPT_NAME' ,
				valuesName:'DEPT_CODES' ,
				DBvalueFieldName:'TREE_CODE',
				DBtextFieldName:'TREE_NAME',
				selectChildren:true,
//				textFieldWidth:89,
				textFieldWidth: 159,
				validateBlank:true,
//				width:300,
				autoPopup:true
				
			}),{
                fieldLabel: '회계부서',
                name:'COST_KIND'   ,   
                xtype: 'uniCombobox',
                store : Ext.StoreManager.lookup('costPoolCombo'),
                colspan: 3
            },
			{
                fieldLabel: '급여지급방식',
                name:'PAY_CODE', 	
                xtype: 'uniCombobox',
                comboType:'AU',
                comboCode:'H028'
            },{
                fieldLabel: '지급차수',
                name:'PAY_PROV_FLAG', 	
                xtype: 'uniCombobox',
                comboType:'AU',
                comboCode:'H031'
            },
            Unilite.popup('Employee',{
		      	fieldLabel : '성명|사번',
			    valueFieldName:'PERSON_NUMB',
			    textFieldName:'NAME',
//			    validateBlank: false,
				listeners: {
					onSelected: {
						fn: function(records, type) {
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('PERSON_NUMB', '');
						panelResult.setValue('NAME', '');
					}
				}
      		}),Unilite.popup('BANK',{
				fieldLabel: '은행코드',
				valueFieldName: 'BANK_CODE',
				textFieldName: 'BANK_NAME',
				validateBlank: false,
				colspan:2,
				name: 'BANK_CODE'
		}),{
				xtype: 'radiogroup',		            		
				fieldLabel: '출력기준',						            		
				itemId: 'RADIO4',
				labelWidth: 90,
				items: [{
					boxLabel: '은행별', 
					width: 80, 
					name: 'COST_POOL',
					inputValue: '1',
					checked: true  
				},{
					boxLabel: '전체', 
					width: 80, 
					name: 'COST_POOL',
					inputValue: '2'
				},{
					boxLabel: 'Cost Pool', 
					width: 80, 
					name: 'COST_POOL',
					inputValue: '3'
				}]
			},,{
                xtype   : 'container',
                layout  : {type : 'uniTable'},
                items   : [{
                    xtype       : 'radiogroup',
                    fieldLabel  : '양식',
                    id          : 'rdoSelect',
                    items       : [{
                        boxLabel    : 'A종', 
                        name        : 'PRINT_CONDITION',
                        width       : 80, 
                        inputValue  : '1',
                        checked     : true  
                    },{
                        boxLabel    : 'B종', 
                        name        : 'PRINT_CONDITION',
                        width       : 80,
                        inputValue  : '2'
                    }],
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {
                        }
                    }
                }]
        },{
			xtype: 'radiogroup',		            		
			fieldLabel: '계좌번호출력',						            		
			itemId: 'BANK_ACCOUNT',
			labelWidth: 90,
			items: [{
				boxLabel: '계좌번호1', 
				width       : 80, 
				name: 'BANK_ACCOUNT',
				inputValue: '1',
				checked: true  
			},{
				boxLabel: '계좌번호2', 
				width       : 80, 
				name: 'BANK_ACCOUNT',
				inputValue: '2'
			}]
		}]
	});		
	
	Unilite.Main({
	 	border: false,
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				panelResult
			]	
		}		
		], 
		id: 's_hpa930rkr_ypApp',
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons(['query', 'detail', 'reset'],false); 
			UniAppManager.setToolbarButtons('print',true);
		},
		checkForNewDetail:function() { 			
        },
		onQueryButtonDown : function()	{
		
		},
		onResetButtonDown: function() {
			this.fnInitBinding();
		},
		onPrintButtonDown: function() {
            var param = panelResult.getValues();
            var win = Ext.create('widget.CrystalReport', {
                url: CPATH+'/z_yp/s_hpa930crkr_yp.do',
                prgID: 's_hpa930rkr_yp',
                extParam: param
            });
            win.center();
            win.show();
        }
	}); //End of
};

</script>
