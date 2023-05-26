<%@page language="java" contentType="text/html; charset=utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<jsp:include page="/WEB-INF/jsp/com/include/admin_header.jsp" flush="true"/>
<h2>그룹 타이틀</h2>
<!-- group title -->

<!-- description list area -->
<ul class="descriptList">
	<li>이용안내 공간 : 해당 메뉴 또는 페이지의 설명과 조건 및 기능 등을 나열한다.</li>
	<li>이용안내 공간 : 해당 메뉴 또는 페이지의 설명과 조건 및 기능 등을 나열한다.</li>
</ul>
<!--//description list area -->

<!-- search area -->
<div class="searchArea">
	<table summary="write table summary">
		<caption>write table caption</caption>
		<colgroup>
			<col width="8%" />
			<col width="25%" />
			<col width="8%" />
			<col width="25%" />
			<col width="8%" />
			<col width="26%" />
		</colgroup>
		<tbody>
			<tr>
				<th scope="row"><label for="">교육주관</label>
				</th>
				<td><select id="" style="width: 100%;">
						<option></option>
						<option></option>
						<option></option>
						<option></option>
				</select></td>
				<th scope="row"><label for="">연도</label>
				</th>
				<td><select id="" style="width: 100%;">
						<option></option>
						<option></option>
						<option></option>
						<option></option>
				</select></td>
				<th scope="row"><label for="">연도</label>
				</th>
				<td><select id="" style="width: 100%;">
						<option></option>
						<option></option>
						<option></option>
						<option></option>
				</select></td>
			</tr>
			<tr>
				<th scope="row"><label for="">과정</label>
				</th>
				<td><select id="" style="width: 100%;">
						<option></option>
						<option></option>
						<option></option>
						<option></option>
				</select></td>
				<th scope="row"><label for="">과목</label>
				</th>
				<td><select id="" style="width: 100%;">
						<option></option>
						<option></option>
						<option></option>
						<option></option>
				</select></td>
				<th scope="row"><label for="">과목</label>
				</th>
				<td><select id="" style="width: 100%;">
						<option></option>
						<option></option>
						<option></option>
						<option></option>
				</select></td>
			</tr>
		</tbody>
	</table>

	<!-- search button -->
	<div class="btnArea">
		<div class="right">
			<a href="#" class="btnAB iconSearch"><dfn>
					<em><span>search</span>
					</em>
				</dfn>
			</a>
		</div>
	</div>
	<!--//search button -->

</div>
<!--//search area -->

<!-- tabMenu -->
<div class="tabMenu">
	<ul>
		<li class="on"><a href="List.html"><dfn>
					<span>tab menu 1</span>
				</dfn>
		</a>
		</li>
		<!-- current tab : add class "on" -->
		<li><a href="List.html"><dfn>
					<span>tab menu 2</span>
				</dfn>
		</a>
		</li>
		<li><a href="List.html"><dfn>
					<span>tab menu 3</span>
				</dfn>
		</a>
		</li>
		<li><a href="List.html"><dfn>
					<span>tab menu 4</span>
				</dfn>
		</a>
		</li>
	</ul>
</div>
<!--//tabMenu -->

<!-- button area -->
<div class="btnArea">
	<div class="leftFloat">
		<a href="#" class="btnA iconXls"><dfn>
				<em><span>엑셀다운</span>
				</em>
			</dfn>
		</a> <a href="#" class="btnA iconPrint"><dfn>
				<em><span>출력</span>
				</em>
			</dfn>
		</a> <a href="#" class="btnA iconSms"><dfn>
				<em><span>SMS</span>
				</em>
			</dfn>
		</a> <a href="#" class="btnA iconEmail"><dfn>
				<em><span>Email</span>
				</em>
			</dfn>
		</a>
	</div>
	<div class="rightFloat">
		<a href="#" class="btnB"><dfn>
				<em><span>인사데이터업데이트</span>
				</em>
			</dfn>
		</a> <a href="#" class="btnB"><dfn>
				<em><span>연수생등록</span>
				</em>
			</dfn>
		</a> <a href="#" class="btnB"><dfn>
				<em><span>연수생일괄등록</span>
				</em>
			</dfn>
		</a>
	</div>
</div>
<!--//button area -->

<!-- grid area-->
<div class="gridArea">
	<div style="height: 300px; padding-top: 200px; text-align: center; border: 1px solid #ddd; background: #F9FCFC;">DATA AREA</div>
</div>
<!--//grid area -->
<jsp:include page="/WEB-INF/jsp/com/include/admin_footer.jsp" flush="true"/>