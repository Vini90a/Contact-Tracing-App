trigger CTPersonTrigger on Person__c (before insert, before update) {
    switch on Trigger.operationType {
        when BEFORE_INSERT {
            CTPersonTriggerHandle.beforeInsertHandle(Trigger.new);
        }
        when BEFORE_UPDATE {
            CTPersonTriggerHandle.beforeUpdateHandle(Trigger.new, Trigger.oldMap);
        }
    }

}