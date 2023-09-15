trigger CountryTrigger on Country__c (before insert, before update, after update, after insert) {
    System.debug('ng-trigger1');
    if(TriggerStopper.stopCountryTrigger){
        return;
    }
    System.debug('ng-trigger');
    CountryTriggerHandler handler = new CountryTriggerHandler(trigger.new, trigger.oldMap);

    switch on Trigger.operationType {
        when AFTER_INSERT {
            handler.afterInsert();
        }
        when AFTER_UPDATE {
            handler.afterUpdate();
        }
    }
}