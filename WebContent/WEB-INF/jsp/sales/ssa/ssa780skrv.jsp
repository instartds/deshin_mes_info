<%@page language="java" contentType="text/html; charset=utf-8"%>

<t:appConfig pgmId="ssa780skrv"  >
	<t:ExtComboStore comboType="BOR120"  pgmId="ssa780skrv"  /> 			<!-- 사업장 -->  
	<t:ExtComboStore comboType="AU" comboCode="S010" /> <!--영업담당 -->
	<t:ExtComboStore comboType="AU" comboCode="B056" /> <!-- 지역 -->    
	<t:ExtComboStore comboType="AU" comboCode="B055" /> <!-- 거래처분류 -->
	<t:ExtComboStore comboType="AU" comboCode="S007" /> <!--출고유형-->
	<t:ExtComboStore comboType="AU" comboCode="S024" /> <!--국내:부가세유형-->
	<t:ExtComboStore comboType="AU" comboCode="S118" /> <!--해외:부가세유형-->
	<t:ExtComboStore comboType="AU" comboCode="S002" /> <!--판매유형-->
	<t:ExtComboStore comboType="AU" comboCode="B020" /> <!--품목유형-->
	<t:ExtComboStore comboType="AU" comboCode="S003" /> <!--단가구분-->
	<t:ExtComboStore comboType="AU" comboCode="B031"  opts= '1;5'/> <!--생성경로-->
	<t:ExtComboStore comboType="AU" comboCode="B059" /> <!--과세여부-->
	<t:ExtComboStore comboType="AU" comboCode="S024" /> <!--부가세유형-->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" />
</t:appConfig>

<script type="text/javascript" >

