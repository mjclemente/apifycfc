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
          var actor_request = apify.listActors();
          expect( actor_request.statusCode ).toBe( 200 );
          var raw = actor_request.raw;
          expect( raw.path ).toBe( baseUrl & '/acts' );
          var data = actor_request.data;
          expect( data.data ).toHaveKey( 'items' );
        });

        it("can be listed with modifiers", function(){
          var actor_request = apify.listActors( my = true, limit = 10 );
          expect( actor_request.statusCode ).toBe( 200 );
          var raw = actor_request.raw;
          expect( raw.params ).toBe( 'desc=false&limit=10&my=true&offset=0' );
        });

      });

		});


	}

}
