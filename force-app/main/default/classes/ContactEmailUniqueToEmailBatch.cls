/**
 * @description       : 
 * @author            : André Galvinas
 * @group             : 
 * @last modified on  : 02-20-2024
 * @last modified by  : André Galvinas
**/
public with sharing class ContactEmailUniqueToEmailBatch implements Database.Batchable<SObject> {

    public ContactEmailUniqueToEmailBatch() {

    }

    public Database.querylocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator('SELECT Id, Email, EmailUnico__c FROM Contact');
    }

    public void execute(Database.BatchableContext BC, List<sObject> scope){
        for(Contact cnt : (List<Contact>)scope){
            if(cnt.EmailUnico__c == null){
                continue;
            }
            if(cnt.Email != null){
                if(cnt.Email != cnt.EmailUnico__c){
                    cnt.Email = cnt.EmailUnico__c;
                }
            }else{
                cnt.Email = cnt.EmailUnico__c;
            }
        }
        
        update scope;
    }

    public void finish(Database.BatchableContext BC) {

    }

}