<%@page language="java" contentType="text/html; charset=utf-8"%>

<t:appConfig pgmId="had605ukr"  >
<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
<t:ExtComboStore comboType="AU" comboCode="H028" /> <!-- 급여지급방식 -->
<t:ExtComboStore comboType="AU" comboCode="H031" /> <!-- 지급차수 -->
</t:appConfig>

<script type="text/javascript" >
var gsBaseDate = '${taxAdjustmentYear}'+'1231';
function appMain() {
	
	Ext.create('Ext.data.Store', {
		storeId:"gubun",
	    fields: ['text', 'value'],
	    data : [
	        {text:"중도퇴사",   value:"Y"},
	        {text:"연말정산", 	value:"N"}
	    ]
	});
	
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Had605ukrModel', {		
	    fields: [{name: 'WORK_TYPE' 		,text: '작업항목'	,type: 'string'},			  
				 {name: 'WORK_START_TIME'	,text: '시작시간'	,type: 'string'},			  
				 {name: 'WORK_END_TIME'		,text: '종료시간'	,type: 'string'},
				 {name: 'WORK_TOTAL_TIME'	,text: '작업시간'	,type: 'string'},
				 {name: 'WORK_CONTENT'		,text: '작업내용'	,type: 'string'},			  
				 {name: 'WORK_REMARK'		,text: '비고' 	,type: 'string'}
			]
	});
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('had605ukrMasterStore1',{
			model: 'Had605ukrModel',
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
                	   read: 'had605ukrService.selectList'                	
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
			
	});
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
    
    var panelSearch = Unilite.createForm('had605ukrvDetail', {
    	disabled :false
        , flex:1        
        , layout: {type: 'uniTable', columns: 1,tdAttrs: {valign:'top'}}
	    , items :[{
			fieldLabel: '정산구분',
			name: 'RETR_TYPE', 
			xtype: 'uniCombobox',
			store: Ext.data.StoreManager.lookup('gubun'),
			value:'N',
			allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						if(newValue == "N"){
							panelSearch.down('#hideField2').hide();
							panelSearch.down('#hideField1').show();
						}else if(newValue == "Y"){
							panelSearch.down('#hideField2').show();
							panelSearch.down('#hideField1').hide();					
						}
					}
				}
		},{
			fieldLabel: '정산년도',
			name: 'YEAR_YYYY',
			xtype: 'uniYearField',
			value: UniHuman.getTaxReturnYear(),
			allowBlank: false
		},{
			fieldLabel: '기준일자',
			itemId: 'hideField1',
			xtype: 'uniDatefield',
			name: 'BASE_DATE',                
			value:gsBaseDate,
			//value: UniDate.get('endOfLastYear'),                    
			allowBlank: false,
			readOnly: true
		},{
			itemId: 'hideField2',
			hidden: true,
			fieldLabel: '퇴사일자',
			xtype: 'uniDateRangefield',
            startFieldName: 'FR_RETIRE_DATE',
            endFieldName: 'TO_RETIRE_DATE'
		},{
			fieldLabel: '사업장',
			name: 'DIV_CODE', 
			xtype: 'uniCombobox',
			comboType: 'BOR120'
		},
			Unilite.treePopup('DEPTTREE',{
			fieldLabel: '부서',
			valueFieldName:'DEPT',
			textFieldName:'DEPT_NAME' ,
			valuesName:'DEPTS' ,
			DBvalueFieldName:'TREE_CODE',
			DBtextFieldName:'TREE_NAME',
			selectChildren:true,
			textFieldWidth:89,
			validateBlank:true,
			width:300,
			autoPopup:true,
			useLike:true,
			listeners: {
                'onValueFieldChange': function(field, newValue, oldValue  ){
                    	
                },
                'onTextFieldChange':  function( field, newValue, oldValue  ){
                    
                },
                'onValuesChange':  function( field, records){
                    	var tagfield = panelSearch.getField('DEPTS') ;
                    	tagfield.setStoreData(records)
                }
			}
		}),{
			fieldLabel: '급여지급방식',
			name: 'PAY_CODE', 
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'H028'
		},{
			fieldLabel: '지급차수',
			name: 'PAY_PROV_FLAG', 
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'H031'
		},			
	     	Unilite.popup('Employee',{ 
			
			validateBlank: false,
			listeners: {
					onSelected: {
						fn: function(records, type) {
							if(records && records.length>0)	{
								var retrDate = records[0].RETR_DATE;
								if(!Ext.isEmpty(retrDate) && retrDate.substring(0,4) <= panelSearch.getValue('YEAR_YYYY'))	{
									if(retrDate.substring(5,8) != '1231')	{
										panelSearch.setValue('RETR_TYPE','Y');
										panelSearch.setValue('BASE_DATE',retrDate);
									}else {
										if(panelSearch.getValue('YEAR_END_TAX_CALCU_RULE') == '2')	{ // 중도퇴사
											panelSearch.setValue('RETR_TYPE','Y');
											panelSearch.setValue('BASE_DATE',retrDate);
										} else  {													  // 연말정산
											panelSearch.setValue('RETR_TYPE','N');
											panelSearch.setValue('BASE_DATE',gsBaseDate);
										}
									}
								}else {
									panelSearch.setValue('RETR_TYPE','N');
									panelSearch.setValue('BASE_DATE',gsBaseDate);
								}
							}
	                	},
						scope: this
					},
                    'onClear': function(type) {
                        panelSearch.setValue('PERSON_NUMB', '');
                        panelSearch.setValue('NAME', '');
                    }
			}
		}),{
			fieldLabel: '12.31일자 처리여부',
			name: 'YEAR_END_TAX_CALCU_RULE',
			value:'1',
			hidden:true
		},{
	     	xtype: 'container', 
	     	tdAttrs: {align: 'center'},
	     	layout: {type: 'uniTable', columns: 3},
	     	items: [{
	        	margin: '0 6 0 0',
				xtype: 'button',
				id: 'startButton',
				text: '실행',		
				width: 60,
				handler : function() {
	    			if(!panelSearch.setAllFieldsReadOnly(true)){
			    		return false;
			    	}
			    	Ext.getBody().mask();
			    	had605ukrService.save(panelSearch.getValues(), function( responseText, response){
			    		Ext.getBody().unmask();
			    		if(responseText && responseText.success === true)	{
			    			Unilite.messageBox("실행 완료되었습니다.", "정산대상    : "+responseText.TOTAL_COUNT+" 명"+"\n" +
			    											     "마감(제외) : "+responseText.CLOSED_COUNT+" 명"+"\n" +
			    											     "실행완료    : "+responseText.BATCH_COUNT+" 명"+"\n" , "성공", {showDetail:true});
			    		}
			    	})
			    	
	    		}
	     	}/*,{xtype: 'component', width: 5}, {
				xtype: 'button',
				id: 'cancelButton',
				text: '취소',
				width: 60,
				handler : function() {
	    			if(!panelSearch.setAllFieldsReadOnly(true)){
			    		return false;
			    	}	    			
	    		}
	     	}*/]
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
		id  : 'had605ukrApp',
		items 	: [ panelSearch],
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('GUBUN', 'N');
			panelSearch.setValue('DATE_TO', UniDate.get('today'));
			panelSearch.setValue('DATE_FR', UniDate.get('startOfMonth', panelSearch.getValue('DATE_TO')));
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
		},
		onQueryButtonDown : function()	{				
		},
		onDetailButtonDown:function() {
			
		}
	});

};


</script>

