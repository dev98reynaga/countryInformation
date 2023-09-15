@IsTest(seealldata=false)
public class CountryInformationControllerTest {
    
    @TestSetup
    static void makeData(){
        TriggerStopper.stopCountryTrigger = true;
        Country__c country = new Country__c();
        country.Name = 'Peru';
        country.Capital__c = 'Lima';
        country.Languages__c = 'Aymara,Quechua,Spanish';
        country.Description__c = 'Test description';
        country.Flag_Image__c = 'url img';
        insert country;
        Account testAccount = new Account();
        testAccount.Name = 'Test Account';
        testAccount.Country__c = 'Peru';
        testAccount.Country_Relation__c = country.Id;
        insert testAccount;
    }

    @IsTest
    static void testInitialData(){
        Account testAcc = [SELECT Id FROM Account WHERE Name = 'Test Account' LIMIT 1];
        Test.startTest();
            Map<String, String> data = CountryInformationController.initialData(testAcc.Id);
        Test.stopTest();
        Assert.areEqual('Peru', data.get('country'), 'Country should be Peru');
        Assert.areEqual('Lima', data.get('capital'), 'Capital should be Lima');
        Assert.areEqual('Aymara,Quechua,Spanish', data.get('languages'), 'Languages should be Aymara, Quechua, Spanish');
        Assert.areEqual('Test description', data.get('description'), 'Description should be Test description');
        Assert.areEqual('url img', data.get('imgflag'), 'Image flag should be url img');
    }

    @IsTest
    static void testGetCountryInformation(){
        String country = 'peru';
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new CountryInformationServiceMock());
            Map<String, String> data = CountryInformationController.getCountryInformation(country);
        Test.stopTest();
        Assert.areEqual('Lima', data.get('capital'), 'Capital should be Lima');
        Assert.areEqual('Aymara,Quechua,Spanish', data.get('languages'), 'Languages should be Aymara, Quechua, Spanish');
        Assert.areNotEqual(null, data.get('description'), 'Description should not be null');
        Assert.areNotEqual(null, data.get('imgflag'), 'imgflag should not be null');
    }

    @IsTest
    static void testGetCountryInformationError(){
        String country = 'peru';
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new CountryInformationServiceMock('notFound'));
            Map<String, String> data = CountryInformationController.getCountryInformation(country);
        Test.stopTest();
        Assert.areEqual('No se pudo recuperar la información del país', data.get('errorMessage'), 'Error message is not as expected');
    }

    @IsTest
    static void testSaveCountry(){
        TriggerStopper.stopCountryTrigger = false;
        Account testAcc = [SELECT Id FROM Account WHERE Name = 'Test Account' LIMIT 1];
        Country__c country = new Country__c();
        country.Name = 'Chile';
        country.Capital__c = 'Santiago';
        country.Languages__c = 'Spanish';
        country.Description__c = 'Test description';
        country.Flag_Image__c = 'url img';

        Test.startTest();
            CountryInformationController.saveCountry(testAcc.Id, country);
        Test.stopTest();
        List<Country__c> newCountry = [SELECT Id FROM Country__c WHERE Name = 'Chile'];
        List<Country__c> countries = [SELECT Id FROM Country__c];
        Assert.areEqual(1, newCountry.size(), 'There should be a new country "chile"');
        Assert.areEqual(2, countries.size(), 'Total number of existing countries should be 2');
    }
}