component extends="testbox.system.BaseSpec"{

/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll(){
    inspectTemplates();
    baseUrl = 'http://127.0.0.1:52558/testapi';
    apify = new apify( baseUrl = baseUrl, includeRaw = true );
	}

	function afterAll(){
	}

/*********************************** BDD SUITES ***********************************/

	function run(){
		describe( "The Apify API wrapper", function(){

			beforeEach(function(){
			});

			afterEach(function(){
			});

			it("can be init", function(){
				expect( apify ).toBeInstanceOf( 'apify' );
			});

      describe( "The actors", function(){

        it("can be listed", function(){
          var apify_request = apify.listActors( my = true, limit = 10 );
          expect( apify_request.statusCode ).toBe( 200 );
          var raw = apify_request.raw;
          expect( raw.path ).toBe( baseUrl & '/acts' );
          expect( raw.params ).toBe( 'desc=false&limit=10&my=true&offset=0' );
          var data = apify_request.data;
          expect( data.data ).toHaveKey( 'items' );
        });

      });

      describe( "The actor tasks", function(){

        it("can be listed", function(){
          var apify_request = apify.listActorTasks( limit = 10 );
          expect( apify_request.statusCode ).toBe( 200 );
          var raw = apify_request.raw;
          expect( raw.path ).toBe( baseUrl & '/actor-tasks' );
          expect( raw.params ).toBe( 'desc=false&limit=10&offset=0' );
          var data = apify_request.data;
          expect( data.data ).toHaveKey( 'items' );
          expect( data.data.items.len() ).toBeLT( 11 );
        });

      });

		});


	}

}
