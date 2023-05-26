<%@page language="java" contentType="text/html; charset=utf-8"%>

<t:appConfig pgmId="hum964rkr"  >
	<t:ExtComboStore comboType="BOR120"  /> 						<!-- 사업장 -->   
	<t:ExtComboStore comboType="BOR120"  comboCode="BILL" />		<!-- 신고사업장 -->
</t:appConfig>

<script type="text/javascript" >

var gsUserDept= '${deptData}';
function appMain() {
	/*
	 * combobox 정의
	 */
	var gsDED_TYPE;
	
	
	
	
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
    
    
	var panelSearch = Unilite.createSearchForm('hum964rkrForm', {
		region: 'center',
    	disabled :false,
    	border: false,
    	flex:1,
    	layout: {
	    	type: 'uniTable',
			columns:1
	    },
	    defaults:{
	    	width:325,
			labelWidth:90
	    },
		defaultType: 'uniTextfield',
		padding:'20 0 0 0',
		width:400,
	    items :[
	   {
			fieldLabel: '사업장',
			id: 'DIV_CODE', 
			name: 'DIV_CODE', 
			xtype: 'uniCombobox',
			comboType: 'BOR120'
			//allowBlank: false
		},Unilite.popup('DEPT',{
		        fieldLabel: '부서',
			    valueFieldName:'DEPT_CODE_FR',
			    textFieldName:'DEPT_NAME_FR',
			    itemId:'DEPT_CODE_FR',
    			autoPopup: true,
                listeners: {
                    onClear: function(type) {
                        panelSearch.setValue('DEPT_CODE_FR', '');
                        panelSearch.setValue('DEPT_NAME_FR', '');
                    }
                }
	    }),Unilite.popup('DEPT',{
		        fieldLabel: '~',
		        itemId:'DEPT_CODE_TO',
			    valueFieldName:'DEPT_CODE_TO',
			    textFieldName:'DEPT_NAME_TO',
    			autoPopup: true,
                listeners: {
                    onClear: function(type) {
                        panelSearch.setValue('DEPT_CODE_TO', '');
                        panelSearch.setValue('DEPT_NAME_TO', '');
                    }
                }
	    }),{
			fieldLabel: '직위',
			name:'POST_CODE',
			xtype: 'uniCombobox',
			comboType:'AU',
			comboCode:'H005'
		},
		Unilite.popup('Employee',{
			fieldLabel: '사원',
		  	valueFieldName:'PERSON_NUMB',
		    textFieldName:'NAME',
			validateBlank:false,
			autoPopup:true,
			listeners: {
				applyextparam: function(popup){	
					//popup.setExtParam({'BASE_DT': '00000000'}); 
					//popup.setExtParam({'PAY_GUBUN': ''}); 
				},
				onClear: function(type) {
                        panelSearch.setValue('PERSON_NUMB', '');
                        panelSearch.setValue('NAME', '');
                }
			}
		}),
		{
    		xtype: 'radiogroup',		            		
    		fieldLabel: '비정규직포함',
    		id: 'radio1',
    		items: [{
    			boxLabel: ' 한다', width: 100, name: 'PAY_GUBUN', inputValue: 'N'
    		}, {
    			boxLabel: '안한다', width: 100, name: 'PAY_GUBUN', inputValue: 'Y',checked: true
    		}]
		},{
    		xtype: 'radiogroup',		            		
    		fieldLabel: '퇴직자포함',
    		id: 'radio2',
    		items: [{
    			boxLabel: '한다', width: 100, name: 'RETR_YN', inputValue: 'Y'
    		}, {
    			boxLabel: '안한다', width: 100, name: 'RETR_YN', inputValue: 'N',checked: true
    		}]
		},
		 {
         	xtype:'button',
         	text:'출    력',
         	width:235,
         	tdAttrs:{'align':'center', style:'padding-left:95px'},
    		handler:function()	{
         		UniAppManager.app.onPrintButtonDown();
         	}
         }
	    ]		
	});
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
 
    Unilite.Main( {
		items 	: [ panelSearch],
		id  : 'hum964rkrApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons(['reset','query','print'],false);
			
			
			var today = UniDate.get('today');
			var strReceDate= UniDate.getDbDateStr(today).substring(0, 4) 
						   + UniDate.getDbDateStr(today).substring(4, 6)
			               + "10"
			gsDED_TYPE = "1";
			
			if (!Ext.isEmpty(gsUserDept)){
				
				panelSearch.setValue('DEPT_CODE_FR',gsUserDept[0].DEPT_CODE);
				panelSearch.setValue('DEPT_NAME_FR',gsUserDept[0].DEPT_NAME);
                panelSearch.setValue('DEPT_CODE_TO',gsUserDept[0].DEPT_CODE);
				panelSearch.setValue('DEPT_NAME_TO',gsUserDept[0].DEPT_NAME);
                
				panelSearch.down('#DEPT_CODE_FR').setDisabled(true);
				panelSearch.down('#DEPT_CODE_TO').setDisabled(true);
				
			}else{
				panelSearch.down('#DEPT_CODE_FR').setDisabled(false);
				panelSearch.down('#DEPT_CODE_TO').setDisabled(false);
			}
			
			
		},
		onQueryButtonDown : function()	{			
			
				/*masterGrid1.getStore().loadStoreRecords();
				var viewLocked = masterGrid1.lockedGrid.getView();
				var viewNormal = masterGrid1.normalGrid.getView();
				console.log("viewLocked : ",viewLocked);
				console.log("viewNormal : ",viewNormal);
			    viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
			    viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
			    viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
			    viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);*/				
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		},
		onPrintButtonDown: function() {
			if(!panelSearch.getInvalidMessage()) return;   
			var param= panelSearch.getValues();
			param["DIV_NAME"]=panelSearch.getField('DIV_CODE').getRawValue();
//			param["TITLE_NAME"]=panelSearch.getField('MEDIUM_TYPE').getRawValue();
//			param["PGM_ID"]='hum960rkr';
//			var win = Ext.create('widget.CrystalReport', {
//				url: CPATH+'/human/hum964crkrPrint.do',//'/human/hum960rkrPrint.do',//'/human/hum960crkr.do',//'/human/hum960rkrPrint.do',
//				prgID: 'hum963rkr',
//					extParam: param
//				});
//			win.center();
//			win.show();
			
			hum963skrService.selectPrimaryDataList(param, function(provider, response){
                if(Ext.isEmpty(provider)){
                	alert('조건에 맞는 사원이 존재하지 않습니다..');
                	return false;
                } else {
		            param.PGM_ID = 'hum964rkr';  //프로그램ID
		            param.sTxtValue2_fileTitle = "인사기록카드";
		            
					var win = Ext.create('widget.ClipReport', {
						url: CPATH+'/human/hum964clrkrv.do',
						prgID: 'hum964rkr',
							extParam: param
						});
					win.center();
					win.show();   				
                }
            });
		}
	});

};


</script>
			