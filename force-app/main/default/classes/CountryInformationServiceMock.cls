@isTest
public class CountryInformationServiceMock implements HttpCalloutMock {
    private String responseType;

    public CountryInformationServiceMock(){
        this.responseType = 'success';
    }

    public CountryInformationServiceMock(string type){
        this.responseType = type;
    }
    public HTTPResponse respond(HTTPRequest req) { 
        HttpResponse res = new HttpResponse();
        String endpoint = req.getEndpoint();
        if(responseType == 'exception'){
            throw new CalloutException('Exception');
        }
        switch on responseType {
            when 'notFound' {
                if(endpoint.contains('restcountries.com/v3.1/name/')){
                    res.setHeader('Content-Type', 'application/json');
                    res.setBody('{"status": 404, "message": "Not Found"}');
                    res.setStatusCode(404);
                }
            }
            when 'success' {
                if(endpoint.contains('restcountries.com/v3.1/name/')){
                    res.setHeader('Content-Type', 'application/json');
                    res.setBody(countryInformationResponse());
                    res.setStatusCode(200);
                }
            }
        }
        return res;
    }

    private static String countryInformationResponse(){
        String jsonString = '['+
                                '{'+
                                    '"currencies": {'+
                                        '"PEN": {'+
                                            '"name": "Peruvian sol",'+
                                            '"symbol": "S/ "'+
                                        '}'+
                                    '},'+
                                    '"capital": ['+
                                        '"Lima"'+
                                    '],'+
                                    '"altSpellings": ['+
                                        '"PE",'+
                                        '"Republic of Peru",'+
                                        '"República del Perú"'+
                                    '],'+
                                    '"region": "Americas",'+
                                    '"subregion": "South America",'+
                                    '"languages": {'+
                                        '"aym": "Aymara",'+
                                        '"que": "Quechua",'+
                                        '"spa": "Spanish"'+
                                    '},'+
                                    '"flag": "🇵🇪",'+
                                    '"timezones": ['+
                                        '"UTC-05:00"'+
                                    '],'+
                                    '"flags": {'+
                                        '"png": "https://flagcdn.com/w320/pe.png",'+
                                        '"svg": "https://flagcdn.com/pe.svg",'+
                                        '"alt": "The flag of Peru is composed of three equal vertical bands of red, white and red, with the national emblem centered in the white band."'+
                                    '}'+
                                '}'+
                            ']';
        return jsonString;
    }

}