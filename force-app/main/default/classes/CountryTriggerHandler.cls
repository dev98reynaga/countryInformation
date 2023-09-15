public without sharing class CountryTriggerHandler {

    private List<Country__c> countries;
    private Map<Id, Country__c> oldMap;

    public CountryTriggerHandler(List<Country__c> countries, Map<Id, Country__c> oldMap){
        this.countries = countries;
        this.oldMap = oldMap;
    }

    public void afterInsert(){
        filterCountriesWithoutCurrency();
    }

    public void afterUpdate(){
        filterCountriesWithoutCurrency();
    }

    public void filterCountriesWithoutCurrency(){
        List<Country__c> listCountry = new List<Country__c>();
        for (Country__c oCountry : this.countries) {
            if(this.oldMap == null || oCountry.Currency__c == null){
                listCountry.add(oCountry);
            }
        }
        if(listCountry.size() > 0){
            updateCurrency(listCountry);
        }
    }

    private void updateCurrency(List<Country__c> listCountries){
        try {
            
            for (List<Country__c> lstCountry : SObjectListHelper.splitRecordList(listCountries)) {
                string serializedCountries = JSON.serialize(lstCountry);
                //We send small blocks to the future method in order not to exceed the callout limits.  
                updateCurrencyFuture(serializedCountries);
            }
        } catch(Exception e) {
            System.debug(e.getMessage());
        }
    }

    @future(callout=true)
    private static void updateCurrencyFuture(string serializedCountries){
        List<Country__c> listCountryToUpdate = new List<Country__c>();
        try {
            List<Country__c> countries =(List<Country__c>)JSON.deserialize(serializedCountries, List<Country__c>.class);
            //We are certain that the countries list does not exceed 100 records and thus not hit the callout limits.
            for (Country__c oCountry : countries) {
                CountryInformation countryInfo = CountryInformationService.getCountryInformation(oCountry.Name);
                List<String> currencyNames = new List<String>();
                if(countryInfo != null){
                    Country__c objCountry = new Country__c();
                    objCountry.Id = oCountry.Id;
                    objCountry.Name = oCountry.Name;
                    //A for loop is added here because there are not many currencies per country.
                    for (CountryInformation.CurrencyInfo objCurrency : countryInfo.currencies.values()) {
                        currencyNames.add(objCurrency.name);
                    }
                    objCountry.Currency__c = String.join(currencyNames, ',');
                    listCountryToUpdate.add(objCountry);
                }
            }
            if(listCountryToUpdate.size() > 0){
                upsert listCountryToUpdate Name;
            }
            
        } catch(Exception e) {
            System.debug(e.getMessage());
        }
        
    }   

}