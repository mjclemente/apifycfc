<cfscript>
  route = cgi.PATH_INFO.replacenocase( '/testapi', '' ).lcase();
  method = cgi.request_method;

  cfheader( name="Content-Type", value="application/json" );

  if( route == '/acts' ){

    if( method == 'GET' ){
      writeOutput( '{ "data": { "total": 1, "count": 1, "offset": 0, "limit": 1000, "desc": false, "items": [ { "id": "xxx", "createdAt": "2021-12-06T16:18:32.192Z", "modifiedAt": "2021-12-16T19:23:27.247Z", "name": "apify-xxx-test", "username": "xxx" } ] } }' );
    }

  }
  // writeOutput( serializeJson({ 'test': 1 }) );
</cfscript>
