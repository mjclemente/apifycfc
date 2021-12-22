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

  if( route.left(4) == '/429' ){
    cfheader( statuscode="429", statustext="Too Many Requests" );
  }

  cfheader( name="Content-Type", value="application/json" );
  writeOutput( serializeJSON(res) );
</cfscript>
