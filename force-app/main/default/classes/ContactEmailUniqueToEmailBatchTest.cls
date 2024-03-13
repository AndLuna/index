/**
 * @description       : 
 * @author            : André Galvinas
 * @group             : 
 * @last modified on  : 02-20-2024
 * @last modified by  : André Galvinas
**/
@IsTest
public with sharing class ContactEmailUniqueToEmailBatchTest {

    @TestSetup
    static void makeData(){
        Contact cnt = new Contact(
            LastName = 'Test',
            EmailUnico__c = 'a@a.com',
            Email = ''
        );

        insert cnt;

        Contact cnt2 = new Contact(
            LastName = 'Test 2',
            EmailUnico__c = 'b@b.com',
            Email = 'c@c.com'
        );

        insert cnt2;

        Contact cnt3 = new Contact(
            LastName = 'Test 3',
            EmailUnico__c = '',
            Email = 'd@d.com'
        );

        insert cnt3;

    }

    @IsTest
    static void testEmailUniqueToEmail(){
        
        Test.startTest();
        Database.executeBatch(new ContactEmailUniqueToEmailBatch());
        Test.stopTest();

        Contact cnt = [SELECT Id, Email, EmailUnico__c FROM Contact WHERE LastName = 'Test' LIMIT 1];
        Assert.areEqual(cnt.EmailUnico__c, cnt.Email);

        Contact cnt2 = [SELECT Id, Email, EmailUnico__c FROM Contact WHERE LastName = 'Test 2' LIMIT 1];
        Assert.areEqual(cnt2.EmailUnico__c, cnt2.Email);

        Contact cnt3 = [SELECT Id, Email, EmailUnico__c FROM Contact WHERE LastName = 'Test 3' LIMIT 1];
        Assert.areEqual('d@d.com', cnt3.Email);

    }
}