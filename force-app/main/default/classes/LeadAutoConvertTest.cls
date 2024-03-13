@isTest
private class LeadAutoConvertTest {

    @isTest
    static void testLeadAutoConvert() {
        Lead testLead = new Lead(
            LastName = 'TestLead',
            Company = 'TestCompany',
            Email = 'testlead@example.com'
        );
        insert testLead;

        Account[] accounts = [SELECT Id FROM Account WHERE Name = 'TestCompany'];
        Contact[] contacts = [SELECT Id FROM Contact WHERE LastName = 'TestLead'];

        System.assertEquals(1, accounts.size(), 'Uma conta deveria ter sido criada');
        System.assertEquals(1, contacts.size(), 'Um contato deveria ter sido criado');
    }
}