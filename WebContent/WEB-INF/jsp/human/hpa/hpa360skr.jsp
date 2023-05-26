<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hpa360skr"  >
		<t:ExtComboStore comboType="AU" comboCode="H024" />								<!-- 사원구분 -->
		<t:ExtComboStore comboType="AU" comboCode="H031" /> 							<!-- 지급차수 -->
		<t:ExtComboStore comboType="BOR120"  />											<!-- 사업장 --> 
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {
	
//	colData = ${colData};
//	var fields	= createModelField(colData);
//	var columns	= createGridColumn(colData);
//	var	getCostPoolName = ${getCostPoolName};

		
	/* Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Hpa360skrModel', {		
	    fields: [{name: 'DIV_NAME'   		,text: '사업장' 		,type: 'string'},	    		
				 {name: 'DEPT_NAME'   	 	,text: '부서' 		,type: 'string'},	    		
				 {name: 'POST_NAME'   	 	,text: '직위' 		,type: 'string'},	    		
				 {name: 'ABIL_NAME'	 		,text: '직책' 		,type: 'string'},	    		
				 {name: 'NAME'   			,text: '성명' 		,type: 'string'},	    		
				 {name: 'PERSON_NUMB'  		,text: '사번' 		,type: 'string'},	    		
				 {name: 'JOIN_DATE'   	 	,text: '입사일자' 		,type: 'uniDate'}, 
				 {name: 'AMOUNT_I'   	 	,text: '통상임금' 		,type: 'uniPrice'}, 
				 {name: 'AMOUNT_COST'   	,text: '시간외단가' 		,type: 'uniPrice'}, 
				 {name: 'REMARK'   	 		,text: '비고' 		,type: 'string'}
		]
	});
	
	/* Store 정의(Service 정의)
	 * @type 
	 */					
	var masterStore = Unilite.createStore('hpa360skrMasterStore',{
		model: 'Hpa360skrModel',
		uniOpt: {
           	isMaster	: true,				// 상위 버튼 연결 
            editable	: false,			// 수정 모드 사용 
            deletable	: false,			// 삭제 가능 여부 
	        useNavi		: false				// prev | newxt 버튼 사용
	            	
        },
        autoLoad: false,
        proxy: {
            type: 'direct',
            api: {			
                read: 'hpa360skrService.selectList'                	
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

	/* 검색조건 (Search Panel)
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
    			fieldLabel: '급여년월',
    			name:'DATE',
				xtype: 'uniMonthfield',
				value: UniDate.get('today'),
				allowBlank:false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DATE', newValue);
					}
				}
			},{
		        fieldLabel: '사업장',
			    name:'DIV_CODE', 
			    xtype: 'uniCombobox',
				multiSelect: false, 
				typeAhead: false,
				value:UserInfo.divCode,
				comboType:'BOR120',
			    listeners: {
			      change: function(field, newValue, oldValue, eOpts) {      
			       panelResult.setValue('DIV_CODE', newValue);
			      }
	     		}
			},{
                fieldLabel: '지급차수',
                name:'PAY_FLAG', 	
                xtype: 'uniCombobox',
                comboType:'AU',
                comboCode:'H031',
			    listeners: {
			    	change: function(field, newValue, oldValue, eOpts) {      
			    		panelResult.setValue('PAY_FLAG', newValue);
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
//				textFieldWidth:89,
				textFieldWidth: 159,
				validateBlank:true,
//				width:300,
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
			}),{
                fieldLabel: '사원구분',
                name:'EMPLOY_TYPE', 	
                xtype: 'uniCombobox',
                comboType:'AU',
                comboCode:'H024',
			    listeners: {
			    	change: function(field, newValue, oldValue, eOpts) {      
			    		panelResult.setValue('EMPLOY_TYPE', newValue);
			    	}
	     		}
            },
		      	Unilite.popup('Employee',{
		      	fieldLabel : '사원',
			    valueFieldName:'PERSON_NUMB',
			    textFieldName:'NAME',
//			    validateBlank: false,
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

	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
		layout : {type : 'uniTable', columns : 3
//		,tableAttrs: {style: 'border : 1px solid #ced9e7;'/*, width: '100%'*/},
//			tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
		},
		padding:'1 1 1 1',
		border:true,
		items: [{ 
			fieldLabel: '급여년월',
			name:'DATE',
			xtype: 'uniMonthfield',
			value: UniDate.get('today'),
			allowBlank:false,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('DATE', newValue);
				}
			}
		},{
	        fieldLabel: '사업장',
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
            fieldLabel: '지급차수',
            name:'PAY_FLAG', 	
            xtype: 'uniCombobox',
            comboType:'AU',
            comboCode:'H031',
		    listeners: {
		    	change: function(field, newValue, oldValue, eOpts) {      
					panelSearch.setValue('PAY_FLAG', newValue);
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
//			textFieldWidth:89,
			textFieldWidth: 159,
			validateBlank:true,
//			width:300,
			autoPopup:true,
			useLike:true,
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
		}),{
            fieldLabel: '사원구분',
            name:'EMPLOY_TYPE', 	
            xtype: 'uniCombobox',
            comboType:'AU',
            comboCode:'H024',
		    listeners: {
		    	change: function(field, newValue, oldValue, eOpts) {      
		    		panelSearch.setValue('EMPLOY_TYPE', newValue);
		    	}
     		}
        },
	      	Unilite.popup('Employee',{
	      	fieldLabel : '사원',
		    valueFieldName:'PERSON_NUMB',
		    textFieldName:'NAME',
			colspan: 2,
//			validateBlank: false,
			listeners: {
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('PERSON_NUMB', panelResult.getValue('PERSON_NUMB'));
						panelSearch.setValue('NAME', panelResult.getValue('NAME'));	
					},
					scope: this
				},
				onClear: function(type)	{
					panelSearch.setValue('PERSON_NUMB', '');
					panelSearch.setValue('NAME', '');
				}
			}
  		})]
	});

	/* Master Grid 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('hpa360skrGrid1', {
    	region		: 'center',
    	store: masterStore,
        selModel	: 'rowmodel',
        uniOpt: {
			useMultipleSorting	: true,
    		useLiveSearch		: true,
    		dblClickToEdit		: false,
    		onLoadSelectFirst	: false, 
    		useGroupSummary		: false,
			useContextMenu		: false,
			useRowNumberer		: false,
			expandLastColumn	: false,
    		filter: {
				useFilter		: false,
				autoCreate		: false
			}
        },
        features: [{
        	id: 'masterGridSubTotal',
        	ftype: 'uniGroupingsummary', 
        	showSummaryRow: false 
        },{
	        id: 'masterGridTotal', 	
	        ftype: 'uniSummary', 
	        showSummaryRow: false
        }],
        columns:  [ { dataIndex:'DIV_NAME'     		 , width: 130},
					{ dataIndex:'DEPT_NAME'    		 , width: 130},
					{ dataIndex:'POST_NAME'    		 , width: 100},
					{ dataIndex:'ABIL_NAME'	   		 , width: 100},
					{ dataIndex:'NAME'   		  	 , width: 100},
					{ dataIndex:'PERSON_NUMB'  		 , width: 130},
					{ dataIndex:'JOIN_DATE'    		 , width: 130},
					{ dataIndex:'AMOUNT_I'     		 , width: 130},
					{ dataIndex:'AMOUNT_COST'  		 , width: 130},
					{ dataIndex:'REMARK'   	   		 , width: 300}
        ],
    	viewConfig: {
	        getRowClass: function(record, rowIndex, rowParams, store){
	        	var cls = '';
	        	
	          	if(record.get('GUBUN') == '3'){
					cls = 'x-change-cell_dark';
				} else if(record.get('GUBUN') == '2') {
					cls = 'x-change-cell_normal';
				}
				return cls;
	        }
	    }
    });      
	
	Unilite.Main( {
	 	border: false,
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid, panelResult
			]	
		}		
		,panelSearch
		], 
		id : 'hpa360skrApp',
		fnInitBinding : function() {
			panelSearch.setValue('DATE', UniDate.get('today'));
			panelResult.setValue('DATE', UniDate.get('today'));
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);

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
				masterGrid.reset();
				masterStore.clearData();
				masterGrid.getStore().loadStoreRecords();
				UniAppManager.setToolbarButtons('reset',true);
			}
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.reset();
			masterStore.clearData();
			this.fnInitBinding();
		},
		onSaveAsExcelButtonDown :function() {
			masterGrid.downloadExcelXml(false, '타이틀');
			masterGrid.getStore().groupField = null;
			masterGrid.getStore().load();
		},
		onPrintButtonDown : function() {
			//do something!!
		}
	});
};
</script>
