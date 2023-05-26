<%@page language="java" contentType="text/html; charset=utf-8"%>
<%
//인사기본자료등록
request.setAttribute("PKGNAME","Unilite_app_gac100ukrv");
%>
<t:appConfig pgmId="gac100ukr"  >
<t:ExtComboStore comboType="BOR120" />
	<t:ExtComboStore items="${ROUTE_COMBO}" storeId="routeStore" /> <!-- 노선 -->
	<t:ExtComboStore comboType="AU" comboCode="GA01" /><!-- 접수자구분 -->
	<t:ExtComboStore comboType="AU" comboCode="GA02" /><!-- 날씨 -->
	<t:ExtComboStore comboType="AU" comboCode="GA03" /><!-- 노면 -->
	<t:ExtComboStore comboType="AU" comboCode="GA04" /><!-- 사고구분 -->
	<t:ExtComboStore comboType="AU" comboCode="GA05" /><!-- 사고유형 -->
	<t:ExtComboStore comboType="AU" comboCode="GA06" /><!-- 도로종류 -->
	<t:ExtComboStore comboType="AU" comboCode="GA07" /><!-- 도로형태 -->
	<t:ExtComboStore comboType="AU" comboCode="GA08" /><!-- 사고구간 -->
	<t:ExtComboStore comboType="AU" comboCode="GA09" /><!-- 발생원인 -->
	<t:ExtComboStore comboType="AU" comboCode="GA10" /><!-- 사고장소구분 -->
	<t:ExtComboStore comboType="AU" comboCode="GA11" /><!-- 과실 -->
	<t:ExtComboStore comboType="AU" comboCode="GA12" /><!-- 보험사 -->
	<t:ExtComboStore comboType="AU" comboCode="GA13" /><!-- 관할서 -->
	<t:ExtComboStore comboType="AU" comboCode="GA14" /><!-- 대인구분 -->
	<t:ExtComboStore comboType="AU" comboCode="GA25" /><!-- 성별 -->
	<t:ExtComboStore comboType="AU" comboCode="GA15" /><!-- 형태 -->
	<t:ExtComboStore comboType="AU" comboCode="GA16" /><!-- 상해정도 -->
	<t:ExtComboStore comboType="AU" comboCode="GA17" /><!-- 대물구분 -->
	<t:ExtComboStore comboType="AU" comboCode="GA18" /><!-- 피해구분 -->
	<t:ExtComboStore comboType="AU" comboCode="GA19" /><!-- 차량구분 -->
	<t:ExtComboStore comboType="AU" comboCode="GA20" /><!-- 용도 -->
	<t:ExtComboStore comboType="AU" comboCode="GA21" /><!-- 입금방법 -->
	<t:ExtComboStore comboType="AU" comboCode="GA22" /><!-- 합의자 -->
	<t:ExtComboStore comboType="AU" comboCode="GA23" /><!-- 처리방법 -->
	<t:ExtComboStore comboType="AU" comboCode="GA24" /><!-- 구상처 -->
	<t:ExtComboStore comboType="AU" comboCode="A020" /><!--  예/아니오 -->
	
</t:appConfig>

