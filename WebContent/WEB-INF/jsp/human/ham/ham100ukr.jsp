<%@page language="java" contentType="text/html; charset=utf-8"%>
<%@ page import="foren.framework.utils.*" %>
<%
	String extjsVersion = ConfigUtil.getString("extjs.version", "4.2.2");
	request.setAttribute("ext_root", "extjs_"+extjsVersion);
%>
<t:appConfig pgmId="ham100ukr"  >
	<t:ExtComboStore comboType="AU" comboCode="H012" /><!--  입사코드       -->
	<t:ExtComboStore comboType="AU" comboCode="H024" /><!--  사원구분       --> 
	<t:ExtComboStore comboType="AU" comboCode="H028" /><!--  급여지급방식    -->
	<t:ExtComboStore comboType="AU" comboCode="H005" /><!--  직위구분       --> 
	<t:ExtComboStore comboType="AU" comboCode="H029" /><!--  세액구분       -->
	<t:ExtComboStore comboType="AU" comboCode="H031" /><!--  급여지급일구분   --> 
	<t:ExtComboStore comboType="AU" comboCode="H049" /><!--  월차지급방식     -->
	<t:ExtComboStore comboType="AU" comboCode="H037" /><!--  상여계산구분자   --> 
	<t:ExtComboStore comboType="AU" comboCode="H036" /><!--  잔업계산구분자   -->
	<t:ExtComboStore comboType="AU" comboCode="H006" /><!--  직책          --> 
	<t:ExtComboStore comboType="AU" comboCode="H009" /><!--  최종학력       -->
	<t:ExtComboStore comboType="AU" comboCode="H008" /><!--  담당업무       --> 	
	<t:ExtComboStore comboType="AU" comboCode="H010" /><!--  졸업구분       -->
	<t:ExtComboStore comboType="AU" comboCode="H023" /><!--  퇴사사유       --> 
	<t:ExtComboStore comboType="AU" comboCode="H017" /><!--  병역군별       -->
	<t:ExtComboStore comboType="AU" comboCode="H018" /><!--  병역계급       --> 
	<t:ExtComboStore comboType="AU" comboCode="H019" /><!--  병역병과       -->
	<t:ExtComboStore comboType="AU" comboCode="H016" /><!--  병역구분       --> 
	<t:ExtComboStore comboType="AU" comboCode="B012" /><!--  국가          --> 
	
	<t:ExtComboStore comboType="BOR120" />			   <!--  사업장        --> 
	<t:ExtComboStore comboType="AU" comboCode="B027" /><!--  제조판관       -->
	<t:ExtComboStore comboType="CBM600"/>   		   <!--  Cost Pool   -->
	<t:ExtComboStore items="${costPoolCombo}" storeId="costPoolCombo"/>           <!--  Cost Pool        --> 
	<t:ExtComboStore comboType="AU" comboCode="H011" opts='2'/><!--  고용형태       -->
	<t:ExtComboStore comboType="AU" comboCode="H007" /><!--  거주구분       --> 
	<t:ExtComboStore comboType="AU" comboCode="B004" /><!--  화폐단위       -->
	<t:ExtComboStore comboType="BILL_DIV"/>			   <!--  신고사업장      --> 	
	<t:ExtComboStore comboType="AU" comboCode="H112" /><!--  퇴직계산분류     -->
	<t:ExtComboStore comboType="AU" comboCode="H143" /><!--  양음구분     -->
	<t:ExtComboStore comboType="AU" comboCode="H144" /><!--  결혼여부     -->
	<t:ExtComboStore comboType="AU" comboCode="A020" /><!--  예/아니오     -->
	<t:ExtComboStore comboType="AU" comboCode="H020" /><!--  가족관계     -->
	
	<t:ExtComboStore comboType="AU" comboCode="H080" /><!--  혈액형      -->
	<t:ExtComboStore comboType="AU" comboCode="H081" /><!--  색맹여부     -->
	<t:ExtComboStore comboType="AU" comboCode="H082" /><!--  주거구분     -->
	<t:ExtComboStore comboType="AU" comboCode="H083" /><!--  생활수준     -->
	<t:ExtComboStore comboType="AU" comboCode="H084" /><!--  보훈구분     -->
	<t:ExtComboStore comboType="AU" comboCode="H085" /><!--  장애구분     -->
	<t:ExtComboStore comboType="AU" comboCode="H086" /><!--  종교        -->
	<t:ExtComboStore comboType="AU" comboCode="H163" /><!--  인정경력구분   -->
	<t:ExtComboStore comboType="AU" comboCode="H087" /><!--  전공학과      -->
	
	<t:ExtComboStore comboType="AU" comboCode="H089" /><!--  교육기관      -->
	<t:ExtComboStore comboType="AU" comboCode="H090" /><!--  교육국가      -->
	<t:ExtComboStore comboType="AU" comboCode="H091" /><!--  구분         -->
	<t:ExtComboStore comboType="AU" comboCode="H022" /><!--  자격종류      -->
	<t:ExtComboStore comboType="AU" comboCode="H022" /><!--  자격종류      -->
	
	<t:ExtComboStore comboType="AU" comboCode="H094" /><!--  발령코드      -->
	<t:ExtComboStore comboType="AU" comboCode="H095" /><!--  고과구분      -->
	<t:ExtComboStore comboType="AU" comboCode="H096" /><!--  상벌종류      -->
	<t:ExtComboStore comboType="AU" comboCode="H164" /><!--  계약구분      -->
	<t:ExtComboStore comboType="AU" comboCode="H088" /><!--  비자종류      -->
	<t:ExtComboStore comboType="AU" comboCode="H072" /><!--  직종      -->
	
    <t:ExtComboStore comboType="AU" comboCode="H204" /><!--  업무속성      -->
    <t:ExtComboStore comboType="AU" comboCode="H205" /><!--  인적속성      -->
    <t:ExtComboStore comboType="AU" comboCode="H004" /><!--  근무형태      -->
    
    <t:ExtComboStore items="${COMBO_DEPTS2}" storeId="authDeptsStore" /> <!--권한부서-->
