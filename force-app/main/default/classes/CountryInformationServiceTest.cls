@IsTest(seealldata=false)
public class CountryInformationServiceTest {

    @IsTest
    static void testSuccessGetCountryInformation(){
        String country = 'peru';
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new CountryInformationServiceMock());
            CountryInformation data = CountryInformationService.getCountryInformation(country);
        Test.stopTest();
        String capital = data.capital.toString() ;
        String languages = data.languages.values().toString();
        String description = data.flags.get('alt');
        String imgflag = data.flags.get('png') ;

        Assert.isTrue(capital.contains('Lima'), 'Capital should contain Lima');
        Assert.isTrue(languages.contains('Aymara, Quechua, Spanish'), 'Languages should contain Aymara, Quechua, Spanish');
        Assert.areNotEqual(null, description, 'Description should not be null');
        Assert.areNotEqual(null, imgflag, 'imgflag should not be null');
    }

    @IsTest
    static void testNotFoundGetCountryInformation(){
        String country = 'peru';
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new CountryInformationServiceMock('notFound'));
            CountryInformation data = CountryInformationService.getCountryInformation(country);
        Test.stopTest();
        Integer status = data.notFoundWrapper.status ;
        String message = data.notFoundWrapper.message;

        Assert.areEqual(404, status, 'Status code should be 404');
        Assert.areEqual('Not Found', message, 'Message should be "Not Found"');
    }

    @IsTest
    static void testExceptionGetCountryInformation(){
        String country = 'peru';
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new CountryInformationServiceMock('exception'));
            CountryInformation data = CountryInformationService.getCountryInformation(country);
        Test.stopTest();
        Assert.areEqual(null, data, 'Data should be null indicating an exception');
    }
}