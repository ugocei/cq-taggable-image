<%@page session="false"%><%--
/*************************************************************************
 *
 * ADOBE CONFIDENTIAL
 * ___________________
 *
 *  Copyright 2013 Adobe Systems Incorporated
 *  All Rights Reserved.
 *
 * NOTICE:  All information contained herein is, and remains
 * the property of Adobe Systems Incorporated and its suppliers,
 * if any.  The intellectual and technical concepts contained
 * herein are proprietary to Adobe Systems Incorporated and its
 * suppliers and are protected by trade secret or copyright law.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Adobe Systems Incorporated.
 **************************************************************************/
--%><%@include file="/libs/foundation/global.jsp"%>
<%@ page contentType="application/json; charset=utf-8" import="
    org.apache.jackrabbit.api.security.user.UserManager,
	org.apache.jackrabbit.api.security.user.Authorizable,
    org.apache.jackrabbit.api.security.user.Query,
    org.apache.jackrabbit.api.security.user.QueryBuilder,
    org.apache.jackrabbit.api.security.user.User,
	org.apache.jackrabbit.api.JackrabbitSession,
	org.apache.sling.jcr.api.SlingRepository,
	javax.jcr.Repository,
	javax.jcr.Session,
	java.util.Iterator"
%>[<%
    final String term = slingRequest.getParameter("term");
	// final Session session = slingRequest.getResourceResolver().adaptTo(Session.class);
	SlingRepository repository = sling.getService(SlingRepository.class);
	final Session session = repository.loginAdministrative(null);
	final JackrabbitSession js = (JackrabbitSession) session;
	final UserManager um = js.getUserManager();
	Iterator<Authorizable> users = um.findAuthorizables(new Query() {
      public  void build(QueryBuilder builder) {
          builder.setCondition(builder.nameMatches(term + "%"));
          builder.setSortOrder("@name", QueryBuilder.Direction.ASCENDING);
          builder.setSelector(User.class);
      }
 	});
	while (users.hasNext()) {
        Authorizable user = users.next();
        String gn = "";
        String fn = "";
        Value[] names = user.getProperty("profile/givenName");
        if (names != null) gn = names[0].getString();
        names = user.getProperty("profile/familyName");
        if (names != null) fn = names[0].getString();
        %> { "id": "<%= user.getPath() %>", "label": "<%= gn %> <%= fn %>", "value": "<%= gn %> <%= fn %>" }<%
        if (users.hasNext()) %>, <%
    }
%>]