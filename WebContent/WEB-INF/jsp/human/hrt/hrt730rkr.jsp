<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hrt730rkr"  >
		<t:ExtComboStore comboType="BOR120"  pgmId="hrt730rkr" /><!-- 신고사업장 -->
		<t:ExtComboStore comboType="AU" comboCode="H028" /> <!-- 급여지급방식-->
		<t:ExtComboStore comboType="AU" comboCode="H031" /> <!-- 급여지급일구분-->
		<t:ExtComboStore comboType="AU" comboCode="A074" /> <!-- 귀속분기-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

function appMain() {
	
	
	
    var panelResult = Unilite.createSearchForm('resultForm2',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'west',
		layout : {type : 'uniTable', columns : 1},
		padding:'1 1 1 1',
		
		border:true,
		items: [{
			fieldLabel: '정산구분',
			name:'RETR_TYPE',
			id: 'RETR_TYPE',
			xtype: 'uniCombobox', 
			comboType:'AU',
			comboCode:'H053',
			width: 325
		},{
			fieldLabel: '정산일',
	    	xtype: 'uniDateRangefield',
	   		startFieldName: 'FR_DATE',
	   		endFieldName: 'TO_DATE',
	    	width: 325
		},{
				fieldLabel: '사업장',
				name:'DIV_CODE', 
				xtype: 'uniCombobox',
				width:325,
		        multiSelect: false, 
		        typeAhead: false,
		        comboType:'BOR120',
		        width: 325
			},
			
			Unilite.popup('DEPT',{
		    	colspan: 1,
		        fieldLabel: '부서',
			    valueFieldName:'FR_DEPT_CODE',
			    textFieldName:'FR_DEPT_NAME',
		        validateBlank:false,
                listeners: {
                    onSelected: {
                        fn: function(records, type) {
                        },
                        scope: this
                    },
                    onClear: function(type) {
                        panelResult.setValue('FR_DEPT_CODE', '');
                        panelResult.setValue('FR_DEPT_NAME', '');
                    }
                }
		    }),
	      	Unilite.popup('DEPT',{
		        fieldLabel: '~',
		        colspan: 1,
			    valueFieldName:'TO_DEPT_CODE',
			    textFieldName:'TO_DEPT_NAME',
		        validateBlank:false,
                listeners: {
                    onSelected: {
                        fn: function(records, type) {
                        },
                        scope: this
                    },
                    onClear: function(type) {
                        panelResult.setValue('TO_DEPT_CODE', '');
                        panelResult.setValue('TO_DEPT_NAME', '');
                    }
                }
		    }), 
			{
				fieldLabel: '급여지급방식',
				name:'PAY_CODE', 
				xtype: 'uniCombobox',
				width:325,
		        comboType: 'AU',
				comboCode: 'H028'
				
			},{
				fieldLabel: '지급차수',
				name:'PAY_PROV_FLAG', 
				xtype: 'uniCombobox',
				width:325,
		        comboType: 'AU',
				comboCode: 'H031'
			},Unilite.popup('Employee',{
				fieldLabel: '사원',
			  	valueFieldName:'PERSON_NUMB',
			    textFieldName:'NAME',
				validateBlank:false,
				autoPopup:true,
				id : 'PERSON_NUMB', 
				listeners: {
					 onSelected: {
                        fn: function(records, type) {
                        },
                          scope: this
                     },
                     onClear: function(type) {
                         panelResult.setValue('PERSON_NUMB', '');
                         panelResult.setValue('NAME', '');
                     },
					applyextparam: function(popup){	
						popup.setExtParam({'BASE_DT': '00000000'}); 
					}
				}
			}),
			{
	         	xtype:'button',
	         	text:'출    력',
	         	width:235,
	         	tdAttrs:{'align':'center', style:'padding-left:95px'},
	         	handler:function()	{
	         		UniAppManager.app.onPrintButtonDown();
	         	}
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
		id: 'hrt730rkrApp',
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons(['print'], false);
			UniAppManager.setToolbarButtons(['query', 'reset', 'newData', 'save', 'detail', 'delete'], false);
			
		},
        onPrintButtonDown: function() {

        	
	        if(!panelResult.getInvalidMessage()) return;   
			//var param  = Ext.getCmp('resultForm').getValues();			// 상단 증명서 종류
			//sMHT0085
			var param = Ext.getCmp('resultForm2').getValues();			// 하단 검색조건
			param.TITLE = Msg.sMHT0090;
			param.DIV_NAME = panelResult.getField("DIV_CODE").getRawValue();
			var win = Ext.create('widget.PDFPrintWindow', {
	            url: CPATH+'/human/hrt730rkrPrint.do',
	            prgID: 'hrt730rkr',
	               extParam: param
	            });
	            win.center();
	            win.show();
          
	    }
	}); //End of 	Unilite.Main( {
};

</script>
