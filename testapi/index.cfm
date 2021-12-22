<cfscript>
  route = cgi.PATH_INFO.replacenocase( '/testapi', '' ).lcase();
  method = cgi.request_method;
  res = {
    "route": route,
    "method": method,
    "params": cgi.QUERY_STRING
  };

  if( route.left(4) == '/500' ){
    cfheader( statuscode="500", statustext="Apify Error" );
  }

  cfheader( name="Content-Type", value="application/json" );
  writeOutput( serializeJSON(res) );
</cfscript>
