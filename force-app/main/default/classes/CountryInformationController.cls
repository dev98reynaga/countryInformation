public with sharing class CountryInformationController {

    @AuraEnabled(cacheable=true)
    public static Map<String, String> initialData(Id recordId){
        Map<String, String> mapResponse = new Map<String, String>();
        Account objAccount = [SELECT Id, Country__c, Country_Relation__r.Capital__c, Country_Relation__r.Languages__c,  Country_Relation__r.Description__c, 
                            Country_Relation__r.Flag_Image__c FROM Account WHERE Id =: recordId LIMIT 1];

        if(!String.isEmpty(objAccount.Country__c)) {
        mapResponse.put('country', objAccount.Country__c);
        mapResponse.putAll(buildCountryResponse(
            objAccount.Country_Relation__r.Capital__c,
            objAccount.Country_Relation__r.Languages__c, 
            objAccount.Country_Relation__r.Description__c,
            objAccount.Country_Relation__r.Flag_Image__c
        ));
    }
        return mapResponse;
    }

    @AuraEnabled(cacheable=true)
    public static Map<String, String> getCountryInformation(String country){
        Map<String, String> response = new  Map<String, String>();
        country = country.toLowerCase();
        CountryInformation countryInfo = CountryInformationService.getCountryInformation(country);
        if(countryInfo != null && countryInfo.notFoundWrapper == null){
            response.putAll(buildCountryResponse(
                String.join(countryInfo.capital, ','),
                String.join(countryInfo.languages.values(), ','),
                countryInfo.flags.get('alt'),
                countryInfo.flags.get('png')
            ));
            return response;
        }
        response.put('errorMessage', 'No se pudo recuperar la información del país');
        return response;
    }

    private static Map<String, String> buildCountryResponse(String capital, String languages, String description, String imgflag) {
        Map<String, String> response = new Map<String, String>();
        response.put('capital', capital);
        response.put('languages', languages);
        response.put('description', description);
        response.put('imgflag', imgflag);
        return response;
    }

    @AuraEnabled
    public static void saveCountry(Id accountId, Country__c objCountry){
        try {
            upsert objCountry Name;
            Account accToUpdate = new Account();
            accToUpdate.Id = accountId;
            accToUpdate.Country_Relation__c = objCountry.Id;
            accToUpdate.Country__c = objCountry.Name;
            update accToUpdate;
        } catch(Exception e) {
            System.debug('Error - '+e.getMessage());
        }
    }
}