function appMain() {
	/**
	 *   Model 정의 
	 * @type 
	 */	    			
	Unilite.defineModel('ssa780skrvModel1', {
	    fields: [
	    	{name: 'COMP_CODE'	    	,text: 'COMP_CODE'	,type: 'string'},
	    	{name: 'DIV_CODE'	    	,text: '<t:message code="system.label.sales.division" default="사업장"/>'		,type: 'string'},
	    	{name: 'TEAM_CODE'	    	,text: '팀코드'		,type: 'string'},
	    	{name: 'TEAM_NAME'	    	,text: '팀명'		,type: 'string'},
	    	{name: 'DEPT_CODE'	    	,text: '<t:message code="system.label.sales.department" default="부서"/>'	,type: 'string'},
	    	{name: 'DEPT_NAME'	    	,text: '<t:message code="system.label.sales.departmentname" default="부서명"/>'	,type: 'string'},
	    	{name: 'DAILY_SALE_AMT'	    ,text: '일일매출'	,type: 'uniPrice'},
	    	{name: 'WEEKLY_SALE_AMT'	,text: '주별누계'	,type: 'uniPrice'},
	    	{name: 'MONTHLY_SALE_AMT'	,text: '월별누계'	,type: 'uniPrice'},
	    	{name: 'REMARK'	    		,text: '<t:message code="system.label.sales.remarks" default="비고"/>'		,type: 'string'}	 
		]
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('ssa780skrvMasterStore1',{
		model: 'ssa780skrvModel1',
		uniOpt: {
        	isMaster: true,			// 상위 버튼 연결 
        	editable: false,			// 수정 모드 사용 
        	deletable: false,			// 삭제 가능 여부 
            useNavi: false			// prev | next 버튼 사용
        },
        autoLoad: false,
        proxy: {
            type: 'direct',
            api: {			
            	   read: 'ssa780skrvService.selectList1'                	
            }
        }
		,loadStoreRecords: function()	{			
			var param= Ext.getCmp('searchForm').getValues();
			var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
			var deptCode = UserInfo.deptCode;	//부서코드
			if(authoInfo == "5" && Ext.isEmpty(panelSearch.getValue('DEPT_CODE'))){
				param.DEPT_CODE = deptCode;
			}
			console.log( param );
			this.load({
				params: param
			});			
		},
		groupField: 'DEPT_NAME'
	});
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {          
		title: '<t:message code="system.label.sales.searchconditon" default="검색조건"/>',         
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
			title: '<t:message code="system.label.sales.basisinfo" default="기본정보"/>',   
			itemId: 'search_panel1',
			layout: {type: 'vbox', align: 'stretch'},
        	items: [{	
        		xtype: 'container',
        		layout: {type: 'uniTable', columns:1},
        		items: [{
        			fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
        			name: 'DIV_CODE',
        			xtype: 'uniCombobox',
        			comboType: 'BOR120',
        			allowBlank: false,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('DIV_CODE', newValue);
						}
					}
        		},{
					fieldLabel: '매출일자',
					name: 'BASIS_DAY',
					xtype: 'uniDatefield',
					value: new Date(),
					holdable: 'hold',
					allowBlank: false,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('BASIS_DAY', newValue);
						}
					}
				},
				Unilite.popup('DEPT', { 
					fieldLabel: '<t:message code="system.label.sales.department" default="부서"/>', 
					valueFieldName: 'DEPT_CODE',
			   	 	textFieldName: 'DEPT_NAME',
					
					holdable: 'hold',
					listeners: {
						onSelected: {
							fn: function(records, type) {
								panelResult.setValue('DEPT_CODE', panelSearch.getValue('DEPT_CODE'));
								panelResult.setValue('DEPT_NAME', panelSearch.getValue('DEPT_NAME'));
		                	},
							scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('DEPT_CODE', '');
							panelResult.setValue('DEPT_NAME', '');
						},
						applyextparam: function(popup){							
							var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
							var deptCode = UserInfo.deptCode;	//부서정보
							var divCode = '';					//사업장
							
							if(authoInfo == "A"){	//자기사업장	
								popup.setExtParam({'DEPT_CODE': ""});
								popup.setExtParam({'DIV_CODE': UserInfo.divCode});
								
							}else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){	//전체권한
								popup.setExtParam({'DEPT_CODE': ""});
								popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
								
							}else if(authoInfo == "5"){		//부서권한
								popup.setExtParam({'DEPT_CODE': UserInfo.deptCode});
								popup.setExtParam({'DIV_CODE': UserInfo.divCode});
							}
						}
					}
				})]	
			}]	            			 
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
   						var labelText = invalid.items[0]['fieldLabel']+' : ';
   					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
   						var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
   					}

				   	Unilite.messageBox(labelText+'<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
				   	invalid.items[0].focus();
				}
	  		}
			return r;
  		}
	});
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{
    			fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
    			name: 'DIV_CODE',
    			xtype: 'uniCombobox',
    			comboType: 'BOR120',
    			allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('DIV_CODE', newValue);
					}
				}
    		},{
				fieldLabel: '매출일자',
				name: 'BASIS_DAY',
				xtype: 'uniDatefield',
				value: new Date(),
				holdable: 'hold',
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('BASIS_DAY', newValue);
					}
				}
			},
			Unilite.popup('DEPT', { 
				fieldLabel: '<t:message code="system.label.sales.department" default="부서"/>', 
				valueFieldName: 'DEPT_CODE',
		   	 	textFieldName: 'DEPT_NAME',
				
				holdable: 'hold',
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('DEPT_CODE', panelResult.getValue('DEPT_CODE'));
							panelSearch.setValue('DEPT_NAME', panelResult.getValue('DEPT_NAME'));
	                	},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('DEPT_CODE', '');
						panelSearch.setValue('DEPT_NAME', '');
					},
					applyextparam: function(popup){							
						var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
						var deptCode = UserInfo.deptCode;	//부서정보
						var divCode = '';					//사업장
						
						if(authoInfo == "A"){	//자기사업장	
							popup.setExtParam({'DEPT_CODE': ""});
							popup.setExtParam({'DIV_CODE': UserInfo.divCode});
							
						}else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){	//전체권한
							popup.setExtParam({'DEPT_CODE': ""});
							popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
							
						}else if(authoInfo == "5"){		//부서권한
							popup.setExtParam({'DEPT_CODE': UserInfo.deptCode});
							popup.setExtParam({'DIV_CODE': UserInfo.divCode});
						}
					}
				}
			})]	
    });
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('ssa780skrvGrid1', {
    	// for tab
    	region: 'center',
        //layout: 'fit',    
		syncRowHeight: false,  
		uniOpt: {
		 	expandLastColumn: true,
		 	useRowNumberer: false,
		 	useContextMenu: true
        }, 
    	store: directMasterStore1,
    	features: [ {id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	           	{id: 'masterGridTotal', 	ftype: 'uniSummary',  showSummaryRow: false} ],
        columns:  [ 
        			{ dataIndex: 'TEAM_CODE'	    			,		   	width: 80, locked: true}, 	
					{ dataIndex: 'TEAM_NAME'	    			,		   	width: 180, locked: true},
               		{ dataIndex: 'DEPT_CODE'	    			,		   	width: 80, locked: true}, 	
					{ dataIndex: 'DEPT_NAME'	    			,		   	width: 180, locked: true,
						summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
		              	return Unilite.renderSummaryRow(summaryData, metaData, '', '<t:message code="system.label.sales.total" default="총계"/>');
                    }}, 	
					{ dataIndex: 'DAILY_SALE_AMT'	    		,		   	width: 150, summaryType: 'sum'}, 	
					{ dataIndex: 'WEEKLY_SALE_AMT'				,		   	width: 150, summaryType: 'sum'}, 	
					{ dataIndex: 'MONTHLY_SALE_AMT'				,		   	width: 150, summaryType: 'sum'}, 	
					{ dataIndex: 'REMARK'	    				,		   	width: 100}
					
          ] 
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
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
//			panelSearch.setValue('DEPT_CODE', UserInfo.deptCode);
//        	panelSearch.setValue('DEPT_NAME', UserInfo.deptName);
        	panelSearch.setValue('BASIS_DAY', UniDate.get('today'));
        	
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
//        	panelResult.setValue('DEPT_CODE', UserInfo.deptCode);
//        	panelResult.setValue('DEPT_NAME', UserInfo.deptName);
        	panelResult.setValue('BASIS_DAY', UniDate.get('today'));			
		},
		onQueryButtonDown: function()	{
			if(!panelSearch.setAllFieldsReadOnly(true)){
	    		return false;
	    	}
			directMasterStore1.loadStoreRecords();				
			
			var viewLocked = masterGrid.lockedGrid.getView();
			var viewNormal = masterGrid.normalGrid.getView();
			viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
			viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
			viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
			viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);			
	
		},		
		onDetailButtonDown: function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.getStore().loadData({})
			this.fnInitBinding();			
		}
	});

};


</script>
