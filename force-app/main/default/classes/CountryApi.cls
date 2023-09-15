@RestResource(urlMapping='/v1/country/*')
global with sharing class CountryApi {
    
    @HttpGet
    global static void getCountries(){
        RestResponse res = RestContext.response;
        List<Country__c> countries = [SELECT Id, Name, Capital__c, Currency__c, Description__c, Flag_Image__c, Languages__c FROM Country__c];
        List<CountryInfo> countryInfoList = new List<CountryInfo>();
        for (Country__c country : countries) {
            countryInfoList.add(new CountryInfo(country));
        }
        String serializeResponse = JSON.serialize(countryInfoList);
        res.statusCode = 200;
        res.addHeader('Content-Type', 'application/json');
        res.responseBody = Blob.valueOf(serializeResponse);
    }

    global class CountryInfo {
        public String id;
        public String name;
        public String capital;
        public String currencyName;
        public String description;
        public String urlImage;
        public String languages;
        
        CountryInfo(Country__c country) {
            this.id = country.Id;
            this.name = country.Name;
            this.capital = country.Capital__c;
            this.currencyName = country.Currency__c;
            this.description = country.Description__c;
            this.urlImage = country.Flag_Image__c;
            this.languages = country.Languages__c;
        }
    }
}