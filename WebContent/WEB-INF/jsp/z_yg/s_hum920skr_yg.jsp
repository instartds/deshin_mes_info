<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_hum920skr_yg"  >
	<t:ExtComboStore comboType="BOR120" pgmId="hum920skr"/> 						<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" 	comboCode="H011" /> 						<!-- 고용형태 -->
	<t:ExtComboStore comboType="AU" 	comboCode="H024" /> 						<!-- 사원구분 -->
	<t:ExtComboStore comboType="AU" 	comboCode="H005" /> 						<!-- 직위 -->
	<t:ExtComboStore comboType="AU" 	comboCode="H006" /> 						<!-- 직책 -->
	<t:ExtComboStore comboType="AU" 	comboCode="H009" /> 						<!-- 학력 -->
	<t:ExtComboStore comboType="AU" 	comboCode="H010" /> 						<!-- 졸업구분 -->
	<t:ExtComboStore items="${COMBO_HUMAN_COST_POOL}" storeId="getHumanCostPool" />	<!-- 사업명-->
	<t:ExtComboStore comboType="AU" 	comboCode="H084" /> 						<!-- 보훈구분 -->
	<t:ExtComboStore comboType="AU" 	comboCode="H085" /> 						<!-- 장애구분 -->
	<t:ExtComboStore comboType="AU" 	comboCode="H173" /> 						<!-- 직렬 -->
	<t:ExtComboStore comboType="AU" 	comboCode="H174" /> 						<!-- 호봉승급기준 -->
	<t:ExtComboStore comboType="AU" 	comboCode="H028" /> 						<!-- 급여지급방식 -->
	<t:ExtComboStore comboType="AU" 	comboCode="H031" /> 						<!-- 지급차수 -->
	<t:ExtComboStore comboType="AU" 	comboCode="H181" /> 						<!-- 사원그룹 -->
	<t:ExtComboStore comboType="AU" 	comboCode="H008" /> 						<!-- 담당그룹 -->
	<t:ExtComboStore comboType="AU" 	comboCode="T107" /> 						<!-- 고용보험 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

