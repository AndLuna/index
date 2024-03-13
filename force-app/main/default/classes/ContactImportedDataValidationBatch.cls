/**
 * @description       : 
 * @author            : André Galvinas
 * @group             : 
 * @last modified on  : 02-29-2024
 * @last modified by  : André Galvinas
**/
public with sharing class ContactImportedDataValidationBatch implements Database.Batchable<sObject> {

public class PhoneData {
    public String country;
    public Integer phoneNumberLengthByCountry_phLengthMax;
    public Integer phoneNumberLengthByCountry_phLengthMin;
    //public String phoneNumberLengthByCountry_phLength;
    public String phoneNumberLengthByCountry_CountryCode;
    //public Decimal phoneNumberLengthByCountry_phLength_InternationalPrefix;
    //public Integer phoneNumberLengthByCountry_phLength_NationalPrefix;
    //public String phoneNumberLengthByCountry_Notes;
}

public static List<PhoneData> phoneDataList {get{
    if(phoneDataList == null){
        phoneDataList = new List<PhoneData>();
        ContactNumberValidationHelper__mdt cnvh = [SELECT Data__c FROM ContactNumberValidationHelper__mdt WHERE DeveloperName = 'JsonString' LIMIT 1];

        phoneDataList = (List<PhoneData>)JSON.deserialize(cnvh.Data__c, List<PhoneData>.class);
        for(PhoneData pd : phoneDataList){
            switch on pd.country {
                when 'South Africa' {pd.country = 'África do Sul'; }
                when 'Germany' {pd.country = 'Alemanha'; }
                when 'Saudi Arabia' {pd.country = 'Arábia Saudita'; }
                when 'Armenia' {pd.country = 'Arménia'; }
                when 'Australia' {pd.country = 'Austrália'; }
                when'Austria' {pd.country = 'Áustria'; }
                when 'Belgium' {pd.country = 'Bélgica'; }
                when 'Croatia' {pd.country = 'Croácia'; }
                when 'Denmark' {pd.country = 'Dinamarca'; }
                when 'United Arab Emirates' {pd.country = 'Emirados Árabes Unidos'; }
                when 'Slovakia' {pd.country = 'Eslovaquia'; }
                when 'Slovenia' {pd.country = 'Eslovénia'; }
                when 'Spain' {pd.country = 'Espanha'; }
                when 'United States' {pd.country = 'Estados Unidos'; }
                when 'Finland' {pd.country = 'Finlândia'; }
                when 'France' {pd.country = 'França'; }
                when 'Gibraltar' {pd.country = 'Gibraltar'; }
                when 'Greece' {pd.country = 'Grécia'; }
                when 'Ireland' {pd.country = 'Irlanda'; }
                when 'Iceland' {pd.country = 'Islândia'; }
                when 'Italy' {pd.country = 'Itália'; }
                when 'Lebanon' {pd.country = 'Libano'; }
                when 'Luxembourg' {pd.country = 'Luxemburgo'; }
                when 'Malaysia' {pd.country = 'Malásia'; }
                when 'Maldives' {pd.country = 'Maldivas'; }
                when 'Morocco' {pd.country = 'Marrocos'; }
                when 'Mexico' {pd.country = 'México'; }
                when 'Nigeria' {pd.country = 'Nigéria'; }
                when 'Norway' {pd.country = 'Noruega'; }
                when 'New Zealand' {pd.country = 'Nova Zelândia'; }
                when 'Netherlands' {pd.country = 'Países Baixos'; }
                when 'Poland' {pd.country = 'Polónia'; }
                when 'United Kingdom'{pd.country = 'Reino Unido'; }
                when 'Russia' {pd.country = 'Rússia'; }
                when 'San Marino' {pd.country = 'São Martinho'; }
                when 'Seychelles' {pd.country = 'Seicheles'; }
                when 'Singapore' {pd.country = 'Singapura'; }
                when 'Sweden' {pd.country = 'Suécia'; }
                when 'Switzerland' {pd.country = 'Suiça'; }
                when 'Thailand' {pd.country = 'Tailândia'; }
                when 'Ivory Coast' {pd.country = 'The Republic of Côte d\'Ivoire'; }
                when 'Turkey' {pd.country = 'Turquia'; }
                when 'Uruguay' {pd.country = 'Uruguai'; }
                when else{}
            }
        }
        //System.debug('phoneDataList: ' + phoneDataList);
    }
    return phoneDataList;
} set;}
public static Set<String> emailSet = new Set<String>();

public ContactImportedDataValidationBatch() {
    
}

public Database.querylocator start(Database.BatchableContext BC) {
    return Database.getQueryLocator('SELECT Id, FirstName, LastName, Email, PotencialInvalidEmail__c, PotencialInvalidPhone__c, PotencialInvalidMobilePhone__c, ImportedEmail__c, ImportedMobilePhone__c, ImportedPhone__c, MailingCountry, DuplicateEmail__c, CalculatedCountryIndicatif__c, Phone, MobilePhone FROM Contact');
}

public void execute(Database.BatchableContext BC, List<sObject> scope){

    for(Contact ct : [SELECT Email FROM Contact WHERE Email != '' AND Email != null]){
        emailSet.add(ct.Email);
    }

    for(Contact cnt : (List<Contact>)scope){

        cnt.FirstName = cnt.FirstName?.toLowerCase().capitalize();
        cnt.LastName = cnt.LastName.toLowerCase().capitalize();
        cnt.Phone = normalizePhoneNumber(cnt.ImportedPhone__c);
        cnt.MobilePhone = normalizePhoneNumber(cnt.ImportedMobilePhone__c);
        cnt.PotencialInvalidEmail__c = false;
        cnt.DuplicateEmail__c = false;
        cnt.PotencialInvalidPhone__c = false;
        cnt.PotencialInvalidMobilePhone__c = false;

        System.debug('Inicial Contact Data - ImportedEmail__c: ' + cnt.ImportedEmail__c + ', ImportedPhone__c: ' + cnt.ImportedPhone__c + ', ImportedMobilePhone__c: ' + cnt.ImportedMobilePhone__c + ', MailingCountry: ' + cnt.MailingCountry);
        if(!validateEmail(cnt.ImportedEmail__c)){
            cnt.PotencialInvalidEmail__c = true;
        }else{
            cnt.Email = cnt.ImportedEmail__c;
        }
        if(cnt.Email != null){
            if(emailSet.contains(cnt.Email)){
                cnt.DuplicateEmail__c = true;
            }else{
                emailSet.add(cnt.Email);
            }
        }
        
        if(!validatePhone(cnt.MailingCountry?.trim(), cnt.Phone, cnt)){
            cnt.PotencialInvalidPhone__c = true;
        }
        if(!validatePhone(cnt.MailingCountry?.trim(), cnt.MobilePhone, cnt)){
            cnt.PotencialInvalidMobilePhone__c = true;
        }

    }
    
    update scope;
}

public static Boolean validateEmail(String email) {
    if (String.isBlank(email)){
        return true;
    }
    String inputString = email;
    String emailRegex = '^[a-zA-Z0-9!#$%&\'*+/=?^_`{|}~-]+(?:\\.[a-zA-Z0-9!#$%&\'*+/=?^_`{|}~-]+)*@(?:[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?\\.)+[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$';
    Pattern emailPattern = Pattern.compile(emailRegex);
    Matcher emailMatcher = emailPattern.matcher(InputString);

    if (!emailMatcher.matches()) {
        return false;
    } else {
        return true;
    }
}

public static Boolean validatePhone(String country, String phoneNumber, Contact cnt) {
    if (String.isBlank(phoneNumber)){
        return true;
    }
    if(String.isBlank(country)){
        return false;
    }
    for(PhoneData pd : phoneDataList){
        if(pd.country == country){
            if(phoneNumber.startsWith(pd.phoneNumberLengthByCountry_CountryCode)){
                Integer phLength = phoneNumber.replace(pd.phoneNumberLengthByCountry_CountryCode, '').length();
                if(phoneNumber.isNumeric() && phLength >= pd.phoneNumberLengthByCountry_phLengthMin && phLength <= pd.phoneNumberLengthByCountry_phLengthMax){
                    cnt.CalculatedCountryIndicatif__c = pd.phoneNumberLengthByCountry_CountryCode;
                    return true;
                }
            }else{
                if(phoneNumber.isNumeric() && phoneNumber.length() >= pd.phoneNumberLengthByCountry_phLengthMin && phoneNumber.length() <= pd.phoneNumberLengthByCountry_phLengthMax){
                    cnt.CalculatedCountryIndicatif__c = pd.phoneNumberLengthByCountry_CountryCode;
                    return true;
                }
            }
        }
    }
    return false;
}

public static String normalizePhoneNumber(String phoneNumber) {
    if (String.isBlank(phoneNumber)){
        return null;
    }
    String normalizedNumber = phoneNumber.trim().replace(' ', '').replace('\'', '');
    if (normalizedNumber.startsWith('+')) {
        normalizedNumber = normalizedNumber.replace('+', '');
    }
    if (normalizedNumber.startsWith('00')) {
        normalizedNumber = normalizedNumber.replace('00', '');
    }
    
    return normalizedNumber;
}

public void finish(Database.BatchableContext BC) {

}

}