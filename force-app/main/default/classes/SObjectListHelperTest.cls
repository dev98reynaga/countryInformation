@IsTest(seealldata=false)
public class SObjectListHelperTest {

    @IsTest
    static void testExactSplitRecordList(){
        List<Country__c> testCountries = new List<Country__c>();
        for (Integer i = 0; i < 200; i++) {
            Country__c country = new Country__c();
            country.Name = 'Country '+i;
            country.Capital__c = 'Capital ' +i;
            country.Languages__c = 'Languages '+i;
            country.Description__c = 'Test description '+i;
            country.Flag_Image__c = 'url img '+i;
            testCountries.add(country);
        }

        Test.startTest();
            List<List<SObject>> result = SObjectListHelper.splitRecordList(testCountries);
        Test.stopTest();
        
        Assert.areEqual(4, result.size(), 'Expected 4 sublists after splitting');
    }

    @IsTest
    static void testNotExactSplitRecordList(){
        List<Country__c> testCountries = new List<Country__c>();
        for (Integer i = 0; i < 101; i++) {
            Country__c country = new Country__c();
            country.Name = 'Country '+i;
            country.Capital__c = 'Capital ' +i;
            country.Languages__c = 'Languages '+i;
            country.Description__c = 'Test description '+i;
            country.Flag_Image__c = 'url img '+i;
            testCountries.add(country);
        }

        Test.startTest();
            List<List<SObject>> result = SObjectListHelper.splitRecordList(testCountries);
        Test.stopTest();
        
        Assert.areEqual(3, result.size(), 'Expected 3 sublists after splitting');
    }
}