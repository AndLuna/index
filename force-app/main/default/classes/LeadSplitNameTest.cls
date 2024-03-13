@isTest
private class LeadSplitNameTest {

    @isTest
    static void testLeadSplitName() {
        Lead testLead = new Lead(
            LeadSource = 'Website',
            LastName = 'Andre Luna',
            Company = 'TestCompany',
            Email = 'testlead@example.com'
        );
        insert testLead;

        Test.startTest();
        LeadSplitName.assignLeads(new List<Id>{testLead.Id});
        Test.stopTest();
        testLead = [SELECT Id, FirstName, LastName FROM Lead WHERE Id = :testLead.Id LIMIT 1];

        System.assertEquals('Andre', testLead.FirstName, 'O sobrenome deve ser dividido corretamente em nome e sobrenome');
        System.assertEquals('Luna', testLead.LastName, 'O sobrenome deve ser dividido corretamente em nome e sobrenome');
    }
}