<cfscript>
  route = cgi.PATH_INFO.replacenocase( '/testapi', '' ).lcase();
  method = cgi.request_method;
  res = {
    "route": route,
    "method": method,
    "params": cgi.QUERY_STRING
  };

  cfheader( name="Content-Type", value="application/json" );
  writeOutput( serializeJSON(res) );
</cfscript>