</t:appConfig>
<link rel="stylesheet" type="text/css" href='<c:url value="/${ext_root}/app/Ext/ux/css/GroupTabPanel.css" />' />
<script type="text/javascript">
  var protocol =   ("https:" == document.location.protocol)  ? "https" : "http"  ;
  if(protocol == "https")	{
	  document.write( unescape( "%3Cscript src='"+ protocol+ "://ssl.daumcdn.net/dmaps/map_js_init/postcode.v2.js' type='text/javascript' %3E %3C/script%3E")  );
  }else {
  	document.write( unescape( "%3Cscript src='"+ protocol+ "://dmaps.daum.net/map_js_init/postcode.v2.js' type='text/javascript' %3E %3C/script%3E") );
  }
</script><!-- Unilite.popup('ZIP',..) -->
<script type="text/javascript" >
var uploadWin;
function appMain() {
	
	/**
	 * Model 정의 
	 * @type 
	 */
	
	Unilite.defineModel('ham100ukrModel', {
	    fields: [
					{name: 'DEPT_CODE',			text: '부서코드',		type: 'string'},
					{name: 'DEPT_NAME',			text: '부서',			type: 'string'},
					{name: 'NAME',				text: '성명',			type: 'string'},
					{name: 'PERSON_NUMB',		text: '사번',			type: 'string'}, 
					{name: 'NAME_ENG',			text: '영문성명',		type: 'string'},	
					{name: 'PHONE_NO',			text: '전화번호',		type: 'string'},
					{name: 'NAME_CHI',			text: '전화번호',		type: 'string'},
					{name: 'DIV_CODE',			text: '전화번호',		type: 'string'},
					{name: 'POST_CODE',			text: '전화번호',		type: 'string'},
					{name: 'ABIL_CODE',			text: '전화번호',		type: 'string'},
					{name: 'ZIP_CODE',			text: '전화번호',		type: 'string'},
					{name: 'KOR_ADDR',			text: '전화번호',		type: 'string'},
                    {name: 'dc',          		text: 'dc',       type: 'string'}
			]
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var searchPanelStore = Unilite.createStore('ham100ukrMasterStore',{
			model: 'ham100ukrModel',
            uniOpt : {
            	isMaster: false,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
            proxy: {
                type: 'direct',
                api: {
                	   read : 'ham100ukrService.selectList'
                }
            },
            listeners: {
	            load: function(){
	            	console.log("test");                    
            	}
            }
			// Store 관련 BL 로직
            // 검색 조건을 통해 DB에서 데이타 읽어 오기 
			,loadStoreRecords : function(personNumb)	{
				
				var param= panelSearch.getValues();
				param.DEPT_AUTH = UserInfo.deptAuthYn;
				
				console.log( param );
				var me = this;
				this.load({
					params : param,
					callback: function(records, operation, success) {
				        if (success) {
							var record = me.find('PERSON_NUMB', personNumb);
							panelSearch.down('#imageList').getSelectionModel().select(record);

							if(Ext.isEmpty(textList.getSelectedRecord())){//조회 후 마스터그리드 선택된 행이 없을 경우에는 선택된 사람이 없는 것이기 때문에 디테일 정보 클리어 처리
								var activeTab = panelDetail.down('#ham100Tab').getActiveTab();
								var basicInfo1 = activeTab.down('#basicInfo');
			
								basicInfo1.loadBasicData(null);
								activeTab.loadData(null);
								basicInfo1.down('#EmpImg').getEl().dom.src=CPATH+'/resources/images/human/noPhoto.png';
								basicInfo1.down('#empName').update('');
								basicInfo1.down('#empEngName').update('');
								basicInfo1.down('#empNo').update('');
								basicInfo1.down('#empTel').update('');
								UniAppManager.app.setToolbarButtons('save',false);
								panelDetail.down('#ham100Tab').getEl().unmask();
								panelDetail.getEl().mask();
							}
				        }
					}
				});
			}
			,loadDetailForm: function(node)	{
				var activeTab = panelDetail.down('#ham100Tab').getActiveTab();
				if(!Ext.isEmpty(node))	{
					var data = node.getData();
					if(!Ext.isEmpty(data))	{
						activeTab.loadData(data['PERSON_NUMB']);
						activeTab.down('#basicInfo').loadBasicData(node);
						panelDetail.down('#ham100Tab').getEl().unmask();
						
					}				
				}
				UniAppManager.app.setToolbarButtons('save',false);	
			}
            
		});	
	
	/**
	 *  한다/않한다(Y/N) 라디오그룹 Store
	 */
	var ynOptStore = Unilite.createStore('Ham100ukrYNStore', {
	    fields: ['text', 'value'],
		data :  [
			        {'text':'한다'	, 'value':'Y'},
			        {'text':'안한다'		, 'value':'N'}
	    		]
		});
		
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var imageList = Ext.create('Unilite.human.ImageListPanel', {
		itemId:'imageList',
		store: searchPanelStore,  
		hidden:true,
        listeners: {
        	selectionchange: function(dv, nodes ){   
            	var me = this;
            	if(!Ext.isEmpty(nodes))	{
            		var config = {
            			success : function()	{
							panelSearch.down('#imageList').dataSelect(nodes[0]);
						}
					};
					if(UniAppManager.app.checkSave(config))	{
						me.dataSelect(nodes[0]);
					}
            	}
            }
        }
        ,dataSelect:function(node)	{
        	var me = this;
        	me.getStore().loadDetailForm(node);
	        panelSearch.down('#textList').getSelectionModel().select(node);
        }
	});
	
	var textList = Unilite.createGrid('ham100ukrGrid', {
		itemId:'textList',
		border:0,
        store : searchPanelStore, 
        uniOpt:{	expandLastColumn	: false,
        			useRowNumberer		: false,
                    onLoadSelectFirst	: false,
                    userToolbar 		: false,
        			useLoadFocus		: false	 /// 저장한 행 보여주기 위함
        },
        hidden:false,
        selModel:'rowmodel',
        columns:  [     
               		{ dataIndex: 'PERSON_NUMB'	,width: 100 }, 
					{ dataIndex: 'NAME' 		,width: 100 }, 
					{ dataIndex: 'DEPT_NAME'	,flex:1 },
					{ dataIndex: 'DEPT_CODE'	,width: 80 , hidden: true},
					{ dataIndex: 'PHONE_NO'		,width: 100 , hidden: true}
				  ],
		listeners: {
            selectionchange: function(grid, selNodes ){ 
            	var me = this;
            	var config = {
            			success : function(){
            				panelSearch.down('#textList').dataSelect(selNodes[0]);
						}
				 };
            	if(UniAppManager.app.checkSave(config))	{
            		me.dataSelect(selNodes[0]);
            	}
            	
            	panelDetail.unmask();
            }
        },
        dataSelect:function(node)	{
        	var me = this;
        	me.getStore().loadDetailForm(node);
	        panelSearch.down('#imageList').getSelectionModel().select(node);
	        
        }
	});
					
	var panelSearch = Unilite.createSearchPanel('${PKGNAME}_searchForm',{
		title: '검색조건',
        defaultType: 'uniSearchSubPanel',
        defaults: {
        	autoScroll:true
        },
        collapsed:false,		  
        width: 330,
		items: [{	
			title: '기본정보', 	
			id: 'search_panel1',
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',   			
	    	items:[{	    
				fieldLabel: '사번/성명',
				name: 'TXT_SEARCH',
				listeners:{
					specialkey: function(field, e){
	                    if (e.getKey() == e.ENTER) {
	                       UniAppManager.app.onQueryButtonDown();
	                    }
	                }
				}
			},{	    
				fieldLabel: '재직구분',
				name: 'RETR_DATE',
				xtype: 'uniRadiogroup',
				width: 300,	
				value: '1',
				items:[
					{
						boxLabel:'전체',
						name: 'RETR_DATE',
						inputValue:'1'							
					},{
						boxLabel:'재직',
						name: 'RETR_DATE',
						inputValue:'00000000'								
					},{
						boxLabel:'퇴사',
						name: 'RETR_DATE',
						inputValue: UniDate.getDateStr(new Date())						
					}
				]
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
	            	imageList.hide();
	                textList.show();
	            }
    		},{

				type: 'hum-photo',					            
	            handler: function () {
	                textList.hide();
	                imageList.show();
	            }
    		}],
	        items: [textList,imageList]
		}]
		,listeners:{
				afterrender: function( form, eOpts )	{
					form.expand(false);
				}
			
			}
	});	//end panelSearch    
	
	
    /**
     * 상세 조회(Detail Form Panel)
     * @type 
     */
	var basicInfo = //Ext.create('Unilite.com.form.UniDetailForm', {
				{xtype: 'uniFieldset',
				itemId:'basicInfo',
				layout:{type: 'uniTable', columns:'2'},
				margin: '10 10 10 10',
				autoScroll:false,
				items:[ {
							xtype: 'container',
							width: 274,
							margin: '10 0 10 0',
							layout:{type: 'uniTable', columns:'2', tableAttrs:{class:'photo-background'}},
							cls:'photo-background',
							items: [							
									{ 
										xtype:'component',
							        	itemId:'EmpImg',
							        	width:130,							        
							        	autoEl: {
							        		tag: 'img',
							        		src: CPATH+'/resources/images/human/noPhoto.png',
							        		cls:'photo-wrap'
							        	}
				    	  			},{ xtype:'container',
				    	  				layout:{type: 'vbox', align:'stretch'},
				    	  				width:140,
				    	  				defaults:{cls:'photo-lable-group'},
				    	  				tdAttrs:{valign:'top'},
				    	  				margin:'20 5 5 5',
				    	  				items: [
				    	  						{
							    	  				xtype:'component',
										        	itemId:'empName',
										        	cls:'photo-lable-name',
										        	html:' '
							    	  			},{
							    	  				xtype:'component',
										        	itemId:'empEngName',
										        	cls:'photo-lable-engname',
										        	html:' '
							    	  			},{
							    	  				xtype:'component',
										        	itemId:'empNo',
										        	html:' '
							    	  			},{
							    	  				xtype:'component',
										        	itemId:'empTel',
										        	html:' '
							    	  			}
						    	  		]
				    	  			}
		    	  			]
    	  			
    	  				}
    	  			,{
	        		 	xtype:'uniDetailForm',
	        		 	itemId: 'basicInfoForm',
	        		 	disabled:false,
	        		 	layout: {type: 'uniTable',  columns:'2'},
	        		 	width: 510,
	        		 	bodyCls: 'human-panel-form-background',
	        	 		defaults: {
		        					width:260,
		        					labelWidth:140,		        					
		        					readOnly:true
		        		},
		        		 api: {
				         		 load: 'ham100ukrService.select'
						},
	        		 	items:[ {
	                    	  	 	fieldLabel: '사번'    ,
								 	name:'PERSON_NUMB' , 
									allowBlank:false,
									width:230,
		        					labelWidth:110
								},
								{
	                    	  	 	fieldLabel: '사업장',
								 	name:'DIV_CODE' , 
								 	allowBlank:false,
								 	xtype: 'uniCombobox',
								 	comboType: 'BOR120'
								},{
	                    	  	 	fieldLabel: '성명',
								 	name:'NAME' , 
								 	allowBlank:false,
									width:230,
		        					labelWidth:110
								},{
	                    	  	 	fieldLabel: '부서',
								 	name:'DEPT_NAME'
								}
								,{
	                    	  	 	fieldLabel: '영문성명',
								 	name:'NAME_ENG',
									width:230,
		        					labelWidth:110   
								},{
	                    	  	 	fieldLabel: '직위',
								 	name:'POST_CODE' , 
								 	allowBlank:false,
								 	xtype: 'uniCombobox',
								 	comboType: 'AU', 
								 	comboCode: 'H005'
								},{
	                    	  	 	fieldLabel: '한자성명',
								 	name:'NAME_CHI',
									width:230,
		        					labelWidth:110   
								},{
	                    	  	 	fieldLabel: '직책',
								 	name:'ABIL_CODE',
								 	xtype: 'uniCombobox',
								 	comboType: 'AU', 
								 	comboCode: 'H006'   
								},{
									fieldLabel: '주소',
		        					labelWidth:110,
		        					colspan:2,
									showValue:false,
									width:230,	
									name:'ZIP_CODE'
								},{
	                    	  	 	fieldLabel: '상세주소',
								 	name:'KOR_ADDR',
								 	hideLabel:true,
								 	width:377,
								 	colspan:2,
								 	margin:'0 0 0 115'
								}
						]
						
				}
			],
			loadBasicData: function(node)	{
				var basicForm = this.down('#basicInfoForm').getForm();					
				if(!Ext.isEmpty(node))	{
					basicForm.loadRecord(node);
					var data = node.getData();
					this.down('#EmpImg').getEl().dom.src=CPATH+'/uploads/employeePhoto/'+data['PERSON_NUMB'];
					this.down('#empName').update(data['NAME']);
					this.down('#empEngName').update(data['NAME_ENG']);
					this.down('#empNo').update(data['PERSON_NUMB']);
					this.down('#empTel').update(data['PHONE_NO']);  
				}else {
					basicForm.reset();
					if(Ext.isEmpty(textList.getSelectedRecord())){//조회 후 마스터그리드 선택된 행이 없을 경우에는 선택된 사람이 없는 것이기 때문에 디테일 정보 클리어 처리
						this.down('#basicInfoForm').clearForm();
					}
					this.down('#EmpImg').getEl().dom.src=CPATH+'/resources/images/human/noPhoto.png';
					this.down('#empName').update('');
					this.down('#empEngName').update('');
					this.down('#empNo').update('');
					this.down('#empTel').update('');   
				}
			}
		};
		
//인사기본정보
<%@include file="./ham100ukrs01.jsp" %> 
//급여정보
<%@include file="./ham100ukrs02.jsp" %>
//경력사항
<%@include file="./ham100ukrs07.jsp" %> 
    var panelDetail = Ext.create('Ext.panel.Panel', {
    	layout 	: 'fit',
        region 	: 'center',
       	disabled: false,
	    items 	:[{
		    	xtype		: 'uniGroupTabPanel',
		    	itemId		: 'ham100Tab',
		    	activeGroup	: 0,
		        collapsed 	:false,	
		        cls			:'human-panel',
		        defaults:{
		        	defaults:{
		                	xtype: 'container',
		                    layout:{type:'vbox', align:'stretch'}
	                	}
		        },
	            items: [
	            	{	defaults:{
	            			bodyCls		: 'human-panel-form-background',
	            			border		:0,
	            			disabled	:false,
	            			autoScroll	:true
	            		},	   
		                items: [
		                	personalInfo, 		//인사기본정보
		                	salaryInfo,  		//급여정보
                            careerInfo          //경력사항
			    		]
	            	}
		        ]
		        ,listeners: {		       		
		       		afterrender: function( grouptabPanel, eOpts )	{
		       			this.getEl().mask();
		       		},
		       		beforetabchange : function( grouptabPanel, newCard, oldCard, eOpts )	{	
		       			
		       			if(Ext.isObject(oldCard))	{
		       			   grouptabPanel.mask('Loading');
		       			   var config = { 
		       			   		success : function()	{
		       			   			var tabPanel = grouptabPanel;
		       			   			var tab = oldCard;
		       			   			tabPanel.setActiveTab(tab);
		       			   		}
		       			   }
				           if(UniAppManager.app.checkSave(config))	{
				           		var record = panelSearch.down('#imageList').getSelectionModel().getSelection();	
				       			if(!Ext.isEmpty(record) )	{
					       			newCard.loadData(record[0].data['PERSON_NUMB']);
									newCard.down('#basicInfo').loadBasicData(record[0]);
				       			}else if(Ext.isDefined(this.getEl()))	{
				       				UniAppManager.app.onResetButtonDown();
									Unilite.messageBox('<t:message code="system.message.human.message001" default="사원을 선택하세요."/>');
				       				this.getEl().mask();
				       				grouptabPanel.setActiveTab(oldCard);
				       				return false;
				       			}
				           	
			       				var nerCardItemId = newCard.getItemId();
				       			if( nerCardItemId == 'salaryInfo')	{
				       				UniAppManager.app.setToolbarButtons('newData',false);
				       			} else {
				       				UniAppManager.app.setToolbarButtons('newData',true);
				       			}
				       			// 삭제버튼이 그리드가 있는 탭에서 활성화되므로 탭 이동시 비활성화 시킴
				       			UniAppManager.setToolbarButtons('delete',false);
				       			grouptabPanel.unmask();
		       				}else {
		       					grouptabPanel.setActiveTab(oldCard);
		       					grouptabPanel.unmask();
		       					return false;
		       				}
		       				
		       			}
		       		}
		       }
	    	}
	   	]
		
	}); // detailForm
	
	
	function openUploadWindow() {
		var photoForm = Ext.create('Unilite_com_form_UniDetailForm',{ xtype:'uniDetailForm',
                                disabled:false,
                                fileUpload: true,
                                itemId:'photoForm',
                                //url:  CPATH+'/uploads/employeePhoto/upload.do',
                                //url:  CPATH+'/fileman/upload.do',
                                api: {
                                    submit: ham100ukrService.photoUploadFile 
                                },
                                items:[
                                      {
                                        fieldLabel:'사번', 
                                        name:'PERSON_NUMB', 
                                        hidden:true
                                      },
                                      { 
                                        xtype: 'filefield',
                                        buttonOnly: false,
                                        fieldLabel: '사진',
                                        flex:1,
                                        name: 'photoFile',
                                        buttonText: '파일선택',
                                        width: 270,
                                        labelWidth: 70
                                      }
                                 ]
                        });
			if(!uploadWin) {				
				uploadWin = Ext.create('Ext.window.Window', {
	                title: '사진등록',
	                width: 300,				                
	                height: 100,  
				    closable: false,
				    closeAction: 'hide',
				    modal: true,
				    resizable: true,
				    layout: {
				        type: 'fit'
				    },
				    
	                items: [ photoForm
							/* {	xtype:'uniDetailForm',
					 			disabled:false,
					 			fileUpload: true,
					 			itemId:'photoForm',
					 			//url:  CPATH+'/uploads/employeePhoto/upload.do',
					 			//url:  CPATH+'/fileman/upload.do',
					 			api: {
                                    submit: ham100ukrService.photoUploadFile 
                                },
					 			items:[
						 			  {
						 			  	fieldLabel:'사번', 
						 			  	name:'PERSON_NUMB', 
						 			  	hidden:true
						 			  },{ 
	        						  	xtype: 'filefield',
										buttonOnly: false,
										fieldLabel: '사진',
										flex:1,
										name: 'photoFile',
										buttonText: '파일선택',
										width: 270,
										labelWidth: 70
						 			  }
					             ]
						}*/
									
					],
	                listeners : {
	                			 beforeshow: function( window, eOpts)	{
		                			 	var dataform = panelDetail.down('#personalInfo').getForm();	
		                			 	var config = {success : function()	{
		                									uploadWin.show();	
						                    			  }
				                    			}
		                			 	if(!dataform.isValid())	{	
		                			 		
		                			 		var invalidFields = [];
		                			 		var invalidFieldNames='';
										    dataform.getFields().filterBy(function(field) {
										        if (field.validate()) return;
										        invalidFieldNames = invalidFieldNames+field.fieldLabel+',';
										        invalidFields.push(field);
										    });
    										console.log("invalidFields : ", invalidFields);
		                			 		alert('필수입력사항을 입력하신 후 사진을 올려주세요.'+'\n'
		                			 				+'미입력항목: '+invalidFieldNames.substring(0,invalidFieldNames.length-1));
		                			 		return false;
		                			 	}else if(UniAppManager.app._needSave())	{
		                			 		UniAppManager.app.checkSave(config);
		                			 		return false;
		                			 	}
	                			 },
	                			 show: function( window, eOpts)	{
	                			 	window.down('#photoForm').setValue('PERSON_NUMB', panelDetail.down('#personalInfo').getValue('PERSON_NUMB'))
	                			 	window.center();
	                			 }
	                },
	                afterSavePhoto: function()	{
	                	var photoForm = uploadWin.down('#photoForm');
	                	photoForm.clearForm();
			            uploadWin.hide();
	                },
	                afterSuccess: function()	{
	                	var formPanel = this.down('#photoForm');
	                	var personNumb = formPanel.getValue('PERSON_NUMB');
	                	//var r = Math.random();
	                	//panelDetail.down('#personalInfo').down('#EmpImg').getEl().dom.src=CPATH+'/uploads/employeePhoto/' + personNumb+'?'+r;		
						searchPanelStore.loadStoreRecords(personNumb);
						this.afterSavePhoto();
	                },
	                tbar:[	'->',
				            { 	
		                		xtype: 'button', 
		                		text: '올리기',
		                		handler: function()	{
		                			
				                    if(panelDetail.down('#personalInfo').getForm().isDirty())	{
				                    	var config = {success : function()	{
		                										var photoForm = uploadWin.down('#photoForm').getForm();
		                										photoForm.submit(
		                											{
		                											 waitMsg: 'Uploading your files...',
		                											 success: function(form, action)	{		                													
		                													uploadWin.afterSuccess();
		                												}
		                											}
		                										);
						                    			  }
				                    			}	
							        	UniAppManager.app.onSaveDataButtonDown(config);
				                    }else {
				                    	var photoForm = uploadWin.down('#photoForm').getForm();
		                										photoForm.submit(
		                											{
		                											 waitMsg: 'Uploading your files...',
		                											 success: function(form, action)	{		                													
		                													uploadWin.afterSuccess();
		                												}
		                											}
		                										);
				                    }
		                		}
		                	 },{ 
		                	 	xtype: 'button', 
		                		text: '닫기',
		                		handler: function()	{
		                			var photoForm = uploadWin.down('#photoForm').getForm();
		                			if(photoForm.isDirty())	{
		                				if(confirm('사진이 변경되었습니다. 저장하시겠습니까?'))	{
		                					var config = {success : function()	{
		                						// TODO: fix it!!!
		                						uploadWin.afterSavePhoto();
						                    			  }
				                    			}
				                        	UniAppManager.app.onSaveDataButtonDown(config);
		                				}else{
		                					// TODO: fix it!!!
		                					uploadWin.afterSavePhoto();
		                				}
		                			}else {
		                				uploadWin.hide();
		                			}
		                		}
		                	 }
				            
				       ]
				});
			}
			uploadWin.show();
	}
	
    Unilite.Main({
		borderItems:[
				 		  panelSearch
				 		 ,panelDetail
		],
		id  : 'ham100ukrApp',
		autoButtonControl : false,
		fnInitBinding : function() {
			if (typeof params !== 'undefined') {
//				searchPanelStore.loadStoreRecords(params.PERSON_NUMB);
			}
			UniAppManager.setToolbarButtons(['reset', 'excel'],false);
			UniAppManager.setToolbarButtons(['newData','print'],true);
		}
		,onSaveAsExcelButtonDown: function() {
			var masterGrid = Ext.getCmp('ham100ukrGrid');
			masterGrid.downloadExcelXml();
		},
		onQueryButtonDown : function()	{
			searchPanelStore.loadStoreRecords();
			
		},
		onNewDataButtonDown : function()	{
			var me = this;
			
			panelDetail.down('#ham100Tab').getEl().unmask();
			panelDetail.down('#personalInfo').getEl().unmask();
			
			var config={
				success:function()	{
					UniAppManager.app.onNewDataButtonDown();
				}
			};	
						
			var activeTab = panelDetail.down('#ham100Tab').getActiveTab();
			switch(activeTab.getItemId())	{
				case 'personalInfo':
					var config={
						success:function()	{
							UniAppManager.app.onNewDataButtonDown();
						}
					};
					if(!me.checkSave(config)) {
						break;
					}
					var selmodel = panelSearch.down('#textList').getSelectionModel().getSelection( );			
					panelSearch.down('#textList').getSelectionModel().deselect(selmodel[0]);
					selmodel = panelSearch.down('#imageList').getSelectionModel().getSelection( );	
					panelSearch.down('#imageList').getSelectionModel().deselect(selmodel[0]);
					activeTab.clearForm();
					activeTab.down('#basicInfo').loadBasicData(null);
					
					
					//기본값셋팅
                    var formPanel = panelDetail.down('#personalInfo');
                    formPanel.setValue('JOIN_DATE', UniDate.get('today')); //입사일
                    formPanel.setValue('NATION_CODE', 'KR'); //국적
                    formPanel.setValue('PAY_GUBUN', '2'); //고용형태
                    formPanel.setValue('SECT_CODE', '01'); //신고사업장
//                    formPanel.setValue('RETR_OT_KIND', 'ST'); //퇴직계산분류
                    
                    formPanel.setValue('DIV_CODE', '01'); //사업장
                    
                    UniAppManager.setToolbarButtons('save',true);
                    
                    panelDetail.getEl().unmask();
					break;
				case 'familyInfo':
					var personNum = activeTab.down('#basicInfoForm').getValue('PERSON_NUMB');
					activeTab.down('#ham100ukrs2Grid').createRow({'PERSON_NUMB':personNum});
					break;
				case 'careerInfo':
					var personNum = activeTab.down('#basicInfoForm').getValue('PERSON_NUMB');
					activeTab.down('#ham100ukrs7Grid').createRow({'PERSON_NUMB':personNum});
					break;
				case 'academicBakground':
					var personNum = activeTab.down('#basicInfoForm').getValue('PERSON_NUMB');
					activeTab.down('#ham100ukrs8Grid').createRow({'PERSON_NUMB':personNum});
					break;
				case 'educationInfo':
					var personNum = activeTab.down('#basicInfoForm').getValue('PERSON_NUMB');
					activeTab.down('#ham100ukrs9Grid').createRow({'PERSON_NUMB':personNum});
					break;
				case 'certificateInfo':
					var personNum = activeTab.down('#basicInfoForm').getValue('PERSON_NUMB');
					activeTab.down('#ham100ukrs10Grid').createRow({'PERSON_NUMB':personNum});
					break;
				case 'hrChanges':
					var personNum = activeTab.down('#basicInfoForm').getValue('PERSON_NUMB');
					activeTab.down('#ham100ukrs11Grid').createRow({'PERSON_NUMB':personNum});
					break;
				case 'personalRating':
					var personNum = activeTab.down('#basicInfoForm').getValue('PERSON_NUMB');
					activeTab.down('#ham100ukrs12Grid').createRow({'PERSON_NUMB':personNum});
					break;
				case 'disciplinaryInfo':
					var personNum = activeTab.down('#basicInfoForm').getValue('PERSON_NUMB');
					activeTab.down('#ham100ukrs13Grid').createRow({'PERSON_NUMB':personNum});
					break;
				case 'contractInfo':
					var personNum = activeTab.down('#basicInfoForm').getValue('PERSON_NUMB');
					activeTab.down('#ham100ukrs14Grid').createRow({'PERSON_NUMB':personNum});
					break;
				case 'visaInfo':
					var personNum = activeTab.down('#basicInfoForm').getValue('PERSON_NUMB');
					if(visaInfoSelectedGrid=='ham100ukrs15_2Grid')	{
						activeTab.down('#ham100ukrs15_2Grid').createRow({'PERSON_NUMB':personNum});
					}else {
						activeTab.down('#ham100ukrs15_1Grid').createRow({'PERSON_NUMB':personNum});
					}	
					break;	
				case 'abroadTrip':
					var personNum = activeTab.down('#basicInfoForm').getValue('PERSON_NUMB');
					activeTab.down('#ham100ukrs16Grid').createRow({'PERSON_NUMB':personNum});
					break;	
				case 'schoolExpence':
					var personNum = activeTab.down('#basicInfoForm').getValue('PERSON_NUMB');
					activeTab.down('#ham100ukrs17Grid').createRow({'PERSON_NUMB':personNum});
					break;
				default:
					break;
			}
			
			
		},
		onPrevDataButtonDown:  function()	{
			masterGrid.selectPriorRow();
		},
		onNextDataButtonDown:  function()	{
			masterGrid.selectNextRow();
		},		
		onSaveDataButtonDown: function (config) {
			var me = this;
			var activeTab = panelDetail.down('#ham100Tab').getActiveTab();
			switch(activeTab.getItemId())	{
				case 'personalInfo':
					if(!activeTab.isValid())	{
						UniAppManager.app.findInvalidField(activeTab);
					} else {
						
						//퇴사일, 퇴사사유 체크
                        var formPanel = this.down('#personalInfo');
                        var retrDate = formPanel.getValue('RETR_DATE'); //퇴사일
                        var retrResn = formPanel.getValue('RETR_RESN'); //퇴사사유
                        
                        if(Ext.isEmpty(retrDate) && !Ext.isEmpty(retrResn)){
                        	Unilite.messageBox('<t:message code="system.message.human.message005" default="퇴사일을 입력하세요."/>');
                            formPanel.getField('RETR_DATE').focus();
                            break;
                        }
                        if(!Ext.isEmpty(retrDate) &&  Ext.isEmpty(retrResn)){
                        	Unilite.messageBox('<t:message code="system.message.human.message006" default="퇴사사유를 입력하세요."/>');
                            formPanel.getField('RETR_RESN').focus();
                            break;
                        }
						
						var activeform = activeTab.getForm();	
						activeTab.mask('<t:message code="system.message.human.message010" default="저장중.."/>');
						activeform.submit(
							{
								success:function(form, action)	{
									UniAppManager.app.setToolbarButtons('save',false);	
									var personNumb = action.result['PERSON_NUM'];
									searchPanelStore.loadStoreRecords(personNumb);
									
									if(Ext.isDefined(config))	{
										config.success.call(this);
									}
                                    activeTab.unmask();
                                    UniAppManager.updateStatus('<t:message code="system.message.human.message007" default="저장되었습니다."/>');
								}
							}
						)
					}
					break;
				case 'etcInfo':
					var activePanel = activeTab.down('#etcForm');
					if(!activePanel.isValid())	{
						UniAppManager.app.findInvalidField(activePanel);
					} else {
						var activeform = activePanel.getForm();		
						var r = true;
						if(!activePanel.chkSupportNum())	{  //부양가족 수 체크 
							r = false;
						}
						if(r)	{
                            activeTab.mask('<t:message code="system.message.human.message010" default="저장중.."/>');
							activeform.submit(
								{
									success:function(form, action)	{
										UniAppManager.app.setToolbarButtons('save',false);	
										if(Ext.isDefined(config))	{
											config.success.call(this);
										}
										activePanel.unmask();
                                        UniAppManager.updateStatus('<t:message code="system.message.human.message007" default="저장되었습니다."/>');
									}
								}
							);
						}
					}					
					break;
				case 'familyInfo':
					var activeStore = activeTab.down('#ham100ukrs2Grid').getStore();					
					activeStore.saveStore();					
					break;	
				case 'healthInfo':
					var activePanel = activeTab.down('#healthForm');
					if(!activePanel.isValid())	{
						UniAppManager.app.findInvalidField(activePanel);
					} else {
						var activeform = activePanel.getForm();	
						activeform.submit(
							{
								success:function(form, action)	{
									UniAppManager.app.setToolbarButtons('save',false);	
									if(Ext.isDefined(config))	{
										config.success.call(this);
									}
								}
							}
						);
					}
					break;
				case 'salaryInfo':
					var activePanel = activeTab.down('#salaryForm');
					if(!activePanel.isValid())	{
						UniAppManager.app.findInvalidField(activePanel);
					} else {
						var activeform = activePanel.getForm();					
						activeform.submit(
							{
								success:function(form, action)	{
									UniAppManager.app.setToolbarButtons('save',false);	
									if(Ext.isDefined(config))	{
										config.success.call(this);
									}
								}
							}
						);
					}
					
					break;	
				case 'deductionInfo':
					var activeStore1 = activeTab.down('#ham100ukrs6_1Grid').getStore();			
					var activeStore2 = activeTab.down('#ham100ukrs6_2Grid').getStore();		
					activeStore1.saveStore();	
					activeStore2.saveStore();	
					break;	
				case 'careerInfo':
					var activeStore = activeTab.down('#ham100ukrs7Grid').getStore();			
					activeStore.saveStore();	
					break;
				case 'academicBakground':
					var activeStore = activeTab.down('#ham100ukrs8Grid').getStore();			
					activeStore.saveStore();	
					break;	
				case 'educationInfo':
					var activeStore = activeTab.down('#ham100ukrs9Grid').getStore();			
					activeStore.saveStore();	
					break;		
				case 'certificateInfo':
					var activeStore = activeTab.down('#ham100ukrs10Grid').getStore();			
					activeStore.saveStore();	
					break;
				case 'hrChanges':
					var activeStore = activeTab.down('#ham100ukrs11Grid').getStore();			
					activeStore.saveStore();	
					break;	
				case 'personalRating':
					var activeStore = activeTab.down('#ham100ukrs12Grid').getStore();			
					activeStore.saveStore();	
					break;	
				case 'disciplinaryInfo':
					var activeStore = activeTab.down('#ham100ukrs13Grid').getStore();			
					activeStore.saveStore();	
					break;	
				case 'contractInfo':
					var activeStore = activeTab.down('#ham100ukrs14Grid').getStore();			
					activeStore.saveStore();	
					break;
				case 'visaInfo':
					var activeStore1 = activeTab.down('#ham100ukrs15_1Grid').getStore();			
					activeStore1.saveStore();	
					var activeStore2 = activeTab.down('#ham100ukrs15_2Grid').getStore();			
					activeStore2.saveStore();	
					break;
				case 'abroadTrip':
					var activeStore = activeTab.down('#ham100ukrs16Grid').getStore();			
					activeStore.saveStore();	
					break;
				case 'schoolExpence':
					var activeStore = activeTab.down('#ham100ukrs17Grid').getStore();			
					activeStore.saveStore();	
					break;		
				case 'recommender':
					var activePanel = activeTab.down('#recommenderForm');
					if(!activePanel.isValid())	{
						UniAppManager.app.findInvalidField(activePanel);
					} else {
						var activeform = activePanel.getForm();	
						activeform.submit(
							{
								success:function(form, action)	{
									UniAppManager.app.setToolbarButtons('save',false);	
									if(Ext.isDefined(config))	{
										config.success.call(this);
									}
								}
							}
						);
					}
					break;				
				case 'surety':
					var activePanel = activeTab.down('#suretyForm');
					if(!activePanel.isValid())	{
						UniAppManager.app.findInvalidField(activePanel);
					} else {
						var activeform = activePanel.getForm();	
						activeform.submit(
							{
								success:function(form, action)	{
									UniAppManager.app.setToolbarButtons('save',false);	
									if(Ext.isDefined(config))	{
										config.success.call(this);
									}
								}
							}
						);
					}
					break;
				default:
					break;
			}
					
		},
		onDeleteDataButtonDown : function()	{
			if(confirm('<t:message code="system.message.human.message008" default="현재행을 삭제 합니다."/>', '<t:message code="system.message.human.message009" default="삭제 하시겠습니까?"/>')) {
				var me = this;
				var activeTab = panelDetail.down('#ham100Tab').getActiveTab();
				
				switch(activeTab.getItemId())	{
					case 'personalInfo':
						// 20210423 삭제시 내용 변경되었다는 문구로 인해 임시처리 =============================
						UniAppManager.app.setToolbarButtons('save',false);
						// ===============================================================
						
						var selectedRec = textList.getSelectedRecord();
	
						if(!Ext.isEmpty(selectedRec)){
							var param = {
								"PERSON_NUMB" : selectedRec.get('PERSON_NUMB')
							};
	
							hum100ukrService.personalInfoDelete(param, function(provider, response)  {
								if(!Ext.isEmpty(provider)){
									if(provider=='C'){
										Unilite.messageBox('급상여자료가 존재하는 사원은 삭제하실수 없습니다.');
									}else if(provider=='Y'){
										Unilite.messageBox('<t:message code="system.message.human.message133" default="삭제 되었습니다."/>');
										var activeTab = panelDetail.down('#ham100Tab').getActiveTab();
										var basicInfo = activeTab.down('#basicInfo');
										//basicInfo.loadBasicData(null);
										//activeTab.loadData(null);
										searchPanelStore.loadStoreRecords();
	
									}else{
										Unilite.messageBox('<t:message code="system.message.human.message131" default="데이터를 확인해 주십시오."/>');
									}
								}else{
									Unilite.messageBox('<t:message code="system.message.human.message131" default="데이터를 확인해 주십시오."/>');
								}
	
							});
						}else{
							Unilite.messageBox('<t:message code="system.message.human.message132" default="삭제 할 데이터가 없습니다."/>');
						}
	
						break;
					case 'familyInfo':
						var activeGrid =  activeTab.down('#ham100ukrs2Grid');
						activeGrid.deleteSelectedRow();					
						break;	
					case 'deductionInfo':
						var activeGrid1 =  activeTab.down('#ham100ukrs6_1Grid');
						activeGrid1.deleteSelectedRow();	
						var activeGrid2 =  activeTab.down('#ham100ukrs6_2Grid');
						activeGrid2.deleteSelectedRow();	
						break;
					case 'careerInfo':
						var activeGrid =  activeTab.down('#ham100ukrs7Grid');
						activeGrid.deleteSelectedRow();					
						break;
					case 'academicBakground':
						var activeGrid =  activeTab.down('#ham100ukrs8Grid');
						activeGrid.deleteSelectedRow();					
						break;	
					case 'educationInfo':
						var activeGrid =  activeTab.down('#ham100ukrs9Grid');
						activeGrid.deleteSelectedRow();					
						break;	
					case 'certificateInfo':
						var activeGrid =  activeTab.down('#ham100ukrs10Grid');
						activeGrid.deleteSelectedRow();					
						break;
					case 'hrChanges':
						var activeGrid =  activeTab.down('#ham100ukrs11Grid');
						activeGrid.deleteSelectedRow();					
						break;	
					case 'personalRating':
						var activeGrid =  activeTab.down('#ham100ukrs12Grid');
						activeGrid.deleteSelectedRow();					
						break;	
					case 'disciplinaryInfo':
						var activeGrid =  activeTab.down('#ham100ukrs13Grid');
						activeGrid.deleteSelectedRow();					
						break;
					case 'contractInfo':
						var activeGrid =  activeTab.down('#ham100ukrs14Grid');
						activeGrid.deleteSelectedRow();					
						break;
					case 'visaInfo':
						if(visaInfoSelectedGrid=='ham100ukrs15_2Grid')	{
							var activeGrid =  activeTab.down('#ham100ukrs15_2Grid');
							activeGrid.deleteSelectedRow();	
						}else {
							var activeGrid =  activeTab.down('#ham100ukrs15_1Grid');
							activeGrid.deleteSelectedRow();	
						}	
						break;	
					case 'abroadTrip':
						var activeGrid =  activeTab.down('#ham100ukrs16Grid');
						activeGrid.deleteSelectedRow();					
						break;
					case 'schoolExpence':
						var activeGrid =  activeTab.down('#ham100ukrs17Grid');
						activeGrid.deleteSelectedRow();					
						break;	
					default:
						break;
				}
			}
			// 삭제 후 삭제버튼 enable 처리
			UniAppManager.setToolbarButtons('delete',false);
		},
		onResetButtonDown:function() {
			var me = this;
			var activeTab = panelDetail.down('#ham100Tab').getActiveTab();
			var basicInfo = activeTab.down('#basicInfo');
			basicInfo.loadBasicData(null);		
			activeTab.loadData(null);
			
			UniAppManager.setToolbarButtons('save',false);
		},
		
		onPrintButtonDown: function() {
			var records = panelSearch.down('#imageList').getSelectionModel().getSelection();	
			if(!Ext.isEmpty(records) )	{
				var pPersonNumb = Ext.isArray(records)? records[0].get('PERSON_NUMB') : records.get('PERSON_NUMB')
	       		var win = Ext.create('widget.PDFPrintWindow', {
	       			prgID: 'ham100ukr',
					url: CPATH+'/human/ham100ukrPrint.do',
					extParam: {
						PERSON_NUMB: pPersonNumb
					}
				});
				win.show();
   			}else if(Ext.isDefined(this.getEl()))	{
   				UniAppManager.app.onResetButtonDown();
   				Unilite.messageBox('<t:message code="system.message.human.message001" default="사원을 선택하세요."/>');
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
		checkSave:function(config)	{
			var me = this;
			if( me._needSave() ) {
				if(confirm(Msg.sMB017 + "\n" + Msg.sMB061))	{					
					me.onSaveDataButtonDown(config);
					return false;
				}else {
					UniAppManager.setToolbarButtons('save',false);
				}
			}
			return true;
		},
		findInvalidField:function(formPanel)	{
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
	        	panelDetail.down('#ham100Tab').getEl().unmask();
    	        
	        }	
		}
	});	// Main

};
</script>