function appMain() {
	var	gsLicenseTab 	= ${gsLicenseTab};
	var	gsOnlyHuman 	= ${gsOnlyHuman};
	
	var gsCostPool = '${CostPool}';  // H175 subCode 10의 Y/N 에 따라 값이 바뀜

	var SetHiddenMode = false; 
	
	if(UserInfo.compCountry == "CN"){  // 중국어 버전 관련 Hidden 처리
		SetHiddenMode = true;
	}
	if(gsLicenseTab[0].LICENSE_TAB == 'Y'){ // 버스_면허기타 Tab 사용여부 관련 Hidden 처리
		SetHiddenMode = true;
	}
	if(gsOnlyHuman.length  == 0){ // 급여/고정공제 TAB 사용못하는 인사담당자ID 여부
		SetHiddenMode = true;
	}
	
   /**
    *   Model 정의 
    * @type 
    */

	Unilite.defineModel('s_hum920skr_ygModel', {
		fields: [ 
			{name: 'GUBUN',             text: '구분',            type: 'string'},
			{name: 'DIV_CODE',			text: '사업장',			type: 'string', comboType:'BOR120'},
			{name: 'DEPT_CODE',			text: '부서코드',			type: 'string' },
			{name: 'DEPT_NAME',			text: '부서',			type: 'string' },
			{name: 'POST_CODE',			text: '직위',			type: 'string', comboType:'AU',comboCode:'H005' },
			{name: 'NAME',				text: '성명',			type: 'string'},
			{name: 'PERSON_NUMB',		text: '사번',			type: 'string'},
			{name: 'REPRE_NUMB',          text: '주민번호',           type: 'string'},
            {name: 'REPRE_NUMB_EXPOS',   text: '주민번호',           type: 'string'},
			{name: 'JOIN_DATE',			text: '입사일',			type: 'uniDate'},
			{name: 'ABIL_CODE',			text: '직책',			type: 'string', comboType:'AU',comboCode:'H006' },
			{name: 'JOB_CODE',			text: '담당업무',			type: 'string', comboType:'AU',comboCode:'H008' },
			{name: 'TELEPHON',			text: '전화번호',			type: 'string'},
			{name: 'PHONE_NO',		    text: '핸드폰',			type: 'string'},
			{name: 'EMAIL_ADDR',		text: '이메일',			type: 'string'},             	 
			{name: 'KOR_ADDR',			text: '주소',			type: 'string'},		
			{name: 'WEDDING_DATE',		text: '결혼기념일',		type: 'uniDate'},
			{name: 'BIRTH_DATE',		text: '생년월일',		    type: 'string'},
			{name: 'RETR_DATE',			text: '퇴사일',			type: 'uniDate'}
			
		]
	});
   
   /**
    * Store 정의(Service 정의)
    * @type 
    */               
   var directMasterStore1 = Unilite.createStore('s_hum920skr_ygMasterStore1',{
         model: 's_hum920skr_ygModel',
         uniOpt : {
               isMaster: true,         // 상위 버튼 연결 
               editable: false,         // 수정 모드 사용 
               deletable:false,         // 삭제 가능 여부 
               useNavi : false         // prev | newxt 버튼 사용
                  //비고(*) 사용않함
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {          
                      read: 's_hum920skr_ygService.selectList'                   
                }
            },
    	    loadStoreRecords : function()   {
	            var param= Ext.getCmp('searchForm').getValues();         
	            console.log( param );
	            this.load({
	               params : param
	            });
	        }
	       /* ,
	        _onStoreLoad: function ( store, records, successful, eOpts ) {
		    	if(this.uniOpt.isMaster) {
		    		var recLength = 0;
		    		Ext.each(records, function(record, idx){
		    			if(record.get('GUBUN') == '1'){
		    				recLength++;
		    			}
		    		});
			    	if (records) {
				    	UniAppManager.setToolbarButtons('save', false);
						var msg = recLength + Msg.sMB001; //'건이 조회되었습니다.';
				    	//console.log(msg, st);
				    	UniAppManager.updateStatus(msg, true);	
			    	}
		    	}
		    }*/
   });
   


   /**
    * 검색조건 (Search Panel)
    * @type 
    */
	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '검색조건',		
        defaultType: 'uniSearchSubPanel',
        collapsed: UserInfo.appOption.collapseLeftSearch,
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
			items: [{
				fieldLabel: '사업장',
				name:'DIV_CODE', 
				xtype: 'uniCombobox',
		        /*multiSelect: true,*/ 
		        typeAhead: false,
		        comboType:'BOR120',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
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
	                    	panelResult.setValue('DEPT',newValue);
	                },
	                'onTextFieldChange':  function( field, newValue, oldValue  ){
	                    	panelResult.setValue('DEPT_NAME',newValue);
	                },
	                'onValuesChange':  function( field, records){
	                    	var tagfield = panelResult.getField('DEPTS') ;
	                    	tagfield.setStoreData(records)
	                }
				}
			}),
			
			{ 
                fieldLabel: '입사일',
                xtype: 'uniDateRangefield',
                startFieldName: 'ANN_FR_DATE',
                endFieldName: 'ANN_TO_DATE',
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                        if(panelResult) {
                            panelResult.setValue('ANN_FR_DATE',newValue);
                        }
                    },
                onEndDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelResult) {
                        panelResult.setValue('ANN_TO_DATE',newValue);
                    }
                }
            },
			Unilite.popup('Employee',{
				fieldLabel: '사원',
			  	valueFieldName:'PERSON_NUMB',
			    textFieldName:'NAME',
				validateBlank:false,
//				autoPopup:true,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('PERSON_NUMB', panelSearch.getValue('PERSON_NUMB'));
							panelResult.setValue('NAME', panelSearch.getValue('NAME'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('PERSON_NUMB', '');
						panelResult.setValue('NAME', '');
					},
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('PERSON_NUMB', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('NAME', newValue);				
					}
				}
			}),{
                fieldLabel: '퇴사자포함',
                xtype: 'radiogroup',
                columns: [60,60],
                items: [{
						boxLabel: '한다',
                        name: 'RDO_RETIRE',
                        inputValue: '1'
					},{
						boxLabel: '안한다',
                        name: 'RDO_RETIRE',
                        inputValue: '2',
                        checked: true
					}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.getField('RDO_RETIRE').setValue(newValue.RDO_RETIRE);
						}
					}
            },{
                fieldLabel: '비정규직포함',
                xtype: 'radiogroup',
                columns: [60,60],
                items: [{
                        boxLabel: '한다',
                        name: 'RDO_PAYGUBUN',
                        inputValue: '1'
                    },{
                        boxLabel: '안한다',
                        name: 'RDO_PAYGUBUN',
                        inputValue: '2',
                        checked: true
                    }],
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                            panelResult.getField('RDO_PAYGUBUN').setValue(newValue.RDO_PAYGUBUN);
                        }
                    }
            }
		]}]     	
	});
	
	var panelResult = Unilite.createSearchForm('panelResultForm', {
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
	    	items: [{
				fieldLabel: '사업장',
				name:'DIV_CODE', 
				xtype: 'uniCombobox',
		        /*multiSelect: true, */
		        typeAhead: false,
		        comboType:'BOR120',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('DIV_CODE', newValue);
					}
				}
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
				colspan:2,
				listeners: {
	                'onValueFieldChange': function(field, newValue, oldValue  ){
	                    	panelSearch.setValue('DEPT',newValue);
	                },
	                'onTextFieldChange':  function( field, newValue, oldValue  ){
	                    	panelSearch.setValue('DEPT_NAME',newValue);
	                },
	                'onValuesChange':  function( field, records){
	                    	var tagfield = panelSearch.getField('DEPTS') ;
	                    	tagfield.setStoreData(records)
	                }
				}
			}), 
			{ 
    			fieldLabel: '입사일',
		        xtype: 'uniDateRangefield',
		        startFieldName: 'ANN_FR_DATE',
		        endFieldName: 'ANN_TO_DATE',
		        onStartDateChange: function(field, newValue, oldValue, eOpts) {
	                	if(panelSearch) {
							panelSearch.setValue('ANN_FR_DATE',newValue);
	                	}
				    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelSearch.setValue('ANN_TO_DATE',newValue);
			    	}
			    }
	        },
	        Unilite.popup('Employee',{
				fieldLabel: '사원',
			  	valueFieldName:'PERSON_NUMB',
			    textFieldName:'NAME',
				validateBlank:false,
//				autoPopup:true,
				colspan:2,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('PERSON_NUMB', panelSearch.getValue('PERSON_NUMB'));
							panelSearch.setValue('NAME', panelSearch.getValue('NAME'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('PERSON_NUMB', '');
						panelSearch.setValue('NAME', '');
					},
					onValueFieldChange: function(field, newValue){
						panelSearch.setValue('PERSON_NUMB', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelSearch.setValue('NAME', newValue);				
					}
				}
			}),{
                fieldLabel: '퇴사자포함',
                xtype: 'radiogroup',
                columns: [60,60],
                items: [{
                        boxLabel: '한다',
                        name: 'RDO_RETIRE',
                        inputValue: '1'
                    },{
                        boxLabel: '안한다',
                        name: 'RDO_RETIRE',
                        inputValue: '2',
                        checked: true
                    }],
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                            panelSearch.getField('RDO_RETIRE').setValue(newValue.RDO_RETIRE);
                        }
                    }
            },
	      
	        {
                fieldLabel: '비정규직포함',
                xtype: 'radiogroup',
                columns: [60,60],
                items: [{
						boxLabel: '한다',
						name: 'RDO_PAYGUBUN',
						inputValue: '1'
					},{
						boxLabel: '안한다',
						name: 'RDO_PAYGUBUN',
						inputValue: '2',
                        checked: true
					}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.getField('RDO_PAYGUBUN').setValue(newValue.RDO_PAYGUBUN);
						}
					}
            }]
    });
   
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
	var masterGrid = Unilite.createGrid('s_hum920skr_ygGrid1', {
       region: 'center',
        layout: 'fit',
        uniOpt:{	
        	expandLastColumn: false,	//마지막 컬럼 * 사용 여부
			useRowNumberer: true,		//첫번째 컬럼 순번 사용 여부
			useLiveSearch: true,		//찾기 버튼 사용 여부
			useRowContext: true,			
			onLoadSelectFirst	: true,
    		filter: {					//필터 사용 여부
				useFilter: true,
				autoCreate: true
			}
		},
        /*tbar: [{
        	xtype: 'splitbutton',
        	text: '이동...',
        	iconCls : 'icon-referance',
        	menu: Ext.create('Ext.menu.Menu',{
        		items: [{
        			itemId: 'defaultHumRegBtn',
        			text: '인사기본자료등록',
        			handler: function() {
        				if (masterGrid.getSelectionModel().hasSelection()) {
						   var person_numb = masterGrid.getSelectionModel().getSelection()[0].get('PERSON_NUMB');
						}
        				var params = {
								'PERSON_NUMB' : person_numb
   						}
   						var rec = {data : {prgID : 'hum100ukr', 'text':'인사기본자료등록'}};							
   						parent.openTab(rec, '/human/hum100ukr.do', params);	
   						// srq100ukrv의 fnInitBinding(params)에서 처리되도록 구현되어야 함. (cmb200ukrv.jsp 참고)
					}
        		}]
        		
        	})
        }],*/
		features: [{
			id: 'masterGridSubTotal',
			ftype: 'uniGroupingsummary',
			showSummaryRow: false						
		},{
			id: 'masterGridTotal',
			ftype: 'uniSummary',
			showSummaryRow: false
		}],
		viewConfig: {
	        getRowClass: function(record, rowIndex, rowParams, store){
	        	var cls = '';
	        	
	          	if(record.get('GUBUN') == '2'){
					cls = 'x-change-cell_light';
				}
				return cls;
	        }
	    },
		store: directMasterStore1,
        columns: [
			{dataIndex: 'GUBUN',                width: 80, hidden:true},
			{dataIndex: 'DIV_CODE',				width: 120},
			//{dataIndex: 'DEPT_CODE',			width: 130},
			{dataIndex: 'DEPT_NAME',			width: 130},
			{dataIndex: 'POST_CODE',			width: 100},
			//{dataIndex: 'PERSON_CNT',			width: 100},
			
			{dataIndex: 'NAME',					width: 100},
			{dataIndex: 'REPRE_NUMB_EXPOS',      width: 100 , hidden: true},
			{dataIndex: 'REPRE_NUMB',            width: 100},
			{dataIndex: 'PERSON_NUMB',			width: 100 },
			{dataIndex: 'JOIN_DATE',			width: 100 },
			{dataIndex: 'ABIL_CODE',			width: 100 },
			{dataIndex: 'JOB_CODE',			    width: 100 },
			{dataIndex: 'TELEPHON',			    width: 130 },
			{dataIndex: 'PHONE_NO',		        width: 130 },
			{dataIndex: 'EMAIL_ADDR',			width: 200 },
			{dataIndex: 'KOR_ADDR',			    width: 200 },
			{dataIndex: 'WEDDING_DATE',			width: 100 },
			{dataIndex: 'BIRTH_DATE',			width: 110 },
			{dataIndex: 'RETR_DATE',			width: 100 }
			
			
        ],
        listeners: {
        	onGridDblClick:function(grid, record, cellIndex, colName, td)   {
                    if (colName =="REPRE_NUMB") {
                        grid.ownerGrid.openRepreNumPopup(record);
                    }   
            },
			itemmouseenter:function(view, record, item, index, e, eOpts )	{          		
	        	view.ownerGrid.setCellPointer(view, item);
        	}
        },
        openRepreNumPopup:function( record )    {
            if(record)  {
                var params = {'REPRE_NUM': record.get('REPRE_NUMB_EXPOS'), 'GUBUN_FLAG': '3', 'INPUT_YN': 'N'}
                Unilite.popupCipherComm('grid', record, 'REPRE_NUMB', 'REPRE_NUMB_EXPOS', params);
            }
                
        },
        onItemcontextmenu:function( menu, grid, record, item, index, event  )	{          		
      		//menu.showAt(event.getXY());
        	if(record.get("GUBUN") == '1'){
      			return true;
        	}
      	},
      	uniRowContextMenu:{
			items: [
	            {	text	: '인사기본자료등록 보기',   
	            	handler	: function(menuItem, event) {
	            		var param = menuItem.up('menu');
	            		masterGrid.gotoHum920skr(param.record);
	            	}
	        	}
	        ]
	    },
	    gotoHum920skr:function(record)	{
			if(record)	{
		    	var params = {
		    		action:'select',
			    	'PGM_ID' 			: 's_hum920skr_yg',
			    	'PERSON_NUMB' 		:  record.data['PERSON_NUMB'],					/* gsParam(0) */
			    	'NAME' 				:  record.data['NAME'],							/* gsParam(1) */
			    	'COMP_CODE' 		:  UserInfo.compCode							/* gsParam(2) */
			    	/*'DOC_ID'			:  record.data['DOC_ID'] */ 						/* gsParam(3) */
			    	
		    	}
		    	var rec1 = {data : {prgID : 'hum100ukr', 'text':''}};							
				parent.openTab(rec1, '/human/hum100ukr.do', params);	    	
			}
    	}
    });
   
   
    Unilite.Main( {
		borderItems:[{
         region:'center',
         layout: 'border',
         border: false,
         items:[
            	masterGrid, panelResult
	     	]
	     },
	         panelSearch
	    ], 
      id  : 's_hum920skr_ygApp',
      fnInitBinding : function() {
         panelSearch.setValue('DIV_CODE',UserInfo.divCode);
         UniAppManager.setToolbarButtons('detail',true);
         UniAppManager.setToolbarButtons('reset',false);
         /*Ext.getCmp('PAY_GU2').setVisible(false);*/
         
         /*if(!Ext.isEmpty(gsCostPool)){
			panelSearch.getField('COST_POOL').setFieldLabel(gsCostPool);  
		 }*/
      },
      onQueryButtonDown : function()   {         
         masterGrid.getStore().loadStoreRecords();
      }
   });

    
    // 최초 입사일의 표시 /숨김 적용
    /*function checkVisibleOriJoinDate(newValue) {
    	//var value = Ext.getCmp('oriRadio').items.get(0).getGroupValue();
		if (newValue.ORI_JOIN_DATE == 'O') {
			masterGrid.getColumn('ORI_JOIN_DATE').setVisible(true);
			masterGrid.getColumn('ORI_YEAR_DIFF').setVisible(true);
		} else {
			masterGrid.getColumn('ORI_JOIN_DATE').setVisible(false);
			masterGrid.getColumn('ORI_YEAR_DIFF').setVisible(false);
		}
    }*/
    
    /*function checkVisible(newValue) {
    	//var value = Ext.getCmp('oriRadio').items.get(0).getGroupValue();
		if (newValue == '2') {
			
			Ext.getCmp('PAY_GU2').setVisible(true);
		} else {
			Ext.getCmp('PAY_GU2').setVisible(false);
		}
    }*/

};


</script>