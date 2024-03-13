public class LeadSplitName {
/*
    @InvocableMethod
    public static void assignLeads(List<Id> LeadIds){

        // Ajuste aqui: O código original tentava selecionar um Lead sem especificar um ID.
        // Removido para evitar erros.

        List<Lead> leadsToUpdate = new List<Lead>();
        
        for(Id currentLeadId : LeadIds){
            // Carrega o Lead específico com base no ID fornecido
            Lead lead = [SELECT Id, FirstName, LastName FROM Lead WHERE Id = :currentLeadId LIMIT 1];

            if (lead.LastName.contains(' ') and lead.LeadSource = 'WebSite') {
                // Divide o nome completo em partes
                List<String> nameParts = lead.LastName.split(' ');
                
                // Define o primeiro nome como a primeira parte do nome completo
                lead.FirstName = nameParts[0];
                
                // Remove o primeiro nome da lista de partes do nome
                nameParts.remove(0);
                
                // Junta as partes restantes do nome e atribui ao LastName
                lead.LastName = String.join(nameParts, ' ');
                
                // Adiciona o Lead atualizado à lista para atualização
                leadsToUpdate.add(lead);
            }
        }

        // Atualiza todos os Leads em massa
        if(!leadsToUpdate.isEmpty()){
            update leadsToUpdate;
        }
    }*/
}