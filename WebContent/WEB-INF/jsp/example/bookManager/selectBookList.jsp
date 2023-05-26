<%@page language="java" contentType="text/html; charset=utf-8"%>
<script type="text/javascript">
	
</script>
<table class="panel">
	<colgroup>
		<col width="5%">
		<col width="10%">
		<col width="*">
	</colgroup>
	<thead>
		<tr>
			<th scope="col">ISBN</th>
			<th scope="col">Name</th>
			<th scope="col">Writer</th>
			<th scope="col">Writer</th>
		</tr>
	</thead>
	<tbody>

		<c:forEach var="item" items="${navi.list }">
			<tr>

				<td class="text_align_center">${item.isbn }</td>
				<td title="${item.sndrCrr }"><t:out value="${item.bookName }" bytes="15" /></td>
				<td class="text_align_center"><t:out value="${item.writer}" /></td>
				<td class="text_align_center"><t:out value="${item.price}"  format="int"/></td>

			</tr>
		</c:forEach>
	</tbody>
</table>