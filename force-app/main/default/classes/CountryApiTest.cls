@IsTest(seealldata=false)
private class CountryApiTest {

    @isTest
    static void testGetCountries() {
        List<Country__c> countries = new List<Country__c>();
        countries.add(new Country__c(Name = 'Country 1', Capital__c = 'Capital 1', Currency__c = 'Currency 1', Description__c = 'Description 1', Flag_Image__c = 'Flag 1', Languages__c = 'Language 1'));
        countries.add(new Country__c(Name = 'Country 2', Capital__c = 'Capital 2', Currency__c = 'Currency 2', Description__c = 'Description 2', Flag_Image__c = 'Flag 2', Languages__c = 'Language 2'));
        insert countries;
        Test.startTest();
            RestResponse restResponse = new RestResponse();
            RestContext.response = restResponse;
            CountryApi.getCountries();
        Test.stopTest();

        List<CountryApi.CountryInfo> result = (List<CountryApi.CountryInfo>)JSON.deserialize(
            restResponse.responseBody.toString(),
            List<CountryApi.CountryInfo>.class
        );

        Assert.areEqual(2, result.size(), 'Number of countries retrieved should be 2');
        Assert.areEqual(200, restResponse.statusCode, 'HTTP status code should be 200 (OK)');
    }
}