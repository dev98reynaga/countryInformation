public class CountryInformationService {
    private static External_Apis__mdt setting = External_Apis__mdt.getInstance('CountryInformation');
    
    public static CountryInformation getCountryInformation(String country){
        CountryInformation countryInfo;
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
                
        try {
            String endpoint = setting.Endpoint__c + country;
            req.setHeader('Content-Type', 'application/json');
            req.setEndpoint(endpoint);
            req.setTimeout(120000);
            req.setMethod('GET');
            res = h.send(req); 
            if(res.getStatusCode() == 200){
                List<CountryInformation> result = (List<CountryInformation>)JSON.deserialize(res.getBody(), List<CountryInformation>.class);
                countryInfo = result[0];
            }else if(res.getStatusCode() == 404){
                countryInfo = new CountryInformation();
                CountryInformation.NotFoundWrapper result = (CountryInformation.NotFoundWrapper)JSON.deserialize(res.getBody(), CountryInformation.NotFoundWrapper.class);
                countryInfo.notFoundWrapper = result;
            }
        } catch (exception e) {
            System.debug('error - '+ e.getMessage());
        } 
        return countryInfo;
    }
}