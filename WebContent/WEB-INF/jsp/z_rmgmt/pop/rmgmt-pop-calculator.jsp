<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<style>
	.pop-calc-top .form-clicked {
		background: linear-gradient(to top, #0ba360 0%, #3cba92 100%);
	}
</style>
<div id="rmgmtPopCalculator" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="rmgmtPopCalculatorHeader" aria-hidden="true">
	<div class="modal-dialog modal-lg">
	    <div class="modal-content">
	        <div class="modal-header">
	            <h4 class="modal-title" id="standard-modalLabel"><span id="titlistpop">제조이력 입력기</span></h4>
	            <button type="button" class="close" name="rmgmtPopCalculatorClose" data-dismiss="modal" aria-hidden="true"><span style="font-size: 50px;">x</span></button>
	            
	        </div>
	        <div class="pb-2">
	
	        </div>
	        <div class="row">
	        	<!-- form -->
	            <div id="rmgmtPopCacsTopForm" class="col-12 pl-4 pr-0">
	               <div class="row pop-calc-top">
	                   
	                    
	                     <div class="col-3 pl-0">
	                        <div class="card mb-2">
	                            <a id="aPopCalcTopPowder" onclick="javascript:fnVisiblePopTop('Powder');">
	                                <div class="card-body pt-1 pb-2 pr-1 pl-1">
	                                    <h4 class="text-center m-0 text-dark">파우더</h4>
	                                    <hr class="mt-1 mb-1" />
	                                    <div class="row">
	                                        <div class="col-12 pt-1">
	                                            <input id="popCalcPowder" class="form-control text-center" readonly type="text" style="height:50px;font-size:35px">
	                                        </div>
	                                    </div>
	                                </div>
	                            </a>
	                        </div>
	                    </div>
	                    <div class="col-3 pl-0">
	                        <div class="card mb-2">
	                            <a id="aPopCalcTopColoring" onclick="javascript:fnVisiblePopTop('Coloring');">
	                                <div class="card-body pt-1 pb-2 pl-1 pr-1">
	                                    <h4 class="text-center m-0 text-dark">색소</h4>
	                                    <hr class="mt-1 mb-1" />
	                                    <div class="row">
	                                        <div class="col-12 pt-1">
	                                            <input id="popCalcColoring" class="form-control text-center" readonly type="text" style="height:50px;font-size:35px">
	                                        </div>
	                                    </div>
	                                </div>
	                            </a>
	                        </div>
	                    </div>
	                    <div class="col-3 pl-0">
	                        <div class="card mb-2">
	                            <a id="aPopCalcTopBinder" onclick="javascript:fnVisiblePopTop('Binder');">
	                                <div class="card-body pt-1 pb-2 pl-1 pr-1">
	                                    <h4 class="text-center m-0 text-dark">바인더</h4>
	                                    <hr class="mt-1 mb-1" />
	                                    <div class="row">
	                                        <div class="col-12 pt-1">
	                                            <input id="popCalcBinder" class="form-control text-center" readonly type="text" style="height:50px;font-size:35px">
	                                        </div>
	                                    </div>
	                                </div>
	                            </a>
	                        </div>
	
	                    </div>
	                    <div class="col-3 pl-0 pr-4">
	                        <div class="card mb-2">
	                            <a id="aPopCalcTopPearl" onclick="javascript:fnVisiblePopTop('Pearl');">
	                                <div class="card-body pt-1 pb-2 pl-1 pr-1">
	                                    <h4 class="text-center m-0 text-dark">펄</h4>
	                                    <hr class="mt-1 mb-1" />
	                                    <div class="row">
	                                        <div class="col-12 pt-1">
	                                            <input id="popCalcPearl" class="form-control text-center" readonly type="text" style="height:50px;font-size:35px">
	                                        </div>
	                                    </div>
	                                </div>
	                            </a>
	
	                        </div>
	
	                    </div>
	                    <div class="col-3 pl-0">
	                        <div class="card mb-2">
	                            <a id="aPopCalcTopSharp7" onclick="javascript:fnVisiblePopTop('Sharp7');">
	                                <div class="card-body pt-1 pb-2 pr-1 pl-1">
	                                    <h4 class="text-center m-0 text-dark">#7</h4>
	                                    <hr class="mt-1 mb-1" />
	                                    <div class="row">
	                                        <div class="col-12 pt-1">
	                                            <input id="popCalcSharp7" class="form-control text-center" readonly type="text" style="height:50px;font-size:35px">
	                                        </div>
	                                    </div>
	                                </div>
	                            </a>
	                        </div>
	                    </div>
	                   <div class="col-3 pl-0">
	                        <div class="card mb-2">
	                           <a id="aPopCalcTopRpm" onclick="javascript:fnVisiblePopTop('Rpm');">
	                               <div class="card-body pt-1 pb-2 pr-1 pl-1">
	                                <h4 class="text-center m-0 text-dark">RPM</h4>
	                                    <hr class="mt-1 mb-1" />
	                                    <div class="row">
	                                        <div class="col-12 pt-1">
	                                            <input id="popCalcRpm" class="form-control text-center" readonly type="text" style="height:50px;font-size:35px">
	                                        </div>
	                                    </div>
	                                </div>
	                           </a>
	                        </div>
	                    </div>
	                    <div class="col-3 pl-0">
	                        <div class="card mb-2">
	                            <a id="aPopCalcTopTime" onclick="javascript:fnVisiblePopTop('Time');">
	                                <div class="card-body pt-1 pb-2 pr-1 pl-1">
	                                    <h4 class="text-center m-0 text-dark">시간(초)</h4>
	                                    <hr class="mt-1 mb-1" />
	                                    <div class="row">
	                                        <div class="col-12 pt-1">
	                                            <input id="popCalcTime" class="form-control text-center" readonly type="text" style="height:50px;font-size:35px">
	                                        </div>
	                                    </div>
	                                </div>
	                            </a>
	                        </div>
	                    </div>
	                    <div class="col-3 pr-4 pl-0">
	                        <div class="card mb-2">
	                        	<a id="aPopCalcTopHgi" onclick="javascript:fnVisiblePopTop('Hgi');">
	                        	
	                        	
	                            <div class="card-body pt-1 pb-2 pl-1 pr-1">
	                                <h4 class="text-center m-0 text-dark">분쇄도</h4>
	                                <hr class="mt-1 mb-1" />
	                                <div class="row">
	                                    <div class="col-12 pt-1">
	                                    	<input id="popCalcHgi" class="form-control text-center" readonly type="text" style="height:50px;font-size:35px">
	                                    </div>
	                                </div>
	                            </div>
	                            
	                            </a>
	                        </div>
	                   </div>
	                   <div class="col-3 pl-0">
	                        <div class="card mb-2">
	                        	<a id="aPopCalcTopGroup" onclick="javascript:fnVisiblePopTop('Group');">
	                        
	                            <div class="card-body pt-1 pb-2 pl-1 pr-1">
	                                <h4 class="text-center m-0 text-dark">공정그룹</h4>
	                                <hr class="mt-1 mb-1" />
	                                <div class="row">
	                                    <div class="col-12 pt-1">
	                                    	<input id="popCalcGroup" class="form-control text-center" readonly type="text" style="height:50px;font-size:35px">
	                                    </div>
	                                </div>
	                            </div>
	                            
	                            </a>
	                        </div>
	                   </div>
	               </div>
	           </div>
	           <!-- table -->
	           
	           	<div id="rmgmtPopCalcTopGrid" class="col-12 pr-3 pl-3"  style="display:none">
	           	   	
	           	   		<div class="card mb-2">
	           	   			<div class="card-body p-1">
	           	   				<table class="table table-hover mb-0">
								  <thead>
								    <tr>
								      <th>No.</th>
								      <th>원료코드</th>
								      <th>시험번호</th>
								      <th>원료명</th>
								      <th>단위</th>
								      <th>함량(%)</th>
								      <th>이론량(g)</th>
								      <th id="thPopCalcGridProdtQG">계량량(g)</th>
								      <th id="thPopCalcGridProdtQP">계량량(%)</th>
								    </tr>
								  </thead>
								  <tbody>
								    <tr>
								      <td class="text-center" id="popCalcGridNo"></td>
								      <td class="text-center" id="popCalcGridChildCode"></td>
								      <td class="text-center" id="popCalcGridChildLotNo"></td>
								      <td class="text-center" id="popCalcGridChildName"></td>
								      <td class="text-center" id="popCalcGridStockUnit"></td>
								      <td class="text-center" id="popCalcGridUnitQ"></td>
								      <td class="text-center" id="popCalcGridAllockQ" data-value=""></td>
								      <td class="text-center" id="popCalcGridProdtQG" data-value=""></td>
								      <td class="text-center" id="popCalcGridProdtQP" data-value=""></td>
								    </tr>
								  </tbody>
								</table>
	           	   			</div>
	           	   		</div>
		           	
	           </div>
	           
	           <!-- table end -->
	            <div class="col-12  find-pbl-procs-line pb-2 pl-3 pr-3">
	               <div class="row">
	                   <div class="col-12" id="divTxtPopCalsViewArea">
	                      <div class="card mb-2">
	                          <div class="card-body pt-2 pb-2 pr-1 pl-1">
	                              <input type="text" class="text-center" id="txtPopCalsView" style="height: 60px;width:100%;font-size:40px;" autocomplete="off" readonly>
	                          </div>
	                      </div>
	                   </div>
	                   <div class="col-12">
	                       <div class="card mb-2">
	                           <div class="card-body pt-2 pb-2">
	                               <div class="row">
	                                   <div class="col-12" id="divPopCalcKeypadComm">
	                                   		<!-- RPM Button -->
	                                       <div class="row" id="divPopCalcKeypadCommRpm" style="display:none">
	                                       		<c:forEach items="${Z011 }" var="ls" varStatus="i">
													<div class="col-4">
														<button style="height: 70px;font-size: 30px;" name="btnPopCalcCommRpm" data-code="${ls.CODE_CD }" data-ref1="${ls.REF_CODE1 }" class="btn btn-block btn-outline-info">${ls.CODE_NM }</button>
													</div>
												</c:forEach>
	                                        </div>
	                                        <!-- Time Button -->
	                                        <div class="row" id="divPopCalcKeypadCommTime" style="display:none">
	                                            <c:forEach items="${Z012 }" var="ls" varStatus="i">
													<div class="col-2">
														<button style="height: 70px;font-size: 30px;" name="btnPopCalcCommTime" data-code="${ls.CODE_CD }" data-ref1="${ls.REF_CODE1 }" class="btn btn-block btn-outline-info">${ls.CODE_NM }</button>
													</div>
												</c:forEach>
	                                        </div>
	                                        <div class="row" id="divPopCalcKeypadCommHgi" style="display:none">
	                                            <c:forEach items="${Z013 }" var="ls" varStatus="i">
													<div class="col-4">
														<button style="height: 70px;font-size: 30px;" name="btnPopCalcCommHgi" data-code="${ls.CODE_CD }" data-ref1="${ls.REF_CODE1 }" class="btn btn-block btn-outline-info">${ls.CODE_NM }</button>
													</div>
												</c:forEach>
	                                        </div>
	                                        <div class="row" id="divPopCalcKeypadCommGroup" style="display:none">
	                                            <c:forEach items="${B140 }" var="ls" varStatus="i">
	                                            	<c:if test="${ls.CODE_CD < 'G' }">
	                                            	<div class="col-2">
														<button style="height: 70px;font-size: 30px;" name="btnPopCalcCommGroup" data-code="${ls.CODE_CD }" data-ref1="${ls.REF_CODE1 }" class="btn btn-block btn-outline-info">${ls.CODE_CD }</button>
													</div>
	                                            	</c:if>
													
												</c:forEach>
	                                        </div>
	                                   </div>
	                               </div>
	                           </div>
	                       </div>
	                   </div>
	                   <div class="col-12">
	                       <div class="card mb-0">
	    
	                            <div class="card-body pb-0 pt-0 pl-1 pr-1">
	                               <div class="row" id="divPopCalcKeypad">
	                                   <div class="col-12">
	                                       <div class="row p-1">
	                                            <div class="col-4"><button data-code="1" data-ref1="" style="height: 70px;font-size: 30px;" class="btn btn-block btn-outline-dark">1</button></div>
	                                            <div class="col-4"><button data-code="2" data-ref1="" style="height: 70px;font-size: 30px;" class="btn btn-block btn-outline-dark">2</button></div>
	                                            <div class="col-4"><button data-code="3" data-ref1="" style="height: 70px;font-size: 30px;" class="btn btn-block btn-outline-dark">3</button></div>
	                                        </div>
	                                        <div class="row p-1">
	                                            <div class="col-4"><button data-code="4" data-ref1="" style="height: 70px;font-size: 30px;" class="btn btn-block  btn-outline-dark">4</button></div>
	                                            <div class="col-4"><button data-code="5" data-ref1="" style="height: 70px;font-size: 30px;" class="btn btn-block  btn-outline-dark">5</button></div>
	                                            <div class="col-4"><button data-code="6" data-ref1="" style="height: 70px;font-size: 30px;" class="btn btn-block  btn-outline-dark">6</button></div>
	                                        </div>
	                                        <div class="row p-1">
	                                            <div class="col-4"><button data-code="7" data-ref1="" style="height: 70px;font-size: 30px;" class="btn btn-block  btn-outline-dark">7</button></div>
	                                            <div class="col-4"><button data-code="8" data-ref1="" style="height: 70px;font-size: 30px;" class="btn btn-block  btn-outline-dark">8</button></div>
	                                            <div class="col-4"><button data-code="9" data-ref1="" style="height: 70px;font-size: 30px;" class="btn btn-block  btn-outline-dark">9</button></div>
	                                        </div>
	                                        <div class="row p-1">
	                                        	<div class="col-2"><button data-code="clear" data-ref1="" style="height: 70px;font-size: 30px;" class="btn btn-block  btn-outline-primary">Clear</button></div>
	                                            <div class="col-2"><button data-code="back" data-ref1="" style="height: 70px;font-size: 30px;" class="btn btn-block  btn-outline-dark">←</button></div>
	                                            <div class="col-4"><button data-code="0" data-ref1="" style="height: 70px;font-size: 30px;" class="btn btn-block  btn-outline-dark">0</button></div>
	                                            <div class="col-4" id="btnPopCalsPoint1"><button data-code="." data-ref1="" style="height: 70px;font-size: 30px;" class="btn btn-block  btn-outline-dark">.</button></div>
	                                            <div class="col-2" id="btnPopCalsPoint2"><button data-code="." data-ref1="" style="height: 70px;font-size: 30px;" class="btn btn-block  btn-outline-dark">.</button></div>
	                                            <div class="col-2" id="btnPopCalsPercent"><button data-code="percent" data-ref1="" style="height: 70px;font-size: 30px;" class="btn btn-block  btn-outline-success">%</button></div>
	                                        </div>
	                                   </div>
	                                   <div class="col-3">
	                                       <!-- <div class="row p-2">
	                                           <div class="col-12 pr-0"><button data-code="clear" data-ref1="" style="height: 70px;font-size: 30px;" class="btn btn-block  btn-outline-primary">Clear</button></div>
	                                       </div> -->
	                                       <!-- <div id="divPopCalcKeypadPercent" class="row p-2">
	                                           <div class="col-12 pr-0"><button data-code="percent" data-ref1="" style="height: 70px;font-size: 30px;" class="btn btn-block  btn-outline-success">%</button></div>
	                                       </div> -->
	
	                                   </div>
	                               </div>
	
	                            </div>
	                        </div>
	                   </div>
	               </div>
	                
	            </div>
	            <div class="col-4">
	                
	            </div>
	            
	
	        </div>
	        
	        
	        <div class="modal-footer pt-2">
	            <div class="col-3 text-right pr-0 pl-3">
	                <button style="height: 60px;font-size:35px" type="button" class="btn btn-primary btn-block" id="btnRmgmtPopCalculatorConfirm">
	                    
	                    <span>확 인</span>
	                </button>
	            </div>
	            <div class="col-3 text-right pr-0 pl-3">
	                <button style="height: 60px;font-size:35px" type="button" class="btn btn-primary btn-block" name="rmgmtPopCalculatorClose" data-dismiss="modal">
	                    
	                    <span>닫 기</span>
	                </button>
	            </div>
	            
	        </div>
	    </div><!-- /.modal-content -->
	</div><!-- /.modal-dialog -->
</div><!-- /.modal -->

<script type = "text/javascript" charset = "utf-8" >
/********** 전역 
**************************************************/
 
 	_glbRmgmtPopCalc = {
		
 		loc		: "",		// Rpm, Time, Powder, Binder, Pearl,  Grid 
		seq		: "",
		rpm  	: {obj : "", value : ""},
		time 	: {obj : "", value : ""},
		sharp7	: {obj : "", value : ""}, 
		powder	: {obj : "", value : ""},
		coloring: {obj : "", value : ""}, 
		binder	: {obj : "", value : ""},
		pearl	: {obj : "", value : ""},
		hgi		: {obj : "", value : ""},
		group	: {obj : "", value : ""},
		no			: "",
		childCode 	: "",
		childLotNo 	: "",
		childName 	: "",
		stockUnit	: "",
		unitQ		: "",
		allockQ		: "",
		prodtQG		: {obj : "", value : ""},
		prodtQP		: {obj : "", value : ""}
		
	};
 
 	$(document).ready(function () {
		/********** 이벤트 함수 정의.
    	**************************************************/
    	/********** Modal Open 이벤트. **********/
        $('#rmgmtPopCalculator').on('show.bs.modal', function (e) {
			
        	var loc = _glbRmgmtPopCalc.loc;

        	// click에 따라 보여지는 공통 코드가 다름
        	fnVisiblePopTop(loc, "Y");
        	// popup의 top setting
        	fnSetPopTop();
        	
        });

        /********** Modal Close 이벤트. **********/
        $('#rmgmtPopCalculator').on('hidden.bs.modal', function (e) {
        	
        });	
        
        /***** 각 셋팅 후 확인 클릭 시 
        - Main BodyTop 및 팝업전역변수 set  
    	*************************/
        $("#btnRmgmtPopCalculatorConfirm").click(function(){
        	var sRpm 		= $("#popCalcRpm").val();
        	var sTime 		= $("#popCalcTime").val();
        	var sSharp7		= $("#popCalcSharp7").val();
        	var sPowder 	= $("#popCalcPowder").val();
        	var sColoring	= $("#popCalcColoring").val();
        	var sBinder 	= $("#popCalcBinder").val();
        	var sPearl		= $("#popCalcPearl").val();
        	var sHgi		= $("#popCalcHgi").val();
        	var sGroup		= $("#popCalcGroup").val();
        	
        	var attrRpm 		= $("#popCalcRpm").attr("data-value");
        	var attrTime 		= $("#popCalcTime").attr("data-value");
        	var attrSharp7		= $("#popCalcSharp7").attr("data-value");
        	var attrPowder 		= $("#popCalcPowder").attr("data-value");
        	var attrColoring	= $("#popCalcColoring").attr("data-value");
        	var attrBinder 		= $("#popCalcBinder").attr("data-value");
        	var attrPearl		= $("#popCalcPearl").attr("data-value");
        	var attrHgi			= $("#popCalcHgi").attr("data-value");
        	var attrGroup		= $("#popCalcGroup").attr("data-value");
        	
        	var sProdtQG 		=  $("#popCalcGridProdtQG").text();
        	var attrProdtQG 	=  $("#popCalcGridProdtQG").attr("data-value");
        	var sProdtQP 		=  $("#popCalcGridProdtQP").text();
        	var attrProdtQP 	=  $("#popCalcGridProdtQP").attr("data-value");
        	
        	// 쓰일 main Body top data-value set 
        	_glbRmgmtPopCalc.rpm.obj.attr("data-value", attrRpm);
        	_glbRmgmtPopCalc.time.obj.attr("data-value",attrTime);
        	_glbRmgmtPopCalc.sharp7.obj.attr("data-value",attrSharp7);
        	_glbRmgmtPopCalc.powder.obj.attr("data-value",attrPowder);
        	_glbRmgmtPopCalc.coloring.obj.attr("data-value",attrColoring);
        	_glbRmgmtPopCalc.binder.obj.attr("data-value",attrBinder);
        	_glbRmgmtPopCalc.pearl.obj.attr("data-value",attrPearl);
        	_glbRmgmtPopCalc.hgi.obj.attr("data-value",attrHgi);
        	_glbRmgmtPopCalc.group.obj.attr("data-value",attrGroup);
        	
        	// 화면에 보일 main Body top value set
        	_glbRmgmtPopCalc.rpm.obj.val(sRpm);
        	_glbRmgmtPopCalc.time.obj.val(sTime);
        	_glbRmgmtPopCalc.sharp7.obj.val(sSharp7);
        	_glbRmgmtPopCalc.powder.obj.val(sPowder);
        	_glbRmgmtPopCalc.coloring.obj.val(sColoring);
        	_glbRmgmtPopCalc.binder.obj.val(sBinder);
        	_glbRmgmtPopCalc.pearl.obj.val(sPearl);
        	_glbRmgmtPopCalc.hgi.obj.val(sHgi);
        	_glbRmgmtPopCalc.group.obj.val(sGroup);
        	
        	// 팝업전역변수 set  
        	_glbRmgmtPopCalc.rpm.value = attrRpm;
       		_glbRmgmtPopCalc.time.value = attrTime;
       		_glbRmgmtPopCalc.sharp7.value = attrSharp7;
       		_glbRmgmtPopCalc.powder.value = attrPowder;
       		_glbRmgmtPopCalc.coloring.value = attrColoring;
       		_glbRmgmtPopCalc.binder.value = attrBinder;
       		_glbRmgmtPopCalc.pearl.value = attrPearl;
       		_glbRmgmtPopCalc.hgi.value = sHgi;
       		_glbRmgmtPopCalc.group.value = sGroup;
       		
       		if(_glbRmgmtPopCalc.loc == "G" || _glbRmgmtPopCalc.loc == "P"){
       			
       			var allockQ = _glbRmgmtPopCalc.allockQ;
       			
       			if(_glbRmgmtPopCalc.loc == "G"){
       				attrProdtQP = Math.round((attrProdtQG * 10000) / allockQ) / 100; 
       			}else{
       				attrProdtQG = allockQ * attrProdtQP / 100;
       			}
       			
       			_glbRmgmtPopCalc.prodtQG.obj.val(attrProdtQG);
       			_glbRmgmtPopCalc.prodtQG.value = attrProdtQG;
       			_glbRmgmtPopCalc.prodtQP.obj.val(attrProdtQP);
       			_glbRmgmtPopCalc.prodtQP.value = attrProdtQP;
       			if(_glbRmgmtPopCalc.loc == "G"){
       				fnSetTopObjFromBodyTop(_glbRmgmtPopCalc.seq, _glbRmgmtPopCalc.loc, _glbRmgmtPopCalc.prodtQG.obj);	
       			}else{
       				fnSetTopObjFromBodyTop(_glbRmgmtPopCalc.seq, _glbRmgmtPopCalc.loc, _glbRmgmtPopCalc.prodtQP.obj);
       			}
       				
       			
       		}else{
       			fnSetTopObjFromBodyTop(_glbRmgmtPopCalc.seq, _glbRmgmtPopCalc.loc);
       		}
       		
       		
       		$("#rmgmtPopCalculator").modal("hide");
        }); 
        
        
        /***** 계산기 클릭(코드)
    	*************************/
    	$(document).on("click", "#divPopCalcKeypadComm button", function(e){
    		me = $(this);
    		
    		var num 	= me.attr("data-code");
    		var proc 	= me.attr("data-ref1");
    		var objLoc 	= _glbRmgmtPopCalc.loc; 
    		
    		
    		if(objLoc == "Hgi"){
    			$("#popCalc" + objLoc).val(me.text());
    		}else{
    			$("#popCalc" + objLoc).val(num);	
    		}
    		
    		$("#txtPopCalsView").val(num);
    		
    		$("#popCalc" + objLoc).attr("data-value",num);
    		//$("#popCalc" + objLoc).attr("data-ref1",proc);
    		fnClickedPopTop(objLoc);
    	});
    	/***** 계산기 클릭(키패드)
    	*************************/
    	$(document).on("click", "#divPopCalcKeypad button", function(e){
    		me = $(this);
    		
    		var pattern = /^[+-]?\d*(\.?\d*)$/;
    		
    		var num 	 = me.attr("data-code");
    		var proc 	 = me.attr("data-ref1");
    		var objLoc 	 = _glbRmgmtPopCalc.loc;
    		var txt		 = $("#txtPopCalsView").val();
    		var inputNum = "0";
    		
    		switch(num){
    			case "clear":
    	    		break;
    			case "back":
    				var txtSlice = txt.slice(0, -1);
    				inputNum = txtSlice == "" ? "0" : txtSlice;
    				break;
    			case "percent":
    				var chkNum = ((NumberUtil.nullEqualsZero(txt) == "0") ? "" : txt);
    				var allockQ =  $("#popCalcGridAllockQ").attr("data-value");
    				
    				if(chkNum == "0" || isNaN(chkNum) || isNaN(allockQ)){
    					break;
    				}
    				
    				inputNum = allockQ * chkNum / 100;
    				
    				break;
    			case ".":
    				
    				var chkNum = txt + num;
    				if(!pattern.test(chkNum)){
		    			inputNum = txt;
						break;
					}
    				inputNum = chkNum;
    				break;
				default:
					
					var chkNum = ((txt != "0." && NumberUtil.nullEqualsZero(txt) == "0") ? "" : txt) + num; 

		    		if(!pattern.test(chkNum)){
		    			inputNum = txt;
						break;
					}
		    		
		    		inputNum = chkNum;
		    		break;
    		};
    		if(objLoc != "G" && objLoc != "P"){
    			$("#popCalc" + objLoc).val(inputNum);
        		$("#popCalc" + objLoc).attr("data-value",inputNum);
        		$("#txtPopCalsView").val(inputNum);	
        		
        		fnClickedPopTop(objLoc);
    		}else{
    			$("#popCalcGridProdtQ" + objLoc).text(inputNum);
    			$("#popCalcGridProdtQ" + objLoc).attr("data-value", inputNum);
    			$("#txtPopCalsView").val(inputNum);	
    		}
    		
    		
    	});
        
        
    	fnInitRmgmtPopCalculator()
	});
	
	/********** 초기화.
    **************************************************/
    function fnInitRmgmtPopCalculator() {
        
    }
	
    /********** 유효성 검사.
    **************************************************/
    function fnValidateRmgmtPopCalculator() {
 		
    }
	
    /********** 사용자 정의 함수.
    **************************************************/
    
    /***** 팝업의 top change css 
    - 선택시 색상변경
    - 2021.05.04 y/n 추가
	*************************/
    function fnClickedPopTop(pLoc, pInit){
    	
    	var $click 		= $("#popCalc" + pLoc);
    	
    	if(pInit == "Y"){
    		if(_glbRmgmtPopCalc.powder.obj.attr("data-value") == "Y"){
				if(!$("#popCalcPowder").hasClass("form-clicked")){
					$("#popCalcPowder").addClass("form-clicked")
				};
			}else{
				if($("#popCalcPowder ").hasClass("form-clicked")){
					$("#popCalcPowder").removeClass("form-clicked")
				};
			};
			if(_glbRmgmtPopCalc.coloring.obj.attr("data-value") == "Y"){
				if(!$("#popCalcColoring").hasClass("form-clicked")){
					$("#popCalcColoring").addClass("form-clicked")
				};
			}else{
				if($("#popCalcColoring").hasClass("form-clicked")){
					$("#popCalcColoring").removeClass("form-clicked")
				};
			};
			if(_glbRmgmtPopCalc.binder.obj.attr("data-value") == "Y"){
				if(!$("#popCalcBinder").hasClass("form-clicked")){
					$("#popCalcBinder").addClass("form-clicked")
				};
			}else{
				if($("#popCalcBinder").hasClass("form-clicked")){
					$("#popCalcBinder").removeClass("form-clicked")
				};
			};
			if(_glbRmgmtPopCalc.pearl.obj.attr("data-value") == "Y"){
				if(!$("#popCalcPearl").hasClass("form-clicked")){
					$("#popCalcPearl").addClass("form-clicked")
				};
			}else{
				if($("#popCalcPearl").hasClass("form-clicked")){
					$("#popCalcPearl").removeClass("form-clicked")
				};
			};
			
			if(_glbRmgmtPopCalc.sharp7.obj.attr("data-value") != "0"){
				if(!$("#popCalcSharp7").hasClass("form-clicked")){
					$("#popCalcSharp7").addClass("form-clicked")
				};
			}else{
				if($("#popCalcSharp7").hasClass("form-clicked")){
					$("#popCalcSharp7").removeClass("form-clicked")
				};
			};
			
			if(_glbRmgmtPopCalc.rpm.obj.attr("data-value") != "0"){
				if(!$("#popCalcRpm").hasClass("form-clicked")){
					$("#popCalcRpm").addClass("form-clicked")
				};
			}else{
				if($("#popCalcRpm").hasClass("form-clicked")){
					$("#popCalcRpm").removeClass("form-clicked")
				};
			};
			
			if(_glbRmgmtPopCalc.time.obj.attr("data-value") != "0"){
				if(!$("#popCalcTime").hasClass("form-clicked")){
					$("#popCalcTime").addClass("form-clicked")
				};
			}else{
				if($("#popCalcTime").hasClass("form-clicked")){
					$("#popCalcTime").removeClass("form-clicked")
				};
			};
			
			if(_glbRmgmtPopCalc.hgi.obj.attr("data-value") != "00"){
				if(!$("#popCalcHgi").hasClass("form-clicked")){
					$("#popCalcHgi").addClass("form-clicked")
				};
			}else{
				if($("#popCalcHgi").hasClass("form-clicked")){
					$("#popCalcHgi").removeClass("form-clicked")
				};
			};
			
			if(_glbRmgmtPopCalc.group.obj.attr("data-value") != ""){
				if(!$("#popCalcGroup").hasClass("form-clicked")){
					$("#popCalcGroup").addClass("form-clicked")
				};
			}else{
				if($("#popCalcGroup").hasClass("form-clicked")){
					$("#popCalcGroup").removeClass("form-clicked")
				};
			};
			
			
    	}
    	
    	switch(pLoc){
			case "Powder":
			case "Coloring":
			case "Binder":
			case "Pearl":
				
				if(pInit != "Y"){
					if($click.hasClass("form-clicked")){
						$click.val("OFF").attr("data-value", "N").removeClass("form-clicked");
					}else{
						$click.val("ON").attr("data-value", "Y").addClass("form-clicked");
					}
				}
				
				$("#divPopCalcKeypad").find("button").prop("disabled", true);
				break;
				
			case "Hgi":
				
				var code = $click.attr("data-value");
				
				if(code != "" && code != "00"){
					if(!$click.hasClass("form-clicked")){
						$click.addClass("form-clicked")
					};
				}else{
					if($click.hasClass("form-clicked")){
						$click.removeClass("form-clicked")
					};
				};
				
				$("#divPopCalcKeypad").find("button").prop("disabled", true);
				break;
				
				
			case "Group":
				if($click.val() != ""){
					if(!$click.hasClass("form-clicked")){
						$click.addClass("form-clicked")
					};
				}else{
					if($click.hasClass("form-clicked")){
						$click.removeClass("form-clicked")
					};
				};
				
				$("#divPopCalcKeypad").find("button").prop("disabled", true);
				break;
				
			default:
				
				if($click.val() != "0"){
					if(!$click.hasClass("form-clicked")){
						$click.addClass("form-clicked")
					};
				}else{
					if($click.hasClass("form-clicked")){
						$click.removeClass("form-clicked")
					};
				};
			
				$("#divPopCalcKeypad").find("button").prop("disabled", false);
				break;
		}
    	
    	
    	
    	
    	
    	
    }
    
    /***** 팝업의 top 공통코드 show 
    - 공통 코드 및 그리그 show 여부
	*************************/
    function fnVisiblePopTop(pLoc, pInit){
    	$("#txtPopCalsView").val("0");
    	fnClickedPopTop(pLoc, pInit);
    	$("#divPopCalcKeypadComm>div").each(function(index, item){
    		
    		var objId = $(item).attr("id");
    		
    		if(objId == "divPopCalcKeypadComm" + pLoc){
    			$(item).show();
    		}else{
    			$(item).hide();
    		}
    	});
    	
    	if(pLoc == "G" || pLoc == "P" ){
			$("#rmgmtPopCalcTopGrid").show();
    		$("#rmgmtPopCacsTopForm").hide();
    		//$("#divPopCalcKeypadPercent").show();
    		$("#divTxtPopCalsViewArea").show();
    		
    		$("#btnPopCalsPoint1").show();
    		$("#btnPopCalsPoint2").hide();
    		$("#btnPopCalsPercent").hide();
    		
    		if(pLoc == "G"){
    			$("#thPopCalcGridProdtQP").hide();
    			$("#popCalcGridProdtQP").hide();
    			$("#thPopCalcGridProdtQG").show();
    			$("#popCalcGridProdtQG").show();
    		}else{
    			$("#thPopCalcGridProdtQP").show();
    			$("#popCalcGridProdtQP").show();
    			$("#thPopCalcGridProdtQG").hide();
    			$("#popCalcGridProdtQG").hide();
    		}
    		
    		
    		
		}else{
			$("#rmgmtPopCalcTopGrid").hide();
    		$("#rmgmtPopCacsTopForm").show();
    		//$("#divPopCalcKeypadPercent").hide();
    		$("#divTxtPopCalsViewArea").hide();
    		
    		$("#btnPopCalsPoint1").show();
    		$("#btnPopCalsPoint2").hide();
    		$("#btnPopCalsPercent").hide();
    		
    		switch(pLoc){
    			case "Powder":
	    		case "Coloring":
	    		case "Binder":
	    		case "Pearl":
	    		case "Hgi":
	    		case "Group":
	    			$("#divPopCalcKeypad").find("button").prop("disabled", true);
	    			break;
				default:
					$("#divPopCalcKeypad").find("button").prop("disabled", false);
					break;
    		}
    		
		}
    	
    	_glbRmgmtPopCalc.loc = pLoc;
    }
    
    /***** 팝업 open시 
    - Main에서 팝업전역에 셋팅한 데이터를 팝업에 바인딩
	*************************/
    function fnSetPopTop(){
    	
    	$("#popCalcRpm").attr("data-value", _glbRmgmtPopCalc.rpm.value);
    	$("#popCalcTime").attr("data-value", _glbRmgmtPopCalc.time.value);
    	$("#popCalcSharp7").attr("data-value", _glbRmgmtPopCalc.sharp7.value);
    	$("#popCalcPowder").attr("data-value", _glbRmgmtPopCalc.powder.value);
    	$("#popCalcColoring").attr("data-value", _glbRmgmtPopCalc.coloring.value);
    	$("#popCalcBinder").attr("data-value", _glbRmgmtPopCalc.binder.value);
    	$("#popCalcPearl").attr("data-value", _glbRmgmtPopCalc.pearl.value);
    	$("#popCalcHgi").attr("data-value", _glbRmgmtPopCalc.hgi.value);
    	$("#popCalcGroup").attr("data-value", _glbRmgmtPopCalc.group.value);
    	
    	$("#popCalcRpm").val(_glbRmgmtPopCalc.rpm.obj.val());
    	$("#popCalcTime").val(_glbRmgmtPopCalc.time.obj.val());
    	$("#popCalcSharp7").val(_glbRmgmtPopCalc.sharp7.obj.val());
    	$("#popCalcPowder").val(_glbRmgmtPopCalc.powder.obj.val());
    	$("#popCalcColoring").val(_glbRmgmtPopCalc.coloring.obj.val());
    	$("#popCalcBinder").val(_glbRmgmtPopCalc.binder.obj.val());
    	$("#popCalcPearl").val(_glbRmgmtPopCalc.pearl.obj.val());
    	$("#popCalcHgi").val(_glbRmgmtPopCalc.hgi.obj.val());
    	$("#popCalcGroup").val(_glbRmgmtPopCalc.group.obj.val());
    	
    	if(_glbRmgmtPopCalc.loc == "G" || _glbRmgmtPopCalc.loc == "P" ){
    		
    		$("#popCalcGridNo").text(_glbRmgmtPopCalc.no);
    		$("#popCalcGridChildCode").text(_glbRmgmtPopCalc.childCode);
    		$("#popCalcGridChildLotNo").text(_glbRmgmtPopCalc.childLotNo);
    		$("#popCalcGridChildName").text(_glbRmgmtPopCalc.childName);
    		$("#popCalcGridStockUnit").text(_glbRmgmtPopCalc.stockUnit);
    		$("#popCalcGridUnitQ").text(_glbRmgmtPopCalc.unitQ);
    		$("#popCalcGridAllockQ").text(_glbRmgmtPopCalc.allockQ);
    		$("#popCalcGridProdtQG").text(_glbRmgmtPopCalc.prodtQG.value);
    		$("#popCalcGridProdtQP").text(_glbRmgmtPopCalc.prodtQP.value);
    		
    		$("#popCalcGridAllockQ").attr("data-value",_glbRmgmtPopCalc.allockQ);
    		$("#popCalcGridProdtQG").attr("data-value", _glbRmgmtPopCalc.prodtQG.value);
    		$("#popCalcGridProdtQP").attr("data-value", _glbRmgmtPopCalc.prodtQP.value);
    	}
    }
</script>