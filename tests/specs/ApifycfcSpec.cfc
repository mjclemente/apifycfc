component extends="testbox.system.BaseSpec"{

/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll(){
    inspectTemplates();
    apify = new apify();
	}

	function afterAll(){
	}

/*********************************** BDD SUITES ***********************************/

	function run(){
		describe( "A spec", function(){

			beforeEach(function(){
			});

			afterEach(function(){
			});

			it("can be init", function(){
				expect( apify ).toBeInstanceOf( 'apify' );
			});

		});


	}

}