<script type="text/javascript" >
var uploadWin;
function appMain() {

	/**
	 * Model 정의 
	 * @type 
	 */
	
	Unilite.defineModel('gac100ukrModel', {
	    fields: [
	    			{name: 'COMP_CODE',			text: '법인코드',		type: 'string'},
					{name: 'DIV_CODE',			text: '사업장',			type: 'string'},
					{name: 'ACCIDENT_NUM',		text: '사고번호',		type: 'string'},
					{name: 'ACCIDENT_DATE',		text: '사고일',			type: 'string'},
					{name: 'ACCIDENT_TIME',		text: '사고시간',		type: 'string',convert:convertTime},					
					
					{name: 'VEHICLE_REGIST_NO',	text: '차량등록명',			type: 'string'},
					{name: 'VEHICLE_NAME',		text: '차량명',			type: 'string'},
					{name: 'DRIVER_CODE',		text: '사번',			type: 'string'}, 
					{name: 'DRIVER_NAME',		text: '기사명',			type: 'string'}, 
					{name: 'ROUTE_CODE',		text: '노선코드',		type: 'string'},	
					{name: 'ROUTE_NUM',			text: '노선',		type: 'string'},	
					{name: 'ACCIDENT_DIV',		text: '사고구분',		type: 'string',comboType:'AU', comboCode:'GA04'},
					{name: 'ACCIDENT_DIV_NAME',	text: '사고구분',		type: 'string'},
					
					{name: 'ACCIDENT_TYPE',		text: '사고유형',		type: 'string',comboType:'AU', comboCode:'GA05'},
					{name: 'ACCIDENT_TYPE_NAME',text: '사고유형',		type: 'string'},
					{name: 'MANAGE_DATE',		text: '처리일',			type: 'string'},
					{name: 'MANAGE_DIV',		text: '처리결과',		type: 'string' ,comboType:'AU', comboCode:'GA23'},
					{name: 'MANAGE_DIV_NAME',	text: '처리결과',		type: 'string'},
					{name: 'ACCIDENT_PLACE',	text: '장소',			type: 'string'},
					
					{name: 'REGIST_DATE',		text: '접수일',			type: 'string'},
					{name: 'REGIST_PERSON_TYPE',text: '접수구분',		type: 'string',comboType:'AU', comboCode:'GA01'},
					{name: 'REGIST_PERSON',		text: '접수자',			type: 'string'},
					{name: 'SPECIAL_FEATURE',	text: '특이사항',		type: 'string'},
					
					{name: 'DIV_CODE',			text: '사업장',			type: 'string'},	
					{name: 'COMP_CODE',			text: '법인코드',		type: 'string'},	
					{name: 'REMARK',			text: '비고',			type: 'string'}	
			]
	});	
	function convertTime( value, record )	{
		value = value.replace(/:/g, "");
		var r = '';
		if(value.length == 6 ){
			r = value.substring(0,2)+":"+value.substring(2,4)+":"+value.substring(4,6);
		} else if(value.length == 4 ){
			r = value.substring(0,2)+":"+value.substring(2,4);
		}
		return r;
	}
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var searchPanelStore = Unilite.createStore('gac100ukrMasterStore',{
			model: 'gac100ukrModel',
            autoLoad: false,
            uniOpt : {
            	isMaster: false,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
            
            proxy: {
                type: 'direct',
                api: {
                	   read : 'gac100ukrvService.selectList'
                }
            }  // proxy            
			// Store 관련 BL 로직
            // 검색 조건을 통해 DB에서 데이타 읽어 오기 
			,loadStoreRecords : function(accidentNum)	{
				var param= panelSearch.getValues();			
				//console.log( param );
				var me = this;
				this.load({
					params : param,
					callback: function(records, operation, success) {
				        if (success) {
				        	if(accidentNum)	{
				        		var index = searchPanelStore.find('ACCIDENT_NUM', accidentNum);
				        		textList.select(index);
				        		masterGrid.select(index);
				        	}
				        }
					}
				});
			}
			,loadDetailForm: function(node)	{
				var activeTab = panelDetail.getActiveTab();
				if(node != null && !Ext.isEmpty(node.get('ACCIDENT_NUM')))	{;
					var param ={
						'DIV_CODE' : node.get('DIV_CODE'),
						'ACCIDENT_NUM' : node.get('ACCIDENT_NUM')
					}
					console.log("param:", param);
					activeTab.loadData(param);	            	
					panelDetail.getEl().unmask();						
				}
				UniAppManager.app.setToolbarButtons('save',false);	
			}
            
		});	
	

	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var textList = Ext.create('Ext.view.View', {
		itemId:'imageList',
		store: searchPanelStore,  
		tpl: [
            '<tpl for=".">',
                '<div class="listItem" style="border: 1px soild blue !important; width:305px;">',
                	'<tpl if="ACCIDENT_DIV != \'001\'">',
                    	'<div class="listItem-div-out-blue"><div class="listItem-div-title-blue">{DRIVER_NAME} {VEHICLE_REGIST_NO} ({ROUTE_NUM})</div>',
                    '</tpl>',
                    '<tpl if="ACCIDENT_DIV == \'001\'">',
	                    '<div class="listItem-div-out-orange"><div class="listItem-div-title-orange">{DRIVER_NAME} {VEHICLE_REGIST_NO} ({ROUTE_NUM})',
		                    '<tpl if="MANAGE_DIV_NAME != \'\'">',
			                    '- {MANAGE_DIV_NAME}',
		                    '</tpl>',
		    	                '<tpl if="MANAGE_DATE != \'\'">',
		                    '({MANAGE_DATE})',
		                    '</tpl>',
	                    '</div>',
                    '</tpl>',
                    '<div class="listItem-div-contents">{ACCIDENT_DATE} {ACCIDENT_TIME} {ACCIDENT_TYPE_NAME}/{ACCIDENT_DIV_NAME}<br>',
                    '{ACCIDENT_PLACE}&nbsp;</div></div>',
                    
                '</div>',
            '</tpl>',
            '<div class="x-clear"></div>'
        ],        
//        this.down('#EmpImg').getEl().dom.src=CPATH+'/human/viewPhoto.do?personNumb='+data['PERSON_NUMB'];
        trackOver: true,
        frame:true,
        overItemCls: 'listItem-over',
        selectedItemCls : 'listItem-selected',
        itemSelector: 'div.listItem',
        
        listeners: {
            selectionchange: function( model, nodes, eOpts ){   
            	var me = this;
            	if(!Ext.isEmpty(nodes))	{
            		var config = {
            			success : function()	{
							panelSearch.down('#imageList').dataSelect(nodes[0]);
							
						}
					};
					var activeTab = panelDetail.getActiveTab();
					if(UniAppManager.app.checkSave(config, activeTab))	{
						me.dataSelect(nodes[0]);
					}
            	}
            }
        }
        ,dataSelect:function(node)	{
        	var me = this;
        	if(me.isVisible())	{
        		me.getStore().loadDetailForm(node);
        	}
	        panelSearch.down('#textList').getSelectionModel().select(node);
        }
	});
	
	var masterGrid = Unilite.createGrid('gac100ukrGrid', {
		itemId:'textList',
		border:0,
        store : searchPanelStore, 
        uniOpt:{	expandLastColumn: false,
        			useRowNumberer: false,
                    useMultipleSorting: false,
                    onLoadSelectFirst: false
        },
        hidden:true,
        columns:  [     
               		{ dataIndex: 'ACCIDENT_DATE'	,width: 80 }, 
               		{ dataIndex: 'ACCIDENT_TIME'	,width: 80 }, 
               		{ dataIndex: 'DRIVER_CODE'	,width: 60 },
               		{ dataIndex: 'DRIVER_NAME'	,width: 60 },
               		
					{ dataIndex: 'VEHICLE_REGIST_NO' 		,width: 100 }, 
					{ dataIndex: 'ROUTE_CODE'	,width: 80 },
					{ dataIndex: 'ACCIDENT_DIV'	,width: 80 },
					{ dataIndex: 'ACCIDENT_TYPE'	,width: 80 },
					{ dataIndex: 'ACCIDENT_PLACE'	,width: 80 },
					{ dataIndex: 'REGIST_DATE'	,width: 80 },
					{ dataIndex: 'REGIST_PERSON_TYPE'	,width: 80 },
					{ dataIndex: 'REGIST_PERSON'	,width: 80 },
					{ dataIndex: 'SPECIAL_FEATURE'	,width: 80 }
				  ],
		listeners: {
            selectionchange: function(grid, selNodes ){ 
            	var me = this;
            	var config = {success : function()	{
												panelSearch.down('#textList').dataSelect(selNodes[0]);
											}
									 };
				var activeTab = panelDetail.getActiveTab();
            	if(UniAppManager.app.checkSave(config, activeTab))	{
            		me.dataSelect(selNodes[0]);
            	}
            }
        },
        dataSelect:function(node)	{
        	var me = this;
        	if(me.isVisible())	{
        		me.getStore().loadDetailForm(node);
        	}
	        panelSearch.down('#imageList').getSelectionModel().select(node);
	        
        }
	});
		

	var panelSearch = Unilite.createSearchPanel('${PKGNAME}searchForm',{
		title: '검색조건',
        defaultType: 'uniSearchSubPanel',
        defaults: {
			autoScroll:true
	  	},
        width: 330,
		items: [{	
					title: '기본정보', 	
					id: 'search_panel1',
		   			itemId: 'search_panel1',
		           	layout: {type: 'uniTable', columns: 1},
		           	defaultType: 'uniTextfield',   			
			    	items:[{	    
						fieldLabel: '사업장',
						name: 'DIV_CODE',
						xtype:'uniCombobox',
						comboType:'BOR120',
						value: UserInfo.divCode,
						allowBlank:false,
						listeners:{
							change:function(field, newValue, oldValue)	{
								var driverPopup = panelSearch.down('#driver');
							 	driverPopup.setExtParam({'DIV_CODE':newValue});
							 	var vehiclePopup = panelSearch.down('#vehicle');
							 	vehiclePopup.setExtParam({'DIV_CODE':newValue});
							}
						}
					},{	    
						fieldLabel: '사고일',
						name: 'ACCIDENT_DATE',
						xtype: 'uniDateRangefield',
			            startFieldName: 'ACCIDENT_DATE_FR',
			            endFieldName: 'ACCIDENT_DATE_TO',	
			            startDate: UniDate.get('startOfMonth'),
			            endDate: UniDate.get('endOfMonth'),
			            width:320
					},{	    
						fieldLabel: '사고구분',
						name: 'ACCIDENT_DIV',
						xtype:'uniCombobox'					
					},{	    
						fieldLabel: '처리구분',
						name: 'MANAGE_DIV'	,
						xtype:'uniCombobox'				
					},	    
					Unilite.popup('DRIVER',
				 	 {
				 	 	fieldLabel:'운전자',
				 		itemId:'driver',
				 		extParam:{'DIV_CODE': UserInfo.divCode},
				 		useLike:true,
				 		validateBlank:false
				 	 }
			 		)
			 		,Unilite.popup('VEHICLE',
						 {
						 	itemId:'vehicle',
						 	extParam:{'DIV_CODE': UserInfo.divCode}						  
						 }
					)
					,{	    
						fieldLabel: '대인성명',
						name: 'VICTIM_NAME'						
					},{	    
						fieldLabel: '대물차량',
						name: 'VEHICLE_DAMAGE'						
					}]
				
				},{
					itemId:'result',
			        border:0,
			        defaults:{autoScroll:true},
			        layout: {type: 'vbox', align:'stretch'},
			        flex:1,
			        tools: [{
								type: 'hum-grid',					            
					            handler: function () {
					            	textList.hide();
					                masterGrid.show();
					            }
			        		},{

								type: 'hum-photo',					            
					            handler: function () {
					                masterGrid.hide();
					                textList.show();
					            }
			        		}/*,{
								type: 'hum-tree',					            
					            handler: function () {
					                
					            }
			        		}*/
						
					],
			        items: [textList,masterGrid]
			}]
		
	});	//end panelSearch    
	
	
    
//기본정보
<%@include file="./gac100ukrv01.jsp" %> 
//대인내역
<%@include file="./gac110ukrv.jsp" %>
//대물내역
<%@include file="./gac120ukrv.jsp" %> 
//사진
<%@include file="./gac100ukrv02.jsp" %>

    var panelDetail = Ext.create('Ext.tab.Panel', {
    			region:'center',
		    	itemId: 'gac100Tab',
		    	activeGroup: 0,
		        collapsed :false,	
		        cls:'human-panel',
		       	defaults:{
	            			bodyCls: 'human-panel-form-background',
	            			disabled:false,
	            			autoScroll:true
	            		},	   
		                items: [
		                	detailAccident,		//기본정보
			            	peopleDamage, 		//대인내역
			            	propertyDamage, 	//대물내역
			            	photos 				//사진
			    		]
		        
		        ,listeners: {		       		
		       		afterrender: function( tabPanel, eOpts )	{
		       			//this.getEl().mask();
		       		},
		       		beforetabchange : function( tabPanel, newCard, oldCard, eOpts )	{	
		       			var record = masterGrid.getSelectedRecord();
		       			if(record) {
			       			if(Ext.isObject(oldCard))	{
			       			   var config = { 
			       			   		success : function()	{
			       			   			var tab = oldCard;
			       			   			tabPanel.setActiveTab(tab);
			       			   		}
			       			   }
			       			   var activeTab = panelDetail.getActiveTab();
					           if(!UniAppManager.app.checkSave(config, activeTab))	{
					           		return false
					           }
			       			}
		       			}else {
		       				alert('사고목록을 선택하세요.');
		       				return false;	
		       			}
		       			return true;
		       		},
		       		tabchange:function(tabPanel, newCard, oldCard, eOpts )	{
		       			var record = masterGrid.getSelectedRecord();
		       			if(record)	{
			           		var param ={
								'DIV_CODE' : record.get('DIV_CODE'),
								'ACCIDENT_NUM' : record.get('ACCIDENT_NUM')
							}
							newCard.loadData(param);	            	
							panelDetail.getEl().unmask();
		       			}
		       		}
		       }
	    	}
	  ); // detailForm
	
	
	
	
    Unilite.Main({
		borderItems:[
				 		  panelSearch
				 		 ,panelDetail
		],
		id  : 'gac100ukrApp',
		autoButtonControl : false,
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons(['reset', 'excel'],false);
			UniAppManager.setToolbarButtons(['newData','print'],true);
		},
		onQueryButtonDown : function()	{
			searchPanelStore.loadStoreRecords();
		},
		onNewDataButtonDown : function()	{
			var me = this;
			var activeTab = panelDetail.getActiveTab();
			activeTab.newData();	
		},
		
		onSaveDataButtonDown: function (config) {
			var me = this;
			var activeTab = panelDetail.getActiveTab();
			activeTab.saveData();	
			
		},
		onDeleteDataButtonDown : function()	{
			var activeTab = panelDetail.getActiveTab();
			if(activeTab.getItemId() == 'gac100ukrv01Form')	{
			
				return;
			}
			if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				var me = this;
				
				activeTab.deleteData();
			}
		},
		onResetButtonDown:function() {
			var me = this;
			
		},
		onPrintButtonDown: function() {
			var records = panelSearch.down('#imageList').getSelectionModel().getSelection();	
			if(!Ext.isEmpty(records) )	{
				var pPersonNumb = Ext.isArray(records)? records[0].get('PERSON_NUMB') : records.get('PERSON_NUMB')
	       		var win = Ext.create('widget.PDFPrintWindow', {
					url: CPATH+'/human/hum960rkrPrint.do',
					extParam: {
						PERSON_NUMB: pPersonNumb
					}
				});
				win.show();
   			}else if(Ext.isDefined(this.getEl()))	{
   				UniAppManager.app.onResetButtonDown();
   				alert('사원을 선택하세요.');
   				return false;
   			}
			
			
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		},
		onSaveAsExcelButtonDown: function() {
			masterGrid.downloadExcelXml();
		},
		
		checkSave:function(config, tab)	{
			var me = this;
			if( me._needSave() ) {
				if(confirm(Msg.sMB017 + "\n" + Msg.sMB061))	{					
					me.onSaveDataButtonDown(config);
					return false;
				}else {
					tab.rejectChanges();
					UniAppManager.setToolbarButtons('save',false);
				}
			}
			return true;
		},
		findInvalidField:function(formPanel)	{
			var r = true;
			var invalid = formPanel.getForm().getFields().filterBy(function(field) {
			            return !field.validate();
			    });
			if(invalid.length > 0)	{
	        	r=false;
	        	var labelText = ''
	        	
	        	if(Ext.isDefined(invalid.items[0]['fieldLabel']))	{
	        		var labelText = invalid.items[0]['fieldLabel']+'은(는)';
	        	}else if(Ext.isDefined(invalid.items[0].ownerCt))	{
	        		var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
	        	}
	        	alert(labelText+Msg.sMB083);
	        	invalid.items[0].focus();
	        }	
	        return r;
		}
	});	// Main

	
	
}; // main


</script>


