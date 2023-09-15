@IsTest(seealldata=false)
public class CountryTriggerHandlerTest {
    
    private static Integer numberOfRecords = 100;

    @IsTest
    static void testFilterCountriesWithoutCurrencyInsert(){
        List<Country__c> testCountries = new List<Country__c>();
        for (Integer i = 0; i < numberOfRecords; i++) {
            Country__c country = new Country__c();
            country.Name = 'Country '+i;
            country.Capital__c = 'Capital ' +i;
            country.Languages__c = 'Languages '+i;
            country.Description__c = 'Test description '+i;
            country.Flag_Image__c = 'url img '+i;
            testCountries.add(country);
        }
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new CountryInformationServiceMock());
            insert testCountries;
        Test.stopTest();
        
        List<Country__c> resultCountries = [SELECT Id, Currency__c FROM Country__c];
        Boolean hasCurrency = true;
        for (Country__c oContry : resultCountries) {
            if(oContry.Currency__c == null){
                hasCurrency = false;
                break;
            }
        }
        Assert.areEqual(true, hasCurrency, 'All records should have a currency');
    }

    @IsTest
    static void testFilterCountriesWithoutCurrencyUpdate(){
        TriggerStopper.stopCountryTrigger = true;
        List<Country__c> testCountries = new List<Country__c>();
        for (Integer i = 0; i < numberOfRecords; i++) {
            Country__c country = new Country__c();
            country.Name = 'Country '+i;
            country.Capital__c = 'Capital ' +i;
            country.Languages__c = 'Languages '+i;
            country.Description__c = 'Test description '+i;
            country.Flag_Image__c = 'url img '+i;
            testCountries.add(country);
        }
        insert testCountries;
        Test.startTest();
            TriggerStopper.stopCountryTrigger = false;
            Test.setMock(HttpCalloutMock.class, new CountryInformationServiceMock());
            for (Country__c oContry : testCountries) {
                oContry.Currency__c = null;
            }
            update testCountries;
        Test.stopTest();
        
        List<Country__c> resultCountries = [SELECT Id, Currency__c FROM Country__c];
        Boolean hasCurrency = true;
        for (Country__c oContry : resultCountries) {
            if(oContry.Currency__c == null){
                hasCurrency = false;
                break;
            }
        }
        Assert.areEqual(true, hasCurrency, 'All records should have a currency after the update');
    }
}