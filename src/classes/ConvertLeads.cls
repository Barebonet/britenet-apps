/**
 * Created by bartosz.rozpara on 02.01.2023.
 */

public with sharing class ConvertLeads {
    @InvocableMethod
    public static void assignLeads(List<Id> LeadIds){
        LeadStatus cLeadStatus = [SELECT Id,MasterLabel FROM LeadStatus WHERE isConverted = true LIMIT 1];
        List<Database.LeadConvert> massLeadConvert = new List<Database.LeadConvert>();
        for(Id currentLead:LeadIds){
            Database.LeadConvert LeadConvert = new Database.LeadConvert();
            LeadConvert.setLeadId(currentLead);
            LeadConvert.setConvertedStatus(cLeadStatus.MasterLabel);
            massLeadConvert.add(LeadConvert);
        }
        if(!massLeadConvert.isEmpty()){
            List<Database.LeadConvertResult> lcr = Database.convertLead(massLeadConvert);
        }
    }
}