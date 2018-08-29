<% if(!_logged){ %>
	<form method="post" action="">
		<table>
			<tr>
				<td class="tdCellLeft">
					<h1>Login is required to continue</h1>
					<div class="field"><span>User:</span> <input type="text" name="_secToolsLogin" autocomplete="off"></div>
					<div class="field"><span>Password:</span> <input type="password" name="_secToolsPassword" autocomplete="off"></div>
					<div class="field"><span>&nbsp;</span><input type="submit" value="Login"></div>
				</td>
				<td class="tdCellRight">
					<p class="ieWarning" id="ieWarning">You are using Internet Explorer, experience may not be as desire.</p>
					<p class="disclaimer"><b>Apia 3.0 Tools</b> has been developed by STATUM for internal and support usage, it is not included as part of the <b>Apia</b> installation.</p>
				</td>
			</tr>
		</table>
	</form>
<% } %>