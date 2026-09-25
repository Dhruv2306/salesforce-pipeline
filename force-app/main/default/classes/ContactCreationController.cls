
//this is for testing
public with sharing class ContactCreationController {

    @AuraEnabled
    public static Id createContact(Map<String, Object> contactData) {

        if (contactData == null || contactData.isEmpty()) {
            throw new AuraHandledException('No contact data was provided.');
        }

        String firstName  = trimField(contactData.get('firstName'));
        String lastName   = trimField(contactData.get('lastName'));
        String email      = trimField(contactData.get('email'));
        String phone      = trimField(contactData.get('phone'));
        String title      = trimField(contactData.get('title'));
        String department = trimField(contactData.get('department'));

        if (String.isBlank(lastName)) {
            throw new AuraHandledException('Last Name is required to create a Contact.');
        }

        Contact newContact = new Contact(
            FirstName  = firstName,
            LastName   = lastName,
            Email      = email,
            Phone      = phone,
            Title      = title,
            Department = department
        );

        try {
            insert newContact;
        } catch (DmlException dmlEx) {
            throw new AuraHandledException('Unable to create Contact: ' + dmlEx.getMessage());
        }
        System.debug('test it');

        return newContact.Id;
    }

    private static String trimField(Object val) {
        if (val == null) return null;
        String s = String.valueOf(val).trim();
        return String.isBlank(s) ? null : s;
    }

}  
